hirom

org  $c0d613 : fillbyte $ff
fill 2445

org  $c0d613


;===================================================================
; @ RAM Direct Page Map:
;   Field:
;       $5c   : H-scroll value of BG1.
;       $64   : H-scroll value of BG2.
;       $6c   : H-scroll value of BG3.
;
;       $73   : x-movement direction offset (non-controller).
;
;       $86   : BG1 Map Horizontal Clip.
;       $87   : BG1 Map Vertical Clip.
;       $88   : BG2 Map Horizontal Clip.
;       $89   : BG2 Map Vertical Clip.
;       $8A   : BG3 Map Horizontal Clip.
;       $8B   : BG3 Map Vertical Clip.
;
;       $91   : low byte of  BG1 DMA buffer address for y-movement and fullscreen updates.
;       $92   : high byte of BG1 DMA buffer address for y-movement and fullscreen updates.

;       $93   : low byte of  BG1 DMA buffer address for x-movement updates (column 1).
;       $94   : high byte of BG1 DMA buffer address for x-movement updates (column 1).
;       $95   : low byte of  BG1 DMA buffer address for x-movement updates (column 2).
;       $96   : high byte of BG1 DMA buffer address for x-movement updates (column 2).
;
;       $97   : low byte of  BG2 DMA buffer address for y-movement and fullscreen updates.
;       $98   : high byte of BG2 DMA buffer address for y-movement and fullscreen updates.
;
;       $99   : low byte of  BG2 DMA buffer address for y-movement updates (column 1).
;       $9a   : high byte of BG2 DMA buffer address for x-movement updates (column 1).
;       $9b   : low byte of  BG2 DMA buffer address for x-movement updates (column 2).
;       $9c   : high byte of BG2 DMA buffer address for x-movement updates (column 2).
;
;       $9d   : low byte of  BG3 DMA buffer address for y-movement and fullscreen updates.
;       $9e   : high byte of BG3 DMA buffer address for y-movement and fullscreen updates.
;
;       $9f   : low byte of  BG3 DMA buffer address for x-movement updates (column 1).
;       $a0   : high byte of BG3 DMA buffer address for x-movement updates (column 1).
;       $a1   : low byte of  BG3 DMA buffer address for x-movement updates (column 2).
;       $a2   : high byte of BG3 DMA buffer address for x-movement updates (column 2).
;
; @ RAM Indirect Map:
;   Field:
;       $0541 : BG1 current x-coordinate pivot.
;       $0542 : BG1 current y-coordinate pivot.
;
;       $0543 : BG2 current x-coordinate pivot.
;       $0544 : BG2 current y-coordinate pivot.
;
;       $0545 : BG3 current x-coordinate pivot.
;       $0546 : BG3 current y-coordinate pivot.
;
;       $0547 : Added to $73 -- dunno.
;
;       $062c : X-Scroll start + Camera start?
;
;       $0960 : exact character x-offset in pixels (not true in all areas).
;       $0963 : exact character y-offset in pixels (not true in all areas).
;
;       $0970 : character x position (not true in all areas).
;       $0971 : character y position (not true in all areas).
;
;       $0974 : current controller movement direction. 0 if controller isn't initiating movement (not true in all areas).
;       $0975 : current controller movement direction (stored). 0 if controller isn't initiating movement (not true in all areas).
;
; @ ROM Code Map:
;   Field:
;       $c01cf3 - $c01d23 : Full Update Top-half DMA to VRAM | BG1.
;       $c01d24 - $c01d5e : Full Update Bot-half DMA to VRAM | BG1.
;       $c01d5f - $c01d8f : Full Update Top-half DMA to VRAM | BG2.
;       $c01d90 - $c01dca : Full Update Bot-half DMA to VRAM | BG2.
;       $c01dcb - $c01dfb : Full Update Top-half DMA to VRAM | BG3.
;       $c01dfc - $c91e36 : Full Update Bot-half DMA to VRAM | BG3.
;       $c01e37 - $c01ec3 : Full Update DMA check            | BG1, BG2, BG3.
;       $c01ec4 - $c01f07 : Full Update Map Data (e.g doors) | BG1, BG2, BG3.
;       $c01f08 - $c01f13 : Full Update Check                | BG1.
;       $c01f14 - $c01fc1 : Full Update Buffering            | BG1.
;       $c01fc2 - $c01fcd : Full Update Check                | BG2.
;       $c01fce - $c02080 : Full Update Buffering            | BG2.
;       $c02081 - $c0208c : Full Update Check                | BG3.
;       $c0208d - $c02101 : Full Update Buffering            | BG3.
;       $c02102 - $c02153 : Row/Column Update Check          | BG1, BG2, BG3.
;       $c02154 - $c0220f : Row    Update Buffering          | BG1.
;       $c02210 - $c022ce : Column Update Buffering          | BG1.
;       $c022cf - $c0238a : Row    Update Buffering          | BG2.
;       $c0238b - $c0244d : Column Update Buffering          | BG2.
;       $c0244e - $c02499 : Row    Update Pre-Buffering      | BG3.
;       $c0249a - $c02558 : Row    Update Buffering          | BG3.
;       $c02559 - $c0265b : Column Update Buffering          | BG3.
;       $c0265c - $c0268c : Color Palette Load               | BG1, BG2, BG3.
;       $c0268d - $c026d7 : Tile Data DMA Check              | BG1, BG2.
;       $c026d8 - $c0285e : Tile Data DMA to VRAM            | BG1, BG2.
;       $c0275f - $c027d9 : Tile Data DMA to VRAM            | BG3.
;       $c027da - $c02882 : Tile Formation                   | BG1, BG2.
;       $c02883 - $c0296a : Map Load                         | BG1, BG2.
;       $c0296b - $c0297f : Map Load                         | BG3.
;       $c02980 - $c02a46 : Map Decompression                | BG1, BG2, BG3.
;       $c02a47 - $c02a77 : Row    Update DMA to VRAM        | BG1.
;       $c02a78 - $c02aC9 : Column Update DMA to VRAM        | BG1.
;       $c02aca - $c02afa : Row    Update DMA to VRAM        | BG2.
;       $c02afb - $c02b4c : Column Update DMA to VRAM        | BG2.
;       $c02b4d - $c02b7d : Row    Update DMA to VRAM        | BG3.
;       $c02b7e - $c02bcf : Column Update DMA to VRAM        | BG3.

