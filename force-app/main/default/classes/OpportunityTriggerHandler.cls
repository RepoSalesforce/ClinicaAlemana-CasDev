public with sharing class OpportunityTriggerHandler {

    private static OpportunityTriggerHandler instance = null;

    public static OpportunityTriggerHandler getInstance(){
        if (instance == null){
            instance = new OpportunityTriggerHandler();
        }
        return instance;
    }

    public void onBeforeUpdate(List<Opportunity> oppList, List<Opportunity> oppListOld){
        OpportunityTriggerHelper.onBeforeUpdate(oppList, oppListOld);
    }

}