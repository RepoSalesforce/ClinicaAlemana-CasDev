/*********************************************************************************
    Name         : LeadManager_Test
    Work         : Integración Objeto de Leads
    Created By   : Everis
    Created Date : 27/08/2020
    Description  : Test class for class LeadManager
    VERSION  AUTHOR         DATE            Description
    1.0      Everis      28/08/2020       initial version /
**********************************************************************************/
@isTest
public class LeadManager_Test {
	/*********************************************************************************
    Name         : setup
    Work         : Integración Objeto de Leads
    Created By   : Everis
    Created Date : 28/08/2020
    Description  : setup test method
    VERSION  AUTHOR         DATE            Description
    1.0      Everis      28/08/2020       initial version /
	**********************************************************************************/
    @testSetup
    static void setup(){
              
        Lead le = new Lead();
        le = UtilitiesTestClass.createLead('12345','1', '17954869-8');
        insert le;
        
    }
    /*********************************************************************************
    Name         : createFileMethodUpsertTest
    Work         : Integración Objeto de Leads
    Created By   : Everis
    Created Date : 28/08/2020
    Description  : Test method for createFileMethod - Upsert Lead
    VERSION  AUTHOR         DATE            Description
    1.0      Everis      28/08/2020       initial version /
	**********************************************************************************/
    @isTest
    static void createFileMethodUpsertTest(){
        String b64 = 'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z/C/HgAGgwJ/lK3Q6wAAAABJRU5ErkJggg==';
        List<Lead> le = [SELECT id, FirstName, LastName, status, RecordTypeId FROM Lead WHERE FirstName ='Rosa' LIMIT 1];
        List<LeadManager.File> fileList = new List<LeadManager.File>();
        
        le[0].FirstName = 'Juana';
        update le;
        
        LeadManager.File file = new LeadManager.File();
        file.NOMBREARCHIVO = 'test.pdf';
        file.DATA = b64;
        fileList.add(file);
        
        LeadManager.Request request = new LeadManager.Request();
        request.FECHAENVIO = '2020-08-27 15:04:00';
		request.IDENVIO = 0;
        request.LEAD = le[0]; 
        request.FILE = fileList;      
        
        Test.startTest();
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/V1/Lead/';  	//Request URL
        req.httpMethod = 'POST'; 							//HTTP Request Type
        String json = JSON.serialize(request);
        req.requestBody = Blob.valueof(json);
        RestContext.request = req;
 
        LeadManager.Response salida = LeadManager.createLeadWithFiles();
        system.assertEquals('Juana', salida.LEAD.FirstName);
        Test.stopTest();
    }
    /*********************************************************************************
    Name         : createFileMethodInsertTest
    Work         : Integración Objeto de Leads
    Created By   : Everis
    Created Date : 28/08/2020
    Description  : Test method for createFileMethod - Insert Lead
    VERSION  AUTHOR         DATE            Description
    1.0      Everis      28/08/2020       initial version /
	**********************************************************************************/
    @isTest
    static void createFileMethodInsertTest(){
        String b64 = 'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z/C/HgAGgwJ/lK3Q6wAAAABJRU5ErkJggg==';
		List<LeadManager.File> fileList = new List<LeadManager.File>();
        List<Lead> le = [SELECT id, FirstName, LastName, status, RecordTypeId FROM Lead WHERE FirstName ='Rosa' LIMIT 1];
        
        Lead lea = new Lead();
        lea.FirstName = 'Tester';
        lea.LastName = 'V1';
        lea.Status = 'Nuevo';
        lea.Tipo_de_identificacion__c = 'ab';
        lea.Tipo_Parto__c = '123';
        lea.Seguro_Complementario__c = 'abcd123';
        lea.RecordTypeId = le[0].RecordTypeId;
        
        LeadManager.File file = new LeadManager.File();
        file.NOMBREARCHIVO = 'test.pdf';
        file.DATA = b64;
        fileList.add(file);
        
        LeadManager.Request request = new LeadManager.Request();
        request.FECHAENVIO = '2020-08-27 15:04:00';
		request.IDENVIO = 0;
        request.LEAD = lea; 
        request.FILE = fileList;      
        
        Test.startTest();
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/V1/Lead/';  	//Request URL
        req.httpMethod = 'POST'; 							//HTTP Request Type
        String json = JSON.serialize(request);
        req.requestBody = Blob.valueof(json);
        RestContext.request = req;
 
        LeadManager.Response salida = LeadManager.createLeadWithFiles();
        system.assertNotEquals(null, salida.LEAD.id);
        Test.stopTest();
    }
    /*********************************************************************************
    Name         : createFileMethodTestFailPicklist
    Work         : Integración Objeto de Leads
    Created By   : Everis
    Created Date : 28/08/2020
    Description  : Test method for createFileMethod - Fail
    VERSION  AUTHOR         DATE            Description
    1.0      Everis      28/08/2020       initial version /
	**********************************************************************************/
    @isTest
    static void createFileMethodTestFailPicklist(){
        String b64 = 'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z/C/HgAGgwJ/lK3Q6wAAAABJRU5ErkJggg==';
		List<LeadManager.File> fileList = new List<LeadManager.File>(); 
        List<Lead> le = [SELECT id, FirstName, LastName, status, RecordTypeId FROM Lead WHERE FirstName ='Rosa' LIMIT 1];
		le[0].Status = 'Test';
        update le;
        LeadManager.File file = new LeadManager.File();
        file.NOMBREARCHIVO = 'test.pdf';
        file.DATA = b64;
        fileList.add(file);
        
        LeadManager.Request request = new LeadManager.Request();
        request.FECHAENVIO = '2020-08-27 15:04:00';
		request.IDENVIO = 0;
        request.LEAD = le[0]; 
        request.FILE = fileList;      
        
        Test.startTest();
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/V1/Lead/';  	//Request URL
        req.httpMethod = 'POST'; 							//HTTP Request Type
        String json = JSON.serialize(request);
        req.requestBody = Blob.valueof(json);
        RestContext.request = req;
 
        LeadManager.Response salida = LeadManager.createLeadWithFiles();
        system.assertEquals(true, salida.ESTADO.MENSAJE.contains('Error, valor incorrecto'));
        Test.stopTest();
    }
    
