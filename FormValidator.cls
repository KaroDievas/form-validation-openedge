 
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
    DEFINE PRIVATE PROPERTY cErrorCodeBegining  AS CHARACTER INITIAL "error.field."                     NO-UNDO GET. SET.
    DEFINE PRIVATE PROPERTY RULES_LIST          AS CHARACTER INITIAL "required,integer,double,date"     NO-UNDO GET. SET.
    DEFINE PRIVATE PROPERTY oFieldRulesObject   AS JsonObject                                           NO-UNDO GET. SET.
    DEFINE PRIVATE PROPERTY oErrorObject        AS JsonArray                                            NO-UNDO GET. SET.
    DEFINE PRIVATE PROPERTY cCurrentField       AS CHARACTER                                            NO-UNDO GET. SET.
    DEFINE PRIVATE PROPERTY oParameters         AS BaseParameter                                        NO-UNDO GET. SET.
    
    DEFINE PUBLIC PROPERTY hasErrors            AS LOGICAL INITIAL FALSE                                NO-UNDO GET. SET.
    
    /**
    @constructor
    **/
    CONSTRUCTOR PUBLIC FormValidator():
        THIS-OBJECT:oErrorObject        = NEW JsonArray().
        THIS-OBJECT:oFieldRulesObject   = NEW JsonObject().
    END CONSTRUCTOR.
    
    /**
    @purpose - sets error beggining
    @return void
    @input CHARACTER
    **/
    METHOD PUBLIC VOID setErrorCodeBegining(cErrorCodeBegining AS CHARACTER):
        THIS-OBJECT:cErrorCodeBegining = cErrorCodeBegining.
    END METHOD.
    
    /**
    @purpose - iterates throuth fields and calls to validate them
    @input
    @return VOID
    **/
    METHOD PUBLIC VOID processValidation():
        DEFINE VARIABLE i AS INTEGER NO-UNDO.
        DEFINE VARIABLE cValidatableFields AS CHARACTER EXTENT NO-UNDO.
        
        cValidatableFields = THIS-OBJECT:oFieldRulesObject:GetNames().
        DO i=1 TO EXTENT (cValidatableFields):
            THIS-OBJECT:validateRules(cValidatableFields[i], THIS-OBJECT:oFieldRulesObject:GetJsonArray(cValidatableFields[i])).
        END.
    END METHOD.
    
    /**
    @purpose - process field validation by provided rules array
    @input CHARACTER,JsonArray
    @return VOID
    **/
    METHOD PRIVATE VOID validateRules(cFieldName AS CHARACTER, oRulesArray AS JsonArray):
        DEFINE VARIABLE cRuleName AS CHARACTER NO-UNDO.
        DEFINE VARIABLE i AS INTEGER NO-UNDO.
        DEFINE VARIABLE cFieldValue AS CHARACTER NO-UNDO.
        
        cFieldValue = DYNAMIC-PROPERTY(THIS-OBJECT:oParameters, cFieldName).
        
        DO i=1 TO oRulesArray:LENGTH:
            CASE oRulesArray:GetCharacter(i):
                WHEN "required" THEN DO:
                    THIS-OBJECT:validateRequired(cFieldName, cFieldValue).
                END.
                WHEN "integer" THEN DO:
                    
                END.
                OTHERWISE 
                    UNDO, THROW NEW AppError("Failed to find rule").
            END CASE.
        END.
    END METHOD.
    
    /**
    @purpose - sets validation field name into object
    @input CHARACTER
    @return FormValidator
    **/
    METHOD FINAL PUBLIC FormValidator setField(cFieldName AS CHARACTER):
        DEFINE VARIABLE oRulesArray AS JsonArray NO-UNDO.
        
        THIS-OBJECT:cCurrentField = cFieldName.
        IF NOT THIS-OBJECT:oFieldRulesObject:Has(cFieldName) THEN DO:
            oRulesArray = NEW JsonArray().
            THIS-OBJECT:oFieldRulesObject:add(cFieldName, oRulesArray).
        END.
        
        RETURN THIS-OBJECT.
    END METHOD.
    
    /**
    @purpose - sets field with validation rules
    @input CHARACTER,JsonArray
    @return VOID
    **/
    METHOD PUBLIC VOID setFieldAndRulesArray(cFieldName AS CHARACTER, oRulesArray AS JsonArray):
        THIS-OBJECT:cCurrentField = cFieldName.
        IF NOT THIS-OBJECT:oFieldRulesObject:Has(cFieldName) THEN 
        DO:
            THIS-OBJECT:oFieldRulesObject:add(cFieldName, oRulesArray).
        END.
    END METHOD.
    
    /**
    @purpose - sets field validation rules
    @input CHARACTER
    @return FormValidator
    **/
    METHOD FINAL PUBLIC FormValidator setFieldRules(cRule AS CHARACTER):
        DEFINE VARIABLE oRulesArray AS JsonArray NO-UNDO.
        
        THIS-OBJECT:isExistRule(cRule).
        IF THIS-OBJECT:oFieldRulesObject:Has(THIS-OBJECT:cCurrentField) THEN DO:
            oRulesArray = THIS-OBJECT:oFieldRulesObject:GetJsonArray(THIS-OBJECT:cCurrentField).
            oRulesArray:Add(cRule).
        END.
        
        RETURN THIS-OBJECT.
    END METHOD.
    
    /**
    @purpose - gets error list
    @input
    @return JsonArray
    **/
    METHOD PUBLIC JsonArray getErrorList():
        RETURN THIS-OBJECT:oErrorObject.
    END METHOD.
    
    /**
    @purpose - sets object where exist our validating properties
    @input BaseParameter
    @return VOID
    **/
    METHOD PUBLIC VOID setParameterObject(oParameters AS BaseParameter):
        THIS-OBJECT:oParameters = oParameters.
    END METHOD.
    
    /**
    @purpose - check if user selected rule exists
    @input CHARACTER
    @return VOID
    **/
    METHOD PRIVATE VOID isExistRule(cRule AS CHARACTER):
        IF INDEX(THIS-OBJECT:RULES_LIST, cRule) = 0 THEN DO:
            UNDO, THROW NEW AppError("Failed to find rule").
        END.
    END METHOD.
    
    /**
    @purpose - checks if validating field is not empty
    @input CHARACTER,CHARACTER
    @return VOID
    **/
    METHOD PRIVATE VOID validateRequired(cFieldName AS CHARACTER, cFieldValue AS CHARACTER):
        IF cFieldValue = "" OR cFieldValue = ? THEN DO:
            THIS-OBJECT:setError(SUBSTITUTE("&1&2&3", THIS-OBJECT:cErrorCodeBegining, cFieldName, ".required")).
        END.
    END METHOD.
    
    /**
    @purpose - to sett error message to error array and set flag to true
    @input CHARACTER
    @return VOID
    **/
    METHOD PRIVATE VOID setError(cErrorMessage AS CHARACTER):
        THIS-OBJECT:oErrorObject:add(cErrorMessage).
        THIS-OBJECT:hasErrors = TRUE.
    END METHOD.
END CLASS.