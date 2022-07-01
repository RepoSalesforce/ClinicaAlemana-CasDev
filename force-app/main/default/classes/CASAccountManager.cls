@RestResource(urlMapping='/V1/CASAccounts/*')

global with sharing class CASAccountManager {
    
   @HttpGet
    global static void getAccountbyNumident() {        
       // String strNumIdent = '';
        RestRequest restReq = RestContext.request;
        RestResponse restRes = RestContext.response;
        
        Account resultAccount = new Account();
        
        String strNumIdent = restReq.params.get('numIdent');
        System.debug(strNumIdent);
        // Get account by rut (Numero_de_Identificacion__c)
       // List<Account> accs = [SELECT Id, FirstName, LastName, Numero_de_Identificacion__c, Tipo_de_Identificacion__c FROM Account WHERE Numero_de_Identificacion__c = :strNumIdent and toLabel(Tipo_de_Identificacion__c) = 'RUT'];
      
        //result = JSON.serialize( resultMap);
        Account[] accs = [SELECT Id, FirstName, LastName, Numero_de_Identificacion__c, Tipo_de_Identificacion__c, toLabel(Tipo_de_Identificacion__c) TipoIdentificacion 
                            FROM Account WHERE Numero_de_Identificacion__c = :strNumIdent and toLabel(Tipo_de_Identificacion__c) = 'RUT'];    
       System.debug(accs.size());
       if (accs.size()>0) { 
           resultAccount = accs[0];
           restRes.responseBody = Blob.valueOf(JSON.serialize(resultAccount));
           restRes.addHeader('Content-Type','application/json');
           restRes.statusCode=200;          
        }else { 
        	Account[] accs2 = [SELECT Id, FirstName, LastName, Numero_de_Identificacion__c, Tipo_de_Identificacion__c, toLabel(Tipo_de_Identificacion__c) TipoIdentificacion 
                               FROM Account WHERE Numero_de_Identificacion__c = :strNumIdent and toLabel(Tipo_de_Identificacion__c) = 'Pasaporte'];    
            if (accs2.size()>0) { //Es Pasaporte
                resultAccount = accs2[0];
                restRes.responseBody = Blob.valueOf(JSON.serialize(resultAccount));
                restRes.addHeader('Content-Type','application/json');
                restRes.statusCode=200;          
           }else { 
                 restRes.statusCode=404;           
           }          
        }
        RestContext.response = restRes;
    }
}