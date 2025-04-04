* Sele 1 = Config
* Sele 2 = Company
sele 5
use ranges
sele 4
use items index items
sele 3
use profiles index profiles
do while .t.
        title('Edit Tests/Profiles Database')
        clearmenu()
        message('Edit, Add New or Delete Test/Profile.',.f.,.f.)
        @ menurow+1, menucol say 'Profile:' color '*'+mc_high+'/'+mc_back
        set color to &c_prompt
        @ menurow+2, menucol prompt 'Edit'
        @ menurow+3, menucol prompt 'Add New'
        @ menurow+4, menucol prompt 'Delete!'
        @ menurow+5, menucol prompt 'Exit'
        menu to choice8
        title('Edit Tests/Profiles Database - '+iif(choice8=1,'Edit',if(choice8=2,'Add',iif(choice8=3,'Delete','Exit'))))
        clearwork()
        set color to &c_defa
        @ menurow+1, menucol say 'Profile:' color mc_high+'/'+mc_back
        do case
        case choice8=2 .and. mCo_id=3
            message("Cannot add in Sample or Temporary modes.",.t.,.t.)
        case choice8=3 .and. mCo_id=3
            message("Cannot delete in Sample or Temporary modes.",.t.,.t.)
        case choice8=1 .or. choice8=3
            do proflist
        case choice8=2
                if mReg
                        append blank
                        replace pro_id with config->cfg_pro_id
                        reindex eval Progress(1,100) every 1
                        go top
                        seek config->cfg_pro_id
                        if found()
                                replace config->cfg_pro_id with config->cfg_pro_id+1
                                replace pro_mode with 'N'   && Normal/Text
                                replace pro_type with 'T'   && Test/Profile
                                sele items
                                append blank
                                replace item_id with config->cfg_itm_id
                                replace pro_id with profiles->pro_id
                                replace item_descr with 'NEW ITEM.'
                                replace order with 1
                                replace input_calc with 'I'
                                replace char_num with 'N'
                                replace unit with space(len(unit)-3)+'3AR'
                                reindex eval Progress(1,100) every 1
                                go top
                                seek config->cfg_itm_id
                                sele profiles
                                if found()
                                        replace config->cfg_itm_id with config->cfg_itm_id+1
                                        do clearwork
                                        do profedit
                                        message('Edit test/profile details.',.f.,.f.)
                                        if mCo_id=3 // sample
                                            clear gets
                                            set cursor off
                                            set cursor on
                                        else
                                            set key 19 to keyleft
                                            set key 4 to keyright
                                            read
                                            set key 19 to 
                                            set key 4 to 
                                        endif
                                        if pro_mode='T'                && Text
                                            replace pro_type with 'P'   && Profile
                                        endif
                                        do itemedit
                                else
                                        message('Record creation error. (08.02)',.t.,.t.)
                                endif
                        else
                                message('Record creation error. (08.01)',.t.,.t.)
                        endif
                else
                        message('Please register to use this feature.',.t.,.t.)
                endif
        otherwise
exit
        endcase
        drawwork()
enddo
sele 3
use
sele 4
use
sele 5
use profiles
sort on pro_name to prolist
use
dele file profiles.dbf
rename prolist.dbf to profiles.dbf
use profiles index profiles
reindex eval Progress(1,100) every 1
use
return

proc proflist
go top
if getlist(17,"pro_id",,"pro_name",.t.)
    clearwork()
    do profedit
    do case
    case choice8=1
        message('Edit test/profile details.',.f.,.f.)
        if mCo_id=3 // sample
            clear gets
            set cursor off
            set cursor on
        else
            set key 19 to keyleft
            set key 4 to keyright
            read
            set key 19 to 
            set key 4 to 
        endif
        if pro_mode='T'                && Text
            replace pro_type with 'P'   && Profile
        endif
        do itemedit
    case choice8=3
        clear gets
        if mReg
            delete
            if !deleted()
                message('Delete error. (08.03)',.t.,.t.)
            else
                pack
                reindex eval Progress(1,100) every 1
            endif                                                        
        else
            message('Please register to use this feature.',.t.,.t.)
            inkey(5)
        endif
    endcase
