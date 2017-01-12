 
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
USING Progress.Json.ObjectModel.JsonObject FROM PROPATH.
USING Progress.Json.ObjectModel.JsonArray FROM PROPATH.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS FormValidator: 
    DEFINE PRIVATE PROPERTY cErrorCodeBegining AS CHARACTER INITIAL "error.field." NO-UNDO GET. SET.
    DEFINE PRIVATE PROPERTY RULES_LIST AS CHARACTER INITIAL "required,integer,double,date" NO-UNDO GET. SET.
    DEFINE PRIVATE PROPERTY oFieldRulesObject AS JsonObject NO-UNDO GET. SET.
    DEFINE PRIVATE PROPERTY oErrorObject AS JsonArray NO-UNDO GET. SET.
    DEFINE PUBLIC PROPERTY hasErrors AS LOGICAL INITIAL FALSE NO-UNDO GET. SET.
    
    DEFINE PRIVATE PROPERTY cCurrentField AS CHARACTER NO-UNDO GET. SET.
    
    DEFINE PRIVATE PROPERTY oParameters AS BaseParameter NO-UNDO GET. SET.
    
    CONSTRUCTOR PUBLIC FormValidator():
        THIS-OBJECT:oErrorObject = NEW JsonArray().
        THIS-OBJECT:oFieldRulesObject = NEW JsonObject().
    END CONSTRUCTOR.
    
    METHOD PUBLIC VOID setErrorCodeBegining(cErrorCodeBegining AS CHARACTER):
        THIS-OBJECT:cErrorCodeBegining = cErrorCodeBegining.
    END METHOD.
    
    METHOD PUBLIC VOID processValidation():
        DEFINE VARIABLE i AS INTEGER NO-UNDO.
        DEFINE VARIABLE cValidatableFields AS CHARACTER EXTENT NO-UNDO.
        
        cValidatableFields = THIS-OBJECT:oFieldRulesObject:GetNames().
        DO i=1 TO EXTENT (cValidatableFields):
            THIS-OBJECT:validateRules(cValidatableFields[i], THIS-OBJECT:oFieldRulesObject:GetJsonArray(cValidatableFields[i])).
        END.
    END METHOD.
    
    METHOD PRIVATE VOID validateRules(cFieldName AS CHARACTER, oRulesArray AS JsonArray):
        DEFINE VARIABLE cRuleName AS CHARACTER NO-UNDO.
        DEFINE VARIABLE i AS INTEGER NO-UNDO.
        
        DO i=1 TO oRulesArray:LENGTH:
            CASE oRulesArray:GetCharacter(i):
                WHEN "required" THEN 
                    DO:
                        THIS-OBJECT:validateRequired(cFieldName, "").
                    END. 
            END CASE.
        END.
        
    END METHOD.
    
    METHOD FINAL PUBLIC FormValidator setField(cFieldName AS CHARACTER):
        DEFINE VARIABLE oRulesArray AS JsonArray NO-UNDO.
        
        THIS-OBJECT:cCurrentField = cFieldName.
        IF NOT THIS-OBJECT:oFieldRulesObject:Has(cFieldName) THEN DO:
            oRulesArray = NEW JsonArray().
            THIS-OBJECT:oFieldRulesObject:add(cFieldName, oRulesArray).
        END.
        
        RETURN THIS-OBJECT.
    END METHOD.
    
    METHOD PUBLIC VOID setFieldAndRulesArray(cFieldName AS CHARACTER, oRulesArray AS JsonArray):
        THIS-OBJECT:cCurrentField = cFieldName.
        IF NOT THIS-OBJECT:oFieldRulesObject:Has(cFieldName) THEN 
        DO:
            THIS-OBJECT:oFieldRulesObject:add(cFieldName, oRulesArray).
        END.
    END METHOD.
    
    METHOD FINAL PUBLIC FormValidator setFieldRules(cRule AS CHARACTER):
        DEFINE VARIABLE oRulesArray AS JsonArray NO-UNDO.
        
        THIS-OBJECT:isExistRule(cRule).
        IF THIS-OBJECT:oFieldRulesObject:Has(THIS-OBJECT:cCurrentField) THEN DO:
            oRulesArray = THIS-OBJECT:oFieldRulesObject:GetJsonArray(THIS-OBJECT:cCurrentField).
            oRulesArray:Add(cRule).
        END.
        
        RETURN THIS-OBJECT.
    END METHOD.
    
    METHOD PUBLIC JsonArray getErrorList():
        RETURN THIS-OBJECT:oErrorObject.
    END METHOD.
    
    METHOD PUBLIC VOID setParameterObject(oParameters AS BaseParameter):
        THIS-OBJECT:oParameters = oParameters.
    END METHOD.
    
    METHOD PRIVATE VOID isExistRule(cRule AS CHARACTER):
        IF INDEX(THIS-OBJECT:RULES_LIST, cRule) = 0 THEN DO:
            UNDO, THROW NEW AppError("Failed to find rule").
        END.
    END METHOD.
    
    METHOD PRIVATE VOID validateRequired(cFieldName AS CHARACTER, cFieldValue AS CHARACTER):
        IF cFieldValue = "" OR cFieldValue = ? THEN DO:
            THIS-OBJECT:setError(SUBSTITUTE("&1&2&3", THIS-OBJECT:cErrorCodeBegining, cFieldName, ".required")).
        END.
    END METHOD.
    
    METHOD PRIVATE VOID setError(cErrorMessage AS CHARACTER):
        THIS-OBJECT:oErrorObject:add(cErrorMessage).
        THIS-OBJECT:hasErrors = TRUE.
    END METHOD.
END CLASS.