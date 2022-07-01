@RestResource(urlMapping='/V1/Cases/*')
global with sharing class CaseManager {

    @HttpGet
    global static void getCaseById() {
        
        //String strCaseId = '';
        //String strValidationCode = '';
        String strEmail = '';

        RestRequest restReq = RestContext.request;
        RestResponse restRes = RestContext.response;
        
        //RESPONSE res = new RESPONSE();
        //state sta = new state();
        
        Case resultCase = new Case();
        
        //strCaseId = restReq.params.get('caseId');
        strEmail = restReq.params.get('email');

       // System.debug('strValidationCode: ' + strValidationCode);
        System.debug('strEmail: ' + strEmail);

       // RestRequest request = RestContext.request;
        // grab the caseId from the end of the URL
        //String caseId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        
		Case[] cases =  [SELECT Status, Origin, Priority, Subject, CaseNumber, 
                                SRV_Web_Numero_de_documento__c, SRV_Web_Tipo_de_documento__c,  
                                SuppliedName, SuppliedPhone, PCI_Codigo_Pais_Telefono__c, SuppliedEmail, 
                                SRV_Web_Fecha_de_nacimiento__c, PCI_Sexo__c, SRV_Web_Edad__c, PCI_Categoria__c, PCI_Subcategoria__c, Description, RecordTypeId
        				FROM Case
                        where SuppliedEmail = :strEmail
                       // and Codigo_Verificacion__c = :strValidationCode
                        order by LastModifiedDate desc];    
        
        if(cases.size() > 0){
			System.debug('**Con Resultados');
            System.debug(cases);
            resultCase = cases[0];
            restRes.responseBody = Blob.valueOf(JSON.serialize(resultCase));
            restRes.addHeader('Content-Type','application/json');
            restRes.statusCode=200;  
        } else{
        	System.debug('**Sin Resultados');
            restRes.addHeader('Content-Type','application/json');
            restRes.statusCode=404;     
            /*sta.CODIGO = '404';
            sta.MENSAJE = 'Case Not found';
            res.ESTADO = sta;*/
        }
        //return res;
    }
    
    @HttpPost
    global static void createCaseWithFiles() {
        Case newCase = new Case();
        Case createdCase = new Case();
        
        //Opportunity opp = new Opportunity();
        //Quote q = new Quote();
        // RESPONSE res = new RESPONSE();
        //state sta = new state();
        
        //Objetos asociados a archivos
        List<ResFile> resFileList = new List<ResFile>();
        List<Map<String, String>> result = new List<Map<String, String>>();
        List<UtilitiesClass.createFileSubclass> files = new List<UtilitiesClass.createFileSubclass>();
        List<utilitiesClass.createRelationshipFilesSubclass> linkFiles = new List<utilitiesClass.createRelationshipFilesSubclass>();
        
		REQUEST newRequest = (REQUEST)JSON.deserialize(RestContext.request.requestBody.toString(), REQUEST.class);
        //Date.parse(newRequest.Caso.SRV_Web_Fecha_de_nacimiento__c);
		System.debug('*****REQUEST****');
        System.debug(newRequest);
        
        newCase = newRequest.Caso;
        
        /***Asignación de código de Validación**/
        Integer len = 5;
        Blob blobKey = crypto.generateAesKey(128);
        String key = EncodingUtil.convertToHex(blobKey);
        //String generatedValidationCode = key.substring(0,len);
        //System.debug('************generatedValidationCode: '+generatedValidationCode);        
        //newCase.Codigo_Verificacion__c= generatedValidationCode;
        
 		String recordTypeId =Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('PCI_Caso_Imagen').getRecordTypeId();
        newCase.RecordTypeId=recordTypeId;
        newCase.PCI_Subcategoria__c=newCase.Subject;
        newCase.PCI_Categoria__c='Solicitud agendamiento de hora';
        newCase.Description='Solicitud agendamiento de hora '+newCase.Subject;
        System.debug('*****newCase****');
        System.debug(newCase);

		insert newCase;

		createdCase = [SELECT Id, Status, Origin, Priority, Subject, CaseNumber, 
                              SRV_Web_Numero_de_documento__c, SRV_Web_Tipo_de_documento__c, 
                              SuppliedName, SuppliedPhone, PCI_Codigo_Pais_Telefono__c, SuppliedEmail, 
                              SRV_Web_Fecha_de_nacimiento__c, PCI_Sexo__c, SRV_Web_Edad__c, PCI_Categoria__c, PCI_Subcategoria__c, Description, RecordTypeId
                       FROM Case WHERE Id = :newCase.ID];
       
        //Create Files
        if(newRequest.Files != null && !newRequest.Files.isempty() && newCase != null){
			System.debug('Create Files');
            //Create Files List to Case
            for(file f:newRequest.Files){
                System.debug('Create Files List to Case');
                UtilitiesClass.createFileSubclass fileToCreate = new UtilitiesClass.createFileSubclass();
                fileToCreate.parentId = newCase.id;
                fileToCreate.fileName = f.NOMBREARCHIVO;
                fileToCreate.base64Data = f.DATA;
                fileToCreate.tag = 'ApexCreated';
                files.add(fileToCreate);
            }
            //Create File in Case
            result = utilitiesClass.createFileMethod(files);
            for(Map<String, String> file : result){
                resFile rfile = new resFile();
                rfile.NOMBREARCHIVO = file.get('Title');
                resFileList.add(rfile);
            }
        }
        RestResponse restRes = RestContext.response;
       // System.debug('RESPONSE');
		//System.debug(restRes);

        if (createdCase != null){
            restRes.responseBody = Blob.valueOf(JSON.serialize(createdCase));
            restRes.addHeader('Content-Type','application/json');
            restRes.statusCode=200;  
        }else{
            restRes.statusCode=404;                  
        }
    }  
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //
    //      WRAPPERS
    //
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////      
    /* REQUEST WRAPPER START*/
    Global class REQUEST {
        public Case Caso;
        public List<File> FILES;
    }
    public class File{
        public String NOMBREARCHIVO;
        public String DATA;
    }
    /* REQUEST WRAPPER END*/
    
    /* RESPONSE WRAPPER START*/
    Global class RESPONSE {
		//public state ESTADO;
        public Case Caso;
    }
    public class state{
        public String CODIGO;
        public String MENSAJE;
    }
    public class ResFile{
        public String NOMBREARCHIVO;
    }
    /* RESPONSE WRAPPER END*/
}