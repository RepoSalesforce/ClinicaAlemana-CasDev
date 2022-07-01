@isTest
private class OpportunityTriggerHelper_Test {

    @testSetup
    static void setup(){
        Account acc1 = new Account();
        acc1 = UtilitiesTestClass.createAccount('Jadue', 'PPN', '1', '12897546-9');
        insert acc1;
           
        Medico__c med = new Medico__c();
        med = UtilitiesTestClass.createMedico('House', '17584968-8', '1');
        insert med;
        
        Opportunity opp1 = new Opportunity();
        opp1 = UtilitiesTestClass.createOpportunity(med.id, acc1.id, '19856547-9');
        insert opp1;

        Quote quo1 = new Quote();
        quo1 = UtilitiesTestClass.createQuote(acc1.PersonContactId , 'IDTEXTA666', opp1.Id, null);
        insert quo1;

        String b64 = 'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z/C/HgAGgwJ/lK3Q6wAAAABJRU5ErkJggg==';
        ContentVersion contVer1 = new ContentVersion();
        contVer1.Title = 'Test_1.png';
        contVer1.FirstPublishLocationId = opp1.Id; 
        contVer1.PathOnClient = 'Test_1.png';
        contVer1.VersionData = EncodingUtil.base64Decode(b64);
        contVer1.ContentLocation = 'S';
        contVer1.TagCsv = 'ApexCreated';
        insert contVer1;

        ContentVersion contVer2 = new ContentVersion();
        contVer2.Title = 'Test_2.png';
        contVer2.FirstPublishLocationId = quo1.Id; 
        contVer2.PathOnClient = 'Test_2.png';
        contVer2.VersionData = EncodingUtil.base64Decode(b64);
        contVer2.ContentLocation = 'S';
        contVer2.TagCsv = 'ApexCreated';
        insert contVer2;
    }

    @isTest
    static void syncQuoteToOpportunity(){
        List<Account> acc = [SELECT Id, LastName FROM Account WHERE LastName = 'Jadue' LIMIT 1];
		List<Opportunity> opp = [SELECT Id, Name, SyncedQuoteId FROM Opportunity WHERE AccountId =: acc[0].Id LIMIT 1];
        List<Quote> quo = [SELECT Id, Name, Nombre_Intervencion_1__c FROM Quote WHERE OpportunityId =: opp[0].Id LIMIT 1];

        Test.startTest();
        opp[0].SyncedQuoteId = quo[0].Id;
        update opp;
        Test.stopTest();

        List<Opportunity> oppResult = [SELECT Id, Name, Descripcion_Cirugia__c FROM Opportunity WHERE AccountId =: acc[0].Id LIMIT 1];
        System.assertEquals(quo[0].Nombre_Intervencion_1__c, oppResult[0].Descripcion_Cirugia__c);
    }

}