if defined("DEBUG")
    print "Warning: APL Verification enabled!"
    incsrc "aplib_verifier.asm"
    apl_verify:
        %APL_VERIFY()
endif

incsrc "aplib.asm"

apl:
    %APL()

macro apl_inject(src, dst, addr)
    ; Inject a jump.
    pushpc
    {
        org <addr>
        jml +               ; apl_check
    }
    pullpc
    +:  rep #$20
        lda [<src>]
        cmp #$ffff          ; check for modified algorithm (used to differentiate).
        beq +
        jml <addr>+4        ; original algorithm.
        +:
        ; Load registers for APL call.
        lda <src>+1
        sta $fb
        lda <src>
        clc
        adc #$0002          ; move past header.
        sta $fa
        lda <dst>
        sta $fd

    if defined("DEBUG")
        lda $fa : pha : lda $fd : pha : sep #$20 : lda $fc : pha : rep #$20
    endif

        jsl apl

    if defined("DEBUG")
        sep #$20 : pla : sta $fc : rep #$20 : pla : sta $fd : pla : sta $fa
        jsl apl_verify
    endif

        sep #$20
        jml <addr>+137      ; end of orig alg.

endmacro

%apl_inject($f3, $f6, $c0046d) ; field decompressor injection.
%apl_inject($d2, $d5, $eea47d) ; world decompressor injection.
