// program to redraw the work area
mcolor=mc_line+'/'+mc_back
set color to &mcolor
clearwork()
do case
case mCo_id=1 .or. mCo_id=2 .or. mCo_id=4
    do logo with company->logid
    if bmpyes
        gbmpdisp(logo[3],18,54)
        for mx=1 to 10
            gwriteat(155,130+(mx*10),logoline[mx],val(mc_line))
        next
    else
        for mx=1 to 10
            @ 7+mx,12 say logoline[mx]
        next
    endif
otherwise //   Sample Databases. mCo_id=3
    if bmpyes
        gbmpdisp(logo[1],150,150)
    else
        @ 8,0 say '≥             €€€€€€€€€€€€€€€€≤     ‹‹€€€€€€‹‹                    ≥           ≥'
        @ 9,0 say '≥             €€€€€€€€€€€€€€€€≤    €€€€ﬂﬂﬂﬂﬂ€€€                   ≥           ≥'
        @10,0 say '≥                   €€€€   ≤≤≤≤   €€€€        ﬂ                   ≥           ≥'
        @11,0 say '≥                   €€€€   ≤≤≤≤  €€€€                             ≥           ≥'
        @12,0 say '≥                   €€€€   ≤≤≤≤  €€€€                             ≥           ≥'
        @13,0 say '≥                   €€€€   ≤≤≤≤  €€€€                             ≥           ≥'
        @14,0 say '≥                   €€€€   ≤≤≤≤  €€€€                             ≥           ≥'
        @15,0 say '≥                   €€€€   ≤≤≤≤   €€€€        ‹                   ≥           ≥'
        @16,0 say '≥                   €€€€   ≤≤≤≤≤≤≤≤≤≤≤≤≤‹‹‹‹€€€                   ≥           ≥'
        @17,0 say '≥                   €€€€   ≤≤≤≤≤≤≤≤≤≤≤≤≤€€€€ﬂﬂ                    ≥           ≥'
    endif
endcase
mxcol=iif(bmpyes,30,20)
do case
case mCo_id=1 .and. mReg
    @ 20,mxcol+3 say 'R E G I S T E R E D'
case mCo_id=2
    @ 20,mxcol+6 say 'T e m p o r a r y   C o.'
case mCo_id=3
    @ 20,20 say 'S A M P L E   S Y S T E M'
case mCo_id=4
    @ 20,mxcol+8 say 'Archives'
endcase

proc logo
para id3
public logoline
opaq=.t.
ch1=substr(id3,1,1)                         // a char =10row*15col
ch2=substr(id3,2,1)
ch3=substr(id3,3,1)
store space(15) to ch1l1,ch1l2,ch1l3,ch1l4,ch1l5,ch1l6,ch1l7,ch1l8,ch1l9,ch1l10
store space(15) to ch2l1,ch2l2,ch2l3,ch2l4,ch2l5,ch2l6,ch2l7,ch2l8,ch2l9,ch2l10
store space(15) to ch3l1,ch3l2,ch3l3,ch3l4,ch3l5,ch3l6,ch3l7,ch3l8,ch3l9,ch3l10
if !empty(ch1)
    do ch&ch1 with 1,!opaq
endif
if !empty(ch2)
    do ch&ch2 with 2,opaq
endif
if !empty(ch3)
    do ch&ch3 with 3,!opaq
endif
logoline := {}
aadd(logoline, ch1l1+' ' +ch2l1+' ' + ch3l1)
aadd(logoline, ch1l2+' ' +ch2l2+' ' + ch3l2)
aadd(logoline, ch1l3+' ' +ch2l3+' ' + ch3l3)
aadd(logoline, ch1l4+' ' +ch2l4+' ' + ch3l4)
aadd(logoline, ch1l5+' ' +ch2l5+' ' + ch3l5)
aadd(logoline, ch1l6+' ' +ch2l6+' ' + ch3l6)
aadd(logoline, ch1l7+' ' +ch2l7+' ' + ch3l7)
aadd(logoline, ch1l8+' ' +ch2l8+' ' + ch3l8)
aadd(logoline, ch1l9+' ' +ch2l9+' ' + ch3l9)
aadd(logoline, ch1l10+' '+ch2l10+' '+ch3l10)
return

proc chA
para pos,opaque
line1='ch'+ltrim(str(pos,0))+'l1'
line2='ch'+ltrim(str(pos,0))+'l2'
line3='ch'+ltrim(str(pos,0))+'l3'
line4='ch'+ltrim(str(pos,0))+'l4'
line5='ch'+ltrim(str(pos,0))+'l5'
line6='ch'+ltrim(str(pos,0))+'l6'
line7='ch'+ltrim(str(pos,0))+'l7'
line8='ch'+ltrim(str(pos,0))+'l8'
line9='ch'+ltrim(str(pos,0))+'l9'
line10='ch'+ltrim(str(pos,0))+'l10'
//                  123456789012345   123456789012345
&line1 =iif(!opaque, '     ≤≤≤≤      ','     €€€€      ')
&line2 =iif(!opaque, '    ≤≤≤≤≤≤     ','    €€€€€€     ')
&line3 =iif(!opaque, '   ≤≤≤  ≤≤≤    ','   €€€  €€€    ')
&line4 =iif(!opaque, '   ≤≤≤  ≤≤≤    ','   €€€  €€€    ')
&line5 =iif(!opaque, '  ≤≤≤    ≤≤≤   ','  €€€    €€€   ')
&line6 =iif(!opaque, '  ≤≤≤≤≤≤≤≤≤≤   ','  €€€€€€€€€€   ')
&line7 =iif(!opaque, ' ≤≤≤      ≤≤≤  ',' €€€      €€€  ')
&line8 =iif(!opaque, ' ≤≤≤      ≤≤≤  ',' €€€      €€€  ')
&line9 =iif(!opaque, '≤≤≤        ≤≤≤ ','€€€        €€€ ')
&line10=iif(!opaque, '≤≤≤        ≤≤≤ ','€€€        €€€ ')
return

