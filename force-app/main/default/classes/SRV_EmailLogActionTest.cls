@isTest
public class SRV_EmailLogActionTest {
    @testSetup
    private static void testSetup() {
        //create contact
        Account acc = new Account();
        acc = UtilitiesTestClass.createAccount('rodriguez', '45', '1', '32');
        insert acc;
        //create case
        Case caso = UtilitiesTestClass.createCaseGeneral('New',acc.PersonContactId);
        insert caso;      
    }
    private static testMethod void RegistroDeEmail(){
        
        List<SRV_EmailLogAction.sendEmailRequest> requestList = new List<SRV_EmailLogAction.sendEmailRequest>();
        SRV_EmailLogAction.sendEmailRequest soleRequest = new SRV_EmailLogAction.sendEmailRequest();
        soleRequest.CaseID = [SELECT Id FROM Case WHERE subject = 'Test Case'].Id;
        soleRequest.FromAddress = [select Email from User where Id =: UserInfo.getUserId()].email;
        soleRequest.FromName = 'Juanito Perez';
        soleRequest.TemplateUniqueName = 'SUPPORTWebtoCaseemailresponseSAMPLE';
        soleRequest.ToAddress = 'Test_test@testing.test';
        requestList.add(soleRequest);
        SRV_EmailLogAction.createEmailMessageLog(requestList);
        List<emailMessage> TestMess = [Select Id from emailMessage where FromName ='Juanito Perez'];
        system.assertEquals(1, testMess.size(), 'no se creo el emailMessage');

    }
}