@isTest
private class utilitiesClass_Test{
    
    @isTest
    static void jsonToAccountTest(){
        AccountManager.CLIENTE cli = new AccountManager.CLIENTE();
        cli.IDCLIENTENATURAL = '123456';
        cli.TIPOIDENTIFICACION = '1';
        cli.NUMIDENTIFICACION = '15132985';
        cli.DVIDENTIFICACION = '3';
        cli.FLAGVIGENCIA = true;
        cli.FECHANACIMIENTO = '1983-03-28';
        cli.SEXO = 'M';
        cli.ESTADOCIVIL = 'S';
        cli.FECHADEFUCION = '2060-06-23';
        cli.IDPREVISION = '50';
        cli.IDACTIVIDAD = '41';
        cli.FLAGACREDITADO = true;
        cli.FLAGEMAIL = true;
        cli.FLAGDEFUNCION = false;
        cli.NOMBRES = 'Nombre Falso';
        cli.APEPATERNO = 'ApPaterno';
        cli.APEMATERNO = 'ApMaterno';
        cli.IDNACIONALIDAD = '49';
        cli.TELEFONOPARTICULAR = '9182736450';
        cli.CORREOPARTICULAR = 'correo@falso.com';
        cli.CELULARPARTICULAR = '9876543210';
        cli.DIRECCIONPARTICULAR = 'Calle Falsa #123';
        cli.DIRECCIONCOMERCIAL = 'Avenida Falsa #321';
        cli.IDEMPRESA = '2';
        cli.IDCOMUNAPARTICULAR = '13119';
        cli.CIUDADPARTICULAR = 'Santiago';
        cli.IDCOMUNACOMERCIAL = '13114';
        cli.CIUDADCOMERCIAL = 'Santiago';
        cli.IDPAISPARTICULAR = '49';
        cli.IDPAISCOMERCIAL = '49';
        cli.FECHACONSENTINF = '2050-06-23';
		cli.CONSENTIMIENTOINF = 'Nulo';
		cli.INDICADORFUNCIONARIO = true;
        
        
        
        utilitiesClass.getpicklistValues();
        Account acc = utilitiesClass.jsonToAccount(cli, true);
        //String expected = '[{ "IDCLIENTENATURAL" : "'+cli.IDCLIENTENATURAL+'", "TIPOIDENTIFICACION" : "'+cli.TIPOIDENTIFICACION+'", "NUMIDENTIFICACION" : "'+cli.NUMIDENTIFICACION+'", "DVIDENTIFICACION" : "'+cli.DVIDENTIFICACION+'", "FLAGVIGENCIA" : "'+cli.FLAGVIGENCIA+'", "FECHANACIMIENTO" : "'+cli.FECHANACIMIENTO+'", "SEXO" : "'+cli.SEXO+'", "ESTADOCIVIL" : "'+cli.ESTADOCIVIL+'", "FECHADEFUCION" : "'+cli.FECHADEFUCION+'", "IDPREVISION" : "'+cli.IDPREVISION+'", "IDACTIVIDAD" : "'+cli.IDACTIVIDAD+'", "FLAGACREDITADO" : "'+cli.FLAGACREDITADO+'", "FLAGEMAIL" : "'+cli.FLAGEMAIL+'", "FLAGDEFUNCION" : "'+cli.FLAGDEFUNCION+'", "NOMBRES" : "'+cli.NOMBRES+'", "APEPATERNO" : "'+cli.APEPATERNO+'", "APEMATERNO" : "'+cli.APEMATERNO+'", "IDNACIONALIDAD" : "'+cli.IDNACIONALIDAD+'", "TELEFONOPARTICULAR" : "'+cli.TELEFONOPARTICULAR+'", "CORREOPARTICULAR" : "'+cli.CORREOPARTICULAR+'", "CELULARPARTICULAR" : "'+cli.CELULARPARTICULAR+'", "DIRECCIONPARTICULAR" : "'+cli.DIRECCIONPARTICULAR+'", "DIRECCIONCOMERCIAL" : "'+cli.DIRECCIONCOMERCIAL+'", "IDEMPRESA" : "'+cli.IDEMPRESA+'", "IDCOMUNAPARTICULAR" : "'+cli.IDCOMUNAPARTICULAR+'", "CIUDADPARTICULAR" : "'+cli.CIUDADPARTICULAR+'", "IDCOMUNACOMERCIAL" : "'+cli.IDCOMUNACOMERCIAL+'", "CIUDADCOMERCIAL" : "'+cli.CIUDADCOMERCIAL+'", "IDPAISPARTICULAR" : "'+cli.IDPAISPARTICULAR+'", "IDPAISCOMERCIAL" : "'+cli.IDPAISCOMERCIAL+'"}]';
        System.assertEquals('Nombre', acc.FirstName);
        System.assertEquals('Falso', acc.MiddleName);
        System.assertEquals(cli.NUMIDENTIFICACION + '-' + cli.DVIDENTIFICACION, acc.Numero_de_Identificacion__c);
        System.assertEquals(cli.FECHANACIMIENTO, string.valueOf(acc.PersonBirthdate));
    }
    
