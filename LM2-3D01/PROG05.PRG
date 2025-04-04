* Sele 1 = Config
* Sele 2 = Company
*-----------------------------
sele 9
use ranges
sele 8
use items index items
sele 7
use (mLogdir+'\patients') index (mLogdir+'\patients')
sele 6
use profiles index profiles
sele 5
if mArch
    use (mLogdir+'\resarch') alias results
else
    use (mLogdir+'\results')
/*
    sort to sortres.dbf on rep_id /D, item_id /A
    if file("sortres.dbf")
        use
        copy file sortres.dbf to (mLogdir+'\results.dbf')
        erase sortres.dbf
        use (mLogdir+'\results')
    else
        message('Sort error. (05.01)',.t.,.t.)
    endif
*/
endif
sele 4
if mArch
    use (mLogdir+'\detarch') alias proinrep
else
    use (mLogdir+'\proinrep')
endif
set relation to pro_id into profiles
sele 3
if mArch
    use (mLogdir+'\reparch') index ('archives\reparch') alias reports
else
    use (mLogdir+'\reports') index (mLogdir+'\reports')
endif
set relation to pat_id into patients
mid_from=0
mid_to=0
//do clearwork
print=.f.
do while .t.
    title('Print Lab Reports')
    message('Select from/to range.',.f.,.f.)
    do clearwork
    do clearmenu
    @ workrow+1, workcol say 'Report ID No: From                      (F2 for list)'
    @ workrow+2, workcol say '              To                 '
    @ workrow+1, workcol+21 say mid_from
    @ workrow+2, workcol+21 say mid_to
    @ menurow+1, menucol say 'Range:' color '*'+mc_high+'/'+mc_back
    set color to &c_prompt
    @ menurow+2, menucol prompt 'From'
    @ menurow+3, menucol prompt 'To'
    @ menurow+4, menucol prompt 'Print'
    @ menurow+5, menucol prompt 'Exit'
    menu to choice3
    @ menurow+1, menucol say 'Range:' color mc_high+'/'+mc_back
    set color to &c_defa
    do case
    case choice3=1
        title('Print Lab Reports - Set Range')
        set key -1 to keyF2
        @ workrow+1, workcol+21 get mid_from color c_get
        read
        set key -1 to
        if mid_from = 0
            @ workrow+1, workcol+21 say mid_from
            if mid_from = 0 .and. mid_to = 0
                choice3=1
                print=.f.
            else
                print=.t.
                choice3=3
            endif
        else
            seek mid_from
            if !found()
                mid_from=0
                message('Report not found.',.t.,.t.)
                @ workrow+1, workcol+21 say mid_from
                if mid_to = 0
                    print=.f.
                    choice3=1
                endif
            else
                print=.t.
                choice3=3
            endif
        endif
    case choice3=2
        title('Print Lab Reports - Set Range')
        set key -1 to keyF2
        @ workrow+2, workcol+21 get mid_to color c_get
        read
        set key -1 to
        if mid_to = 0
            @ workrow+2, workcol+21 say mid_to
            if mid_to = 0 .and. mid_from = 0
                choice3=1
                print=.f.
            else
                print=.t.
                choice3=3
            endif
        else
            seek mid_to
            if !found()
                mid_to=0
                message('Report not found.',.t.,.t.)
                @ workrow+2, workcol+21 say mid_to
                if mid_from = 0
                    choice3=1
                    print=.f.
                endif
            else
                print=.t.
                choice3=3
            endif
        endif
    case choice3=3
        title('Print Lab Reports - Print')
        if print
            message('Prepare to print.',.f.,.f.)
            sele reports        && related to patients
            do case
            case mid_from<>0 .and. mid_to=0
                set filter to rep_id=mid_from
            case mid_to<>0 .and. mid_from=0
                set filter to rep_id=mid_to
            otherwise
                if mid_from>mid_to
                    set filter to rep_id<=mid_from .and. rep_id>=mid_to
                else
                    set filter to rep_id>=mid_from .and. rep_id<=mid_to
                endif
            endcase
            go bott
            go top
            do while !eof()
                if paid
                    for x=1 to config->copies
                        do print1
                    next
                else
                    @ 12,25 say 'Payment not complete.'
                    message('Please confirm payment to print!',.t.,.t.)
                endif
                sele reports
                skip
            enddo
            set filter to
            choice3=4
        else
            print=.f.
            message('Please set range',.t.,.t.)
            choice3=1
        endif
        mid_from=0
        mid_to=0
    otherwise
exit
    endcase