; @ WRAM Address Map:
;   Original Field:
;       $7e0500 : OAM buffer.
;       $7e81b3 : location of buffer looping values (switches on hsync intervals?).
;
;       $7fd840 - $7fd8bf: Partial BG1 Map for Horizontal Scrolling (128 bytes) (2 x 32 tiles, 2 bytes per 8x8 tile) (first column, second column)
;       $7fd8c0 - $7fd93f: Partial BG2 Map for Horizontal Scrolling (128 bytes) (2 x 32 tiles, 2 bytes per 8x8 tile) (first column, second column)
;       $7fd940 - $7fd9bf: Partial BG3 Map for Horizontal Scrolling (128 bytes) (2 x 32 tiles, 2 bytes per 8x8 tile) (first column, second column)
;
;       $7fd9c0 - $7fda3f: Partial BG1 Map for Vertical Scrolling (128 bytes) (32 x 2 tiles, 2 bytes per 8x8 tile)
;       $7fe1c0 - $7fe23f: Partial BG2 Map for Vertical Scrolling (128 bytes) (32 x 2 tiles, 2 bytes per 8x8 tile)
;       $7fe9c0 - $7fea3f: Partial BG3 Map for Vertical Scrolling (128 bytes) (32 x 2 tiles, 2 bytes per 8x8 tile)
;
;       $7fd9c0 - $7fe1bf: BG1 Map for Full Updates (2048 bytes) (32 x 32 tiles, 2 bytes per 8x8 tile)
;       $7fe1c0 - $7fe9bf: BG2 Map for Full Updates (2048 bytes) (32 x 32 tiles, 2 bytes per 8x8 tile)
;       $7fe9c0 - $7ff1bf: BG3 Map for Full Updates (2048 bytes) (32 x 32 tiles, 2 bytes per 8x8 tile)
;
;   Widescreen Field:
;       $7fd840 - $7fd8bf: Partial BG1 Map for Horizontal Scrolling (128 bytes) (2 x 32 tiles, 2 bytes per 8x8 tile) (first column, second column)
;       $7fd8c0 - $7fd93f: Partial BG2 Map for Horizontal Scrolling (128 bytes) (2 x 32 tiles, 2 bytes per 8x8 tile) (first column, second column)
;       $7fd940 - $7fd9bf: Partial BG3 Map for Horizontal Scrolling (128 bytes) (2 x 32 tiles, 2 bytes per 8x8 tile) (first column, second column)
;
;       $3f6000 - $3f60ff: Partial BG1 Map for Vertical Scrolling (256 bytes) (64 x 2 tiles, 2 bytes per 8x8 tile)
;       $3f7000 - $3f70ff: Partial BG2 Map for Vertical Scrolling (256 bytes) (64 x 2 tiles, 2 bytes per 8x8 tile)
;       $7fd9c0 - $7fdabf: Partial BG3 Map for Vertical Scrolling (256 bytes) (64 x 2 tiles, 2 bytes per 8x8 tile)
;
;       $3f6000 - $3f6fff: BG1 Map for Full Updates (4096 bytes) (64 x 32 tiles, 2 bytes per 8x8 tile)
;       $3f7000 - $3f7fff: BG2 Map for Full Updates (4096 bytes) (64 x 32 tiles, 2 bytes per 8x8 tile)
;       $7fd9c0 - $7fe9bf: BG3 Map for Full Updates (4096 bytes) (64 x 32 tiles, 2 bytes per 8x8 tile)
;
;   World Map:
;       0x7e6b30 : OAM Table 1 start (in CPU memory).
;       0x7e6d30 : OAM Table 2 start (in CPU memory).
;       0x7eb5da : x-location of airship on-screen.
;       0x7eb5dc : y-location of airship on-screen.
;
; @ VRAM Address Map:
;   Original (assuming 8-bit word size):
;       $0000 - $5fff  : Tile data (BG1 & BG2).
;       $6000 - $7fff  : Tile data (BG3).
;       $8000 - $87ff  : Message Borders (BG1).
;       $8800 - $8fff  : Message Text (BG3) (Top and bottom half are duplicates).
;       $9000 - $97ff  : Bottom Layer Tiles (BG1).
;       $9800 - $9fff  : Bottom Layer Tiles Alt (BG1).
;       $a000 - $a7ff  : Top Layer Tiles (BG2).
;       $a800 - $afff  : Top Layer Tiles Alt (BG2).
;       $b000 - $b7ff  : Effects (BG3).
;       $b800 - $bfff  : Effects Alt (BG3).
;       $c000 - $dfff  : Sprite Locations (OAM).
;       $e000 - $ffff  : Sprite Data (OAM).
;
;   Wide-screen (assuming 8-bit word size):
;       $0000 - $5fff : Tile data (BG1 & BG2).
;       $6000 - $7fff : Tile data (BG3).
;       $8000 - $87ff : Message Borders (BG1).
;       $8800 - $8fff : Message Text (Top and bottom half are duplicates) (BG3).
;       $9000 - $9fff : Ground Tiles (Expanded) (BG1).
;       $a000 - $afff : Roof Tiles (Expanded) (BG2).
;       $b000 - $bfff : Effects (Expanded) (BG3).
;       $c000 - $dfff : Sprite Locations (OAM).
;       $e000 - $ffff : Sprite Data (OAM).
;
; @ Reserved Memory Map:
;   Wide-screen:
;       $15ff : Configurable mini-map state byte.
;
; @ Cheat Codes:
;   Walk through walls in Towns/Dungeons:
;       Raw : C04E4E:EA+C04E4F:EA+C04E57:EA+C04E58:EA+C04E6A:EA+C04E6B:EA+C04E73:EA+C04E74:EA+C04E7E:EA+C04E7F:EA+C04E86:EA+C04E87:EA+C04E8D:EA+C04E8E:EA+C04EA9:80
;       Game Genie : 3C00-8767+3C00-87A7+3C09-8FA7+3C09-84D7+3C01-8467+3C01-84A7+3C05-8DA7+3C05-8FD7+3C05-8767+3C05-87A7+3C06-8F67+3C06-8FA7+3C06-8707+3C06-8767+6D0C-8407
;
;   Walk though walls in Overworld:
;       Raw : EE1EE2:EA+EE1EE3:EA+EE1F30:EA+EE1F31:EA+EE1F7E:EA+EE1F7F:EA+EE1FCB:EA+EE1FCC:EA
;       Game Genie : 3CF3-8688+3CF3-86E8+3CF7-E678+3CF7-E658+3CF5-E888+3CF5-E8E8+3CFA-ECE8+3CFA-E878
;

;===================================================================
; Section:
; @ Generic Macros
;

macro cmp(loc, val)
    org <loc> : cmp <val>
endmacro

macro cpx(loc, val)
    org <loc> : cpx <val>
endmacro

macro cpy(loc, val)
    org <loc> : cpy <val>
endmacro

macro eor_nop3(loc)
    org <loc> : eor #$01 : nop #3
endmacro

macro jsl(loc, lbl)
    org <loc> : jsl <lbl>
