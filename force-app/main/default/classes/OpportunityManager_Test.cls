@isTest
public class OpportunityManager_Test {

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
        OppToCreate.Nombre_Medico__c = Med.id;
        insert OppToCreate;
        
        
    }
    private static testMethod void InsertOppWithFiles(){
        
        OpportunityManager.RESPONSE res = new OpportunityManager.RESPONSE();
        List<Opportunity> resOpp = new List<Opportunity>();
        Opportunity opp = UtilitiesTestClass.createOpportunity(null, null, '99999');
        opp.Name = 'Test99999';
        opp.Canal_Origen__c = 'ALGO';
        system.debug('OPP-->'+opp);
        OpportunityManager.REQUEST request = CreateRequest(opp, 'PPN001');
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/V1/Opportunity/';  //Request URL
        req.httpMethod = 'POST'; //HTTP Request Type
        String json = JSON.serialize(request);
        req.requestBody = Blob.valueof(json);
        RestContext.request = req;
        
        Test.startTest();
        res = OpportunityManager.upsertOppWithFiles();
        system.debug('RESULT '+ res);
        Test.StopTest();
        
        //Validaciones
        resOpp = [SELECT ID, Numero_de_Identificacion__c, account.PPN__c  FROM OPPORTUNITY WHERE Name = 'Test99999'];
        system.debug('OPP'+resOpp);
        //Correct insert of 1 Opp
        System.assertEquals(1, resOpp.size());
        //Correct account associated 
        System.assertEquals('PPN001', resOpp[0].account.PPN__c);
        //Estado OK 
        System.assertEquals('0', res.ESTADO.CODIGO);

    }
    
    private static testMethod void UpdateOppWithFiles(){
        
        OpportunityManager.RESPONSE res = new OpportunityManager.RESPONSE();
        List<Opportunity> resOpp = new List<Opportunity>();
        
        Opportunity opp = [SELECT id, name,CloseDate FROM Opportunity WHERE name = 'test456789'];
        opp.Name = 'Test888';
        opp.Score__c = 100;
        system.debug('OPP-->'+opp);
        OpportunityManager.REQUEST request = CreateRequest(opp, 'PPN001');
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/V1/Opportunity/';  //Request URL
        req.httpMethod = 'POST'; //HTTP Request Type
        String json = JSON.serialize(request);
        req.requestBody = Blob.valueof(json);
        RestContext.request = req;
        
        Test.startTest();
        res = OpportunityManager.upsertOppWithFiles();
        system.debug('RESULT '+ res);
        Test.StopTest();
        
        //Validaciones
        resOpp = [SELECT ID, Numero_de_Identificacion__c,Score__c  FROM OPPORTUNITY WHERE id =: opp.id];
        //Correct insert of 1 Opp
        System.assertEquals(1, resOpp.size());
        //Correct account associated 
        System.assertEquals(100, resOpp[0].Score__c);
        //Estado OK 
        System.assertEquals('0', res.ESTADO.CODIGO);
        
    }
    
    
    private static testMethod void UpdateInsertOppNull(){
        System.debug('TEST START ------------------> UpdateInsertOppNull');
        OpportunityManager.RESPONSE res = new OpportunityManager.RESPONSE();
        List<Opportunity> resOpp = new List<Opportunity>();
        OpportunityManager.REQUEST request = CreateRequest(null, 'PPN001');
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/V1/Opportunity/';  //Request URL
        req.httpMethod = 'POST'; //HTTP Request Type
        String json = JSON.serialize(request);
        req.requestBody = Blob.valueof(json);
        RestContext.request = req;
        
        Test.startTest();
        res = OpportunityManager.upsertOppWithFiles();
        system.debug('RESULT '+ res);
        Test.StopTest();
        
        //Validaciones
        System.assertEquals('-2', res.ESTADO.CODIGO);
        System.assertEquals('No Opportunity in JSON', res.ESTADO.MENSAJE);
    }
    
    private static testMethod void UpdateInsertOppIdInvalid(){
        
        OpportunityManager.RESPONSE res = new OpportunityManager.RESPONSE();
        List<Opportunity> resOpp = new List<Opportunity>();
        
        Opportunity opp = [SELECT id, name,CloseDate FROM Opportunity WHERE name = 'test456789'];
        opp.Name = 'Test888';
        opp.Id = '0065500000Gyx6dAAA';
        system.debug('OPP-->'+opp);
        OpportunityManager.REQUEST request = CreateRequest(opp, 'PPN001');
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/V1/Opportunity/';  //Request URL
        req.httpMethod = 'POST'; //HTTP Request Type
        String json = JSON.serialize(request);
        req.requestBody = Blob.valueof(json);
        RestContext.request = req;
        
        Test.startTest();
        res = OpportunityManager.upsertOppWithFiles();
        system.debug('RESULT '+ res);
        Test.StopTest();
        
        //Validaciones
        System.assertEquals('-2', res.ESTADO.CODIGO);
        System.assertEquals('Opportunity ID Not Found', res.ESTADO.MENSAJE);
        
    }
    private static testMethod void InsertRequiredFields(){
        
        OpportunityManager.RESPONSE res = new OpportunityManager.RESPONSE();
        List<Opportunity> resOpp = new List<Opportunity>();
        Opportunity opp = UtilitiesTestClass.createOpportunity(null, null, '99999');
        opp.Name = null;
        opp.CloseDate = null;
        system.debug('OPP-->'+opp);
        OpportunityManager.REQUEST request = CreateRequest(opp, 'PPN001');
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/V1/Opportunity/';  //Request URL
        req.httpMethod = 'POST'; //HTTP Request Type
        String json = JSON.serialize(request);
        req.requestBody = Blob.valueof(json);
        RestContext.request = req;
        
        Test.startTest();
        res = OpportunityManager.upsertOppWithFiles();
        system.debug('RESULT '+ res);
        Test.StopTest();
        
        //Validaciones
        System.assertEquals('-2', res.ESTADO.CODIGO);
        System.assertEquals('Opportunity required field missing (Name, StageName, CloseDate)', res.ESTADO.MENSAJE);
    }
    private static testMethod void InsertAccPPNInvalid(){
        
        OpportunityManager.RESPONSE res = new OpportunityManager.RESPONSE();
        List<Opportunity> resOpp = new List<Opportunity>();
        
        Opportunity opp = UtilitiesTestClass.createOpportunity(null, null, '99999');
        opp.Name = 'Test99999';
        opp.Canal_Origen__c = 'ALGO';
        system.debug('OPP-->'+opp);
        OpportunityManager.REQUEST request = CreateRequest(opp, 'PPN001BAD');
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/V1/Opportunity/';  //Request URL
        req.httpMethod = 'POST'; //HTTP Request Type
        String json = JSON.serialize(request);
        req.requestBody = Blob.valueof(json);
        RestContext.request = req;
        
        Test.startTest();
        res = OpportunityManager.upsertOppWithFiles();
        system.debug('RESULT '+ res);
        Test.StopTest();
        
        //Validaciones
        System.assertEquals('-2', res.ESTADO.CODIGO);
        System.assertEquals('PPN Client Not Found', res.ESTADO.MENSAJE);
        
    }
    
    private static OpportunityManager.REQUEST CreateRequest(Opportunity Opp, String Acc){
        
        OpportunityManager.REQUEST res = new OpportunityManager.REQUEST();
        List<OpportunityManager.File> fileList = new List<OpportunityManager.File>();
        OpportunityManager.File f1 = new OpportunityManager.File();
        f1.NOMBREARCHIVO = 'TESTFILE1';
        f1.DATA = 'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z/C/HgAGgwJ/lK3Q6wAAAABJRU5ErkJggg==';
        fileList.add(f1);
        OpportunityManager.File f2 = new OpportunityManager.File();
        f2.NOMBREARCHIVO = 'TESTFILE2';
        f2.DATA = 'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z/C/HgAGgwJ/lK3Q6wAAAABJRU5ErkJggg==';
        fileList.add(f2);
        OpportunityManager.File f3 = new OpportunityManager.File();
        f3.NOMBREARCHIVO = 'TESTFILE3';
        f3.DATA = 'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z/C/HgAGgwJ/lK3Q6wAAAABJRU5ErkJggg==';
		fileList.add(f3);
        res.FILES = fileList;
        res.FECHAENVIO = '2020-06-15 05:05:05';
        res.IDENVIO = 182;
        res.PPN_HASHEADO_PACIENTE = Acc;
        res.OPPORTUNITY = Opp;       
        return res;
    }
    
}