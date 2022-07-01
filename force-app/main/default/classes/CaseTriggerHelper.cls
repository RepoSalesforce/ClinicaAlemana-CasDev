public with sharing class CaseTriggerHelper {
    
    public static void onBeforeDelete (List<Case> caseList){
        String profileId=userinfo.getProfileId();	
        List<ProfilesCantDelete__c>profileLst = [SELECT id, SetupOwnerId FROM ProfilesCantDelete__c WHERE SetupOwnerId =:profileId LIMIT 1];
        if(profileLst.size()>0){
            Trigger.old[0].addError(Label.SRV_ErrorPermisosParaBorrar);
        } 
    }
    public static void onBeforeUpdate (Map<Id,Case> caseOldMap, Map<Id,Case> caseNewMap){
        Set<id> caseIds = caseOldMap.keySet();
        Set<id> caseIdsToQuery = new Set<id>();
        for(id i:caseIds){
            if(caseOldMap.get(i).Status != caseNewMap.get(i).Status && caseNewMap.get(i).Status=='Closed'){
                caseIdsToQuery.add(i);
            }
        }
        List<Case> caseWithTask = [SELECT id, (SELECT id FROM Tasks WHERE IsClosed=false) FROM Case WHERE id=:caseIdsToQuery];
        for(Case c:caseWithTask){
            if(c.Tasks.size() > 0){
                caseNewMap.get(c.Id).addError(Label.SRV_ErrorCasoConTareasAbiertas);
            }
        }
    }
    
}