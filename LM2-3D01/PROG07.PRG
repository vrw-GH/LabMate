* Sele 1 = Config
* Sele 2 = Company
*-----------------------------
do while .t.
    title('Print Information.')
    clearmenu()
    message('Select item to print.',.f.,.f.)
    @ menurow+1, menucol say 'Select:' color '*'+mc_high+'/'+mc_back
    set color to &c_prompt
    @ menurow+2, menucol prompt 'Company'
    @ menurow+3, menucol prompt 'Profile'
    @ menurow+4, menucol prompt 'Patient'
    @ menurow+5, menucol prompt 'Rates List'
    @ menurow+6, menucol prompt 'Exit'
    menu to choice7
    clearwork()
    set color to &c_defa
    @ menurow+1, menucol say 'Select:' color mc_high+'/'+mc_back
    do case
    case choice7=1
        title('Print Information - Company')
        sele company
        do confprn with 'prnco'
    case choice7=2
        title('Print Information - Profile')
        mId=0
        @ 12, 25 say 'Enter ID:' get mId color c_get
        read
        sele 3
        use profiles index profiles
        seek mId
        if found()
            sele 5
            use ranges
            sele 4
            use items index items
            set filter to items->pro_id=profiles->pro_id
            go bott
            go top
            sele company
            do confprn with 'prnpro'
            sele 4
            use
            sele 5
            use
        else
            message('Test/Profile not found!',.t.,.t.)
        endif
        sele 3
        use
/*    case (choice7=3 .or. choice7=4) .and. mCo_id=3
        message("Unavailable option.",.t.,.f.)
        inkey(5)
*/
    case choice7=3
        title('Print Information - Patient')
        mId=0
        @ 12, 25 say 'Enter ID:' get mId color c_get
        read
        sele 3
        use (mLogdir+'\patients') index (mLogdir+'\patients')
        seek mId
        if found()
            sele company
            do confprn with 'prnpat'
        else
            message('Patient not found!',.t.,.t.)
        endif
        sele 3
        use
    case choice7=4
        title('Print Information - Rates List')
        sele 3
        use profiles index profiles
        do confprn with 'ratelist'
        sele 3
        use
    otherwise
exit
    endcase
    drawwork()
enddo
return

proc confprn
param doproc
do while .t.
    do clearmenu
    do clearwork
    message('Prepare to print.',.f.,.f.)
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
        do &doproc
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
return

proc prnco
message('Printing company information...',.t.,.f.)
set device to printer
set print on
pc=config->l_margin
************************ HEADER
pl=config->t_margin
@ pl,pc say repl('_',config->pg_cols-pc)
@ pl,config->pg_cols-len(trim(company->co_name))*2-1 say chr(27)+chr(14)+trim(company->co_name)+chr(27)+chr(18)
pl=pl+1
@ pl,config->pg_cols-len(trim(company->co_addr1)+' '+trim(company->co_addr2)) say trim(company->co_addr1)+' '+trim(company->co_addr2)
@ pl,config->pg_cols-len(trim(company->co_addr1)+' '+trim(company->co_addr2)) say trim(company->co_addr1)+' '+trim(company->co_addr2)
pl=pl+1
@ pl,config->pg_cols-len('Tel:'+trim(company->co_tel)+' Fax:'+trim(company->co_fax)) say 'Tel:'+trim(company->co_tel)+' Fax:'+trim(company->co_fax)
pl=pl+1
@ pl,pc say chr(27)+chr(14)+'COMPANY INFORMATION'+chr(27)+chr(18)
pl=pl+2
*********************** DETAILS
@ pl,pc say 'Program:'
pl=pl+1
@ pl,pc say chr(27)+chr(14)+mProgram+chr(27)+chr(18)
pl=pl+1
@ pl,pc say mVersion
pl=pl+2
@ pl,pc say 'Developed by:'
pl=pl+1
@ pl,pc say chr(27)+chr(14)+'THE LEISURE CO.'+chr(27)+chr(18)
pl=pl+1
@ pl,pc say '288/82 Lot 3/C Kimbulapitiya Estate, Negombo, Sri Lanka.'
pl=pl+1
@ pl,pc say 'Tel/Fax: +94 (0)31 38731'
pl=pl+1
@ pl,pc say 'Prop/Developer: Victor R Wright'
pl=pl+1
@ pl,pc say 'Admin/Fin.: Honorine Wright (Mrs.)'
pl=pl+3
@ pl,pc say 'Registered to: '
pl=pl+1
@ pl,pc say iif(mReg,trim(company->co_name),trim(mRegco))
@ pl,pc say iif(mReg,trim(company->co_name),trim(mRegco))
pl=pl+1
@ pl,pc say '  '+company->co_addr1
pl=pl+1
@ pl,pc say '  '+company->co_addr2
pl=pl+1
@ pl,pc say '  Tel: '+company->co_tel
pl=pl+1
@ pl,pc say '  Fax: '+company->co_fax
pl=pl+2
@ pl,pc say 'Director/Prop:'
pl=pl+1
@ pl,pc say '  '+trim(company->co_prop)
pl=pl+1
@ pl,pc say '  '+trim(company->co_propq)
pl=pl+2
@ pl,pc say 'Registered Doctors:'
pl=pl+1
@ pl,pc say '  '+trim(company->co_doc1)
pl=pl+1
@ pl,pc say '  '+company->co_doc1q
pl=pl+1
@ pl,pc say '  '+trim(company->co_doc2)
pl=pl+1
@ pl,pc say '  '+company->co_doc2q
pl=pl+2
@ pl,pc say 'Laboratory Tech:'
pl=pl+1
@ pl,pc say '  '+trim(company->co_mlt)
pl=pl+1
@ pl,pc say '  '+company->co_mltq
pl=pl+2
@ pl,pc say 'Other:'
pl=pl+1
@ pl,pc say '  '+trim(company->co_other)
pl=pl+1
@ pl,pc say '  '+trim(company->co_otherq)
pl=pl+3
*********************** FOOTER
pl=config->pg_lines-4
@ pl,pc say repl('_',config->pg_cols-pc)
eject
set device to screen
set print off
return

