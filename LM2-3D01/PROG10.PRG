* Sele 1 = Config
* Sele 2 = Company
sele company
do while .t.
    clearmenu()
    title('Change System Options')
    set color to &c_prompt
    @ menurow+1, menucol say 'Edit:' color '*'+mc_high+'/'+mc_back
    @ menurow+2, menucol prompt 'Company'
    @ menurow+3, menucol prompt 'System'
    @ menurow+4, menucol prompt 'Printing'
    @ menurow+5, menucol prompt 'Other'
    @ menurow+6, menucol prompt 'Exit'
    menu to choice10
    clearwork()
    set color to &c_defa
    @ menurow+1, menucol say 'Edit:' color mc_high+'/'+mc_back
    do case
    case choice10=1
        title('Change Company Info')
        do editcomp
    case choice10=2
        title('Change System Info')
        do editsys
    case choice10=3
        title('Change Printer Page Info')
        do editprin
    case choice10=4
        title('Change Other Info')
        do editoth
    otherwise
exit
    endcase
    drawwork()
enddo
return

proc editcomp
clearwork()
sele company
mco_name=co_name
mco_addr1 =co_addr1 
mco_addr2 =co_addr2
mco_tel = co_tel
mco_fax = co_fax
mco_note = co_note 
mco_prop = co_prop 
mco_propq = co_propq 
mco_doc1 = co_doc1 
mco_doc1q = co_doc1q 
mco_doc2 = co_doc2
mco_doc2q = co_doc2q
mco_MLT  = co_MLT 
mco_mltq = co_mltq 
mco_other  = co_other 
mco_otherq = co_otherq
message('Use  keys to select field and make changes.',.f.,.f.)
if mReg
        @ workrow+0, workcol say '         Changing the 1st 20 characters of the Company Name will' color mc_text+'/'+mc_back
        @ workrow+1, workcol say 'create a temporary, un-registered company by the new name.' color mc_text+'/'+mc_back
        @ workrow+0, workcol say 'Warning: ' color '*+R/'+mc_back
        @ workrow+4, workcol+1 get mco_name pict '@S48!' valid !empty(mco_name) color c_get
else
    if upper(left(mco_name,20)) = upper(left(mGenco,20))
        @ workrow+0, workcol say '         This is DEMO company Info.' color mc_text+'/'+mc_back
        @ workrow+0, workcol say 'Note   : ' color '+R/'+mc_back
    else
        @ workrow+0, workcol say '         This is Unregistered company Info.' color mc_text+'/'+mc_back
        @ workrow+0, workcol say '!!!!   : ' color '+R/'+mc_back
    endif
    @ workrow+4, workcol+1 get mco_name pict '@S48!' valid !empty(mco_name) color c_get
endif
@ workrow+3, workcol say 'Company Name:' color mc_high+'/'+mc_back
@ workrow+5, workcol say 'Address:' color mc_high+'/'+mc_back
@ workrow+6, workcol+1 get mco_addr1 color c_get
@ workrow+7, workcol+1 get mco_addr2 color c_get
@ workrow+5, workcol+31 say 'Contact Nos:' color mc_high+'/'+mc_back
@ workrow+6, workcol+32 say 'Tel:' get mco_tel color c_get
@ workrow+7, workcol+32 say 'Fax:' get mco_fax color c_get
@ workrow+9, workcol say 'Special Note:' color mc_high+'/'+mc_back
@ workrow+10, workcol+1 get mco_note pict '@S60' color c_get
@ workrow+12, workcol say 'Names & Designations:' color mc_high+'/'+mc_back
@ workrow+13, workcol+1 say 'Owner:' get mco_prop pict '@S25' color c_get
@ workrow+13, workcol+35 say '-' get mco_propq pict '@S20' color c_get
@ workrow+14, workcol+1 say 'Doc.1:' get mco_doc1 pict '@S25' color c_get
@ workrow+14, workcol+35 say '-' get mco_doc1q pict '@S20' color c_get
@ workrow+15, workcol+1 say 'Doc.2:' get mco_doc2 pict '@S25' color c_get
@ workrow+15, workcol+35 say '-' get mco_doc2q pict '@S20' color c_get
@ workrow+16, workcol+1 say 'M.L.T:' get mco_MLT pict '@S25' color c_get
@ workrow+16, workcol+35 say '-' get mco_mltq pict '@S20' color c_get
@ workrow+17, workcol+1 say 'Other:' get mco_other pict '@S25' color c_get
@ workrow+17, workcol+35 say '-' get mco_otherq pict '@S20' color c_get
if mCo_id=3
    clear gets
    set cursor off
    inkey(5)
    set cursor on
