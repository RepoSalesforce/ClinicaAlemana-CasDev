@isTest
public class SRV_RunCaseAssignmentRuleTest {    
    @testSetup
    static void loadData(){
        //create contact
        Account acc = new Account();  
        acc = UtilitiesTestClass.createAccount('rodriguez', '45', '1', '32');
        insert acc;
        //create case
        Case caso = UtilitiesTestClass.createCaseGeneral('New',acc.PersonContactId);
        caso.subject = 'Test Assign';
        insert caso;
    }
    
    @isTest
    static void assignCasesTest(){
        //instantiate List to pass to @InvocableMethod
        List<Id> ids = new List<Id>();
        
        //query for test data and add to List
        Case casito = [SELECT Id, OwnerId FROM Case WHERE subject = 'Test Assign'];
        ids.add(casito.Id);
        
        //call @InvocableMethod
        test.startTest();
        SRV_RunCaseAssignmentRule.assignCases(ids);
        test.stopTest();
        
        //verify that Lead was re-assigned
        Case res = [SELECT Id, OwnerId FROM Case WHERE subject = 'Test Assign'];
        System.assert(casito.OwnerId != res.OwnerId, res);
    }
}