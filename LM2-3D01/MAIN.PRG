// LAB-MATE 2000
// by Victor Wright
// The Leisure Co.
// ***********************************************************************
param OK
#include "inkey.ch"
#include "llibg.ch"
//
mRegco  =   'AVE MARIA HOSPITAL (PVT) LTD.'
*mRegco  =   'NEGOMBO MEDICAL LABORATORY'
mProgram=   'LAB-MATE 2000'
mVersion=   'ver 3.0.1'
//
do begshow
do global
//
//
aMode := gmode()
if amode[LLG_MODE_IN_USE] != LLG_VIDEO_TXT
    bmpyes=.t.
    logo := {}
    aadd(logo, gbmpload("tlc1.bmp"))
    aadd(logo, gbmpload("tlc2.bmp"))
    aadd(logo, gbmpload("logo.bmp"))
else
    bmpyes=.f.
endif
//
//
sele 1
use config  // General configuration and sequence number file
mDefdir=config->Defdir  // Set to current directory "."
mc_back=ltrim(rtrim(config->c_back))
mc_text=ltrim(rtrim(config->c_text))
mc_line=ltrim(rtrim(config->c_line))
mc_high=ltrim(rtrim(config->c_high))
mc_sele=ltrim(rtrim(config->c_sele))
*        = standard,               enhanced,               border
c_defa   = mc_text+'/'+mc_back+','+mc_back+'/'+mc_text+','+mc_back
c_prompt = mc_text+'/'+mc_back+','+mc_back+'/'+mc_sele+','+mc_back
c_get    = mc_text+'/'+mc_back+','+mc_back+'/'+mc_sele
set color to &c_defa
cls
//
//
sele 2
use company index company
reindex
seek 2 // Un-registered Co.
mULog=iif(found(),company->logid,'--    ')
seek 1 // Registered Co.
mRLog=iif(found(),company->logid,'--    ')
tone(1000,4)
set cursor on
do while .t.
    mArch=.f.
    set defa to (mDefdir)
    sele company
    seek 3 // Default Co. (Unregistered)
    mDLog=iif(found(),company->logid,'Error!')
    mAlog='Archives'
    mGenco=company->co_name
    mCompany=mGenco
    mReg=.f.
    mCo_id=0
    do screen1 with .t.
    title('Mode Select')
    @ menurow+1, menucol say 'Mode:' color '*'+mc_high+'/'+mc_back
    set color to &c_prompt
    @ menurow+2, menucol prompt mRlog 
    @ menurow+3, menucol prompt mUlog
    @ menurow+4, menucol prompt mDlog
    @ menurow+5, menucol prompt mAlog
    @ menurow+6, menucol prompt 'Exit'
    menu to mCo_id
    set color to &c_defa
    @ menurow+1, menucol say 'Mode:'
    do case
    case mCo_id=4   // Archives Exist
        mArch=iif(file("archives\*.dbf"),.t.,.f.)
        if mArch
            seek 1  // Registered Company
            if found()
                mReg=iif(upper(left(company->co_name,20))=upper(left(mRegco,20)),.t.,.f.)
                mCompany=company->co_name
                mLogdir=rtrim(mDefdir)+'\Archives'
                set defa to (mLogdir)
                do case
                case !file("reparch.dbf") .or. !file("resarch.dbf") .or. !file("detarch.dbf")
                    message('Directory error. (00.03)',.t.,.t.)
                case !file("reparch.ntx")
                    message('Directory error. (00.04)',.t.,.t.)
                otherwise                
                    set defa to (mDefdir)
                    do mainmenu
                endcase
                set defa to (mDefdir)
            else
                message('Registered company not available.',.t.,.t.)
            endif
        else
            message('Unavailable!',.t.,.t.)
        endif
    case mCo_id=5    // Exit/Quit
exit
    otherwise
        seek mCo_id
        if found()
            do clearwork
            title('Security')
            mpassword='          ' && '1234567890'
            @ workrow+9, workcol+24 say 'Enter Password' get mpassword when (mCo_id<>3 .and. !empty(password)) color ','+mc_back+'/'+mc_back
            read
            if mpassword=company->password .or. mCo_id=3
                mReg=iif(upper(left(company->co_name,20))=upper(left(mRegco,20)),.t.,.f.)
                mCompany=company->co_name
                mLogdir=rtrim(mDefdir)+'\'+trim(company->dir)
                set defa to (mLogdir)
                do case
                case !file("reports.dbf") .or. !file("results.dbf") .or. !file("proinrep.dbf") .or. !file("patients.dbf")
                    message('Directory error. (00.05)',.t.,.t.)
                case !file("reports.ntx") .or. !file("patients.ntx")
                    message('Directory error. (00.06)',.t.,.t.)
                otherwise                
                    set defa to (mDefdir)
                    do mainmenu
                endcase
                set defa to (mDefdir)
            else
                message('Incorrect Password',.t.,.t.)
            endif
        else
            message('Unavailable!',.t.,.t.)
        endif
    endcase
