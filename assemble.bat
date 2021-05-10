copy "Final Fantasy III (USA).sfc" "Final Fantasy III (USA).tile_layout_patched.sfc"
flips.exe --ignore-checksum "tile_layout_patch.bps" "Final Fantasy III (USA).tile_layout_patched.sfc"
copy "Final Fantasy III (USA).tile_layout_patched.sfc" "Final Fantasy III (USA).patched.sfc"
asar patch.asm "Final Fantasy III (USA).patched.sfc"

copy "Final Fantasy III (USA) (Rev 1).sfc" "Final Fantasy III (USA) (Rev 1).tile_layout_patched.sfc"
flips.exe "tile_layout_patch.bps" "Final Fantasy III (USA) (Rev 1).tile_layout_patched.sfc"
copy "Final Fantasy III (USA) (Rev 1).tile_layout_patched.sfc" "Final Fantasy III (USA) (Rev 1).patched.sfc"
asar patch.asm "Final Fantasy III (USA) (Rev 1).patched.sfc"
