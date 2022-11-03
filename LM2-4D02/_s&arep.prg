// The Leisure Company.
// All Rights Reserved.

proc AcRates
MsgLeft('Print Rates List.', Maxrow(), .f., LLG_MODE_XOR)
sele Database
if database->(Dbseek(Upper(mMode+"Company.dbf")))
    openfile((alltrim(database->DATADIR)+database->DBFNAME), 2, ;
        iif( !empty(database->INDEXFILE), alltrim(database->DATADIR)+database->INDEXFILE, ''), ;
        alltrim(database->TAG) , 'Company')
    go 1
    if database->(Dbseek(Upper(mMode+"Profiles.dbf")))
        openfile((alltrim(database->DATADIR)+database->DBFNAME), 3, ;
            iif( !empty(database->INDEXFILE), alltrim(database->DATADIR)+database->INDEXFILE, ''), ;
            alltrim(database->TAG) )
        go top
        sort to Protemp on pro_name
        use
        use Protemp alias 'Profiles'
        for tx = 1 to mCopies
            if Alert('Prepare to print.', {'Ok','Cancel'} ) = 1
                audio(.t.)
                MsgLeft('Print Rates List.', Maxrow(), .t., LLG_MODE_XOR)
                MsgLeft('Printing '+procname()+'...', maxrow(), .f., LLG_MODE_XOR)
                sayWait(1,"Printing...")
                set device to printer
                if Upper(alltrim(mPrinter)) = 'TXT' .or. Upper(alltrim(mPrinter)) = 'TEXT'
					prnfile = "Rates"+".txt"
				    set printer to (prnfile)
                else
                    set printer to
                endif
                set print on
                lastPgFt = mFootperpage
                mFootperpage = .f.
				nPgFtLines = nPgFtLines()
                printHeader()
                sayline = chr(27)+chr(14)+'Charge Rates'+chr(27)+chr(18)
                printLine(1,sayline)
                printLine(1,'As at : '+dtoc(date()))
                printLine(0,repl('_',mRmarg-mLmarg))
                printLine(1,' ')
                go top
                mLmarg=mLmarg+1
                setprc(prow()+1,mLmarg)
                do while !eof() 
                    sayline = makepline( '#' +transform(profiles->pro_id,"@B 9999999999") + profiles->pro_name, ;
                        , ;
                        '- Rs.' + transform(profiles->pro_cost+profiles->markup,"99,999.99"))
                    printLine(1,sayline)
                    skip
                enddo
                mLmarg=mLmarg-1
                printFooter()
                set device to screen
                mFootperpage = lastPgFt
                set print off
                if Upper(alltrim(mPrinter)) = 'TXT' .or. Upper(alltrim(mPrinter)) = 'TEXT'
                    set printer to
                else
                    set printer to
                endif
                sayWait(0,"Printing...")
                MsgLeft('Printing '+procname()+'...', maxrow(), .t., LLG_MODE_XOR)
                MsgLeft('Print Rates List.', Maxrow(), .f., LLG_MODE_XOR)
                audio(.t.)
            endif
        next
        Profiles->(dbclosearea())
        ferase("protemp.dbf")
    endif
    Company->(dbclosearea())
endif
MsgLeft('Print Rates List.', Maxrow(), .t., LLG_MODE_XOR)
return

PROC AcRepA
choice6=1
do AcRep
return

PROC AcRepB
choice6=2
do AcRep
return

