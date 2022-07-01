@isTest
public class GetTokenController_Test {
   @isTest 
    static void Test1() {

		AuthProv__c authPrv = new AuthProv__c();
        authPrv.client_id__c = '1234';
        authPrv.client_secret__c = '1234';
        authPrv.response__c = '{}';
        authPrv.audience__c = 'audience';
        authPrv.grant_type__c = 'grant_type';
        authPrv.access_token__c = '1234';
        
        String stringDateTime = String.valueOf(DateTime.now());
        DateTime dt = DateTime.valueOf(stringDateTime); 
        DateTime expires_in_date = dt.addSeconds(2000);        
        
        authPrv.expires_in_date__c = expires_in_date;
        authPrv.status_code__c='200';
        authPrv.token_type__c = 'token_type';
        authPrv.name = 'Indicadores1';
        authPrv.token_url__c = 'www.a.cl';
        
        insert authPrv;   

		expires_in_date = dt.addSeconds(-4000);                
 		AuthProv__c authPrv_2 = new AuthProv__c();
        authPrv_2.client_id__c = '1234';
        authPrv_2.client_secret__c = '1234';
        authPrv_2.response__c = '{}';
        authPrv_2.audience__c = 'audience';
        authPrv_2.grant_type__c = 'grant_type';
        authPrv_2.access_token__c = '1234';
        
        authPrv_2.expires_in_date__c = expires_in_date;
        authPrv_2.status_code__c='200';
        authPrv_2.token_type__c = 'token_type';
        authPrv_2.name = 'Indicadores2';
        authPrv_2.token_url__c = 'www.a.cl';
        insert authPrv_2;   

		test.startTest();
        Test.setMock(HttpCalloutMock.class, new GetTokenCalloutMock()); 
        
        GetTokenController gtoken = new GetTokenController();
        
        gtoken.getToken('Indicadores1');
        gtoken.getToken('Indicadores2');
        
        GetTokenController.ResponseToken responseToken = new GetTokenController.ResponseToken();
        gtoken.updateToken(responseToken, 'Indicadores1', '200', '{}');
        
        test.stopTest();
    }
    
}