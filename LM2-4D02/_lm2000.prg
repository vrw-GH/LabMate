// The Leisure Company.
// All Rights Reserved.
//---------------------------------------------------------

PROC LabReps
MsgLeft('Lab Reports.', Maxrow(), .f., LLG_MODE_XOR)
sele Database
if database->(Dbseek(Upper(mMode+"Company.dbf")))
    openfile((alltrim(database->DATADIR)+database->DBFNAME), 0, ;
        iif( !empty(database->INDEXFILE), alltrim(database->DATADIR)+database->INDEXFILE, ''), ;
        alltrim(database->TAG) ,'Company')
    if database->(Dbseek(Upper(mMode+"Ranges.dbf")))
        openfile((alltrim(database->DATADIR)+database->DBFNAME), 0, ;
            iif( !empty(database->INDEXFILE), alltrim(database->DATADIR)+database->INDEXFILE, ''), ;
            alltrim(database->TAG) , 'Ranges')
        if database->(Dbseek(Upper(mMode+"Items.dbf")))
            openfile((alltrim(database->DATADIR)+database->DBFNAME), 0, ;
                iif( !empty(database->INDEXFILE), alltrim(database->DATADIR)+database->INDEXFILE, ''), ;
                alltrim(database->TAG) , 'Items')
            if database->(Dbseek(Upper(mMode+"Patients.dbf")))
                openfile((alltrim(database->DATADIR)+database->DBFNAME), 0, ;
                    iif( !empty(database->INDEXFILE), alltrim(database->DATADIR)+database->INDEXFILE, ''), ;
                    alltrim(database->TAG) , 'Patients')
                if database->(Dbseek(Upper(mMode+"Profiles.dbf")))
                    openfile((alltrim(database->DATADIR)+database->DBFNAME), 0, ;
                        iif( !empty(database->INDEXFILE), alltrim(database->DATADIR)+database->INDEXFILE, ''), ;
                        alltrim(database->TAG) , 'Profiles')
                    if database->(Dbseek(Upper(mMode+"Results.dbf")))
                        openfile((alltrim(database->DATADIR)+database->DBFNAME), 0, ;
                            iif( !empty(database->INDEXFILE), alltrim(database->DATADIR)+database->INDEXFILE, ''), ;
                            alltrim(database->TAG) , 'Results')
                        if database->(Dbseek(Upper(mMode+"Proinrep.dbf")))
                            openfile((alltrim(database->DATADIR)+database->DBFNAME), 0, ;
                                iif( !empty(database->INDEXFILE), alltrim(database->DATADIR)+database->INDEXFILE, ''), ;
                                alltrim(database->TAG) , 'Proinrep')
                            if database->(Dbseek(Upper(mMode+"Refby.dbf")))
                                openfile((alltrim(database->DATADIR)+database->DBFNAME), 0, ;
                                    iif( !empty(database->INDEXFILE), alltrim(database->DATADIR)+database->INDEXFILE, ''), ;
                                    alltrim(database->TAG) ,'Refby')
                                if database->(Dbseek(Upper(mMode+"Reports.dbf")))
                                    openfile((alltrim(database->DATADIR)+database->DBFNAME), 0, ;
                                        iif( !empty(database->INDEXFILE), alltrim(database->DATADIR)+database->INDEXFILE, ''), ;
                                        alltrim(database->TAG) ,'Reports')
                                    set relation to pat_id into patients
                                    set relation to Ref_id into Refby additive
                                    sele Proinrep
                                    set relation to pro_id into profiles
                                    do LabRep1
                                    Refby->(dbclosearea())
                                else
                                    warning(6,"REPORTS not found.")
                                endif
                                Reports->(dbclosearea())
                            else
                                warning(6,"REFBY not found.")
                            endif
                            Proinrep->(dbclosearea())
                        else
                            warning(6,"PROINREP not found.")
                        endif
                        Results->(dbclosearea())
                    else
                        warning(6,"RESULTS not found.")
                    endif
                    Profiles->(dbclosearea())
                else
                    warning(6,"PROFILES not found.")
                endif
                Patients->(dbclosearea())
            else
                warning(6,"PATIENTS not found.")
            endif
            Items->(dbclosearea())
        else
            warning(6,"ITEMS not found.")
        endif
        Ranges->(dbclosearea())
    else
        warning(6,"RANGES not found.")
    endif
    Company->(dbclosearea())
else
    warning(6,"COMPANY not found.")
endif
MsgLeft('Lab Reports.', Maxrow(), .t., LLG_MODE_XOR)
return(.t.)

PROC LabRep1
clearwork()
sele reports
go bott
MsgLeft('Lab Reports.', Maxrow(), .t., LLG_MODE_XOR)
MsgLeft('^F-Find, F2-Edit, ^N-New, ^A-Change Profiles', maxrow(), .f., LLG_MODE_XOR)
aProlist = {}
lnewRep = .f.
do while .t.
    prolist()
    a = loadflds(select(),1,fcount(),'fRep_')
    a = loadflds(select('Patients'),1,Patients->(fcount()),'fPat_')
    workrow = 3
    workcol = 2
    menurow = 1
    menucol = 2
    setthescr()
    setcolor(cBar)
    @  2, maxcol()-(3+len('ID: '+ltrim(str(fRep_01)))) say 'ID: '+ltrim(str(fRep_01))
    setcolor(cNormal)
    @ workrow+0, workcol+11 say fRep_04 pict '@S20'
    @ workrow+0, workcol+45 say fRep_02
    @ workrow+1, workcol+6 say iif(empty(fPat_02),'Not Entered.',fPat_02) pict '@S56'
    @ workrow+1, workcol+68 say iif(fPat_03='P','Pregnant',iif(fPat_03='M','Male    ','Female  '))
    @ workrow+2, workcol+6 say iif(empty(fPat_07),'None given.'+spac(len(fPat_07)-11),fPat_07) pict '@S52'
    @ workrow+2, workcol+64 say fPat_04 pict "999"
    @ workrow+2, workcol+69 say fPat_05 pict "99"
    @ workrow+2, workcol+73 say fPat_06 pict "99"
    @ workrow+3, workcol+10 say iif(empty(fPat_09),'None.'+spac(len(fPat_09)-5),fPat_09) pict '@S60'
    @ workrow+5, workcol+11 say Refby->Name pict "@S46"
    @ workrow+5, workcol+73 say iif(fRep_10='Y','Yes','No ')
    @ workrow+6, workcol+10 say iif(empty(fRep_09),'None.'+spac(len(fRep_09)-5),fRep_09) pict '@S45'
    @ workrow+6, workcol+66 say fRep_06
    @ workrow+8, workcol say 'Test/Profile: '+Profiles->Pro_name
    mProlist = iif(Proinrep->(eof()),'',str(Proinrep->Pro_id))
    @ workrow+9, workcol, 22,workcol+19 get mProlist LISTBOX aProlist scrollbar 
    clear gets
    @ workrow+9, workcol+31 say Profiles->Pro_spec
    @ workrow+10,workcol+31 say Profiles->Pro_method
    @ workrow+11,workcol+32 say Proinrep->Col_Date
    @ workrow+11,workcol+59 say Proinrep->Exm_Date
    @ workrow+12,workcol+32 say Proinrep->Col_Time pict '99:99'
    @ workrow+12,workcol+59 say Proinrep->Exm_Time pict '99:99'
    @ workrow+13,workcol+28 say Proinrep->Remarks
    @ workrow+15,workcol+21 say 'Item  :'+space(maxcol()-2-workcol+21-7)
    @ workrow+16,workcol+21 say 'Result:'+space(maxcol()-2-workcol+21-7)
    @ workrow+17,workcol+21 say 'Range :'+space(maxcol()-2-workcol+21-7)
    @ workrow+18,workcol+21 say 'Remark:'+space(maxcol()-2-workcol+21-7)
    mret=.f.
    if lnewRep
	    keypressed = K_F2
	else
	    keypressed = Waitforkey("Waiting ...")
	endif
	lnewRep = .f.
    do case
    case keypressed = K_ESC .or. keypressed = 0
exit
    case keypressed = K_F1
		help()
    case keypressed = K_PGDN
        skip 1
        if eof()
            go bott
            audio(.f.)
            alert('This is the last record.')
            audio(.t.)
        endif
    case keypressed = K_PGUP
        skip -1
        if bof()
            go top
            audio(.f.)
            alert('This is the first record.')
            audio(.t.)
        endif
    case keypressed = K_CTRL_PGUP
        Go Top
    case keypressed = K_CTRL_PGDN
        Go Bott
    case keypressed = K_CTRL_A .and. CanAcces(AXL_CHANGPROS)
        if !reports->paid
            changpros()
        else
            audio(.f.)
            alert('Cannot change paid reports.')
            audio(.t.)
        	if aAccess[2] = 1
	            changpros()
        	endif
        endif
    case keypressed = K_CTRL_N .and. CanAcces(AXL_LABREPS)
        audio(.t.)
        if alert('Create New Report?',{ 'Yes','No'}) = 1
            audio(.t.)
            append blank
            replace rep_id with company->cfg_rep_id,;
                    ent_date with date(),;
                    today with date(),;
                    Ref_id with 1,;
                    printed with .f.,;
                    paid with .f.,;
                    archive with .f.,;
                    dbl_space with 'N',; 
                    recdate with date(),;
                    time with left(time(),2)+substr(time(),4,2)
            reindex
            seek company->cfg_rep_id
            if found()
                replace company->cfg_rep_id with company->cfg_rep_id+1,;
                        company->recdate with date()
			    a = loadflds(select(),1,fcount(),'fRep_')
			    a = Patients->(dbgoto(lastrec()+1))
			    a = loadflds(select('Patients'),1,Patients->(fcount()),'fPat_')
			    prolist()
                setthescr()
                changpros()
                lnewRep = .t.
            else
                Warning(6,'Record creation error. (01.01)')
            endif
        endif
    case keypressed = K_F2 .and. CanAcces(AXL_LABREPS)
        MsgLeft('^F-Find, F2-Edit, ^N-New, ^A-Change Profiles', maxrow(), .t., LLG_MODE_XOR)
        MsgLeft('Edit Mode', maxrow(), .f., LLG_MODE_XOR)
        setcolor(cGet)
        tNestUpd = .f.
        @ workrow+0, workcol+11 get fRep_04 pict '@S20'
        @ workrow+0, workcol+45 get fRep_02 valid FindPat(fRep_02)
        @ workrow+1, workcol+6 get fPat_02 pict '@KS56' valid !empty(fPat_02) 
        @ workrow+1, workcol+68 get fPat_03 pict '!' valid showat(workrow+1, workcol+68,iif(fPat_03='P','Pregnant',iif(fPat_03='M','Male    ','Female  '))) .and. (fPat_03='M' .or. fPat_03='F' .or. fPat_03='P')
        @ workrow+2, workcol+6 get fPat_07 pict '@S52'
        @ workrow+2, workcol+64 get fPat_04 range 0,120 pict "999"
        @ workrow+2, workcol+69 get fPat_05 range 0,11 pict "99"
        @ workrow+2, workcol+73 get fPat_06  pict "99" valid(fPat_06<30 .and. iif((fPat_04+fPat_05)=0,fPat_06>0,.t.)) 
        @ workrow+3, workcol+10 get fPat_09 pict '@S60'
        Refbyname = Refby->Name
        @ workrow+5, workcol+11 get Refbyname pict "@KS46" when getref(@Refbyname) valid saveref()
        @ workrow+5, workcol+73 get fRep_10 pict '!' valid showat(workrow+5, workcol+73, iif(fRep_10='Y','Yes','No '))
        @ workrow+6, workcol+10 get fRep_09 pict '@S45'
        @ workrow+6, workcol+66 get fRep_06 valid fRep_06 >= fRep_05
        @ workrow+9, workcol, 22,workcol+19 get mProlist LISTBOX aProlist scrollbar color cListbox valid (getres(val(mProlist)) .and. lastkey() = 27) //state { |oListbox| listchg(oListbox) }
        set key K_F2 to keyF2
        set key K_CTRL_LEFT to KeyCycle()
        set key K_CTRL_RIGHT to KeyCycle()
        setcursor(1)
        read
        setcursor(0)
        setcolor(cNormal)
        set key K_F2 to 
        set key K_CTRL_LEFT
        set key K_CTRL_RIGHT
        if readupdated() .or. tNestUpd
            if alert('Changes were made', {'Save', 'Discard'} ) = 1
                audio(.t.)
                a = saveflds(select(),1,fcount(),'fRep_')
                replace recdate with date()
                a = saveflds(select('Patients'),1,Patients->(fcount()),'fPat_')
                replace Patients->recdate with date()
            endif
        endif
        MsgLeft('Edit Mode', maxrow(), .t., LLG_MODE_XOR)
        MsgLeft('^F-Find, F2-Edit, ^N-New, ^A-Change Profiles', maxrow(), .f., LLG_MODE_XOR)
    case keypressed = K_CTRL_F
        MsgLeft('^F-Find, F2-Edit, ^N-New, ^A-Change Profiles', maxrow(), .t., LLG_MODE_XOR)
        MsgLeft('Find Mode', maxrow(), .f., LLG_MODE_XOR)
        a = alert('Search by', {'List', 'ID'} )
        audio(.t.)
        nGoBy = 10
        set key K_PGUP to pgkey
        set key K_PGDN to pgkey 
        do case
        case a = 1
            mList := {}
            go bott
            do while !bof()
                aadd(mList, { left(Patients->Pat_Name,25)+'-'+transform(Rep_id,'@B 9999999999'), str(Rep_id) } )
                skip -1
            enddo
            mRid = str(Rep_Id)
            @ workrow+1, workcol+6, 20,60 get mRid LISTBOX mList DROPDOWN SCROLLBAR color cListdwn
            read
            mRid = val(mRid)
            seek mRid
            if !found()
                audio(.f.)
                Alert("Not found.", "Ok")
                go bott
            endif
            audio(.t.)
        case a = 2
            mRid=0
            @ 2, maxcol()-12 get mRid
            setcursor(1)
            read
            setcursor(0)
            seek mRid
            if !found()
                audio(.f.)
                Alert("Not found.", "Ok")
                go bott
            endif
            audio(.t.)
        endcase
        set key K_PGUP to
        set key K_PGDN to
        MsgLeft('Find Mode', maxrow(), .t., LLG_MODE_XOR)
        MsgLeft('^F-Find, F2-Edit, ^N-New, ^A-Change Profiles', maxrow(), .f., LLG_MODE_XOR)
    otherwise
    	sayWait(1,"No action associated for that key")
    	inkey(0.3)
    	sayWait(0,"No action associated for that key")
    endcase
