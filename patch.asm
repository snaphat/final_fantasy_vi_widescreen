hirom

org  $c3f091 : fillbyte $ff
fill 3951

org  $c3f091


;===================================================================
; Registers:
;
;   $5c   - H-scroll value of BG1.
;   $64   - H-scroll value of BG2.
;   $6c   - H-scroll value of BG3.
;
;   $73   - x-movement direction offset (non-controller).
;
;   $86   - Max x coordinate for BG1.
;   $88   - Max x coordinate for BG2.
;   $8a   - Max x coordinate for BG3.
;
;   $91   - low byte of  BG1 DMA buffer address for y-movement and fullscreen updates.
;   $92   - high byte of BG1 DMA buffer address for y-movement and fullscreen updates.
;   $94   - high byte of BG1 DMA buffer address for x-movement updates.
;   $96   - high byte of BG1 DMA buffer address for x-movement updates (extra?).
;
;   $97   - low byte of  BG2 DMA buffer address for y-movement and fullscreen updates.
;   $98   - high byte of BG2 DMA buffer address for y-movement and fullscreen updates.
;   $9a   - high byte of BG2 DMA buffer address for x-movement updates.
;   $9c   - high byte of BG2 DMA buffer address for x-movement updates (extra?).
;
;   $9d   - low byte of  BG3 DMA buffer address for y-movement and fullscreen updates.
;   $9e   - high byte of BG3 DMA buffer address for y-movement and fullscreen updates.
;   $a0   - high byte of BG3 DMA buffer address for x-movement updates.
;   $a2   - high byte of BG3 DMA buffer address for x-movement updates (extra?).
;
;   $0541 - BG1 current x-coordinate pivot.
;   $0542 - BG1 current y-coordinate pivot.
;
;   $0543 - BG2 current x-coordinate pivot.
;   $0544 - BG2 current y-coordinate pivot.
;
;   $0545 - BG3 current x-coordinate pivot.
;   $0546 - BG3 current y-coordinate pivot.
;
;   $0547 - Added to $73 -- dunno.
;
;   $062c - X-Scroll start + Camera start?
;
;   $0960 - exact character x-offset in pixels.
;   $0963 - exact character y-offset in pixels.
;
;   $0970 - character x position
;   $0971 - character y position.
;
;   $0974 - current controller movement direction. 0 if controller isn't initiating movement.
;   $0975 - current controller movement direction (stored). 0 if controller isn't initiating movement.
;
;   0x7e0500 - Location of table data written to OAM.
;   0x7e81b3 - Location of buffer looping values (switches on hsync intervals?).
;
; VRAM address map (original) (assuming 8-bit word size):
;   $0000 - $5fff  - Tile data (BG1 & BG2).
;   $6000 - $7fff  - Tile data (BG3).
;   $8000 - $87ff  - Message Borders (BG1).
;   $8800 - $8fff  - Message Text (BG3) (Top and bottom half are duplicates).
;   $9000 - $97ff  - Bottom Layer Tiles (BG1).
;   $9800 - $9fff  - Bottom Layer Tiles Alt (BG1).
;   $a000 - $a7ff  - Top Layer Tiles (BG2).
;   $a800 - $afff  - Top Layer Tiles Alt (BG2).
;   $b000 - $b7ff  - Effects (BG3).
;   $b800 - $bfff  - Effects Alt (BG3).
;   $c000 - $dfff  - Sprite Locations (OAM).
;   $e000 - $ffff  - Sprite Data (OAM).
;
; VRAM address map (Wide-screen) (assuming 8-bit word size):
;   $0000 - $5fff  - Tile data (BG1 & BG2).
;   $6000 - $7fff  - Tile data (BG3).
;   $8000 - $87ff  - Message Borders (BG1).
;   $8800 - $8fff  - Message Text (Top and bottom half are duplicates) (BG3).
;   $9000 - $9fff  - Ground Tiles (Expanded) (BG1).
;   $a000 - $afff  - Roof Tiles (Expanded) (BG2).
;   $b000 - $bfff  - Effects (Expanded) (BG3).
;   $c000 - $dfff  - Sprite Locations (OAM).
;   $e000 - $ffff  - Sprite Data (OAM).
;
; Walk through walls cheat:
;   Raw: C04E4E:EA+C04E4F:EA+C04E57:EA+C04E58:EA+C04E6A:EA+C04E6B:EA+C04E73:EA+C04E74:EA+C04E7E:EA+C04E7F:EA+C04E86:EA+C04E87:EA+C04E8D:EA+C04E8E:EA+C04EA9:80
;   Game Genie: 3C00-8767+3C00-87A7+3C09-8FA7+3C09-84D7+3C01-8467+3C01-84A7+3C05-8DA7+3C05-8FD7+3C05-8767+3C05-87A7+3C06-8F67+3C06-8FA7+3C06-8707+3C06-8767+6D0C-8407
;

