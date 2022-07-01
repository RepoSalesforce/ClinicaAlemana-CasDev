@RestResource(urlMapping='/V1/Accounts/*')
global with sharing class AccountManager {
    private static List<CLIENTE> lstToInsert = new List<CLIENTE>();
    private static RESPONSE res = new RESPONSE();
    private static integer numOk = 0;
    private static integer numError = 0;
    private static integer numCreados = 0;
    private static integer numActualizados = 0;

/*
@HttpGet
global static Account getAccountById() {
return null;
}
*/
    
    @HttpPost
    global static Response upsertAccount() {
        utilitiesClass.getpicklistValues();
        //system.debug('LISTA >>>'+ utilitiesClass.fieldValuesMap);
        //VARIABLES DE METODO Start
        ESTADOGENERAL eGeneral = new ESTADOGENERAL();
        List<RESPUESTA> answerList = new List<RESPUESTA>();
        boolean isError = false;
        set<String> setPPN = new set<String>();
        set<String> setRUT = new set<String>();
        set<String> ppnExist = new set<String>();
        //List<Account> accList = new List<Account>();
        List<Lead> leadList = new List<Lead>();
        Map<string,id> ppnIdMap = new Map<string,id>();
        Map<string,object> ppnLstObjMap = new Map<string,object>();
        Map<id,string> accIdPpnMap = new Map<id,string>();
        Map<String,List<ERROR>> ppnErrorMap = new Map<String,List<ERROR>>();
        List<Account> lstToUpdate = new List<Account>();
        List<RecordType> rtList = new List<RecordType>();
        Database.SaveResult[] srUpdate;
        List<Account> lstToInsert = new List<Account>();
        Database.SaveResult[] srInsert;
        //VARIABLES DE METODO End
        
        //Get RecordType
        rtList = [SELECT ID, DeveloperName FROM RecordType WHERE DeveloperName = 'PersonAccount'];
        //system.debug('INITIAL CPU TIME'+Limits.getCpuTime());
        //system.debug('Limite de CPU :'+Limits.getLimitCpuTime());
        Request newRequest = (Request)JSON.deserialize(RestContext.request.requestBody.toString(), Request.class);

        //Get PPN List and RUT List from service
        for(CLIENTE cli: newRequest.CLIENTES){
            if(!String.isEmpty(cli.NUMIDENTIFICACION) && !String.isEmpty(cli.DVIDENTIFICACION)){
                setRUT.add(cli.NUMIDENTIFICACION + '-' + cli.DVIDENTIFICACION);
            }
            setPPN.add(cli.IDCLIENTENATURAL);
        }
        //system.debug(' PPN SET : ' + setPPN);
        //system.debug(' RUT SET : ' + setRUT);
        //Get a map with PPN AND ACCID
        if(!setPPN.isEmpty()){
            //accList = ;
            for(Account acc: [SELECT id, name, ppn__c FROM account WHERE ppn__c =: setPPN]){
                ppnExist.add(acc.ppn__c);
                ppnIdMap.put(acc.ppn__c,acc.id);
                accIdPpnMap.put(acc.id,acc.ppn__c);
            }
        }        
        //system.debug('ppnExist has this: ' + ppnExist);
        //system.debug('Your ppnIdMap has this: ' + ppnIdMap);
        //system.debug('Your accIdPpnMap has this: ' + accIdPpnMap);
        //system.debug('CPU TIME BEFORE VALIDATE'+Limits.getCpuTime());
        // Validate Errors in data Start////////////////////////////////////
        for(CLIENTE cli: newRequest.CLIENTES){
            List<ERROR> resErrorList = new List<ERROR>();
            //system.debug('cli '+cli);
            // Lista de errores a ser devuelta
            resErrorList = ValidateData(cli);
            if(!resErrorList.isEmpty()){
                ppnErrorMap.put(cli.IDCLIENTENATURAL ,resErrorList);
            }else{
                if(ppnIdMap.get(cli.IDCLIENTENATURAL) != null){
                    Account acco = new Account();
                    acco = utilitiesClass.jsonToAccount(cli, false);
                    acco.id = ppnIdMap.get(cli.IDCLIENTENATURAL);
                    lstToUpdate.add(acco);
                }else{
                    Account accToInsert = new Account();
                    accToInsert = utilitiesClass.jsonToAccount(cli, true);
                    accToInsert.RecordTypeId = rtList[0].id;
                    lstToInsert.add(accToInsert);
                    //system.debug('SE AGREGO AL INSERT LIST '+ lstToInsert);
                }
            }    
        }
        // Validate Errors in data End////////////////////////////////////
        //system.debug('CPU TIME BEFORE UPDATE'+Limits.getCpuTime());
        // LOGIC TO UPDATE START ////////////////////////////////////////
        //Validate Acc Update List 
        if(lstToUpdate != null && !lstToUpdate.isEmpty()) {
            srUpdate = database.update(lstToUpdate, false);
            //Database.SaveResult[] result = Database.update(lstAccToUpdate,false);
            for(Integer i=0; i < srUpdate.size(); i++) {
                List<ERROR> errList = new List<ERROR>();
                if(srUpdate.get(i).isSuccess()) {
                    //System.debug('Records are updated Successfully');
                    //System.debug('Successfully updated account. Account ID: ' + srUpdate.get(i));
                    numActualizados++;
                } 
                else if(!srUpdate.get(i).isSuccess()) {

                    //system.debug('ID --->'+lstToUpdate.get(i).id);
                    //system.debug('PPN ---->'+lstToUpdate.get(i).ppn__c);
                    Database.Error[] errors =  srUpdate.get(i).getErrors();
                    for(Database.Error err :errors){
                        errList.add(createError(err.getFields()[0],err.getStatusCode() + ': ' + err.getMessage()));
                    }
                    //system.debug('ERROR APEX CREATE PPN --->'+accIdPpnMap.get(lstToUpdate.get(i).id));
                    ppnErrorMap.put(accIdPpnMap.get(lstToUpdate.get(i).id),errList);
                    //system.debug('ppnErrorMap LIST UPDATE '+ppnErrorMap);
                }
            }
            
        }
        // LOGIC TO UPDATE END ////////////////////////////////////////
        //system.debug('CPU TIME BEFORE INSERT'+Limits.getCpuTime());
        // LOGIC TO INSERT START ////////////////////////////////////////
        //Validate Acc Insert List
        if(lstToInsert != null && !lstToInsert.isEmpty()) {
            srInsert = database.insert(lstToInsert, false);
            //Database.SaveResult[] result = Database.update(lstAccToUpdate,false);
            for(Integer i=0; i < srInsert.size(); i++) {
                List<ERROR> errList = new List<ERROR>();
                if(srInsert.get(i).isSuccess()) {
                    //System.debug('Records are INSERT Successfully');
                    //System.debug('Successfully inserted account. Account ID: ' + srInsert.get(i));
                    numCreados++;
                } 
                else if(!srInsert.get(i).isSuccess()) {

                    //system.debug('ID --->'+lstToInsert.get(i).id);
                    //system.debug('PPN ---->'+lstToInsert.get(i).ppn__c);
                    Database.Error[] errors =  srInsert.get(i).getErrors();
                    //system.debug('ERROR APEX CREATE PPN --->'+accIdPpnMap.get(lstToInsert.get(i).id));
                    for(Database.Error err :errors){
                        //system.debug(err);
                        if(!err.getFields().isempty()){
                            errList.add(createError(err.getFields()[0],err.getStatusCode() + ': ' + err.getMessage()));
                        }
                    }
                    //system.debug('ERROR APEX CREATE PPN --->'+accIdPpnMap.get(lstToInsert.get(i).id));
                    ppnErrorMap.put(lstToInsert.get(i).ppn__c,errList);
                    //system.debug('ppnErrorMap LIST UPDATE '+ppnErrorMap);
                }
            }
            
        }
        // LOGIC TO INSERT END ////////////////////////////////////////  
        /*
        if(!lstToInsert.isEmpty() && false){
            System.debug('UPDATE'+lstToInsert);
            srInsert = database.insert(lstToInsert, false);
        }
        
        if(srInsert != null){
            //Validate each record has been updated
            for (Database.SaveResult sr : srInsert) {
                // Respuesta por cada cliente
                System.debug('SaveResult Insert item -->'+sr);
                List<ERROR> errList = new List<ERROR>();
                if (sr.isSuccess()) {
                    // Operation was successful, so get the ID of the record that was processed
                    System.debug('Successfully inserted account. Account ID: ' + sr.getId());
                    numCreados++;
                }
                else {
                    // Operation failed, so get all errors
                    for(Database.Error err : sr.getErrors()) {
                        errList.add(createError('ERROR APEX',err.getStatusCode() + ': ' + err.getMessage()));                  
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('Account fields that affected this error: ' + err.getFields());
                    }
                }
                if(!errList.isEmpty()){
                    ppnErrorMap.put(accIdPpnMap.get(sr.getId()),errList);
                }
            }
        }
        */
        
              
        
        //FLAGVIGENCIANOCLIENTE
        
        // LOGIC TO UPDATE LEADS START ////////////////////////////////////////
        if(!setRUT.isEmpty()){
            leadList = [SELECT id, Numero_de_identificacion__c, Vigente__c 
                       FROM lead 
                       WHERE Numero_de_identificacion__c =: setRUT];
            for(lead ld: leadList){
                ld.Vigente__c = false;
            }
            if(!leadList.isEmpty()){
                update leadList;
            }
        }
        
        // LOGIC TO UPDATE LEADS END ////////////////////////////////////////     
        
        for(CLIENTE cli: newRequest.CLIENTES){
            // Respuesta por cada cliente
            RESPUESTA answer = new RESPUESTA();
            // ANSWER - Devolver lo ingresado
            answer.DATA = cli;
            if(ppnErrorMap.get(cli.IDCLIENTENATURAL) != null && !ppnErrorMap.get(cli.IDCLIENTENATURAL).isEmpty()){
                //system.debug('ENTRO EN ERROR el cliente: '+cli.IDCLIENTENATURAL+'ERROR: ' +ppnErrorMap.get(cli.IDCLIENTENATURAL));
                answer.ESTADO = 'NOOK';
                answer.ERRORES = ppnErrorMap.get(cli.IDCLIENTENATURAL);
                numError++;
            }else{
                numOk++;
                answer.ESTADO = 'OK';
            }
            answerList.add(answer);
            //ERRORES = resErrorList;
            //system.debug('ANSWER '+json.serializePretty(answer));
        }
        // Cantidad de datos recibidos
        res.RECIBIDO = newRequest.CLIENTES.size();
        res.RESPUESTA = answerList;
        res.ERROR = numError;
        res.OK = numOk;
        res.CREADOS = numCreados;
        res.ACTUALIZADOS = numActualizados;
        res.IDENVIO = newRequest.IDENVIO;
        if(res.ERROR > 0){
            eGeneral.CODIGO = 1;
            eGeneral.MENSAJE = 'Se ha producido un error de validación de datos en al menos un registro. Por favor revisar e intentar nuevamente.';
        }else{
            eGeneral.CODIGO = 0;
            eGeneral.MENSAJE = 'Los datos se han procesado exitosamente.';
        }
        res.ESTADOGENERAL = eGeneral;
        Datetime now = Datetime.now();
        Integer offset = UserInfo.getTimezone().getOffset(now);
        Datetime local = now.addSeconds(offset/1000);
        res.FECHARESPUESTA = System.now().format('YYYY-MM-dd HH:mm:ss');
        //res.FECHARESPUESTA = String.valueOf(local);
        res.FECHAENVIO = newRequest.FECHAENVIO;
        return res;
    }
    
    /*
@HttpDelete
global static void deleteCase() {
}     
*/
    /*
@HttpPut
global static ID upsertCase(String subject, String status,
String origin, String priority, String id) {

return null;
}
*/
    /*
@HttpPatch
global static ID updateCaseFields() {
}   
*/
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //
    //      METHODS
    //
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////  
    
    /* Validaciones */
    private static List<ERROR> ValidateData(CLIENTE cli){
        List<ERROR> errList = new List<ERROR>();
        
        /*-Existencia de campo PPN (IDCLIENTENATURAL) -----> NO NULL*/
        if(String.isBlank(cli.IDCLIENTENATURAL)){
            //CREATE ERROR AND ADD TO RESPONSE 
            errList.add(createError('IDCLIENTENATURAL','ERROR: IDCLIENTENATURAL VALUE IS MISSING'));
        }
        if(String.isBlank(cli.NUMIDENTIFICACION)){
            //ADD ERROR AND ADD TO RESPONSE  ---> NUMIDENTIFICACION NULL
            errList.add(createError('NUMIDENTIFICACION','ERROR: NUMIDENTIFICACION VALUE IS MISSING'));
        }
        if(String.isBlank(cli.IDEMPRESA)){
            //ADD ERROR AND ADD TO RESPONSE  ---> IDEMPRESA NULL
            errList.add(createError('IDEMPRESA','ERROR: IDEMPRESA VALUE IS MISSING'));
        }
        if(String.isBlank(cli.SEXO)){
            //ADD ERROR AND ADD TO RESPONSE  ---> SEXO NULL
            errList.add(createError('SEXO','ERROR: SEXO VALUE IS MISSING'));
        }
        if(String.isBlank(cli.FECHANACIMIENTO)){
            //ADD ERROR AND ADD TO RESPONSE  ---> FECHANACIMIENTO NULL
            errList.add(createError('FECHANACIMIENTO','ERROR: FECHANACIMIENTO VALUE IS MISSING'));
        }else if(!validateDateFormat(cli.FECHANACIMIENTO)){
            //ADD ERROR AND ADD TO RESPONSE  ---> FECHANACIMIENTO BAD FORMAT
            errList.add(createError('FECHANACIMIENTO','FECHANACIMIENTO VALUE IS AN INVALID DATE, DATE FORMAT SHOULD BE YYYY-MM-DD'));
        }
        if(!String.isBlank(cli.FECHADEFUCION) && !validateDateFormat(cli.FECHADEFUCION)){
            //ADD ERROR AND ADD TO RESPONSE  ---> FECHADEFUCION BAD FORMAT
            errList.add(createError('FECHADEFUCION','FECHADEFUCION VALUE IS AN INVALID DATE, DATE FORMAT SHOULD BE YYYY-MM-DD'));
        }
        return errList;
    }
    
    /* REGEX DATE VALIDATION */
    private static boolean validateDateFormat(string dateToValidate){
        //system.debug('DATE ----> '+ dateToValidate);
        string regex = '^(((\\d{4}-((0[13578]-|1[02]-)(0[1-9]|[12]\\d|3[01])|(0[13456789]-|1[012]-)(0[1-9]|[12]\\d|30)|02-(0[1-9]|1\\d|2[0-8])))|((([02468][048]|[13579][26])00|\\d{2}([13579][26]|0[48]|[2468][048])))-02-29)){0,10}$';
        Pattern datePattern = Pattern.compile(regex);
        Matcher dateMatcher = datePattern.Matcher(dateToValidate);
        //system.debug('DATE VALIDATION ----> '+ dateMatcher.matches());
        return dateMatcher.matches();
    }
    /* CREATE ERROR AND RETURN */
    private static ERROR createError(String fName, String errorDesc){
        ERROR err = new ERROR();
        err.CAMPO = fName;
        err.ERROR = errorDesc;
        return err;
    }
    
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //
    //      WRAPPERS
    //
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////      
    /* REQUEST WRAPPER START*/
    Global class Request {
        public String FECHAENVIO;
        public Integer IDENVIO;
        public List<CLIENTE> CLIENTES;
    }

    public class CLIENTE {
        public String IDCLIENTENATURAL;
        public String TIPOIDENTIFICACION;
        public String NUMIDENTIFICACION;
        public String DVIDENTIFICACION;
        public Boolean FLAGVIGENCIA;
        public String FECHANACIMIENTO;
        public String SEXO;
        public String ESTADOCIVIL;
        public String FECHADEFUCION;
        public String IDPREVISION;
        public String IDACTIVIDAD;
        public Boolean FLAGACREDITADO;
        public Boolean FLAGEMAIL;
        public Boolean FLAGDEFUNCION;
        public String NOMBRES;
        public String APEPATERNO;
        public String APEMATERNO;
        public String IDNACIONALIDAD;
        public String TELEFONOPARTICULAR;
        public String CORREOPARTICULAR;
        public String CELULARPARTICULAR;
        public String DIRECCIONPARTICULAR;
        public String DIRECCIONCOMERCIAL;
        public String IDEMPRESA;
        public String IDCOMUNAPARTICULAR;
        public String CIUDADPARTICULAR;
        public String IDCOMUNACOMERCIAL;
        public String CIUDADCOMERCIAL;
        public String IDPAISPARTICULAR;
        public String IDPAISCOMERCIAL;
        public String FECHACONSENTINF;
        public String CONSENTIMIENTOINF;
        public Boolean INDICADORFUNCIONARIO;
    }
    /* REQUEST WRAPPER END*/
    
    /* RESPONSE WRAPPER START*/
    Global class RESPONSE {
        public String FECHAENVIO;
        public String FECHARESPUESTA;
        public Integer IDENVIO;
        public Integer RECIBIDO;
        public Integer OK;
        public Integer ERROR;
        public Integer CREADOS;
        public Integer ACTUALIZADOS;
        public ESTADOGENERAL ESTADOGENERAL;
        public List<RESPUESTA> RESPUESTA;
    }
    
    public class ESTADOGENERAL {
        public Integer CODIGO;
        public String MENSAJE;
    }
    
    public class ERROR {
        public String CAMPO;
        public String ERROR;
    }
    
    public class RESPUESTA {
        public List<ERROR> ERRORES;
        public String ESTADO;
        public CLIENTE DATA;
    }
    /* RESPONSE WRAPPER END*/
}