proc chB
para pos,opaque
line1='ch'+ltrim(str(pos,0))+'l1'
line2='ch'+ltrim(str(pos,0))+'l2'
line3='ch'+ltrim(str(pos,0))+'l3'
line4='ch'+ltrim(str(pos,0))+'l4'
line5='ch'+ltrim(str(pos,0))+'l5'
line6='ch'+ltrim(str(pos,0))+'l6'
line7='ch'+ltrim(str(pos,0))+'l7'
line8='ch'+ltrim(str(pos,0))+'l8'
line9='ch'+ltrim(str(pos,0))+'l9'
line10='ch'+ltrim(str(pos,0))+'l10'
//                  123456789012345   123456789012345
&line1 =iif(!opaque, '≤≤≤≤≤≤≤≤≤≤≤    ','€€€€€€€€€€€    ')
&line2 =iif(!opaque, '≤≤≤       ≤≤   ','€€€       €€   ')
&line3 =iif(!opaque, '≤≤≤       ≤≤≤  ','€€€       €€€  ')
&line4 =iif(!opaque, '≤≤≤      ≤≤≤   ','€€€      €€€   ')
&line5 =iif(!opaque, '≤≤≤≤≤≤≤≤≤≤     ','€€€€€€€€€€     ')
&line6 =iif(!opaque, '≤≤≤      ≤≤≤   ','€€€      €€€   ')
&line7 =iif(!opaque, '≤≤≤       ≤≤≤  ','€€€       €€€  ')
&line8 =iif(!opaque, '≤≤≤        ≤≤≤ ','€€€        €€€ ')
&line9 =iif(!opaque, '≤≤≤        ≤≤≤ ','€€€        €€€ ')
&line10=iif(!opaque, '≤≤≤≤≤≤≤≤≤≤≤≤≤  ','€€€€€€€€€€€€€  ')
return

proc chC
para pos,opaque
line1='ch'+ltrim(str(pos,0))+'l1'
line2='ch'+ltrim(str(pos,0))+'l2'
line3='ch'+ltrim(str(pos,0))+'l3'
line4='ch'+ltrim(str(pos,0))+'l4'
line5='ch'+ltrim(str(pos,0))+'l5'
line6='ch'+ltrim(str(pos,0))+'l6'
line7='ch'+ltrim(str(pos,0))+'l7'
line8='ch'+ltrim(str(pos,0))+'l8'
line9='ch'+ltrim(str(pos,0))+'l9'
line10='ch'+ltrim(str(pos,0))+'l10'
//                  123456789012345   123456789012345 
&line1 =iif(!opaque, '  ≤≤≤≤≤≤≤≤≤≤   ','  €€€€€€€€€€   ')
&line2 =iif(!opaque, '≤≤≤≤      ≤≤≤  ','€€€€      €€€  ')
&line3 =iif(!opaque, '≤≤≤        ≤≤  ','€€€        €€  ')
&line4 =iif(!opaque, '≤≤≤            ','€€€            ')
&line5 =iif(!opaque, '≤≤≤            ','€€€            ')
&line6 =iif(!opaque, '≤≤≤            ','€€€            ')
&line7 =iif(!opaque, '≤≤≤            ','€€€            ')
&line8 =iif(!opaque, '≤≤≤         ≤≤ ','€€€         €€ ')
&line9 =iif(!opaque, '≤≤≤≤       ≤≤≤ ','€€€€       €€€ ')
&line10=iif(!opaque, '  ≤≤≤≤≤≤≤≤≤≤≤  ','  €€€€€€€€€€€  ')
return

proc chD
para pos,opaque
line1='ch'+ltrim(str(pos,0))+'l1'
line2='ch'+ltrim(str(pos,0))+'l2'
line3='ch'+ltrim(str(pos,0))+'l3'
line4='ch'+ltrim(str(pos,0))+'l4'
line5='ch'+ltrim(str(pos,0))+'l5'
line6='ch'+ltrim(str(pos,0))+'l6'
line7='ch'+ltrim(str(pos,0))+'l7'
line8='ch'+ltrim(str(pos,0))+'l8'
line9='ch'+ltrim(str(pos,0))+'l9'
line10='ch'+ltrim(str(pos,0))+'l10'
//                  123456789012345   123456789012345
&line1 =iif(!opaque, '≤≤≤≤≤≤≤≤≤≤≤≤   ','€€€€€€€€€€€€   ')
&line2 =iif(!opaque, '≤≤≤       ≤≤≤  ','€€€       €€€  ')
&line3 =iif(!opaque, '≤≤≤        ≤≤≤ ','€€€        €€€ ')
&line4 =iif(!opaque, '≤≤≤        ≤≤≤ ','€€€        €€€ ')
&line5 =iif(!opaque, '≤≤≤        ≤≤≤ ','€€€        €€€ ')
&line6 =iif(!opaque, '≤≤≤        ≤≤≤ ','€€€        €€€ ')
&line7 =iif(!opaque, '≤≤≤        ≤≤≤ ','€€€        €€€ ')
&line8 =iif(!opaque, '≤≤≤        ≤≤≤ ','€€€        €€€ ')
&line9 =iif(!opaque, '≤≤≤       ≤≤≤  ','€€€       €€€  ')
&line10=iif(!opaque, '≤≤≤≤≤≤≤≤≤≤≤≤   ','€€€€€€€€€€€€   ')
return

proc chE
para pos,opaque
line1='ch'+ltrim(str(pos,0))+'l1'
line2='ch'+ltrim(str(pos,0))+'l2'
line3='ch'+ltrim(str(pos,0))+'l3'
line4='ch'+ltrim(str(pos,0))+'l4'
line5='ch'+ltrim(str(pos,0))+'l5'
line6='ch'+ltrim(str(pos,0))+'l6'
line7='ch'+ltrim(str(pos,0))+'l7'
line8='ch'+ltrim(str(pos,0))+'l8'
line9='ch'+ltrim(str(pos,0))+'l9'
line10='ch'+ltrim(str(pos,0))+'l10'
//                  123456789012345   123456789012345
&line1 =iif(!opaque, ' ≤≤≤≤≤≤≤≤≤≤≤≤≤ ',' €€€€€€€€€€€€€ ')
&line2 =iif(!opaque, ' ≤≤≤           ',' €€€           ')
&line3 =iif(!opaque, ' ≤≤≤           ',' €€€           ')
&line4 =iif(!opaque, ' ≤≤≤           ',' €€€           ')
&line5 =iif(!opaque, ' ≤≤≤≤≤≤≤≤≤≤≤   ',' €€€€€€€€€€€   ')
&line6 =iif(!opaque, ' ≤≤≤           ',' €€€           ')
&line7 =iif(!opaque, ' ≤≤≤           ',' €€€           ')
&line8 =iif(!opaque, ' ≤≤≤           ',' €€€           ')
&line9 =iif(!opaque, ' ≤≤≤‹‹‹‹‹‹‹‹‹‹ ',' €€€‹‹‹‹‹‹‹‹‹‹ ')
&line10=iif(!opaque, ' ≤≤≤≤≤≤≤≤≤≤≤≤≤ ',' €€€€€€€€€€€€€ ')
return