;===================================================================
; Description:
;
; Stack modifications...
;
; - Reserve stack space for patch usage. (Perhaps unnecessary)
;

;pushpc
;{
;   org $c00020         ; Reserve stack space (originally #15ff)
;   ldx #$14ff
;
;}
;pullpc

;===================================================================
; Description (BG1, BG2, & BG3):
;
; Buffer size modifications...
;
; - Increase buffer size.
; - Remove pixel masks for screen edges.
;

pushpc
{
    ; Modify buffers to be 512x256.
    org $c005b7             ; BG1
    lda #$49
    org $c03f1f             ; BG1
    lda #$49
    org $c005bc             ; BG2
    lda #$51
    org $c03f2d             ; BG2
    lda #$51
    org $c005c1             ; BG3
    lda #$59
    org $c03f49             ; BG3
    lda #$59
    ;org $c03f17             ; BG1 - msgbox
    ;lda #$41
    ;org $c03f3b             ; BG2 - text
    ;lda #$45
    ; Remove pixel masking along edges.
    org $c005e7             ; left coordinate: town/dungeon.
    lda #$00
    org $c005ec             ; right coordinate: town/dungeon.
    lda #$ff
    org $ee9003             ; left coordinate: overworld.
    lda #$00
    org $ee9008             ; right coordinate: overworld.
    lda #$ff
    ;org $d4cdc6             ; left coordinate: load menu.
    ;lda #$00
    ;org $d4cdce             ; right coordinate: load menu.
    ;lda #$ff
}
pullpc

;===================================================================
; Description (OAM):
;
; Sprite Drawing boundary expansion...
;
pushpc
{
    ; ----
    ; Shift removal code:
    ; ----
    ; Remove 8 pixel shift for regular sprites.
    org $c05bb2 ; OAM
    nop #4
    ; Remove 8 pixel shift for large chocobo sprites.
    org $c060e4
    nop #4
    ; Remove 8 pixel shift for large esper sprites.
    org $c06579
    nop #4
    ; Remove 8 pixel shift for extra large magitek armor sprites.
    org $c05d67
    jsl rm_lrg_sprite_shft
    ; ----
    ; Load expansion code:
    ; ----
    ; Expand draw bounds for regular sprites.
    org $c05bee
    nop                     ; xba that is now located in the jump.
    org $c05bb9
    jsl exp_draw_bnds_reg_sprite
    nop
    ; Expand draw bounds for large chocobo sprites.
    org $c06112
    cpy #$01a0              ; shift the boundary to load/unload sprites directly at the wide-screen pivot location.
    org $c06117
    cpy #$ffa0              ; shift the boundary to load/unload sprites directly at the wide-screen pivot location.
    ; Expand draw bounds for large esper sprites.
    org $c065b6
    cpx #$ffa0              ; shift the boundary to load/unload sprites directly at the wide-screen pivot location.
    org $c065bb
    cpx #$01a0              ; shift the boundary to load/unload sprites directly at the wide-screen pivot location.
    ; Expand draw bounds for extra large magitek armor sprites.
    org $c05d99
    cpy #$01a0              ; shift the boundary to load/unload sprites directly at the wide-screen pivot location.
    org $c05d9e
    cpy #$ffa0              ; shift the boundary to load/unload sprites directly at the wide-screen pivot location.
}
pullpc

;----

rm_lrg_sprite_shft:
{
    ; Subtract 8 from large sprite location.
    sbc $5c
    sec
    sbc #$0008
    sta $1e
    rtl
}

;----

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

;===================================================================
; Description (BG1, BG2, & BG3):
;
; Scrolling modifications...
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
    org $c042e1             ; BG1
    nop #4
    org $c042ba             ; BG2
    nop #4
    org $c04317             ; BG2
    nop #4
    org $c0434d             ; BG3
    nop #4
    ; Changes tilemap x-scrolling to begin at 13 tiles in instead of 8.
    org $c07e32             ; BG1, BG2, BG3
    nop
    cmp #$0c                ; Switch comparison to 13.
    ; Changes tilemap x-scrolling to end 5 tiles sooner.
    org $c017a3
    sbc #$0c
    ; Change pivot on load
    org $c0179a
    lda #$0c
}
pullpc

