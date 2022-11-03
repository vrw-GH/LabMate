proc help
mscreen:= savescreen(20,0,24,80)
message('Help system not available in this version.',.t.,.f.)
restscreen(20,0,24,80,mscreen)
return

proc errhand
para errnum,msg
@ 12, 24 say msg+' ERROR: '+str(errnum)
wait
return

proc nullkey
return

proc keyF2
save screen
do case
case readvar()='PAT_ID'
    sele patients
    go top
    mpat_id=0
    do getlist with 17,"pat_id",,"pat_name","mpat_id"
    replace reports->pat_id with mpat_id
    sele reports
    restore screen
    editpat(.f.)
case readvar()='MID_FROM'
    go bott
    do getlist with 17,"rep_id","ent_date","patients->pat_name","mid_from"
    keyboard chr(13)
    restore screen
case readvar()='MID_TO'
    go bott
    do getlist with 17,"rep_id","ent_date","patients->pat_name","mid_to"
    keyboard chr(13)
    restore screen
endcase
return

proc keyleft
do case
case readvar()='PATIENTS->PAT_SEX'
    if patients->pat_sex='F'
        patients->pat_sex='M'
    elseif patients->pat_sex='M'
        patients->pat_sex='P'
    else
        patients->pat_sex='F'
    endif
    @ workrow+4,  workcol+1 say 'Sex : '+iif(patients->pat_sex='M','Male    ',iif(patients->pat_sex='F','Female  ',iif(patients->pat_sex='P','Pregnant',' ')))
case readvar()='PATIENTS->PAT_YEARS'
    if patients->pat_years<120
        patients->pat_years=patients->pat_years+1
    endif
case readvar()='PATIENTS->PAT_MONTHS'
    if patients->pat_months<11
        patients->pat_months=patients->pat_months+1
    endif
case readvar()='PATIENTS->PAT_DAYS'
    if patients->pat_days<29
        patients->pat_days=patients->pat_days+1
    endif
case readvar()='DBL_SPACE'
    if reports->dbl_space='N'
        reports->dbl_space='Y'
    else
        reports->dbl_space='N'
    endif
    @ workrow,   workcol+45 say 'Double Spaced: '+iif(dbl_space='Y','Yes','No ')
case readvar()='PRO_MODE'
    if profiles->pro_mode='N'
        profiles->pro_mode='T'
        profiles->pro_type='P'
    else
        profiles->pro_mode='N'
    endif
    @ workrow+1, workcol+47 say 'Mode: '+iif(pro_mode='N','Normal','Text  ') 
    @ workrow+2, workcol+47 say 'Type: '+iif(pro_type='T','Test   ','Profile') 
case readvar()='PRO_TYPE'
    if profiles->pro_type='T'
        profiles->pro_type='P'
    else
        profiles->pro_type='T'
    endif
    @ workrow+2, workcol+47 say 'Type: '+iif(pro_type='T','Test   ','Profile') 
case readvar()='MPOS'
    if mpos='B'
        mpos='A'
    else
        mpos='B'
    endif
    @ workrow+6, workcol+36 say iif(mpos='B','Before result','After result ')
case readvar()='INPUT_CALC'
    if items->input_calc='I'
        items->input_calc='C'
        items->char_num='N'
    else
        items->input_calc='I'
    endif
    @ workrow+8, workcol say iif(input_calc='I','Input     ','Calculated')
    @ workrow+8, workcol+14 say iif(char_num='C','Character','Number   ')
case readvar()='CHAR_NUM'
    if items->char_num='C'
        items->char_num='N'
    else
        items->char_num='C'
    endif
    @ workrow+8, workcol+14 say iif(char_num='C','Character','Number   ')
case readvar()='MALIGN'
    if malign='R'
        malign='L'
    else
        malign='R'
    endif
    @ workrow+8, workcol+26 say iif(malign='R','Right align','Left align ')
case readvar()='MDEC'
    if val(mdec)<3
        mdec=str(val(mdec)+1,1,0)
    endif
