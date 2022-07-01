@isTest
private class AccountManager_Test{

    @isTest
    static void upsertAccountTest(){

        AccountManager.Request rqst = createRequestForTesting();
        //String json = '{ "IDCLIENTENATURAL" : "'+rqst.CLIENTES[0].IDCLIENTENATURAL+'", "TIPOIDENTIFICACION" : "'+rqst.CLIENTES[0].TIPOIDENTIFICACION+'", "NUMIDENTIFICACION" : "'+rqst.CLIENTES[0].NUMIDENTIFICACION+'", "DVIDENTIFICACION" : "'+rqst.CLIENTES[0].DVIDENTIFICACION+'", "FLAGVIGENCIA" : "'+rqst.CLIENTES[0].FLAGVIGENCIA+'", "FECHANACIMIENTO" : "'+rqst.CLIENTES[0].FECHANACIMIENTO+'", "SEXO" : "'+rqst.CLIENTES[0].SEXO+'", "ESTADOCIVIL" : "'+rqst.CLIENTES[0].ESTADOCIVIL+'", "FECHADEFUCION" : "'+rqst.CLIENTES[0].FECHADEFUCION+'", "IDPREVISION" : "'+rqst.CLIENTES[0].IDPREVISION+'", "IDACTIVIDAD" : "'+rqst.CLIENTES[0].IDACTIVIDAD+'", "FLAGACREDITADO" : "'+rqst.CLIENTES[0].FLAGACREDITADO+'", "FLAGEMAIL" : "'+rqst.CLIENTES[0].FLAGEMAIL+'", "FLAGDEFUNCION" : "'+rqst.CLIENTES[0].FLAGDEFUNCION+'", "NOMBRES" : "'+rqst.CLIENTES[0].NOMBRES+'", "APEPATERNO" : "'+rqst.CLIENTES[0].APEPATERNO+'", "APEMATERNO" : "'+rqst.CLIENTES[0].APEMATERNO+'", "IDNACIONALIDAD" : "'+rqst.CLIENTES[0].IDNACIONALIDAD+'", "TELEFONOPARTICULAR" : "'+rqst.CLIENTES[0].TELEFONOPARTICULAR+'", "CORREOPARTICULAR" : "'+rqst.CLIENTES[0].CORREOPARTICULAR+'", "CELULARPARTICULAR" : "'+rqst.CLIENTES[0].CELULARPARTICULAR+'", "DIRECCIONPARTICULAR" : "'+rqst.CLIENTES[0].DIRECCIONPARTICULAR+'", "DIRECCIONCOMERCIAL" : "'+rqst.CLIENTES[0].DIRECCIONCOMERCIAL+'", "IDEMPRESA" : "'+rqst.CLIENTES[0].IDEMPRESA+'", "IDCOMUNAPARTICULAR" : "'+rqst.CLIENTES[0].IDCOMUNAPARTICULAR+'", "CIUDADPARTICULAR" : "'+rqst.CLIENTES[0].CIUDADPARTICULAR+'", "IDCOMUNACOMERCIAL" : "'+rqst.CLIENTES[0].IDCOMUNACOMERCIAL+'", "CIUDADCOMERCIAL" : "'+rqst.CLIENTES[0].CIUDADCOMERCIAL+'", "IDPAISPARTICULAR" : "'+rqst.CLIENTES[0].IDPAISPARTICULAR+'", "IDPAISCOMERCIAL" : "'+rqst.CLIENTES[0].IDPAISCOMERCIAL+'"}';

        AccountManager.RESPONSE respuesta = new AccountManager.RESPONSE();
        RestRequest req = new RestRequest();
        
        req.requestURI = '/services/apexrest/V1/Accounts/';  //Request URL
        req.httpMethod = 'POST'; //HTTP Request Type
        String json = JSON.serialize(rqst);
        req.requestBody = Blob.valueof(json);
        RestContext.request = req;
        
        Test.startTest();
            respuesta = AccountManager.upsertAccount();
            System.assertEquals(1, respuesta.CREADOS);
            System.assertEquals(12345678, respuesta.IDENVIO);
            System.assertEquals(0, respuesta.ESTADOGENERAL.CODIGO);
        Test.StopTest();
    }

