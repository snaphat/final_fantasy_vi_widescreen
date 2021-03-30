hirom

org  $c3f091 : fillbyte $ff
fill 3951

org  $c3f091


;===================================================================
; Registers:
; $91   - low byte of BG1 DMA buffer address for y-movement and fullscreen updates.
; $92   - high byte of BG1 DMA buffer address for y-movement and fullscreen updates.
; $94   - high byte of BG1 DMA buffer address for x-movement updates.
; $9a   - high byte of BG2 DMA buffer address for x-movement updates.
; $a2   - high byte of BG3 DMA buffer address for x-movement updates.
; $0541 - BG1 current x-coordinate pivot.
; $0542 - BG1 current y-coordinate pivot.
; $0543 - BG2 current x-coordinate pivot.
; $0544 - BG2 current y-coordinate pivot.
; $0545 - BG3 current x-coordinate pivot.
; $0546 - BG3 current y-coordinate pivot.
; $0960 - exact character offset in pixels?
; $0970 - character x position
; $0971 - character y position.
; $0974 - current movement direction.
; $0975 - last movement direction.
;
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

; Description (BG1):
; Modify full buffer refresh-code. FF6 uses a back-buffer normally, but
; there doesn't appear to be enough VRAM to house both a 512x256 front
; and back buffer. It is not-clear with the back buffer is really necessary.
; Moreover, it doesn't appear that two buffers fit into VRAM memory with a
; 512x256 tilemap, so the secondary buffer must be disabled unless expanded
; (128KB+) VRAM becomes supported in bsnes-hd.
;
; Internally, ff6 appears to use BG1 VRAM buffer addresses high-word with
; ORing logic to determine what the BG1SC (2107) register should be set to.
; The address is either 0x4800 or 0x4c000 depending on whether a buffer swap
; has occurred. The pointer updates when opening doors or chests (and probably
; during other events?). Exiting an area will reset the pointer to 0x4800. For
; a 512x256 tilemap size, the low-bit of the BGSC1 register needs to be high.