otherwise
    set key 19 to
    keyboard chr(19)
    set key 5 to resetkey
    set key 24 to resetkey
    set key 13 to resetkey
endcase
return

proc keyright
do case
case readvar()='PATIENTS->PAT_SEX'
    if patients->pat_sex='F'
        patients->pat_sex='P'
    elseif patients->pat_sex='P'
        patients->pat_sex='M'
    else
        patients->pat_sex='F'
    endif
    @ workrow+4,  workcol+1 say 'Sex : '+iif(patients->pat_sex='M','Male    ',iif(patients->pat_sex='F','Female  ',iif(patients->pat_sex='P','Pregnant',' ')))
case readvar()='PATIENTS->PAT_YEARS'
    if patients->pat_years>0
        patients->pat_years=patients->pat_years-1
    endif
case readvar()='PATIENTS->PAT_MONTHS'
    if patients->pat_months>0
        patients->pat_months=patients->pat_months-1
    endif
case readvar()='PATIENTS->PAT_DAYS'
    if patients->pat_days>0
        patients->pat_days=patients->pat_days-1
    endif
case readvar()='DBL_SPACE'
    if reports->dbl_space='Y'
        reports->dbl_space='N'
    else
        reports->dbl_space='Y'
    endif
    @ workrow,   workcol+45 say 'Double Spaced: '+iif(dbl_space='Y','Yes','No ')
case readvar()='PRO_MODE'
    if profiles->pro_mode='N'
        profiles->pro_mode='T'
        profiles->pro_type='P'
    else
        profiles->pro_mode='N'
    endif
    @ workrow+1, workcol+47 say 'Mode: '+iif(pro_mode='N','Normal','Text  ') 
    @ workrow+2, workcol+47 say 'Type: '+iif(pro_type='T','Test   ','Profile') 
case readvar()='PRO_TYPE'
    if profiles->pro_type='T'
        profiles->pro_type='P'
    else
        profiles->pro_type='T'
    endif
    @ workrow+2, workcol+47 say 'Type: '+iif(pro_type='T','Test   ','Profile') 
case readvar()='MPOS'
    if mpos='B'
        mpos='A'
    else
        mpos='B'
    endif
    @ workrow+6, workcol+36 say iif(mpos='B','Before result','After result ')
case readvar()='INPUT_CALC'
    if items->input_calc='I'
        items->input_calc='C'
        items->char_num='N'
    else
        items->input_calc='I'
    endif
    @ workrow+8, workcol say iif(input_calc='I','Input     ','Calculated')
    @ workrow+8, workcol+14 say iif(char_num='C','Character','Number   ')
case readvar()='CHAR_NUM'
    if items->char_num='C'
        items->char_num='N'
    else
        items->char_num='C'
    endif
    @ workrow+8, workcol+14 say iif(char_num='C','Character','Number   ')
case readvar()='MALIGN'
    if malign='R'
        malign='L'
    else
        malign='R'
    endif
    @ workrow+8, workcol+26 say iif(malign='R','Right align','Left align ')
case readvar()='MDEC'
    if val(mdec)>0
        mdec=str(val(mdec)-1,1,0)
    endif
otherwise
    set key 4 to
    keyboard chr(4)
    set key 5 to resetkey
    set key 24 to resetkey
    set key 13 to resetkey
endcase
return

proc dispword
para word
ret=.f.
do case
case readvar()='PATIENTS->PAT_SEX'
    @ workrow+4,  workcol+1 say 'Sex : '+iif(word='M','Male    ',iif(word='F','Female  ',iif(word='P','Pregnant',' ')))
    ret=.t.
case readvar()='PRO_MODE'
    @ workrow+1, workcol+47 say 'Mode: '+iif(word='N','Normal','Text  ')
    ret=.t.
case readvar()='PRO_TYPE'
    @ workrow+2, workcol+47 say 'Type: '+iif(word='T','Test   ','Profile') 
    ret=.t.
case readvar()='CHAR_NUM'
    ret=iif(word='C' .or. word='N',.t.,.f.)
    @ workrow+8, workcol+14 say iif(word='C','Character','Number   ')