proc prnpat
message('Printing patient information...',.t.,.f.)
set device to printer
set print on
pc=config->l_margin
************************ HEADER
pl=config->t_margin
@ pl,pc say repl('_',config->pg_cols-pc)
@ pl,config->pg_cols-len(trim(company->co_name))*2-1 say chr(27)+chr(14)+trim(company->co_name)+chr(27)+chr(18)
pl=pl+1
@ pl,config->pg_cols-len(trim(company->co_addr1)+' '+trim(company->co_addr2)) say trim(company->co_addr1)+' '+trim(company->co_addr2)
@ pl,config->pg_cols-len(trim(company->co_addr1)+' '+trim(company->co_addr2)) say trim(company->co_addr1)+' '+trim(company->co_addr2)
pl=pl+1
@ pl,config->pg_cols-len('Tel:'+trim(company->co_tel)+' Fax:'+trim(company->co_fax)) say 'Tel:'+trim(company->co_tel)+' Fax:'+trim(company->co_fax)
pl=pl+1
@ pl,pc say chr(27)+chr(14)+'PATIENT INFORMATION'+chr(27)+chr(18)
pl=pl+2
*********************** DETAILS
@ pl,pc say 'Patient ID: '+ltrim(str(patients->pat_id))
pl=pl+1
@ pl,pc say '      Name: '+patients->pat_name
@ pl,pc say '      Name: '+patients->pat_name
pl=pl+2
@ pl,pc say '       Sex: '+iif(patients->pat_sex='P','Pregnant',iif(patients->pat_sex='M','Male','Female'))
pl=pl+1
@ pl,pc say '       Age: '+str(patients->pat_years,3,0)+' Years  '+str(patients->pat_months,2,0)+' Months  '+str(patients->pat_days,2,0)+' Days'
pl=pl+2
@ pl,pc say '   Address: '+patients->pat_addr
pl=pl+1
@ pl,pc say '   Contact: '+patients->pat_contct
pl=pl+2
@ pl,pc say '      Note: '+patients->pat_remark
pl=pl+1
*********************** FOOTER
pl=config->pg_lines-4
@ pl,pc say repl('_',config->pg_cols-pc)
eject
set device to screen
set print off
return

