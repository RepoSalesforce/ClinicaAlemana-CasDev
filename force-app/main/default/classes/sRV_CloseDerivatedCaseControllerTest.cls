@isTest
public class sRV_CloseDerivatedCaseControllerTest {
    @testSetup
    private static void testSetup() {
        //create contact
        Account acc = new Account();  
        acc = UtilitiesTestClass.createAccount('rodriguez', '45', '1', '32');
        insert acc;
        //create case
        Case caso = UtilitiesTestClass.createCaseGeneral('New',acc.PersonContactId);
        insert caso;
        //Create sucursal
        SRV_Sucursal__c suc = new SRV_Sucursal__c();
        suc = UtilitiesTestClass.createSucursal('TestCodigo','TestDireccion','TestName');  
        insert suc;
        //Create funcionario
        SRV_Funcionario__c fun = new SRV_Funcionario__c();
        fun = UtilitiesTestClass.createFuncionario('test@test.com','test');
        insert fun;  
        //Create unidad responsable
        SRV_Unidad_responsable__c unr = new SRV_Unidad_responsable__c();
        unr = UtilitiesTestClass.createUnidadResponsable('TestID','TestNameUN',suc.Id,fun.Id);
        insert unr;
        //Create Email Messaje
        EmailMessage em = new EmailMessage();
        em = UtilitiesTestClass.createEmailmessage(caso.id, 'testEmail@test.com');
        em.Incoming = true;
        insert em;
        //Create usuario
        Profile pro = [SELECT id, Name FROM profile WHERE Name = 'Supervisor de Servicio'];
        User user = new User();
        user = UtilitiesTestClass.createUser(pro.id,'tAlias');
        insert user;
        
    }
    
    private static testMethod void getSucursalesTest(){
        test.startTest();
        List<SRV_Sucursal__c> resultado = sRV_CloseDerivatedCaseController.getSucursales();
        test.stopTest();
        system.assert(!resultado.isEmpty());
        
    } 
    private static testMethod void getUnidadesResponsablesTest(){
        test.startTest();
        List<SRV_Sucursal__c> resultado = [SELECT id FROM SRV_Sucursal__c WHERE SRV_Codigo__c = 'TestCodigo' AND SRV_Direccion__c = 'TestDireccion' AND Name = 'TestName'];
        String codigoSuc = resultado[0].id;
        List<SRV_Unidad_responsable__c> resultadoUni = sRV_CloseDerivatedCaseController.getUnidadesResponsables(codigoSuc); 
        test.stopTest();
        system.assert(!resultadoUni.isEmpty());
    }
    private static testMethod void setDerivatedCaseWithEmail(){
        test.startTest();
        List<Case> casito = [SELECT Id, SRV_Conforme__c FROM Case WHERE subject = 'Test Case'];
        List<SRV_Sucursal__c> resultado = [SELECT id FROM SRV_Sucursal__c WHERE SRV_Codigo__c = 'TestCodigo' AND SRV_Direccion__c = 'TestDireccion' AND Name = 'TestName'];   
        List<SRV_Unidad_responsable__c> resultadoUni = [SELECT id, SRV_Jefe_de_Area__r.SRV_Correo_Electronico__c FROM SRV_Unidad_responsable__c WHERE Name='TestNameUN'];
        sRV_CloseDerivatedCaseController.setDerivatedCase('test@test.com', resultadoUni[0].id, resultado[0].id, casito[0].id);
        test.stopTest();
        List<Case> casito2 = [SELECT Id, SRV_Conforme__c, SRV_Email_Tipificacion__c FROM Case WHERE subject = 'Test Case'];
        system.assertEquals('Sí', casito2[0].SRV_Conforme__c);
    }
    
    private static testMethod void setDerivatedCaseWithSucursal(){
        test.startTest();
        User usuario = [SELECT id, Name FROM User WHERE Alias = 'tAlias'];
        system.runAs(usuario){
            List<SRV_Sucursal__c> resultado = [SELECT id FROM SRV_Sucursal__c WHERE SRV_Codigo__c = 'TestCodigo' AND SRV_Direccion__c = 'TestDireccion' AND Name = 'TestName'];   
            List<SRV_Unidad_responsable__c> resultadoUni = [SELECT id, SRV_Jefe_de_Area__r.SRV_Correo_Electronico__c FROM SRV_Unidad_responsable__c WHERE Name='TestNameUN'];
            List<Case> casito = [SELECT Id, SRV_Email_Tipificacion__c FROM Case WHERE subject = 'Test Case'];
            sRV_CloseDerivatedCaseController.setDerivatedCase('', resultadoUni[0].id, resultado[0].id, casito[0].id);
            
        }
        test.stopTest();
        List<Case> casito2 = [SELECT Id, SRV_Email_Tipificacion__c FROM Case WHERE subject = 'Test Case'];
        system.assertEquals('test@test.com',casito2[0].SRV_Email_Tipificacion__c); 
        
    }
    
    
}