enddo
MsgLeft('^F-Find, F2-Edit, ^N-New, ^A-Change Profiles', maxrow(), .t., LLG_MODE_XOR)
MsgLeft('Lab Reports.', Maxrow(), .f., LLG_MODE_XOR)
return(.t.)

PROC setthescr
	clearwork()
    setcolor(cBar)
    @  2, 2 clear to 2,maxcol()-2
    @  2, 2 say 'LABORATORY RESULTS.'
    @  2, maxcol()-(15) say spac(15)
    @  2, maxcol()-(3+len('ID: '+ltrim(str(fRep_01)))) say 'ID: '
    setcolor(cNormal)
    @ workrow+0, workcol say 'Reference:                       Patient Id:            (F2 for list, 0 New)'
    @ workrow+1, workcol say 'Name:                                                          Sex:         '
    @ workrow+2, workcol say 'Addr:                                                      Age:    Y,  M,  D'
    @ workrow+3, workcol say 'Pat.Note:'
    @ workrow+4, workcol to workrow+4, maxcol()-workcol
    @ workrow+5, workcol say 'Ref.by: Dr.                                               Double Spaced:    '
    @ workrow+6, workcol say 'Gen.Note:                                               Rep.Date:   /  /    '
    @ workrow+7, workcol to workrow+7, maxcol()-workcol
    @ workrow+8, workcol say 'Test/Profile: '
    mProlist = iif(Proinrep->(eof()),'',str(Proinrep->Pro_id))
    @ workrow+9, workcol, 22,workcol+19 get mProlist LISTBOX aProlist scrollbar 
    clear gets
    @ workrow+9, workcol+21 say 'Specimen:   ' // from profile database
    @ workrow+10,workcol+21 say 'Method  :   ' // from profile database
    @ workrow+11,workcol+21 say 'Collected:   /  /          Examined :   /  /    '
    @ workrow+12,workcol+21 say 'at (24hr):   :  hrs        at (24hr):   :  hrs'
    @ workrow+13,workcol+21 say 'Notes:   '
    @ workrow+14,workcol+21 to workrow+14, maxcol()-workcol
    @ workrow+15,workcol+21 say 'Item  :'+space(maxcol()-2-workcol+21-7)
    @ workrow+16,workcol+21 say 'Result:'+space(maxcol()-2-workcol+21-7)
    @ workrow+17,workcol+21 say 'Range :'+space(maxcol()-2-workcol+21-7)
    @ workrow+18,workcol+21 say 'Remark:'+space(maxcol()-2-workcol+21-7)
return (.t.)

FUNC keyF2
save screen
do case
case readvar()='FREP_02'
    FREP_02 = getbylist(workrow+0, workcol+45,workrow+8, Maxcol()-4,'sdfged','Patients','Pat_Id','transform(Patients->Pat_Id,"@B 9999999999")+left(Patients->Pat_Name,25)',.f.       ,Company->CFG_PAT_ID)
    keyboard chr(K_ENTER)
endcase
return

PROC getref()
mret = .f.
tX1 = fRep_03
Refby->(dbseek(tX1 := getbylist(workrow+5,workcol+11,workrow+18,workcol+48,,'Refby','Ref_id','Name',.t.,tX1)))
do case
case lastkey() = K_ESC
    fRep_03 := 0
    Refbyname := spac(len(Refby->Name))
    mret = .t.
otherwise
    if fRep_03 <> tX1
        fRep_03 := tX1
        Refbyname := Refby->Name
        tNestUpd = .t.
    endif
    mret = .f.
endcase
return(mret)

PROC saveref()
if fRep_03 = 0 .and. !empty(Refbyname)
    if !islocated(Select('Refby'),'Name',Refbyname)
        Refby->(dbappend())
        Replace Refby->Ref_id with company->cfg_ref_id, ;
                Refby->Name with Refbyname, ;
                Refby->Recdate with date()
        Refby->(dbreindex())
        if Refby->(dbseek(company->cfg_ref_id))
            fRep_03 = company->cfg_ref_id
            replace company->cfg_ref_id with company->cfg_ref_id+1,;
                    company->Recdate with date()
        else
            warning(6,'Record creation error. (01.02)')
        endif
    else
        fRep_03 = Refby->Ref_id
        Refbyname = Refby->Name
    endif
endif
if fRep_03 <> Reports->Ref_Id
    tNestUpd = .t.
endif
return(.t.)

PROC prolist
sele proinrep
set filter to proinrep->rep_id=reports->rep_id
go bott
go top
aProlist = {}
if eof()
    aadd(aProlist, { 'None.' , '' } )
else
    do while !eof()                    
        aadd(aProlist, { iif(Profiles->(eof()),'Lost Link!',Profiles->Pro_Name) , str(Proinrep->Pro_id) } )
        skip
    enddo
endif
go top
sele proinrep
set filter to
sele Reports
return(.t.)

PROC FindPat
mret=.t.
if fRep_02=0
    Patients->(dbappend())
    replace Patients->pat_id with Company->cfg_pat_id, ; 
            Patients->pat_name with ' New Patient.', ; 
            Patients->pat_sex with 'F', ; 
            Patients->recdate with date()
    Patients->(dbreindex())
    if Patients->(dbseek(Company->cfg_pat_id))
        replace Reports->Pat_id with Company->cfg_pat_id, ; 
                Company->cfg_pat_id with Company->cfg_pat_id+1, ; 
                Company->recdate with date(), ; 
                Reports->recdate with date()
        fRep_02 = Reports->Pat_id
        a = loadflds(select('Patients'),1,Patients->(fcount()),'fPat_')
    else
        warning(6,'Patient record creation error. (02.01)')
        mret=.f.
    endif
else
    if ! Patients->(dbseek(fRep_02))
        warning(6,'Cannot find this patient.')
        mret=.f.
    else
        a = loadflds(select('Patients'),1,Patients->(fcount()),'fPat_')
    endif
endif
@ workrow+1, workcol+6 say iif(empty(fPat_02),'Not Entered.',fPat_02) pict '@S56'
@ workrow+1, workcol+68 say iif(fPat_03='P','Pregnant',iif(fPat_03='M','Male    ','Female  '))
@ workrow+2, workcol+6 say iif(empty(fPat_07),'None given.'+spac(len(fPat_07)-11),fPat_07) pict '@S52'
@ workrow+2, workcol+64 say fPat_04
@ workrow+2, workcol+69 say fPat_05
@ workrow+2, workcol+73 say fPat_06
@ workrow+3, workcol+10 say iif(empty(fPat_09),'None.'+spac(len(fPat_09)-5),fPat_09) pict '@S60'
return(mret)

FUNC listchg (oListbox)
wait
?oListbox:buffer
wait
return(.t.)

FUNC puted (oGet)
if empty(fPir_06)
    oGet:varPut(fPir_04)
endif
mRet = .f.
if !empty(fPir_04) .or. !empty(fPir_06)
    mRet = .t.
endif
return(mRet)

FUNC putet (oGet)
if empty(fPir_07)
    oGet:varPut(fPir_05)
endif
mRet = .f.
if !empty(fPir_04) .or. !empty(fPir_06)
    mRet = .t.
endif
return(mRet)

PROC getres(tproid)
local GetList := {}
local mRet := .f.
tNestUpd = iif(tNestUpd,.t.,readupdated())
sele Proinrep
set filter to proinrep->rep_id=reports->rep_id
go bott
go top
sele Reports
if islocated(Select('Proinrep'),'Pro_id',tproid)
    @ workrow+9, workcol+21 say 'Specimen:   ' // from profile database
    @ workrow+10,workcol+21 say 'Method  :   ' // from profile database
    @ workrow+11,workcol+21 say 'Collected: dd/mm/yyyy      Examined : dd/mm/yyyy'
    @ workrow+12,workcol+21 say 'at (24hr): 99:99hrs        at (24hr): 99:99hrs'
    @ workrow+13,workcol+21 say 'Notes:   '
    @ workrow+14,workcol+21 to workrow+14, maxcol()-workcol
    @ workrow+15,workcol+21 say 'Item  :'+space(maxcol()-2-workcol+21-7)
    @ workrow+16,workcol+21 say 'Result:'+space(maxcol()-2-workcol+21-7)
    @ workrow+17,workcol+21 say 'Range :'+space(maxcol()-2-workcol+21-7)
    @ workrow+18,workcol+21 say 'Remark:'+space(maxcol()-2-workcol+21-7)
    a = loadflds(select('Proinrep'),1,Proinrep->(fcount()),'fPir_')
    @ workrow+8, workcol+14 say Profiles->Pro_name
    @ workrow+9, workcol+31 say Profiles->Pro_spec
    @ workrow+10,workcol+31 say Profiles->Pro_method              
    @ workrow+11,workcol+32 get fPir_04 valid fPir_04<=reports->today .and. showat(workrow+11,workcol+59,iif(empty(fPir_06),fPir_04,fPir_06))
    @ workrow+12,workcol+32 get fPir_05 pict '99:99' valid fPir_05<2400 .and. mod(fPir_05,100)<60 .and. showat(workrow+12,workcol+59,transform(iif(empty(fPir_07),fPir_05,fPir_07),'99:99'))
    @ workrow+11,workcol+59 get fPir_06 when { |oGet| puted(oGet) } valid empty(fPir_06) .or. (fPir_06>=fPir_04 .and. fPir_06<=reports->today)
    @ workrow+12,workcol+59 get fPir_07 when { |oGet| putet(oGet) } pict '99:99' valid empty(fPir_07) .or. (fPir_07<2400 .and. mod(fPir_07,100)<60 .and. iif(fPir_06=fPir_04,fPir_07>=fPir_05,.t.))
    @ workrow+13,workcol+28 get fPir_08 pict '@S34' valid writeres() .and. showat(workrow+13,workcol+28,iif(empty(fPir_08),'None.'+space(len(fPir_08)-5),fPir_08))
    if profiles->pro_mode='T'
        @ workrow+15,workcol+31 say 'Text Text Text Text Text'
    endif
    setcursor(1)
    read
    setcursor(0)
    if readupdated()
        if alert('Changes were made', {'Save', 'Discard'} ) = 1
            audio(.t.)
            a = saveflds(select('Proinrep'),1,Proinrep->(fcount()),'fPir_')
            replace proinrep->recdate with date()
        endif
        tNestUpd = .t.
    endif
else
    warning(6,'This Profile does not exist!')
endif
sele Proinrep
set filter to
sele Reports
if lastkey() <> K_ENTER
    mRet = .t.
endif
readupdated(tNestUpd)
keyboard chr(K_DOWN)
return(mRet)