endif
return

proc profedit
@ workrow,   workcol say 'Test/Profile  :' color mc_high+'/'+mc_back get pro_name pict '@S45!' valid !empty(pro_name) color c_get
@ workrow+1, workcol say 'Specimen      :' get pro_spec pict '@S30' color c_get
@ workrow+2, workcol say 'Collect.Method:' get pro_method pict '@S30' color c_get
@ workrow+1, workcol+47 say 'Mode: '+iif(pro_mode='N','Normal','Text  ') 
@ workrow+1, workcol+47 say 'Mode:' get pro_mode pict '!' valid ((pro_mode='T' .or. pro_mode='N') .and. dispword(pro_mode)) color c_get
@ workrow+2, workcol+47 say 'Type: '+iif(pro_type='T','Test   ','Profile') 
@ workrow+2, workcol+47 say 'Type:' get pro_type pict '!' valid ((pro_type='T' .or. pro_type='P') .and. dispword(pro_type)) when pro_mode<>'T' color c_get
@ workrow+3, workcol say 'Rate          : '+str(pro_cost+markup,10,2)+' = Cost(          )+Markup(       )'
@ workrow+3, workcol+34 get pro_cost pict '9999999.99' color c_get valid (pro_cost>0 .and. tcost(pro_cost,markup))
@ workrow+3, workcol+53 get markup pict '9999.99' color c_get valid tcost(pro_cost,markup)
return

proc itemedit
sele items
if profiles->pro_type='T'   && Test
    dele all for order>1 .and. pro_id=profiles->pro_id
    pack
    reindex eval Progress(1,100) every 1
endif
set filter to pro_id=profiles->pro_id
go bott
go top
if profiles->pro_type='T'   && Test
    replace item_descr with profiles->pro_name