proc chF
para pos,opaque
line1='ch'+ltrim(str(pos,0))+'l1'
line2='ch'+ltrim(str(pos,0))+'l2'
line3='ch'+ltrim(str(pos,0))+'l3'
line4='ch'+ltrim(str(pos,0))+'l4'
line5='ch'+ltrim(str(pos,0))+'l5'
line6='ch'+ltrim(str(pos,0))+'l6'
line7='ch'+ltrim(str(pos,0))+'l7'
line8='ch'+ltrim(str(pos,0))+'l8'
line9='ch'+ltrim(str(pos,0))+'l9'
line10='ch'+ltrim(str(pos,0))+'l10'
//                  123456789012345   123456789012345
&line1 =iif(!opaque, ' ≤≤≤≤≤≤≤≤≤≤≤≤≤ ',' €€€€€€€€€€€€€ ')
&line2 =iif(!opaque, ' ≤≤≤≤≤≤≤≤≤≤≤≤≤ ',' €€€€€€€€€€€€€ ')
&line3 =iif(!opaque, ' ≤≤≤           ',' €€€           ')
&line4 =iif(!opaque, ' ≤≤≤           ',' €€€           ')
&line5 =iif(!opaque, ' ≤≤≤≤≤≤≤≤≤≤≤   ',' €€€€€€€€€€€   ')
&line6 =iif(!opaque, ' ≤≤≤           ',' €€€           ')
&line7 =iif(!opaque, ' ≤≤≤           ',' €€€           ')
&line8 =iif(!opaque, ' ≤≤≤           ',' €€€           ')
&line9 =iif(!opaque, ' ≤≤≤           ',' €€€           ')
&line10=iif(!opaque, ' ≤≤≤           ',' €€€           ')
return

proc chG
para pos,opaque
line1='ch'+ltrim(str(pos,0))+'l1'
line2='ch'+ltrim(str(pos,0))+'l2'
line3='ch'+ltrim(str(pos,0))+'l3'
line4='ch'+ltrim(str(pos,0))+'l4'
line5='ch'+ltrim(str(pos,0))+'l5'
line6='ch'+ltrim(str(pos,0))+'l6'
line7='ch'+ltrim(str(pos,0))+'l7'
line8='ch'+ltrim(str(pos,0))+'l8'
line9='ch'+ltrim(str(pos,0))+'l9'
line10='ch'+ltrim(str(pos,0))+'l10'
//                  123456789012345   123456789012345
&line1 =iif(!opaque, '  ≤≤≤≤≤≤≤≤≤≤   ','  €€€€€€€€€€   ')
&line2 =iif(!opaque, '≤≤≤≤      ≤≤≤  ','€€€€      €€€  ')
&line3 =iif(!opaque, '≤≤≤        ≤≤  ','€€€        €€  ')
&line4 =iif(!opaque, '≤≤≤            ','€€€            ')
&line5 =iif(!opaque, '≤≤≤            ','€€€            ')
&line6 =iif(!opaque, '≤≤≤            ','€€€            ')
&line7 =iif(!opaque, '≤≤≤     ≤≤≤≤≤≤ ','€€€     €€€€€€ ')
&line8 =iif(!opaque, '≤≤≤         ≤≤ ','€€€         €€ ')
&line9 =iif(!opaque, '≤≤≤≤       ≤≤≤ ','€€€€       €€€ ')
&line10=iif(!opaque, '  ≤≤≤≤≤≤≤≤≤≤≤  ','  €€€€€€€€€€€  ')
return

proc chH
para pos,opaque
line1='ch'+ltrim(str(pos,0))+'l1'
line2='ch'+ltrim(str(pos,0))+'l2'
line3='ch'+ltrim(str(pos,0))+'l3'
line4='ch'+ltrim(str(pos,0))+'l4'
line5='ch'+ltrim(str(pos,0))+'l5'
line6='ch'+ltrim(str(pos,0))+'l6'
line7='ch'+ltrim(str(pos,0))+'l7'
line8='ch'+ltrim(str(pos,0))+'l8'
line9='ch'+ltrim(str(pos,0))+'l9'
line10='ch'+ltrim(str(pos,0))+'l10'
//                  123456789012345   123456789012345
&line1 =iif(!opaque, ' ≤≤≤       ≤≤≤ ',' €€€       €€€ ')
&line2 =iif(!opaque, ' ≤≤≤       ≤≤≤ ',' €€€       €€€ ')
&line3 =iif(!opaque, ' ≤≤≤       ≤≤≤ ',' €€€       €€€ ')
&line4 =iif(!opaque, ' ≤≤≤       ≤≤≤ ',' €€€       €€€ ')
&line5 =iif(!opaque, ' ≤≤≤≤≤≤≤≤  ≤≤≤ ',' €€€€€€€€  €€€ ')
&line6 =iif(!opaque, ' ≤≤≤ ≤≤≤≤≤≤≤≤≤ ',' €€€  €€€€€€€€ ')
&line7 =iif(!opaque, ' ≤≤≤       ≤≤≤ ',' €€€       €€€ ')
&line8 =iif(!opaque, ' ≤≤≤       ≤≤≤ ',' €€€       €€€ ')
&line9 =iif(!opaque, ' ≤≤≤       ≤≤≤ ',' €€€       €€€ ')
&line10=iif(!opaque, ' ≤≤≤       ≤≤≤ ',' €€€       €€€ ')
return

