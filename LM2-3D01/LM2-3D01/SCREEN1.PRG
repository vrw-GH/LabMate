@ 0,0 clear
public workrow,workcol,menurow,menucol,msgrow,msgcol,titlerow,titlecol,idrow,idcol
idrow=3
idcol=2
titlerow=1
titlecol=4
workrow=3
workcol=2
menurow=4
menucol=67                                         
msgrow=23
msgcol=4
//
// basic screen
// ��������������������������������������������������
//
//
mcolor=mc_line+'/'+mc_back
set color to &mcolor
@ 0,0 say '�͹                                                                         ���'
@ 1,0 say '� ���������������������������������������������������������������������������Ĵ'
@ 2,0 say '�����������������������������������������������������������������ĳ  M E N U  �'
@ 3,0 say '�                                                                 �-----------�'
@ 4,0 say '�                                                                 �           �'
@ 5,0 say '�                                                                 �           �'
@ 6,0 say '�                                                                 �           �'
@ 7,0 say '�                                                                 �           �'
@ 8,0 say '�                                                                 �           �'
@ 9,0 say '�                                                                 �           �'
@10,0 say '�                                                                 �           �'
@11,0 say '�                                                                 �           �'
@12,0 say '�                                                                 �           �'
@13,0 say '�                                                                 �           �'
@14,0 say '�                                                                 �           �'
@15,0 say '�                                                                 �           �'
@16,0 say '�                                                                 �           �'
@17,0 say '�                                                                 �           �'
@18,0 say '�                                                                 �           �'
@19,0 say '�                                                                 �           �'
@20,0 say '�                                                                 �           �'
@21,0 say '�                                                                 �           �'
@22,0 say '�                                                                 �           �'
@23,0 say '�ͳ��������������������������������������������������������������۳������������'
//
// enhancements to screen
//
@ 0,3 say ' '+mCompany+' ' color mc_high+'/'+mc_back
if mCo_id=3
    @ 2,0 say '������������������S�A�M�P�L�E���D�A�T�A�B�A�S�E������������������ĳ  M E N U  �'
endif
@ 2,67 say '  M E N U  ' color '+'+mc_high+'/'+mc_line
@ 1,3 say    '���������������������������������������������������������������' color mc_sele+'/'+mc_sele
@23,3 say    '���������������������������������������������������������������' color mc_sele+'/'+mc_sele
do drawwork
if bmpyes
    gbmpdisp(logo[2],532,380)
else
    @24,42 say ' ' color '+w'+'/'+mc_back
    @24,43 say 'T' color '+w'+'/'+mc_back
    @24,44 say 'H' color '+w'+'/'+mc_back
    @24,45 say 'E' color '+gr'+'/'+mc_back
    @24,46 say ' ' color '+gr'+'/'+mc_back
    @24,47 say 'L' color '+gr'+'/'+mc_back
    @24,48 say 'E' color '+gr'+'/'+mc_back
    @24,49 say 'I' color '+g'+'/'+mc_back
    @24,50 say 'S' color '+g'+'/'+mc_back
    @24,51 say 'U' color '+g'+'/'+mc_back
    @24,52 say 'R' color '+g'+'/'+mc_back
    @24,53 say 'E' color 'g'+'/'+mc_back
    @24,54 say ' ' color 'g'+'/'+mc_back
    @24,55 say 'C' color 'g'+'/'+mc_back
    @24,56 say 'O.' color 'g'+'/'+mc_back
    @24,58 say ' ' color 'g'+'/'+mc_back
    @24,59 say 'Tel:+94 (0)31 38731 ' color mc_high+'/'+mc_back
endif
set color to &c_defa
@24,0 say ' '+mProgram+' ('+mVersion+')' color mc_high+'/'+mc_back
message('Welcome to Lab-Mate 2000.',.f.,.f.)
return

proc clearwork
@ workrow,workcol clear to 22,menucol-2
return

proc clearmenu
@ menurow,menucol clear to 22,77
return

proc clearmsg
mcolor=mc_sele+'/'+mc_sele
set color to &mcolor
@ msgrow,msgcol clear to msgrow,menucol-2
set color to &c_defa
return

proc message
param mmsg,blink,wait
do clearmsg
if blink
    tone(1300,2)
    @ msgrow-2,msgcol-1 say '�' color '*+4/'+mc_back
    @ msgrow-1,msgcol-1 say '�' color '*+4/'+mc_back
    @ msgrow,msgcol-1 say '�' color '*+4/'+mc_back
    @ msgrow,msgcol+1 say mmsg color mc_back+'/'+mc_sele
    inkey(config->speed/2)
    if wait
        inkey(config->speed/2)
    endif
    @ msgrow,msgcol-1 say '�' color mc_sele+mc_sele
else
    @ msgrow,msgcol+1 say mmsg color mc_back+'/'+mc_sele
    if wait
        inkey(config->speed)
    endif
endif
return

proc cleartitle
mcolor=mc_sele+'/'+mc_sele
set color to &mcolor
@ titlerow,titlecol clear to titlerow,menucol-2
set color to &c_defa
return

proc title
param mmsg
do cleartitle
@ titlerow,titlecol say mmsg color mc_back+'/'+mc_sele
return

proc clearid
@ idrow,idcol clear to idrow,menucol-3
return

proc id
param mmsg,iid
do clearid
@ idrow, idcol say left(mmsg,10)
@ idrow, idcol+10 say iid color '+w'
return
