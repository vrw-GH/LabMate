* Sele 1 = Config
* Sele 2 = Company
sele 3
use (mLogdir+'\patients') index (mLogdir+'\patients')
do while .t.
        title('Edit Patient Details')
        clearmenu()
        message('Select search criteria.',.f.,.f.)
        @ menurow+0, menucol say 'Patient' color '*'+mc_high+'/'+mc_back
        @ menurow+1, menucol say 'Search:' color '*'+mc_high+'/'+mc_back
        set color to &c_prompt
        @ menurow+2, menucol prompt 'by ID'
        @ menurow+3, menucol prompt 'by Name'
        @ menurow+4, menucol prompt 'List'
        @ menurow+5, menucol prompt 'Add New'
        @ menurow+6, menucol prompt 'Exit'
        menu to choice9
        title(iif(choice9=1,'Search - by ID',iif(choice9=2,'Search - by Name',iif(choice9=3,'Pick from List','Add New'))))
        clearwork()
        set color to &c_defa
        @ menurow+0, menucol say 'Patient' color mc_high+'/'+mc_back
        @ menurow+1, menucol say 'Search:' color mc_high+'/'+mc_back
        do case
        case choice9=1
                do schid
        case choice9=2
                do schname
        case choice9=3
            go top
            if getlist(17,"pat_id",,"pat_name",.f.)
                do clearwork
                do patedit
                message('Edit now.',.f.,.f.)
                if mCo_id=3 // Sample
                    clear gets
                    set cursor off
                    inkey(5)
                    set cursor on
                else
                    set key 19 to keyleft
                    set key 4 to keyright
                    read
                    set key 19 to 
                    set key 4 to
                endif
            endif
        case choice9=4
                if mReg
                        append blank
                        replace pat_id with company->cfg_pat_id
                        reindex eval Progress(1,100) every 1
                        go top
                        seek company->cfg_pat_id
                        if found()
                                replace company->cfg_pat_id with company->cfg_pat_id+1
                                do clearwork
                                do patedit
                                message('Edit now.',.f.,.f.)
                                if mCo_id=3 // Sample
                                    clear gets
                                    set cursor off
                                    inkey(5)
                                    set cursor on
                                else
                                    set key 19 to keyleft
                                    set key 4 to keyright
                                    read
                                    set key 19 to
                                    set key 4 to
                                endif
                        else
                                message('Record creation error. (09.01)',.t.,.t.)
                        endif
                else
                        message('Cannot add record in Sample or Temporary modes.',.t.,.t.)
                endif
        otherwise
exit
        endcase
        drawwork()
enddo
sele 3
use
*restore screen from scr09
return

proc schid
message('Enter number or 0 to exit.',.f.,.f.)
mpid=0
@ workrow, workcol say 'ID No  :' get mpid color c_get
read
if mpid<>0
        seek mpid
        if found()
                do patedit
                message('Edit now.',.f.,.f.)
                if mCo_id=3 // Sample
                    clear gets
                    set cursor off
                    inkey(5)
                    set cursor on
                else
                    set key 19 to keyleft
                    set key 4 to keyright
                    read
                    set key 19 to 
                    set key 4 to 
                endif
        else
                message('Not found.',.t.,.t.)
        endif
endif
return

proc schname
message('Enter a name or blank field to exit.',.f.,.f.)
mpname=space(30)
@ workrow+1, workcol say 'Name   :' get mpname color c_get
read
if !empty(mpname)
        loca for upper(trim(mpname)) $ upper(pat_name) .or. soundex(trim(mpname)) $ soundex(pat_name) 
        if found()
                do while .t.
                        do patedit
                        message('Choose to edit, seek next matching record or exit.',.f.,.f.)
                        @ menurow+8, menucol say 'Record:' color '*'+mc_high+'/'+mc_back
                        set color to &c_prompt
                        @ menurow+9, menucol prompt 'Edit'
                        @ menurow+10,menucol prompt 'Next match'
                        @ menurow+11,menucol prompt 'Delete'
                        @ menurow+12,menucol prompt 'Exit'
                        menu to choice
                        set color to &c_defa
                        @ menurow+8, menucol say 'Record:' color mc_high+'/'+mc_back
                        do case
                        case choice=1
                                message('Edit now.',.f.,.f.)
                                if mCo_id=3 // Sample
                                    clear gets
                                    set cursor off
                                    inkey(5)
                                    set cursor on
                                else
                                    set key 19 to keyleft
                                    set key 4 to keyright
                                    read
                                    set key 19 to 
                                    set key 4 to 
                                endif
                exit
                        case choice=2
                                clear gets
                                continue
                                if eof()
                                        message('Not found.',.t.,.t.)
                exit
                                endif
                        case choice=3
                                clear gets
                                if mReg
                                        delete
                                        if !deleted()
                                                message('Deletion error. (09.02)',.t.,.t.)
                                        else
                                                pack
                                                reindex eval Progress(1,100) every 1
                                        endif
                                else
                                        message('Cannot delete in Sample or Temporary modes.',.t.,.t.)
                                endif
                exit
                        otherwise
                                clear gets
                exit
                        endcase
                enddo
        else
                message('Not found.',.t.,.t.)
        endif
endif
return

proc patedit
title('Edit Patient Details')
@ workrow+1,  workcol+1 say 'ID  :' color mc_high+'/'+mc_back get pat_id color c_get
clear gets
@ workrow+3,  workcol+1 say 'Name:' color mc_text+'/'+mc_back get pat_name pict '@S48' valid !empty(pat_name) color c_get
@ workrow+4,  workcol+1 say 'Sex :' color mc_text+'/'+mc_back get patients->pat_sex pict '!' valid(dispword(patients->pat_sex) .and. (pat_sex='M' .or. pat_sex='P' .or. pat_sex='F')) color c_get
@ workrow+5,  workcol+1 say 'Age : 999 Yrs,  99 Months,  99 Days.'
@ workrow+5,  workcol+1 say 'Age :' color mc_text+'/'+mc_back 
@ workrow+5,  workcol+7  get patients->pat_years pict '999' valid(pat_years<110) color c_get
@ workrow+5,  workcol+17 get patients->pat_months pict '99' valid(pat_months<12) color c_get
@ workrow+5,  workcol+29 get patients->pat_days pict '99' valid(pat_days<30 .and. iif((pat_years+pat_months)=0,pat_days>0,.t.)) color c_get
@ workrow+9,  workcol+1 say 'Address:' color mc_text+'/'+mc_back get pat_addr pict '@S48' color c_get
@ workrow+11, workcol+1 say 'Contact:' color mc_text+'/'+mc_back get pat_contct pict '@S48' color c_get
@ workrow+13, workcol+1 say 'Remarks:' color mc_text+'/'+mc_back get pat_remark pict '@S48' color c_get
return
