 
 /*------------------------------------------------------------------------
    File        : BaseRules
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : dkurapkis
    Created     : Mon Jan 09 20:19:45 EET 2017
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING rules.IRules.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS rules.BaseRules IMPLEMENTS IRules: 
		
	CONSTRUCTOR PUBLIC BaseRules (  ):
		SUPER ().
		
	END CONSTRUCTOR.
    
END CLASS.