PROC writeres
local GetList := {}
local mRet := .f.
tNestUpd = iif(tNestUpd,.t.,readupdated())
if lastkey() = K_ENTER .or. lastkey() = K_DOWN .or. lastkey() = K_TAB
    sele results
    set filter to Results->rep_id = Reports->rep_id
    go bott
    go top
    sele items
    set filter to items->pro_id = profiles->pro_id
    go bott
    go top
    if profiles->pro_mode='N'
        do while !eof() .and. (lastkey() != 27)    // items.dbf (filter: profiles->pro_id)
            @ workrow+15,workcol+21 say 'Item  :'+space(maxcol()-2-workcol+21-7)
            @ workrow+16,workcol+21 say 'Result:'+space(maxcol()-2-workcol+21-7)
            @ workrow+17,workcol+21 say 'Range :'+space(maxcol()-2-workcol+21-7)
            @ workrow+18,workcol+21 say 'Remark:'+space(maxcol()-2-workcol+21-7)
            ax='R'+ltrim(str(items->order,0))
            if items->char_num='N'
                mresult=0.000
            else
                mresult=space(len(results->result))
            endif
            if !islocated(Select('Results'),'Item_id',items->item_id)
                Results->(dbappend())
                replace Results->Rep_id with Reports->Rep_id,;
                        Results->Item_id with Items->item_id,;
                        Results->recdate with date()
            endif
            mdec=left(right(items->unit,3),1)
            d=val(mdec)
            if items->input_calc='C'   && char_num='N'
                v=items->calculate
                mresult=round(&v,d)
            elseif !empty(results->result)
                mresult=iif(items->char_num='C',results->result,val(results->result))
            endif
            @ workrow+15,workcol+29 say left(items->item_descr,34) 
            agedays=fPat_06+(fPat_05*30)+(int(fPat_05/2))+(fPat_04*365)+(int(fPat_04/4))
            mrange='Not found.'
            do case
            case agedays<(Company->kid_adult*365)+(int(Company->kid_adult/4)+1)+1
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
                case fPat_03 = 'M'
                    mrange = 'ADULT (M)'
                case fPat_03 = 'F'
                    mrange = 'ADULT (F)'
                case fPat_03 = 'P'
                    mrange = 'PREGNANT'
                endcase
            endcase
            sele ranges
            loca for item_id = results->item_id .and. upper(trim(category))=upper(trim(mrange))
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
            sele Items
            if items->char_num='C'
                @ workrow+16,workcol+29 get mresult pict '@S35' 
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
                        @ workrow+16,workcol+29 get mresult pict mpic range items->lowest,items->highest
                    else    // Character
                        @ workrow+16,workcol+29 get mresult pict mpic
                    endif
                else
                    d=val(mdec)
                    @ workrow+16,workcol+29 say str(mresult,10,d)+' (Calculated)'
                endif
            endif
            @ workrow+18,workcol+29 get results->remarks pict 'XXXXX' valid showat(workrow+18,workcol+29,iif(empty(results->remarks),'None.',results->remarks))
            setcursor(1)
            read
            setcursor(0)
            if items->char_num='C'
                replace results->result with mresult,;
                        results->recdate with date()
                &ax=0
            else
                replace results->result with iif(empty(mresult),'0.'+repl('0',d),str(mresult,10,d)),;
                        results->recdate with date()
                &ax=mresult
            endif
            skip
            if (lastkey() = 3)
        exit
            endif
        enddo
    else // Text item
        tScreen := savescreen(workrow+9, workcol+21,22,maxcol()-2)
        @ workrow+9, workcol+21 clear to 22,maxcol()-2
        do while !eof()     // items.dbf (filter: profiles->pro_id)
            if !islocated(Select('Results'),'Item_id',items->item_id)
                Results->(dbappend())
                replace Results->Rep_id with Reports->Rep_id,;
                        Results->Item_id with Items->item_id,;
                        Results->recdate with date()
            endif
            mrem = 'rem'+ltrim(str(items->order,0))
            &mrem = results->result + results->remarks
            @ workrow+8+items->order,workcol+22 get &mrem pict '@S40' color cReverse
            skip
        enddo
        setcursor(1)
        read
        setcursor(0)
        go top
        do while !eof()     // items.dbf (filter: profiles->pro_id)
            if !islocated(Select('Results'),'Item_id',items->item_id)
                Results->(dbappend())
                replace Results->Rep_id with Reports->Rep_id,;
                        Results->Item_id with items->item_id,;
                        Results->recdate with date()
            endif
            mrem='rem'+ltrim(str(items->order,0))
            replace results->result with left(&mrem,len(results->result)), ; 
                    results->remarks with right(&mrem,len(results->remarks)), ;
                    results->recdate with date()
            skip
        enddo
        restscreen(workrow+9, workcol+21,22,maxcol()-2,tScreen)
    endif
    sele results
    set filter to 
    sele items
    set filter to
endif
sele Reports
readupdated(tNestUpd)
mRet := .t.
return(mRet)

PROC changpros
tScreen := savescreen(5, workcol+20, 18, maxcol()-20)
@ 5, workcol+20 clear to 18, maxcol()-20
tsetdel := set(_SET_DELETED, .f.)
do while .t.
	sele Proinrep
    tproid = getbylist(5, workcol+20, 18, maxcol()-20,,'Profiles','Pro_id','Pro_Name',.t.,0)
    if lastkey() <> K_ESC
		set filter to Proinrep->Rep_id=Reports->Rep_id
		go bott
		go top
	    if islocated(Select('Proinrep'),'Pro_Id',tproid)
    		delete
			pack
	    else
        	append blank
	        replace Proinrep->rep_id with reports->rep_id, ; 
    	            Proinrep->pro_id with tproid, ;
        	        Proinrep->pro_name with profiles->pro_name, ;
            	    Proinrep->recdate with date()
        endif
		set filter to
		go bott
		go top
    endif
    prolist()
    @ workrow+9, workcol, 22,workcol+19 get mProlist LISTBOX aProlist scrollbar 
    clear gets
    do case
    case lastkey() = K_ESC
exit
    endcase
enddo
modify_res()
sele proinrep
sele Reports
set(_SET_DELETED, tsetdel)
restscreen(5,workcol+20,18,maxcol()-20,tScreen)
return(.t.)

func modify_res()
sayWait(1,"Creating Records...")
sele Proinrep
set filter to Proinrep->Rep_id=Reports->Rep_id
go bott
go top
sele results
delete all for Results->Rep_id = Proinrep->Rep_id // dangerous
//do NOT pack here!!
sele Proinrep
do while !eof()
	sele items
	set filter to Proinrep->Pro_id = Items->Pro_id
	go bott
	go top
	do while !eof() //items
		sele results
	   	go top
	    locate for Results->Rep_id = Proinrep->Rep_id .and. Results->Item_id=Items->Item_id
	    if found()
		   	recall
		else
			append blank
			replace Results->Rep_id with Proinrep->Rep_id,;
					Results->Item_id with Items->item_id,;
					Results->Recdate with date()
		endif
	    sele items
	    skip
	enddo
	sele items
	set filter to
	sele Proinrep
	skip
enddo
sele results
pack
sele Proinrep
set filter to
sayWait(0,"Creating Records...")
return

PROC PReps
MsgLeft('Print Lab Reports.', Maxrow(), .f., LLG_MODE_XOR)
sele Database
if database->(Dbseek(Upper(mMode+"Company.dbf")))
    openfile((alltrim(database->DATADIR)+database->DBFNAME), 0, ;
        iif( !empty(database->INDEXFILE), alltrim(database->DATADIR)+database->INDEXFILE, ''), ;
        alltrim(database->TAG) ,'Company')
    if database->(Dbseek(Upper(mMode+"Ranges.dbf")))
        openfile((alltrim(database->DATADIR)+database->DBFNAME), 0, ;
            iif( !empty(database->INDEXFILE), alltrim(database->DATADIR)+database->INDEXFILE, ''), ;
            alltrim(database->TAG) , 'Ranges')
        if database->(Dbseek(Upper(mMode+"Items.dbf")))
            openfile((alltrim(database->DATADIR)+database->DBFNAME), 0, ;
                iif( !empty(database->INDEXFILE), alltrim(database->DATADIR)+database->INDEXFILE, ''), ;
                alltrim(database->TAG) , 'Items')
            if database->(Dbseek(Upper(mMode+"Patients.dbf")))
                openfile((alltrim(database->DATADIR)+database->DBFNAME), 0, ;
                    iif( !empty(database->INDEXFILE), alltrim(database->DATADIR)+database->INDEXFILE, ''), ;
                    alltrim(database->TAG) , 'Patients')
                if database->(Dbseek(Upper(mMode+"Profiles.dbf")))
                    openfile((alltrim(database->DATADIR)+database->DBFNAME), 0, ;
                        iif( !empty(database->INDEXFILE), alltrim(database->DATADIR)+database->INDEXFILE, ''), ;
                        alltrim(database->TAG) , 'Profiles')
                    if database->(Dbseek(Upper(mMode+"Results.dbf")))
                        openfile((alltrim(database->DATADIR)+database->DBFNAME), 0, ;
                            iif( !empty(database->INDEXFILE), alltrim(database->DATADIR)+database->INDEXFILE, ''), ;
                            alltrim(database->TAG) , 'Results')
                        if database->(Dbseek(Upper(mMode+"Proinrep.dbf")))
                            openfile((alltrim(database->DATADIR)+database->DBFNAME), 0, ;
                                iif( !empty(database->INDEXFILE), alltrim(database->DATADIR)+database->INDEXFILE, ''), ;
                                alltrim(database->TAG) , 'Proinrep')
                            set relation to pro_id into profiles
                            if database->(Dbseek(Upper(mMode+"Refby.dbf")))
                                openfile((alltrim(database->DATADIR)+database->DBFNAME), 0, ;
                                    iif( !empty(database->INDEXFILE), alltrim(database->DATADIR)+database->INDEXFILE, ''), ;
                                    alltrim(database->TAG) ,'Refby')
                                if database->(Dbseek(Upper(mMode+"Reports.dbf")))
                                    openfile((alltrim(database->DATADIR)+database->DBFNAME), 0, ;
                                        iif( !empty(database->INDEXFILE), alltrim(database->DATADIR)+database->INDEXFILE, ''), ;
                                        alltrim(database->TAG) ,'Reports')
                                    set relation to pat_id into patients
                                    do plabrep
                                    Reports->(dbclosearea())
                                else
                                    warning(6,"REPORTS not found.")
                                endif
                                Refby->(dbclosearea())
                            else
                                warning(6,"REFBY not found.")
                            endif
                            Proinrep->(dbclosearea())
                        else
                            warning(6,"PROINREP not found.")
                        endif
                        Results->(dbclosearea())
                    else
                        warning(6,"RESULTS not found.")
                    endif
                    Profiles->(dbclosearea())
                else
                    warning(6,"PROFILES not found.")
                endif
                Patients->(dbclosearea())
            else
                warning(6,"PATIENTS not found.")
            endif
            Items->(dbclosearea())
        else
            warning(6,"ITEMS not found.")
        endif
        Ranges->(dbclosearea())
    else
        warning(6,"RANGES not found.")
    endif
    Company->(dbclosearea())
else
    warning(6,"COMPANY not found.")
endif
MsgLeft('Print Lab Reports.', Maxrow(), .t., LLG_MODE_XOR)
return

PROC plabrep
mid_from=0
mid_to=0
print=.f.
do while .t.
    clearwork()
    workcol := 12
    workrow := 6
    menurow := 6
    menucol := 12
    @ workrow-2, workcol say 'PRINT REPORT(S) :'
    @ workrow+1, workcol+17 say mid_from
    @ workrow+2, workcol+17 say mid_to
    @ menurow+1, menucol prompt 'Select From   :'
    @ menurow+2, menucol prompt 'Select To     :'
    @ menurow+5, menucol+2 prompt  ' Print '
    @ menurow+5, menucol+17 prompt ' Exit  '
    set key K_PGUP to nullkey
    set key K_PGDN to nullkey
    menu to choice3
    set key K_PGUP to
    set key K_PGDN to
    do case
    case choice3=1
        mid_from = getbylist(menurow+1, menucol+13,20,70,'Select &From ',Alias(),'Rep_Id','transform(Reports->Rep_Id,"@B 9999999999")+left(Patients->Pat_Name,25)+dtos(Reports->Today)',.f.,Company->CFG_REP_ID-1)
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
                audio(.f.)
                Alert('Report not found.')
                audio(.t.)
                mid_from=0
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
        mid_to = getbylist(menurow+2, menucol+13,20,70,'Select &From ',Alias(),'Rep_Id','transform(Reports->Rep_Id,"@B 9999999999")+left(Patients->Pat_Name,25)+dtos(Reports->Today)',.f.,Company->CFG_REP_ID-1)
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
                audio(.f.)
                Alert('Report not found.')
                audio(.t.)
                mid_to=0
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
        if print
            MsgLeft('Print Lab Reports.', Maxrow(), .t., LLG_MODE_XOR)
            MsgLeft('Prepare to print.', Maxrow(), .f., LLG_MODE_XOR)
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
                    for x=1 to mCopies
                        @ workrow+1, workcol say 'Ready to print Report ID: '+str(rep_id)
                        @ workrow+2, workcol say '                   Copy : '+ltrim(str(x))+' of '+ltrim(str(mCopies))
                        audio(.t.)
                        for tx = 1 to mCopies
                            if alert('Print', {'Ok','Cancel'} ) = 1
                                audio(.t.)
                                mReprint = 2
                                do while mReprint = 2
                                	sayWait(1,"Printing...")
                                    do printrep
                                	sayWait(0,"Printing...")
                                    mReprint = alert('Print it again?', {'No.','Yes.'} )
                                    audio(.t.)
                                    if mReprint = 1
                                        replace printed with .t.
                                    endif
                                enddo
                            endif
                        next
                    next
                else
                    audio(.f.)
                    alert('Payment not complete.;Please confirm payment to print.')
                    audio(.t.)
                endif
                sele reports
                skip
            enddo
            set filter to
            choice3=4
            MsgLeft('Prepare to print.', Maxrow(), .t., LLG_MODE_XOR)
            MsgLeft('Print Lab Reports.', Maxrow(), .f., LLG_MODE_XOR)
        else
            print=.f.
            audio(.f.)
            Alert('Please set range')
            audio(.t.)
            choice3=1
        endif
        mid_from=0
        mid_to=0
    otherwise
