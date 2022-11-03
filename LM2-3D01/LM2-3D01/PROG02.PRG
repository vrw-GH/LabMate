* Sele 1 = Config
* Sele 2 = Company
para mrep_id
title('View/Modify Report')
do clearwork
do clearmenu
*-----------------------------
sele 9
use ranges
sele 8
if mArch
    use (mLogdir+'\resarch') alias results
else
    use (mLogdir+'\results')
endif
sele 7
use profiles index profiles
sele 6
use (mLogdir+'\patients') index (mLogdir+'\patients')
sele 5
use items index items
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
goahead=.f.
if empty(mrep_id)
    set relation to pat_id into patients
    if getlist (15,"rep_id","ent_date","patients->pat_name",.f.)
        goahead=.t.
    endif
    set relation to
else
    seek mrep_id
    if found()
        goahead=.t.
    else
        message('Report not found.',.t.,.t.)
    endif
endif
if goahead
    message('Use  keys to select. F2 to change, Esc to finish.',.f.,.f.)
    do clearwork
    drawscr2()
    sele reports
    mret=.f.
    @ workrow,   workcol+11 say ltrim(str(rep_id)) color '*'+mc_high+'/'+mc_back
    @ workrow,   workcol+31 get today color c_get valid today>ent_date-1
    @ workrow,   workcol+60 say iif(dbl_space='Y','Yes','No ') color c_get
    @ workrow,   workcol+60 get dbl_space pict '!' color c_get valid dispword(dbl_space)
    @ workrow+1, workcol+11 get remarks pict '@S50' color c_get
    set key -1 to keyF2
    set key 19 to keyleft
    set key 4 to keyright
    @ workrow+2, workcol+11 get pat_id color c_get valid getpat(pat_id)
    do editpat with .t.
    @ workrow+6, workcol+7 get refno color c_get
    @ workrow+6, workcol+24 get refby pict '@S50' color c_get
    sele proinrep
    set filter to proinrep->rep_id = reports->rep_id
    go bott
    go top
    do getresult with .f.
    if mCo_id=3 .or. mArch
        clear gets
        set cursor off
        inkey(5)
        set cursor on
    else
        read
    endif
    @ workrow,   workcol+11 say ltrim(str(rep_id)) color mc_high+'/'+mc_back
    set key 19 to 
    set key 4 to
    set key -1 to 
    replace config->refby with iif(!empty(reports->refby),reports->refby,config->refby)
    if empty(reports->remarks)
        @ workrow+1,  workcol+12 say 'None.'
    endif
    if empty(patients->pat_remark)
        @ workrow+5,  workcol+25 say 'None.'
    endif
    if (lastkey() != 27)
        do getresult with .t.   // this is where we select tests/profiles and enter results
    endif
    sele proinrep
    set filter to
    go top
endif
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

proc getresult
param getok
do while .t.
    sele proinrep
    go bott
    go top
    x=1
    @ workrow+8, workcol say 'Select Test/Profile' color '*'+mc_high+'/'+mc_back
    @ workrow+9, workcol say 'F2=change,Esc=exit.' color mc_high+'/'+mc_back
    do while !eof()
        if getok
            @ workrow+9+x, workcol prompt left(proinrep->pro_name,20)
        else
            @ workrow+9+x, workcol say left(proinrep->pro_name,20)
        endif
        ax='a'+ltrim(str(x,0))
        &ax=recno()
        skip
        x=x+1
    enddo
    if getok
        set key -1 to changepro
        set color to &c_prompt
        menu to choice2
        set color to
        set key -1 to
    endif
    do case
    case getok .and. choice2<>0 .and. choice2<x
        @ workrow+8, workcol say 'Select Test/Profile' color mc_high+'/'+mc_back
        @ workrow+9, workcol say 'F2=change,Esc=exit.' color mc_high+'/'+mc_back
        ax='a'+ltrim(str(choice2,0))
        goto &ax
        drawscr2a()
        setcancel(.t.)
        do getres
        setcancel(.f.)
    otherwise
exit
    endcase
    choice2 = if(choice2<x-1,choice2+1,1)
enddo
@ workrow+8, workcol say 'Select Test/Profile' color mc_high+'/'+mc_back
sele reports
return