    /*********************************************************************************
    Name         : createFileMethodTestFailField
    Work         : Integración Objeto de Leads
    Created By   : Everis
    Created Date : 28/08/2020
    Description  : Test method for createFileMethod - Fail
    VERSION  AUTHOR         DATE            Description
    1.0      Everis      28/08/2020       initial version /
	**********************************************************************************/     
    @isTest
    static void createFileMethodTestFailField(){
        String b64 = 'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z/C/HgAGgwJ/lK3Q6wAAAABJRU5ErkJggg==';
		List<LeadManager.File> fileList = new List<LeadManager.File>(); 
        List<Lead> le = [SELECT id, FirstName, LastName, status, RecordTypeId FROM Lead WHERE FirstName ='Rosa' LIMIT 1];
		le[0].FirstName = null;     
        update le;
        
        LeadManager.File file = new LeadManager.File();   
        file.NOMBREARCHIVO = 'test.pdf';
        file.DATA = b64;
        fileList.add(file);
        
        LeadManager.Request request = new LeadManager.Request();
        request.FECHAENVIO = '2020-08-27 15:04:00';
		request.IDENVIO = 0;
        request.LEAD = le[0]; 
        request.FILE = fileList;      
        
        Test.startTest();
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/V1/Lead/';  	//Request URL
        req.httpMethod = 'POST'; 							//HTTP Request Type
        String json = JSON.serialize(request);
        req.requestBody = Blob.valueof(json);
        RestContext.request = req;
 
        LeadManager.Response salida = LeadManager.createLeadWithFiles();
        system.assertEquals(true, salida.ESTADO.MENSAJE.contains('Error, faltan ingresar campos obligatorios'));
        Test.stopTest();
    }
}