proc chI
para pos,opaque
line1='ch'+ltrim(str(pos,0))+'l1'
line2='ch'+ltrim(str(pos,0))+'l2'
line3='ch'+ltrim(str(pos,0))+'l3'
line4='ch'+ltrim(str(pos,0))+'l4'
line5='ch'+ltrim(str(pos,0))+'l5'
line6='ch'+ltrim(str(pos,0))+'l6'
line7='ch'+ltrim(str(pos,0))+'l7'
line8='ch'+ltrim(str(pos,0))+'l8'
line9='ch'+ltrim(str(pos,0))+'l9'
line10='ch'+ltrim(str(pos,0))+'l10'
//                  123456789012345   123456789012345
&line1 =iif(!opaque, '   ≤≤≤≤≤≤≤≤≤   ','   €€€€€€€€€   ')
&line2 =iif(!opaque, '      ≤≤≤      ','      €€€      ')
&line3 =iif(!opaque, '      ≤≤≤      ','      €€€      ')
&line4 =iif(!opaque, '      ≤≤≤      ','      €€€      ')
&line5 =iif(!opaque, '      ≤≤≤      ','      €€€      ')
&line6 =iif(!opaque, '      ≤≤≤      ','      €€€      ')
&line7 =iif(!opaque, '      ≤≤≤      ','      €€€      ')
&line8 =iif(!opaque, '      ≤≤≤      ','      €€€      ')
&line9 =iif(!opaque, '      ≤≤≤      ','      €€€      ')
&line10=iif(!opaque, '   ≤≤≤≤≤≤≤≤≤   ','   €€€€€€€€€   ')
return

proc chJ
para pos,opaque
line1='ch'+ltrim(str(pos,0))+'l1'
line2='ch'+ltrim(str(pos,0))+'l2'
line3='ch'+ltrim(str(pos,0))+'l3'
line4='ch'+ltrim(str(pos,0))+'l4'
line5='ch'+ltrim(str(pos,0))+'l5'
line6='ch'+ltrim(str(pos,0))+'l6'
line7='ch'+ltrim(str(pos,0))+'l7'
line8='ch'+ltrim(str(pos,0))+'l8'
line9='ch'+ltrim(str(pos,0))+'l9'
line10='ch'+ltrim(str(pos,0))+'l10'
//                  123456789012345   123456789012345
&line1 =iif(!opaque, '      ≤≤≤≤≤    ','      €€€€€    ')
&line2 =iif(!opaque, '        ≤≤≤    ','        €€€    ')
&line3 =iif(!opaque, '        ≤≤≤    ','        €€€    ')
&line4 =iif(!opaque, '        ≤≤≤    ','        €€€    ')
&line5 =iif(!opaque, '        ≤≤≤    ','        €€€    ')
&line6 =iif(!opaque, '        ≤≤≤    ','        €€€    ')
&line7 =iif(!opaque, '        ≤≤≤    ','        €€€    ')
&line8 =iif(!opaque, ' ≤≤     ≤≤≤    ',' €€     €€€    ')
&line9 =iif(!opaque, ' ≤≤≤    ≤≤≤    ',' €€€    €€€    ')
&line10=iif(!opaque, '  ≤≤≤≤≤≤≤≤     ','  €€€€€€€€     ')
return

proc chK
para pos,opaque
line1='ch'+ltrim(str(pos,0))+'l1'
line2='ch'+ltrim(str(pos,0))+'l2'
line3='ch'+ltrim(str(pos,0))+'l3'
line4='ch'+ltrim(str(pos,0))+'l4'
line5='ch'+ltrim(str(pos,0))+'l5'
line6='ch'+ltrim(str(pos,0))+'l6'
line7='ch'+ltrim(str(pos,0))+'l7'
line8='ch'+ltrim(str(pos,0))+'l8'
line9='ch'+ltrim(str(pos,0))+'l9'
line10='ch'+ltrim(str(pos,0))+'l10'
//                  123456789012345   123456789012345
&line1 =iif(!opaque, ' ≤≤≤      ≤≤≤  ',' €€€      €€€  ')
&line2 =iif(!opaque, ' ≤≤≤     ≤≤≤   ',' €€€     €€€   ')
&line3 =iif(!opaque, ' ≤≤≤    ≤≤≤    ',' €€€    €€€    ')
&line4 =iif(!opaque, ' ≤≤≤   ≤≤≤     ',' €€€   €€€     ')
&line5 =iif(!opaque, ' ≤≤≤≤≤≤≤       ',' €€€€€€€       ')
&line6 =iif(!opaque, ' ≤≤≤≤≤≤≤≤      ',' €€€€€€€€      ')
&line7 =iif(!opaque, ' ≤≤≤  ≤≤≤≤     ',' €€€  €€€€     ')
&line8 =iif(!opaque, ' ≤≤≤    ≤≤≤    ',' €€€    €€€    ')
&line9 =iif(!opaque, ' ≤≤≤     ≤≤≤   ',' €€€     €€€   ')
&line10=iif(!opaque, ' ≤≤≤      ≤≤≤≤ ',' €€€      €€€€ ')
return

proc chL
para pos,opaque
line1='ch'+ltrim(str(pos,0))+'l1'
line2='ch'+ltrim(str(pos,0))+'l2'
line3='ch'+ltrim(str(pos,0))+'l3'
line4='ch'+ltrim(str(pos,0))+'l4'
line5='ch'+ltrim(str(pos,0))+'l5'
line6='ch'+ltrim(str(pos,0))+'l6'
line7='ch'+ltrim(str(pos,0))+'l7'
line8='ch'+ltrim(str(pos,0))+'l8'
line9='ch'+ltrim(str(pos,0))+'l9'
line10='ch'+ltrim(str(pos,0))+'l10'
//                  123456789012345   123456789012345
&line1 =iif(!opaque, ' ≤≤≤           ',' €€€           ')
&line2= iif(!opaque, ' ≤≤≤           ',' €€€           ')
&line3= iif(!opaque, ' ≤≤≤           ',' €€€           ')
&line4= iif(!opaque, ' ≤≤≤           ',' €€€           ')
&line5= iif(!opaque, ' ≤≤≤           ',' €€€           ')
&line6= iif(!opaque, ' ≤≤≤           ',' €€€           ')  
&line7= iif(!opaque, ' ≤≤≤           ',' €€€           ')
&line8= iif(!opaque, ' ≤≤≤           ',' €€€           ')
&line9= iif(!opaque, ' ≤≤≤‹‹‹‹‹‹‹‹‹  ',' €€€‹‹‹‹‹‹‹‹‹  ')
&line10=iif(!opaque, ' ≤≤≤≤≤≤≤≤≤≤≤≤  ',' €€€€€€€€€€€€  ') 
return

