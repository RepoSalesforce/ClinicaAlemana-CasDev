public without sharing class sRV_CloseDerivatedCaseController {
    @AuraEnabled(cacheable=true)
    public static List<SRV_Sucursal__c> getSucursales(){
        return [SELECT Id, Name FROM SRV_Sucursal__c];
    }
    @AuraEnabled(cacheable=true)
    public static List<SRV_Unidad_responsable__c> getUnidadesResponsables(String sucursal){
        return [SELECT Id, Name FROM SRV_Unidad_responsable__c WHERE SRV_Sucursal__c=:sucursal];
    }
    @AuraEnabled
    public static void setDerivatedCase(String email, String idUnidadResponsable, String idSucursal, String idCase){
        Case mod = New Case();
        mod.id = idCase;
        RecordType idRT = [SELECT Id FROM RecordType WHERE DeveloperName='SRV_Caso_Resolucion_Rapida'];
        mod.RecordTypeId = idRT.id;
        mod.Type = 'Consulta';
        mod.SRV_Tipo_de_cierre__c = 'Explicaciones';
        mod.SRV_Conforme__c = 'Sí';
        mod.Comentarios_de_cierre__c = 'Derivado al área de interés';
        mod.SRV_Cerrado_por__c = 'Cerrado por SAC';
        mod.Status = 'Closed';
        mod.ownerId = UserInfo.getUserId();
        if(!String.isBlank(email)){
            mod.SRV_Email_Tipificacion__c = email;
        } else {
            mod.SRV_Sucursal__c = idSucursal;
            mod.SRV_Unidad_responsable__c = idUnidadResponsable;
            SRV_Unidad_responsable__c unidadResponsable = [SELECT id, SRV_Jefe_de_Area__r.SRV_Correo_Electronico__c FROM SRV_Unidad_responsable__c WHERE id=:idUnidadResponsable];
            system.debug(unidadResponsable);
            mod.SRV_Email_Tipificacion__c = unidadResponsable.SRV_Jefe_de_Area__r.SRV_Correo_Electronico__c; 
        }
        update mod;
        //Look for Email Message
        List<EmailMessage> em = [SELECT Id, HtmlBody, Subject, FromName, FromAddress, TextBody, RelatedToId, Incoming, Headers FROM EmailMessage where RelatedToId =: idCase AND Incoming = true];
        //ejecución de flow
        if(em.size() > 0){
            system.debug(em[0].HtmlBody.replace('\n',''));
            Map<String, Object> params = new Map<String, Object>();
            params.put('CaseId', idCase);
            params.put('emailBody', em[0].HtmlBody.replace('\n',''));
            params.put('emailSubject', 'Información recibida en Servicio al Cliente');
            params.put('emailTo', mod.SRV_Email_Tipificacion__c);
            Flow.Interview.SRV_EnvioEmailDerivado derivatedCaseFlow = new Flow.Interview.SRV_EnvioEmailDerivado(params);
            derivatedCaseFlow.start();
        }
    }
}