;===================================================================
; Description (BG1, BG2):
;
; full buffer update modifications (only used when needing to update on-screen elements in an existing buffer)...
;
; - Disable buffer swapping during full screen buffer updates.
; - Keep BG in 512x256 mode during full screen buffer updates.
; - Modify tile data loaded for wrap around areas.
; - Modify DMA location depending on where character is located on the screen.
;
; FF6 uses a back-buffer normally, but there doesn't appear to be enough
; VRAM to house both a 512x256 front and back buffer. It is not-clear with
; the back buffer is really necessary. Moreover, it doesn't appear that two
; buffers fit into VRAM memory with a 512x256 tilemap, so the secondary buffer
; must be disabled unless expanded (128KB+) VRAM becomes supported in bsnes-hd.
;
; Internally, ff6 appears to use BG1 VRAM buffer addresses high-word with
; ORing logic to determine what the BG1SC (2107) register should be set to.
; The address is either 0x4800 or 0x4c000 depending on whether a buffer swap
; has occurred. The pointer updates when opening doors or chests (and probably
; during other events?). Exiting an area will reset the pointer to 0x4800. For
; a 512x256 tilemap size, the low-bit of the BGSC1 register needs to be high.
;
; Internally, ff6 appears to use BG2 VRAM buffer addresses high-word with
; ORing logic to determine what the BG2SC (2108) register should be set to.
; The address is either 0x5000 or 0x54000 depending on whether a buffer swap
; has occurred. The pointer updates when in caves and ????????????????????????
; ?????????????????????? Exiting an area will reset the pointer to 0x5000. For
; a 512x256 tilemap size, the low-bit of the BGSC2 register needs to be high.
;
; Internally, ff6 appears to use BG3 VRAM buffer addresses high-word with
; ORing logic to determine what the BG3SC (2109) register should be set to.
; The address is either 0x5800 or 0x5c000 depending on whether a buffer swap
; has occurred. The pointer updates when ?????????????????????????????????????
; ?????????????????????? Exiting an area will reset the pointer to 0x5800. For
; a 512x256 tilemap size, the low-bit of the BGSC3 register needs to be high.
;