endmacro

macro jsl_nop(loc, lbl)
    %jsl(<loc>, <lbl>) : nop
endmacro

macro jsl_nop2(loc, lbl)
    %jsl(<loc>, <lbl>) : nop #2
endmacro

macro lda(loc, val)
    org <loc> : lda <val>
endmacro

macro ldx(loc, val)
    org <loc> : ldx <val>
endmacro

macro ldy(loc, val)
    org <loc> : ldy <val>
endmacro

macro nop(loc)
    org <loc> : nop
endmacro

macro nop2(loc)
    org <loc> : nop #2
endmacro

macro nop3(loc)
    org <loc> : nop #3
endmacro

macro nop4(loc)
    org <loc> : nop #4
endmacro

;===================================================================
; Section:
; @ Cheats
;
; Description:
;   Cheats.
;
; - Walk through Walls in Towns/Dungeons.
; - Walk through Walls in Overworld.
;
pushpc
{
    ; Towns/Dungeons
    %nop2($c04e4e)
    %nop2($c04e57)
    %nop2($c04e6a)
    %nop2($c04e73)
    %nop2($c04e7e)
    %nop2($c04e86)
    %nop2($c04e8d)
    org $c04ea9 : db $80 ; bra
    ; Overworld
    %nop2($ee1ee2)
    %nop2($ee1f30)
    %nop2($ee1f7e)
    %nop2($ee1fcb)
}
pullpc

;===================================================================
; Section:
; @ ROM Header
;
; Description:
;   Rom header modifications.
;
; - Quadruple  SRAM.
;
pushpc
{
    org $00ffd8
    db $05 ; $400<<5 (32768 Bytes)
}
pullpc

;===================================================================
; Section:
; @ Lookup Tables
;
; Description:
;   Lookup tables.
;
; - OAM2 bitwise table for looking up the location of the 9th x-bit to set for a given sprite number.
;
oam2_bit_vals:
{
    db $01,$04,$10,$40 ; bits: 00_00_00_01; 00_00_01_00, 00_01_00_00, 01_00_00_00
}

