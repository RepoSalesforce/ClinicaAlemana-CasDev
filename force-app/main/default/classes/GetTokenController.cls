/*********************************************************************************
Name         : GetTokenController
Project      : CAS
Created By   : Everis
Created Date : 11/08/2020
Description  : Class GetTokenController
User Story   : ---
History                                                            
-------                                                            
VERSION  AUTHOR         DATE            Description
1.0      Everis       	11/08/2020      initial version 
********************************************************************************/
global without sharing class GetTokenController {
    
    /********************************************************************************
Author       : Everis
Company      : Everis
Description  : Metodo que actualiza / obtiene nuevo token
Inputs       : String nameAuthProvider
Returns      : -
History      : -------
AUTHOR          DATE              Description
everis        11/08/2020         Versión inicial
********************************************************************/
    public ReturnToken getToken(String nameAuthProvider){
        String token='';
        ResponseToken responseToken = new ResponseToken(); 
        ReturnToken returnToken = new ReturnToken();
        Date.today();
        
        AuthProv__c authPrv = [SELECT Id, client_id__c, client_secret__c,token_url__c, 
                               response__c, audience__c, grant_type__c, access_token__c, 
                               expires_in_date__c, status_code__c, last_fail__c, token_type__c
                               FROM AuthProv__c
                               WHERE name =: nameAuthProvider];
        
        
        if (authPrv.access_token__c <> '' && authPrv.expires_in_date__c > DateTime.now()){
            responseToken.access_token = authPrv.access_token__c;
            responseToken.token_type = authPrv.token_type__c;
            returnToken.responseToken = responseToken;
            System.debug('FECHA TOKEN: '+authPrv.expires_in_date__c );            
            System.debug('FECHA ACTUAL: '+DateTime.now());            
            System.debug('TOKEN VIGENTE: '+authPrv.access_token__c);
        }
        else
        {
            String strBody = '{"client_id":"'+authPrv.client_id__c+'","client_secret":"'
                +authPrv.client_secret__c+'","audience":"'+authPrv.audience__c
                +'","grant_type":"'+authPrv.grant_type__c+'"}';
            
            HttpResponse response = callService(authPrv.token_url__c,strBody);
            
            if (response.getStatusCode() == 200) {
                responseToken = (ResponseToken)JSON.deserialize(response.getBody(), ResponseToken.class);
				returnToken.responseToken = responseToken;
                returnToken.status_code = String.valueOf(response.getStatusCode());
                returnToken.response = response.toString();
                returnToken.regenerate = true;
                
                System.debug('TOKEN REGENERADO: '+responseToken.access_token);
            } else {
                System.debug('ERROR EN LLAMADA: ' +
                             response.getStatusCode() + ' ' + response.getStatus());
                authPrv.access_token__c= '';
                authPrv.expires_in_date__c = DateTime.now();
                authPrv.status_code__c= String.valueOf(response.getStatusCode());
                authPrv.response__c= response.toString();
                authPrv.last_fail__c = String.format('{0}\n{1}',new List<String>{ String.valueOf(DateTime.now()),response.toString()});
                
                update authPrv;
            }        
        }
        return returnToken;
    }
    
    
    public void updateToken(ResponseToken responseToken, String nameAuthProvider,String status_code, String response){
        String stringDateTime = String.valueOf(DateTime.now());
        DateTime dt = DateTime.valueOf(stringDateTime); 
        Integer expires_in = Integer.valueOf(responseToken.expires_in);
        DateTime expires_in_date = dt.addSeconds(expires_in);
        try{
            
        AuthProv__c authPrv = [SELECT Id, client_id__c, client_secret__c,token_url__c, 
                               response__c, audience__c, grant_type__c, access_token__c, 
                               expires_in_date__c, status_code__c, last_fail__c, token_type__c
                               FROM AuthProv__c
                               WHERE name =: nameAuthProvider];        
        
        authPrv.token_type__c= responseToken.token_type;
        authPrv.expires_in__c= (responseToken.expires_in - 120); // 60 segundos antes
        authPrv.expires_in_date__c= expires_in_date;
        authPrv.access_token__c= responseToken.access_token;
        authPrv.status_code__c= status_code;
        authPrv.response__c= response;
        
        update authPrv;        
        } catch(DmlException e) {
          system.debug('ERROR '+e);   
        }
            
    }
    
    public HttpResponse callService(String endPoint, String strBody){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endPoint);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setBody(strBody);
        HttpResponse response = http.send(request);
        return response;
    }
    
    
    global class ResponseToken{
        public String access_token = '';
        public Double expires_in = 0;
        public String token_type = '';
    }

    global class ReturnToken{
        public ResponseToken responseToken;
        public Boolean regenerate = false;
        public String status_code ='';
        public String response ='';
    }    
}