exit
    endcase
enddo
return

proc printrep       && for each report ID
MsgLeft('Prepare to print.', Maxrow(), .t., LLG_MODE_XOR)
MsgLeft('Printing '+procname()+'...', Maxrow(), .f., LLG_MODE_XOR)
set device to printer
if Upper(alltrim(mPrinter)) = 'TXT' .or. Upper(alltrim(mPrinter)) = 'TEXT'
	prnfile = "Rep"+right(alltrim(str(Reports->rep_id,0)),5)+".txt"
    set printer to (prnfile)
else
    set printer to
endif
set print on
sele Proinrep   && related to profiles
set filter to Proinrep->rep_id = Reports->rep_id
go bott
go top
tpcount = 0
mPagecount = 1
nPgFtLines = nPgFtLines()
do while !eof()
    if tpcount <> mPagecount
        printHeader()
        do pagehead
    endif
    rowsneeded := 1
    if !empty(proinrep->col_date) .and. !empty(proinrep->col_time)
        rowsneeded += 1
    endif
    if !empty(proinrep->exm_date) .and. !empty(proinrep->exm_time)
        rowsneeded += 1
    endif
    if !empty(proinrep->remarks)
        rowsneeded += 1
    endif
    if profiles->pro_type<>'T'  && Not a Test
        rowsneeded += 2
    endif
    rowsneeded += 1
    sele results
    set filter to Results->rep_id = reports->rep_id
    go bott
    go top
    sele items
    set filter to items->pro_id = proinrep->pro_id
    go bott
    go top
    count to tRn
    go top
    tRn = iif(reports->dbl_space='Y',tRn*2,tRn)
    rowsneeded += tRn
    if rowsneeded > mPage-mBmarg-prow()-1-iif(mFootperpage,nPgFtLines,0)
	    if mFootperpage
	    	pagefooter()
		endif
	    ptext="Cont'd next page..."
	    @ prow()+1,mRmarg-(len(ptext)/1.5) say chr(27)+chr(15)+ptext+chr(27)+chr(18)+':'
	    eject
	    mPagecount += 1
	    audio(.t.)
	    alert('Insert next page')
	    audio(.t.)
	    setprc(mTmarg,mLmarg)
        printHeader()
        do pagehead
    endif
    if !empty(proinrep->col_date) .and. !empty(proinrep->col_time)
        printLine(1,'Specimen: Collected '+dtoc(proinrep->col_date)+' '+left(str(proinrep->col_time,4,0),2)+':'+right(str(proinrep->col_time,4,0),2)+'hrs.')
    endif
    if !empty(proinrep->exm_date) .and. !empty(proinrep->exm_time)
        printLine(1,'          Examined  '+dtoc(proinrep->exm_date)+' '+left(str(proinrep->exm_time,4,0),2)+':'+right(str(proinrep->exm_time,4,0),2)+'hrs.')
    endif
    if !empty(proinrep->remarks)
        printLine(1,'Remarks : '+proinrep->remarks)
    endif
    if profiles->pro_type<>'T'  && Not a Test
        printLine(2,trim(profiles->pro_name))
		if mPrintbold
        	printLine(0,trim(profiles->pro_name))
        endif
        printLine(0,repl('_',len(trim(profiles->pro_name))))
    endif
    printLine(1,'')
    do while !eof()
        sele results
        go top
        loca for item_id = items->item_id
        do printl1               && results selected   && print details
        sele items
        skip
    enddo
    sele items
    set filter to
    sele proinrep
    printLine(1,'')
    skip
enddo
sele reports
if prow() > mPage-mBmarg-6
    setprc(mPage,mLmarg)
    printline(0,'')
    printHeader()
    do pagehead
endif
printLine(1,repl('_',mRmarg-mLmarg))
printLine(1,'General Notes: '+reports->remarks)
printLine(1,'')
printfooter()
set device to screen
set print off
if Upper(alltrim(mPrinter)) = 'TXT' .or. Upper(alltrim(mPrinter)) = 'TEXT'
    set printer to
else
    set printer to
endif
audio(.t.)
MsgLeft('Printing '+procname()+'...', Maxrow(), .t., LLG_MODE_XOR)
MsgLeft('Prepare to print.', Maxrow(), .f., LLG_MODE_XOR)
sele reports
return

proc printl1
pL=iif(reports->dbl_space='Y',2,1)
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
            printLine(pL,trim(items->item_descr))
			if mPrintbold
	            printLine( 0,trim(items->item_descr))
	        endif
            printLine( 0,repl('_',len(trim(items->item_descr))))
        else                        && Profile
            printLine(pL,space(1)+trim(items->item_descr))
        endif
        if items->char_num='C'
            if mpos='A'
                if malign='L'   && character, after, left
                    asayline = space(32)+ltrim(trim(results->result))
                    bsayline = space(32)+ltrim(trim(results->result))+iif(!empty(munit),' '+trim(munit),'')+' '+left(results->remarks,5)
                else            && character, after, right
                    mres=space(len(results->result)-len(trim(results->result)))+ltrim(trim(results->result))
                    asayline = space(32)+mres
                    bsayline = space(32)+mres+iif(!empty(munit),' '+trim(munit),'')+' '+left(results->remarks,5)
                endif
            else
                if malign='L'   && character, before, left
                    asayline = space(32+len(munit+' '))+ltrim(results->result)
                    bsayline = space(32)+munit+' '+ltrim(results->result)+' '+left(results->remarks,5)
                else            && character, before, right
                    mres=space(len(results->result)-len(trim(results->result)))+ltrim(trim(results->result))
                    asayline = space(32+len(munit+' '))+mres
                    bsayline = space(32)+munit+' '+mres+' '+left(results->remarks,5)
                endif
            endif
        else    && Numbers
            d=val(mdec)
            pnum=str(val(results->result),10,d)
            if mpos='A'
                if malign='L'   && Number, After, Left
                    asayline = space(28)+ltrim(pnum)
                    bsayline = space(28)+ltrim(pnum)+iif(!empty(munit),' '+trim(munit),'')+' '+left(results->remarks,5)
                else            && Number, After, Right
                    asayline = space(28)+transform(val(pnum),mpic)
                    bsayline = space(28)+transform(val(pnum),mpic)+iif(!empty(munit),trim(munit),'')+' '+left(results->remarks,5)
                endif
            else
                if malign='L'   && Number, Before, Left
                    asayline = space(28+len(munit))+ltrim(pnum)
                    bsayline = space(28)+munit+ltrim(pnum)+' '+left(results->remarks,5)
                else            && Number, Before, Right
                    asayline = space(28)+len(munit)+transform(val(pnum),mpic)
                    bsayline = space(28)+munit+transform(val(pnum),mpic)+' '+left(results->remarks,5)
                endif
            endif
        endif
		if mPrintbold
        	printLine(0,asayline)
        endif
        printLine(0,bsayline)
        pl=iif(reports->dbl_space='Y',2,1)
        agedays=patients->pat_days+(patients->pat_months*30)+(int(patients->pat_months/2))+(patients->pat_years*365)+(int(patients->pat_years/4))
        mrange='Not found.'
        do case
        case agedays<(Company->kid_adult*365)+(int(Company->kid_adult/4)+1)+1 //5846   && under 16 years
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
            printLine(0,makepline(,,rtrim(mrange)+' '+trim(munit)))
        endif
        sele items
    else    && Text (10 items)
        printLine(1,space(10)+results->result+results->remarks)
    endif
else
    printLine(pL,'Error! Result not found!')
endif
if tpcount <> mPagecount
    printHeader()
    do pagehead
endif
return

PROC pagehead
tpcount = mPagecount
//line 1
printLine(1,makepline(,,'Date: '+dtoc(reports->today)))
//line 2
sayline := makepline('PATIENT ID : '+ltrim(str(patients->pat_id)),;
    ,;
    'Report Ref: '+ltrim(str(reports->rep_id)))
printLine(1,sayline)
//line 3
sayline := makepline('Name       : '+ltrim(patients->pat_name),;
    ,;
    'Page No: '+transform(mPagecount,'99'))
printLine(1,sayline)
if mPrintbold
	printLine(0,'             '+ltrim(patients->pat_name))
endif
//line 4
mcSex = 'Sex        : ' + iif(patients->pat_sex='P','Pregnant',iif(patients->pat_sex='M','Male','Female'))
mcAge = '  Age: '+iif(patients->pat_years<>0,ltrim(str(patients->pat_years))+' Years ','')+iif(patients->pat_months<>0,ltrim(str(patients->pat_months))+' Months ','')+iif(patients->pat_days<>0,ltrim(str(patients->pat_days))+' Days','')
mcMachine = alltrim(Company->machine)
printLine(1, mcSex + mcAge)
//line 5
printLine(1, makepline('Ref.No     : '+ltrim(reports->refno),,mcMachine))
if mPrintbold
	printLine(0, makepline(             						,,mcMachine))
endif
if !empty(Company->machine)
	printLine(0, makepline(,,repl('_',len(mcMachine))))
endif
//line 6
refby1 = iif(islocated(Select('Refby'),'Ref_id',reports->ref_id),Refby->Name,'Record not found!')
do case
case upper(left(refby1,3)) = "C/O"
	refby1 = 'REFERRED by: '+refby1
case upper(left(refby1,3)) = "DR."
	refby1 = 'REFERRED by: '+refby1
case upper(left(refby1,6)) = "DOCTOR"
	refby1 = 'REFERRED by: '+refby1
case upper(left(refby1,4)) = "DOC."
	refby1 = 'REFERRED by: '+refby1
otherwise
	refby1 = 'REFERRED by: Dr. '+refby1
endcase
printLine(1,refby1)
//line 7
if !empty(patients->pat_remark)
    printLine(1,'Note       : '+ltrim(patients->pat_remark))
endif
//line 8
printLine(1,repl('_',mRmarg-mLmarg))
//line 9
sayline := makepline('LABORATORY REPORT',,'R E S U L T S             NORMAL VALUES')
printLine(1,sayline)
printLine(0,repl('_',mRmarg-mLmarg))

return

PROC AcPay
MsgLeft('Make payments.', Maxrow(), .f., LLG_MODE_XOR)
sele Database
if database->(Dbseek(Upper(mMode+"Profiles.dbf")))
    openfile((alltrim(database->DATADIR)+database->DBFNAME), 0, ;
        iif( !empty(database->INDEXFILE), alltrim(database->DATADIR)+database->INDEXFILE, ''), ;
        alltrim(database->TAG) , 'Profiles')
    go top
    if database->(Dbseek(Upper(mMode+"Patients.dbf")))
        openfile((alltrim(database->DATADIR)+database->DBFNAME), 0, ;
            iif( !empty(database->INDEXFILE), alltrim(database->DATADIR)+database->INDEXFILE, ''), ;
            alltrim(database->TAG) , 'Patients')
        if database->(Dbseek(Upper(mMode+"Proinrep.dbf")))
            openfile((alltrim(database->DATADIR)+database->DBFNAME), 0, ;
                iif( !empty(database->INDEXFILE), alltrim(database->DATADIR)+database->INDEXFILE, ''), ;
                alltrim(database->TAG) , 'Proinrep')
            if database->(Dbseek(Upper(mMode+"Reports.dbf")))
                openfile((alltrim(database->DATADIR)+database->DBFNAME), 0, ;
                    iif( !empty(database->INDEXFILE), alltrim(database->DATADIR)+database->INDEXFILE, ''), ;
                    alltrim(database->TAG) ,'Reports')
                set relation to pat_id into patients
                if database->(Dbseek(Upper(mMode+"Company.dbf")))
                    openfile((alltrim(database->DATADIR)+database->DBFNAME), 0, ;
                        iif( !empty(database->INDEXFILE), alltrim(database->DATADIR)+database->INDEXFILE, ''), ;
                        alltrim(database->TAG) ,'Company')
                    do makepay
                    Company->(dbclosearea())
                else
                    warning(6,"COMPANY not found.")
                endif
                Reports->(dbclosearea())
            else
                warning(6,"REPORTS not found.")
            endif
            Proinrep->(dbclosearea())
        else
            warning(6,"PROINREP not found.")
        endif
        Patients->(dbclosearea())
    else
        warning(6,"PATIENTS not found.")
    endif
    Profiles->(dbclosearea())
else                        
    warning(6,"PROFILES not found.")
endif
MsgLeft('Make payments.', Maxrow(), .t., LLG_MODE_XOR)
return(.t.)