pushpc
{
    org $c03f63             ; BG1
    eor #$01                ; Keep BG1SC register size at 512x256 during disabled buffer swap by flipping the first bit high.
    nop #3                  ; Disable store back of "new" buffer address to a memory location used for address computations.
    org $c01f6b             ; BG1
    jsl full_tile_ld_bg1    ; Modify column load locations.
    org $c01f37             ; BG1
    jsl full_dma_cpy_bg1    ; Jump to routine to update the DMA store location if necessary.
pullpc

full_tile_ld_bg1:
{
                ; Modify column location (+16) for certain coordinate ranges depending on whether the character
                ; is in the left or right half of the extended buffer. This is to fix the broken updates.
    phy         ; 5a        ; store dest addr for later.
    ldy #$0000  ; a00000    ; load additional offset of 0.
    lda $92     ; a592      ; Load buffer location (to determine if we are in left or right half of buffer).
    cmp #$4c    ; c948      ; equal implies we are in the left half of the buffer.
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
}


full_dma_cpy_bg1:
{
                ; Changes the VRAM store location if current character coordinate is in the second half of BG1 buffer.
                ; In keeping with the original refresh code only a 256x256 area is updated. This may turn out to be
                ; unteniable if the full buffer needs to be updated.
    pha         ; 48        ; push original address.
    lda $0970   ; ad7090    ; load register with character x-coordinate.
    and #$10    ; 2910      ; normalize.
    cmp #$00    ; c900      ; Compare.
    bne +       ; d011      ; equal implies we shouldn't change our offset.
    pla         ; 68        ; pop original address.
    bra .end    ; 80??      ; Branch to end.
    +:
    pla         ; 68        ; pop original address.
    lda #$4c    ; a94c      ; Load address for second half of BG1 buffer.
    .end:
    sta $92     ; 8592      ; Update DMA address.
    rtl         ; 6b        ; Return.
}

;===================================================================

; Description (BG1, BG2, & BG3):
; Modify buffers to be 512x256.

pushpc
{
    ;
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
}
pullpc

;===================================================================

; Description (BG1, BG2, & BG3):
; Remove pixel masking along edges.

pushpc
{
    ;
    org $c005d0             ; left coordinate.
    lda #$00
    org $c005ec             ; right right coordinate.
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

macro dma(dest, src)
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
    %dma(#$da40, $91)
}

row_dma_cpy_bg2:
{
    %dma(#$e240, $97)
}

row_dma_cpy_bg3:
{
    %dma(#$ea40, $9d)
}

;===================================================================

; Description (BG1 & BG2 & BG3):
; Vertical (y) movement modification...
; Preload additional row tile data.
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
}
pullpc

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
    adc #$0040  ; 694000    ; +16*4
    sta <dest>  ; 85??
    rtl         ; 6b
endmacro

cam_start_bg1:
{
    asl #04     ; 0a
    clc         ; 18
    adc #$0040  ; 694000    ; +16*4
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
; Modify Load location of column tiles when moving right (+16 columns).
; Original logic is used when moving left.
; This expands the logic to load data +16 columns from what it
; originally did when moving left. The data will then get picked up
; during DMA.

pushpc
{
    ; Call-site modifications
    org $c02247             ; BG1
    jsl col_tile_ld_bg12
    org $c023c2             ; BG2
    jsl col_tile_ld_bg12
    org $c0259c             ; BG3
    jsl col_tile_ld_bg3
}
pullpc

macro col_tile_ld()
    ; Add 16 to column offset when moving left.
    lda $0974   ; ad7094    ; Movement direction.
    cmp #$02    ; c902      ; Compare - 0x2 is right direction.
    bne .end    ; d007      ; jump for right direction.
    ; Left direction:
    lda $2a     ; a52a      ; Load column address.
    clc         ; 18        ; Clear carry.
    adc #$10    ; 6910      ; Add 16 to the column.
    sta $2a     ; 852a      ; Store result.
    ; Right direction:
    .end:
    lda #$10    ; a910      ; Restore original A low byte value.
endmacro

col_tile_ld_bg12:
{
    %col_tile_ld()
    rtl         ; 6b        ; Return
}

col_tile_ld_bg3:
{
    %col_tile_ld()
    sta $1b     ; 851b      ; Store original A.
    rtl         ; 6b        ; Return
}

;===================================================================

; Description (BG1, BG2, & BG3):
; Horizontal (x) movement modification for BG1, BG2, & BG3...
; Modify the store location for VRAM to place column tiles in the second half
; of the buffer (16-63, 96-127, etc.) for certain coordinate ranges. Otherwise, it
; keeps placing data from columns 0 to 31. Internally, it preloads
; 0x48XX address which needs to be swapped to 0x4CXX for loading
; in the correct columns

pushpc
{
    ; Call-site modifications
    org $c022ca             ; BG1
    jsl col_dma_cpy_bg1
    org $c02449             ; BG2
    jsl col_dma_cpy_bg2
    org $c02657             ; BG3
    jsl col_dma_cpy_bg3
}
pullpc

macro col_dma_cpy(src, dest1, dest2)
    ; Modify VRAM store location for certain coordinate ranges (32-63, 96-127, etc.).
    pha         ; 48        ; push a
    lda $0974   ; ad7094    ; Movement direction.
    cmp #$02    ; c902      ; Compare - 0x2 is right direction.
    bne +       ; d005      ; jump for left direction
    ; right direction:
    lda $0541   ; ad4105    ; register with vertical pivot coordinate.
    bra ++      ; 8004      ; jump for right direction
    +:
    ; left direction:
    lda $0541   ; ad4105    ; register with vertical pivot coordinate.
    inc         ; 1a        ; add 1 if moving in left direction
    ++:
    sec         ; 38        ; set carry for subtraction
    sbc #$8     ; e908      ; normalize subtract 8
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
