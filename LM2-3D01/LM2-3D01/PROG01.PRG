* Sele 1 = Config
* Sele 2 = Company
title('Create New Report')
do clearmenu
do clearmsg
*-----------------------------
* List all profiles/tests and select 9 for report
sele 6
use items
sele 5
use (mLogdir+'\results')
sele 4
use (mLogdir+'\proinrep')
set filter to rep_id=company->cfg_rep_id
go bott
go top
sele 3
use profiles
go top
clearwork()
@ workrow+1, workcol say 'Please select Test/Profile to include in this'
@ workrow+2, workcol say 'report from the list at right.'
@ workrow+4, workcol say 'A list of selected items will appear at left. Pressing'
@ workrow+5, workcol say 'Enter key on a selected item will remove it from the list.'
@ workrow+7, workcol to workrow+7, menucol-2 color mc_high+'/'+mc_back
@ workrow+8, workcol say 'Tests/Profiles' color mc_high+'/'+mc_back
@ workrow+9, workcol say 'in this Report:' color mc_high+'/'+mc_back
@ workrow+8, workcol+21 say 'List:' color mc_high+'/'+mc_back
@ workrow+8, workcol+20 to 22, workcol+20
set key 18 to PgUp1
set key 3 to PgDn1
do while .t.
    @ workrow+9,workcol+21 clear to 22, menucol-2
    message('Enter to select/unselect - up to a maximum of 9',.f.,.f.)
    skipback=recno()
    set color to &c_prompt
    empties=1
    maxlist=10
    for x=1 to maxlist
        ax='a'+ltrim(str(x,0))
        bx='b'+ltrim(str(x,0))
        if eof()
            @ workrow+8+x, workcol+22 prompt '-(Empty)-'
            &ax=0
            &bx=''
            empties=empties+1
        else
            @ workrow+8+x, workcol+22 prompt left(pro_name,60)
            &ax=pro_id
            &bx=pro_name
        endif
        skip
    next
    @ menurow+1, menucol prompt 'Pg Down'
    @ menurow+2, menucol prompt 'Pg Up'
    @ menurow+3, menucol prompt 'Finish'
    menu to choice1
    clearmenu()
    set color to &c_defa
    do case
    case choice1=maxlist+1   // Pg Dn
        if eof()
            go bott
            skip -(maxlist-1)
        endif
        choice1=1
    case choice1=maxlist+2   // Pg Up
        skip -(maxlist*2-empties)
        if bof()
            go top
        endif
        choice1=1
    case choice1<=maxlist .and. choice1<>0
        ax='a'+ltrim(str(choice1,0))    && profile id
        bx='b'+ltrim(str(choice1,0))    && profile name
        sele proinrep
        go top
        x=1
        do while !eof()
            skip
            x=x+1
        enddo
        go top
        if &ax<>0
            loca for pro_id=&ax
            if found()
                delete
                pack
            else
                if x>9
                    message('Table full.',.t.,.t.)
                else
                    append blank
                    replace rep_id with company->cfg_rep_id
                    replace pro_id with &ax
                    replace pro_name with &bx
                endif
            endif
        endif
        @ workrow+10,workcol clear to 22, 21
        go top
        x=1
        do while !eof()
            @ workrow+9+x, workcol say left(pro_name,20)
            skip
            x=x+1
        enddo
        sele profiles
        goto skipback
    otherwise
exit
    endcase
enddo
set key 18 to nullkey
set key 3 to nullkey
sele 3
use (mLogdir+'\reports') index (mLogdir+'\reports')
sele proinrep
set filter to rep_id=company->cfg_rep_id
go bott
go top
canedit=0
if !eof() .and. lastkey() != 27 .and. mCo_id<>3
    message('Creating record, please wait...',.t.,.f.)
    sele reports
    append blank
    replace rep_id with company->cfg_rep_id
    replace ent_date with date()
    replace today with date()
    replace refby with config->refby
    replace printed with .f.
    replace paid with .f.
    replace archive with .f.
    replace dbl_space with 'N'
    reindex eval Progress(1,100) every 1
    seek company->cfg_rep_id
    if found()
        canedit=company->cfg_rep_id
        replace company->cfg_rep_id with company->cfg_rep_id+1
    else
        message('Record creation error. (01.01)',.t.,.t.)
        sele proinrep
        dele all for rep_id = cfg_rep_id
        pack
    endif
    if canedit<>0
        sele proinrep
        set filter to rep_id=canedit    && created rep_id
        go bott
        go top
        do while !eof()
            sele items
            set filter to proinrep->pro_id=pro_id
            go bott
            go top
            do while !eof()
                sele results
                append blank
                replace rep_id with canedit
                replace item_id with items->item_id
                if rep_id<>canedit
                    message('Record creation error. (01.02)',.t.,.t.)
            exit
                endif
                sele items
                skip
            enddo
            sele proinrep
            skip
        enddo
    endif
else
    sele proinrep
    set filter to
    dele all for rep_id=company->cfg_rep_id
    pack
    if mCo_id=3
        message('Cannot create in Sample mode.',.t.,.t.)
    endif
endif
*---------------------
sele 3
use
sele 4
use
sele 5
use
sele 6
use
if canedit<>0
    do prog02 with canedit
endif
return