proc chM
para pos,opaque
line1='ch'+ltrim(str(pos,0))+'l1'
line2='ch'+ltrim(str(pos,0))+'l2'
line3='ch'+ltrim(str(pos,0))+'l3'
line4='ch'+ltrim(str(pos,0))+'l4'
line5='ch'+ltrim(str(pos,0))+'l5'
line6='ch'+ltrim(str(pos,0))+'l6'
line7='ch'+ltrim(str(pos,0))+'l7'
line8='ch'+ltrim(str(pos,0))+'l8'
line9='ch'+ltrim(str(pos,0))+'l9'
line10='ch'+ltrim(str(pos,0))+'l10'
//                 123456789012345   123456789012345
&line1 =iif(!opaque,'≤≤           ≤≤','€€€         €€€')
&line2 =iif(!opaque,'≤≤≤≤       ≤≤≤≤','€€€€       €€€€')
&line3 =iif(!opaque,'≤≤≤≤≤     ≤≤≤≤≤','€€€€€     €€€€€')
&line4 =iif(!opaque,'≤≤≤≤≤≤   ≤≤≤≤≤≤','€€€€€€   €€€€€€')
&line5 =iif(!opaque,'≤≤≤ ≤≤≤ ≤≤≤ ≤≤≤','€€€ €€€ €€€ €€€')
&line6 =iif(!opaque,'≤≤≤  ≤≤≤≤≤  ≤≤≤','€€€  €€€€€  €€€')
&line7 =iif(!opaque,'≤≤≤   ≤≤≤   ≤≤≤','€€€   €€€   €€€')
&line8 =iif(!opaque,'≤≤≤    ≤    ≤≤≤','€€€    €    €€€')
&line9 =iif(!opaque,'≤≤≤         ≤≤≤','€€€         €€€')
&line10=iif(!opaque,'≤≤≤         ≤≤≤','€€€         €€€')
return

proc chN
para pos,opaque
line1='ch'+ltrim(str(pos,0))+'l1'
line2='ch'+ltrim(str(pos,0))+'l2'
line3='ch'+ltrim(str(pos,0))+'l3'
line4='ch'+ltrim(str(pos,0))+'l4'
line5='ch'+ltrim(str(pos,0))+'l5'
line6='ch'+ltrim(str(pos,0))+'l6'
line7='ch'+ltrim(str(pos,0))+'l7'
line8='ch'+ltrim(str(pos,0))+'l8'
line9='ch'+ltrim(str(pos,0))+'l9'
line10='ch'+ltrim(str(pos,0))+'l10'
//                  123456789012345   123456789012345
&line1 =iif(!opaque, ' ≤≤≤≤      ≤≤≤ ',' €€€€      €€€ ')
&line2 =iif(!opaque, ' ≤≤≤≤≤     ≤≤≤ ',' €€€€€     €€€ ')
&line3 =iif(!opaque, ' ≤≤≤≤≤≤    ≤≤≤ ',' €€€€€€    €€€ ')
&line4 =iif(!opaque, ' ≤≤≤≤≤≤≤   ≤≤≤ ',' €€€€€€€   €€€ ')
&line5 =iif(!opaque, ' ≤≤≤ ≤≤≤≤  ≤≤≤ ',' €€€ €€€€  €€€ ')
&line6 =iif(!opaque, ' ≤≤≤  ≤≤≤≤ ≤≤≤ ',' €€€  €€€€ €€€ ')
&line7 =iif(!opaque, ' ≤≤≤   ≤≤≤≤≤≤≤ ',' €€€   €€€€€€€ ')
&line8 =iif(!opaque, ' ≤≤≤    ≤≤≤≤≤≤ ',' €€€    €€€€€€ ')
&line9 =iif(!opaque, ' ≤≤≤     ≤≤≤≤≤ ',' €€€     €€€€€ ')
&line10=iif(!opaque, ' ≤≤≤      ≤≤≤≤ ',' €€€      €€€€ ')
return

proc chO
para pos,opaque
line1='ch'+ltrim(str(pos,0))+'l1'
line2='ch'+ltrim(str(pos,0))+'l2'
line3='ch'+ltrim(str(pos,0))+'l3'
line4='ch'+ltrim(str(pos,0))+'l4'
line5='ch'+ltrim(str(pos,0))+'l5'
line6='ch'+ltrim(str(pos,0))+'l6'
line7='ch'+ltrim(str(pos,0))+'l7'
line8='ch'+ltrim(str(pos,0))+'l8'
line9='ch'+ltrim(str(pos,0))+'l9'
line10='ch'+ltrim(str(pos,0))+'l10'
//                  123456789012345   123456789012345
&line1 =iif(!opaque, '  ≤≤≤≤≤≤≤≤≤≤   ','  €€€€€€€€€€   ')
&line2 =iif(!opaque, '≤≤≤≤      ≤≤≤≤ ','€€€€      €€€€ ')
&line3 =iif(!opaque, '≤≤≤        ≤≤≤ ','€€€        €€€ ')
&line4 =iif(!opaque, '≤≤≤        ≤≤≤ ','€€€        €€€ ')
&line5 =iif(!opaque, '≤≤≤        ≤≤≤ ','€€€        €€€ ')
&line6 =iif(!opaque, '≤≤≤        ≤≤≤ ','€€€        €€€ ')
&line7 =iif(!opaque, '≤≤≤        ≤≤≤ ','€€€        €€€ ')
&line8 =iif(!opaque, '≤≤≤        ≤≤≤ ','€€€        €€€ ')
&line9 =iif(!opaque, '≤≤≤≤      ≤≤≤≤ ','€€€€      €€€€ ')
&line10=iif(!opaque, '  ≤≤≤≤≤≤≤≤≤≤≤  ','  €€€€€€€€€€€  ')
return

