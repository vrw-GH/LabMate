* Sele 1 = Config
* Sele 2 = Company
clearmenu()
*-----------------------------
title('Print Sales & Analysis Reports')
message('Select Report.',.f.,.f.)
@ menurow+1,menucol say 'Daily Rep:' color '*'+mc_high+'/'+mc_back
set color to &c_prompt
@ menurow+2,menucol prompt 'Sales'
@ menurow+3,menucol prompt 'Analysis'
@ menurow+4,menucol prompt 'Exit'
menu to choice6
title('Print '+iif(choice6=1,'Sales','Analysis')+' Report')
clearwork()
set color to &c_defa
@ menurow+1,menucol say 'Daily Rep:' color mc_high+'/'+mc_back
do case
case choice6=1 .or. choice6=2
    mdate=date()
    @ 12, 25 say 'Date:' get mdate color c_get
    read
    do while .t.
        clearmenu()
        clearwork()
        message('Prepare to print.',.f.,.f.)
        @ 12, 25 say 'Prepare printer.'+iif(mCo_id=3," (On screen)","") color mc_high+'/'+mc_back
        @ menurow+1, menucol say 'PRINT' color '*'+mc_high+'/'+mc_back
        set color to &c_prompt
        @ menurow+2, menucol prompt '(Re)Print'
        @ menurow+3, menucol prompt 'Exit'
        menu to choice
        set color to &c_defa
        @ menurow+1, menucol say 'PRINT' color mc_high+'/'+mc_back
        @ 12, 25 say '                 '
        do case
        case choice=1
            do dayend
            pok='Y'
            message('Confirm print',.f.,.f.)
            @ 12, 25 say 'Print OK? Y/N' get pok pict '!' valid (pok='Y' .or. pok='N') color c_get
            read
            if pok='Y'
    exit
            endif
        otherwise
    exit
        endcase
    enddo
endcase
return

proc dayend
message('Printing ...',.t.,.f.)
if mCo_id<>3
    set device to printer
    set print on
endif
pl=0    && printed line no
pc=config->l_margin
fl=8    && page footer lines
tcost=0
trate=0
tdisc=0
tpaid=0
tprof=0
sele 6
use profiles index profiles
sele 5
use (mLogdir+'\patients') index (mLogdir+'\patients')
sele 4
use (mLogdir+'\proinrep')
sele 3
use (mLogdir+'\reports') index (mLogdir+'\reports')
set filter to today=mdate
go bott
go top
set relation to pat_id into patients
// REPORT FORM sales for inkey() != K_ESC
do phead
do rhead
do while !eof()
    tpaid=tpaid+reports->amount
    do ridhead
    sele proinrep
    set filter to rep_id=reports->rep_id
    go bott
    go top
    set relation to pro_id into profiles
    do while !eof()
        tcost=tcost+profiles->pro_cost
        trate=trate+proinrep->cost
        tdisc=tdisc+proinrep->cost-proinrep->paid
        tprof=tprof+proinrep->paid-profiles->pro_cost
        do printl
        sele proinrep
        skip
    enddo
    set relation to
    sele reports
    do ridfoot
    skip
enddo
do rfoot
if mCo_id<>3
    eject
    set device to screen
    set print off
endif
sele 3
use
sele 4
use
sele 5
use
sele 6
use
return

proc rhead
if choice6=2
    @ pl,pc say chr(27)+chr(14)+'DAILY SALES ANALYSIS REPORT'+chr(27)+chr(18)+' '
else
    @ pl,pc say chr(27)+chr(14)+'DAILY SALES REPORT'+chr(27)+chr(18)+' '
endif
pl=pl+1
@ pl,pc say 'As at : '+dtoc(mdate)
pl=pl+1
@ pl,pc say repl('_',config->pg_cols-pc)
pl=pl+1
@ pl,pc say repl('_',config->pg_cols-pc)
@pl,pc+1 say 'PROFILE DETAILS'
if choice6=2    && Sales analysis
    @pl,pc+28 say '     COST'
    @pl,pc+39 say '     RATE'
    @pl,pc+50 say '  INVOICED'
    @pl,pc+61 say 'PROFIT/LOSS'
else            && Sales report
    @pl,pc+39 say '     RATE'
    @pl,pc+50 say '  DISCOUNT'
    @pl,pc+61 say '     PAID'
endif
pl=pl+1         && 999,999.99
return

proc printl     && print proinrep
if pl>config->pg_lines-fl
    do phead
endif
pc=pc+1
@pl,pc say pro_name
if choice6=2
    @pl,pc+27 say profiles->pro_cost pict '999,999.99'
    @pl,pc+38 say profiles->pro_cost+profiles->markup pict '999,999.99'
    @pl,pc+49 say proinrep->paid pict '999,999.99'
    @pl,pc+60 say proinrep->paid-profiles->pro_cost pict '999,999.99'
else
    @pl,pc+38 say profiles->pro_cost+profiles->markup pict '999,999.99'
    @pl,pc+49 say proinrep->cost-proinrep->paid pict '999,999.99'
    @pl,pc+60 say proinrep->paid pict '999,999.99'
endif
pc=pc-1
pl=pl+1
return

proc rfoot
pl=pl+1
@ pl,pc say repl('_',config->pg_cols-pc)
pl=pl+1
@pl,pc say '  TOTALS:'
if choice6=2
    @pl,pc+26 say tcost pict '9,999,999.99'
    @pl,pc+37 say trate pict '9,999,999.99'
    @pl,pc+48 say tpaid pict '9,999,999.99'
    @pl,pc+59 say tprof pict '9,999,999.99'
else
    @pl,pc+37 say trate pict '9,999,999.99'
    @pl,pc+48 say tdisc pict '9,999,999.99'
    @pl,pc+59 say tpaid pict '9,999,999.99'
endif
pl=pl+1                      && 999,999.99
if pl<config->pg_lines-fl
    pl = config->pg_lines-fl
endif
@ pl,pc say repl('.',config->pg_cols-pc)
pl=pl+1
@ pl,pc say trim(company->co_other)
@ pl,config->pg_cols-len(trim(company->co_prop)) say trim(company->co_prop)
pl=pl+1
@ pl,pc+1 say trim(company->co_otherq)
@ pl,config->pg_cols-len(trim(company->co_propq)) say trim(company->co_propq)
pl=pl+1
@ pl,pc say repl('_',config->pg_cols-pc)
pl=pl+1
if pl<config->pg_lines-fl
    pl = config->pg_lines-fl
endif
return

proc ridhead
pl=pl+1
@ pl,pc say +'('+ltrim(str(reports->rep_id))+') '+trim(reports->refno)+' '+patients->pat_name
@pl,pc+71 say iif(!reports->paid,'*','')
pl=pl+1
return

proc ridfoot
return

proc phead
if pl>config->pg_lines-fl
    do pfoot
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

proc pfoot
@ pl,pc say repl('_',config->pg_cols-pc)
pl=pl+1
@ pl,config->pg_cols-len("Cont'd next page...")-1 say "Cont'd next page..."
pl=pl+1
if mCo_id<>3
    eject
else
    inkey(5)
endif
return
