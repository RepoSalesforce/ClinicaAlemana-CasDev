/*********************************************************************************
Name         : GetIndicadoresController
Project      : CAS
Created By   : Everis
Created Date : 06/08/2020
Description  : Class GetIndicadoresController
User Story   : ---
History                                                            
-------                                                            
VERSION  AUTHOR         DATE            Description
1.0      Everis       	06/08/2020      initial version 
********************************************************************************/
public class GetIndicadoresController {
    
    /********************************************************************************
Author       : Everis
Company      : Everis
Description  : -
Returns      : WrapperResponse
History      : -------
AUTHOR          DATE              Description
everis        06/08/2020         Versión inicial
********************************************************************************/
    @AuraEnabled
    public static WrapperResponse getIndicadores(String recordId){
        
        // IDREG
        // 001 --> ID ACCOUNT
        // 006 --> ID OPORTUNITTY
        
        String PPN = '';
        system.debug('ENTROOO');
        system.debug(recordId);
        if (recordId.substring(0,3)=='001'){
            system.debug('CUENTA');
            List<Account> ac = [select id,PPN__c
                                from account where id =:recordId];
            if (ac.size()>0){
                PPN = ac[0].PPN__c;
            }
        }        
        
        if (recordId.substring(0,3)=='006'){
            system.debug('OPORTUNIDAD');
            List<Opportunity> op = [select id, Account.PPN__c
                                    from opportunity where id =:recordId];
            if (op.size()>0){
                PPN = op[0].Account.PPN__c;    
            }
        }
        if (recordId.substring(0,3)=='500'){
            system.debug('CASO');
            List<Case> Cas = [SELECT id, account.name, account.ppn__c from case WHERE id=:recordId];
            if (Cas.size()>0){
                PPN = Cas[0].account.PPN__c;
            }
        }          
        
        List<EndPoints__mdt> endPointIndicador = [SELECT Id, url__c, method__c
                                                  FROM EndPoints__mdt
                                                  WHERE Label in ('Indicadores')];
        
        List<EndPoints__mdt> endPointUrlImagenes = [SELECT Id, url__c, method__c
                                                    FROM EndPoints__mdt
                                                    WHERE Label in ('UrlImagenes')];
        
        WrapperResponse wrapperResponse = new wrapperResponse();
        
        if (endPointUrlImagenes.size()>0 && endPointIndicador.size()>0 && PPN<>''){
            
            try{
                
        AuthProv__c authPrv = [SELECT Id, client_id__c, client_secret__c,token_url__c, 
                               response__c, audience__c, grant_type__c, access_token__c, 
                               expires_in_date__c, status_code__c, last_fail__c, token_type__c
                               FROM AuthProv__c
                               WHERE name ='Indicadores'];
                
                if (authPrv.access_token__c<>''){
                    Http http = new Http();
                    HttpRequest request = new HttpRequest();
                    request.setEndpoint(endPointIndicador[0].url__c+'/'+PPN);
                    request.setMethod(endPointIndicador[0].method__c);
                    
                    system.debug('RETORNO TYPE: '+authPrv.token_type__c);	
                    system.debug('RETORNO TOKEN: '+authPrv.access_token__c);	
                    request.setHeader('authorization', authPrv.token_type__c +' '+ authPrv.access_token__c);
                    request.setHeader('content-type', 'application/json');
                    
                    system.debug('METHOD LLAMADA: '+endPointIndicador[0].method__c);	
                    Integer randomNumber = Integer.valueof((Math.random() * 10000000));
                    HttpResponse response = http.send(request);
                    
                    if (response.getStatusCode()==200){
                        wrapperResponse.data.url = endPointUrlImagenes[0].url__c;
                        wrapperResponse.data.json = response.getBody();
                        wrapperResponse.code = String.valueOf(response.getStatusCode());
                        wrapperResponse.message = 'OK'+String.valueOf(randomNumber);
                        wrapperResponse.debugLog  = '';
                        system.debug('RESPONSE BODY: '+response.getBody());                    
                    }
                    else
                    {
                        wrapperResponse.code = String.valueOf(response.getStatusCode());
                        wrapperResponse.message = 'KO'+String.valueOf(randomNumber);
                        wrapperResponse.debugLog  = 'ERROR RESPONSE SERVICIO';
                        system.debug('RESPONSE BODY ERROR: '+response.getBody());                    
                    }
                    
                    system.debug(' CODE STATUS: '+String.valueOf(response.getStatusCode()) + 'RESPONSE BODY: '+response.getBody());                    
                }
                else
                { 
                    wrapperResponse.message = 'Token vacio';
                    wrapperResponse.code = '400';
                }
            }
            catch(Exception e)
            {
                wrapperResponse.code = '400'; 
                wrapperResponse.debugLog = e.getStackTraceString();
                system.debug('ERROR: '+e.getStackTraceString());
            }            
        }
        else
        {
            wrapperResponse.message = 'Falta configuración de endpoint';
            wrapperResponse.code = '400';
        }
        
        return wrapperResponse;
    }

    @AuraEnabled
    public static GetTokenController.ResponseToken generateToken(){
                GetTokenController gtoken = new GetTokenController(); 
                GetTokenController.ResponseToken responseToken = new GetTokenController.ResponseToken();
                GetTokenController.ReturnToken returnToken = gtoken.getToken('Indicadores');                
                responseToken = returnToken.responseToken;
        
                    if (returnToken.regenerate){
                        gtoken.updateToken(responseToken, 'Indicadores', returnToken.status_code, returnToken.response);
                    }
        return responseToken;
    }
    
    public class WrapperResponse{
        @AuraEnabled Public String message {get;set;}
        @AuraEnabled Public String code {get;set;}
        @AuraEnabled Public String debugLog {get;set;}
        @AuraEnabled Public String regenerateToken {get;set;}
        @AuraEnabled Public Data data = new Data();
    } 
    
    public class Data {
        @AuraEnabled Public String url = '';
        @AuraEnabled Public String json ='';
    }   
    
    @AuraEnabled
    public static String getUrl(){
       String prefix = URL.getSalesforceBaseURL().toExternalForm().replace('https://', '').split('\\.')[0];
        prefix = prefix.removeEnd('--c');
        return 'https://' + prefix.toLowerCase() + '.lightning.force.com';        

    }    
}