enddo
sele 3
use
sele 4
use
sele 5
use
sele 6
use
sele 7
use
sele 8
use
sele 9
use
return

proc print1
do while .t.
    do clearmenu
    do clearwork
    message('Prepare to print.',.f.,.f.)
    @ workrow+1, workcol say 'Ready to print Report ID: '+ltrim(str(rep_id))
    @ workrow+2, workcol say '                   Copy : '+ltrim(str(x))+' of '+ltrim(str(config->copies))
    @ 12, 25 say 'Prepare printer.' color mc_high+'/'+mc_back
    @ menurow+1, menucol say 'PRINT' color '*'+mc_high+'/'+mc_back
    set color to &c_prompt
    @ menurow+2, menucol prompt '(Re)Print'
    @ menurow+3, menucol prompt 'Exit'
    menu to choice5
    set color to &c_defa
    @ menurow+1, menucol say 'PRINT' color mc_high+'/'+mc_back
    @ 12, 25 say '                 '
    do case
    case choice5=1
        do printrep
        sele reports
        pok='Y'
        message('Confirm print',.f.,.f.)
        @ 12, 25 say 'Print OK? Y/N' get pok pict '!' valid (pok='Y' .or. pok='N') color c_get
        read
        replace printed with iif((pok='Y' .and. !mArch),.t.,.f.) 
        if printed
exit
        endif
    otherwise
exit
    endcase
enddo
return

proc printrep       && for each report ID
message('Printing ...',.t.,.f.)
set device to printer
set print on
pl=0    && printed line no
pc=config->l_margin
fl=8    && page footer lines
sele proinrep   && related to profiles
set filter to rep_id=reports->rep_id
go bott
go top
do pagehead                                 && page header
do rephead                                  && report header
do while !eof()
    if (config->pg_lines-pl)<=profiles->tot_items+fl
        do pagefoot
        eject
        do pagehead                                 && page header
        do rephead                                  && report header
    endif
    do profhead                             && profile header
    sele results
    set filter to rep_id=reports->rep_id
    go bott
    go top
    sele items
    set filter to pro_id=proinrep->pro_id
    go bott
    go top
    do while !eof()
        sele results
        go top
        loca for item_id=items->item_id
        do printline  && results selected   && print details
        sele items
        skip
    enddo
    sele items
    set filter to
    sele proinrep
    do proffoot                             && profile footer
    skip
enddo
sele reports
do repfoot                                  && report footer
eject
set device to screen
set print off
return

proc printline
if pl>config->pg_lines-fl
    do pagehead
    do rephead
