public class SRV_RunCaseAssignmentRule {
    @InvocableMethod
    public static void assignCases(List<Id> caseIds){
        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.AssignmentRuleHeader.useDefaultRule = TRUE;
        List<Case> toAssign = [SELECT Id FROM Case WHERE Id = :caseIds];
        Database.update(toAssign,dmo);
    }
}