case readvar()='MALIGN'
    ret=iif(word='L' .or. word='R',.t.,.f.)
    @ workrow+8, workcol+26 say iif(word='R','Right align','Left align ')
case readvar()='MPOS'
    ret=iif(word='B' .or. word='A',.t.,.f.)
    @ workrow+6, workcol+36 say iif(word='B','Before result','After result ')
case readvar()='CONFIG->C_BACK'
    @ workrow+10,workcol+21 say 'лллл' color word
    ret=.t.
case readvar()='CONFIG->C_TEXT'
    @ workrow+11,workcol+21 say 'лллл' color word
    ret=.t.
case readvar()='CONFIG->C_LINE'
    @ workrow+12,workcol+21 say 'лллл' color word
    ret=.t.
case readvar()='CONFIG->C_HIGH'
    @ workrow+13,workcol+21 say 'лллл' color word
    ret=.t.
case readvar()='CONFIG->C_SELE'
    @ workrow+14,workcol+21 say 'лллл' color word
    ret=.t.
case readvar()='DBL_SPACE'
    if word='Y' .or. word='N'
        @ workrow,   workcol+45 say 'Double Spaced: '+iif(word='Y','Yes','No ')
        ret=.t.
    else
        ret=.f.
    endif
endcase
return(ret)

proc getlist
// select the area from calling program and
// set your relations first  - don't forget to reset
// pass parameters by reference
para maxlist,theid,thedate,thename,theret
if maxlist = NIL
    maxlist=10
endif
if type("theret") = "L"
    theret=.f.
endif
clearmenu()
set key 18 to PgUp1
set key 3 to PgDn1
go bott
do while .t.
    message('Choose from list.',.f.,.f.)
    do clearwork
    @ workrow, workcol say 'List:' color '*'+mc_high+'/'+mc_back
    @ menurow, menucol say 'Menu:' color '*'+mc_high+'/'+mc_back
    empties=1
    set color to &c_prompt
    for x=1 to maxlist
        ax='a'+ltrim(str(x,0))
        if bof() .or. eof()
            @ workrow+x, workcol prompt '-(Empty)-'
            &ax=0
            empties=empties+1
        else
            @ workrow+x, workcol prompt iif(theid != NIL,ltrim(str(&theid,0))+' - ','')+iif(thedate != NIL, '('+dtoc(&thedate)+')  ','')+iif(thename != NIL, &thename,'')
            &ax=&theid
        endif
        skip -1
    next
    @ menurow+1, menucol prompt 'Pg Down'
    @ menurow+2, menucol prompt 'Pg Up'
    @ menurow+3, menucol prompt 'Exit'
    menu to choice
    @ menurow, menucol say 'Menu:' color mc_high+'/'+mc_back
    clearmenu()
    set color to &c_defa
    do case
    case choice<=maxlist .and. choice<>0
        ax='a'+ltrim(str(choice,0))
        seek &ax
        if found()
            if type("theret")="L"
                theret=.t.
            else
                &theret=&ax
            endif
exit
        else
            message('Report not found.',.t.,.t.)
            go bott
            choice=0
            if type("theret")="L"
                theret=.f.
            else
                &theret=0
            endif
        endif
    case choice=maxlist+1   // Pg Dn
        if bof()
            go top
            skip maxlist-1
        endif
        choice=1
    case choice=maxlist+2   // Pg Up
        skip (maxlist*2-empties)
        if eof()
            go bott
        endif
        choice=1
    otherwise
        if type("theret")="L"
            theret=.f.
        else
            &theret=0
        endif
exit
    endcase
enddo
set key 18 to nullkey
set key 3 to nullkey
return(theret)


proc resetkey
set key 5 to
set key 24 to
set key 13 to
keyboard chr(lastkey())
set key 4 to keyright
set key 19 to keyleft
return

Function progress
para start,max
Local cComplete := Ltrim(str(start+(recno()/lastrec()*max),3,0))
message(cComplete + '%',.f.,.f.)
return .t.