proc chP
para pos,opaque
line1='ch'+ltrim(str(pos,0))+'l1'
line2='ch'+ltrim(str(pos,0))+'l2'
line3='ch'+ltrim(str(pos,0))+'l3'
line4='ch'+ltrim(str(pos,0))+'l4'
line5='ch'+ltrim(str(pos,0))+'l5'
line6='ch'+ltrim(str(pos,0))+'l6'
line7='ch'+ltrim(str(pos,0))+'l7'
line8='ch'+ltrim(str(pos,0))+'l8'
line9='ch'+ltrim(str(pos,0))+'l9'
line10='ch'+ltrim(str(pos,0))+'l10'
//                  123456789012345   123456789012345
&line1 =iif(!opaque, '≤≤≤≤≤≤≤≤≤≤≤    ','€€€€€€€€€€€    ')
&line2 =iif(!opaque, '≤≤≤       ≤≤   ','€€€       €€   ')
&line3 =iif(!opaque, '≤≤≤       ≤≤≤  ','€€€       €€€  ')
&line4 =iif(!opaque, '≤≤≤      ≤≤≤   ','€€€      €€€   ')
&line5 =iif(!opaque, '≤≤≤≤≤≤≤≤≤≤     ','€€€€€€€€€€     ')
&line6 =iif(!opaque, '≤≤≤            ','€€€            ')
&line7 =iif(!opaque, '≤≤≤            ','€€€            ')
&line8 =iif(!opaque, '≤≤≤            ','€€€            ')
&line9 =iif(!opaque, '≤≤≤            ','€€€            ')
&line10=iif(!opaque, '≤≤≤            ','€€€            ')
return

proc chQ
para pos,opaque
line1='ch'+ltrim(str(pos,0))+'l1'
line2='ch'+ltrim(str(pos,0))+'l2'
line3='ch'+ltrim(str(pos,0))+'l3'
line4='ch'+ltrim(str(pos,0))+'l4'
line5='ch'+ltrim(str(pos,0))+'l5'
line6='ch'+ltrim(str(pos,0))+'l6'
line7='ch'+ltrim(str(pos,0))+'l7'
line8='ch'+ltrim(str(pos,0))+'l8'
line9='ch'+ltrim(str(pos,0))+'l9'
line10='ch'+ltrim(str(pos,0))+'l10'
//                  123456789012345   123456789012345
&line1 =iif(!opaque, '  ≤≤≤≤≤≤≤≤≤≤   ','  €€€€€€€€€€   ')
&line2 =iif(!opaque, '≤≤≤≤      ≤≤≤≤ ','€€€€      €€€€ ')
&line3 =iif(!opaque, '≤≤≤        ≤≤≤ ','€€€        €€€ ')
&line4 =iif(!opaque, '≤≤≤        ≤≤≤ ','€€€        €€€ ')
&line5 =iif(!opaque, '≤≤≤        ≤≤≤ ','€€€        €€€ ')
&line6 =iif(!opaque, '≤≤≤        ≤≤≤ ','€€€        €€€ ')
&line7 =iif(!opaque, '≤≤≤        ≤≤≤ ','€€€        €€€ ')
&line8 =iif(!opaque, '≤≤≤     ≤≤≤ ≤≤ ','€€€     €€€ €€ ')
&line9 =iif(!opaque, '≤≤≤≤     ≤≤≤≤  ','€€€€     €€€€  ')
&line10=iif(!opaque, '  ≤≤≤≤≤≤≤≤ ≤≤≤ ','  €€€€€€€€ €€€ ')
return

proc chR
para pos,opaque
line1='ch'+ltrim(str(pos,0))+'l1'
line2='ch'+ltrim(str(pos,0))+'l2'
line3='ch'+ltrim(str(pos,0))+'l3'
line4='ch'+ltrim(str(pos,0))+'l4'
line5='ch'+ltrim(str(pos,0))+'l5'
line6='ch'+ltrim(str(pos,0))+'l6'
line7='ch'+ltrim(str(pos,0))+'l7'
line8='ch'+ltrim(str(pos,0))+'l8'
line9='ch'+ltrim(str(pos,0))+'l9'
line10='ch'+ltrim(str(pos,0))+'l10'
//                  123456789012345   123456789012345
&line1 =iif(!opaque, '≤≤≤≤≤≤≤≤≤≤≤    ','€€€€€€€€€€€    ')
&line2 =iif(!opaque, '≤≤≤       ≤≤   ','€€€       €€   ')
&line3 =iif(!opaque, '≤≤≤       ≤≤≤  ','€€€       €€€  ')
&line4 =iif(!opaque, '≤≤≤      ≤≤≤   ','€€€      €€€   ')
&line5 =iif(!opaque, '≤≤≤≤≤≤≤≤≤≤     ','€€€€€€€€€€     ')
&line6 =iif(!opaque, '≤≤≤   ≤≤≤      ','€€€   €€€      ')
&line7 =iif(!opaque, '≤≤≤    ≤≤≤     ','€€€    €€€     ')
&line8 =iif(!opaque, '≤≤≤     ≤≤≤    ','€€€     €€€    ')
&line9 =iif(!opaque, '≤≤≤      ≤≤≤   ','€€€      €€€   ')
&line10=iif(!opaque, '≤≤≤       ≤≤≤  ','€€€       €€€  ')
return

proc chS
para pos,opaque
line1='ch'+ltrim(str(pos,0))+'l1'
line2='ch'+ltrim(str(pos,0))+'l2'
line3='ch'+ltrim(str(pos,0))+'l3'
line4='ch'+ltrim(str(pos,0))+'l4'
line5='ch'+ltrim(str(pos,0))+'l5'
line6='ch'+ltrim(str(pos,0))+'l6'
line7='ch'+ltrim(str(pos,0))+'l7'
line8='ch'+ltrim(str(pos,0))+'l8'
line9='ch'+ltrim(str(pos,0))+'l9'
line10='ch'+ltrim(str(pos,0))+'l10'
//                  123456789012345   123456789012345
&line1 =iif(!opaque, '  ≤≤≤≤≤≤≤≤≤≤   ','  €€€€€€€€€€   ')
&line2 =iif(!opaque, '≤≤≤≤      ≤≤≤  ','€€€€      €€€  ')
&line3 =iif(!opaque, '≤≤≤        ≤≤  ','€€€        €€  ')
&line4 =iif(!opaque, '  ≤≤≤          ','  €€€          ')
&line5 =iif(!opaque, '    ≤≤≤≤       ','    €€€€       ')
&line6 =iif(!opaque, '       ≤≤≤≤    ','       €€€€    ')
&line7 =iif(!opaque, '          ≤≤≤  ','          €€€  ')
&line8 =iif(!opaque, '≤≤        ≤≤≤  ','€€        €€€  ')
&line9 =iif(!opaque, '≤≤≤      ≤≤≤≤  ','€€€      €€€€  ')
&line10=iif(!opaque, ' ≤≤≤≤≤≤≤≤≤≤≤   ',' €€€€€€€€€€€   ')
return

