/** 
* ===================================================================================
* @className        SetAgeContactSchedule
* @description      Schedulable class for update age contact
* @author           everis
* @testClass        SetAgeContactSchedule
* @dateCreated      05/08/2020
* ===================================================================================
*/
global without sharing class SetAgeContactSchedule implements Schedulable {
/** 
* ===================================================================================
* @MethodName       execute()
* @description      Method execute schedulable batch
* @author           everis
* @version          V1.0
* @dateCreated      05/08/2020
* ===================================================================================
*/
    global void execute(SchedulableContext sc) {        
            database.executebatch(new SetAgeContactTask());
    }
}