    @isTest
    static void upsertAccountTestConErrores(){

        AccountManager.Request rqst = createRequestForTesting();
        rqst.IDENVIO = 87654321;
        rqst.CLIENTES[0].IDCLIENTENATURAL = null;
        rqst.CLIENTES[0].NUMIDENTIFICACION = null;
        rqst.CLIENTES[0].IDEMPRESA = null;
        rqst.CLIENTES[0].SEXO = null;
        rqst.CLIENTES[0].FECHANACIMIENTO = null;

        AccountManager.RESPONSE respuesta = new AccountManager.RESPONSE();
        RestRequest req = new RestRequest();
        
        req.requestURI = '/services/apexrest/V1/Accounts/';  //Request URL
        req.httpMethod = 'POST'; //HTTP Request Type
        String json = JSON.serialize(rqst);
        req.requestBody = Blob.valueof(json);
        RestContext.request = req;
        
        Test.startTest();
            respuesta = AccountManager.upsertAccount();
            System.assertEquals(0, respuesta.CREADOS);
            System.assertEquals(87654321, respuesta.IDENVIO);
            System.assertEquals(1, respuesta.ESTADOGENERAL.CODIGO);
        Test.StopTest();
    }

    @isTest
    static void upsertAccountTestErrorCrear(){

        AccountManager.Request rqst = createRequestForTesting();
        rqst.CLIENTES[0].SEXO = 'Z';
        
        AccountManager.RESPONSE respuesta = new AccountManager.RESPONSE();
        RestRequest req = new RestRequest();
        
        req.requestURI = '/services/apexrest/V1/Accounts/';  //Request URL
        req.httpMethod = 'POST'; //HTTP Request Type
        String json = JSON.serialize(rqst);
        req.requestBody = Blob.valueof(json);
        RestContext.request = req;
        
        Test.startTest();
            respuesta = AccountManager.upsertAccount();
            System.assertEquals(0, respuesta.CREADOS);
            System.assertEquals(12345678, respuesta.IDENVIO);
            System.assertEquals(1, respuesta.ESTADOGENERAL.CODIGO);
        Test.StopTest();
    }

    @isTest
    static void upsertAccountTestErrorActualizar(){

        Account acc = new Account(PPN__c='123456',LastName='ApPaterno ApMaterno',Numero_de_Identificacion__c='15132985-3',Sexo__pc='M',Empresa__c='2',PersonBirthdate=date.valueOf('1983-03-28'));
		insert acc;

        AccountManager.Request rqst = createRequestForTesting();
        rqst.CLIENTES[0].SEXO = 'Z';
        
        AccountManager.RESPONSE respuesta = new AccountManager.RESPONSE();
        RestRequest req = new RestRequest();
        
        req.requestURI = '/services/apexrest/V1/Accounts/';  //Request URL
        req.httpMethod = 'POST'; //HTTP Request Type
        String json = JSON.serialize(rqst);
        req.requestBody = Blob.valueof(json);
        RestContext.request = req;
        
        Test.startTest();
            respuesta = AccountManager.upsertAccount();
            System.assertEquals(0, respuesta.ACTUALIZADOS);
            System.assertEquals(12345678, respuesta.IDENVIO);
            System.assertEquals(1, respuesta.ESTADOGENERAL.CODIGO);
        Test.StopTest();
    }

    static AccountManager.CLIENTE createClienteForTesting(){
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
        
        return cli;
    }

    static AccountManager.Request createRequestForTesting(){
        AccountManager.Request reque = new AccountManager.Request();
        AccountManager.CLIENTE clnt = createClienteForTesting();
        List<AccountManager.CLIENTE> lstClnt = new List<AccountManager.CLIENTE>();
        lstClnt.add(clnt);
        reque.IDENVIO = 12345678;
        reque.FECHAENVIO = '2020-06-30';
        reque.CLIENTES = lstClnt;

        return reque;
    }

}