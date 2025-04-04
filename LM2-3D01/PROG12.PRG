* Sele 1 = Config
* Sele 2 = Company
title('Re-indexing...')
message('Please wait.',.f.,.f.)
set cursor off
do clearwork
do clearmenu
// 1
@ workrow+2, workcol say 'Company Information file                '
sele company
use
use company
index on Co_Id to company unique eval Progress(1,20) every 1
use company index company
seek mCo_id
// 2
@ workrow+3, workcol say 'Test/Profiles database                  '
sele 0
use profiles // index profiles
dele all for empty(pro_name)
pack
index on Pro_Id to profiles unique eval Progress(21,20) every 1
use
// 3
@ workrow+4, workcol say 'Profile items database                  '
use items // index items
dele all for empty(item_descr)
pack
sort to sortitm.dbf on item_id /A
if file("sortitm.dbf")
    use
    copy file sortitm.dbf to items.dbf
    erase sortitm.dbf
endif
use items
index on Item_Id to Items unique eval Progress(41,20) every 1
use
// 4
@ workrow+5, workcol say 'Ranges database                         '
use ranges
dele all for empty(range)
pack
sort to sortrng.dbf on item_id /A
if file("sortrng.dbf")
    use
    copy file sortrng.dbf to ranges.dbf
    erase sortrng.dbf
endif
use
// 5
@ workrow+6, workcol say 'Reports database                        '
use (mLogdir+'\reports') // index (mLogdir+'\reports')
dele all for empty(pat_id)
pack
index on Rep_Id to (mLogdir+'\reports') unique eval Progress(61,20) every 1
use
// 6
use (mLogdir+'\proinrep')
dele all for empty(rep_id) .or. empty(pro_id)
pack
use
// 7
@ workrow+7, workcol say 'Results database                        '
use (mLogdir+'\results')
sort to sortres.dbf on rep_id /D, item_id /A
if file("sortres.dbf")
    use
    copy file sortres.dbf to (mLogdir+'\results.dbf')
    erase sortres.dbf
endif
use
// 8
@ workrow+8, workcol say 'Patients database                       '
use (mLogdir+'\patients') // index (mLogdir+'\patients')
dele all for empty(pat_name)
pack
index on Pat_Id to (mLogdir+'\Patients') unique eval Progress(81,19) every 1
use
// 
message('Done.',.t.,.t.)
set cursor on
return