proc chT
para pos,opaque
line1='ch'+ltrim(str(pos,0))+'l1'
line2='ch'+ltrim(str(pos,0))+'l2'
line3='ch'+ltrim(str(pos,0))+'l3'
line4='ch'+ltrim(str(pos,0))+'l4'
line5='ch'+ltrim(str(pos,0))+'l5'
line6='ch'+ltrim(str(pos,0))+'l6'
line7='ch'+ltrim(str(pos,0))+'l7'
line8='ch'+ltrim(str(pos,0))+'l8'
line9='ch'+ltrim(str(pos,0))+'l9'
line10='ch'+ltrim(str(pos,0))+'l10'
//                  123456789012345   123456789012345
&line1 =iif(!opaque, '≤≤≤≤≤≤≤≤≤≤≤≤≤≤ ','€€€€€€€€€€€€€€ ')
&line2 =iif(!opaque, '≤≤≤≤≤≤≤≤≤≤≤≤≤≤ ','€€€€€€€€€€€€€€ ')
&line3 =iif(!opaque, '     ≤≤≤≤      ','     €€€€      ')
&line4 =iif(!opaque, '     ≤≤≤≤      ','     €€€€      ')
&line5 =iif(!opaque, '     ≤≤≤≤      ','     €€€€      ')
&line6 =iif(!opaque, '     ≤≤≤≤      ','     €€€€      ')
&line7 =iif(!opaque, '     ≤≤≤≤      ','     €€€€      ')
&line8 =iif(!opaque, '     ≤≤≤≤      ','     €€€€      ')
&line9 =iif(!opaque, '     ≤≤≤≤      ','     €€€€      ')
&line10=iif(!opaque, '     ≤≤≤≤      ','     €€€€      ')
return

proc chU
para pos,opaque
line1='ch'+ltrim(str(pos,0))+'l1'
line2='ch'+ltrim(str(pos,0))+'l2'
line3='ch'+ltrim(str(pos,0))+'l3'
line4='ch'+ltrim(str(pos,0))+'l4'
line5='ch'+ltrim(str(pos,0))+'l5'
line6='ch'+ltrim(str(pos,0))+'l6'
line7='ch'+ltrim(str(pos,0))+'l7'
line8='ch'+ltrim(str(pos,0))+'l8'
line9='ch'+ltrim(str(pos,0))+'l9'
line10='ch'+ltrim(str(pos,0))+'l10'
//                  123456789012345   123456789012345
&line1 =iif(!opaque, '≤≤≤        ≤≤≤ ','€€€        €€€ ')
&line2 =iif(!opaque, '≤≤≤        ≤≤≤ ','€€€        €€€ ')
&line3 =iif(!opaque, '≤≤≤        ≤≤≤ ','€€€        €€€ ')
&line4 =iif(!opaque, '≤≤≤        ≤≤≤ ','€€€        €€€ ')
&line5 =iif(!opaque, '≤≤≤        ≤≤≤ ','€€€        €€€ ')
&line6 =iif(!opaque, '≤≤≤        ≤≤≤ ','€€€        €€€ ')
&line7 =iif(!opaque, '≤≤≤        ≤≤≤ ','€€€        €€€ ')
&line8 =iif(!opaque, '≤≤≤        ≤≤≤ ','€€€        €€€ ')
&line9 =iif(!opaque, '≤≤≤≤      ≤≤≤≤ ','€€€€      €€€€ ')
&line10=iif(!opaque, '  ≤≤≤≤≤≤≤≤≤≤≤  ','  €€€€€€€€€€€  ')
return

proc chV
para pos,opaque
line1='ch'+ltrim(str(pos,0))+'l1'
line2='ch'+ltrim(str(pos,0))+'l2'
line3='ch'+ltrim(str(pos,0))+'l3'
line4='ch'+ltrim(str(pos,0))+'l4'
line5='ch'+ltrim(str(pos,0))+'l5'
line6='ch'+ltrim(str(pos,0))+'l6'
line7='ch'+ltrim(str(pos,0))+'l7'
line8='ch'+ltrim(str(pos,0))+'l8'
line9='ch'+ltrim(str(pos,0))+'l9'
line10='ch'+ltrim(str(pos,0))+'l10'
//                  123456789012345   123456789012345
&line1 =iif(!opaque, '≤≤≤        ≤≤≤ ','€€€        €€€ ')
&line2 =iif(!opaque, '≤≤≤        ≤≤≤ ','€€€        €€€ ')
&line3 =iif(!opaque, ' ≤≤≤      ≤≤≤  ',' €€€      €€€  ')
&line4 =iif(!opaque, ' ≤≤≤      ≤≤≤  ',' €€€      €€€  ')
&line5 =iif(!opaque, '  ≤≤≤    ≤≤≤   ','  €€€    €€€   ')
&line6 =iif(!opaque, '  ≤≤≤    ≤≤≤   ','  €€€    €€€   ')
&line7 =iif(!opaque, '   ≤≤≤  ≤≤≤    ','   €€€  €€€    ')
&line8 =iif(!opaque, '   ≤≤≤  ≤≤≤    ','   €€€  €€€    ')
&line9 =iif(!opaque, '    ≤≤  ≤≤     ','    €€  €€     ')
&line10=iif(!opaque, '     ≤≤≤≤      ','     €€€€      ')
return

