/*********************************************************************************
Name         : Test_SetAgeContactTask
Project      : CAS
Created By   : Everis
Created Date : 05/08/2020
Description  : Test class for class SetAgeContactTask
User Story   : ---
History                                                            
-------                                                            
VERSION  AUTHOR         DATE            Description
1.0      Everis       	05/08/2020      initial version 
********************************************************************************/
@isTest
public class SetAgeContactTask_Test {
    
    /********************************************************************************
    Author: Everis
    Company: Everis
    Description: Test Method for Batch Method
    
    AUTHOR          DATE            	Description
    everis        05/08/2020         Versión inicial
    ********************************************************************************/
    @isTest
    static void test() {
        Account acc = new Account();
        acc.Name = 'Mora';        
        insert acc;
        Contact con1 = new Contact();
        con1.FirstName = 'Juan';
        con1.LastName = 'Perez';
        con1.AccountId = acc.Id;
        insert con1;
        List<Contact> contList = new List<Contact>();
        contList.add(con1);
        
        Test.startTest();
        SetAgeContactTask setAgeBatch = new SetAgeContactTask();
        Database.executeBatch(setAgeBatch);
        setAgeBatch.execute(null, contList);
        
        Contact[] contList2 = [SELECT Id,Name FROM Contact];
        System.assert(contList2[0].Name.Contains('Juan'));        
        Test.stopTest();
        
    }
    
    @isTest
    static void test_1(){
                SetAgeContactSchedule schedule = new SetAgeContactSchedule();
                schedule.execute(null);
    }
    
}