proc getres
    mexamd=proinrep->exm_date
    mexamt=proinrep->exm_time
    @ workrow+8, workcol+34 say left(proinrep->pro_name,30) color '*'+mc_high+'/'+mc_back
    @ workrow+9, workcol+32 say left(profiles->pro_spec,31)
    @ workrow+10,workcol+32 say left(profiles->pro_method,31)
    @ workrow+11,workcol+32 get proinrep->col_date color c_get valid(proinrep->col_date<=reports->today .and. puted(proinrep->col_date))
    @ workrow+11,workcol+56 get proinrep->col_time pict '99:99' color c_get valid(col_time<2400 .and. mod(col_time,100)<60 .and. putet(proinrep->col_time))
    @ workrow+12,workcol+32 get mexamd color c_get valid(mexamd>=proinrep->col_date .and. mexamd<=reports->today) when !empty(proinrep->col_date)
    @ workrow+12,workcol+56 get mexamt pict '99:99' color c_get valid(mexamt<2400 .and. mod(mexamt,100)<60 .and. iif(mexamd=proinrep->col_date,mexamt>=col_time,.t.)) when !empty(proinrep->col_date)
    @ workrow+13,workcol+32 get proinrep->remarks pict '@S31' color c_get
    if profiles->pro_mode='T'
        @ workrow+15,workcol+31 say 'Text Text Text Text Text'
    endif
    if mCo_id=3 .or. mArch
        clear gets
        set cursor off
        inkey(5)
        set cursor on
    else
        read
    endif
    if empty(proinrep->col_date)
        replace proinrep->exm_date with proinrep->col_date
    else
        replace proinrep->exm_date with mexamd
    endif
    if empty(proinrep->col_date)
        replace proinrep->exm_time with 0
    else
        replace proinrep->exm_time with mexamt
    endif
    @ workrow+8, workcol+34 say left(proinrep->pro_name,30) color mc_high+'/'+mc_back
    if empty(proinrep->remarks)
        @ workrow+13,workcol+32 say 'None.'
    endif
    if (lastkey() != 27)
        sele results
        set filter to results->rep_id=reports->rep_id
        go bott
        go top
        sele items
        set filter to items->pro_id=profiles->pro_id
        go bott
        go top
        if profiles->pro_mode='N'
            drawscr2b()
            do while !eof() .and. (lastkey() != 27)    // items.dbf (filter: profiles->pro_id)
                ax='R'+ltrim(str(items->order,0))
                sele results
                if items->char_num='N'
                    mresult=0.000
                else
                    mresult=space(len(result))
                endif
                loca for results->item_id=items->item_id
                if !found()
                    message('Record locate error. (02.02)',.t.,.t.)
                else
                    mdec=left(right(items->unit,3),1)
                    d=val(mdec)
                    if items->input_calc='C'   && char_num='N'
                        v=items->calculate
                        mresult=round(&v,d)
                    elseif !empty(results->result)
                        mresult=iif(items->char_num='C',results->result,val(results->result))
                    endif
                    @ workrow+15,workcol+29 say left(items->item_descr,34) color '*'+mc_high+'/'+mc_back
                    agedays=patients->pat_days+(patients->pat_months*30)+(int(patients->pat_months/2))+(patients->pat_years*365)+(int(patients->pat_years/4))
                    mrange='Not found.'
                    do case
                    case agedays<(config->kid_adult*365)+(int(config->kid_adult/4)+1)+1
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
                        case agedays>=2193                      && 6 to kid_adult break
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
                                mrange='No range found.'
                            endif
                        endif
                    endif
                    @ workrow+17,workcol+29 say trim(mrange)+' '+trim(left(items->unit,len(items->unit)-3))+'('+trim(category)+')'
                    sele results
                    if items->char_num='C'
                        @ workrow+16,workcol+29 get mresult pict '@S35' color c_get
                    else    && 'N'
                        mdec=left(right(items->unit,3),1)
                        do case
                        case mdec='0'
                            mpic='999,999,999'
                        case mdec='1'
                            mpic='9,999,999.9'
                        case mdec='2'
                            mpic='999,999.99'
                        case mdec='3'
                            mpic='99,999.999'
                        endcase
                        @ workrow+16,workcol+29 say mpic+' '+trim(left(items->unit,len(items->unit)-3))
                        if items->input_calc='I'
                            if items->char_num='N' // Numeric
                                @ workrow+16,workcol+29 get mresult pict mpic color c_get range items->lowest,items->highest //valid(iif(items->char_num='N',mresult>=items->lowest .and. mresult<=items->highest,.t.))
                            else    // Character
                                @ workrow+16,workcol+29 get mresult pict mpic color c_get // valid(iif(items->char_num='N',mresult>=items->lowest .and. mresult<=items->highest,.t.))
                            endif
                        else
                            d=val(mdec)
                            @ workrow+16,workcol+29 say str(mresult,10,d)+' (Calculated)'
                        endif
                    endif
                    @ workrow+18,workcol+29 get results->remarks pict 'XXXXX' color c_get
                    if mCo_id=3 .or. mArch
                        clear gets
                        set cursor off
                        inkey(5)
                        set cursor on
                    else
                        read
                    endif
                    @ workrow+15,workcol+29 say left(items->item_descr,34) color mc_high+'/'+mc_back
                    if empty(results->remarks)
                        @ workrow+18,workcol+29 say 'None.'
                    endif
                    if items->char_num='C'
                        replace results->result with mresult
                        &ax=0
                    else
                        replace results->result with iif(empty(mresult),'0.'+repl('0',d),str(mresult,10,d))
                        &ax=mresult
                    endif
                endif
                sele items
                skip
                if (lastkey() = 3)
            exit
                endif
            enddo
        else
            @ workrow+9, workcol+21 clear to 22,menucol-2
            set color to &c_get
            do while !eof()     && items.dbf (filter: profiles->pro_id)
                sele results
                loca for results->item_id=items->item_id
                if !found()
                    message('Record locate error. (02.03)',.t.,.t.)
                else
                    mrem='rem'+ltrim(str(items->order,0))
                    &mrem=results->result+results->remarks
                    sele results
                    @ workrow+8+items->order,workcol+22 get &mrem pict '@S40'
                endif
                sele items
                skip
            enddo
            if mCo_id=3 .or. mArch
                clear gets
                set cursor off
                inkey(5)
                set cursor on
            else
                read
            endif
            set color to &c_defa
            go top
            do while !eof()     && items.dbf (filter: profiles->pro_id)
                sele results
                loca for results->item_id=items->item_id
                if !found()
                    message('Record locate error. (02.04)',.t.,.t.)
                else
                    mrem='rem'+ltrim(str(items->order,0))
                    sele results
                    replace results->result with left(&mrem,20)
                    replace results->remarks with right(&mrem,20)
                    @ workrow+8+items->order,workcol+22 say &mrem color mc_text+'/'+mc_back
                endif
                sele items
                skip
            enddo
        endif
    endif
    sele items
    set filter to
    sele proinrep