pushpc
{
    ; Keep register size at 512x256 during disabled buffer swap by flipping the first bit high.
    ; Disable store back of "new" buffer address to a memory location used for address computations.
    org $c03f63             ; BG1
    eor #$01
    nop #3
    org $c03f83             ; BG2
    eor #$01
    nop #3
    org $c03fa3             ; BG3
    eor #$01
    nop #3
    ; Modify pivot.
    org $c01f2c             ; BG1
    jsl full_tile_pivot_bg1
    org $c01fe9             ; BG2
    jsl full_tile_pivot_bg2
    org $c020a6             ; BG3
    jsl full_tile_pivot_bg3
    ; Modify column load locations.
    org $c01f6b             ; BG1
    jsl full_tile_ld_bg1
    org $c02028             ; BG2
    jsl full_tile_ld_bg2
    ;org $000000             ; BG3 : Seems to use the row load code instead.
    ;jsl full_tile_ld_bg3
    ; Modify DMA store location.
    org $c01f37             ; BG1 : clobbers an eor #$04 buffer addr update.
    jsl full_dma_cpy_bg1
    org $c01ff4             ; BG2 : clobbers an eor #$04 buffer addr update.
    jsl full_dma_cpy_bg2
    org $c020b1             ; BG3 : clobbers an eor #$04 buffer addr update.
    jsl full_dma_cpy_bg3
pullpc

;----

macro full_tile_pivot(addr)
    ; Modifies the pivot location. Zeros out if underflow due to the pivot being in the right half of the buffer
    ; so the first half just updates starting at 0x0.
    sbc #$0b                ; -11 instead of -7.
    bpl .end                ; Check for underflow (below 0)
    lda #$00                ; Set to zero if underflow.
    .end:
    and <addr>              ; Original instruction.
    rtl
endmacro

full_tile_pivot_bg1:
{
    %full_tile_pivot($86)
}

full_tile_pivot_bg2:
{
    %full_tile_pivot($88)
}

full_tile_pivot_bg3:
{
    %full_tile_pivot($8a)
}

macro full_tile_ld(src, test)
    ; Modify column location (+16) for certain coordinate ranges depending on whether the character
    ; is in the left or right half of the extended buffer. The original logic is broken due to doubling buffer sizes.
    phy         ; 5a        ; store dest addr for later.
    ldy #$0000  ; a00000    ; load additional offset of 0.
    lda <src>   ; a5??      ; Load buffer location (to determine if we are in left or right half of buffer).
    cmp <test>  ; c9??      ; equal implies we are in the left half of the buffer.
    bne +       ; d00a      ; branch if in second half of of buffer.
    ; Left buffer logic check:
    lda $2a     ; a52a      ; load tile column index.
    and #$10    ; 2910      ; normalize.
    cmp #$00    ; c900      ; 1 implies we need to +16 the tile index to account for buffer changes.
    beq .add    ; f00a      ; branch if tile index does need to be incremented.
    bra .end    ; 800b      ; branch if tile index doesn't need to be incremented.
    ; Right buffer logic check (inverted logic):
    +:
    lda $2a     ; a52a      ; load column index.
    and #$10    ; 2910      ; normalize.
    cmp #$00    ; c900      ; 0 implies we need to +16 the tile index to account for buffer changes.
    beq .end    ; d003      ; branch if tile index doesn't need to be incremented.
    .add:
    ldy #$0010  ; a01000    ; add 16 to load offset.
    .end:
    lda ($2a), y; b12a      ; load tile index.
    ply         ; 7a        ; restore  dest addr.
    rep #$20    ; c220      ; clear 8-bit accum mode.
    rtl         ; 6b        ; return.
endmacro

full_tile_ld_bg1:
{
    %full_tile_ld($92, #$4c)
}

full_tile_ld_bg2:
{
    %full_tile_ld($98, #$54)
}

;full_tile_ld_bg3:
;{
;    %full_tile_ld($9a, #$5c)
;}

;----

macro full_dma_cpy(src, dest)
    ; Changes the VRAM store location if current character coordinate is in the second half of BG1 buffer.
    ; In keeping with the original refresh code only a 256x256 area is updated. This may turn out to be
    ; unteniable if the full 512x256 buffer needs to be updated.
    pha         ; 48        ; push original address.
    lda $0970   ; ad7090    ; load register with character x-coordinate.
    and #$10    ; 2910      ; normalize.
    cmp #$00    ; c900      ; Compare.
    bne +       ; d011      ; equal implies we shouldn't change our offset.
    pla         ; 68        ; pop original address.
    bra .end    ; 80??      ; Branch to end.
    +:
    pla         ; 68        ; pop original address.
    lda <src>   ; a9??      ; Load address for second half of BG1 buffer.
    .end:
    sta <dest>  ; 85??      ; Update DMA address.
    rtl         ; 6b        ; Return.
endmacro

full_dma_cpy_bg1:
{
    %full_dma_cpy(#$4c, $92)
}

full_dma_cpy_bg2:
{
    %full_dma_cpy(#$54, $98)
}

full_dma_cpy_bg3:
{
    %full_dma_cpy(#$5c, $9a)
}


;===================================================================
; Description (BG1, BG2, & BG3):
; Row/Vertical/y movement modifications (also used when entering new areas)...
;
; - Preload additional row tile data into new spots of RAM located
;   contigously below the original buffer spots.
; - Insert an additional DMA for writing second half of TileMaps to VRAM.
;
; FIXME: The jump logic here slows down the code a lot. Is there a more efficient way to do this?

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
    ; Row load modifications:
    org $c0218c             ; BG1 - pivot
    sbc #$0b                ; -11 instead of -7.
    org $c02307             ; BG2 - pivot
    sbc #$0b                ; -11 instead of -7.
    org $c02477             ; BG3 - pivot
    sbc #$0b                ; -11 instead of -7.
    ; Call-site modifications: Jump to offset modification routines.
    org $c021a7             ; BG1
    jsl row_tile_ld_bg12
    org $c021d9             ; BG1
    jsl row_tile_ld_bg12
    org $c02322             ; BG2
    jsl row_tile_ld_bg12
    org $c02354             ; BG2
    jsl row_tile_ld_bg12
    org $c024e5             ; BG3
    jsl row_tile_ld_bg3
    org $c024fb             ; BG3
    jsl row_tile_ld_bg3
    org $c02511             ; BG3
    jsl row_tile_ld_bg3
    org $c02527             ; BG3
    jsl row_tile_ld_bg3
    ; Call-site modifications: Jump to offset reverse routines.
    org $c021c3             ; BG1
    jsl rev_row_tile_ld12
    org $c021f5             ; BG1
    jsl rev_row_tile_ld12
    org $c0233e             ; BG2
    jsl rev_row_tile_ld12
    org $c02370             ; BG2
    jsl rev_row_tile_ld12
    org $c0253b             ; BG3
    jsl rev_row_tile_ld3
    ; DMA Copy modifications:
    org $c02a72             ; BG1
    jsl row_dma_cpy_bg1
    nop
    org $c02af5             ; BG2
    jsl row_dma_cpy_bg2
    nop
    org $c02b78             ; BG3
    jsl row_dma_cpy_bg3
    nop
}
pullpc

;----

macro row_tile_ld()
    ; Add 64 to offset if dest offset >= 0x40.
    sep #$20    ; e220      ; set 8-bit accum mode
    pha         ; 48        ; push src offset.
    tya         ; 98        ; y -> a.
    cmp #$40    ; c940      ; compare to 0x40.
    bcc .end    ; 9003      ; jump if less than 0x40.
    clc         ; 18        ; clear carry.
    adc #$40    ; 6940      ; add 0x40.
    .end:
    tay         ; a8        ; a -> y.
    pla         ; 68        ; pop src offset.
endmacro

row_tile_ld_bg12:
{
    %row_tile_ld()
    asl         ; 0a        ; lshift src offset.
    tax         ; aa        ; move src offset to x.
    rep #$20    ; c220      ; clear 8-bit accum mode.
    rtl         ; 6b        ; return
}

row_tile_ld_bg3:
{
    %row_tile_ld()
    rep #$20    ; e220      ; clear 8-bit accum mode
    asl         ; 0a        ; lshift tile data.
    asl         ; 0a        ; lshift tile data.
    ora $22     ; 0522      ; or tile data.
    rtl         ; 6b        ; return
}

;----

macro rev_row_tile_ld()
    ; Reverse above routine.
    ; Subtract 64 from offset if dest offset >= 0x80.
    sep #$20    ; e220      ; set 8-bit accum mode
    cmp #$80    ; c980      ; compare to 0x80.
    bcc .end    ; 9003      ; jump if less than 0x80.
    sec         ; 38        ; set carry.
    sbc #$40    ; e940      ; subtract 0x40.
    .end:
endmacro

rev_row_tile_ld12:
{
    tdc         ; 7b        ; clear a.
    sep #$21    ; e221      ; set 8-bit accum mode.
    tya         ; 98        ; y -> a.
    %rev_row_tile_ld()
    sec         ; 38        ; set carry
    rtl         ; 6b        ; return
}

rev_row_tile_ld3:
{
    %rev_row_tile_ld()
    rep #$20    ; e220      ; clear 8-bit accum mode.
    inc #4      ; 1a        ; inc dest addr.
    rtl         ; 6b        ; return
}

;----

macro row_dma_cpy(dest, src)
                ; DMA for second half of BG buffers.
    lda #$01    ; a901      ; 1 -> a.
    sta $420b   ; 8d0b42    ; Initiate DMA transfer.
    stz $420b   ; 9c0b42    ; Clear DMA transfer flag.
    stx $4305   ; 8e0543    ; set amount of bytes to transfer.
    ldx <dest>  ; a2????    ; load second half of tile buffer.
    stx $4302   ; 8e0243    ; set DMA dest addr.
    rep #$20    ; c220      ; clear 8-bit accum mode.
    lda <src>   ; a5??      ; load src addr.
    clc         ; 18        ; clear carry.
    adc #$0400  ; 690004    ; add 0x400 (offset to 2nd half of buf).
    sta $2116   ; 8d1621    ; set DMA src addr.
    lda #$0001  ; a90100    ; 1 -> a.
    sep #$20    ; e220      ; set 8-bit accum mode.
    sta $420b   ; 8d0b42    ; Initiate DMA transfer.
    rtl         ; 6b        ; return.
endmacro

row_dma_cpy_bg1:
{
    %row_dma_cpy(#$da40, $91)
}

row_dma_cpy_bg2:
{
    %row_dma_cpy(#$e240, $97)
}

row_dma_cpy_bg3:
{
    %row_dma_cpy(#$ea40, $9d)
}

;===================================================================
; Description (BG1, BG2,& BG3):
;
; Column/Horizontal/x movement modifications...
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

pushpc
{
    ; Column load modifications:
    org $c02220             ; BG1 - moving right
    adc #$14                ; +20 instead of 8. Why? Seems to be 0xc added.
    org $c0222b             ; BG1 - moving left
    sbc #$0b                ; -11 instead of -7.
    org $c0239b             ; BG2 - moving right
    adc #$14                ; +20 instead of 8. Why? Seems to be 0xc added.
    org $c023a6             ; BG2 - moving left
    sbc #$0b                ; -11 instead of -7.
    org $c02569             ; BG3 - moving right
    adc #$14                ; +20 instead of 8. Why? Seems to be 0xc added.
    org $c02578             ; BG3 - moving left
    sbc #$0b                ; -11 instead of -7.
    ; DMA copy modifications:
    org $c022ca             ; BG1
    jsl col_dma_cpy_bg1
    org $c02449             ; BG2
    jsl col_dma_cpy_bg2
    org $c02657             ; BG3
    jsl col_dma_cpy_bg3
}
pullpc


;----

macro col_dma_cpy(src, dest1, dest2)
    ; Modify VRAM store location for certain coordinate ranges (32-63, 96-127, etc.).
    pha         ; 48        ; push a
    rep #$21                ; set 16-bit accumulator mode.
    lda $73                 ; Load movement offset.
    adc $0547               ; Add unknown to it (this is what the original code does).
    bpl +                   ; Branch if positive (indicates right movement).
    ; left direction:
    tdc                     ; Clear accumulator.
    sep #$20                ; set 8-bit accumulator mode.
    lda $0541   ; ad4105    ; register with vertical pivot coordinate.
    inc         ; 1a        ; add 1 if moving in left direction
    bra ++      ; 8004      ; jump for right direction
    +:
    ; right direction:
    tdc                     ; Clear accumulator.
    sep #$20                ; set 8-bit accumulator mode.
    lda $0541   ; ad4105    ; register with vertical pivot coordinate.
    ++:
    sec         ; 38        ; set carry for subtraction
    sbc #$0c    ; e90c      ; normalize subtract 12
    and #$10    ; 2910      ; normalize
    cmp #$00    ; c900      ; 0 result implies we should use original coordinates. 1 result implies we should shift to the second vram location.
    bne .upd    ; d003
    pla         ; 68        ; restore a.
    bra .end    ; 8003
    .upd:
    pla         ; 68        ; drop a.
    lda <src>   ; a9??      ; Load modified vram location.
    .end:
    sta <dest1> ; 85??
    sta <dest2> ; 85??
    rtl         ; 6b
endmacro

col_dma_cpy_bg1:
{
    %col_dma_cpy(#$4c, $94, $96) ; 0x4c is the high-byte of the second half of buffer.
}

col_dma_cpy_bg2:
{
    %col_dma_cpy(#$54, $9a, $9c) ; 0x54 is the high-byte of the second half of buffer.
}

col_dma_cpy_bg3:
{
    %col_dma_cpy(#$5c, $a0, $a2) ; 0x5c is the high-byte of the second half of buffer.
}
