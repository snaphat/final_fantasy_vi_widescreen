
; ***************************************************************************
; ***************************************************************************
;
; aplib.asm
;
; 65C816 decompressor for data stored in Jorgen Ibsen's aPLib format.
;
; Includes support for Emmanuel Marty's enhancements to the aPLib format.
;
; The code is 413 bytes long.
;
; This code is written for the ASAR assembler.
;
; Based off of the NMOS 6502 decompressor, Copyright 2019, John Brandwood:
; https://github.com/emmanuel-marty/apultra/blob/master/asm/6502/aplib_6502.asm
;
; Distributed under the Boost Software License, Version 1.0.
;
; Permission is hereby granted, free of charge, to any person or organization
; obtaining a copy of the software and accompanying documentation covered by
; this license (the "Software") to use, reproduce, display, distribute,
; execute, and transmit the Software, and to prepare derivative works of the
; Software, and to permit third-parties to whom the Software is furnished to
; do so, all subject to the following:
;
; The copyright notices in the Software and this entire statement, including
; the above license grant, this restriction and the following disclaimer,
; must be included in all copies of the Software, in whole or in part, and
; all derivative works of the Software, unless such copies or derivative
; works are solely in the form of machine-executable object code generated by
; a source language processor.
;
; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
; FITNESS FOR A PARTICULAR PURPOSE, TITLE AND NON-INFRINGEMENT. IN NO EVENT
; SHALL THE COPYRIGHT HOLDERS OR ANYONE DISTRIBUTING THE SOFTWARE BE LIABLE
; FOR ANY DAMAGES OR OTHER LIABILITY, WHETHER IN CONTRACT, TORT OR OTHERWISE,
; ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
; DEALINGS IN THE SOFTWARE.
;
; ***************************************************************************
; ***************************************************************************

; ***************************************************************************
; ***************************************************************************
;
; Decompression Macros
;

;
; Macro to increment the source pointer to the next page.
; opt: duplication: removes costly jmps.
;
macro GET_SRC(srcptr)
    lda     [<srcptr>], y           ; opt: keep lowbyte in reg.
    iny                             ; inc src addr.
    bne +
    inc     <srcptr>+1              ; highbyte in zeropage.
    bne +
    inc     <srcptr>+2              ; page in zeropage.
    +:
endmacro

;
; Macro for byte & bit handling.
; opt: duplication: removes costly jmps.
;
macro LOAD_BIT(bitbuf, srcptr)
    %GET_SRC(<srcptr>)              ; Reload an empty bit-buffer
    rol                             ; from the compressed source.
    sta     <bitbuf>
endmacro

;
; Macro for gamma handling.
; opt: duplication: removes costly jmps.
;
macro GET_GAMMA(bitbuf, hilen, srcptr)
    lda     #$1                     ; Get a gamma-coded value.

    --:
    asl     <bitbuf>
    bne     ++
    tcs                             ; opt: 2-cycle.
    %LOAD_BIT(<bitbuf>, <srcptr>)   ; Reload an empty bit-buffer
    tsc                             ; opt: 2-cycle.

    ++:
    rol
    rol     <hilen>
    asl     <bitbuf>
    bne     ++
    tcs                             ; opt: 2-cycle.
    %LOAD_BIT(<bitbuf>, <srcptr>)   ; Reload an empty bit-buffer
    tsc                             ; opt: 2-cycle.

    ++:
    bcs     --
endmacro

; ***************************************************************************
; ***************************************************************************
;
; apl_decompress - Decompress data stored in Jorgen Ibsen's aPLib format.
;
; Uses: lots!
;
; As an optimization, the code to handle window offsets > 64768 bytes has
; been removed, since these don't occur with a 16-bit address range.
;
; As an optimization, the code to handle window offsets > 32000 bytes can
; be commented-out, since these don't occur in typical 8-bit computer usage.
;

; Overall opts: reduce register pressure on y & x, use stack ptr, mvn, remove subroutine jumps.
; scratch : 2-byte. - scratch+1 must remain #$00
; hilen   : 1-byte.
; bitbuf  : 1-byte.
; offset  : 2-byte.
; spbuf   : 2-byte.
; tdstptr : 2-byte.
; srcptr  : 3-byte.
; dstptr  : 2-byte.
; dstbank : const.

macro APL(scratch, hilen, bitbuf, offset, spbuf, tdstptr, srcptr, dstptr, dstbank)
apl_decompress:
                ; setup init.
                sep     #$30
                phb                             ; push bank.
                lda     #<dstbank>               ; load new bank.
                pha
                plb
                rep     #$30
                sei                             ; disable interrupts.
                lda     #$0000
                sta     <scratch>               ; clear scratch.
                sta     $004200                 ; disable nmi.
                tsc                             ; opt: use sp as free reg.
                sta     <spbuf>                 ; store sp.
                sep     #$30
                ; ---.
                ldy     <srcptr>                ; Initialize source index.
                stz     <srcptr>                ; Opt: set lowbyte to zero.

                lda     #$80                    ; Initialize an empty
                sta     <bitbuf>                ; bit-buffer.

                ;
                ; 0 bbbbbbbb - One byte from compressed data, i.e. a "literal".
                ;
.literal:       %GET_SRC(<srcptr>)

