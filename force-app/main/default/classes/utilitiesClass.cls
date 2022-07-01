public without sharing class utilitiesClass {
    public static Map<String,List<String>> fieldValuesMap = new Map<String,List<String>>();
    public static Account jsonToAccount(AccountManager.cliente cli, Boolean isInsert){

        Account acc = new Account(); //Crear un objeto
        if(cli.NOMBRES != null){
            if(cli.NOMBRES.indexOf(' ') > 0){
                acc.FirstName = cli.NOMBRES.Substring(0,cli.NOMBRES.indexOf(' '));
                String longName = cli.NOMBRES.Substring(cli.NOMBRES.indexOf(' ')+1,cli.NOMBRES.length());
                if(longName.length()>40){
                    acc.MiddleName = longName.Substring(0,40).substringBeforeLast(' ');
                }else{
                    acc.MiddleName = longName;
                }
            }else{
                acc.FirstName = cli.NOMBRES;
                acc.MiddleName = '';
            }    
        }
        
        if(cli.APEPATERNO != null || isInsert){
            if(String.isBlank(cli.APEPATERNO) && String.isBlank(cli.APEMATERNO)){
                acc.LastName = 'Sin Información';
            }else{
                String completeLastName = cli.APEPATERNO + ' ' + cli.APEMATERNO;
                if(completeLastName.length()>80){
                    completeLastName = completeLastName.Substring(0,80);
                    acc.LastName = completeLastName.substringBeforeLast(' ');
                }else{
                    acc.LastName = completeLastName;
                }
            }
        }

        if(cli.IDCLIENTENATURAL != null){
            acc.PPN__c = cli.IDCLIENTENATURAL;
        }
        if(cli.TIPOIDENTIFICACION != null){
            acc.Tipo_de_Identificacion__c = picklistValidation(cli.TIPOIDENTIFICACION, 'Tipo_de_Identificacion__c') ?
            string.valueOf(cli.TIPOIDENTIFICACION) : '0'; // PICKLIST
        }
        if(cli.NUMIDENTIFICACION != null){
            
            if(!String.isBlank(cli.DVIDENTIFICACION)){
                acc.Numero_de_Identificacion__c = cli.NUMIDENTIFICACION + '-' + cli.DVIDENTIFICACION;
            }else{
                acc.Numero_de_Identificacion__c = cli.NUMIDENTIFICACION;
            }
        }
        if(cli.FLAGVIGENCIA != null){
            acc.Cliente_vigente__c = cli.FLAGVIGENCIA;
        }
        if(cli.FECHANACIMIENTO != null){
            acc.PersonBirthdate = cli.FECHANACIMIENTO != '' ? date.valueOf(cli.FECHANACIMIENTO) : null;
        }
        if(cli.SEXO != null){
            acc.Sexo__pc = cli.SEXO;
        }
        if(cli.ESTADOCIVIL != null){
            acc.Estado_civil__pc = picklistValidation(cli.ESTADOCIVIL, 'Estado_civil__pc') ?
            string.valueOf(cli.ESTADOCIVIL) : 'N'; //PICKLIST
        }
        if(cli.FECHADEFUCION != null){
            acc.Fecha_de_defuncion__pc = cli.FECHADEFUCION != '' ? date.valueOf(cli.FECHADEFUCION) : null;
        }
        if(cli.IDPREVISION != null){
            acc.Prevision__pc = picklistValidation(cli.IDPREVISION, 'Prevision__pc') ?
            string.valueOf(cli.IDPREVISION) : '0'; //PICKLIST
        }
        if(cli.IDACTIVIDAD != null){
            acc.Actividad__pc = picklistValidation(cli.IDACTIVIDAD, 'Actividad__pc') ?
            string.valueOf(cli.IDACTIVIDAD) : '0'; //PICKLIST
        }
        if(cli.FLAGACREDITADO != null){
            acc.Acreditado__pc = cli.FLAGACREDITADO;
        }
        if(cli.FLAGDEFUNCION != null){
            acc.Flag_defuncion__pc = cli.FLAGDEFUNCION;
        }
        if(cli.FLAGEMAIL != null){
            acc.PersonHasOptedOutOfEmail = !cli.FLAGEMAIL;
        }
        if(cli.IDNACIONALIDAD != null){
            acc.Nacionalidad__pc = picklistValidation(cli.IDNACIONALIDAD, 'Nacionalidad__pc') ?
            string.valueOf(cli.IDNACIONALIDAD) : '0'; //PICKLIST
        }
        if(cli.TELEFONOPARTICULAR != null){
            if(cli.TELEFONOPARTICULAR.length() > 40){
                acc.PersonHomePhone = cli.TELEFONOPARTICULAR.Substring(0,40);
            }else{
                acc.PersonHomePhone = cli.TELEFONOPARTICULAR;
            }
        }
        if(cli.CORREOPARTICULAR != null){
            acc.PersonEmail = cli.CORREOPARTICULAR;
        }
        if(cli.CELULARPARTICULAR != null){
            if(cli.CELULARPARTICULAR.length() > 40){
                acc.PersonMobilePhone = cli.CELULARPARTICULAR.Substring(0,40);
            }else{
                acc.PersonMobilePhone = cli.CELULARPARTICULAR;
            }
        }
        if(cli.IDEMPRESA != null){
            acc.Empresa__c = string.valueOf(cli.IDEMPRESA);
        }
        if(cli.DIRECCIONPARTICULAR != null){
            if(cli.DIRECCIONPARTICULAR.length() > 250){
                acc.Direccion_particular__pc = cli.DIRECCIONPARTICULAR.Substring(0,250);
            }else{
                acc.Direccion_particular__pc = cli.DIRECCIONPARTICULAR;
            }
        }
        if(cli.DIRECCIONCOMERCIAL != null){
            if(cli.DIRECCIONCOMERCIAL.length() > 250){
                acc.Direccion_Comercial_del__c = cli.DIRECCIONCOMERCIAL.Substring(0,250);
            }else{
                acc.Direccion_Comercial_del__c = cli.DIRECCIONCOMERCIAL;
            }
            
        }
        if(cli.IDCOMUNAPARTICULAR != null){
            acc.Comuna_particular__pc = picklistValidation(cli.IDCOMUNAPARTICULAR, 'Comuna_particular__pc') ?
            string.valueOf(cli.IDCOMUNAPARTICULAR) : '0'; //PICKLIST
        }
        if(cli.IDCOMUNACOMERCIAL != null){
            acc.Comuna_Comercial__c = picklistValidation(cli.IDCOMUNACOMERCIAL, 'Comuna_Comercial__c') ?
            string.valueOf(cli.IDCOMUNACOMERCIAL) : '0'; //PICKLIST
        }
        if(cli.CIUDADPARTICULAR != null){
            if(cli.CIUDADPARTICULAR.length() > 100){
                acc.Ciudad_Direccion_Particular__pc = cli.CIUDADPARTICULAR.Substring(0,100);
            }else{
                acc.Ciudad_Direccion_Particular__pc = cli.CIUDADPARTICULAR;
            }
        }
        if(cli.CIUDADCOMERCIAL != null){
            if(cli.CIUDADCOMERCIAL.length() > 100){
                acc.Ciudad_Direccion_Comercial__c = cli.CIUDADCOMERCIAL.Substring(0,100);
            }else{
                acc.Ciudad_Direccion_Comercial__c = cli.CIUDADCOMERCIAL;
            }
        }
        if(cli.IDPAISPARTICULAR != null){
            acc.Pais_particular__pc = picklistValidation(cli.IDPAISPARTICULAR, 'Pais_particular__pc') ?
            string.valueOf(cli.IDPAISPARTICULAR) : '0'; //PICKLIST
        }
        if(cli.IDPAISCOMERCIAL != null){
            acc.Pais_comercial__c = picklistValidation(cli.IDPAISCOMERCIAL, 'Pais_comercial__c') ?
            string.valueOf(cli.IDPAISCOMERCIAL) : '0'; //PICKLIST
        }
        if(cli.FECHACONSENTINF != null){
            if(cli.FECHACONSENTINF.length() > 50){
                acc.Ultima_Actualizacion_Consentimiento__c  = cli.FECHACONSENTINF.Substring(0,50);
            }else{
                acc.Ultima_Actualizacion_Consentimiento__c  = cli.FECHACONSENTINF;
            }
        }
        if(cli.CONSENTIMIENTOINF != null){
            acc.Consentimiento_Informado__c = picklistValidation(cli.CONSENTIMIENTOINF, 'Consentimiento_Informado__c') ?
            string.valueOf(cli.CONSENTIMIENTOINF) : 'Nulo'; //PICKLIST
        }

        if(cli.INDICADORFUNCIONARIO != null){
            acc.Indicador_Funcionario__c = cli.INDICADORFUNCIONARIO;
        }


        return acc;
    }
    public static void getpicklistValues(){
        List<String> fieldList = new List<String>{'Tipo_de_Identificacion__c', 
            'Estado_civil__pc',
            'Prevision__pc',
            'Actividad__pc',
            'Nacionalidad__pc',
            'Comuna_particular__pc',
            'Comuna_Comercial__c',
            'Pais_particular__pc',
            'Pais_comercial__c',
            'Consentimiento_Informado__c'};
        SObjectType objectType = Schema.getGlobalDescribe().get('Account');
        Map<String,Schema.SObjectField> mfields = objectType.getDescribe().fields.getMap();
        for(String f :fieldList){
            List<String> values = new List<String>();
            DescribeFieldResult fieldResult = mfields.get(f).getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            for(Schema.PicklistEntry t : ple){
                values.add(t.getValue());
            }
            fieldValuesMap.put(f, values);
        }
    }
    
    public static boolean picklistValidation(String recibir, String fieldName){
        boolean res = fieldValuesMap.get(fieldName).contains(recibir);
        return res;
    }
    
    /*********************************************************************************
    Name         : createRelationshipFilesMethod
    Project      : CAS DEV - Historia de Presupuesto
    Created By   : Everis
    Created Date : 11/08/2020
    Description  : Method for create files 
    VERSION  AUTHOR         DATE            Description
    1.0      Everis      11/08/2020       initial version /
    ********************************************************************************/
    public static List<Map<String, String>> createFileMethod(List<createFileSubclass> dataList) { 
        List<Map<String, String>> outputList = new List<Map<String, String>>();
        List<ContentVersion> contVerList = new LIst<ContentVersion>();

        if(dataList == null || dataList.isEmpty()){
            outputList = null;            
        }else{
            try{                
                for(createFileSubclass createFileList : dataList){
                    
                    ContentVersion contVer = new ContentVersion();
                    contVer.ContentLocation = 'S'; 
                    contVer.TagCsv = createFileList.tag;
                    contVer.VersionData = EncodingUtil.base64Decode(createFileList.base64Data);
                    contVer.Title = createFileList.fileName; //nombre del archivo
                    contVer.FirstPublishLocationId = createFileList.parentId; 
                    contVer.PathOnClient = createFileList.fileName;// nombre con la extension del archivo
                    contVerList.add(contVer);                    
                }
                 
                if(contVerList == null || contVerList.isEmpty()){                    
                    outputList = null;                                        
                }else{                    
                    insert contVerList;
                    outputList = returnContentVersionMap(contVerList);
                }
                
            }catch (Exception e) {
                outputList = null;
                system.debug('Error: '+e.getMessage());
            }    
        }        
        return outputList;
    }
    
    private static List<Map<String, String>> returnContentVersionMap(List<ContentVersion> contVerListData){
        List<Map<String, String>> outputList = new List<Map<String, String>>();
        
        for(ContentVersion recordList: contVerListData){
            Map<String, String> output = new Map<String, String>();
            
            List<ContentVersion> contVerMap = [SELECT id, Title, VersionData, FirstPublishLocationId, PathOnClient, ContentDocumentId, TagCsv 
                                               FROM ContentVersion 
                                               WHERE id =: recordList.Id 
                                               LIMIT 1]; 
            
            output.put('Id', ''+contVerMap[0].id);                        
            output.put('Title', ''+contVerMap[0].Title);
            output.put('FirstPublishLocationId', ''+contVerMap[0].FirstPublishLocationId);
            output.put('PathOnClient', ''+contVerMap[0].PathOnClient);
            output.put('ContentDocumentId', ''+contVerMap[0].ContentDocumentId);
            output.put('TagCsv', ''+contVerMap[0].TagCsv);
            output.put('VersionData', ''+contVerMap[0].VersionData);            
            outputList.add(output);
        }
        return outputList;
    }

    /*********************************************************************************
    Name         : createRelationshipFilesMethod
    Project      : CAS DEV - Historia de Presupuesto
    Created By   : Everis
    Created Date : 11/08/2020
    Description  : Method to create relation to files (other records)
    VERSION  AUTHOR         DATE            Description
    1.0      Everis      11/08/2020       initial version /
    ********************************************************************************/
    public static Boolean createRelationshipFilesMethod(List<createRelationshipFilesSubclass> dataContList){
        List<ContentDocumentLink> contRelList = new List<ContentDocumentLink>();
        Boolean outputBool= false;
        
        if(dataContList == null || dataContList.isEmpty()){       
            outputBool= false;        
        }else{
           try{
                for(createRelationshipFilesSubclass createRelList : dataContList){  
                    
                    ContentDocumentLink contRel = new ContentDocumentLink();
                    contRel.LinkedEntityId = createRelList.parentId; 
                    contRel.ContentDocumentId  = createRelList.contDocId; // id del documento a relacionar
                    contRelList.add(contRel);                    
                }
                if(contRelList == null || contRelList.isEmpty()){
                    outputBool = false;
                }else{                    
                    insert contRelList;
                    outputBool = true; 
                }
                
            }catch (Exception e) {
                system.debug('Error: '+e.getMessage());
                outputBool = false;
            } 
        } 
        return outputBool;
    }
    
    /*********************************************************************************
    Name         : validatePicklist
    Created By   : Everis
    Created Date : 01/09/2020
    Description  : Method that validate the picklist in salesforce 
    VERSION  AUTHOR         DATE            Description
    1.0      Everis      01/09/2020       initial version /
    ********************************************************************************/
    public static boolean validatePicklist(String obj, String field, String value){
        List<String> values = new List<String>();
        SObjectType objectType = Schema.getGlobalDescribe().get(obj);
        Map<String,Schema.SObjectField> mfields = objectType.getDescribe().fields.getMap();
        DescribeFieldResult fieldResult = mfields.get(field).getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry t : ple){
            values.add(t.getValue());
        }
        return values.contains(value);
        
    }
    
    /*********************************************************************************
    Name         : createFileSubclass
    Project      : CAS DEV - Historia de Presupuesto
    Created By   : Everis
    Created Date : 11/08/2020
    Description  : ---
    VERSION  AUTHOR         DATE            Description
    1.0      Everis      11/08/2020       initial version /
    ********************************************************************************/
    public class createFileSubclass {
        public Id parentId;
        public String fileName;
        public String base64Data;
        public string tag;

    }
    /*********************************************************************************
    Name         : createRelationshipFilesSubclass
    Project      : CAS DEV - Historia de Presupuesto
    Created By   : Everis
    Created Date : 11/08/2020
    Description  : ---
    VERSION  AUTHOR         DATE            Description
    1.0      Everis      11/08/2020       initial version /
    ********************************************************************************/                                                         
    public class createRelationshipFilesSubclass {
        public Id parentId;
        public Id contDocId;
    }
}