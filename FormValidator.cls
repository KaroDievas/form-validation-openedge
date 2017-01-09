 
 /*------------------------------------------------------------------------
    File        : FormValidator
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : dkurapkis
    Created     : Mon Jan 09 20:04:15 EET 2017
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS FormValidator INHERITS BaseValidator: 
    
    
    
    CONSTRUCTOR PUBLIC FormValidator():
        SUPER().
        
    END CONSTRUCTOR.
    
    
    
END CLASS.