proc makepay
mid_from=0
mid_to=0
getpay=.f.
select Reports
do while .t.
    clearwork()
    workcol := 12
    workrow := 6
    menurow := 6
    menucol := 12
    @ workrow-2, workcol say 'REPORT(S) TO MAKE PAYMENTS FOR:'
    @ workrow+1, workcol+17 say mid_from
    @ workrow+2, workcol+17 say mid_to
    @ menurow+1, menucol prompt 'Select From   :'
    @ menurow+2, menucol prompt 'Select To     :'
    @ menurow+5, menucol+2 prompt  'Payment'
    @ menurow+5, menucol+17 prompt ' Exit  '
    set key K_PGUP to nullkey
    set key K_PGDN to nullkey
    menu to choice3
    set key K_PGUP to
    set key K_PGDN to
    do case
    case choice3=1
        mid_from = getbylist(menurow+1, menucol+13,20,70,'Select &From ',Alias(),'Rep_Id','transform(Reports->Rep_Id,"@B 9999999999")+left(Patients->Pat_Name,25)+dtos(Reports->Today)',.f.,Company->CFG_REP_ID-1)
        if mid_from = 0
            @ workrow+1, workcol+21 say mid_from
            if mid_from = 0 .and. mid_to = 0
                choice3=1
                getpay=.f.
            else
                getpay=.t.
                choice3=3
            endif
        else
            seek mid_from
            if !found()
                mid_from=0
                audio(.f.)
                Alert('Report not found.')
                audio(.t.)
                @ workrow+1, workcol+21 say mid_from
                if mid_to = 0
                    getpay=.f.
                    choice3=1
                endif
            else
                getpay=.t.
                choice3=3
            endif
        endif
    case choice3=2
        mid_to = getbylist(menurow+2, menucol+11,20,70,'Select &To ',Alias(),'Rep_Id','transform(Reports->Rep_Id,"@B 9999999999")+left(Patients->Pat_Name,25)+dtos(Reports->Today)',.f.,Company->CFG_REP_ID-1)
        if mid_to = 0
            @ workrow+2, workcol+21 say mid_to
            if mid_to = 0 .and. mid_from = 0
                choice3=1
                getpay=.f.
            else
                getpay=.t.
                choice3=3
            endif
        else
            seek mid_to
            if !found()
                mid_to=0
                audio(.f.)
                Alert('Report not found.')
                audio(.t.)
                @ workrow+2, workcol+21 say mid_to
                if mid_from = 0
                    getpay=.f.
                    choice3=1
                endif
            else
                getpay=.t.
                choice3=3
            endif
        endif
    case choice3=3
        if getpay
            sele reports
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
                sele proinrep
                set filter to rep_id=reports->rep_id
                set relation to pro_id into profiles
                go bott
                go top
                do payment1
                sele reports
                skip
            enddo
            set filter to
            sele reports
            set filter to
            choice3=4
        else
            audio(.f.)
            Alert('Please set range.')
            audio(.t.)
            getpay=.f.
            audio(.f.)
            choice3=1
        endif
        mid_from=0
        mid_to=0
    otherwise
exit
    endcase
enddo
return

proc payment1
MsgLeft('Make payments.', Maxrow(), .t., LLG_MODE_XOR)
MsgLeft('Enter payment details.', Maxrow(), .f., LLG_MODE_XOR)
clearwork()
@ workrow,  workcol say 'Report ID : '+ltrim(str(rep_id)) 
@ workrow,  workcol+30 say '    Rates'
@ workrow,  workcol+45 say ' Payments'
@ workrow+11, workcol to workrow+11, maxcol()-workcol
@ workrow+12, workcol say 'Totals:'
x=1
mtotcost=0
do while !eof()
    if proinrep->cost=0
        replace proinrep->cost with profiles->pro_cost+profiles->markup
        replace proinrep->paid with profiles->pro_cost+profiles->markup
    endif
    mtotcost=mtotcost+proinrep->cost
    ax='a'+ltrim(str(x,0))
    &ax=proinrep->paid
    @ workrow+1+x,  workcol say proinrep->pro_name
    @ workrow+1+x,  workcol+30 say proinrep->cost pict '9999999.99'
    @ workrow+1+x,  workcol+45 get &ax pict '9999999.99' valid disptot()
    skip
    x=x+1
enddo
@ workrow+12, workcol+30 say mtotcost pict '9999999.99' 
do disptot
if reports->paid
    clear gets
    sum paid to mpayment
    @ workrow+12, workcol+45 say mpayment pict '9999999.99' 
    @ workrow+13, workcol+27 say '      Total paid:'
    mpd=mpayment
    @ workrow+13, workcol+45 get mpd pict '9999999.99'  valid mpd=mpayment
    audio(.t.)
    Alert('Payment already made.')
    audio(.t.)
    clear gets
else
    setcursor(1)
    read
    setcursor(0)
    audio(.t.)
    MsgLeft('Enter payment details.', Maxrow(), .t., LLG_MODE_XOR)
    MsgLeft('Enter Total.', Maxrow(), .f., LLG_MODE_XOR)
    go top
    for y=1 to x-1
        ax='a'+ltrim(str(y,0))
        replace proinrep->paid with &ax
        skip
    next
    sum paid to mpayment
    @ workrow+12, workcol+45 say mpayment pict '9999999.99' 
    @ workrow+13, workcol+27 say 'Enter total paid:'
    mpd=0
    @ workrow+13, workcol+45 get mpd pict '9999999.99' 
    setcursor(1)
    read
    setcursor(0)
    MsgLeft('Enter Total.', Maxrow(), .t., LLG_MODE_XOR)
    if mpd=mpayment
        tMsg = 'Payment confirmed.'
        MsgLeft(tMsg, Maxrow(), .f., LLG_MODE_XOR)
        audio(.t.)
        replace reports->paid with .t.
        replace reports->amount with mpd
    else
        tMsg = 'Last chance.'
        MsgLeft(tMsg, Maxrow(), .f., LLG_MODE_XOR)
        audio(.f.)
        @ workrow+13, workcol+45 get mpd pict '9999999.99' 
        setcursor(1)
        read
        setcursor(0)
        MsgLeft(tMsg, Maxrow(), .t., LLG_MODE_XOR)
        if mpd=mpayment
            tMsg = 'Payment confirmed.'
            MsgLeft(tMsg, Maxrow(), .f., LLG_MODE_XOR)
            audio(.t.)
            replace reports->paid with .t.
            replace reports->amount with mpd
        else
            tMsg = 'Payment not confirmed.'
            MsgLeft(tMsg, Maxrow(), .f., LLG_MODE_XOR)
            audio(.f.)
            replace reports->paid with .f.
            replace reports->amount with 0
        endif
    endif
    MsgLeft(tMsg, Maxrow(), .t., LLG_MODE_XOR)
    MsgLeft('Enter payment details.', Maxrow(), .f., LLG_MODE_XOR)
endif
return

proc disptot
mpayment=0
for y=1 to x-1
    ax='a'+ltrim(str(y,0))
    mpayment=mpayment+&ax
next
@ workrow+12, workcol+45 say mpayment pict '9999999.99' 
return(.t.)

PROC compinfo
MsgLeft('Entity Information.', Maxrow(), .f., LLG_MODE_XOR)
sele Database
seek Upper(mMode+"Company.dbf")
if !found()
    warning(6,"COMPANY not found.")
else
    openfile(alltrim(database->DATADIR)+database->DBFNAME, 0, , ,'Company')
    MsgLeft('Entity Information.', Maxrow(), .t., LLG_MODE_XOR)
    MsgLeft('F2 to Edit, Ctrl-P to Print', maxrow(), .f., LLG_MODE_XOR)
    do while .t.
        a = loadflds(select(),6,fcount(),'fCom_')
        tLm = 0
        if mPrint
            MsgLeft('F2 to Edit, Ctrl-P to Print', maxrow(), .t., LLG_MODE_XOR)
            MsgLeft('Printing '+procname()+'...', maxrow(), .f., LLG_MODE_XOR)
            sayWait(1,"Printing...")
            set device to printer
            if Upper(alltrim(mPrinter)) = 'TXT' .or. Upper(alltrim(mPrinter)) = 'TEXT'
                set printer to Company.txt
            else
                set printer to
            endif
            printHeader()
            tLm = mLmarg
        endif
        setcolor(cBar)
        @  2, tLm+2 clear to 2,maxcol()-2
        @  2, tLm+2 say 'COMPANY INFORMATION.'
        setcolor(cNormal)
        @  4, tLm+4 say 'Company Name    :'
        @  4,tLm+22 say fCom_06 pict '@S50'
        @  6, tLm+4 say 'Address         :'
        @  6,tLm+22 say fCom_07
        @  7, tLm+4 say '                :'
        @  7,tLm+22 say fCom_08
        @  9, tLm+4 say '            Tel :'
        @  9,tLm+22 say fCom_09
        @  9,tLm+40 say 'Fax :'
        @  9,tLm+46 say fCom_10
        @ 12, tLm+4 say 'Authorised Signatories:-'
        @ 13, tLm+4 say '1.'
        @ 13, tLm+7 say iif(empty(fCom_12),'<1st Doctor>',fCom_12)
        @ 13,tLm+40 say iif(empty(fCom_14),'<2nd Doctor>',fCom_14)
        @ 14, tLm+7 say fCom_13
        @ 14,tLm+40 say fCom_15
        @ 15, tLm+4 say '2.'
        @ 15, tLm+7 say iif(empty(fCom_16),'<M.L.T.>',fCom_16)
        @ 15,tLm+40 say iif(empty(fCom_18),'<Proprietor>',fCom_18)
        @ 16, tLm+7 say fCom_17
        @ 16,tLm+40 say fCom_19
        @ 17, tLm+4 say '3.'
        @ 17, tLm+7 say iif(empty(fCom_20),'<Other>',fCom_20)
        @ 18, tLm+7 say fCom_21
        @ 19, tLm+4 say 'Footnote:-'
        @ 20, tLm+4 say fCom_11
        @ 22, tLm+4 say 'Analyzer :'
        @ 22, tLm+15 say fCom_24
        if mPrint
            printFooter()
            Set device to screen
            if Upper(alltrim(mPrinter)) = 'TXT' .or. Upper(alltrim(mPrinter)) = 'TEXT'
                set printer to
            else
                set printer to
            endif
            sayWait(0,"Printing...")
            MsgLeft('Printing '+procname()+'...', maxrow(), .t., LLG_MODE_XOR)
            MsgLeft('F2 to Edit, Ctrl-P to Print', maxrow(), .f., LLG_MODE_XOR)
            Audio(.t.)
            mPrint := .f.
            keyboard chr(asc(""))
    loop
        else
		    keypressed = Waitforkey("Waiting ...")
            do case
            case keypressed = K_ESC .or. keypressed = 0
    exit
            case lastkey() = K_F2 .and. aAccess[2] <= AXL_COMPINFO
                MsgLeft('F2 to Edit, Ctrl-P to Print', maxrow(), .t., LLG_MODE_XOR)
                MsgLeft('Edit Mode', maxrow(), .f., LLG_MODE_XOR)
                setcolor(cGet)
                @  4,tLm+22 get fCom_06 pict '@S50' valid !empty(fCom_06)
                @  6,tLm+22 get fCom_07 //Addr1
                @  7,tLm+22 get fCom_08 //Addr2
                @  9,tLm+22 get fCom_09 //Tel
                @  9,tLm+46 get fCom_10 //Fax
                if empty(fCom_12)
                    fCom_12 := stuff(fCom_12,1,12,'<1st Doctor>')
                endif
                @ 13, tLm+7 get fCom_12 pict '@K' //Doc1
                @ 14, tLm+7 get fCom_13 //Doc1q
                if empty(fCom_14)
                    fCom_14 := stuff(fCom_14,1,12,'<2nd Doctor>')
                endif
                @ 13,tLm+40 get fCom_14 pict '@K' //Doc2
                @ 14,tLm+40 get fCom_15 //Doc2q
                if empty(fCom_16)
                    fCom_16 := stuff(fCom_16,1,8,'<M.L.T.>')
                endif
                @ 15, tLm+7 get fCom_16 pict '@K' //MLT
                @ 16, tLm+7 get fCom_17 //MLTq
                if empty(fCom_18)
                    fCom_18 := stuff(fCom_18,1,12,'<Proprietor>')
                endif
                @ 15,tLm+40 get fCom_18 pict '@K' //Prop
                @ 16,tLm+40 get fCom_19 //Propq
                if empty(fCom_20)
                    fCom_20 := stuff(fCom_20,1,7,'<Other>')
                endif
                @ 17, tLm+7 get fCom_20 pict '@K' //Other
                @ 18, tLm+7 get fCom_21 //Otherq
                @ 20, tLm+4 get fCom_11 //Note
                @ 22, tLm+15 get fCom_24 //Analyzer
                setcursor(1)
                read
                setcursor(0)
                audio(.t.)
                if fCom_12 = '<1st Doctor>'
                    fCom_12 := space(len(fCom_12))
                endif
                if fCom_14 = '<2nd Doctor>'
                    fCom_14 := space(len(fCom_14))
                endif
                if fCom_16 = '<M.L.T.>'
                    fCom_16 := space(len(fCom_16))
                endif
                if fCom_18 = '<Proprietor>'
                    fCom_18 := space(len(fCom_18))
                endif
                if fCom_20 = '<Other>'
                    fCom_20 := space(len(fCom_20))
                endif
                setcolor(cNormal)
                if readupdated()
                    if alert('Changes were made', {'Save', 'Discard'} ) = 1
                        audio(.t.)
                        a = saveflds(select(),6,fcount(),'fCom_')
                        replace recdate with date()
                    endif
                endif
                keyboard chr(asc("A"))
                MsgLeft('Edit Mode', maxrow(), .t., LLG_MODE_XOR)
                MsgLeft('F2 to Edit, Ctrl-P to Print', maxrow(), .f., LLG_MODE_XOR)
            case lastkey() = K_CTRL_P
                if alert('Print', {'Ok', 'Cancel'} ) = 1
                    audio(.t.)
                    mPrint = .t.
                endif
            endcase
        endif
    enddo
    MsgLeft('F2 to Edit, Ctrl-P to Print', maxrow(), .t., LLG_MODE_XOR)
    MsgLeft('Entity Information.', Maxrow(), .f., LLG_MODE_XOR)
    Company->(dbclosearea())