endif
pc=pc+1
if found()  && (results) loca for rep_id=reports->rep_id .and. item_id=items->item_id
    if profiles->pro_mode='N'   && normal report (many items)
        munit=left(items->unit,len(items->unit)-3)
        mdec=left(right(items->unit,3),1)
        mpos=left(right(items->unit,2),1)
        malign=right(items->unit,1)
        do case
        case mdec='0'
            mpic='999,999,999    '
        case mdec='1'
            mpic='  9,999,999.9  '
        case mdec='2'
            mpic='    999,999.99 '
        case mdec='3'
            mpic='     99,999.999'
        endcase
        if profiles->pro_type='T'   && Test not Profile
            @ pl,pc-1 say trim(items->item_descr)
            @ pl,pc-1 say trim(items->item_descr)
            @ pl,pc-1 say repl('_',len(trim(items->item_descr)))
        else                        && Profile
            @ pl,pc+1 say trim(items->item_descr)
        endif
        if items->char_num='C'
            if mpos='A'
                if malign='L'   && character, after, left
                    @ pl,pc+32 say ltrim(trim(results->result))
                    @ pl,pc+32 say ltrim(trim(results->result))+iif(!empty(munit),' '+trim(munit),'')+' '+left(results->remarks,5)
                else            && character, after, right
                    mres=space(len(results->result)-len(trim(results->result)))+ltrim(trim(results->result))
                    @ pl,pc+32 say mres
                    @ pl,pc+32 say mres+iif(!empty(munit),' '+trim(munit),'')+' '+left(results->remarks,5)
                endif
            else
                if malign='L'   && character, before, left
                    @ pl,pc+32+len(munit+' ') say ltrim(results->result)
                    @ pl,pc+32 say munit+' '+ltrim(results->result)+' '+left(results->remarks,5)
                else            && character, before, right
                    mres=space(len(results->result)-len(trim(results->result)))+ltrim(trim(results->result))
                    @ pl,pc+32+len(munit+' ') say mres
                    @ pl,pc+32 say munit+' '+mres+' '+left(results->remarks,5)
                endif
            endif
        else    && Numbers
            d=val(mdec)
            pnum=str(val(results->result),10,d)
            if mpos='A'
                if malign='L'   && Number, After, Left
                    @ pl,pc+28 say ltrim(pnum)
                    @ pl,pc+28 say ltrim(pnum)+iif(!empty(munit),' '+trim(munit),'')+' '+left(results->remarks,5)
                else            && Number, After, Right
                    @ pl,pc+28 say val(pnum) pict mpic
                    @ pl,pc+28 say val(pnum) pict mpic
                    @ pl,pc+28+len(mpic)-1 say iif(!empty(munit),trim(munit),'')+' '+left(results->remarks,5)
                endif
            else
                if malign='L'   && Number, Before, Left
                    @ pl,pc+28+len(munit) say ltrim(pnum)
                    @ pl,pc+28 say munit+ltrim(pnum)+' '+left(results->remarks,5)
                else            && Number, Before, Right
                    @ pl,pc+28+len(munit) say val(pnum) pict mpic
                    @ pl,pc+28+len(munit) say val(pnum) pict mpic
                    @ pl,pc+28 say munit+space(len(mpic)-1)+' '+left(results->remarks,5)
                endif
            endif
        endif
        pl=pl+iif(reports->dbl_space='Y',2,1)
        agedays=patients->pat_days+(patients->pat_months*30)+(int(patients->pat_months/2))+(patients->pat_years*365)+(int(patients->pat_years/4))
        mrange='Not found.'
        do case
        case agedays<5846   && under 16 years
            do case
            case agedays<2                          && newborn
                mrange='NEWBORN'
            case agedays>=2 .and. agedays<8         && 1 week
                mrange='1 WEEK'
            case agedays>=8 .and. agedays<32        && 1 month
                mrange='1 MONTH'
            case agedays>=32 .and. agedays<366      && 1 year
                mrange='1 YEAR'
            case agedays>=366 .and. agedays<2193    && 1-6 years
                mrange='CHILD 1-6Y'
            case agedays>=2193                      && 6 to 16 yrs
                mrange='OVER 6Y'
            endcase
        otherwise           && adult
            do case
            case patients->pat_sex='M'
                mrange='ADULT (M)'
            case patients->pat_sex='F'
                mrange='ADULT (F)'
            case patients->pat_sex='P'
                mrange='PREGNANT'
            endcase
        endcase
        sele ranges
        loca for item_id=results->item_id .and. upper(trim(category))=upper(trim(mrange))
        if found()
            mrange=range
        else
            go top
            loca for item_id=results->item_id .and. upper(trim(category))=upper(trim('GENERAL'))
            if found()
                mrange=range
            else
                loca for item_id=results->item_id .and. upper(trim(category))=upper(trim('OTHER'))
                if found()
                    mrange=range
                else
                    mrange=''
                endif
            endif
        endif
        if !empty(mrange)
            pl=pl-iif(reports->dbl_space='Y',2,1)
            @ pl,pc+config->pg_cols-len(' '+trim(munit))-len(mrange) say rtrim(mrange)+' '+trim(munit)
            pl=pl+iif(reports->dbl_space='Y',2,1)
        endif
        sele items
    else    && Text (10 items)
        @ pl,pc+10 say results->result+results->remarks
        pl=pl+1
    endif
else
    @ pl,pc say 'Error! Result not found!'
    pl=pl+1
endif
pc=pc-1
return

proc pagehead
if pl>config->pg_lines-fl
    do pagefoot
endif
pl=config->t_margin
@ pl,pc say repl('_',config->pg_cols-pc)
@ pl,config->pg_cols-len(trim(company->co_name))*2-1 say chr(27)+chr(14)+trim(company->co_name)+chr(27)+chr(18)
pl=pl+1
@ pl,config->pg_cols-len(trim(company->co_addr1)+' '+trim(company->co_addr2)) say trim(company->co_addr1)+' '+trim(company->co_addr2)
@ pl,config->pg_cols-len(trim(company->co_addr1)+' '+trim(company->co_addr2)) say trim(company->co_addr1)+' '+trim(company->co_addr2)
pl=pl+1
telfax=iif(!empty(company->co_tel),'Tel:'+trim(company->co_tel),'')+iif(!empty(company->co_fax),' Fax:'+trim(company->co_fax),'')
@ pl,config->pg_cols-len(telfax) say telfax
pl=pl+2
return

proc pagefoot
@ pl,pc say repl('_',config->pg_cols-pc)
pl=pl+1
@ pl,config->pg_cols-len("Cont'd next page...")-1 say "Cont'd next page..."
pl=pl+1
eject
pl=0
return

