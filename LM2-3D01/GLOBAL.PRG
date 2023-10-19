cls
#include "llibg.ch"
#include "inkey.ch"
//
//
set videomode to LLG_VIDEO_TXT
setcursor(.f.)
@0,1 say '(TEXT MODE)'
do while .t.
    @0,20 say 'F2-16, F3-256, F4-32K, F5-64K, F6-16M, F7-Text'
    presskey = inkey(0, INKEY_ALL )
    do case
    case presskey = 1002
exit
    case presskey = 1004
exit
    case presskey = K_ENTER
exit
    case presskey = -1
        cls
        set videomode to LLG_VIDEO_VGA_640_480_16
        gBmpdisp(gbmpload("tlc1.bmp"),20,20)
        @0,1 say '(16 MODE)  '
    case presskey = -2
        cls
        set videomode to LLG_VIDEO_VESA_640_480_256
        gBmpdisp(gbmpload("tlc1.bmp"),20,20)
        @0,1 say '(256 MODE) '
    case presskey = -3
        cls
        set videomode to LLG_VIDEO_VESA_640_480_32K
        gBmpdisp(gbmpload("tlc1.bmp"),20,20)
        @0,1 say '(32K MODE) '
    case presskey = -4
        cls
        set videomode to LLG_VIDEO_VESA_640_480_64K
        gBmpdisp(gbmpload("tlc1.bmp"),20,20)
        @0,1 say '(64K MODE) '
    case presskey = -5
        cls
        set videomode to LLG_VIDEO_VESA_640_480_16M
        gBmpdisp(gbmpload("tlc1.bmp"),20,20)
        @0,1 say '(16M MODE) '
    case presskey = -6
        cls
        set videomode to LLG_VIDEO_TXT
        @0,1 say '(TEXT MODE)'
    endcase
enddo
//
//
@ 12,25 say 'Initializaing... Please wait.'
set color to &c_defa
set status off
set bell on
set date british
set century on
set talk off
set exact on
set confirm on
//set console off
set wrap on
set delete on
setcancel(.f.)
set key 18 to nullkey
set key 3 to nullkey
*on error do errhand with error(), message()
//msetcursor(.t.)
//mshow(LLM_CURSOR_ARROW)
//mshow(LLM_CURSOR_FINGER)
//
//
if !file("config.dbf") .or. !file("company.dbf") .or. !file("profiles.dbf") .or. !file("items.dbf") .or. !file("ranges.dbf")
    @ 12,16 say 'Databases not present. Error (00.01)   '
    @ 22,00 say ' '
    quit
endif
if !file("company.ntx") .or. !file("profiles.ntx") .or. !file("items.ntx")
    @ 12,16 say 'Indexes not present. Error (00.02)     '
    @ 22,00 say ' '
    quit
endif
//
//
inkey(1)
