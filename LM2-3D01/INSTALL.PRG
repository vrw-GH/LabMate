cls
para regco
set cursor off
@ 0,0 say 'T' color '+w'
@ 0,1 say 'H' color '+w'
@ 0,2 say 'E' color '+gr'
@ 0,3 say ' ' color '+gr'
@ 0,4 say 'L' color '+gr'
@ 0,5 say 'E' color '+gr'
@ 0,6 say 'I' color '+g'
@ 0,7 say 'S' color '+g'
@ 0,8 say 'U' color '+g'
@ 0,9 say 'R' color '+g'
@ 0,10 say 'E' color 'g'
@ 0,11 say ' ' color 'g'
@ 0,12 say 'C' color 'g'
@ 0,13 say 'O.' color 'g'
@ 0,14 say ' ' color 'g'
@ 0,15 say 'Tel:+94 (0)31 38731 ' color '+b'
set message to 20 center
if empty(regco)
    ?'Usage: Install <regco>'
else
    @ 8, 25 say 'Installation for LAB-MATE 2000'
    @ 9, 25 say '    (in current directory)    '
    @ 15, 25 say '     < Select Option >       '
    @ 12, 36 prompt 'Install - '+regco message 'Install option will overwrite all previous files!'
    @ 13, 36 prompt 'Exit   ' message 'Exit without installing.'
    menu to option
    if option=1
        do case
        case !file(regco+".ex_")
            ?'Cannot find file: '+regco+'.ex_'
        case !file("skeleton.ex_")
            ?'Cannot find file: Skeleton.ex_'
        otherwise
            command='attrib -s -h -r '+regco+'.*'
            !&command
            command='if exist '+regco+'.exe del '+regco+'.exe'
            !&command
            command='rename '+regco+'.ex_ '+regco+'.exe'
            !&command
            command=regco+' -d'
            !&command
            command='rename '+regco+'.exe '+regco+'.ins'
            !&command
            !attrib -s -h -r skeleton.*
            !if exist skeleteon.exe del skeleton.exe
            !rename skeleton.ex_ skeleton.exe
            !skeleton -d
            !rename skeleton.exe skeleton.ins
            !attrib +h +r *.ins
            cls
            @ 0,0 say 'T' color '+w'
            @ 0,1 say 'H' color '+w'
            @ 0,2 say 'E' color '+gr'
            @ 0,3 say ' ' color '+gr'
            @ 0,4 say 'L' color '+gr'
            @ 0,5 say 'E' color '+gr'
            @ 0,6 say 'I' color '+g'
            @ 0,7 say 'S' color '+g'
            @ 0,8 say 'U' color '+g'
            @ 0,9 say 'R' color '+g'
            @ 0,10 say 'E' color 'g'
            @ 0,11 say ' ' color 'g'
            @ 0,12 say 'C' color 'g'
            @ 0,13 say 'O.' color 'g'
            @ 0,14 say ' ' color 'g'
            @ 0,15 say 'Tel:+94 (0)31 38731 ' color '+b'
            !if errorlevel = 0 echo Installation complete. Type LM2 & Enter to start.
        endcase
    else
        cls
        @ 0,0 say 'T' color '+w'
        @ 0,1 say 'H' color '+w'
        @ 0,2 say 'E' color '+gr'
        @ 0,3 say ' ' color '+gr'
        @ 0,4 say 'L' color '+gr'
        @ 0,5 say 'E' color '+gr'
        @ 0,6 say 'I' color '+g'
        @ 0,7 say 'S' color '+g'
        @ 0,8 say 'U' color '+g'
        @ 0,9 say 'R' color '+g'
        @ 0,10 say 'E' color 'g'
        @ 0,11 say ' ' color 'g'
        @ 0,12 say 'C' color 'g'
        @ 0,13 say 'O.' color 'g'
        @ 0,14 say ' ' color 'g'
        @ 0,15 say 'Tel:+94 (0)31 38731 ' color '+b'
        ?'Installation Aborted.'
    endif
endif