return

proc puted
param ed
if empty(proinrep->exm_date)
    mexamd=ed
endif
return(.t.)

proc putet
param et
if empty(proinrep->exm_time)
    mexamt=et
endif
return(.t.)

proc getpat
para mpatid
sele patients
mret=.t.
if mpatid=0
    if !mCo_id=3
        append blank
        replace pat_id with company->cfg_pat_id
        replace pat_name with 'New Patient.'
        reindex eval Progress(1,100) every 1
        seek company->cfg_pat_id
        if found()
            replace reports->pat_id with company->cfg_pat_id
            replace company->cfg_pat_id with company->cfg_pat_id+1
        else
            message('Patient record creation error. (02.01)',.t.,.t.)
        endif
        mpatid=pat_id
    else
        message('Cannot create a new patient in Sample mode',.t.,.t.)
        mret=.f.
    endif
else
    seek mpatid
    if !found()
        message('Cannot find this patient.',.t.,.t.)
        mret=.f.
    endif
endif
editpat(.f.)
sele reports
message('Use  keys to select. Esc to finish.',.f.,.f.)
return(mret)

proc editpat
param getok
@ workrow+2, workcol+11 say str(pat_id) color mc_high+'/'+mc_back
if getok
    @ workrow+3,  workcol+7 get patients->pat_name pict '@S50' valid !empty(patients->pat_name) color c_get
    @ workrow+4,  workcol+7 say iif(patients->pat_sex='M','Male    ',iif(patients->pat_sex='F','Female  ',iif(patients->pat_sex='P','Pregnant',' ')))
    @ workrow+4,  workcol+7 get patients->pat_sex valid (dispword(patients->pat_sex) .and. (patients->pat_sex='F' .or. patients->pat_sex='M' .or. patients->pat_sex='P')) pict '!' color c_get  
    @ workrow+5,  workcol+6 get patients->pat_years pict '999' range 0,120 color c_get
    @ workrow+5,  workcol+11 get patients->pat_months pict '99' range 0,11 color c_get
    @ workrow+5,  workcol+15 get patients->pat_days pict '99' color c_get valid(patients->pat_days<30 .and. iif((patients->pat_years+patients->pat_months)=0,patients->pat_days>0,.t.)) 
    @ workrow+4,  workcol+25 get patients->pat_addr pict '@S38' color c_get
    @ workrow+5,  workcol+25 get patients->pat_remark pict '@S38' color c_get
else
    @ workrow+3,  workcol+7 say left(patients->pat_name,50)
    @ workrow+4,  workcol+7 say iif(patients->pat_sex='M','Male    ',iif(patients->pat_sex='F','Female  ',iif(patients->pat_sex='P','Pregnant',' ')))
    @ workrow+5,  workcol+6 say patients->pat_years pict '999'
    @ workrow+5,  workcol+11 say patients->pat_months pict '99'
    @ workrow+5,  workcol+15 say patients->pat_days pict '99'
    @ workrow+4,  workcol+25 say left(patients->pat_addr,38)
    @ workrow+5,  workcol+25 say left(patients->pat_remark,38)