;===================================================================
; Section:
; @ Stack Setup
;
; Description:
;   Stack modifications.
;
; - Reserve stack space for patch usage.
; - Ex-map state for displaying the mini-map in 4 locations.
;
pushpc
{
    %ldx($c00020, #$15fe)   ; Reserve stack space (originally #15ff)
    %jsl_nop($c0002c,setup) ; Setup reserved variable state.
}
pullpc

setup:
{
    lda #$01                ; Initial value of mini-map.
    sta $15ff               ; ex-map state.
    lda #$01                ; Original code.
    sta $420d               ; Original code.
    rtl
}

;===================================================================
; Section:
; @ OAM Sprite Boundaries
;
; Description:
;   Sprite Drawing boundary expansion.
;


macro rm_ex_lrg_sprite_shft(dest)
    ; Subtract 8 from large sprite location.
    sbc $5c
    sec
    sbc #$0008
    sta <dest>
    rtl
endmacro

exp_draw_bnds_reg_sprite:
{
    ; Checks if character sprite is on a negative boundary and overwrites OAM data. Negative
    ; boundaries could be on the right or left. Anywhere outside the center of the screen.
    ; Rather iffy considering it does it directly. For some reason the built in logic does
    ; not work for the main character sprite so they loop along the center normally? It
    ; remains to be seen whether the OAM locations are static for the main character or not.
    pha
    cpx #$0000              ; Check if character sprite apparently an X of zero here implies this?
    bne .end                ; Branch if not character sprite.
    and #$ff00              ; Get high byte.
    cmp #$0000              ; Check if subtraction was negative for orienting the sprite (-64 logic).
    beq .end                ; Branch if not negative.
    sep #$20                ; Kick into 8-bit mode.
    lda $050f               ; Load current OAM value for sprite that represents the character.
    ora #$10                ; Enable negative bit to place the sprite to the right of the OAM window.
    sta $050f               ; Store back.
    lda $051b               ; Load current OAM value for two other sprites the represent the character.
    ora #$50                ; 0x10 | 0x40 Enable negative bits to place the sprite(s) to the right of the OAM window.
    sta $051b               ; Store back.
    rep #$20                ; Kick into 16-bit mode.
    .end:
    pla

    ; Expands the normal sprites to appear in a wider area.
    adc #$0050              ; shift the boundary to load/unload sprites directly at the wide-screen pivot location.
    sep #$20                ; kick into 8-bit mode.
    xba                     ; swap upper byte -- it uses it to check whether a sprite should be displayed (original code).
    and #$fe                ; Checking clipping to be an extra byte large from the original logic.
    rtl
}

macro overworld_pos_inline()
    ;-------------------------------------------------------------------
    ; Modified Overworld Sprite positioning algorithm to work for
    ; widescreen. Uses 16-bit values to detect if sprites are outside of
    ; the 0-255 range and sets the OAM2 bit table for the given sprite.
    org $ee4335
    ; Load and normalize the sprite x-offset to be positive.
    tdc                     ; clear upper byte of a.
    lda $95d0,y             ; load sprite x-offset (from a lookup table).
    clc                     ; clear carry.
    adc #$10                ; normalize x-offset to get rid of overflow (some offsets are in the 0xF6+ range otherwise).
    ; Switch to 16-bit mode and add x-coord to overflow into the high-byte (used to detect the x-coord range).
    rep #$21                ; Kick a into 16-bit mode and clear carry.
    adc $58                 ; add x-coord to sprite x-offset.
    pha                     ; push a.
    phx                     ; push x.
    phy                     ; push y.
    ; Compute the sprite number, OAM2 byte, and OAM2 9th bit locations (needed to expand x-coords to 0-511).
    sep #$30                ; Kick into 8-bit mode.
    txa                     ; transfer sprite offset x->a.
    lsr #2                  ; normalize to get sprite number.
    tay                     ; transfer sprite index a->y.
    and #$03                ; AND to get current bit to modify.
    tax                     ; transfer OAM BIT to modify a->x.
    tya                     ; transfer sprite index y->a.
    lsr #2                  ; normalize to get OAM BYTE to modify.
    tay                     ; transfer byte to modify a->y.
    bank noassume
    lda oam2_bit_vals, x    ; load bitwise value using current bit as an offset.
    bank auto
    tax                     ; store OAM2 bit to set/clear in value a->x.
    ; Check if in positive range or not and set/clear the 9th bit accordingly.
    xba                     ; exchange high byte to see if in negative range.
    beq +                   ; branch if positive range (0x0).
    ; Negative range (-1 to -256):
    txa                     ; store OAM2 bit to set/clear in x->a(set).
    ora $6d30,y             ; OR with current value in OAM2[byte to modify] to set bit.
    bra ++                  ; Branch to store-back.
    +:
    ; positive range (0 to 255):
    txa                     ; store OAM2 bit to set/clear in x->a (clear).
    eor #$ff                ; invert bits (all bits except the bit we want to clear should be set).
    and $6d30,y             ; and with current value in OAM2[byte to modify] to clear bit.
    ++:
    sta $6d30,y             ; store back in OAM2[byte to modify].
    rep #$30                ; Kick into 16-bit mode.
    ply                     ; restore x.
    plx                     ; restore y.
    pla                     ; restore a.
    sep #$20
    nop #2                  ; nop to $ee4370 (original game code).
    ; Overworld - Character offset shift (subtracted by #$10 to compensate for the adjustment above).
    org $ee482b
    lda #$6e
    ; Overworld - Airship offset shift (subtracted by #$10 to compensate for the adjustment above).
    org $ee4781
    adc #$006e
endmacro

pushpc
{
    ; ----
    ; Shift removal code:
    ; ----
    %nop4($c05bb2)          ; Remove 8 pixel shift for regular sprites.
    %nop3($c0c8c3)          ; Remove 8 pixel shift for shadow clipping sprites.
    %nop4($c06579)          ; Remove 8 pixel shift for large esper sprites.
    ; Remove 8 pixel shift for extra large chocobo sprites.
    %jsl($c060e0, rm_ex_lrg_sprite_shft_chocobo)
    ; Remove 8 pixel shift for extra large magitek armor sprites.
    %jsl($c05d67, rm_ex_lrg_sprite_shft_magitek)
    ; ----
    ; Load expansion code:
    ; ----
    ; Expand draw bounds for regular sprites.
    %nop($c05bee)           ; xba that is now located in the jump.
    %jsl_nop($c05bb9, exp_draw_bnds_reg_sprite)
    ; Expand draw bounds for large esper sprites.
    %cpx($c065b6, #$ffa0)   ; shift the boundary to load/unload sprites directly at the wide-screen pivot location.
    %cpx($c065bb, #$01a0)   ; shift the boundary to load/unload sprites directly at the wide-screen pivot location.
    ; Expand draw bounds for extra large chocobo sprites.
    %cpy($c06112, #$01a0)   ; shift the boundary to load/unload sprites directly at the wide-screen pivot location.
    %cpy($c06117, #$ffa0)   ; shift the boundary to load/unload sprites directly at the wide-screen pivot location.
    ; Expand draw bounds for extra large magitek armor sprites.
    %cpy($c05d99, #$01a0)   ; shift the boundary to load/unload sprites directly at the wide-screen pivot location.
    %cpy($c05d9e, #$ffa0)   ; shift the boundary to load/unload sprites directly at the wide-screen pivot location.
    ; Expand draw bounds for airship sprite.
    %nop3($ee476e)          ; Overworld: Remove x-coordinate clamping.
    %cmp($ee4773, #$010a)   ; check for displaying ship
    %overworld_pos_inline() ; Modify overworld positoning algorithm.
    ;--------------------------------------------------------------------------------------------------
}
pullpc
    rm_ex_lrg_sprite_shft_chocobo: %rm_ex_lrg_sprite_shft($20)
    rm_ex_lrg_sprite_shft_magitek: %rm_ex_lrg_sprite_shft($1e)

;===================================================================
; Section:
; @ OAM Configurable Mini-map
;
; Description:
;   Configurable mini-map logic for displaying the mini-map in 4 different possible locations. Implements
;   logic for five different states. Byte $15FF as been reserved on the the stack to store the state.
;
; 0 - Mini-map not displayed.
; 1 - Mini-map displayed on the mid-right.
; 2 - Mini-map displayed on the far-right.
; 3 - Mini-map displayed on the mid-left.
; 4 - Mini-map displayed on the far-left.
;
mmap_set_cfg:
{
    ; Implements logic for setting up 5 different states to cycle through when the mini-map button toggle is
    ; hit. Modifies the original state bit logic accordingly. The map is open if $11f6 bit 0 is low and closed
    ; if bit 0 is high. However, the state logic here is inversed because the game inverses the currently
    ; reported state after this subroutine. This routine is called during mini-map toggle ON and OFF.
    sep #$30                ; set 8-bit a,x,y mode.
    lda $11f6               ; load state byte that contains map state bit.
    ldx $15ff               ; load current ex-map state (reserved stack space).
    inx                     ; inc ex-map state.
    cpx #$05                ; check if above max ex-map state.
    bne +
    ; Roll around exmap-state (Disable map).
    and #$fe                ; report map as currently enabled.
    ldx #$00                ; load 0 for ex-map state.
    bra ++
    +:
    ; Enable map.
    ora #$01                ; Report map as currently disabled.
    ++:
    sta $11f6               ; Store inverted map state bit.
    stx $15ff               ; Store ex-map state (reserved stack space).
    rep #$20                ; clear 8-bit a,x,y mode.
    bit #$0001              ; Check map state (for jump that follows this).
    rtl
}

mmap_apply_cfg:
{
    ; Implements logic for loading the initial top-left location of the mini-map. The upper bit of the
    ; accumulator is set to 1 if the map begins outside of the 0-255 coordinate area (i.e. is negative).
    ; This will not be called if the ex-map state is 0 so it is not handled here. This routine is called
    ; only during mini-map toggle ON.
    xba                     ; swap upper and lower byte so we can set the upper byte.
    lda $15ff               ; load the current ex-map state.
    ; State 1 - Mid-right.
    cmp #$01 : bne +        ; Check if state is 1.
    lda #$00                ; high byte address of x coord (positive region).
    ldy #$f0 : bra ++       ; Start map at x = 240
    +:
    ; State 2 - Far-right.
    cmp #$02 : bne +        ; Check if state is 2.
    lda #$01                ; high byte address of x coord (negative region).
    ldy #$00 : bra ++       ; start map at x = -256
    +:
    ; State 3 - Mid-left.
    cmp #$03 : bne +        ; Check if state is 3.
    lda #$01                ; high byte address of x coord (negative region).
    ldy #$d0 : bra ++       ; start map at x = -48
    +:
    ; State 4 - Far-left.
    cmp #$04 : bne ++       ; Check if state is 4.
    lda #$01                ; high byte address of x coord (negative region).
    ldy #$c0                ; start map at x = -64
    ++:
    ldx #$00                ; Original instruction.
    xba                     ; Swap high byte back to high location.
    rtl
}

mmap_set_map_loc:
{
    ; Implements logic for incrementing the mini-map sprite coordinates. This extends the original logic
    ; to handle overflow (locations outside of 0-255) and sets the OAM2 table accordingly. Each call
    ; to this routine handles a column (4 sprites) of the map beginning from the left and increments
    ; the x-coordinate by 16. This routine is called only during mini-map toggle ON.
    pha                     ; Push x-address value.
    phx                     ; Push sprite index.
    txa                     ; Transfer sprite index to x->a.
    lsr #2                  ; Normalize to get OAM bit to modify.
    tax                     ; transfer OAM BIT to modify a->x.
    bank noassume
    lda oam2_bit_vals, x    ; load bitwise value using current bit as an offset.
    bank auto
    ; Check if in positive range or not and set/clear the 9th bit accordingly.
    xba                     ; exchange high byte to see if in negative range.
    cmp #$01
    bne +                   ; branch if positive range (0x0).
    ; Negative range (-1 to -256):
    xba                     ; store OAM2 bit to set/clear in x->a(set).
    ora $6d31               ; OR with current value in OAM2 to set bit.
    bra ++                  ; Branch to store-back.
    +:
    ; positive range (0 to 255):
    xba                     ; store OAM2 bit to set/clear in x->a (clear).
    eor #$ff                ; invert bits (all bits except the bit we want to clear should be set).
    and $6d31               ; AND with current value in OAM2[1] to clear bit.
    ++:
    ; Store back - this works because these are where map columns are stored.
    sta $6d31               ; store back in OAM2[1].
    sta $6d32               ; store back in OAM2[2].
    sta $6d33               ; store back in OAM2[3].
    sta $6d34               ; store back in OAM2[4].
    plx                     ; Pop sprite offset.
    pla                     ; Pop x-address.
    ; Add offset for next column of mini-map.
    rep #$20                ; Set 16-bit mode for a.
    clc                     ; Clear-carry.
    adc #$0010              ; Add while accounting for overflow.
    sep #$20                ; Set 8-bit mode for a.
    ; Do original logic.
    tay                     ; Original code.
    txa                     ; Original code.
    clc                     ; Original code.
    adc #$04                ; Original code.
    rtl                     ; Original code.
}

mmap_set_marker_loc:
{
    ; Implements logic for offsetting the mini-map marker's x-coordinate depending on the current ex-map
    ; state. Internally, it also adjusts the OAM2 table for the marker when outside of the 0-255 coordinate
    ; region. This routine is called every frame.
    sep #$10                ; set 8-bit x,y mode.
    ldx $15ff               ; load current ex-map state.
    ; State 1 - Mid-right.
    cpx #$01 : bne +        ; Check if state is 1.
    sec : sbc #$0010        ; Orient marker.
    bra ++
    +:
    ; State 2 - Far-right.
    cpx #$02 : bne +        ; Check if state is 2.
    bra ++                  ; No need to orient marker.
    +:
    ; State 3 - Mid-left.
    cpx #$03 : bne +        ; Check if state is 3.
    clc : adc #$00d0        ; orient marker.
    bra ++
    +:
    ; State 4 - Far-left.
    cpx #$04 : bne ++       ; Check if state is 4.
    clc : adc #$00c0        ; orient marker.
    ++:
    sep #$20                ; set 8-bit a mode.
    pha                     ; push x-coordinate (can't transfer or it affects the negative flag).
    bmi +                   ; Check if in negative range.
    ; Negative range (-1 to -256):
    lda #$01                ; Load bit to set.
    ora $6d30               ; OR with current value in OAM2 to set bit.
    bra ++
    +
    ; positive range (0 to 255):
    lda #$fe                ; Load bit to unset.
    and $6d30               ; AND with current value in OAM2 to clear bit.
    ++
    sta $6d30               ; store back in OAM2.
    pla                     ; pop x-coordinate.
    rep #$30                ; set 16-bit a,x,y mode.
    rtl
}

pushpc
{
    %jsl_nop2($ee202f, mmap_set_cfg)        ; Cycles ex-map states.
    %jsl($ee4153, mmap_apply_cfg)           ; Loads initial mini-map offset based on current ex-map state.
    %jsl_nop2($ee4164, mmap_set_map_loc)    ; Sets map sprite x-address and OAM2 table entries.
    %jsl($ee41c7, mmap_set_marker_loc)      ; Sets marker x-address and OAM2 table entry.
}
pullpc

;===================================================================
; Section:
; @ BG Buffer Size
;
; Description:
;   Buffer size modifications.
;
; - Increase buffer size.
; - Keep BG in 512x256 mode during full screen buffer updates.
; - Remove pixel masks for screen edges.
;
pushpc
{
    ; Modify buffers to be 512x256.
    %lda($c005b7, #$49)     ; BG1 - main
    %lda($c03f1f, #$49)     ; BG1 - main
    %lda($c005bc, #$51)     ; BG2 - main
    %lda($c03f2d, #$51)     ; BG2 - main
    %lda($c005c1, #$59)     ; BG3 - main
    %lda($c03f49, #$59)     ; BG3 - main
    ;%lda($c03f17, #$41)    ; BG1 - msgbox
    ;%lda($c03f3b, #$45)    ; BG2 - text
    ; Keep register size at 512x256 during disabled buffer swap by flipping the first bit high.
    ; Disable store back of "new" buffer address to a memory location used for address computations.
    %eor_nop3($c03f63)      ; BG1
    %eor_nop3($c03f83)      ; BG2
    %eor_nop3($c03fa3)      ; BG3
    ; Remove pixel masking along edges.
    %lda($c005e7, #$00)     ; left coordinate: town/dungeon.
    %lda($c005ec, #$ff)     ; right coordinate: town/dungeon.
    %lda($ee9003, #$00)     ; left coordinate: overworld.
    %lda($ee9008, #$ff)     ; right coordinate: overworld.
    ;%lda($d4cdc6, #$00)    ; left coordinate: load menu.
    ;%lda($d4cdce, #$ff)    ; right coordinate: load menu.
}
pullpc

;===================================================================
; Section:
; @ BG Scroll Registers
;
; Description:
;   Scrolling modifications.
;
; - Remove 8-pixel shift on sprites.
; - Remove 8-pixel shift of scroll registers.
; - Start x-scrolling when character is 13 columns into the map.
; - Stop x-scrolling when character is 13 from the end of the map.
; - Change x-camera start to +16*4 coordinates.
;

pushpc
{
    ; Remove 8 pixel shift to left for x-scroll registers.
    %nop4($c042e1)          ; BG1
    %nop4($c042ba)          ; BG2
    %nop4($c04317)          ; BG2
    %nop4($c0434d)          ; BG3
    ; Changes tilemap x-scrolling to begin at 13 tiles in instead of 8.
    org $c07e32             ; BG1, BG2, BG3
    nop
    cmp #$0c                ; Switch comparison to 13.
    ; Changes tilemap x-scrolling to end 5 tiles sooner.
    org $c017a3
    sbc #$0c
    ; Change pivot on load
    %lda($c0179a, #$0c)
}
pullpc

;===================================================================
; Section:
; @ BG Full Updates
;
; Description:
;   Full buffer update modifications. Only used when needing to update
;   on-screen elements in an existing buffer?
;
; - Disable buffer swapping during full screen buffer updates.
; - Modify tile data loaded for wrap around areas.
; - Modify DMA location depending on where character is located on the screen.
;
; FF6 uses a back-buffers normally for full-screen updates, but there isn't
; enough BRAM to house 512x256 front and back buffers without snes VRAM
; expansion (128KB). It is not-clear whether the back buffers are necessary.
;
; BG1 buffers: 0x4800 or 0x4c00 - swapped on opening doors and chests.
; BG2 buffers: 0x5000 or 0x5400 - swapped in cave?
; BG3 buffers: 0x5800 or 0x5c00 - swapped sometime?
;
; Entering an area resets buffer pointers to the first location.
;
macro full_tile_pivot_algo(addr)
    ; Modifies the pivot location. Zeros out if underflow due to the pivot being in the
    ; right half of the buffer so the first half just updates starting at 0x0. Computes
    ; a normalization factor to figure out when wrap-around occurs during tile buffering
    ; I.e. when shifting from the right side of the buffer back to the left side.
    sbc #$0b                ; -11 instead of -7.
    bpl +                   ; Check for underflow (below 0)
    lda #$00                ; Set to zero if underflow.
    +:
    and <addr>              ; Original instruction.
    tax
    rep #$20    ; e220      ; set 16-bit accum mode.
    and #$ffe0              ; clamp low-bits of tile start index (every 32).
    sta $3f7ffe             ; store wrap-around normalization factor.
    sep #$20    ; e220      ; set 8-bit accum mode.
    txa
    rtl
endmacro

macro full_tile_pivot(loc, piv)
    pushpc
    {
        org <loc>
        jsl +                ; Modify pivot.
        skip +$07
        nop #2               ; clobbers an eor #$04 buffer addr update.
        skip +$09
        and #$5f             ; corrects dest start location.
    }
    pullpc
    +: %full_tile_pivot_algo(<piv>)
endmacro

macro full_tile_ld_algo(src, dest)
    ; Buffers tiles for an entire 512x256 BG on a per tile basis. This
    ; is modified logic to account for storing data to two non-contigious
    ; buffers in VRAM (thanks SNES VRAM address space).
    lda ($2a)               ; load tile value.
    rep #$20                ; clear 8-bit accum mode.
    tyx                     ; transfer dest offset to x.
    phx                     ; push dest offset.
    asl                     ; compute y offset.
    tay                     ; transfer src offset to y.
    pha                     ; push tile index.
    txa                     ; transfer dest offset to a.
    bit #$0040              ; check if in left or right buffer (>#$64 offset).
    beq +                   ; branch if in left buffer.
    ; Right buffer - shift offset.
    clc                     ; in second buffer.
    adc #$07c0              ; shift offset to second buffer.
    tax                     ; transfer updated offset to x.
    +: ; left buffer - no shift.
    ; Check wrap-around.
    lda $2a                 ; load tile addr index.
    sec                     ; set carry.
    sbc $3f7ffe             ; subtract pre-computed wrap-around normalization factor.
    and #$0020              ; check if in wrap-around area.
    beq +                   ; branch if NOT in wrap-around coord area.
    txa                     ; transfer dest addr to accum.
    sec                     ; set carry.
    sbc #$0080              ; subtract 64 to shift dest up a row for wrap-around tiles.
    tax                     ; transfer updated offset to x.
    +:
    ; Store 16x16 tile values to buffer.
    pla                     ; Pop tile value.
    lda <src>, y
    sta <dest>, x
    lda <src>+512, y
    sta <dest>+2, x
    lda <src>+1024, y
    sta <dest>+64, x
    lda <src>+1536, y
    sta <dest>+66, x
    clc                     ; clear-carry otherwise math fails after return.
    plx                     ; restore dest addr (before we modded it).
    txa                     ; transfer dest addr to accum.
    rtl                     ; return.
endmacro

macro full_tile_ld(loc, piv, src, dest)
    ; Row DMA for second half of BG buffers.
    %full_tile_pivot(<loc>, <piv>)
    pushpc
    org <loc>+$16
    and #$5f                ; corrects dest start location.
    skip +$1d
    lda #$20                ; Double the amount of columns looped.
    skip +$08
    jsl ++                  ; Modify column load locations.
    bra +$1a                ; Jump past old leftover load/store tile logic.
    skip +$1d
    nop #3                  ; Remove destination clipping.
    pullpc
    ++: %full_tile_ld_algo(<src>, <dest>)
endmacro

; BG1 full tile load mods.
%full_tile_ld($c01f2c, $86, $c000, $3d6000)
; BG2 full tile load mods.
%full_tile_ld($c01fe9, $88, $c800, $3d7000)
; BG3 full tile load mods (mostly uses the row update code).
%full_tile_pivot($c020a6, $8a)

;----

macro dma_cpy(src, dest, off)
    ; DMA for second half of BG buffers.
    lda #$01                ; 1 -> a.
    sta $420b               ; Initiate DMA transfer.
    stz $420b               ; Clear DMA transfer flag.
    stx $4305               ; set amount of bytes to transfer.
    ldx <src>               ; load second half of tile buffer.
    stx $4302               ; set DMA src addr.
    rep #$20                ; clear 8-bit accum mode.
    lda <dest>              ; load dest addr.
    clc                     ; clear carry.
    adc <off>               ; add 0x400 (offset to 2nd half of buf).
    sta $2116               ; set DMA dest addr.
    lda #$0001              ; 1 -> a.
    sep #$20                ; set 8-bit accum mode.
    sta $420b               ; Initiate DMA transfer.
    rtl                     ; return.
endmacro

macro full_dma_cpy(loc, src, dest, bank)
    ; Row DMA for second half of BG buffers.
    pushpc
    org <loc>
    ldx <src>               ; Change src addr for DMA to new top buffer.
    skip +$03
    lda <bank>              ; Change bank addr for DMA to new top buffer.
    skip +$0c
    jsl +                   ; Call a second DMA operation for top buf (right half).
    nop
    skip +$22
    ldx <src>+$400          ; Change src addr for DMA to new bottom buffer.
    skip +$03
    lda <bank>              ; Change bank addr for DMA to new bottom buffer.
    skip +$0c
    jsl ++                  ; Call a second DMA operation for bottom buf (right half).
    nop
    pullpc
    +:  %dma_cpy(<src>+$800, <dest>, #$400)
    ++: %dma_cpy(<src>+$c00, <dest>, #$600)
endmacro

; BG1 DMA copy (not inline - requires a jump).
%full_dma_cpy($c01d0a, #$6000, $91, #$3d)
; BG2 DMA copy (not inline - requires a jump).
%full_dma_cpy($c01d76, #$7000, $97, #$3d)
; BG3 DMA copy (not inline - requires a jump).
%full_dma_cpy($c01de2, #$d9c0, $9d, #$7f)

;===================================================================
; Section:
; @ BG Y Movement Updates
;
; Description:
;   Contains Row/Vertical/Y movement modifications (also used when entering new areas).
;
; - Change buffer locations to allow enough room for full copies.
; - Preload additional row tile data into spots of RAM located
;   contigously below the originally loaded data.
; - Insert an additional DMA for writing second half of TileMaps to VRAM.
; - Adjust code where necessary for clamping and doubling interations.
; - Optimize tile loading algorithms to fit inline (no need for jmps).
; - DMA requires external subroutines (jmps required).
;
macro row_tile_ld_bg12(src, dest)
    ; Row load algorithm that adds support for buffering
    ; 64x2, 8 by 8 sized tiles for BG1 & BG2. Of note,
    ; this essentially adds 64 to the dest offset if the
    ; dest offset >= 0x40. This is due to the fact that
    ; the left and right sides of a 512x512 vram buffers
    ; do not have a contiguous address space on the snes.
    ; Additionally, this also utilizes 16-bit x&y mode to
    ; the remove unnecessary branching. It has been
    ; optimized to fit within the original algorithms
    ; size constraints so no jumps are necessary.
    sbc #$0b                ; pivot of -11 instead of -7.
    skip +$06
    and #$1f                ; Clip store offset high bit for BG1, BG2, & BG3 buffers.
    skip +$05
    lda #$20                ; Double loop iterations for copying data to BG1, BG2, & BG3 internal buffers (Non-vram).
    skip +$08
    phy                     ; push original dest.
    tyx                     ; transfer dest to y->x (so we can reorder y and x for long stas).
    tay                     ; transfer src offset a->y.
    txa                     ; transfer dest offset x -> a.
    ; Address shift check for right buffer.
    cmp #$40                ; compare dest to 0x40.
    bcc +                   ; jump if less than 0x40.
    clc                     ; clear carry.
    adc #$40                ; add 0x40 to shift to right buffer.
    +
    tax                     ; a -> x.
    tya                     ; pop src offset.
    rep #$30                ; set 16-bit accum mode.
    asl                     ; lshift src offset (16-bit shift).
    tay                     ; move src offset to x.
    ; Load / Store tile.
    lda <src>, y
    sta <dest>, x
    lda <src>+512, y
    sta <dest>+2, x
    lda <src>+1024, y
    sta <dest>+64, x
    lda <src>+1536, y
    sta <dest>+66, x
    sep #$10                ; set x&y to 8-bit mode.
    ply                     ; pop original dest.
    bra +$1e
    skip +$24
    and #$7f                ; Clip high bit for roll around of BG1, BG2 buffers addresses.
endmacro

row_tile_ld_bg3_shf:
    ; BG3 row load helper subroutine that contains the logic
    ; for shifting the buffer location to the right buffer
    ; and computing wrap around for full-loads. Necessary,
    ; This is necessary because full loads use the row logic
    ; for BG3. The original code worked without branching
    ; because the buffer was contiguous so bitwise operations
    ; worked.
    pha                     ; Optimized from 2 byte instruction (sta).
    and #$003f              ; Original instruction.
    tax                     ; Original instruction.
    ; Check if full or row load.
    lda $00055c             ; address is non-zero for full-load.
    cmp #$0000              ;
    beq ++                  ; branch if row-load.
    ; START full load logic.
    ; Address shift check for right buffer.
    tya                     ; transfer dest offset y->a.
    bit #$0040              ; compare dest to 0x40.
    beq +                   ; jump if less than 0x40.
    clc                     ; clear carry.
    adc #$07c0              ; add 0x07c0 to shift to right buffer (further shift than for a row load).
    tay                     ; transfer dest offset a->y.
    +:
    ; Check wrap-around.
    lda $2a                 ; load tile addr index.
    sec                     ; set carry.
    sbc $3f7ffe             ; subtract pre-computed wrap-around normalization factor.
    and #$0020              ; check if in wrap-around area.
    beq .end                ; branch if NOT in wrap-around coord area.
    tya                     ; transfer dest addr to accum.
    sec                     ; set carry.
    sbc #$0080              ; subtract 64 to shift dest up a row for wrap-around tiles.
    tay                     ; transfer updated offset to x.
    bra .end                ; branch to end.
    ; END full load logic.
    ++:
    ; START row load logic.
    tya                     ; transfer dest offset y->a.
    bit #$0040              ; compare dest to 0x40.
    beq .end                ; jump if less than 0x40.
    clc                     ; clear carry.
    adc #$0040              ; add 0x40 to shift to right buffer.
    tay                     ; transfer dest offset a->y.
    ; END row load logic.
    .end:
    pla                     ; Optimized from 2 byte instruction (lda).
    rtl

macro row_tile_ld_bg3()
    ; Row load algorithm that adds support for buffering
    ; 64x2, 8 by 8 sized tiles for BG3. It has been
    ; optimized to fit within the original algorithms
    ; size constraints so no jumps are necessary.
    sbc #$0b                ; pivot of -11 instead of -7.
    skip +$18
    and #$1f                ; Clip store offset high bit for BG3.
    skip +$16
    lda #$20                ; Double loop iterations for copying data to BG3 internal buffers (Non-vram).
    skip +$08
    phy                     ; push original dest (right buf for addr shift).
    lda $8000,x             ; Original  instruction.
    rep #$20                ; Original  instruction.
    jsl row_tile_ld_bg3_shf ; Contains the logic for shifting to the right buffer and wrap-around.
    and #$00c0              ; Original  instruction.
    ora $36                 ; Original  instruction.
    sta $20                 ; Original  instruction.
    txa                     ; Moved     instruction (use to be repeated).
    asl                     ; Moved     instruction (use to be repeated).
    asl                     ; Moved     instruction (use to be repeated).
    sta $22                 ; Optimized instruction (removes later lda).
    lda $d000, x            ; Original  instruction.
    and #$001c              ; Original  instruction.
    ora $20                 ; Original  instruction.
    xba                     ; Original  instruction.
    ora $22                 ; Optimized instruction (lda removed here).
    pha                     ; Optimized instruction (pla later to remove duplicate code).
    and #$c000              ; Original  instruction.
    cmp #$4000              ; Original  instruction.
    beq +                   ; Original  instruction.
    cmp #$8000              ; Original  instruction.
    beq ++                  ; Original  instruction.
    cmp #$c000              ; Original  instruction.
    beq +++                 ; Original  instruction.
    ; Load / Store tile.
    pla                     ; Optimized instruction.
    sta $d9c0, y : inc      ; Moved buffer (expanded for widescreen).
    sta $d9c2, y : inc      ; Moved buffer (expanded for widescreen).
    sta $da00, y : inc      ; Moved buffer (expanded for widescreen).
    sta $da02, y            ; Moved buffer (expanded for widescreen).
    bra ++++                ; Original  instruction.
    +:
    pla                     ; Optimized instruction.
    sta $d9c2, y : inc      ; Moved buffer (expanded for widescreen).
    sta $d9c0, y : inc      ; Moved buffer (expanded for widescreen).
    sta $da02, y : inc      ; Moved buffer (expanded for widescreen).
    sta $da00, y            ; Moved buffer (expanded for widescreen).
    bra ++++
    ++:
    pla                     ; Optimized instruction.
    sta $da00, y : inc      ; Moved buffer (expanded for widescreen).
    sta $da02, y : inc      ; Moved buffer (expanded for widescreen).
    sta $d9c0, y : inc      ; Moved buffer (expanded for widescreen).
    sta $d9c2, y            ; Moved buffer (expanded for widescreen).
    bra ++++
    +++:
    pla                     ; Optimized instruction.
    sta $da02, y : inc      ; Moved buffer (expanded for widescreen).
    sta $da00, y : inc      ; Moved buffer (expanded for widescreen).
    sta $d9c2, y : inc      ; Moved buffer (expanded for widescreen).
    sta $d9c0, y            ; Moved buffer (expanded for widescreen).
    ++++:
    lda $00055c
    tay
    pla                     ; pop original dest (right buf for addr shift).
    inc #4                  ; original instructions.
    cpy #$0000              ; Check if full-load or row load.
    bne +                   ; branch on full load.
    and #$ff7f              ; Clip high bit for roll around of BG3 buffers addresses (for tile-loads).
    bra ++
    +:
    nop
    ++:
endmacro

pushpc
{
    ; BG1 Row Tile Load (inline replace):
    org $c0218c
    %row_tile_ld_bg12($c000, $3d6000)
    ; BG2 Row Tile Load (inline replace):
    org $c02307
    %row_tile_ld_bg12($c800, $3d7000)
    ; BG3 Row Tile Load (inline replace):
    org $c02477
    %row_tile_ld_bg3()
}
pullpc

;----

macro row_dma_cpy(loc, src, dest, bank)
    ; Row DMA for second half of BG buffers.
    pushpc
        org <loc>
        ldx <src>           ; Change address.
        skip +$03
        lda <bank>          ; Change bank.
        skip +$0c
        jsl +               ; Call additional copy.
        nop
    pullpc
    +: %dma_cpy(<src>+$80, <dest>, #$400)
endmacro

; BG1 DMA copy (not inline - requires a jump).
%row_dma_cpy($c02a5e, #$6000, $91, #$3d)
; BG2 DMA copy (not inline - requires a jump).
%row_dma_cpy($c02ae1, #$7000, $97, #$3d)
; BG3 DMA copy (not inline - requires a jump).
%row_dma_cpy($c02b64, #$d9c0, $9d, #$7f)


;===================================================================
; Section:
; @ BG X Movement Updates
;
; Description:
;   Column/Horizontal/X movement modifications.
;
; - Modify Load location of column tiles when moving right (+16 columns).
; - Modify the store location for VRAM to place column tiles in the second
;   half of the buffer for certain coordinate ranges (16-31, 48-63, etc.).
;
; This expands the logic to load data +16 columns from what it
; originally did when moving left. The data will then get picked up
; during DMA.
;
; Modifies the store location for VRAM to place column tiles in the second
; half of the buffer (16-63, 96-127, etc.) for certain coordinate ranges.
; Otherwise, it keeps placing data from columns 0 to 31. Internally, it
; preloads 0x48XX address which needs to be swapped to 0x4CXX for loading
; in the correct columns.
;
; The max possible coordinate in a map is 127 or 0x7F before they loop
; around so coordinates need clamped after that.
;
macro col_dma_adr_mod_algo(src, dest1, dest2, pivot)
    ; Modify VRAM store location for certain coordinate ranges (32-63, 96-127, etc.).
    pha                     ; push a
    rep #$21                ; set 16-bit accumulator mode.
    lda $73                 ; Load movement offset.
    adc $0547               ; Add unknown to it (this is what the original code does).
    bpl +                   ; Branch if positive (indicates right movement).
    ; left direction:
    tdc                     ; Clear accumulator.
    sep #$20                ; set 8-bit accumulator mode.
    lda <pivot>             ; register with vertical pivot coordinate.
    inc                     ; add 1 if moving in left direction
    bra ++                  ; jump for right direction
    +:
    ; right direction:
    tdc                     ; Clear accumulator.
    sep #$20                ; set 8-bit accumulator mode.
    lda <pivot>             ; register with vertical pivot coordinate.
    ++:
    sec                     ; set carry for subtraction
    sbc #$0c                ; normalize subtract 12
    and #$10                ; normalize
    cmp #$00                ; 0 result implies we should use original coordinates. 1 result implies we should shift to the second vram location.
    bne +
    pla                     ; restore a.
    bra ++
    +:
    pla                     ; drop a.
    lda <src>               ; Load modified vram location.
    ++:
    sta <dest1>
    sta <dest2>
    rtl
endmacro

macro col_dma_adr_mod(loc1, loc2, loc3, src, dest1, dest2, pivot)
    ; Row DMA for second half of BG buffers.
    pushpc
        org <loc1>
        adc #$14            ; moving right +20 instead of 8. Why? Seems to be 0xc added.
        org <loc2>
        sbc #$0b            ; moving left -11 instead of -7.
        org <loc3>
        jsl +               ; DMA address modification.
    pullpc
    +: %col_dma_adr_mod_algo(<src>, <dest1>, <dest2>, <pivot>)
endmacro

; BG1 DMA addr modification. ; 0x4c is the high-byte of the right buffer.
%col_dma_adr_mod($c02220, $c0222b, $c022ca, #$4c, $94, $96, $0541)
; BG2 DMA addr modification. ; 0x54 is the high-byte of the right buffer.
%col_dma_adr_mod($c0239b, $c023a6, $c02449, #$54, $9a, $9c, $0543)
; BG3 DMA addr modification. ; 0x5c is the high-byte of the right buffer.
%col_dma_adr_mod($c02569, $c02578, $c02657, #$5c, $a0, $a2, $0545)
