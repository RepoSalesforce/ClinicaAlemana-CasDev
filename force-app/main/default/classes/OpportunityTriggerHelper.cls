public without sharing class OpportunityTriggerHelper {

    public static void onBeforeUpdate(List<Opportunity> oppList, List<Opportunity> oppListOld){

        //Se ejecuta cuando se sincroniza un nuevo presupuesto a la oportunidad. 
        if((oppList[0].SyncedQuoteId != oppListOld[0].SyncedQuoteId) && oppList[0].SyncedQuoteId != null){

            List<ContentDocumentLink> lstContDocLinkToDelete = new List<ContentDocumentLink>();
            List<utilitiesClass.createRelationshipFilesSubclass> lstRelation = new List<utilitiesClass.createRelationshipFilesSubclass>();

            List<Quote> lstQuote = [SELECT Id, Name, Codigo_CAS_1__c, Nombre_Intervencion_1__c, Total_Clinica__c,
                                    Total_Honorarios_Medico__c, Fecha_probable_hospitalizacion__c, Medico_Tratante__c, Codigo_Fonasa_1__c
                                    FROM Quote
                                    WHERE Id =: oppList[0].SyncedQuoteId LIMIT 1];

            List<ContentDocumentLink> lstContDocLinkInOpp = [SELECT Id, LinkedEntityId, ContentDocumentId,
                                                            ContentDocument.LatestPublishedVersion.TagCsv
                                                            FROM ContentDocumentLink
                                                            WHERE LinkedEntityId =: oppList[0].Id];
        
            List<ContentDocumentLink> lstContDocLinkToSync = [SELECT Id, LinkedEntityId, ContentDocumentId
                                                            FROM ContentDocumentLink
                                                            WHERE LinkedEntityId =: oppList[0].SyncedQuoteId];

            //Sincroniza campos desde el presupuesto hacia la oportunidad.                                            
            if(!lstQuote.isEmpty()){
                for(Opportunity opp : oppList){
                    opp.Codigo_Cirugia_CAS__c = lstQuote[0].Codigo_CAS_1__c;
                    opp.Descripcion_Cirugia__c = lstQuote[0].Nombre_Intervencion_1__c;
                    opp.Total_Clinica__c = lstQuote[0].Total_Clinica__c;
                    opp.Total_Honorarios_Medico__c = lstQuote[0].Total_Honorarios_Medico__c;
                    opp.CloseDate = lstQuote[0].Fecha_probable_hospitalizacion__c;
                    opp.Nombre_Medico__c = lstQuote[0].Medico_Tratante__c;
                    opp.Codigo_ciguria_FONASA__c = lstQuote[0].Codigo_Fonasa_1__c;
                }
            }

            //Elimina de la oportunidad los archivos relacionados con presupuestos ya no sincronizados con ella.
            if(!lstContDocLinkInOpp.isEmpty()){
                for(ContentDocumentLink cdl : lstContDocLinkInOpp){
                    if(cdl.ContentDocument.LatestPublishedVersion.TagCsv == 'ApexCreated'){
                        lstContDocLinkToDelete.add(cdl);
                    }
                }
                delete lstContDocLinkToDelete;
            }
            
            //Sincroniza en la oportunidad los archivos relacionados con el nuevo presupuesto sincronizado.
            if(!lstContDocLinkToSync.isEmpty()){
                for(ContentDocumentLink cdl : lstContDocLinkToSync){
                    utilitiesClass.createRelationshipFilesSubclass relation = new utilitiesClass.createRelationshipFilesSubclass();
                    relation.parentId = oppList[0].Id;
                    relation.contDocId = cdl.ContentDocumentId;
                    lstRelation.add(relation);
                }
                utilitiesClass.createRelationshipFilesMethod(lstRelation);
            }
        }
    }
}