proc rephead
@ pl,config->pg_cols-len('Date: '+dtoc(reports->today)) say 'Date: '+dtoc(reports->today)
pl=pl+1
@ pl,config->pg_cols-len('Report Ref: '+ltrim(str(reports->rep_id)))  say 'Report Ref: '+ltrim(str(reports->rep_id))
@ pl,pc say 'PATIENT ID : '+ltrim(str(patients->pat_id))
pl=pl+1
@ pl,pc say '             '+ltrim(patients->pat_name)
@ pl,pc say 'Name       : '+ltrim(patients->pat_name)
pl=pl+1
@ pl,config->pg_cols-len(trim(config->biochem)) say repl('_',len(trim(config->biochem)))
@ pl,config->pg_cols-len(trim(config->biochem)) say trim(config->biochem)
@ pl,config->pg_cols-len(trim(config->biochem)) say trim(config->biochem)
@ pl,pc say '                        Age: '+iif(patients->pat_years<>0,ltrim(str(patients->pat_years))+' Years ','')+iif(patients->pat_months<>0,ltrim(str(patients->pat_months))+' Months ','')+iif(patients->pat_days<>0,ltrim(str(patients->pat_days))+' Days','')
@ pl,pc say 'Sex        : '+iif(patients->pat_sex='P','Pregnant',iif(patients->pat_sex='M','Male','Female'))
pl=pl+1
if !empty(patients->pat_remark)
    @ pl,pc say 'Note       : '+ltrim(patients->pat_remark)
    pl=pl+1
endif
if !empty(reports->refby)
    @ pl,pc say 'REFERRED by: '+ltrim(reports->refby)
    pl=pl+1
endif
if !empty(reports->refno)
    @ pl,pc say 'Ref.No     : '+ltrim(reports->refno)
    pl=pl+1
endif
pl=pl+1
@ pl,pc say repl('_',config->pg_cols-pc)
pl=pl+1
@ pl,pc say 'LABORATORY REPORT'
@ pl,pc+36 say 'R E S U L T S'
@ pl,pc+62 say 'NORMAL VALUES'
@ pl,pc say repl('_',config->pg_cols-pc)
pl=pl+2
return

proc repfoot
@ pl,pc say repl('_',config->pg_cols-pc)
pl=pl+1
@ pl,pc say 'General Notes: '+reports->remarks
pl=pl+5
if pl<config->pg_lines-fl
    pl = config->pg_lines-fl
endif
@ pl,pc say repl('_',config->pg_cols-pc)
pl=pl+1
@ pl,pc say trim(company->co_doc1)
@ pl,pc+len(company->co_doc1)+5 say trim(company->co_doc2)
@ pl,config->pg_cols-len(trim(company->co_MLT)) say trim(company->co_MLT)
pl=pl+1
@ pl,pc say trim(company->co_doc1q)
@ pl,pc+len(company->co_doc1)+5 say trim(company->co_doc2q)
@ pl,config->pg_cols-len(trim(company->co_MLTq)) say trim(company->co_MLTq)
pl=pl+1
@ pl,pc say repl('_',config->pg_cols-pc)
pl=pl+1
@ pl,(config->pg_cols-pc-len(trim(company->co_note)))/2 say trim(company->co_note)
pl=pl+1
if pl<config->pg_lines-fl
    pl = config->pg_lines-fl
endif
return

proc profhead
if !empty(proinrep->col_date) .and. !empty(proinrep->col_time)
    @ pl,pc say 'Specimen: Collected '+dtoc(proinrep->col_date)+' '+left(str(proinrep->col_time,4,0),2)+':'+right(str(proinrep->col_time,4,0),2)+'hrs.'
    pl=pl+1
endif
if !empty(proinrep->exm_date) .and. !empty(proinrep->exm_time)
    @ pl,pc say '          Examined  '+dtoc(proinrep->exm_date)+' '+left(str(proinrep->exm_time,4,0),2)+':'+right(str(proinrep->exm_time,4,0),2)+'hrs.'
    pl=pl+1
endif
if !empty(proinrep->remarks)
    @ pl,pc say 'Remarks : '+proinrep->remarks
    pl=pl+1
endif
if profiles->pro_type<>'T'  && Not a Test
    pl=pl+1
    @ pl,pc say trim(profiles->pro_name)
    @ pl,pc say trim(profiles->pro_name)
    @ pl,pc say repl('_',len(trim(profiles->pro_name)))
    pl=pl+1
endif
pl=pl+1
return

proc proffoot
pl=pl+1
return