endif
MsgLeft('Entity Information.', Maxrow(), .t., LLG_MODE_XOR)
return

PROC EdPatDB
MsgLeft('Edit Patient File.', Maxrow(), .f., LLG_MODE_XOR)
sele Database
//openfile("Database", , "Database", "DBFNAME", 'Database')
seek Upper(mMode+"Company.dbf")
if !found()
    warning(6,"COMPANY not found.")
else
    openfile(alltrim(database->DATADIR)+database->DBFNAME, 0, , ,'Company')
endif
sele Database
seek Upper(mMode+"Patients.dbf")
if !found()
    warning(6,"PATIENTS not found.")
else
    openfile((alltrim(database->DATADIR)+database->DBFNAME), 0, ;
        iif( !empty(database->INDEXFILE), alltrim(database->DATADIR)+database->INDEXFILE, ''), ;
        alltrim(database->TAG) ,'Patients')
    MsgLeft('Edit Patient File.', Maxrow(), .t., LLG_MODE_XOR)
    MsgLeft('^F-Find, F2-Edit, ^P-Print', maxrow(), .f., LLG_MODE_XOR)
    do while .t.    //lastkey() <> K_ESC
        a = loadflds(select(),1,fcount(),'fPat_')
        tLm = 0
        if mPrint
            MsgLeft('^F-Find, F2-Edit, ^P-Print', maxrow(), .t., LLG_MODE_XOR)
            MsgLeft('Printing '+procname()+'...', maxrow(), .f., LLG_MODE_XOR)
            sayWait(1,"Printing...")
            set device to printer
            if Upper(alltrim(mPrinter)) = 'TXT' .or. Upper(alltrim(mPrinter)) = 'TEXT'
				prnfile = "Pat"+right(alltrim(str(fPat_01,0)),5)+".txt"
			    set printer to (prnfile)
            else
                set printer to
            endif
            printHeader()
            tLm = mLmarg
        endif
        setcolor(cBar)
        @ 2, tLm+2 clear to 2,maxcol()-2
        @ 2, tLm+2 say 'PATIENT INFORMATION.'
        @ 2, iif(mPrint,mRmarg,maxcol())-(15) say spac(15)
        @ 2, iif(mPrint,mRmarg,maxcol())-(3+len('ID: '+ltrim(str(fPat_01)))) say 'ID: '+ltrim(str(fPat_01))
        setcolor(cNormal)
        workrow := 4
        workcol := tLm := 4
        @ workrow+3, workcol    say 'Name   :'
        @ workrow+3, workcol+09 say fPat_02 pict '@S48' 
        @ workrow+4, workcol    say 'Sex    :'
        @ workrow+4, workcol+09 say fPat_03 pict '!'
        @ workrow+5, workcol    say 'Age    :     Yrs,     Months,     Days.'
        @ workrow+5, workcol+09 say fPat_04 pict '999' 
        @ workrow+5, workcol+19 say fPat_05 pict '99' 
        @ workrow+5, workcol+31 say fPat_06 pict '99' 
        @ workrow+7, workcol    say 'Addr   :'
        @ workrow+7, workcol+09 say fPat_07 pict '@S48'
        @ workrow+9, workcol    say 'Contact:'
        @ workrow+9, workcol+09 say fPat_08 pict '@S48'
        @ workrow+11,workcol    say 'Remarks:'
        @ workrow+11,workcol+09 say fPat_09 pict '@S48'
        if mPrint
            printFooter()
            Set device to screen
            if Upper(alltrim(mPrinter)) = 'TXT' .or. Upper(alltrim(mPrinter)) = 'TEXT'
                set printer to
            else
                set printer to
            endif
            sayWait(0,"Printing...")
            MsgLeft('Printing '+procname()+'...', maxrow(), .t., LLG_MODE_XOR)
            MsgLeft('^F-Find, F2-Edit, ^P-Print', maxrow(), .f., LLG_MODE_XOR)
            Audio(.t.)
            mPrint := .f.
    loop
        else
		    keypressed = Waitforkey("Waiting ...")
            do case
            case keypressed = K_ESC .or. keypressed = 0
    exit
            case lastkey() = K_PGUP
                skip -1
                if bof()
                    go top
                    audio(.f.)
                    alert('This is the first record.')
                    audio(.t.)
                endif
            case lastkey() = K_PGDN
                skip 1
                if eof()
                    go bott
                    audio(.f.)
                    alert('This is the last record.')
                    audio(.t.)
                endif
            case lastkey() = K_CTRL_PGUP
                Go Top
            case lastkey() = K_CTRL_PGDN
                Go Bott
            case lastkey() = K_F2 .and. CanAcces(AXL_EDPATDB)
                MsgLeft('F2 to Edit, Ctrl-P to Print', maxrow(), .t., LLG_MODE_XOR)
                MsgLeft('Edit Mode', maxrow(), .f., LLG_MODE_XOR)
                setcolor(cGet)
                @ workrow+3, workcol+09 get fPat_02 pict '@S48'    valid !empty(fPat_02)
                @ workrow+4, workcol+09 get fPat_03 pict '!'       valid((fPat_03='M' .or. fPat_03='P' .or. fPat_03='F'))
                @ workrow+5, workcol+09 get fPat_04 pict '999'     valid(fPat_04<110) 
                @ workrow+5, workcol+19 get fPat_05 pict '99'      valid(fPat_05<12) 
                @ workrow+5, workcol+31 get fPat_06 pict '99'      valid(fPat_06<30 .and. iif((fPat_04+fPat_05)=0,fPat_06>0,.t.)) 
                @ workrow+7, workcol+09 get fPat_07 pict '@S48'
                @ workrow+9, workcol+09 get fPat_08 pict '@S48'
                @ workrow+11,workcol+09 get fPat_09 pict '@S48'
                setcursor(1)
                read
                setcursor(0)
                audio(.t.)
                setcolor(cNormal)
                if readupdated()
                    if alert('Changes were made', {'Save', 'Discard'} ) = 1
                        audio(.t.)
                        a = saveflds(select(),1,fcount(),'fPat_')
                        replace recdate with date()
                    endif
                endif
                MsgLeft('Edit Mode', maxrow(), .t., LLG_MODE_XOR)
                MsgLeft('F2 to Edit, Ctrl-P to Print', maxrow(), .f., LLG_MODE_XOR)
            case lastkey() = K_CTRL_F
                MsgLeft('F2 to Edit, Ctrl-P to Print', maxrow(), .t., LLG_MODE_XOR)
                MsgLeft('Find Mode', maxrow(), .f., LLG_MODE_XOR)
                a = alert('Search by', {'List', 'ID', 'Name'} )
                audio(.t.)
                set key K_PGUP to nullkey
                set key K_PGDN to nullkey
                do case
                case a = 1
                    mList := {}
                    go top
                    do while !eof()
                        aadd(mList, { pat_name, str(pat_id) } )
                        skip
                    enddo
                    mPid = str(fPat_01)
                    @ workrow+3, workcol+9, 20,40 get mPid LISTBOX mList caption "Name   :" DROPDOWN SCROLLBAR color cListdwn
			        setcursor(1)
			        read
			        setcursor(0)
                    mPid = val(mPid)
                    seek mPid
                    if !found()
                        audio(.f.)
                        Alert("Not found.", "Ok")
                        go bott
                    endif
                    audio(.t.)
                case a = 2
                    mPid=0 
                    @ 2, maxcol()-12 get mPid
                    setcursor(1)
                    read
                    setcursor(0)
                    seek mPid
                    if !found()
                        audio(.f.)
                        Alert("Not found.", "Ok")
                        go bott
                    endif
                    audio(.t.)
                case a = 3
                    mpname=space(30)
                    @ workrow+3, workcol+09 get mPname
                    setcursor(1)
                    read
                    setcursor(0)
                    if !empty(mpname)
                        go top
                        loca for upper(trim(mpname)) $ upper(pat_name) ;
                            .or.  soundex(trim(mpname)) = soundex(pat_name)
                        if !found()
                            audio(.f.)
                            Alert("Not found.", "Ok")
                            go bott
                            audio(.t.)
                        else
                            do while !eof()
                                audio(.t.)
                                if Alert(trim(pat_name)+" Found.", {"Ok", "Next"}) = 2
                                    audio(.t.)
                                    continue
                                else
                            exit
                                endif
                            enddo
                        endif
                    endif
                endcase
                set key K_PGUP to
                set key K_PGDN to
                MsgLeft('Find Mode', maxrow(), .t., LLG_MODE_XOR)
                MsgLeft('F2 to Edit, Ctrl-P to Print', maxrow(), .f., LLG_MODE_XOR)
            case lastkey() = K_CTRL_P
                if alert('Print', {'Ok', 'Cancel'} ) = 1
                    audio(.t.)
                    mPrint = .t.
                endif
            endcase
        endif
    enddo
    MsgLeft('^F-Find, F2-Edit, ^P-Print', maxrow(), .t., LLG_MODE_XOR)
    MsgLeft('Edit Patient File.', Maxrow(), .f., LLG_MODE_XOR)
    Patients->(dbclosearea())
endif
Company->(dbclosearea())
MsgLeft('Edit Patient File.', Maxrow(), .t., LLG_MODE_XOR)
return

PROC EdProDB
MsgLeft('Edit Profiles File.', Maxrow(), .f., LLG_MODE_XOR)
/*
   Structure:                     ID's in   Company.dbf
                Profile                     Profiles.dbf
                   юд Items...              Items.dbf
                        юд Ranges...        Ranges.dbf
*/
sele Database
if database->(Dbseek(Upper(mMode+"Profiles.dbf")))
    openfile((alltrim(database->DATADIR)+database->DBFNAME), 0, ;
        iif( !empty(database->INDEXFILE), alltrim(database->DATADIR)+database->INDEXFILE, ''), ;
        alltrim(database->TAG) , 'Profiles')
    go top
    if database->(Dbseek(Upper(mMode+"Items.dbf")))
        openfile((alltrim(database->DATADIR)+database->DBFNAME), 0, ;
            iif( !empty(database->INDEXFILE), alltrim(database->DATADIR)+database->INDEXFILE, ''), ;
            alltrim(database->TAG) ,'Items')
        if database->(Dbseek(Upper(mMode+"Ranges.dbf")))
            openfile((alltrim(database->DATADIR)+database->DBFNAME), 0, ;
                iif( !empty(database->INDEXFILE), alltrim(database->DATADIR)+database->INDEXFILE, ''), ;
                alltrim(database->TAG) ,'Ranges')
            private aRanges[11]
            aRanges[1]  := 'NEWBORN'
            aRanges[2]  := '1 WEEK'
            aRanges[3]  := '1 MONTH'
            aRanges[4]  := '1 YEAR'
            aRanges[5]  := 'CHILD 1-6Y'
            aRanges[6]  := 'OVER 6Y'
            aRanges[7]  := 'ADULT (M)'
            aRanges[8]  := 'ADULT (F)'
            aRanges[9]  := 'PREGNANT'
            aRanges[10] := 'GENERAL'
            aRanges[11] := 'OTHER'
            if database->(Dbseek(Upper(mMode+"Company.dbf")))
                openfile((alltrim(database->DATADIR)+database->DBFNAME), 0, ;
                    iif( !empty(database->INDEXFILE), alltrim(database->DATADIR)+database->INDEXFILE, ''), ;
                    alltrim(database->TAG) ,'Company')
                do Edprodb1
                Company->(dbclosearea())
            else
                warning(6,"COMPANY not found.")
            endif
            Ranges->(dbclosearea())
        else
            warning(6,"RANGES not found.")
        endif
        Items->(dbclosearea())
    else
        warning(6,"ITEMS not found.")
    endif
    Profiles->(dbclosearea())
else                        
    warning(6,"PROFILES not found.")
endif
MsgLeft('Edit Profiles File.', Maxrow(), .t., LLG_MODE_XOR)
return(.t.)

