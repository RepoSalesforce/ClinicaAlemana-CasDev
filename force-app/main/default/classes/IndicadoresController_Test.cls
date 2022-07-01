@isTest
public class IndicadoresController_Test {
   @isTest 
    static void Test1() {
        Account acc = new Account();
        acc = UtilitiesTestClass.createAccount('Luis', '', '1', '19856547-9');
        insert acc;
        ApexPages.currentPage().getParameters().put('Id',acc.id);
		IndicadoresController ic = new IndicadoresController();        
        
    }
    
}