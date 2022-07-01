@isTest
public class QuoteManager_Test {

    @testSetup
    private static void testSetup() {
        //create User  (id profId, String alias)
        
        
        //Create Acc String lastName, String ppn, String typeIdent, String numIdent
        Account AccToCreate = UtilitiesTestClass.createAccount('TESTACCOUNT001','PPN001','1','123123');
        insert AccToCreate;
        
        //Create Medico (String ppn, String numIdent, String typeIdent)
        Medico__c Med = UtilitiesTestClass.createMedico('MEDICO001','12345','1');
        insert Med;
        //Create Opp (id medicoId, id accId, String numIdent)
        Opportunity OppToCreate = UtilitiesTestClass.createOpportunity(Med.id, AccToCreate.id, '456789');
        insert OppToCreate;
        
        
    }
    private static testMethod void createQuoteTest(){
        QuoteManager.RESPONSE res = new QuoteManager.RESPONSE();
        List<opportunity> oppList = [SELECT ID,closedate FROM Opportunity];
        List<ContentVersion> resFileList = new List<ContentVersion>();
        List<quote> resQuote = new List<quote>();
        system.debug('OPP'+oppList);
        //Create Quote for insert (id contId, String presCasId, id oppId, id sucId)
        Quote q = UtilitiesTestClass.createQuote(null, 'QUOTE001', oppList[0].id, null);
        QuoteManager.REQUEST request = CreateRequest(oppList[0], q);
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/V1/Quote/';  //Request URL
        req.httpMethod = 'POST'; //HTTP Request Type
        String json = JSON.serialize(request);
        req.requestBody = Blob.valueof(json);
        RestContext.request = req;
        
        Test.startTest();
        res = QuoteManager.createQuoteWithFiles();
        Test.StopTest();
        
        //Validaciones
        resFileList = [SELECT id FROM ContentVersion Where FirstPublishLocationId =: res.PRESUPUESTO.id];
        resQuote = [SELECT ID FROM QUOTE WHERE OpportunityId =: res.OPPORTUNITY.id];
        //Correct insert of 3 files
        System.assertEquals(3, resFileList.size());
        //Correct insert of 1 Quote to the Opp
        System.assertEquals(1, resQuote.size());
        System.assertEquals('OK', res.ESTADO.CODIGO);

        
    }
    private static testMethod void createQuoteTestFailNoOpp(){
        QuoteManager.RESPONSE res = new QuoteManager.RESPONSE();
        opportunity Opp = new Opportunity();
        Quote q = new Quote();
        QuoteManager.REQUEST request = CreateRequest(Opp, q);
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/V1/Quote/';  //Request URL
        req.httpMethod = 'POST'; //HTTP Request Type
        String json = JSON.serialize(request);
        req.requestBody = Blob.valueof(json);
        RestContext.request = req;
        Test.startTest();
        res = QuoteManager.createQuoteWithFiles();
        Test.StopTest();
        System.assertEquals('NOOK', res.ESTADO.CODIGO);        
        
    }
    private static testMethod void createQuoteTestFailBadOpp(){
        QuoteManager.RESPONSE res = new QuoteManager.RESPONSE();
        opportunity Opp = new Opportunity();
        Opp.id = '0062C000006xIBpQAM';
        Quote q = new Quote();
        QuoteManager.REQUEST request = CreateRequest(Opp, q);
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/V1/Quote/';  //Request URL
        req.httpMethod = 'POST'; //HTTP Request Type
        String json = JSON.serialize(request);
        req.requestBody = Blob.valueof(json);
        RestContext.request = req;
        Test.startTest();
        res = QuoteManager.createQuoteWithFiles();
        Test.StopTest();
        System.assertEquals('NOOK', res.ESTADO.CODIGO);        
        
    }
    private static testMethod void createQuoteTestDefaultMedic(){
        
        List<Opportunity> resOppList = new List<Opportunity>();
        QuoteManager.RESPONSE res = new QuoteManager.RESPONSE();
        List<opportunity> oppList = [SELECT ID,closedate FROM Opportunity];
        List<ContentVersion> resFileList = new List<ContentVersion>();
        List<quote> resQuote = new List<quote>();
        system.debug('OPP'+oppList);
        //Create Quote for insert (id contId, String presCasId, id oppId, id sucId)
        Quote q = UtilitiesTestClass.createQuote(null, 'QUOTE001', oppList[0].id, null);
        QuoteManager.REQUEST request = CreateRequest(oppList[0], q);
        request.PPN_MEDICO = '';
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/V1/Quote/';  //Request URL
        req.httpMethod = 'POST'; //HTTP Request Type
        String json = JSON.serialize(request);
        req.requestBody = Blob.valueof(json);
        RestContext.request = req;
        
        Test.startTest();
        res = QuoteManager.createQuoteWithFiles();
        Test.StopTest();
        
        //Validaciones
        //resOppList = [SELECT ID, Nombre_Medico__c FROM OPP WHERE ID =: res.OPPORTUNITY.id];
        //Correct insert of Default Medic
        //System.assertEquals(1, resQuote.size());
    }
    
    
    private static QuoteManager.REQUEST CreateRequest(Opportunity Opp, Quote q){
        
        QuoteManager.REQUEST res = new QuoteManager.REQUEST();
        List<QuoteManager.File> fileList = new List<QuoteManager.File>();
        QuoteManager.File f1 = new QuoteManager.File();
        f1.NOMBREARCHIVO = 'TESTFILE1';
        f1.DATA = 'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z/C/HgAGgwJ/lK3Q6wAAAABJRU5ErkJggg==';
        fileList.add(f1);
        QuoteManager.File f2 = new QuoteManager.File();
        f2.NOMBREARCHIVO = 'TESTFILE2';
        f2.DATA = 'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z/C/HgAGgwJ/lK3Q6wAAAABJRU5ErkJggg==';
        fileList.add(f2);
        QuoteManager.File f3 = new QuoteManager.File();
        f3.NOMBREARCHIVO = 'TESTFILE3';
        f3.DATA = 'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z/C/HgAGgwJ/lK3Q6wAAAABJRU5ErkJggg==';
        fileList.add(f3);
        res.FILES = fileList;
        res.FECHAENVIO = '2020-06-15 05:05:05';
        res.IDENVIO = 182;
        res.PPN_MEDICO = 'MEDICO001'; // llenar cuando haya metodo medico
        res.OPPORTUNITY = Opp;
        res.PRESUPUESTO = q;        
        return res;
    }
    
}