PROC EdProdb1
clearwork()
MsgLeft('Edit Profiles File.', Maxrow(), .t., LLG_MODE_XOR)
MsgLeft('^F-Find, F2-Edit, ^N-New, ^P-Print', maxrow(), .f., LLG_MODE_XOR)
mItemlist = {}
mRangelist = {}
do itemseek
do rangeseek
do while .t.    //lastkey() <> K_ESC
    sele Profiles
    a = loadflds(select(),1,fcount(),'fPro_')
    setcolor(cBar)
    @ 2, 2 clear to 2,maxcol()-2
    @ 2, 2 say 'PROFILE INFORMATION.'
    @ 2, maxcol()-(15) say spac(15)
    @ 2, maxcol()-(2+len('ID: '+ltrim(str(fPro_01)))) say 'ID: '+ltrim(str(fPro_01))
    setcolor(cNormal)
    workrow := 2
    workcol := 2
    @ workrow+2, workcol    say 'Profile:'
    @ workrow+2, workcol+09 say fPro_02 pict '@S35!'
    @ workrow+2, workcol+44 say 'Mode:'
    @ workrow+2, workcol+50 say iif(fPro_04='N','Normal  ','Text    ')
    @ workrow+2, workcol+61 say 'Cost '+transform(fPro_08,'**,**9.99')
    @ workrow+3, workcol    say 'Specimen:'
    @ workrow+3, workcol+10 say fPro_05 pict '@S34'
    @ workrow+3, workcol+44 say 'Type:'
    @ workrow+3, workcol+50 say iif(fPro_03='T','Test    ','Profile ')
    @ workrow+3, workcol+61 say "M'up "+transform(fPro_09,'**,**9.99')
    @ workrow+4, workcol    say 'Collect.Method:'
    @ workrow+4, workcol+16 say fPro_06 pict '@S27'
    @ workrow+4, workcol+61 say 'Total'+transform(fPro_08+fPro_09,'**,**9.99')
    @ workrow+5, workcol to workrow+5, maxcol()-workcol
    @ workrow+6, workcol+1 say 'Items:'
    mItemid = iif(Items->(eof()),'None',str(Items->Item_id))
    @ workrow+7, workcol+1, 22,18 get mItemid LISTBOX mItemlist scrollbar color cListbox 
    clear gets
    @ workrow+7, workcol+19 say 'Item:'
    @ workrow+7, workcol+25 say Items->Item_descr
    @ workrow+7, workcol+60 say 'Reference: R'+ltrim(str(Items->order))+' '
    munit=left(Items->unit,len(Items->unit)-3)
    malign=right(Items->unit,1)        && Last character
    mpos=left(right(Items->unit,2),1)  && One-before-last character
    mdec=left(right(Items->unit,3),1)  && Two-before-last character
    @ workrow+9, workcol+19 say 'Unit:'
    @ workrow+9, workcol+25 say munit
    @ workrow+9, workcol+52 say 'Position:'
    @ workrow+9, workcol+62 say iif(mpos='B','Before result ','After result  ')
    @ workrow+11,workcol+19 say 'Result Properties:-'
    @ workrow+12,workcol+20 say iif(Items->input_calc='I','Input       ','Calculated  ')
    @ workrow+12,workcol+34 say iif(Items->char_num='C','Character  ','Number     ')
    @ workrow+12,workcol+48 say mdec+' Decimals '
    @ workrow+12,workcol+62 say iif(malign='R','Right align  ','Left align   ')
    @ workrow+13,workcol+19 say 'Formula:'
    @ workrow+13,workcol+28 say Items->Calculate
    @ workrow+14,workcol+19 say 'Valid Range: Lowest:'
    @ workrow+14,workcol+39 say Items->Lowest pict '99,999,999.999'
    @ workrow+14,workcol+54 say 'Highest:'
    @ workrow+14,workcol+62 say Items->Highest pict '99,999,999.999'
    @ workrow+16,workcol+19 say 'Ref.Ranges:'
    @ workrow+17,workcol+19 say 'Range:                  '
    mRangeCat = iif(Ranges->(eof()),'None',Ranges->Category)
    @ workrow+17,workcol+26 say mRangeCat
    @ workrow+17,workcol+44 say 'Value:'
    @ workrow+17,workcol+51 say Ranges->Range
    clear gets
    keypressed = Waitforkey("Waiting ...")
    do case
    case keypressed = K_ESC .or. keypressed = 0
exit
    case lastkey() = K_UP
        items->(dbskip(-1))
        do rangeseek
    case lastkey() = K_DOWN
        items->(dbskip(1))
        if items->(eof())
            items->(dbgobottom())
        endif
        do rangeseek
    case lastkey() = K_PGUP
        skip -1
        if bof()
            go top
            audio(.f.)
            alert('This is the first record.')
            audio(.t.)
        endif
        do itemseek
        do rangeseek
    case lastkey() = K_PGDN
        skip 1
        if eof()
            go bott
            audio(.f.)
            alert('This is the last record.')
            audio(.t.)
        endif
        do itemseek
        do rangeseek
    case lastkey() = K_CTRL_PGUP
        Go Top
        do itemseek
        do rangeseek
    case lastkey() = K_CTRL_PGDN
        Go Bott
        do itemseek
        do rangeseek
    case lastkey() = K_CTRL_N .and. CanAcces(AXL_EDPRODB)
        MsgLeft('^F-Find, F2-Edit, ^N-New, ^P-Print', maxrow(), .t., LLG_MODE_XOR)
        MsgLeft('Add Mode', maxrow(), .f., LLG_MODE_XOR)
        do addprofile
        do itemseek
		do rangeseek
        MsgLeft('Add Mode', maxrow(), .t., LLG_MODE_XOR)
        MsgLeft('^F-Find, F2-Edit, ^N-New, ^P-Print', maxrow(), .f., LLG_MODE_XOR)
    case lastkey() = K_CTRL_F
        MsgLeft('^F-Find, F2-Edit, ^N-New, ^P-Print', maxrow(), .t., LLG_MODE_XOR)
        MsgLeft('Find Mode', maxrow(), .f., LLG_MODE_XOR)
        a = alert('Search by', {'List', 'ID', 'Name'} )
        audio(.t.)
        set key K_PGUP to nullkey
        set key K_PGDN to nullkey
        do case
        case a = 1
            mList := {}
            go top
            do while !eof()
                aadd(mList, { pro_name, str(pro_id) } )
                skip
            enddo
            mProid = str(fPro_01)
            @ workrow+2, workcol+09, 20,40 get mProid LISTBOX mList caption 'Profile:' DROPDOWN SCROLLBAR 
        	setcursor(1)
    	    read
	        setcursor(0)
            mProid = val(mProid)
            seek mProid
            if !found()
                audio(.f.)
                alert("Not found.", "Ok")
                go bott
            endif
            audio(.t.)
        case a = 2
            mProid=0
            @ 2, maxcol()-12 get mProid
            setcursor(1)
            read
            setcursor(0)
            seek mProid
            if !found()
                audio(.f.)
                alert("Not found.", "Ok")
                go bott
            endif
            audio(.t.)
        case a = 3
            mproname=space(30)
            @ workrow+2, workcol+09 get mProname
            setcursor(1)
            read
            setcursor(0)
            if !empty(mproname)
                go top
                loca for upper(trim(mproname)) $ upper(pro_name) ;
                    .or.  soundex(trim(mproname)) = soundex(pro_name)
                if !found()
                    audio(.f.)
                    alert("Not found.", "Ok")
                    go bott
                    audio(.t.)
                else
                    do while !eof()
                        audio(.t.)
                        if Alert(trim(pro_name)+" Found.", {"Ok", "Next"}) = 2
                            audio(.t.)
                            continue
                        else
                            audio(.t.)
                    exit
                        endif
                    enddo
                endif
            endif
        endcase
        set key K_PGUP to
        set key K_PGDN to
        MsgLeft('Find Mode', maxrow(), .t., LLG_MODE_XOR)
        MsgLeft('^F-Find, F2-Edit, ^N-New, ^P-Print', maxrow(), .f., LLG_MODE_XOR)
        do itemseek
        do rangeseek
    case lastkey() = K_F2 .and. CanAcces(AXL_EDPRODB)
        MsgLeft('^F-Find, F2-Edit, ^N-New, ^P-Print', maxrow(), .t., LLG_MODE_XOR)
        MsgLeft('Edit Mode', maxrow(), .f., LLG_MODE_XOR)
        if fPro_04 = 'T' // Text
            fPro_03 = 'P' // Profile
        endif
        setcolor(cGet)
        @ workrow+2, workcol+09 get fPro_02 pict '@S35!' valid !empty(fPro_02)
        @ workrow+3, workcol+10 get fPro_05 pict '@S34'
        @ workrow+4, workcol+16 get fPro_06 pict '@S28'
        @ workrow+2, workcol+50, workrow+6, workcol+58 get fPro_04 listbox { {"Normal", "N"}, {"Text", "T"} } caption 'Mode:' color cListdwn dropdown 
        @ workrow+3, workcol+50, workrow+8, workcol+58 get fPro_03 listbox { {"Test", "T"}, {"Profile", "P"} } caption 'Type:' color cListdwn dropdown when fPro_04<>'T' 
        @ workrow+2, workcol+66 get fPro_08 pict '**,**9.99' valid (showat(workrow+4,workcol+66,transform(fPro_08+fPro_09,'**,**9.99')) .and. fPro_08>0 )
        @ workrow+3, workcol+66 get fPro_09 pict '**,**9.99' valid  showat(workrow+4,workcol+66,transform(fPro_08+fPro_09,'**,**9.99'))
        if fPro_03='P'         // Profile
            aadd(mItemlist, { "<add new item>", str(Company->cfg_itm_id) } )
        endif
        if fPro_04 = 'N' // Normal
            @ workrow+7, workcol+1, 22,18 get mItemid LISTBOX mItemlist color cListbox scrollbar valid itemedit(mItemid) 
        endif
        setcursor(1)
        read
        setcursor(0)
        setcolor(cNormal)
        audio(.t.)
        if readupdated()
            if alert('Changes were made', {'Save', 'Discard'} ) = 1
                audio(.t.)
                a = saveflds(select(),1,fcount(),'fPro_')
                replace recdate with date()
                if Profiles->Pro_Mode = 'T' // Text
                    sele items
                    go top
                    do while !eof()
                        sele ranges
                        dele all for item_id=items->item_id
                        pack
                        sele items
                        skip
                    enddo
                    go top
                    xl=1
                    mitlines=10     // set number of Text lines here
                    do while !eof()
                        if xl>mitlines
                            delete
                        endif
                        skip
                        xl += 1
                    enddo
                    pack
                    go top
                    for xl=1 to mitlines
                        if eof()
                            append blank
                            replace item_id with Company->cfg_itm_id, ;
                                    pro_id  with profiles->pro_id
                            reindex
                            seek Company->cfg_itm_id
                            if found()
                                replace Company->cfg_itm_id with Company->cfg_itm_id+1
                            else
                                warning(6,'Record creation error. (08.06)')
                            endif
                        endif
                        replace item_descr  with 'T'+ltrim(str(xl,0))+':', ;
                                order       with xl, ;
                                char_num    with 'C', ;
                                Input_calc  with 'I', ;
                                unit        with '', ;
                                calculate   with 'No calculation.', ;
                                lowest      with 0, ;
                                highest     with 0
                        skip
                    next
                    go top
                    go bott
                    replace profiles->tot_items with items->order
                endif
            endif
        endif
        MsgLeft('Edit Mode', maxrow(), .t., LLG_MODE_XOR)
        MsgLeft('^F-Find, F2-Edit, ^N-New, ^P-Print', maxrow(), .f., LLG_MODE_XOR)
        do itemseek
        do rangeseek
        sele profiles
    case lastkey() = K_CTRL_P
        if alert('Print', {'Ok', 'Cancel'} ) = 1
            audio(.t.)
            do prnpro
            do itemseek
            do rangeseek
        endif
    endcase
enddo
MsgLeft('^F-Find, F2-Edit, ^N-New, ^P-Print', maxrow(), .t., LLG_MODE_XOR)
MsgLeft('Edit Profiles File.', Maxrow(), .f., LLG_MODE_XOR)
return(.t.)

PROC addprofile
sele Profiles
append blank
replace pro_id      with Company->cfg_pro_id, ;
        pro_name    with 'NEW PROFILE', ;
        pro_mode            with 'N', ;         // Normal/Text
        pro_type            with 'P', ;         // Test/Profile
        recdate     with date()
reindex eval odometer(recno(),reccount()) every int(reccount()/50)
go top
if Profiles->(Dbseek(Company->cfg_pro_id))
    replace Company->cfg_pro_id with Company->cfg_pro_id+1, ;
            Company->recdate    with date()
    a = loadflds(select(),1,fcount(), 'fPro_')
    do additem
else
    warning(6,'Record Creation error. (08.07)')
endif
sele Profiles
return(.t.)

proc additem
do itemseek
do rangeseek
sele items
go top
mtotal = iif(bof(),0,1)
skip
do while !eof()
    mtotal += 1
    skip
enddo
if fPro_03='T' .and. mtotal=1  //profiles->pro_type
    audio(.f.)
    Alert('Only 1 item record required for a TEST.', 'Ok')
    audio(.t.)
    go top
else
    append blank
    replace item_id     with Company->cfg_itm_id, ;
            pro_id      with Profiles->pro_id, ;
            item_descr  with 'NEW ITEM.', ;
            order with mtotal+1, ;
            input_calc  with 'I', ;
            char_num    with 'N', ;
            Calculate   with 'None.', ;
            unit        with space(len(unit)-3)+'3AR', ;
            recdate     with date()
            reindex eval odometer(recno(),reccount()) every int(reccount()/50)
            go top
    seek Company->cfg_itm_id
    if found()
        replace Company->cfg_itm_id with Company->cfg_itm_id+1, ;
                Company->recdate    with date()
    else
        warning(6,'Record creation error. (08.08)')
    endif
