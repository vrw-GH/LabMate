// Set Access Levels for Procedures
//---------------------------------------------------------
// Syntax: #Define AXL_<PROC> nLevel //Note: all in Uppercase
/************************************************************
Levels (1 - 99 only):
    (guidelines)
    0           - No Access
    1           - VRW (Exculsive)
    2  - 10     - Administrative
    11 - 20     - Higher Management
    21 - 30     - Middle Management
    31 - 40     - Lower Management
    41 - 50     - General Management
    51 - 60     - Higer Supervisory/Officer
    61 - 70     - Supervisory
    71 - 80     - High Level User
    81 - 90     - General User
    91 - 99     - Low Level User 
*/

//      	Procedure       		Level

#Define 	AXL_PWDOVRRIDE      	5

#Define 	AXL_SECSYS          	10
#Define 	AXL_SORTFILE        	10
#Define 	AXL_EDITDB          	10

#Define 	AXL_COMPINFO        	20

#Define 	AXL_ARCHDB          	50
#Define 	AXL_RETRDB          	50
#Define 	AXL_EDPATDB         	50
#Define 	AXL_EDPRODB         	50
#Define 	AXL_SYSSET  			50
#Define 	AXL_EDITTXT         	50
#Define 	AXL_CHANGPROS  			50
#Define 	AXL_ADDENTITY       	50

#Define 	AXL_PRINTSET        	70

#Define 	AXL_SELECTCO        	90

#Define 	AXL_LABREPS         	95

//*********************************************************