    @testSetup
    static void setup(){
        
        Account acc1 = new Account();
        acc1 = UtilitiesTestClass.createAccount('Jose', 'PPN', '1', '12897546-9');
        insert acc1;
        
        Account acc2 = new Account();
        acc2 = UtilitiesTestClass.createAccount('Luis', 'PPNTest', '1', '19856547-9');
        insert acc2;
           
        Medico__c med = new Medico__c();
        med = UtilitiesTestClass.createMedico('test', '17584968-8', '1');
        insert med;
        
        Opportunity opp1 = new Opportunity();
        opp1 = UtilitiesTestClass.createOpportunity(med.id, acc1.id, '19856547-9');
        insert opp1;
        
        Opportunity opp2 = new Opportunity();
        opp2 = UtilitiesTestClass.createOpportunity(med.id, acc2.id, '20856547-9');
        insert opp2;
                
        String b64 = 'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z/C/HgAGgwJ/lK3Q6wAAAABJRU5ErkJggg==';
        ContentVersion contVer = new ContentVersion();
        contVer.Title = 'Test_1.png';
        contVer.FirstPublishLocationId = acc1.Id; 
        contVer.PathOnClient = 'Test_1.png';
        contVer.VersionData = EncodingUtil.base64Decode(b64);
        contVer.ContentLocation = 'S';
        contVer.TagCsv = 'New';
        insert contVer;
        
        Lead le = new Lead();
        le = UtilitiesTestClass.createLead('12345','1', '17954869-8');
        insert le;
    }
    
    @isTest
    static void createFileMethodTest(){
        String b64 = 'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z/C/HgAGgwJ/lK3Q6wAAAABJRU5ErkJggg==';
        List<Opportunity> opp = [SELECT id, Numero_de_Identificacion__c FROM Opportunity WHERE Numero_de_Identificacion__c ='19856547-9' LIMIT 1];
        system.debug('salida: '+ opp);
        List<utilitiesClass.createFileSubclass> dataList = new List<utilitiesClass.createFileSubclass>();
        utilitiesClass.createFileSubclass data1 = new utilitiesClass.createFileSubclass();
        data1.parentId = opp[0].id;
        data1.fileName = 'Test1.png';
        data1.base64Data = b64;
        data1.tag = 'ApexCreated';
        
        utilitiesClass.createFileSubclass data2 = new utilitiesClass.createFileSubclass();
        data2.parentId = opp[0].id;
        data2.fileName = 'Test2.png';
        data2.base64Data = b64;   
        data2.tag = 'ApexCreated';
        dataList.add(data1);
        dataList.add(data2);
        
        Test.startTest();
        List<Map<String, String>> returnMap = utilitiesClass.createFileMethod(dataList);
        system.assertNotEquals(null, returnMap);
        Test.stopTest();
    }
    
