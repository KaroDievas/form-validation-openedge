 
 /*------------------------------------------------------------------------
    File        : FormParameters
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : dkurapkis
    Created     : Wed Jan 11 22:17:52 EET 2017
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS example.FormParameters INHERITS BaseParameter: 

    DEFINE PUBLIC PROPERTY username AS CHARACTER NO-UNDO GET. SET.

    CONSTRUCTOR PUBLIC FormParameters():
        SUPER ().
        THIS-OBJECT:example().
    END CONSTRUCTOR.
    
    METHOD PUBLIC VOID example():
        DEFINE VARIABLE oFormValidator AS FormValidator NO-UNDO.
        
        MESSAGE "Starting validation process".
        
        oFormValidator = NEW FormValidator().
        oFormValidator:setField("username"):setFieldRules("required").
        oFormValidator:setParameterObject(THIS-OBJECT).
        oFormValidator:processValidation().
        
        IF oFormValidator:hasErrors THEN DO:
            MESSAGE "Form Has errors".
        END.
        ELSE DO:
            MESSAGE "Form is correct".
        END.
        
        MESSAGE "End validation process".
    END METHOD.
END CLASS.