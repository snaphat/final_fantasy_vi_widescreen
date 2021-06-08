; apLib decruncher for SNES
; /Mic, 2010
; http://jiggawatt.org/badc0de/decrunch/aplib_decrunch_65816.asm
;
; Modified version of Mic's aplib decompressor modified to support 64kB bank
; boundary crossing used simply to check that data in the destination matches this
; decoder's results. If a byte doesn't match during decompression, this code
; will issue a STP instruction on the CPU (fail early).
;

!APLIB_ZP_BASE  = $F0

; DirectPage variables
!APLIB_LWM      = !APLIB_ZP_BASE
!APLIB_SRC_PTR  = !APLIB_LWM+2
!APLIB_BITS     = !APLIB_SRC_PTR+3
!APLIB_BITCOUNT = !APLIB_BITS+1
!APLIB_OFFS     = !APLIB_BITCOUNT+1
!APLIB_GAMMA    = !APLIB_OFFS+2
!APLIB_OFFS2    = !APLIB_GAMMA+2

macro APL_VERIFY()
; In:
; A = source bank
; Y = source offset
; X = dest offset
; DBR = dest bank

aplib_decrunch:
    ldx $fd             ; load dest offset.
    ldy $fa             ; load src offset.
    sep #$20
    lda #$7f            ; load dest bank.
    pha
    plb
    lda $fc             ; load src bank in A.

    php
    rep     #$10
    sep     #$20

    sta     !APLIB_SRC_PTR+2
    stz     !APLIB_SRC_PTR+1
    stz     !APLIB_SRC_PTR
    stz     !APLIB_OFFS+1
    stz     !APLIB_LWM+1

    lda     #$01
    sta     !APLIB_BITCOUNT

copy_byte:
    lda     [!APLIB_SRC_PTR],y
    ;sta.w  $0000,x
    cmp     $0000,x
    beq +
    stp
+:
    inx
    iny
    cpy     #$0000
    bne     next_sequence_init
    inc     !APLIB_SRC_PTR+2
next_sequence_init:
    stz     !APLIB_LWM
next_sequence:
    jsr     get_bit
    bcc     copy_byte        ; if bit sequence is %0..., then copy next byte
    jsr     get_bit
    bcc     code_pair        ; if bit sequence is %10..., then is a code pair
    jsr     get_bit
    stz     !APLIB_OFFS
    stz     !APLIB_OFFS+1
    bcs     +
    jmp     short_match        ; if bit sequence is %110..., then is a short match
+:
    ; The sequence is %111..., the next 4 bits are the offset (0-15)
    jsr     get_bit
    rol     !APLIB_OFFS
    jsr     get_bit
    rol     !APLIB_OFFS
    jsr     get_bit
    rol     !APLIB_OFFS
    jsr     get_bit
    rol     !APLIB_OFFS
    lda     !APLIB_OFFS
    beq     write_byte        ; if offset == 0, then write 0x00

    ; If offset != 0, then write the byte at destination - offset
    phx
    rep     #$20
    txa
    sec
    sbc     !APLIB_OFFS        ; A = dest - offs
    tax
    sep     #$20
    lda.w   $0000,x
    plx
write_byte:
    cmp     $0000,x
    ;sta.w  $0000,x
    beq +
    stp
+:    inx
    jmp     next_sequence_init

    ; Code pair %10...
code_pair:
    jsr     decode_gamma
    rep     #$20
    dec     !APLIB_GAMMA
    dec     !APLIB_GAMMA
    bne     normal_code_pair
    lda     !APLIB_LWM
    bne     normal_code_pair
    jsr     decode_gamma
    rep     #$20
    lda     !APLIB_OFFS2
    sta     !APLIB_OFFS
    jmp     copy_code_pair
normal_code_pair:
    lda     !APLIB_GAMMA
    clc
    adc     !APLIB_LWM
    dec
    sep     #$20
    sta     !APLIB_OFFS+1
    lda     [!APLIB_SRC_PTR],y
    iny
    cpy     #$0000
    bne     +
    inc !APLIB_SRC_PTR+2
    +:
    sta     !APLIB_OFFS
    jsr     decode_gamma
    rep     #$20
    lda     !APLIB_OFFS
    cmp     #$7D00
    bcc     compare_1280
    inc     !APLIB_GAMMA
compare_1280:
    cmp     #$500
    bcc     compare_128
    inc     !APLIB_GAMMA
    jmp     continue_short_match
compare_128:
    cmp     #$0080
    bcs     continue_short_match
    inc     !APLIB_GAMMA
    inc     !APLIB_GAMMA
    jmp     continue_short_match

; get_bit: Get bits from the crunched data and insert the most significant bit in the carry flag.
get_bit:
    sep     #$20
    dec     !APLIB_BITCOUNT
    bne     still_bits_left
    lda     #$08
    sta     !APLIB_BITCOUNT
    lda     [!APLIB_SRC_PTR],y
    sta     !APLIB_BITS
    iny
    cpy     #$0000
    bne     +
    inc     !APLIB_SRC_PTR+2
    +:
still_bits_left:
    asl     !APLIB_BITS
    rts

; decode_gamma: Decode values from the crunched data using gamma code
decode_gamma:
    rep     #$20
    lda     #$0001
    sta     !APLIB_GAMMA
get_more_gamma:
    jsr     get_bit
    rep     #$20
    lda     !APLIB_GAMMA
    adc     !APLIB_GAMMA
    sta     !APLIB_GAMMA
    jsr     get_bit
    bcs     get_more_gamma
    rts

; Short match %110...
short_match:
    rep     #$20
    lda     #$0001
    sta     !APLIB_GAMMA
    sep     #$20
    lda     [!APLIB_SRC_PTR],y    ; Get offset (offset is 7 bits + 1 bit to mark if copy 2 or 3 bytes)
    iny
    cpy     #$0000
    bne     +
    inc !APLIB_SRC_PTR+2
+:
    lsr     a
    beq     end_decrunch
    rol     !APLIB_GAMMA
    sta     !APLIB_OFFS
    stz     !APLIB_OFFS+1
    rep     #$20
continue_short_match:
    lda     !APLIB_OFFS
    sta     !APLIB_OFFS2
copy_code_pair:
    phy
    txa
    sec
    sbc     !APLIB_OFFS        ; dest - offs
    tay
loop_do_copy:
    sep     #$20
    lda.w   $0000,y
    ;sta.w  $0000,x
    cmp     $0000,x
    beq     +
    stp
+:
    inx
    iny
    bne     +
    inc !APLIB_SRC_PTR+2
    +:
    rep     #$20
    dec     !APLIB_GAMMA
    bne     loop_do_copy
    ply
    lda     #$0001
    sta     !APLIB_LWM
    sep     #$20
    jmp     next_sequence

end_decrunch:
    plp
    rtl
endmacro
