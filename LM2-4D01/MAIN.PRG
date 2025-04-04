// The Leisure Company.
// All Rights Reserved.
//---------------------------------------------------------

#include "Inkey.ch"     // Include Library
#include "Llibg.ch"     // Include Library
#include "Achoice.ch"   // Include Library
#include "Set.ch"       // Include Library

#include "\programs\TLCUtil\Globvar.ch"

#include ".\Registr.ch"   // keep in local development directory
#include ".\AxsLev.ch"    // keep in local development directory
//#include ".\Errorcod.ch"  // keep in local development directory

cls

MsgCenter(PROGRAMNAME+' '+VERSION,   1, .f., LLG_MODE_SET)
MsgCenter(REGISTEREDTO,              2, .f., LLG_MODE_SET)
MsgCenter(OWNER,      maxrow()-4, .f., LLG_MODE_SET)
MsgCenter(COPYRIGHT,  maxrow()-3, .f., LLG_MODE_SET)
MsgCenter(OWNADDRESS, maxrow()-2, .f., LLG_MODE_SET)
MsgCenter(OWNCONTACT, maxrow()-1, .f., LLG_MODE_SET)

MsgCenter("Please wait. Initializing system.", maxrow()/2, .f., LLG_MODE_SET)

#include "\programs\TLCUtil\preopen.ch"
#include "\programs\TLCUtil\dbfvalid.ch"

openfile("Database", 1, "Database", "DBFNAME", 'Database')
set filter to alltrim(upper(database->mode)) = alltrim(upper(mMode))
go bott
go top

aAccess := seclevel()
if !aAccess[1]
    warning(1,"Access not granted.")
else
    menuLev      := {}
    aadd(menuLev,0)
    menuScr      := {}
    aadd(menuScr,'Mainscreen')
    startno      := 1 //1st Item
    CurrLevel    := 1 //Main Menu
    do while .t.
        do &(menuScr[CurrLevel])
        menuChoice := menus(menuLev[CurrLevel],startno)
        menuname   := menuChoice[1]    // Menu item name
        menudo     := menuChoice[2]    // Menu do program or sublevel
        menumsg    := menuChoice[3]    // Menu Message
        menuScreen := iif(empty(menuChoice[4]),'Mainscreen',menuChoice[4])    // Menu screen
        menupLev   := menuChoice[5]    // Menu previous Level
        do case
        case Upper(alltrim(menudo)) = 'QUIT'
            do &menuScreen
    exit
        case lastkey() = 27
            if CurrLevel>1
                adel(menuLev,CurrLevel)
                adel(menuScr,CurrLevel)
                CurrLevel    -= 1
                asize(menuLev,CurrLevel)
                asize(menuScr,CurrLevel)
            endif
        case val(menudo) = 0
            do &menuScreen
            if !empty(menudo)
                do &menudo
            endif
        otherwise
            CurrLevel     += 1
            aadd(menuLev,val(menudo))
            aadd(menuScr,menuScreen)
        endcase
    enddo
endif

//---------------------------------------------------------
#include "\programs\TLCUtil\Screens.ch"
#include "\programs\TLCUtil\Access.ch"
#include "\programs\TLCUtil\GenFunc.ch"
#include "\programs\TLCUtil\SysSet.ch"
#include "\programs\TLCUtil\PrntProc.ch"
#include "\programs\TLCUtil\SysProc.ch"
#include "\programs\TLCUtil\HelpSys.ch"
#include ".\Includes.ch"    // keep in local development directory
//*********************************************************