endif
choice=1
@ workrow+4, workcol to workrow+4, menucol-2
if profiles->pro_mode='N'       && Normal not Text
    do while .t. 
            message('Edit test/profile details.',.f.,.f.)
            if eof() .or. bof()
                    message('No items in database.',.t.,.f.)
                    choice=4
            endif
            munit=left(unit,len(unit)-3)
            malign=right(unit,1)        && Last character
            mpos=left(right(unit,2),1)  && One-before-last character
            mdec=left(right(unit,3),1)  && Two-before-last character
            @ workrow+5, workcol clear to workrow+15, menucol-2
            @ workrow+5, workcol say 'Item :' get item_descr pict '@S30!' valid !empty(item_descr) when profiles->pro_type<>'T' color c_get
            @ workrow+5, workcol+38 say 'Reference: R'+ltrim(str(order,0))
            @ workrow+6, workcol say 'Unit :' get munit color c_get
            @ workrow+6, workcol+20 say 'Unit Position: '
            @ workrow+6, workcol+36 say iif(mpos='B','Before result','After result ')
            @ workrow+6, workcol+36 get mpos pict '!' color c_get valid dispword(mpos) when !empty(munit)
            @ workrow+7, workcol say 'Result Properties:-'
            @ workrow+8, workcol say iif(input_calc='I','Input     ','Calculated')
            @ workrow+8, workcol get input_calc pict '!' color c_get valid sayinput(input_calc,order)
            @ workrow+8, workcol+14 say iif(char_num='C','Character','Number   ')
            @ workrow+8, workcol+14 get char_num pict '!' valid dispword(char_num) color c_get when input_calc='I'
            @ workrow+8, workcol+26 say iif(malign='R','Right align','Left align ')
            @ workrow+8, workcol+26 get malign pict '!' color c_get valid dispword(malign)
            @ workrow+8, workcol+44 say mdec+' decimals'
            @ workrow+8, workcol+44 get mdec pict '9' color c_get valid (mdec='0' .or. mdec='1' .or. mdec='2' .or. mdec='3') when char_num='N'
            @ workrow+9, workcol say    'Formula:' get calculate pict '@S44' color c_get when input_calc='C'
            @ workrow+10,workcol to workrow+10, menucol-2
            sele ranges
            set filter to item_id=items->item_id
            go bott
            go top
            loca for upper(trim(category))='NEWBORN'
            if found()
                newborn=range
            else
                newborn=space(15)
            endif
            go bott
            go top
            loca for upper(trim(category))='1 WEEK'
            if found()
                week=range
            else
                week=space(15)
            endif
            go bott
            go top
            loca for upper(trim(category))='1 MONTH'
            if found()
                month=range
            else
                month=space(15)
            endif
            go bott
            go top
            loca for upper(trim(category))='1 YEAR'
            if found()
                year=range
            else
                year=space(15)
            endif
            go bott
            go top
            loca for upper(trim(category))='CHILD 1-6Y'
            if found()
                child=range
            else
                child=space(15)
            endif
            go bott
            go top
            loca for upper(trim(category))='OVER 6Y'
            if found()
                over6=range
            else
                over6=space(15)
            endif
            go bott
            go top
            loca for upper(trim(category))='ADULT (M)'
            if found()
                AdltM=range
            else
                AdltM=space(15)
            endif
            go bott
            go top
            loca for upper(trim(category))='ADULT (F)'
            if found()
                AdltF=range
            else
                AdltF=space(15)
            endif
            go bott
            go top
            loca for upper(trim(category))='PREGNANT'
            if found()
                Pregnant=range
            else
                Pregnant=space(15)
            endif
            go bott
            go top
            loca for upper(trim(category))='GENERAL'
            if found()
                General=range
            else
                General=space(15)
            endif
            go bott
            go top
            loca for upper(trim(category))='OTHER'
            if found()
                Other=range
            else
                Other=space(15)
            endif
            sele items
            @ workrow+11, workcol say 'Reference Ranges:' color mc_high+'/'+mc_back
            @ workrow+12, workcol say ' General                        Newborn'
            @ workrow+13, workcol say ' Adult Male                     1-7 days'
            @ workrow+14, workcol say ' Adult Female                   upto 1 month'
            @ workrow+15, workcol say '                                upto 1 year'
            @ workrow+16, workcol say ' Pregnant                       1 to 6 years'
            @ workrow+17, workcol say ' Other                          6 to '+ltrim(str(config->kid_adult,2))+' years'
            @ workrow+12, workcol+15 get General color c_get
            @ workrow+13, workcol+15 get AdltM color c_get
            @ workrow+14, workcol+15 get AdltF color c_get
            @ workrow+16, workcol+15 get Pregnant color c_get
            @ workrow+17, workcol+15 get other color c_get
            @ workrow+12, workcol+46 get newborn color c_get
            @ workrow+13, workcol+46 get week color c_get
            @ workrow+14, workcol+46 get month color c_get
            @ workrow+15, workcol+46 get year color c_get
            @ workrow+16, workcol+46 get child color c_get
            @ workrow+17, workcol+46 get over6 color c_get
            @ workrow+18, workcol say 'Lowest/Highest  :' color mc_high+'/'+mc_back get lowest pict '99,999,999.000' color c_get when (char_num='N' .and. input_calc='I')
            @ workrow+18, workcol+36 say '/' get highest pict '99,999,999.999' color c_get when (char_num='N' .and. input_calc='I')
            clearmenu()
            @ menurow+1, menucol say 'Item:' color '*'+mc_high+'/'+mc_back
            set color to &c_prompt
            @ menurow+2, menucol prompt 'Edit'
            @ menurow+3, menucol prompt 'Next'
            @ menurow+4, menucol prompt 'Previous'
            @ menurow+5, menucol prompt 'Add'
            @ menurow+6, menucol prompt 'Delete'
            @ menurow+7, menucol prompt 'Exit'
            menu to choice
            set color to &c_defa
            @ menurow+1, menucol say 'Item:' color mc_high+'/'+mc_back
            do case
            case choice=1 .and. mCo_id=3
                message("Cannot edit in Sample or Temporary modes.",.t.,.t.)
            case choice=4 .and. mCo_id=3
                message("Cannot add in Sample or Temporary modes.",.t.,.t.)
            case choice=5 .and. mCo_id=3
                message("Cannot delete in Sample or Temporary modes.",.t.,.t.)
            case choice=1
                    message('Edit test/profile details.',.f.,.f.)
                    if !eof() .and. !bof()
                           if mCo_id=3 // sample
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
                            if input_calc='C'
                                    replace char_num with 'N'
                            else && input_calc='I'
                                    replace calculate with 'No calculation.'
                            endif
                            if char_num='C' .or. input_calc='C'
                                    replace lowest with 0
                                    replace highest with 0
                            endif
                            if char_num='C'
                                mdec='0'
                            endif
                            if empty(munit)
                                mpos='A'
                                if char_num='C'
                                    malign='L'
                                endif
                            else
                                if mpos='B'
                                    malign='L'
                                endif
                            endif
                            replace unit with munit+mdec+mpos+malign
                            sele ranges
                            go bott
                            go top
                            loca for upper(trim(category))='NEWBORN'
                            do case
                            case !found() .and. !empty(newborn)
                                    append blank
                                    replace item_id with items->item_id
                                    replace category with 'NEWBORN'
                                    replace min_days with 0
                                    replace max_days with 1
                                    replace range with newborn
                            case found() .and. !empty(newborn)
                                    replace range with newborn
                            case found() .and. empty(newborn)
                                    dele
                                    pack
                            endcase
                            go bott
                            go top
                            loca for upper(trim(category))='1 WEEK'
                            do case
                            case !found() .and. !empty(week)
                                    append blank
                                    replace item_id with items->item_id
                                    replace category with '1 WEEK'
                                    replace min_days with 2
                                    replace max_days with 7
                                    replace range with week
                            case found() .and. !empty(week)
                                    replace range with week
                            case found() .and. empty(week)
                                    dele
                                    pack
                            endcase
                            go bott
                            go top
                            loca for upper(trim(category))='1 MONTH'
                            do case
                            case !found() .and. !empty(month)
                                    append blank
                                    replace item_id with items->item_id
                                    replace category with '1 MONTH'
                                    replace min_days with 8
                                    replace max_days with 31
                                    replace range with month
                            case found() .and. !empty(month)
                                    replace range with month
                            case found() .and. empty(month)
                                    dele
                                    pack
                            endcase
                            go bott
                            go top
                            loca for upper(trim(category))='1 YEAR'
                            do case
                            case !found() .and. !empty(year)
                                    append blank
                                    replace item_id with items->item_id
                                    replace category with '1 YEAR'
                                    replace min_days with 32
                                    replace max_days with 365
                                    replace range with year
                            case found() .and. !empty(year)
                                    replace range with year
                            case found() .and. empty(year)
                                    dele
                                    pack
                            endcase
                            go bott
                            go top
                            loca for upper(trim(category))='CHILD 1-6Y'
                            do case
                            case !found() .and. !empty(child)
                                    append blank
                                    replace item_id with items->item_id
                                    replace category with 'CHILD 1-6Y'
                                    replace min_days with 366
                                    replace max_days with 2192
                                    replace range with child
                            case found() .and. !empty(child)
                                    replace range with child
                            case found() .and. empty(child)
                                    dele
                                    pack
                            endcase
                            go bott
                            go top
                            loca for upper(trim(category))='OVER 6Y'
                            do case
                            case !found() .and. !empty(over6)
                                    append blank
                                    replace item_id with items->item_id
                                    replace category with 'OVER 6Y'
                                    replace min_days with 2193
                                    replace max_days with (config->kid_adult*365)+(int(config->kid_adult/4)+1)
                                    replace range with over6
                            case found() .and. !empty(over6)
                                    replace range with over6
                            case found() .and. empty(over6)
                                    dele
                                    pack
                            endcase
                            go bott
                            go top
                            loca for upper(trim(category))='ADULT (M)'
                            do case
                            case !found() .and. !empty(adltM)
                                    append blank
                                    replace item_id with items->item_id
                                    replace category with 'ADULT (M)'
                                    replace min_days with (config->kid_adult*365)+(int(config->kid_adult/4)+1)+1
                                    replace max_days with 9999
                                    replace range with adltM
                            case found() .and. !empty(adltM)
                                    replace range with adltM
                            case found() .and. empty(adltM)
                                    dele
                                    pack
                            endcase
                            go bott
                            go top
                            loca for upper(trim(category))='ADULT (F)'
                            do case
                            case !found() .and. !empty(adltF)
                                    append blank
                                    replace item_id with items->item_id
                                    replace category with 'ADULT (F)'
                                    replace min_days with (config->kid_adult*365)+(int(config->kid_adult/4)+1)+1
                                    replace max_days with 9999
                                    replace range with adltF
                            case found() .and. !empty(adltF)
                                    replace range with adltF
                            case found() .and. empty(adltF)
                                    dele
                                    pack
                            endcase
                            go bott
                            go top
                            loca for upper(trim(category))='PREGNANT'
                            do case
                            case !found() .and. !empty(pregnant)
                                    append blank
                                    replace item_id with items->item_id
                                    replace category with 'PREGNANT'
                                    replace min_days with (config->kid_adult*365)+(int(config->kid_adult/4)+1)+1
                                    replace max_days with 9999
                                    replace range with pregnant
                            case found() .and. !empty(pregnant)
                                    replace range with pregnant
                            case found() .and. empty(pregnant)
                                    dele
                                    pack
                            endcase
                            go bott
                            go top
                            loca for upper(trim(category))='GENERAL'
                            do case
                            case !found() .and. !empty(general)
                                    append blank
                                    replace item_id with items->item_id
                                    replace category with 'GENERAL'
                                    replace min_days with (config->kid_adult*365)+(int(config->kid_adult/4)+1)+1
                                    replace max_days with 9999
                                    replace range with general
                            case found() .and. !empty(general)
                                    replace range with general
                            case found() .and. empty(general)
                                    dele
                                    pack
                            endcase
                            go bott
                            go top
                            loca for upper(trim(category))='OTHER'
                            do case
                            case !found() .and. !empty(other)
                                    append blank
                                    replace item_id with items->item_id
                                    replace category with 'OTHER'
                                    replace min_days with (config->kid_adult*365)+(int(config->kid_adult/4)+1)+1
                                    replace max_days with 9999
                                    replace range with other
                            case found() .and. !empty(other)
                                    replace range with other
                            case found() .and. empty(other)
                                    dele
                                    pack
                            endcase
                            go bott
                            go top
                            sele items
                            choice=2
                    else
                            clear gets
                            go top
                            choice=4
                    endif
            case choice=2
                    message('Edit test/profile details.',.f.,.f.)
                    clear gets
                    skip
                    choice=1
                    if eof()
                            message('No more records.',.t.,.t.)
                            skip -1
                    endif
            case choice=3
                    message('Edit test/profile details.',.f.,.f.)
                    clear gets
                    skip -1
                    choice=1
                    if bof()
                            message('No prior records.',.t.,.t.)
                            go top
                            choice=1
                    endif
            case choice=4
                    message('Creating new ...',.t.,.f.)
                    clear gets
                    mtotal=1
                    go top
                    do while !eof()
                            skip
                            mtotal=mtotal+1
                    enddo
                    if profiles->pro_type='T' .and. mtotal>0
                        message('Only 1 item required for Bio-Chemistry test.',.t.,.t.)
                        go top
                    else
                        append blank
                        replace item_id with config->cfg_itm_id
                        replace pro_id with profiles->pro_id
                        replace item_descr with 'This is a NEW ITEM.'
                        replace order with mtotal
                        replace input_calc with 'I'
                        replace char_num with 'N'
                        replace unit with space(len(unit)-3)+'3AR'
                        reindex eval Progress(1,100) every 1
                        go top
                        seek config->cfg_itm_id
                        message('Edit test/profile details.',.f.,.f.)
                        if found()
                                replace config->cfg_itm_id with config->cfg_itm_id+1
                                choice=1
                        else
                                message('Record creation error. (08.04)',.t.,.t.)
                                choice=4
                        endif
                    endif
            case choice=5
                    message('Deleting ...',.t.,.f.)
                    clear gets
                    if order=1
                        message('Cannot delete this item!',.t.,.t.)
                    else
                        morder=order
                        delete
                        message('Edit test/profile details.',.f.,.f.)
                        if !deleted()
                                message('Delete error. (08.05)',.t.,.t.)
                        else
                                pack
                                reindex eval Progress(1,100) every 1
                                go top
                                do while !eof()
                                        replace order with iif(order>morder, order-1, order)
                                        skip
                                enddo
                                go top
                                choice=2
                        endif
                    endif
            otherwise
                clear gets
    exit
            endcase
    enddo
