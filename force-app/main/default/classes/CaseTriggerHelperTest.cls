/**
 * @Develop By:       : Everis
 * @author            : zsuanaza@everis.com
 * @last modified on  : 09-02-2021
 * @last modified by  : zsuanaza@everis.com
**/
@isTest
public class CaseTriggerHelperTest {
    @testSetup
    private static void testSetup() {
        user u = [select Email from User where Id =: UserInfo.getUserId()];
        Account acc = new Account();
        acc = UtilitiesTestClass.createAccount('rodriguez', '45', '1', '32');
        insert acc;
        List<Case> caseToInsert = new List<Case>();
        Case caso1 = UtilitiesTestClass.createCaseGeneral('New',acc.PersonContactId);
        caso1.Subject = 'Caso Test Before Update';
        caseToInsert.add(caso1);
 
        Insert caseToInsert;
        Task tsk = new Task();
		tsk = UtilitiesTestClass.createTask(UserInfo.getUserId(), caso1.Id);
        insert tsk;
    }
    @isTest
    public static void onBeforeDeleteTest(){
        Account acc = new Account();
        acc.LastName = 'Test'; 
        insert acc;
        Case cass = UtilitiesTestClass.createStandardCase(acc.Id);
        Case cassB = UtilitiesTestClass.createStandardCase(acc.Id);
        Profile pro2 = [SELECT id, name from profile where name =: 'System Administrator' OR name =: 'Administrador del Sistema'];    
        User us2 = UtilitiesTestClass.createUser(pro2.Id,'test2');
        us2.Username = 'test00723@testt.cl';      
        insert us2;
        cass.OwnerId = us2.Id;   
        Test.startTest();
        insert cassB;
        insert cass;        
        System.assertEquals(cass.IsDeleted, false);        
        system.runAs(us2){
            delete cass;
        }    
        Case delCase = [SELECT Id, IsDeleted FROM Case WHERE Id=: cass.Id ALL ROWS];
        System.assertEquals(true, delCase.IsDeleted);      
        insert new ProfilesCantDelete__c(SetupOwnerId = pro2.ID);
        List<ProfilesCantDelete__c>profileLst = [SELECT id, SetupOwnerId, setupowner.name FROM ProfilesCantDelete__c];
        system.runAs(us2){
            try{
                delete cassB;
            }catch(Exception ex){
                system.assert(ex.getMessage().contains(Label.SRV_ErrorPermisosParaBorrar));
            }
            Case delCase2 = [SELECT Id, IsDeleted FROM Case WHERE Id=: cassB.Id ALL ROWS];
            System.assertEquals(false, delCase2.IsDeleted);    
        }
        Test.stopTest();
    }
    @isTest
    public static void onBeforeUpdateTest(){
        Case casoT = [SELECT id, status from Case where Subject = 'Caso Test Before Update'];
        casoT.Status = 'Closed';        
        Test.startTest();
        try{
            update casoT;            
        }catch(Exception ex){
            system.assert(ex.getMessage().contains(Label.SRV_ErrorCasoConTareasAbiertas));
        }
        Test.stopTest();        
    }
}