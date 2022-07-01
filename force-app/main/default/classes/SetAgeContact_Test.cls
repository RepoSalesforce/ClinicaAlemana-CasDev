/*********************************************************************************
Name         : Test_SetAgeContact
Project      : CAS
Created By   : Everis
Created Date : 05/08/2020
Description  : Test class for class SetAgeContactController
User Story   : ---
History                                                            
-------                                                            
VERSION  AUTHOR         DATE            Description
1.0      Everis       	05/08/2020      initial version 
********************************************************************************/
@isTest
public class SetAgeContact_Test {

    /********************************************************************************
    Author: Everis
    Company: Everis
    Description: Test Method for SetAgeTest Method
    
    AUTHOR          DATE            	Description
    everis        05/08/2020         Versión inicial
    ********************************************************************************/
    @isTest 
    public static void SetAgeTest(){
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
        SetAgeContactController ageCont = new SetAgeContactController();
        ageCont.SetAge(contList);
        
        Contact[] contList2 = [SELECT Id,Name FROM Contact];
        System.assert(contList2[0].Name.Contains('Juan'));
        Test.stopTest();
    }
}