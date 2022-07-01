@isTest
public class GetIndicadoresController_Test {
    
    @testSetup
    static void setup(){
        
        Account acc1 = new Account();
        acc1 = UtilitiesTestClass.createAccount('Jose', 'PPN', '1', '12897546-9');
        insert acc1;
        
        Account acc2 = new Account();
        acc2 = UtilitiesTestClass.createAccount('Luis', 'PPNTest', '1', '19856547-9');
        insert acc2;
        
        Account acc3 = new Account();
        acc3 = UtilitiesTestClass.createAccount('Luis', '', '1', '19856547-9');
        insert acc3;

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
        authPrv.name = 'Indicadores';
        authPrv.token_url__c = 'www.a.cl';
        
        insert authPrv;   
        
        Medico__c med = new Medico__c();
        med = UtilitiesTestClass.createMedico('test', '17584968-8', '1');
        insert med;
        
        Opportunity opp1 = new Opportunity();
        opp1 = UtilitiesTestClass.createOpportunity(med.id, acc1.id, '19856547-9');
        insert opp1;
        
        Case cas1 = new Case();
        cas1 = UtilitiesTestClass.createStandardCase(acc1.ID);
        insert cas1;
        
        
        
    }    
    
  @isTest 
    static void Test1() {
		test.startTest();
        String strBody = '[{"id": 2,"idWidget": null,"idIndicador": 1,"posicion": "2","orden": "1","indicadorcli": "T","glosa": " ","url1": null,"url2": null,"alerta": "N","imagen": "02_01.gif","vigencia": null,"permiso": null}]';
        Test.setMock(HttpCalloutMock.class, new GetIndicadoresCalloutMock(200, 'Complete', strBody)); 
        GetIndicadoresController.WrapperResponse wrapperResponse = new GetIndicadoresController.WrapperResponse();
        Account ac = [select id from Account limit 1];
        wrapperResponse = GetIndicadoresController.getIndicadores(ac.id);
        test.stopTest();
        
    }
    
   @isTest 
    static void Test2() {
		test.startTest();
        String strBody = '[{"id": 2,"idWidget": null,"idIndicador": 1,"posicion": "2","orden": "1","indicadorcli": "T","glosa": " ","url1": null,"url2": null,"alerta": "N","imagen": "02_01.gif","vigencia": null,"permiso": null}]';
        Test.setMock(HttpCalloutMock.class, new GetIndicadoresCalloutMock(200, 'Complete', strBody)); 
        GetIndicadoresController.WrapperResponse wrapperResponse = new GetIndicadoresController.WrapperResponse();
        Opportunity op = [select id from Opportunity limit 1];
        wrapperResponse = GetIndicadoresController.getIndicadores(op.id);
        test.stopTest();
        
    }
    
   @isTest 
    static void Test3() {
		test.startTest();
        String strBody = '[{"id": 2,"idWidget": null,"idIndicador": 1,"posicion": "2","orden": "1","indicadorcli": "T","glosa": " ","url1": null,"url2": null,"alerta": "N","imagen": "02_01.gif","vigencia": null,"permiso": null}]';
        Test.setMock(HttpCalloutMock.class, new GetIndicadoresCalloutMock(400, 'Error', strBody)); 
        GetIndicadoresController.WrapperResponse wrapperResponse = new GetIndicadoresController.WrapperResponse();
        Account ac = [select id from Account where ppn__c ='' limit 1];
        wrapperResponse = GetIndicadoresController.getIndicadores(ac.id);
        test.stopTest();
        
    }   

   @isTest 
    static void Test4() {
		test.startTest();
		GetTokenController.ResponseToken rt = new GetTokenController.ResponseToken();
        GetIndicadoresController.generateToken();
        GetIndicadoresController.getUrl();
        test.stopTest();        
    }   
    
    @isTest 
    static void Test5() {
		test.startTest();
        String strBody = '[{"id": 2,"idWidget": null,"idIndicador": 1,"posicion": "2","orden": "1","indicadorcli": "T","glosa": " ","url1": null,"url2": null,"alerta": "N","imagen": "02_01.gif","vigencia": null,"permiso": null}]';
        Test.setMock(HttpCalloutMock.class, new GetIndicadoresCalloutMock(200, 'Complete', strBody)); 
        GetIndicadoresController.WrapperResponse wrapperResponse = new GetIndicadoresController.WrapperResponse();
        Case ca = [select id from Case limit 1];
        wrapperResponse = GetIndicadoresController.getIndicadores(ca.id);
        test.stopTest();
        
    }
    
        
    
    
}