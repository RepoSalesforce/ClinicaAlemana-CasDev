@isTest
public class SRV_CalculateBusinessDate_Test {
	@testSetup
    private static void testSetup() {
        //create contact
        Account acc = new Account();  
        acc = UtilitiesTestClass.createAccount('rodriguez', '45', '1', '32');
        insert acc;
        //create case
        Case caso = UtilitiesTestClass.createCaseGeneral('New',acc.PersonContactId);
        caso.subject = 'Test Date';
        insert caso;
    }
    private static testMethod void calculateDateTimeTest(){
        List<Case> casito = [SELECT Id, SRV_Conforme__c FROM Case WHERE subject = 'Test Date'];
        List<SRV_CalculateBusinessDate.Results> res = new List<SRV_CalculateBusinessDate.Results>();
        // Create Datetime on Feb 1, 2021 at 9:00:00 AM in the local timezone.
        Datetime startTime = Datetime.newInstance(2021, 2, 1, 9, 0, 0);
        system.debug(startTime);
        SRV_CalculateBusinessDate.dateRequest dr = new SRV_CalculateBusinessDate.dateRequest();
        dr.CaseID = casito[0].id;
        dr.Hours = '5';
        dr.StartDate = startTime;
        List<SRV_CalculateBusinessDate.dateRequest> drList = new List<SRV_CalculateBusinessDate.dateRequest>();
        drList.add(dr);
        test.startTest();
        res = SRV_CalculateBusinessDate.calculateDateTime(drList);
        test.stopTest();
        datetime resCompare = startTime.addHours(5);
        system.debug(res);
        system.assertEquals(resCompare, res[0].resultDate);
    } 

}