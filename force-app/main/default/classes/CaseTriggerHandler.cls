public  class CaseTriggerHandler {
    
    private static CaseTriggerHandler instance = null;
    
    public static CaseTriggerHandler getInstance() {
        if (instance == null){
            instance = new CaseTriggerHandler();
        }    
        return instance;
    }
    public void onBeforeDelete(List<Case> caseLst){
        CaseTriggerHelper.onBeforeDelete(caseLst);
    }
    
    public void onBeforeUpdate(Map<Id,Case> caseOldMap, Map<Id,Case> caseNewMap){
        CaseTriggerHelper.onBeforeUpdate(caseOldMap, caseNewMap);
    }
}