PROC AcRep
clearwork()
MsgLeft('Print Sales & Analysis Reports.', Maxrow(), .f., LLG_MODE_XOR)
sele database
if database->(Dbseek(Upper(mMode+"Company.dbf")))
    openfile((alltrim(database->DATADIR)+database->DBFNAME), 2, ;
        iif( !empty(database->INDEXFILE), alltrim(database->DATADIR)+database->INDEXFILE, ''), ;
        alltrim(database->TAG) , 'Company')
    go 1
    if database->(Dbseek(Upper(mMode+"Profiles.dbf")))
        openfile((alltrim(database->DATADIR)+database->DBFNAME), 3, ;
            iif( !empty(database->INDEXFILE), alltrim(database->DATADIR)+database->INDEXFILE, ''), ;
            alltrim(database->TAG) , 'Profiles' )
        if database->(Dbseek(Upper(mMode+"Patients.dbf")))
            openfile((alltrim(database->DATADIR)+database->DBFNAME), 4, ;
                iif( !empty(database->INDEXFILE), alltrim(database->DATADIR)+database->INDEXFILE, ''), ;
                alltrim(database->TAG) , 'Patients' )
            if database->(Dbseek(Upper(mMode+"Proinrep.dbf")))
                openfile((alltrim(database->DATADIR)+database->DBFNAME), 5, ;
                    iif( !empty(database->INDEXFILE), alltrim(database->DATADIR)+database->INDEXFILE, ''), ;
                    alltrim(database->TAG) , 'Proinrep' )
                if database->(Dbseek(Upper(mMode+"Reports.dbf")))
                    openfile((alltrim(database->DATADIR)+database->DBFNAME), 6, ;
                        iif( !empty(database->INDEXFILE), alltrim(database->DATADIR)+database->INDEXFILE, ''), ;
                        alltrim(database->TAG) , 'Reports' )
                    mdatefrom = date()-1
                    mdate = date()
                    mSaleCat = Company->Sale_Cat
                    mZerosales = Company->Zerosales
                    mCutoffTime = Company->CutoffTime
                    @ 10, 20 say 'Print report from (Date):' get mdatefrom valid mdatefrom<=date()
                    @ 11, 20 say 'Print report   to (Date):' get mdate valid mdate>=mdatefrom .and. mdate<=date()
                    @ 12, 20 say 'Filter Reports by       :' get mSaleCat 	Pict "!!!!!"
                    @ 13, 20 say 'Include Zero Sales?  Y/N:' get mZeroSales 	pict "Y"
                    @ 14, 20 say 'Report Cut-off Time     :' get mCutoffTime pict "9999" valid val(mCutoffTime)<2360 .and. val(mCutoffTime)>=0 .and. val(right(mCutoffTime,2))<60
                    setcursor(1)
                    read
                    setcursor(0)
                    mSaleCat=alltrim(upper(iif(empty(mSaleCat),"ALL",mSaleCat)))
                    replace Company->Sale_Cat with mSaleCat
                    replace Company->Zerosales with mZeroSales
                    replace Company->CutoffTime with mCutoffTime
                    do case
                    case mZeroSales .and. mSaleCat="ALL"
	                    set filter to ;
	                    (today=mdate .and. val(time) <= val(mCutoffTime)) ;
	                    .or. (today=mdatefrom .and. val(time) > val(mCutoffTime)) ;
	                    .or. between(today, mdatefrom+1, mdate-1)
                    case mZeroSales .and. mSaleCat<>"ALL"
	                    set filter to ;
                    	( (today=mdate .and. val(time) <= val(mCutoffTime)) ;
	                    	.or. (today=mdatefrom .and. val(time) > val(mCutoffTime)) ;
	                    	.or. between(today, mdatefrom+1, mdate-1) ) ;
	                    .and. upper(left(Refno,len(alltrim(mSaleCat))))=mSaleCat
                    case !mZeroSales .and. mSaleCat="ALL"
	                    set filter to ;
	                    ( (today=mdate .and. val(time) <= val(mCutoffTime)) ;
	                    	.or. (today=mdate-1 .and. val(time) > val(mCutoffTime)) ;
	                    	.or. between(today, mdatefrom+1, mdate-1) ) ;
	                    .and. Amount<>0
                    case !mZeroSales .and. mSaleCat<>"ALL"
	                    set filter to ;
	                    ( (today=mdate .and. val(time) <= val(mCutoffTime)) ;
	                    	.or. (today=mdate-1 .and. val(time) > val(mCutoffTime)) ;
	                    	.or. between(today, mdatefrom+1, mdate-1) ) ;
	                    .and. Amount<>0 .and. upper(left(Refno,len(alltrim(mSaleCat))))=mSaleCat
                    endcase
                    go bott
                    go top
                    set relation to pat_id into Patients
                    for tx = 1 to mCopies
                        if lastkey() <> 27 .and. Alert('Prepare to print.', {'Ok','Cancel'} ) = 1
                            audio(.t.)
                            MsgLeft('Print Sales & Analysis Reports.', Maxrow(), .t., LLG_MODE_XOR)
                            MsgLeft('Printing '+procname()+'...', maxrow(), .f., LLG_MODE_XOR)
                            sayWait(1,"Printing...")
                            set device to printer
                            if Upper(alltrim(mPrinter)) = 'TXT' .or. Upper(alltrim(mPrinter)) = 'TEXT'
								prnfile = "S&ARep"+".txt"
							    set printer to (prnfile)
                            else
                                set printer to
                            endif
                            set print on
			                lastPgFt = mFootperpage
			                mFootperpage = .f.
							nPgFtLines = nPgFtLines()
                            tcost=0
                            tinvd=0
                            trate=0
                            tdisc=0
                            tpaid=0
                            tprof=0
                            sele Profiles
                            if choice6=2
                                printHeader('H-AcRep1')
                                sayline = chr(27)+chr(14)+'Daily Sales Analysis Report'+chr(27)+chr(18)
                            else
                                printHeader('H-AcRep2')
                                sayline = chr(27)+chr(14)+'Daily Sales Report'+chr(27)+chr(18)
                            endif
                            printLine(1,sayline)
                            printLine(1,'Period : '+dtoc(mdatefrom)+' to '+dtoc(mdate)+'  (Cut-off time: '+mCutoffTime+'hrs.)')
                            printLine(0,repl('_',mRmarg-mLmarg))
                            printLine(1,'')
                            if choice6=2    && Sales analysis
                                sayline = 'COST      RATE   INVOICED PROF/LOSS'
                            else            && Sales report
                                sayline = 'RATE  DISCOUNT      PAID '
                            endif
                            sayline = makepline('REPORT DETAILS',;
                                ,;
                                sayline)
                            printLine(1,sayline)
                            printLine(0,sayline)
                            do while !eof()
                                tpaid=tpaid+reports->amount
                                sayline = iif(!reports->paid,'*(',' (')+dtoc(reports->today)+' '+ltrim(str(reports->rep_id))+') ' ;
                                    +trim(reports->refno)+' '+patients->pat_name
                                sayline = makepline(sayline,;
                                    ,;
                                    iif(choice6=1,'         ','')+'-Paid->>   '+transform(reports->amount,'999,999.99'))
                                printLine(2,sayline)
                                sele proinrep
                                set filter to rep_id=reports->rep_id
                                go bott
                                go top
                                set relation to pro_id into profiles
                                do while !eof()
                                    tcost=tcost + profiles->pro_cost
                                    trate=trate + profiles->pro_cost+profiles->markup
                                    tinvd=tinvd + proinrep->cost
                                    tprof=tprof + proinrep->paid - profiles->pro_cost
                                    tdisc=tdisc + proinrep->cost - proinrep->paid
                                    if choice6=2
                                        sayline = ;
                                            +transform(profiles->pro_cost,'999,999.99');
                                            +transform(profiles->pro_cost+profiles->markup,'999,999.99');
                                            +transform(proinrep->cost,'999,999.99');
                                            +transform(proinrep->paid - profiles->pro_cost,'999,999.99')
                                    else
                                        sayline = ;
                                            +transform(proinrep->cost,'999,999.99');
                                            +transform(proinrep->cost - proinrep->paid,'999,999.99');
                                            +'          '
                                    endif
                                    sayline = makepline(iif(proinrep->cost<>0 .and. proinrep->paid=0,' *','  ')+pro_name,;
                                        ,;
                                        sayline)
                                    if mZeroSales .or. profiles->pro_cost+profiles->markup <> 0
	                                    printLine(1,sayline)
	                                endif
                                    sele proinrep
                                    skip
                                enddo
                                set relation to
                                sele reports
                                skip
                            enddo
                            printLine(1,repl('_',mRmarg-mLmarg))
                            if choice6=2
                                sayline = ;
                                    +transform(tcost,'999,999.99');
                                    +transform(trate,'999,999.99');
                                    +transform(tinvd,'999,999.99');
                                    +transform(tprof,'999,999.99')
                            else    
                                sayline = ;
                                    +transform(tinvd,'999,999.99');
                                    +transform(tdisc,'999,999.99');
                                    +transform(tpaid,'999,999.99')
                            endif
                            sayline = makepline('     TOTALS:',;
                                ,;
                                sayline)
                            printLine(1,sayline)
                            if choice6=2
                                printFooter('F-AcRep1')
                            else    
                                printFooter('F-AcRep2')
                            endif
                            set device to screen
			                mFootperpage = lastPgFt
                            set print off
                            if Upper(alltrim(mPrinter)) = 'TXT' .or. Upper(alltrim(mPrinter)) = 'TEXT'
                                set printer to
                            else
                                set printer to
                            endif
                            sayWait(0,"Printing...")
                            MsgLeft('Printing '+procname()+'...', maxrow(), .t., LLG_MODE_XOR)
                            MsgLeft('Print Sales & Analysis Reports.', Maxrow(), .f., LLG_MODE_XOR)
                            audio(.t.)
                        endif
                    next
                    Reports->(dbclosearea())
                endif
                Proinrep->(dbclosearea())
            endif
            Patients->(dbclosearea())
        endif
        Profiles->(dbclosearea())
    endif
    Company->(dbclosearea())
endif
MsgLeft('Print Sales & Analysis Reports.', Maxrow(), .t., LLG_MODE_XOR)
return
