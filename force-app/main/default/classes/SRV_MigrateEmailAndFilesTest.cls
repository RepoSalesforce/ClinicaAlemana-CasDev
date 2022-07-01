@isTest
public class SRV_MigrateEmailAndFilesTest {
	@testSetup
    private static void testSetup() {
        user u = [select Email from User where Id =: UserInfo.getUserId()];
        //create contact
        Account acc = new Account();
        acc = UtilitiesTestClass.createAccount('rodriguez', '45', '1', '32');
        insert acc;
        //create cases
        List<Case> caseToInsert = new List<Case>();
        Case caso1 = UtilitiesTestClass.createCaseGeneral('New',acc.PersonContactId);
        caseToInsert.add(caso1);
        Case caso2 = UtilitiesTestClass.createCaseGeneral('New',acc.PersonContactId);
        caso2.subject = 'Test Case2';
        caseToInsert.add(caso2);
        Insert caseToInsert;
        //create email
        emailmessage em = UtilitiesTestClass.createEmailmessage(caso1.id,u.email);
        insert em;
        //create Files
        List<ContentVersion> filesToInsert = new List<ContentVersion>();
        ContentVersion cv1 = UtilitiesTestClass.createContentVersion(caso1.id);
        filesToInsert.add(cv1);
        ContentVersion cv2 = UtilitiesTestClass.createContentVersion(em.id);
        filesToInsert.add(cv2);
        insert filesToInsert;
    }
    private static testMethod void testFilesAndEmailMigration(){

        List<SRV_MigrateEmailAndFiles.migrateResquest> requestList = new List<SRV_MigrateEmailAndFiles.migrateResquest>();
        SRV_MigrateEmailAndFiles.migrateResquest mr = new SRV_MigrateEmailAndFiles.migrateResquest();
        mr.OriginCaseID = [Select id from case where subject = 'Test Case'].id;
        mr.TargetCaseID = [Select id from case where subject = 'Test Case2'].id;
        requestList.add(mr);
        SRV_MigrateEmailAndFiles.MigrateEmailMessageAndFiles(requestList);
        List<ContentDocumentLink> results = [SELECT id FROM ContentDocumentLink where LinkedEntityId =: mr.TargetCaseID];
        system.assertEquals(2, results.size(), 'No se crearon la cantidad correcta de Documentos en el nuevo caso');

    }
}