endif
sele profiles
return(.t.)

proc itemseek
mItemlist = {}
mRangelist = {}
sele items
set filter to Items->Pro_id = Profiles->Pro_Id
go bott
go top
if eof()
    aadd(mItemlist, 'None' )
else
    if profiles->pro_type='T'   && Test
        skip
        do while !eof()
            sele ranges
            dele all for ranges->item_id = items->item_id
            pack
            sele items
            skip
        enddo
        Ranges->(dbreindex())	// not indexed, uses locate
        sele items
        dele all for order>1 .and. items->pro_id = profiles->pro_id
        pack
        reindex
        go top
        replace item_descr with profiles->pro_name
    endif
    go top
    do while !eof()
        aadd(mItemlist, { ltrim(Item_descr), str(item_id) } )
        skip
    enddo
endif
go top
sele Profiles
return (.t.)

proc rangeseek
sele Ranges
set filter to Items->Item_id = Ranges->Item_id
go bott
go top
if eof()
    aadd(mRangelist, 'GENERAL' )
else
    do while !eof()
        aadd(mRangelist, alltrim(Category) )
        skip
    enddo
endif
set filter to
go bott
go top
sele Profiles
return

proc itemedit (tItem)
local GetList := {}
mReturn = .f.
do case
case lastkey() = K_ENTER
	sele items
	Items->(dbseek(val(tItem)))
	do case
	case !items->(found()) .and. val(tItem) <> Company->cfg_itm_id
	    audio(.f.)
	    Alert('No items in database.', 'Ok')
	    audio(.t.)
	case fPro_04='N'       // Normal, not Text
	    mItemid1 = tItem
	    do while lastkey() <> K_ESC
	        if mItemid1 = str(Company->cfg_itm_id) ;
	                      .and. fPro_03<>"T" ;
	                      .and. lastkey() = K_ENTER
	            do addItem
	        endif
	        do itemseek
			do rangeseek
	        Items->(dbseek(val(mItemid1)))
	        if fPro_03='P'  && Profile
	            aadd(mItemlist, { "<add new item>", str(Company->cfg_itm_id) } )
	        endif
	        munit=left(items->unit,len(items->unit)-3)
	        malign=right(items->unit,1)        && Last character
	        if malign = ' '
	            malign = 'L'
	        endif
	        mpos=left(right(items->unit,2),1)  && One-before-last character
	        if mpos = ' '
	            mpos = 'A'
	        endif
	        mdec=left(right(items->unit,3),1)  && Two-before-last character
	        if mdec = ' '
	            mdec = '3'
	        endif
	        if fPro_03='T'  && Test
	            items->item_descr = fPro_02
	        endif
	        @ workrow+7, workcol+60 say 'Reference: R'+ltrim(str(Items->order))+' '
	        @ workrow+7, workcol+25 get items->item_descr pict '@S30!' valid !empty(items->item_descr) when fPro_03<>'T'
	        @ workrow+9, workcol+25 get munit
	        @ workrow+9, workcol+62,workrow+13, workcol+76 get mPos listbox { {"Before Result", "B"}, {"After Result", "A"} } color cListdwn dropdown
	        @ workrow+12,workcol+20,workrow+16,workcol+32 get items->input_calc listbox { {"Input", "I"}, {"Calculated", "C"} } color cListdwn dropdown when Items->Order > 1
	        @ workrow+12,workcol+34,workrow+16,workcol+44 get items->char_num listbox { {"Character", "C"}, {"Number", "N"} } color cListdwn dropdown when items->input_calc='I'
	        @ workrow+12,workcol+48,workrow+16,workcol+59 get mdec listbox { {'0 Decimals','0'},{'1 Decimal','1'},{'2 Decimals','2'},{'3 Decimals','3'} } color cListdwn dropdown scrollbar when items->char_num='N'
	        @ workrow+12,workcol+62,workrow+16,workcol+75 get malign listbox { {"Left align", "L"}, {"Right align", "R"} } color cListdwn dropdown 
	        @ workrow+13,workcol+28 get items->calculate pict '@S44'  when items->input_calc='C'
	        @ workrow+14,workcol+39 get items->lowest  pict '99,999,999.999'  when (items->char_num='N' .and. items->input_calc='I')
	        @ workrow+14,workcol+62 get items->highest pict '99,999,999.999'  when (items->char_num='N' .and. items->input_calc='I')
	        mRangeCat = iif(Ranges->(eof()),'GENERAL',alltrim(Ranges->Category))
	        @ workrow+17, workcol+26, workrow+20,workcol+36 get mRangeCat LISTBOX aRanges caption "Range:" color cListdwn dropdown scrollbar ;
	            valid getrange(mRangeCat)
	        if fPro_03='P'         // Profile
	            @ workrow+7, workcol+1, workrow+20,18 get mItemid1 LISTBOX mItemlist color cListbox scrollbar
	        endif
	        setcursor(1)
	        read
	        setcursor(0)
	        audio(.t.)
	        replace items->unit with munit+mdec+mpos+malign
	    enddo
	case fPro_04 = 'T'  // Text
	    fPro_03 := 'P'         // Profile (needed for text fileds)
        sele items
        go top
        do while !eof()
            sele ranges
            dele all for ranges->item_id=items->item_id
            pack
            sele items
            skip
        enddo
        Ranges->(dbreindex())
        go top
        xl=1
        mitlines=10     // set number of Text lines here
        do while !eof()
            if xl>mitlines
                delete
            endif
            skip
            xl += 1
        enddo
        pack
        go top
        for xl=1 to mitlines
            if eof()
                append blank
                replace item_id with Company->cfg_itm_id, ;
                        pro_id  with profiles->pro_id
                if items->item_id = Company->cfg_itm_id
                    replace Company->cfg_itm_id with Company->cfg_itm_id+1
                else
                    warning(6,'Record creation error. (08.09)')
                endif
            endif
            replace item_descr  with 'T'+ltrim(str(xl,0))+':', ;
                    order       with xl, ;
                    char_num    with 'C', ;
                    Input_calc  with 'I', ;
                    unit        with '', ;
                    calculate   with 'No calculation.', ;
                    lowest      with 0, ;
                    highest     with 0
            skip
        next
	endcase
	sele items // filtered
	go top
	go bott
	replace profiles->tot_items with items->order
	reindex
	do itemseek
	do rangeseek
	sele profiles
case lastkey() = K_ESC
	mReturn = .t.
endcase
return mReturn

PROC getrange (tRangeCat)
local GetList := {}
if lastkey() = K_ENTER .and. !empty(tRangeCat)
    sele ranges
    go top
	loca for ranges->item_id = items->item_id .and. upper(alltrim(ranges->category)) = upper(alltrim(tRangeCat))
//    seek alltrim(str(items->item_id))+tRangeCat
    if !found()
        append blank
        replace ranges->item_id with items->item_id,;
                ranges->category with upper(tRangeCat),    ;
                ranges->recdate with date()
        reindex
        go top
		loca for ranges->item_id = items->item_id .and. upper(trim(category))=upper(trim(tRangeCat))
//        seek alltrim(str(items->item_id))+tRangeCat
        if !found()
            warning(6,'Record creation error. (08.10)')
        endif
    endif
    a = loadflds(select(),1,fcount(),'fRng_')
    @ workrow+17, workcol+51 get fRng_05
    setcursor(1)
    read
    setcursor(0)
    audio(.t.)
    if readupdated()
        a = saveflds(select(),1,fcount(),'fRng_')
    endif
    sele items
endif
return(.f.)

proc prnpro
MsgLeft('^F-Find, F2-Edit, ^N-New, ^P-Print', maxrow(), .t., LLG_MODE_XOR)
MsgLeft('Printing '+procname()+'...', maxrow(), .f., LLG_MODE_XOR)
sayWait(1,"Printing...")
set device to printer
if Upper(alltrim(mPrinter)) = 'TXT' .or. Upper(alltrim(mPrinter)) = 'TEXT'
	prnfile = "Pro"+right(alltrim(str(profiles->pro_id,0)),5)+".txt"
    set printer to (prnfile)
else
    set printer to
endif
set print on
printHeader()
pl=prow()+1
@ pl,mLmarg+1 say chr(27)+chr(14)+'TEST/PROFILE INFORMATION'+chr(27)+chr(18)
pl=pl+2
*********************** DETAILS
@ pl,mLmarg say 'Test/Profile  : '+trim(profiles->pro_name)+'   (#'+ltrim(str(profiles->pro_id))+')'
if mPrintbold
	@ pl,mLmarg say 'Test/Profile  : '+trim(profiles->pro_name)
endif
pl=pl+1
@ pl,mLmarg say '      Specimen: '+profiles->pro_spec
pl=pl+1
@ pl,mLmarg say 'Collect.Method: '+profiles->pro_method
pl=pl+2
if profiles->pro_mode='T'       && Text not Normal
    @ pl,mLmarg say '          Item: This is a TEXT profile.'
    pl=pl+1
else
    sele items
    do while !eof()
        if profiles->pro_type='P'       && Profile not Test
            @ pl,mLmarg say 'R'+ltrim(str(order,3))+' - '+trim(item_descr)+'   (#'+ltrim(str(item_id))+')'
			if mPrintbold
    	        @ pl,mLmarg say 'R'+ltrim(str(order,3))+' - '+trim(item_descr)
    	    endif
            pl=pl+1
        endif
        if !empty(unit)
            @ pl,mLmarg say '       Unit: '+left(Items->unit,len(Items->unit)-3) + ;
                left(right(Items->unit,3),1)+' Decimals   ' + ;
                iif(right(Items->unit,1)='L','Left Aligned   ','Right Aligned   ') + ;
                iif(left(right(Items->unit,2),1)='A','After Result','Before Result')
            pl=pl+1
        endif
        if input_calc='C'
            @ pl,mLmarg say '       Calculation: '+trim(calculate)
            pl=pl+1
        endif
        @ pl,mLmarg say '       Reference Ranges:'
        if char_num='N' .and. input_calc='I'
            @ pl,mLmarg say '                               Lowest/Highest: '+ltrim(str(lowest))+'/'+ltrim(str(highest))
        endif
        pl=pl+1
        sele ranges
        set filter to item_id=items->item_id
        go top
        do while !eof()
            if !empty(range)
                @ pl,mLmarg say '         '+category+' - '+range
                skip
            endif
            if !eof() .and. !empty(range)
                @ pl,mLmarg+41 say category+' - '+range
                skip
            endif
            pl=pl+1
        enddo
        pl=pl+1
        sele items
        skip
    enddo
endif
printFooter()
set device to screen
set print off
if Upper(alltrim(mPrinter)) = 'TXT' .or. Upper(alltrim(mPrinter)) = 'TEXT'
    set printer to
else
    set printer to
endif
sayWait(0,"Printing...")
MsgLeft('Printing '+procname()+'...', maxrow(), .t., LLG_MODE_XOR)
MsgLeft('^F-Find, F2-Edit, ^N-New, ^P-Print', maxrow(), .f., LLG_MODE_XOR)
Audio(.t.)
return

FUNC KeyCycle()
do case
case upper(readvar()) = "FPAT_03"  // Sex (MFP)
	mAx = iif(fPat_03="M",1,iif(fPat_03="F",2,3))
	if lastkey() = K_CTRL_RIGHT
		mAx = iif(mAx=1,3,mAx-1)
	elseif lastkey() = K_CTRL_LEFT
		mAx = iif(mAx=3,1,mAx+1)
	endif
	fPat_03 = iif(mAx=1,"M",iif(mAx=2,"F","P"))
	showat(workrow+1, workcol+68,iif(fPat_03='P','Pregnant',iif(fPat_03='M','Male    ','Female  ')))
	tNestUpd = .t.
case upper(readvar()) = "FPAT_04"  // Years
	if lastkey() = K_CTRL_RIGHT .and. fPat_04 < 120
		fPat_04 += 1
	elseif lastkey() = K_CTRL_LEFT .and. fPat_04 > 0
		fPat_04 -= 1
	endif
	tNestUpd = .t.
case upper(readvar()) = "FPAT_05"  // Months
	if lastkey() = K_CTRL_RIGHT .and. fPat_05 < 11
		fPat_05 += 1
	elseif lastkey() = K_CTRL_LEFT .and. fPat_05 > 0
		fPat_05 -= 1
	endif
	tNestUpd = .t.
case upper(readvar()) = "FPAT_06"  // Days
	if lastkey() = K_CTRL_RIGHT .and. fPat_06 < 29
		fPat_06 += 1
	elseif lastkey() = K_CTRL_LEFT .and. fPat_06 > 0
		fPat_06 -= 1
	endif
	tNestUpd = .t.
case upper(readvar()) = "FREP_10"  // Double Spaced (YN)
	fRep_10 = iif(fRep_10 = "Y","N","Y")
	showat(workrow+5, workcol+73, iif(fRep_10='Y','Yes','No '))
	tNestUpd = .t.
otherwise
endcase
return (.t.)