.write_byte:    ldx     #$00                    ; LWM=0.

                sta     (<dstptr>)              ; Write the byte directly to the output.
                inc     <dstptr>
                bne     .next_tag
                inc     <dstptr>+1

.next_tag:      asl     <bitbuf>                ; 0 bbbbbbbb
                bne     .skip0
                %LOAD_BIT(<bitbuf>, <srcptr>)   ; opt: no jsr.
.skip0:         bcc     .literal

.skip1:         asl     <bitbuf>            ; 1 0 <offset> <length>
                bne     .skip2
                %LOAD_BIT(<bitbuf>, <srcptr>)   ; opt: no jsr.
.skip2:         bcc     .copy_large

                asl     <bitbuf>                ; 1 1 0 dddddddn
                bne     .skip3
                %LOAD_BIT(<bitbuf>, <srcptr>)   ; opt: no jsr.
.skip3:         bcc     .copy_normal

                ; 1 1 1 dddd - Copy 1 byte within 15 bytes (or zero).
.copy_short:    lda     #$10
.nibble_loop:   asl     <bitbuf>
                bne     .skip4
                tcs                             ; opt: 2-cycle.
                %LOAD_BIT(<bitbuf>, <srcptr>)   ; opt: no jsr.
                tsc                             ; opt: 2-cycle.
.skip4:         rol
                bcc     .nibble_loop
                beq     .write_byte             ; Offset=0 means write zero.
                sta     <scratch>               ; +1 of scratch must remain zero.
                rep     #$20
                lda     <dstptr>
                sbc     <scratch>
                sta     <tdstptr>
                sep     #$20
                lda     (<tdstptr>)
                bra     .write_byte

.finished:      rep #$30                        ; Fin.
                lda <spbuf>                     ; load sp.
                tcs                             ; restore sp.
                lda $80
                sta $004200                     ; enable
                cli                             ; enable interrupts.
                sep #$30
                plb                             ; restore bank.
                rep #$30
                rtl                             ; All decompressed!

                ;
                ; 1 1 0 dddddddn - Copy 2 or 3 within 128 bytes.
                ;
.copy_normal:   %GET_SRC(<srcptr>)              ; 1 1 0 dddddddn
                lsr
                beq     .finished               ; Offset 0 == EOF.

                sta     <offset>                ; Preserve offset.
                tdc                             ; opt: Clear high byte of length
                sta     <offset>+1
                adc     #$2                     ; +2 length.
                jmp     .copy_page              ; NZ from previous ADC.

                ;
                ; 1 0 <offset> <length> - gamma-coded LZSS pair.
                ;

.copy_large:    %GET_GAMMA(<bitbuf>, <hilen>, <srcptr>) ; opt: no jsr, Get length.
                stz     <hilen>                 ; opt: clear highbyte of length.
                cpx     #$1                     ; CC if LWM==0, CS if LWM==1.
                sbc     #$2                     ; -3 if LWM==0, -2 if LWM==1.
                bcs     .normal_pair            ; CC if LWM==0 && offset==2.

                %GET_GAMMA(<bitbuf>, <hilen>, <srcptr>) ; opt: no jsr, Get length.
                bcc     .copy_page              ; Use previous Offset.

.normal_pair:   tax                             ; opt: keep for cmp.
                stx     <offset>+1              ; Save bits 8..15 of offset.

                %GET_SRC(<srcptr>)              ; opt: no jsr.
                sta     <offset>                ; Save bits 0...7 of offset.

                %GET_GAMMA(<bitbuf>, <hilen>, <srcptr>)  ; opt: no jsr.

                ;
                cpx     #$00                    ; If offset <    256.
                beq     .lt256
                cpx     #$7D                    ; If offset >= 32000, length += 1.
                bcs     .match_plus2
                cpx     #$05                    ; If offset >=  1280, length += 0.
                bcs     .match_plus1

.copy_page:     ; opt: mvn, Calc address of match and store.
                xba                             ; non-opt: put together length.
                lda     <hilen>                 ; load highbyte of length.
                xba                             ; non-opt: put together length.
                dec
                sty     <scratch>               ; opt: 2-cycle, store srcptr lowbyte.
                rep     #$30
                tcs                             ; opt: 2-cycle, store 2 byte length.
                lda     <dstptr>                ; load precomputed destptr.
                tay                             ; transfer cur dest.
                sec                             ; non opt: need to keep this.
                sbc     <offset>                ; opt: subtract full offset in one go.
                tax                             ; transfer src.
                tsc                             ; opt: 2-cycle, load 2 byte length.
                mvn     <dstbank>, <dstbank>    ; opt: mvn.
                sty     <dstptr>                ; opt: free computation of next dstptr
                sep     #$30
                ldx     #$01                    ; transfer 1 to x. ; LWM=1.
                ldy     <scratch>               ; opt: 2-cycle, load srcptr lowbyte.
                jmp     .next_tag


.lt256:         ldx     <offset>                ; If offset <    128, length += 1.
                bmi     .copy_page

                sec

.match_plus2:   adc     #$1                     ; CS, so ADC #2.
                bcs     .match_plus256

.match_plus1:   adc     #$0                     ; CS, so ADC #1, or CC if fall
                bcc     .copy_page              ; through from .match_plus2.

.match_plus256: inc     <hilen>
                bra     .copy_page

.end:
endmacro