proc prnpro
message('Printing test/profile information...',.t.,.f.)
set device to printer
set print on
pc=config->l_margin
************************ HEADER
pl=config->t_margin
@ pl,pc say repl('_',config->pg_cols-pc)
@ pl,config->pg_cols-len(trim(company->co_name))*2-1 say chr(27)+chr(14)+trim(company->co_name)+chr(27)+chr(18)
pl=pl+1
@ pl,config->pg_cols-len(trim(company->co_addr1)+' '+trim(company->co_addr2)) say trim(company->co_addr1)+' '+trim(company->co_addr2)
@ pl,config->pg_cols-len(trim(company->co_addr1)+' '+trim(company->co_addr2)) say trim(company->co_addr1)+' '+trim(company->co_addr2)
pl=pl+1
@ pl,config->pg_cols-len('Tel:'+trim(company->co_tel)+' Fax:'+trim(company->co_fax)) say 'Tel:'+trim(company->co_tel)+' Fax:'+trim(company->co_fax)
pl=pl+1
@ pl,pc say chr(27)+chr(14)+'TEST/PROFILE INFORMATION'+chr(27)+chr(18)
pl=pl+2
*********************** DETAILS
@ pl,pc say 'Test/Profile  : '+trim(profiles->pro_name)+'   (#'+ltrim(str(profiles->pro_id))+')'
@ pl,pc say 'Test/Profile  : '+trim(profiles->pro_name)
pl=pl+1
@ pl,pc say '      Specimen: '+profiles->pro_spec
pl=pl+1
@ pl,pc say 'Collect.Method: '+profiles->pro_method
pl=pl+2
if profiles->pro_mode='T'       && Text not Normal
    @ pl,pc say '          Item: This is a TEXT profile.'
    pl=pl+1
else
    sele items
    do while !eof()
        if profiles->pro_type='P'       && Profile not Test
            @ pl,pc say 'R'+ltrim(str(order,3))+' - '+trim(item_descr)+'   (#'+ltrim(str(item_id))+')'
            @ pl,pc say 'R'+ltrim(str(order,3))+' - '+trim(item_descr)
            pl=pl+1
        endif
        if !empty(unit)
            @ pl,pc say '       Unit: '+unit
            pl=pl+1
        endif
        if input_calc='C'
            @ pl,pc say '       Calculation: '+trim(calculate)
            pl=pl+1
        endif
        @ pl,pc say '       Reference Ranges:'
        if char_num='N' .and. input_calc='I'
            @ pl,pc say '                               Lowest/Highest: '+ltrim(str(lowest))+'/'+ltrim(str(highest))
        endif
        pl=pl+1
        sele ranges
        set filter to item_id=items->item_id
        go bott
        go top
        do while !eof()
            @ pl,pc say '         '+category+' - '+range
            skip
            if !eof()
                @ pl,pc+41 say category+' - '+range
                skip
            endif
            pl=pl+1
        enddo
        pl=pl+1
        sele items
        skip
    enddo
endif
*********************** FOOTER
pl=config->pg_lines-4
@ pl,pc say repl('_',config->pg_cols-pc)
eject
set device to screen
set print off
return

proc ratelist
message('Printing Rates List...',.t.,.f.)
set device to printer
set print on
pc=config->l_margin
************************ HEADER
pl=config->t_margin
@ pl,pc say repl('_',config->pg_cols-pc)
@ pl,config->pg_cols-len(trim(company->co_name))*2-1 say chr(27)+chr(14)+trim(company->co_name)+chr(27)+chr(18)
pl=pl+1
@ pl,config->pg_cols-len(trim(company->co_addr1)+' '+trim(company->co_addr2)) say trim(company->co_addr1)+' '+trim(company->co_addr2)
@ pl,config->pg_cols-len(trim(company->co_addr1)+' '+trim(company->co_addr2)) say trim(company->co_addr1)+' '+trim(company->co_addr2)
pl=pl+1
@ pl,config->pg_cols-len('Tel:'+trim(company->co_tel)+' Fax:'+trim(company->co_fax)) say 'Tel:'+trim(company->co_tel)+' Fax:'+trim(company->co_fax)
pl=pl+1
@ pl,pc say chr(27)+chr(14)+'RATES'+chr(27)+chr(18)
pl=pl+1
@ pl,pc say repl('_',config->pg_cols-pc)
@ pl,pc say 'As at : '+dtoc(date())
pl=pl+2
*********************** DETAILS
go top
pc=pc+1
do while !eof()
    @ pl,pc say profiles->pro_name
    @ pl,pc say profiles->pro_name+'- Rs.'+str(profiles->pro_cost+profiles->markup,10,2)
    skip
*    if !eof()
*        @ pl,pc+35 say profiles->pro_name
*        @ pl,pc+35 say profiles->pro_name+'- Rs.'+str(profiles->pro_cost+profiles->markup,10,2)
*        skip
*    endif
    pl=pl+1
enddo
pc=pc-1
*********************** FOOTER
if pl<config->pg_lines-5
    pl = config->pg_lines-5
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
@ pl,(config->pg_cols-pc-len(trim(company->co_note)))/2 say trim(company->co_note)
pl=pl+1
if pl<config->pg_lines-5
    pl = config->pg_lines-5
endif
eject
set device to screen
set print off
return

