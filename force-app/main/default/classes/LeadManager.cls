/*********************************************************************************
    Name         : LeadManager
    Work         : Integración Objeto de Leads
    Created By   : Everis
    Created Date : 27/08/2020
    Description  : Apex class for service /V1/Lead/ 
    VERSION  AUTHOR         DATE            Description
    1.0      Everis      27/08/2020       initial version /
**********************************************************************************/
@RestResource(urlMapping='/V1/Lead/*')
global with sharing class LeadManager {
    
    /*********************************************************************************
    Name         : createLeadWithFiles
    Created By   : Everis
    Created Date : 27/08/2020
    Description  : Post Method for create Lead with files 
    VERSION  AUTHOR         DATE            Description
    1.0      Everis      27/08/2020       initial version /
    ********************************************************************************/
    @HttpPost
    global static Response createLeadWithFiles() {
        Lead leadRequest = new Lead();
        Response resp = new Response();
        List<ResFile> resFileListOut = new List<ResFile>();
        
        //GET de body from request
        Request newRequest = (Request)JSON.deserialize(RestContext.request.requestBody.toString(), Request.class);
        leadRequest = newRequest.LEAD;
               
        boolean pickStat = utilitiesClass.validatePicklist('Lead','Status',leadRequest.Status);
        
        if(leadRequest != null && !String.isEmpty(leadRequest.FirstName) 
           && !String.isEmpty(leadRequest.LastName) && !String.isEmpty(leadRequest.Status)
           && !String.isEmpty(leadRequest.RecordTypeId) && pickStat){
               
               List<Lead> leadExist = [SELECT id FROM Lead WHERE id =:leadRequest.Id LIMIT 1];
               
               validatePicklistDefault(leadRequest);

               if(leadExist.isEmpty()){
                   Database.DMLOptions dmoIns = new Database.DMLOptions();
                   dmoIns.assignmentRuleHeader.useDefaultRule= true;          
                   leadRequest.setOptions(dmoIns);
                   //Insert Lead
                   insert leadRequest; 
                   
                   resFileListOut = createFile(newRequest.FILE, leadRequest.id);
                   resp = CreateResponse(newRequest, leadRequest,'CREATED LEAD ', '0', resFileListOut);
                   
               }else{
                   //Upsert Lead
                   upsert leadRequest;
                   
                   resFileListOut = createFile(newRequest.FILE, leadRequest.id);
                   resp = CreateResponse(newRequest, leadRequest,'UPSERTED LEAD ', '0', resFileListOut); 
               }
               
           }else{
               if(!pickStat){
                   resp = CreateResponse(newRequest, leadRequest,'Error, valor incorrecto para el campo Status = '+leadRequest.Status, '-2', resFileListOut); 
              
               }else{
                   resp = CreateResponse(newRequest, leadRequest,'Error, faltan ingresar campos obligatorios'
                                         +' FirstName = '+ leadRequest.FirstName
                                         +', LastName = '+ leadRequest.LastName 
                                         +', Status = '+ leadRequest.Status
                                         +', RecordTypeId = '+ leadRequest.RecordTypeId, '-2', resFileListOut);
               }
           }
        return resp;
    }
    /*********************************************************************************
    Name         : validatePicklistDefault
    Created By   : Everis
    Created Date : 08/09/2020
    Description  : Method that validate value default from picklist
    VERSION  AUTHOR         DATE            Description
    1.0      Everis      08/09/2020       initial version /
    ********************************************************************************/
    private static void validatePicklistDefault(Lead leadRequest){
        
		boolean pickStatCan = utilitiesClass.validatePicklist('Lead','LeadSource',leadRequest.LeadSource);
        boolean pickTypIden = utilitiesClass.validatePicklist('Lead','Tipo_de_identificacion__c',leadRequest.Tipo_de_identificacion__c);
		boolean pickSegComp = utilitiesClass.validatePicklist('Lead','Seguro_Complementario__c',leadRequest.Seguro_Complementario__c);
		boolean pickTypPart = utilitiesClass.validatePicklist('Lead','Tipo_Parto__c',leadRequest.Tipo_Parto__c);

        if(!pickStatCan){
            leadRequest.LeadSource = 'O'; 
        }if(!pickTypIden){
            leadRequest.Tipo_de_identificacion__c = '0'; 
        }if(!pickSegComp){
            leadRequest.Seguro_Complementario__c = 'Otro'; 
        }if(!pickTypPart){
            leadRequest.Tipo_Parto__c = 'Sin informacion'; 
        }
    }
    
    /*********************************************************************************
    Name         : createFile
    Created By   : Everis
    Created Date : 28/08/2020
    Description  : Method to create Lead files 
    VERSION  AUTHOR         DATE            Description
    1.0      Everis      28/08/2020       initial version /
    ********************************************************************************/
    private static List<ResFile> createFile(List<File> files, id IdLead){
        List<ResFile> resFileList = new List<ResFile>();
        List<Map<String, String>> result = new List<Map<String, String>>();
        List<UtilitiesClass.createFileSubclass> filesList = new List<UtilitiesClass.createFileSubclass>();
        
        //Create Files
        if(files != null && !files.isEmpty()){
            for(File fil : files){
                UtilitiesClass.createFileSubclass fileToCreate = new UtilitiesClass.createFileSubclass();
                fileToCreate.parentId = IdLead;
                fileToCreate.fileName = fil.NOMBREARCHIVO;
                fileToCreate.base64Data = fil.DATA;
                fileToCreate.tag = 'IntegrationCreated';
                filesList.add(fileToCreate);
            }
            //Create File in Lead
            result = utilitiesClass.createFileMethod(filesList);
            
            //Return files created
            for(Map<String, String> file : result){
                resFile rfile = new resFile();
                rfile.NOMBREARCHIVO = file.get('Title');
                resFileList.add(rfile);
            }            
        }        
        return resFileList;
    }
    
    /*********************************************************************************
    Name         : CreateResponse
    Created By   : Everis
    Created Date : 27/08/2020
    Description  : Method Response 
    VERSION  AUTHOR         DATE            Description
    1.0      Everis      27/08/2020       initial version /
    ********************************************************************************/
    private static Response CreateResponse(Request resquest, Lead leadRequest, String msg, String code, List<ResFile> resFileList){
        Response respuesta = new Response();
        State estado = new State();
        
        estado.CODIGO = code;
        estado.MENSAJE = msg;
        respuesta.ESTADO = estado;
        respuesta.FECHAENVIO = resquest.FECHAENVIO;
        respuesta.IDENVIO = resquest.IDENVIO;
        respuesta.FILE = resFileList;
        respuesta.LEAD = leadRequest;
        return respuesta;
    }
    
    
    /*********************************************************************************
    Name         : Request
    Created By   : Everis
    Created Date : 27/08/2020
    Description  : Wrapper class Request 
    VERSION  AUTHOR         DATE            Description
    1.0      Everis      27/08/2020       initial version /
    ********************************************************************************/
    Global class Request {
        public String FECHAENVIO;
        public Integer IDENVIO;
        public Lead LEAD;
        public List<File> FILE;
        
    }
    public class File{
        public String NOMBREARCHIVO;
        public String DATA;
    }
    
    
    /*********************************************************************************
    Name         : Response
    Created By   : Everis
    Created Date : 27/08/2020
    Description  : Wrapper class Response 
    VERSION  AUTHOR         DATE            Description
    1.0      Everis      27/08/2020       initial version /
    ********************************************************************************/
    Global class Response {
        public String FECHAENVIO;
        public Integer IDENVIO;
        public State ESTADO;
        public Lead LEAD;
        public List<ResFile> FILE;
    }
    public class State{
        public String CODIGO;
        public String MENSAJE;
    }
  
    public class ResFile{
        public String NOMBREARCHIVO;
    }
}