else
    read
endif
if upper(left(mco_name,20)) <> upper(left(co_name,20))  // Change of registered co name
    mReg=.f.
    mCo_id=2
    mLogid='TempCo'
    seek 2
    if !found()
        copy to co2 for co_id=1
        append from co2
        dele file co2.dbf
        replace co_id with 2, Logid with mLogid, dir with mLogid, cfg_rep_id with 100, cfg_pat_id with 100, password with ' '
        reindex eval Progress(1,100) every 1
        seek 2
        !md &mLogid
        sele 0
        //
        // create blank copies of user databases
        //
        use (mLogdir+'\results')
        copy stru to (mLogid+'\results')
        use
        //
        use (mLogdir+'\proinrep')
        copy stru to (mLogid+'\proinrep')
        use
        //
        use (mLogdir+'\reports')
        copy stru to (mLogid+'\reports')
        copy file (mLogdir+'\reports.ntx') to (mLogid+'\reports.ntx')
        use (mLogid+'\reports') index (mLogid+'\reports')
        reindex eval Progress(1,100) every 1
        use
        //
        use (mLogdir+'\patients')
        copy stru to (mLogid+'\patients')
        copy file (mLogdir+'\patients.ntx') to (mLogid+'\patients.ntx')
        use (mLogid+'\patients') index (mLogid+'\patients')
        reindex eval Progress(1,100) every 1
        use
        //
    endif
    sele company
    replace co_name with mco_name
    mReg=iif(upper(left(company->co_name,20))=upper(left(mRegco,20)),.t.,.f.)
    mCompany=company->co_name
    mLogdir=rtrim(mDefdir)+'\'+trim(company->dir)
    mULog=company->logid
    message('Sub-company created for new name.',.f.,.t.)
endif
replace co_addr1 with mco_addr1 
replace co_addr2 with mco_addr2
replace co_tel with mco_tel
replace co_fax with mco_fax
replace co_note with mco_note 
replace co_prop with mco_prop 
replace co_propq with mco_propq 
replace co_doc1 with mco_doc1 
replace co_doc1q with mco_doc1q 
replace co_doc2 with mco_doc2
replace co_doc2q with mco_doc2q
replace co_MLT  with mco_MLT 
replace co_mltq with mco_mltq 
replace co_other  with mco_other 
replace co_otherq with mco_otherq
screen1(mReg)
sele config
return

proc editsys
clearwork()
message('Use  keys to select field and make changes.',.f.,.f.)
@ workrow+1, workcol say '                              0.1 to 5.0 Seconds' color mc_text+'/'+mc_back
@ workrow+1, workcol say 'Wait-State     :' get config->speed color c_get range 0.1,5.0
@ workrow+2, workcol say 'Mode ID        :' get company->logid pict '@!@A' color c_get when mCo_id<>3 valid !empty(company->logid)
@ workrow+3, workcol say 'Password       :' get company->password color c_get when mCo_id<>3 
@ workrow+6, workcol say 'Maximum age (years) for a child:' get config->kid_adult color c_get valid (config->kid_adult>7 .and. config->kid_adult<18) when mCo_id<>3 
@ workrow+9 , workcol say 'Colors:' color mc_high+'/'+mc_back
@ workrow+10, workcol+21 say 'лллл' color config->c_back
@ workrow+10, workcol+1 say 'Background     :' get config->c_back pict '99' valid dispword(config->c_back) color c_get
@ workrow+11, workcol+21 say 'лллл' color config->c_text
@ workrow+11, workcol+1 say 'Text           :' get config->c_text pict '99' valid dispword(config->c_text) color c_get
@ workrow+12, workcol+21 say 'лллл' color config->c_line
@ workrow+12, workcol+1 say 'Lines          :' get config->c_line pict '99' valid dispword(config->c_line) color c_get
@ workrow+13, workcol+21 say 'лллл' color config->c_high
@ workrow+13, workcol+1 say 'Highlited text :' get config->c_high pict '99' valid dispword(config->c_high) color c_get
@ workrow+14, workcol+21 say 'лллл' color config->c_sele
@ workrow+14, workcol+1 say 'Selection      :' get config->c_sele pict '99' valid dispword(config->c_sele) color c_get
@ workrow+17, workcol say 'Set age of old records to archive (days):' get config->archivdays color c_get range 1,62 when mCo_id=1
read
do case
case mCo_id=1
    mRlog=company->logid
