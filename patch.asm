hirom

org  $c3f091 : fillbyte $ff
fill 3951

org  $c3f091

;===================================================================

; Description:
; Reserve stack space for our own usage. (Perhaps unnecessary)

;pushpc
;{
;   org $c00020         ; Reserve stack space (originally #15ff)
;   ldx #$14ff
;
;}
;pullpc

;===================================================================

; Description (BG1, BG2, & BG3):
; Modify buffers to be 512x256.

pushpc
{
    ;
    org $c005b7         ; BG1
    lda #$49
    org $c03f1f         ; BG1
    lda #$49
    org $c005bc         ; BG2
    lda #$51
    org $c03f2d         ; BG2
    lda #$51
    org $c005c1         ; BG3
    lda #$59
    org $c03f49         ; BG3
    lda #$59
}
pullpc

;===================================================================

; Description (BG1, BG2, & BG3):
; Remove pixel masking along edges.

pushpc
{
    ;
    org $c005d0 ; left coordinate.
    lda #$00
    org $c005ec ; right right coordinate.
    lda #$ff
}
pullpc

;===================================================================

; Description (BG1, BG2, & BG3):
; Vertical (y) movement modification...
; Insert additional DMA for writing second half of TileMap to VRAM.

pushpc
{
    ; Call-site modifications.
    org $c02a72         ; BG1
        jsl dma_bg1
        nop
    org $c02af5         ; BG2
        jsl dma_bg2
        nop
    org $c02b78         ; BG3
        jsl dma_bg3
        nop
}
pullpc

macro dma(dest, src)
                ; DMA for second half of BG buffers.
    lda #$01    ; a901     ; 1 -> a.
    sta $420b   ; 8d0b42   ; Initiate DMA transfer.
    stz $420b   ; 9c0b42   ; Clear DMA transfer flag.
    stx $4305   ; 8e0543   ; set amount of bytes to transfer.
    ldx <dest>  ; a2????   ; load second half of tile buffer.
    stx $4302   ; 8e0243   ; set DMA dest addr.
    rep #$20    ; c220     ; clear 8-bit accum mode.
    lda <src>   ; a5??     ; load src addr.
    clc         ; 18       ; clear carry.
    adc #$0400  ; 690004   ; add 0x400 (offset to 2nd half of buf).
    sta $2116   ; 8d1621   ; set DMA src addr.
    lda #$0001  ; a90100   ; 1 -> a.
    sep #$20    ; e220     ; set 8-bit accum mode.
    sta $420b   ; 8d0b42   ; Initiate DMA transfer.
    rtl         ; 6b       ; return.
endmacro

dma_bg1:
{
    %dma(#$da40, $91)
}

dma_bg2:
{
    %dma(#$e240, $97)
}

dma_bg3:
{
    %dma(#$ea40, $9d)
}

;===================================================================

; Description (BG1 & BG2 & BG3):
; Vertical (y) movement modification...
; Preload additional tile data.
; This adds new code which inserts additional
; tile data into new spots of RAM located
; contiguously below the original buffers.

pushpc
{
    ; Double loop iterations for copying data to BG1, BG2, & BG3 internal buffers (Non-vram).
    org $c0219b             ; BG1
    lda #$20
    org $c02316             ; BG2
    lda #$20
    org $c024a9             ; BG3
    lda #$20
    ; Clip store offset high bit for BG1, BG2, & BG3 buffers.
    org $c02194             ; BG1
    and #$1f
    org $c0230f             ; BG2
    and #$1f
    org $c02491             ; BG3
    and #$1f
    ; Clip high bit for roll around of BG1, BG2, BG3 buffers addresses.
    org $c021c9             ; BG1
    and #$7f
    org $c021fb             ; BG1
    and #$7f
    org $c02344             ; BG2
    and #$7f
    org $c02376             ; BG2
    and #$7f
    org $c0253f             ; BG3
    and #$ff7f
    ; Call-site modifications: Jump to offset modification routines.
    org $c021a7             ; BG1
    jsl mod_offset_bg12
    org $c021d9             ; BG1
    jsl mod_offset_bg12
    org $c02322             ; BG2
    jsl mod_offset_bg12
    org $c02354             ; BG2
    jsl mod_offset_bg12
    org $c024e5             ; BG3
    jsl mod_offset_bg3
    org $c024fb             ; BG3
    jsl mod_offset_bg3
    org $c02511             ; BG3
    jsl mod_offset_bg3
    org $c02527             ; BG3
    jsl mod_offset_bg3
    ; Call-site modifications: Jump to offset reverse routines.
    org $c021c3             ; BG1
    jsl rev_offset_bg12
    org $c021f5             ; BG1
    jsl rev_offset_bg12
    org $c0233e             ; BG2
    jsl rev_offset_bg12
    org $c02370             ; BG2
    jsl rev_offset_bg12
    org $c0253b             ; BG3
    jsl rev_offset_bg3
}
pullpc

macro mod_offset()
    ; Add 64 to offset if dest offset >= 0x40.
    sep #$20    ; e220     ; set 8-bit accum mode
    pha         ; 48       ; push src offset.
    tya         ; 98       ; y -> a.
    cmp #$40    ; c940     ; compare to 0x40.
    bcc +3      ; 9003     ; jump if less than 0x40.
    clc         ; 18       ; clear carry.
    adc #$40    ; 6940     ; add 0x40.
    tay         ; a8       ; a -> y.
    pla         ; 68       ; pop src offset.
endmacro

mod_offset_bg12:
{
    %mod_offset()
    asl         ; 0a       ; lshift src offset.
    tax         ; aa       ; move src offset to x.
    rep #$20    ; c220     ; clear 8-bit accum mode.
    rtl         ; 6b       ; return
}

mod_offset_bg3:
{
    %mod_offset()
    rep #$20    ; e220     ; clear 8-bit accum mode
    asl         ; 0a       ; lshift tile data.
    asl         ; 0a       ; lshift tile data.
    ora $22     ; 0522     ; or tile data.
    rtl         ; 6b       ; return
}

macro rev_offset()
    ; Reverse above routine.
    ; Subtract 64 from offset if dest offset >= 0x80.
    sep #$20    ; e220     ; set 8-bit accum mode
    cmp #$80    ; c980     ; compare to 0x80.
    bcc +3      ; 9003     ; jump if less than 0x80.
    sec         ; 38       ; set carry.
    sbc #$40    ; e940     ; subtract 0x40.
endmacro

rev_offset_bg12:
{
    tdc         ; 7b       ; clear a.
    sep #$21    ; e221     ; set 8-bit accum mode.
    tya         ; 98       ; y -> a.
    %rev_offset()
    sec         ; 38       ; set carry
    rtl         ; 6b       ; return
}

rev_offset_bg3:
{
    %rev_offset()
    rep #$20    ; e220     ; clear 8-bit accum mode.
    inc #4      ; 1a       ; inc dest addr.
    rtl         ; 6b       ; return
}

;===================================================================

; Description (BG1, BG2, & BG3):
; Horizontal (x) movement modification...
; Changes camera start to +16*4

pushpc
{
    ; Call-site modifications
    org $c01b87             ; BG1
    jsl cam_start_bg1
    org $c01bdc             ; BG2
    jsl cam_start_bg2
    org $c01c62             ; BG3
    jsl cam_start_bg3
}
pullpc

macro cam_start(dest)
    ; Add 16*4 to start horizontal scroll.
    and $1e     ; 251e
    clc         ; 18
    adc #$0040  ; 694000 ; +16*4
    sta <dest>  ; 85??
    rtl         ; 6b
endmacro

cam_start_bg1:
{
    asl #04     ; 0a
    clc         ; 18
    adc #$0040  ; 694000 ; +16*4
    rtl         ; 6b
}

cam_start_bg2:
{
    %cam_start($64)
}

cam_start_bg3:
{
    %cam_start($6c)
}

;===================================================================

; Description (BG1, BG2, & BG3):
; Horizontal movement modification...
; Changes tilemap scrolling to begin at 13 tiles in instead of 8.

pushpc
{
    ; Switch comparison to 13.
    org $c07e32 ; BG1, BG2, BG3
    nop         ; ea
    cmp #$0c    ; c90c
}
pullpc

;===================================================================

; Description (BG1, BG2,& BG3):
; Horizontal (x) movement modification for BG1, BG2, & BG3...
; Modify Load location of tiles when moving right (+16 columns).
; Original logic is used when moving left.
; This expands the logic to load data +16 columns from what it
; originally did when moving left. The data will then get picked up
; during DMA.

pushpc
{
    ; Call-site modifications
    org $c02247             ; BG1
    jsl mod_col_index_bg12
    org $c023c2             ; BG2
    jsl mod_col_index_bg12
    org $c0259c             ; BG3
    jsl mod_col_index_bg3
}
pullpc

macro mod_col_index()
    ; Add 16 to column offset when moving left.
    rep #$21    ; c221     ; clear 8-bit accum mode, clear carry flag.
    lda $73     ; a573     ; taken from c02210 (indicates movement direction?)
    adc $0547   ; 6d4705   ; negative flag implies left movement
    bmi +14     ; 300e     ; jump for left direction to lda.w #$0.
    lda #$0000  ; a90000   ; restore high bytes of A
    sep #$20    ; e220     ; set 8-bit accum mode
    lda $2a     ; a52a     ; Load column address.
    clc         ; 18       ; Clear carry.
    adc #$10    ; 6910     ; Add 16 to the column.
    sta $2a     ; 852a     ; Store result.
    bra +5      ; 8005     ; Jump for right direction to lda #$10.
    lda #$0000  ; a90000   ; restore high bytes of A
    sep #$20    ; e220     ; set 8-bit accum mode
    lda #$10    ; a910     ; Restore original A low byte value.
endmacro

mod_col_index_bg12:
{
    %mod_col_index()
    rtl         ; 6b       ; Return
}

mod_col_index_bg3:
{
    %mod_col_index()
    sta $1b     ; 851b     ; Store original A.
    rtl         ; 6b       ; Return
}

;===================================================================

; Description (BG1, BG2, & BG3):
; Horizontal (x) movement modification for BG1, BG2, & BG3...
; Modify the store location for VRAM to place data in the second half
; of the buffer (16-63, 96-127, etc.) for certain coordinate ranges. Otherwise, it
; keeps placing data from columns 0 to 31. Internally, it preloads
; 0x48XX address which needs to be swapped to 0x4CXX for loading
; in the correct columns

pushpc
{
    ; Call-site modifications
    org $c022ca             ; BG1
    jsl mod_st_loc_bg1
    org $c02449             ; BG2
    jsl mod_st_loc_bg2
    org $c02657             ; BG3
    jsl mod_st_loc_bg3
}
pullpc

macro mod_st_loc(src, dest1, dest2)
    ; Modify store location for certain coordinate ranges (32-63, 96-127, etc.).
    pha         ; 48       ; push a
    rep #$21    ; c221     ; clear 8-bit accum mode, clear carry flag.
    lda $73     ; a573     ; taken from c02210 (indicates movement direction?)
    adc $0547   ; 6d4705   ; negative flag implies left movement
    bmi +10     ; 300a     ; jump for left direction
    lda #$0000  ; a90000   ; clear A
    sep #$20    ; e220     ; set 8-bit accum mode
    lda $0541   ; ad4105   ; register with vertical coordinate
    bra +9      ; 8009     ; jump for right direction
    lda #$0000  ; a90000
    sep #$20    ; e220     ; set 8-bit accum mode
    lda $0541   ; ad4105   ; register with vertical coordinate
    inc         ; 1a       ; add 1 if moving in left direction
    sec         ; 38       ; set carry for subtraction
    sbc #$8     ; e908     ; normalize subtract 8
    and #$10    ; 2910     ; normalize
    cmp #$00    ; c900     ; 0 result implies we should use original coordinates. 1 result implies we should shift to the second vram location.
    bne +3      ; d003
    pla         ; 68 ; pop a
    bra +3      ; 8003
    pla         ; 68
    lda <src>   ; a9??     ; Statically determined VRAM location loaded from a register for some reason normally.
    sta <dest1> ; 85??
    sta <dest2> ; 85??
    rtl         ; 6b
endmacro

mod_st_loc_bg1:
{
    %mod_st_loc(#$4c, $94, $96)
}

mod_st_loc_bg2:
{
    %mod_st_loc(#$54, $9a, $9c)
}

mod_st_loc_bg3:
{
    %mod_st_loc(#$5c, $a0, $a2)
}