proc chW
para pos,opaque
line1='ch'+ltrim(str(pos,0))+'l1'
line2='ch'+ltrim(str(pos,0))+'l2'
line3='ch'+ltrim(str(pos,0))+'l3'
line4='ch'+ltrim(str(pos,0))+'l4'
line5='ch'+ltrim(str(pos,0))+'l5'
line6='ch'+ltrim(str(pos,0))+'l6'
line7='ch'+ltrim(str(pos,0))+'l7'
line8='ch'+ltrim(str(pos,0))+'l8'
line9='ch'+ltrim(str(pos,0))+'l9'
line10='ch'+ltrim(str(pos,0))+'l10'
//                  123456789012345   123456789012345
&line1 =iif(!opaque, '≤≤≤         ≤≤≤','€€€         €€€')
&line2 =iif(!opaque, '≤≤≤         ≤≤≤','€€€         €€€')
&line3 =iif(!opaque, '≤≤≤    ≤    ≤≤≤','€€€    €    €€€')
&line4 =iif(!opaque, '≤≤≤   ≤≤≤   ≤≤≤','€€€   €€€   €€€')
&line5 =iif(!opaque, '≤≤≤  ≤≤≤≤≤  ≤≤≤','€€€  €€€€€  €€€')
&line6 =iif(!opaque, '≤≤≤ ≤≤≤ ≤≤≤ ≤≤≤','€€€ €€€ €€€ €€€')
&line7 =iif(!opaque, '≤≤≤≤≤≤   ≤≤≤≤≤≤','€€€€€€   €€€€€€')
&line8 =iif(!opaque, '≤≤≤≤≤     ≤≤≤≤≤','€€€€€     €€€€€')
&line9 =iif(!opaque, '≤≤≤≤       ≤≤≤≤','€€€€       €€€€')
&line10=iif(!opaque, ' ≤≤         ≤≤ ',' €€         €€ ')
return

proc chX
para pos,opaque
line1='ch'+ltrim(str(pos,0))+'l1'
line2='ch'+ltrim(str(pos,0))+'l2'
line3='ch'+ltrim(str(pos,0))+'l3'
line4='ch'+ltrim(str(pos,0))+'l4'
line5='ch'+ltrim(str(pos,0))+'l5'
line6='ch'+ltrim(str(pos,0))+'l6'
line7='ch'+ltrim(str(pos,0))+'l7'
line8='ch'+ltrim(str(pos,0))+'l8'
line9='ch'+ltrim(str(pos,0))+'l9'
line10='ch'+ltrim(str(pos,0))+'l10'
//                  123456789012345   123456789012345
&line1 =iif(!opaque, '≤≤≤≤      ≤≤≤≤ ','€€€€      €€€€ ')
&line2 =iif(!opaque, ' ≤≤≤≤    ≤≤≤≤  ',' €€€€    €€€€  ')
&line3 =iif(!opaque, '  ≤≤≤≤  ≤≤≤≤   ','  €€€€  €€€€   ')
&line4 =iif(!opaque, '   ≤≤≤≤≤≤≤≤    ','   €€€€€€€€    ')
&line5 =iif(!opaque, '    ≤≤≤≤≤≤     ','    €€€€€€     ')
&line6 =iif(!opaque, '    ≤≤≤≤≤      ','    €€€€€      ')
&line7 =iif(!opaque, '   ≤≤≤≤≤≤≤     ','   €€€€€€€     ')
&line8 =iif(!opaque, '  ≤≤≤≤  ≤≤≤≤   ','  €€€€  €€€€   ')
&line9 =iif(!opaque, ' ≤≤≤≤    ≤≤≤≤  ',' €€€€    €€€€  ')
&line10=iif(!opaque, '≤≤≤≤      ≤≤≤≤ ','€€€€      €€€€ ')
return

proc chY
para pos,opaque
line1='ch'+ltrim(str(pos,0))+'l1'
line2='ch'+ltrim(str(pos,0))+'l2'
line3='ch'+ltrim(str(pos,0))+'l3'
line4='ch'+ltrim(str(pos,0))+'l4'
line5='ch'+ltrim(str(pos,0))+'l5'
line6='ch'+ltrim(str(pos,0))+'l6'
line7='ch'+ltrim(str(pos,0))+'l7'
line8='ch'+ltrim(str(pos,0))+'l8'
line9='ch'+ltrim(str(pos,0))+'l9'
line10='ch'+ltrim(str(pos,0))+'l10'
//                  123456789012345   123456789012345
&line1 =iif(!opaque, '≤≤≤≤      ≤≤≤≤ ','€€€€      €€€€ ')
&line2 =iif(!opaque, ' ≤≤≤≤    ≤≤≤≤  ',' €€€€    €€€€  ')
&line3 =iif(!opaque, '  ≤≤≤≤  ≤≤≤≤   ','  €€€€  €€€€   ')
&line4 =iif(!opaque, '   ≤≤≤≤≤≤≤≤    ','   €€€€€€€€    ')
&line5 =iif(!opaque, '    ≤≤≤≤≤≤     ','    €€€€€€     ')
&line6 =iif(!opaque, '     ≤≤≤≤      ','     €€€€      ')
&line7 =iif(!opaque, '     ≤≤≤≤      ','     €€€€      ')
&line8 =iif(!opaque, '     ≤≤≤≤      ','     €€€€      ')
&line9 =iif(!opaque, '     ≤≤≤≤      ','     €€€€      ')
&line10=iif(!opaque, '     ≤≤≤≤      ','     €€€€      ')
return

proc chZ
para pos,opaque
line1='ch'+ltrim(str(pos,0))+'l1'
line2='ch'+ltrim(str(pos,0))+'l2'
line3='ch'+ltrim(str(pos,0))+'l3'
line4='ch'+ltrim(str(pos,0))+'l4'
line5='ch'+ltrim(str(pos,0))+'l5'
line6='ch'+ltrim(str(pos,0))+'l6'
line7='ch'+ltrim(str(pos,0))+'l7'
line8='ch'+ltrim(str(pos,0))+'l8'
line9='ch'+ltrim(str(pos,0))+'l9'
line10='ch'+ltrim(str(pos,0))+'l10'
//                  123456789012345   123456789012345
&line1 =iif(!opaque, '≤≤≤≤≤≤≤≤≤≤≤≤≤≤ ','€€€€€€€€€€€€€€ ')
&line2 =iif(!opaque, '          ≤≤≤≤ ','          €€€€ ')
&line3 =iif(!opaque, '         ≤≤≤≤  ','         €€€€  ')
&line4 =iif(!opaque, '        ≤≤≤≤   ','        €€€€   ')
&line5 =iif(!opaque, '       ≤≤≤≤    ','       €€€€    ')
&line6 =iif(!opaque, '     ≤≤≤≤      ','     €€€€      ')
&line7 =iif(!opaque, '    ≤≤≤≤       ','    €€€€       ')
&line8 =iif(!opaque, '   ≤≤≤≤        ','   €€€€        ')
&line9 =iif(!opaque, ' ≤≤≤≤          ',' €€€€          ')
&line10=iif(!opaque, '≤≤≤≤≤≤≤≤≤≤≤≤≤≤ ','€€€€€€€€€€€€€€ ')
return