else
    message('Creating text lines.',.f.,.f.)
    @ workrow+5, workcol clear to workrow+15, menucol-2
    do while !eof()
        sele ranges
        dele all for item_id=items->item_id
        pack
        sele items
        skip
    enddo
    sele items
    go top
    xl=1
    mitlines=10
    do while !eof()
        if xl>mitlines
            delete
        endif
        skip
        xl=xl+1
    enddo
    pack
    reindex eval Progress(1,100) every 1
    go top
    for xl=1 to mitlines
        if eof()
            append blank
            replace item_id with config->cfg_itm_id
            replace pro_id with profiles->pro_id
            reindex eval Progress(1,100) every 1
            seek config->cfg_itm_id
            if found()
                replace config->cfg_itm_id with config->cfg_itm_id+1
            else
                message('Record creation error. (08.06)',.t.,.t.)
            endif
        endif
        replace item_descr with 'T'+ltrim(str(xl,0))+':'
        replace order with xl
        replace char_num with 'C'
        replace input_calc with 'I'
        replace unit with ''
        replace calculate with 'No calculation.'
        replace lowest with 0
        replace highest with 0
        skip
    next
    @ workrow+5, workcol say 'Text Text Text Text Text Text Text Text Text Text Text Text Tex'
    @ workrow+6, workcol say 'Text Text Text Text Text Text Text Text Text Text Text Text Tex'
    @ workrow+7, workcol say 'Text Text Text Text Text Text Text Text Text Text Text Text Tex'
    @ workrow+8, workcol say 'Text Text Text Text Text Text Text Text Text Text Text Text Tex'
    @ workrow+9, workcol say 'Text Text Text Text Text Text Text Text Text Text Text Text Tex'
    @ workrow+10,workcol to workrow+10, menucol-2
    message(str(mitlines,0)+' Text lines created',.t.,.t.)
endif
sele items  && filtered
go top
go bott
replace profiles->tot_items with items->order
sele profiles
return

proc tcost
para c,m
@ workrow+3, workcol+16 say str(c+m,10,2)
return(.t.)

proc sayinput
para in,ord
if ord=1
    ret=iif(in='I',.t.,.f.)
else
    ret=iif(in='I' .or. in='C',.t.,.f.)
endif
@ workrow+8, workcol say iif(in='I','Input     ','Calculated')
return(ret)

