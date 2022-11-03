* Sele 1 = Config
* Sele 2 = Company
*-----------------------------
sele 6
use (mLogdir+'\patients') index (mLogdir+'\patients')
sele 5
use profiles index profiles
sele 4
use (mLogdir+'\proinrep')
sele 3
use (mLogdir+'\reports') index (mLogdir+'\reports')
set relation to pat_id into patients
mid_from=0
mid_to=0
do clearwork
getpay=.f.
do while .t.
    title('Payments')
    message('Select from/to range.',.f.,.f.)
    clearwork()
    do clearmenu
    @ workrow+1, workcol say 'Report ID No: From                      (F2 for list)'
    @ workrow+2, workcol say '              To                 '
    @ workrow+1, workcol+21 say mid_from
    @ workrow+2, workcol+21 say mid_to
    @ menurow+1, menucol say 'Range:' color '*'+mc_high+'/'+mc_back
    set color to &c_prompt
    @ menurow+2, menucol prompt 'From'
    @ menurow+3, menucol prompt 'To'
    @ menurow+4, menucol prompt 'Payment'
    @ menurow+5, menucol prompt 'Exit'
    menu to choice3
    @ menurow+1, menucol say 'Range:' color mc_high+'/'+mc_back
    set color to &c_defa
    do case
    case choice3=1
        title('Payments - Set Range')
        set key -1 to keyF2
        @ workrow+1, workcol+21 get mid_from color c_get
        read
        set key -1 to
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
                message('Report not found.',.t.,.t.)
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
        title('Payments - Set Range')
        set key -1 to keyF2
        @ workrow+2, workcol+21 get mid_to color c_get
        read
        set key -1 to
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
                message('Report not found.',.t.,.t.)
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
        title('Payments - Make Payments')
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
                do clearwork
                do clearmenu
                do payment1
                sele reports
                skip
            enddo
            set filter to
            sele reports
            set filter to
            choice3=4
        else
            getpay=.f.
            message('Please set range',.t.,.t.)
            choice3=1
        endif
        mid_from=0
        mid_to=0
    otherwise
exit
    endcase
enddo
sele 3
use
sele 4
use
sele 5
use
sele 6
use
return

proc payment1
message('Enter payment details.',.f.,.f.)
@ workrow+1,  workcol say 'Report ID : '+ltrim(str(rep_id)) color mc_high+'/'+mc_back
@ workrow+1,  workcol+30 say '    Rates'
@ workrow+1,  workcol+45 say ' Payments'
@ workrow+11, workcol to workrow+11, menucol-2
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
    @ workrow+1+x,  workcol+45 get &ax pict '9999999.99' color c_get valid disptot()
    skip
    x=x+1
enddo
@ workrow+12, workcol+30 say mtotcost pict '9999999.99' color mc_high+'/'+mc_back
do disptot
if reports->paid
    clear gets
    sum paid to mpayment
    @ workrow+12, workcol+45 say mpayment pict '9999999.99' color mc_high+'/'+mc_back
    @ workrow+13, workcol+27 say '      Total paid:'
    mpd=mpayment
    @ workrow+13, workcol+45 get mpd pict '9999999.99' color c_get valid mpd=mpayment
    message('Payment already made.',.t.,.f.)
    read
    message('Payment confirmed.',.f.,.t.)
else
    read
    go top
    for y=1 to x-1
        ax='a'+ltrim(str(y,0))
        replace proinrep->paid with &ax
        skip
    next
    sum paid to mpayment
    @ workrow+12, workcol+45 say mpayment pict '9999999.99' color mc_high+'/'+mc_back
    @ workrow+13, workcol+27 say 'Enter total paid:'
    mpd=0
    @ workrow+13, workcol+45 get mpd pict '9999999.99' color c_get
    read
    if mpd=mpayment
        message('Payment confirmed.',.f.,.t.)
        replace reports->paid with .t.
        replace reports->amount with mpd
    else
        message('Last chance.',.t.,.f.)
        @ workrow+13, workcol+45 get mpd pict '9999999.99' color c_get
        read
        if mpd=mpayment
            message('Payment confirmed.',.f.,.t.)
            replace reports->paid with .t.
            replace reports->amount with mpd
        else
            message('Payment not confirmed.',.t.,.t.)
            replace reports->paid with .f.
            replace reports->amount with 0
        endif
    endif
endif
return

proc disptot
mpayment=0
for y=1 to x-1
    ax='a'+ltrim(str(y,0))
    mpayment=mpayment+&ax
next
@ workrow+12, workcol+45 say mpayment pict '9999999.99' color mc_high+'/'+mc_back
return(.t.)