enddo
do clearwork
set color to
@ 0,0 clear
quit

proc mainmenu
do while .t.
    clear typeahead
        screen1(mReg)
        title('Main Menu')
        message('Select menu item with  keys.',.f.,.f.)
        do clearmenu
        @ menurow+0, menucol say    'Main Menu:' color '*'+mc_high+'/'+mc_back
        @ menurow+1, menucol say    'Lab Report:' color mc_high+'/'+mc_back
        set color to &c_prompt
        @ menurow+2, menucol prompt 'New'                         && 1
        @ menurow+3, menucol prompt 'View/Modify'                 && 2
        @ menurow+4, menucol say    'Accounting:' color mc_high+'/'+mc_back
        @ menurow+5, menucol prompt 'Payments'                    && 3
        @ menurow+6, menucol prompt 'Accounts'                    && 4
        @ menurow+7, menucol say    'Printing:' color mc_high+'/'+mc_back
        @ menurow+8, menucol prompt 'Lab Reports'                 && 5
        @ menurow+9, menucol prompt 'Sales Rep.'                  && 6
        @ menurow+10,menucol prompt 'Other Info'                  && 7
        @ menurow+11,menucol say    'Edit:' color mc_high+'/'+mc_back
        @ menurow+12,menucol prompt 'Profiles'                    && 8
        @ menurow+13,menucol prompt 'Patients'                    && 9
        @ menurow+14,menucol prompt 'Options'                      && 10
        @ menurow+15,menucol say    '----------' color mc_high+'/'+mc_back
        @ menurow+16,menucol prompt 'Archive'                     && 11
        @ menurow+17,menucol prompt 'Reindex'                     && 12
        @ menurow+18,menucol prompt 'Exit'                        && 13
        menu to choice0
        clear typeahead
        set color to &c_defa
        @ menurow+0, menucol say    'Main Menu:' color mc_high+'/'+mc_back
        do case
        case choice0=1
            if mArch
                message('Unavailable in Archive mode.',.t.,.t.)
            else
                do prog01
                choice0=3
            endif
        case choice0=2
                do prog02
                choice0=2
        case choice0=3
            if mArch
                message('Unavailable in Archive mode.',.t.,.t.)
            else
                do prog03
                choice0=5
            endif
        case choice0=4
            if mArch
                message('Unavailable in Archive mode.',.t.,.t.)
            else
                if mReg .or. mCo_id=3
                    do prog04
                else
                    message('Please register to use this feature.',.t.,.t.)
                endif
                choice0=1
            endif
        case choice0=5
                do prog05
                choice0=5
        case choice0=6
//            if mArch
//              message('Unavailable in Archive mode.',.t.,.t.)
//            else
                if mReg .or. mCo_id=3
                        do prog06
                else
                        message('Please register to use this feature.',.t.,.t.)
                endif
                choice0=1
//            endif
        case choice0=7
            if mArch
                message('Unavailable in Archive mode.',.t.,.t.)
            else
                if mReg .or. mCo_id=3
                        do prog07
                else
                        message('Please register to use this feature.',.t.,.t.)
                endif
                choice0=1
            endif
        case choice0=8
            if mArch
                message('Unavailable in Archive mode.',.t.,.t.)
            else
                do prog08
                choice0=1
            endif
        case choice0=9
            if mArch
                message('Unavailable in Archive mode.',.t.,.t.)
            else
                do prog09
                choice0=1
            endif
        case choice0=10
            if mArch
                message('Unavailable in Archive mode.',.t.,.t.)
            else
                do prog10
                choice0=13
            endif
        case choice0=11
            if mArch
                message('Unavailable in Archive mode.',.t.,.t.)
            else
                do prog11
                choice0=1
            endif
        case choice0=12
            if mArch
                message('Unavailable in Archive mode.',.t.,.t.)
            else
                do prog12
                choice0=1
            endif
        otherwise
exit
        endcase
enddo
return

proc PgUp1
keyboard chr(6)+chr(5)+chr(13)
return

proc PgDn1
keyboard chr(6)+chr(5)+chr(5)+chr(13)
return

EXIT PROCEDURE ExitLM2
memvar OK
set cursor off
close all
clear all
set color to
do endshow
return
