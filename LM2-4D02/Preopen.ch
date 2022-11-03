// pre-open procedures.

request _dbfcdx

setcancel(.f.)
set cursor off
set status off
set bell on
set date british
set century on
set talk off
set exact on
set confirm on
set score off
set wrap on
set deleted on
set eventmask to INKEY_ALL
rddsetdefault("_DBFCDX")
readexit(.f.)
           
if !file("config.dbf")
    Warning(1,'Configuration file not found.')
else
    use Config via '_DBFCDX' NEW
    index(".\Config", "cfg_name", "cfg_name", "Config", .t.)
    mHomedir := (iif(dbseek("HOMEDIR"),alltrim(cfg_descr),mHomedir))
    mTodom = 18
    odometer(1,mTodom)
    mDelay := iif(dbseek("DELAY"),val(alltrim(cfg_descr)),mDelay)
    odometer(2,mTodom)
    mVmode := iif(dbseek("VIDMODE"),alltrim(cfg_descr),mVmode)
    odometer(3,mTodom)
    mLtop := iif(dbseek("LOGOTOP"),val(alltrim(cfg_descr)),mLtop)
    odometer(4,mTodom)
    mLleft := iif(dbseek("LOGOLEFT"),val(alltrim(cfg_descr)),mLleft)
    odometer(5,mTodom)
    mBorder := iif(dbseek("BORDER"),val(alltrim(cfg_descr)),mBorder)
    odometer(6,mTodom)
    cLight := iif(dbseek("LITECOLOR"),val(alltrim(cfg_descr)),cLight)
    odometer(7,mTodom)
    cDark := iif(dbseek("DARKCOLOR"),val(alltrim(cfg_descr)),cDark)
    odometer(8,mTodom)
    cFill := iif(dbseek("FILLCOLOR"),val(alltrim(cfg_descr)),cFill)
    odometer(9,mTodom)
    mMsgBoxsize := iif(dbseek("MSGBOXSIZE"),alltrim(cfg_descr),mMsgBoxsize)
    if val(mMsgBoxSize) < 1
        mMsgBoxsize := "1"
    elseif val(mMsgBoxSize) > 8
        mMsgBoxsize := "8"
    endif
    mPrinter := iif( dbseek("PRINTER"), alltrim(cfg_descr), mPrinter )
    odometer(10,mTodom)
    mPage := iif( dbseek("PAGE"), val(cfg_descr), mPage )
    odometer(11,mTodom)
    mTmarg := iif( dbseek("TMARG"), val(cfg_descr), mTmarg )
    odometer(12,mTodom)
    mLmarg := iif( dbseek("LMARG"), val(cfg_descr), mLmarg )
    odometer(13,mTodom)
    mRmarg := iif( dbseek("RMARG"), val(cfg_descr), mRmarg )
    odometer(14,mTodom)
    mBmarg := iif( dbseek("BMARG"), val(cfg_descr), mBmarg )
    odometer(15,mTodom)
    mCopies := iif( dbseek("COPIES"), val(cfg_descr), mCopies )
    odometer(16,mTodom)
    mMode := iif( dbseek("DEFMODE"), alltrim(cfg_descr), mMode )
    odometer(17,mTodom)
    mSound := iif( dbseek("SOUND"), iif(alltrim(cfg_descr)='Y',.t.,.f.), mSound )
    odometer(18,mTodom)
    use
endif
set defa to (mHomedir)
// Video Mode Settings
mBmpyes := .t.
do Case
case mvmode = '16'
    set videomode to LLG_VIDEO_VGA_640_480_16
case mvmode = '256'
    set videomode to LLG_VIDEO_VESA_640_480_256
case mvmode = '32K'
    set videomode to LLG_VIDEO_VESA_640_480_32K
case mvmode = '64K'
    set videomode to LLG_VIDEO_VESA_640_480_64K
case mvmode = '16M'
    set videomode to LLG_VIDEO_VESA_640_480_16M
otherwise
    set videomode to LLG_VIDEO_TXT
    mBmpyes := .f.
endcase
if mBmpyes
    #include "\programs\TLCUtil\logoshow.ch"
//    mshow(LLM_CURSOR_ARROW)
//    mshow(LLM_CURSOR_FINGER)
endif