    @isTest
    static void createFileMethodTestFail(){
        List<utilitiesClass.createFileSubclass> dataList = new List<utilitiesClass.createFileSubclass>();

        Test.startTest();
        List<Map<String, String>> returnMap = utilitiesClass.createFileMethod(dataList);
        system.assertEquals(null, returnMap);
        Test.stopTest();
    }
    
    @isTest
    static void createFileMethodTestFail2(){
        List<Opportunity> opp = [SELECT id, Numero_de_Identificacion__c FROM Opportunity WHERE Numero_de_Identificacion__c ='19856547-9' LIMIT 1];
        
        List<utilitiesClass.createFileSubclass> dataList = new List<utilitiesClass.createFileSubclass>();
        utilitiesClass.createFileSubclass data1 = new utilitiesClass.createFileSubclass();
        data1.parentId = opp[0].id;
        data1.fileName = 'Test1.png';
        data1.base64Data = '';
        data1.tag = 'ApexCreated';
        
        dataList.add(data1);
        
        Test.startTest();
        List<Map<String, String>> returnMap = utilitiesClass.createFileMethod(dataList);
        system.assertEquals(null, returnMap);
        Test.stopTest();
    }
    
    @isTest
    static void createRelationshipFilesMethodTest(){
        List<Account> acc = [SELECT id, LastName FROM Account WHERE LastName = 'Luis' LIMIT 1];
		List<Opportunity> opp = [SELECT id, name 
                                 FROM Opportunity 
                                 WHERE AccountId =:acc[0].Id 
                                 LIMIT 1];

        List<ContentVersion> contV = [SELECT id, Title, ContentDocumentId FROM ContentVersion WHERE Title = 'Test_1.png' LIMIT 1];
        
        List<utilitiesClass.createRelationshipFilesSubclass> dataList = new List<utilitiesClass.createRelationshipFilesSubclass>();
        utilitiesClass.createRelationshipFilesSubclass data1 = new utilitiesClass.createRelationshipFilesSubclass();
        data1.parentId = opp[0].Id;
        data1.contDocId = contV[0].ContentDocumentId;       
        dataList.add(data1);
        
        Test.startTest();
        Boolean returnMap = utilitiesClass.createRelationshipFilesMethod(dataList);
        system.assertEquals(true, returnMap);
        Test.stopTest();        
    }
    
    @isTest
    static void createRelationshipFilesMethodTestFail(){
        List<utilitiesClass.createRelationshipFilesSubclass> dataList = new List<utilitiesClass.createRelationshipFilesSubclass>();

        Test.startTest();
        Boolean returnMap = utilitiesClass.createRelationshipFilesMethod(dataList);
        system.assertEquals(false, returnMap);
        Test.stopTest();        
    }
    
    @isTest
    static void createRelationshipFilesMethodTestFail2(){
        List<Account> acc = [SELECT id, LastName FROM Account WHERE LastName = 'Luis' LIMIT 1];
        List<Opportunity> opp = [SELECT id, name, AccountId  
                                 FROM Opportunity 
                                 WHERE AccountId =:acc[0].Id 
                                 LIMIT 1];

        List<utilitiesClass.createRelationshipFilesSubclass> dataList = new List<utilitiesClass.createRelationshipFilesSubclass>();
        utilitiesClass.createRelationshipFilesSubclass data1 = new utilitiesClass.createRelationshipFilesSubclass();
        data1.parentId = opp[0].Id;
        data1.contDocId = null;       
        dataList.add(data1);
        
        Test.startTest();
        Boolean returnMap = utilitiesClass.createRelationshipFilesMethod(dataList);
        system.assertEquals(false, returnMap);
        Test.stopTest();        
    }
    
    @isTest
    static void validatePicklistTestMethod(){
        List<Lead> le = [SELECT id, FirstName, LastName, status, RecordTypeId FROM Lead WHERE FirstName ='Rosa' LIMIT 1];
        
        Test.startTest();
        Boolean returnPick = utilitiesClass.validatePicklist('Lead', 'Status', le[0].Status);
        system.assertEquals(true, returnPick);
        Test.stopTest();        
    }
}