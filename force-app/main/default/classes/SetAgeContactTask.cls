/*********************************************************************************
Name         : SetAgeContactTask
Project      : CAS
Created By   : Everis
Created Date : 05/08/2020
Description  : Schedule SetAgeContactTask
User Story   : ---
History                                                            
-------                                                            
VERSION  AUTHOR         DATE            Description 
1.0      Everis       	05/08/2020      initial version 
********************************************************************************/
global class SetAgeContactTask implements Database.Batchable<sObject>, Database.Stateful ,Database.AllowsCallouts{
    
    /********************************************************************************
Author: Everis
Company: Everis
Description: Metodo inicial del batch con el cual se obtiene los contactos que cumplen año hoy
Returns: query(resultado de la query)
History ---

AUTHOR          DATE            	Description
everis        05/08/2020         Versión inicial
********************************************************************************/ 
    global Database.QueryLocator start(Database.BatchableContext bc) {
        String query = 'SELECT Birthdate, Id, Name, Description, fax FROM Contact WHERE edad__c = 18 and Birthdate = TODAY';
        return Database.getQueryLocator(query);
    }
    
    /********************************************************************************
Author: Everis
Company: Everis
Description: Metodo de ejecucion el cual hace la llamada SetAgeContact para el calculo de la edad
History ---

AUTHOR          DATE            	Description
everis        05/08/2020         Versión inicial
********************************************************************************/ 
    global void execute(Database.BatchableContext bc, List<Contact> scope){
        SetAgeContactController setAge = new SetAgeContactController();
        setAge.setAge(scope);
    }  
    /********************************************************************************
Author: Everis
Company: Everis
Description: Metodo de finalizacion del batch
Returns: -)
History ---

AUTHOR          DATE            	Description
everis        05/08/2020         Versión inicial
********************************************************************************/ 
    
    global void finish(Database.BatchableContext bc) {
        
    }    
    
    
    
    
    
}