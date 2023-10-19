* Sele 1 = Config
* Sele 2 = Company
title('Archive paid reports older than '+ltrim(str(config->archivdays,0))+' days')
set cursor off
do clearwork
do clearmenu
*-----------------------------
message('Please wait ...',.f.,.f.)
do case
case mCo_id=1
    if mReg
        // Make sure today's archive is not yet done
        mdir='BK'+left(dtoc(date()),2)+substr(dtoc(date()),4,2)+right(dtoc(date()),2)
        if !file(mdir+'\*.bak')
            mfile1='REPARCH'
            mfile2='DETARCH'
            mfile3='RESARCH'
            setpos(msgrow,msgcol+5)
            !md archives   //  create archive directory
            setpos(msgrow,msgcol+5)
            !md &mdir   // create the date backup directory
            do arch1    // normal archive
        else
            message('An archive file for today already exists!',.t.,.t.)
        endif
    else
        message('Please register this program to use this feature.',.t.,.t.)
    endif
case mCo_id=2
    message('Deleting records! No backup in Temporary mode.',.t.,.f.)
    doarch=.f.
    @ workrow+9, workcol+20 say 'Delete Old Records ? ' get doarch pict 'Y' color c_get
    read
    if doarch
        do arch2    //  delete records only
        message('Done.',.t.,.t.)
    endif
otherwise
    message('Option not available in Sample mode.',.t.,.t.)
endcase
set cursor on
return

proc arch1
//
//  - Backup -
//
message('0%',.f.,.f.)
message('Please wait ...',.f.,.f.)
sele 6
use (mLogdir+'\patients')
copy to &mdir\patients.bak
message('4%',.f.,.f.)
use ranges
copy to &mdir\ranges.bak
message('7%',.f.,.f.)
use profiles
copy to &mdir\profiles.bak
message('11%',.f.,.f.)
use items
copy to &mdir\items.bak
message('15%',.f.,.f.)
sele 5
use (mLogdir+'\results')
copy to &mdir\results.bak
message('19%',.f.,.f.)
sele 4
use (mLogdir+'\proinrep')
copy to &mdir\proinrep.bak
message('22%',.f.,.f.)
sele 3
use (mLogdir+'\reports') index (mLogdir+'\reports')
copy to &mdir\reports.bak
message('26%',.f.,.f.)
//
//  - Archive -
//
sele reports
replace all archive with .t. for printed .and. paid .and. ent_date<date()-config->archivdays
message('30%',.f.,.f.)
set filter to archive
go bott
go top
do while !eof()
        sele proinrep
        dele all for rep_id=reports->rep_id
        sele results
        dele all for rep_id=reports->rep_id
        sele reports
        dele 
        skip
        progress(31,10)
enddo
sele reports
set filter to
set delete off
message('41%',.f.,.f.)
if !file('archives\'+mfile1+'.dbf')
    copy to ('archives\'+mfile1) for archive                    && RP Reports
else
    use
    sele 0
    use ('archives\'+mfile1)
    append from (mLogdir+'\reports') for archive
    use
endif
message('48%',.f.,.f.)
sele proinrep
if !file('archives\'+mfile2+'.dbf')
    copy to ('archives\'+mfile2) for deleted()     && DT Proinrep
else
    use
    sele 0
    use ('archives\'+mfile2)
    append from (mLogdir+'\proinrep') for deleted()
    use
endif
message('53%',.f.,.f.)
sele results
if !file('archives\'+mfile3+'.dbf')
    copy to ('archives\'+mfile3) for deleted()     && RS Results
else
    use
    sele 0
    use ('archives\'+mfile3)
    append from (mLogdir+'\results') for deleted()
    use
endif
sele 5
use (mLogdir+'\results')
sele 4
use (mLogdir+'\proinrep')
sele 3
use (mLogdir+'\reports') index (mLogdir+'\reports')
sele proinrep
pack
sele results
pack
sele reports
pack
message('57%',.f.,.f.)
reindex eval Progress(61,10) every 1
use
copy file (mLogdir+'\reports.ntx') to ('archives\'+mfile1+'.ntx')
use archives\reparch
recall all
use archives\reparch index archives\reparch
reindex eval Progress(71,10) every 1
use
use archives\detarch
recall all
use
use archives\resarch
recall all
use
copy file (mLogdir+'\patients.dbf') to ('archives\patients.dbf')
message('90%',.f.,.f.)
copy file (mLogdir+'\patients.ntx') to ('archives\patients.ntx')
message('100%',.f.,.f.)
set delete on
sele 3
use
sele 4
use
sele 5
use
sele 6
use
message('Done.',.t.,.t.)
return

proc arch2
sele 5
use (mLogdir+'\results')
sele 4
use (mLogdir+'\proinrep')
sele 3
use (mLogdir+'\reports') index (mLogdir+'\reports')
replace all archive with .t. for printed .and. paid .and. ent_date<date()-config->archivdays
set filter to archive
go bott
go top
do while !eof()
    sele proinrep
    dele all for rep_id=reports->rep_id
    sele results
    dele all for rep_id=reports->rep_id
    sele reports
    dele 
    skip
    Progress(10,50)
enddo
sele proinrep
pack
sele results
pack
sele reports
pack
reindex eval Progress(51,50) every 1
sele 3
use
sele 4
use
sele 5
use
message('Done.',.t.,.t.)
return
