@isTest
public class CASAccountManagerTest {
    @isTest
    static void getAccountTestFound() {
       	 RestRequest req = new RestRequest(); 
         RestResponse res = new RestResponse();
       
         req.requestURI = '/services/apexrest/V1/CASAccounts';  //Request URL +recordCuenta.Numero_de_Identificacion__c
       
         req.addHeader('Content-Type', 'application/json'); 
         req.params.put('numIdent', '16301360-6');
         req.httpMethod = 'GET';//HTTP Request Type
		 req.requestBody = Blob.valueof('{}');         
       
         RestContext.request = req;
         RestContext.response= res;
        
        Account acc = new Account(FirstName='Daniela',LastName='Guerra',Numero_de_Identificacion__c='16301360-6',Tipo_de_Identificacion__c='1');
		insert acc;
		
        Test.startTest();        
         	CASAccountManager.getAccountbyNumident();
            res = RestContext.response;
            //System.debug(res);         
            System.assertEquals(200,  res.statusCode);
            //System.assert( lstProspect.entList  != null);
         Test.StopTest();
   }
    
   @isTest 
    static void getAccountTestFoundPas() {
       	 RestRequest req = new RestRequest(); 
         RestResponse res = new RestResponse();
       
         req.requestURI = '/services/apexrest/V1/CASAccounts';  //Request URL +recordCuenta.Numero_de_Identificacion__c
       
         req.addHeader('Content-Type', 'application/json'); 
         req.params.put('numIdent', 'AAF532592');
         req.httpMethod = 'GET';//HTTP Request Type
		 req.requestBody = Blob.valueof('{}');         
       
         RestContext.request = req;
         RestContext.response= res;
        
        Account acc = new Account(FirstName='Chuck',LastName='Norris',Numero_de_Identificacion__c='AAF532592',Tipo_de_Identificacion__c='2');
		insert acc;
		
        Test.startTest();        
         	CASAccountManager.getAccountbyNumident();
            res = RestContext.response;
            //System.debug(res);         
            System.assertEquals(200,  res.statusCode);
            //System.assert( lstProspect.entList  != null);
         Test.StopTest();
   }
    
    @isTest 
    public static void getAccountTestNotFound() {
    	 RestRequest req = new RestRequest(); 
         RestResponse res = new RestResponse();
        
         req.requestURI = '/services/apexrest/V1/CASAccounts';  //Request URL +recordCuenta.Numero_de_Identificacion__c
         req.params.put('numIdent', '16301360-5');
         req.httpMethod = 'GET';//HTTP Request Type
         req.addHeader('Content-Type', 'application/json'); 
       
         RestContext.request = req;
         RestContext.response= res;
        
         Test.startTest();  
         	CASAccountManager.getAccountbyNumident();
            res = RestContext.response;
            System.debug(res); 
            System.assertEquals(404,  res.statusCode);
         Test.StopTest();
   }
}