case mCo_id=2
    mUlog=company->logid
endcase
mc_back=ltrim(rtrim(config->c_back))
mc_text=ltrim(rtrim(config->c_text))
mc_line=ltrim(rtrim(config->c_line))
mc_high=ltrim(rtrim(config->c_high))
mc_sele=ltrim(rtrim(config->c_sele))
c_defa= mc_text+'/'+mc_back+','+mc_back+'/'+mc_text+','+mc_back
c_prompt=mc_text+'/'+mc_back+','+mc_back+'/'+mc_sele+','+mc_back
c_get=mc_text+'/'+mc_back+','+mc_back+'/'+mc_sele
set color to &c_defa
return

proc editprin
do clearwork
message('Use  keys to select field and make changes.',.f.,.f.)
@ workrow+1,  workcol+18 say 'Page:' color mc_high+'/'+mc_back
@ workrow+2,  workcol+18 say chr(9)+'                            '+chr(9) color mc_back+'/w'
@ workrow+3,  workcol+18 say chr(9)+'  Top margin :              '+chr(9) color mc_back+'/w'
@ workrow+4,  workcol+18 say chr(9)+'                            '+chr(9) color mc_back+'/w'
@ workrow+5,  workcol+18 say chr(9)+'                            '+chr(9) color mc_back+'/w'
@ workrow+6,  workcol+18 say chr(9)+'  Left margin:              '+chr(9) color mc_back+'/w'
@ workrow+7,  workcol+18 say chr(9)+'                            '+chr(9) color mc_back+'/w'
@ workrow+8,  workcol+18 say chr(9)+'                            '+chr(9) color mc_back+'/w'
@ workrow+9,  workcol+18 say chr(9)+'  Columns    :              '+chr(9) color mc_back+'/w'
@ workrow+10, workcol+18 say chr(9)+'                            '+chr(9) color mc_back+'/w'
@ workrow+11, workcol+18 say chr(9)+'                            '+chr(9) color mc_back+'/w'
@ workrow+12, workcol+18 say chr(9)+'  Page lines :              '+chr(9) color mc_back+'/w'
@ workrow+13, workcol+18 say chr(9)+'                            '+chr(9) color mc_back+'/w'
@ workrow+14, workcol+18 say chr(9)+'                            '+chr(9) color mc_back+'/w'
@ workrow+15, workcol+18 say chr(9)+'                            '+chr(9) color mc_back+'/w'
@ workrow+16, workcol+18 say chr(9)+'  Copies     :              '+chr(9) color mc_back+'/w'
@ workrow+17, workcol+18 say chr(9)+'                            '+chr(9) color mc_back+'/w'
@ workrow+3,  workcol+35 get config->t_margin color '0/7,0/'+mc_sele valid config->t_margin<16
@ workrow+6,  workcol+35 get config->l_margin color '0/7,0/'+mc_sele valid config->l_margin<16
@ workrow+9,  workcol+35 get config->pg_cols color '0/7,0/'+mc_sele valid (config->pg_cols<=132)
@ workrow+12, workcol+35 get config->pg_lines color '0/7,0/'+mc_sele valid config->pg_lines>config->t_margin+1
@ workrow+16, workcol+35 get config->copies color '0/7,0/'+mc_sele valid config->copies>0 when mCo_id<>3 
read
return

proc editoth
do clearwork
message('Use  keys to select field and make changes.',.f.,.f.)
@ workrow+1, workcol say 'Bio-Chem. analyzer:' color mc_high+'/'+mc_back
@ workrow+2, workcol+1 get config->biochem color c_get when mCo_id<>3 
@ workrow+4, workcol say 'Last reference by :' color mc_high+'/'+mc_back
@ workrow+5, workcol+1 get config->Refby pict '@S48' color c_get when mCo_id<>3 
if mCo_id=3
    clear gets
    set cursor off
    inkey(5)
    set cursor on
else
    read
endif
return

