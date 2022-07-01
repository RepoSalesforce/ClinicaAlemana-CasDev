@IsTest
private class CaseManagerTest {

    @isTest static void testGetCaseById() {
        Case recordCase = createTestRecord();
         //System.debug('RECORD ID '+recordCase.Id); 5006s000006i7hSAAQ
        // Set up a test request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestUri = '/services/apexrest/Cases/';
        req.params.put('caseId', recordCase.Id);
        //req.params.put('validationCode', recordCase.Codigo_Verificacion__c);
        req.params.put('email', recordCase.SuppliedEmail);
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response= res;
        
        Test.startTest();
        	CaseManager.getCaseById();
        	res = RestContext.response;
            System.debug('STATUS '+res.statusCode); 
            System.assertEquals(200, res.statusCode);
            //System.debug(actual); 
        Test.StopTest();
        
    }

   @isTest
    static void testGetCaseByIdNotFound() {
        CaseManager.Request rqst = createCaseRequestForTesting();
       //aseManager.RESPONSE respuesta = new CaseManager.RESPONSE();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/V1/Cases/'; //Request URL
        req.params.put('email', 'test@test.cl');
        req.httpMethod = 'GET'; //HTTP Request Type
        String json = JSON.serialize(rqst);
        req.requestBody = Blob.valueof(json);
        RestContext.request = req;
        RestContext.response= res;

       Test.startTest();
        res = RestContext.response;
        CaseManager.getCaseById();
        System.assertEquals(404, res.statusCode);
       Test.StopTest();
    }

    @isTest
    static void testCreateCaseWithFiles() {
        CaseManager.Request rqst = createCaseRequestForTesting();
        //CaseManager.RESPONSE respuesta = new CaseManager.RESPONSE();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/V1/Cases/'; //Request URL
        req.httpMethod = 'POST'; //HTTP Request Type
        String json = JSON.serialize(rqst);
        req.requestBody = Blob.valueof(json);
        RestContext.request = req;
        RestContext.response = res;
        //res = RestContext.response;
        Test.startTest();
            CaseManager.createCaseWithFiles();            
            System.assertEquals(200,  res.statusCode);
        Test.StopTest();
    }

    // Helper method
    static Case createTestRecord() {
        // Create test record
        Case caseTest = new Case(
            Subject = 'Resonancia Magnética',
            Status = 'New',
            Origin = 'Phone',
            Priority = 'Medium',
            //queCodigo_Verificacion__c ='cf691',
            SuppliedEmail = 'test@alemana.cl',
        
            SRV_Web_Tipo_de_documento__c = '1',
            SRV_Web_Numero_de_documento__c = '15838376-4',
            SuppliedName = 'Nombre',
            SuppliedPhone = '98888888',
            PCI_Codigo_Pais_Telefono__c = 'Chile +56',
            SRV_Web_Fecha_de_nacimiento__c = Date.parse('05-04-1986'),
            PCI_Sexo__c = 'F');
        
        insert caseTest;
        return caseTest;
    }

    /* RESPONSE WRAPPER START*/
    /*public class responseTest {
        public Id id;
        public String SuppliedEmail;
        public String CodigoVerificacion;
    }

    public class state {
        public String CODIGO;
        public String MENSAJE;
    }
    public class ResFile {
        public String NOMBREARCHIVO;
    }*/

    /* RESPONSE WRAPPER END*/
   static CaseManager.Request createCaseRequestForTesting() {
        Case reqCase = new Case();
        CaseManager.REQUEST reque = new CaseManager.REQUEST();
         //createdCase = [SELECT Id, Status, Origin, Priority, SRV_Web_Numero_de_documento__c, Subject, SuppliedEmail, Codigo_Verificacion__c, CaseNumber FROM Case WHERE Id = :newCase.ID];                                
        reqCase.Subject = 'Resonancia Magnética';
        reqCase.Status = 'New';
        reqCase.Origin = 'Web';
        reqCase.Priority = 'Medium';
        reqCase.SuppliedEmail = 'campi@gmail.com';       
        reqCase.SRV_Web_Tipo_de_documento__c = '1';
        reqCase.SRV_Web_Numero_de_documento__c = '15838376-4';
        reqCase.SuppliedName = 'Nombre';
        reqCase.SuppliedPhone = '98888888';
        reqCase.PCI_Codigo_Pais_Telefono__c = 'Chile +56';
        reqCase.SRV_Web_Fecha_de_nacimiento__c = Date.parse('05-04-1986');
        reqCase.PCI_Sexo__c = 'F';

        List < CaseManager.File > caseFiles = new List < CaseManager.File > ();
        CaseManager.File caseFile = new CaseManager.File();

        caseFile.NOMBREARCHIVO = 'ArchivoCaso.jpg';
        caseFile.DATA = 'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z/C/HgAGgwJ/lK3Q6wAAAABJRU5ErkJggg==';

        caseFiles.add(caseFile);
        reque.Caso = reqCase;
        reque.FILES = caseFiles;
        //insert reqCase;
        return reque;
    } 
    
}