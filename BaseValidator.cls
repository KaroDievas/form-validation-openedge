 
 /*------------------------------------------------------------------------
    File        : BaseValidator
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : dkurapkis
    Created     : Mon Jan 09 20:04:08 EET 2017
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING rules.IRules FROM PROPATH.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS BaseValidator: 
    
    DEFINE PRIVATE PROPERTY oRules AS IRules NO-UNDO GET. SET.
    DEFINE PRIVATE PROPERTY cErrorCodeBegining AS CHARACTER NO-UNDO GET. SET.
    
    CONSTRUCTOR PUBLIC BaseValidator():
        
    END CONSTRUCTOR.
    
    METHOD PUBLIC VOID setErrorCodeBegining(cErrorCodeBegining AS CHARACTER):
        THIS-OBJECT:cErrorCodeBegining = cErrorCodeBegining.
    END METHOD.
    
    METHOD PUBLIC VOID processValidation():
        
    END METHOD.
    
END CLASS.