endif
return

proc drawscr2
@ workrow,   workcol say 'Report ID:'                       color mc_high+'/'+mc_back
@ workrow,   workcol+25 say 'Date:'                         color mc_text+'/'+mc_back
@ workrow,   workcol+45 say 'Double Spaced:'                color mc_text+'/'+mc_back
@ workrow+1, workcol say 'Gen. Note:'                       color mc_text+'/'+mc_back
@ workrow+2, workcol say 'Patient  :'                       color mc_high+'/'+mc_back
@ workrow+2, workcol+1+25 say '(F2 for list, 0 to add)'     color mc_text+'/'+mc_back
@ workrow+3, workcol+1 say 'Name:'                          color mc_text+'/'+mc_back
@ workrow+4, workcol+1 say 'Sex :'                          color mc_text+'/'+mc_back
@ workrow+4, workcol+1+18 say 'Addr:'                       color mc_text+'/'+mc_back
@ workrow+5, workcol+1 say 'Age :999Y,99M,99D'              color mc_text+'/'+mc_back
@ workrow+5, workcol+1+18 say 'Rem.:'                       color mc_text+'/'+mc_back
@ workrow+6, workcol+1 say 'Ref :'                          color mc_text+'/'+mc_back
@ workrow+6, workcol+1+19 say 'by:'                         color mc_text+'/'+mc_back
@ workrow+7, workcol to workrow+7, menucol-2                color mc_line+'/'+mc_back
@ workrow+8, workcol say 'Select Test/Profile'              color mc_high+'/'+mc_back
@ workrow+8, workcol+20 to 22, workcol+20                   color mc_line+'/'+mc_back
drawscr2a()
return

proc drawscr2a
@ workrow+8, workcol+21 clear to 22,menucol-2
@ workrow+8, workcol+21 say 'Results: for'                  //color mc_high+'/'+mc_back
@ workrow+9, workcol+21 say 'Specimen'                      color mc_high+'/'+mc_back
@ workrow+9, workcol+30 say ':'                             color mc_text+'/'+mc_back
@ workrow+10,workcol+21 say 'Method   :'                    color mc_text+'/'+mc_back
@ workrow+11,workcol+21 say 'Collected:'                    color mc_text+'/'+mc_back
@ workrow+11,workcol+46 say 'at (24hr):'                    color mc_text+'/'+mc_back
@ workrow+12,workcol+21 say 'Examined :'                    color mc_text+'/'+mc_back
@ workrow+12,workcol+46 say 'at (24hr):'                    color mc_text+'/'+mc_back
@ workrow+13,workcol+21 say 'Remarks  :'                    color mc_text+'/'+mc_back
@ workrow+14,workcol+21 to workrow+14,menucol-2             color mc_line+'/'+mc_back
drawscr2b()
return

proc drawscr2b
@ workrow+15,workcol+21 clear to 22,menucol-2
@ workrow+15,workcol+21 say 'Item  :'                       color mc_high+'/'+mc_back
@ workrow+16,workcol+21 say 'Result:'                       color mc_text+'/'+mc_back
@ workrow+17,workcol+21 say 'Range :'                       color mc_text+'/'+mc_back
@ workrow+18,workcol+21 say 'Remark:'                       color mc_text+'/'+mc_back
return

proc changepro
if !reports->paid
    @ workrow+8, workcol+21 clear to 22, menucol-2
    @ workrow+8, workcol+21 say 'List:' color mc_high+'/'+mc_back
    set key 18 to PgUp1
    set key 3 to PgDn1
    sele profiles
    use
    use profiles
    go top
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
                    if x<>2
                        sele items
                        set filter to proinrep->pro_id=pro_id
                        go bott
                        go top
                        do while !eof()
                            sele results
                            delete all for results->item_id=items->item_id
                            pack
                            sele items
                            skip
                        enddo
                        sele proinrep
                        delete
                        pack
                    else
                        message('Cannot delete this test/profile.',.t.,.t.)
                    endif
                else
                    if x>9
                        message('Table full.',.t.,.t.)
                    else
                        append blank
                        replace rep_id with reports->rep_id
                        replace pro_id with &ax
                        replace pro_name with &bx
                        sele items
                        set filter to proinrep->pro_id=pro_id
                        go bott
                        go top
                        do while !eof()
                            sele results
                            append blank
                            replace rep_id with reports->rep_id
                            replace item_id with items->item_id
                            sele items
                            skip
                        enddo
                        sele proinrep
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
    sele profiles
    use
    use profiles index profiles
    sele proinrep
    set relation to pro_id into profiles
    go bott
    go top
    message('Use  keys to select. Esc to finish.',.f.,.f.)
    keyboard chr(13)+chr(27)
endif
return
