@RestResource(urlMapping='/V1/Opportunity/*')
global with sharing class OpportunityManager {
    public static String defaultValue;
    /*
@HttpGet
global static Account getAccountById() {
return null;
}
*/
    
    @HttpPost
    global static Response upsertOppWithFiles() {
        Opportunity opp = new Opportunity();
        RESPONSE res = new RESPONSE();
        state sta = new state();
        Boolean isUpdateOpp = false;
        String resultMsg;
        String defaultValue; 
        List<ResFile> resFileList = new List<ResFile>();
        List<Map<String, String>> result = new List<Map<String, String>>();
        List<UtilitiesClass.createFileSubclass> files = new List<UtilitiesClass.createFileSubclass>();
        //GET de body from request
        REQUEST newRequest = (REQUEST)JSON.deserialize(RestContext.request.requestBody.toString(), REQUEST.class);
        system.debug('REQUEST '+newRequest);
        opp = newRequest.OPPORTUNITY;
        //Validate Opp Null
        if(opp == null){
            res = CreateResponse(newRequest, opp,'No Opportunity in JSON', '-2',null);
            return res;
        }
        //Validate Opp ID is correct for update
        if(opp != null && !String.isEmpty(opp.id)){
            List<opportunity> OppExist = new List<opportunity>([select id from opportunity where id =:opp.Id Limit 1]);
            if(OppExist.isempty()){
                res = CreateResponse(newRequest, opp,'Opportunity ID Not Found', '-2',null);
                return res;
            }else{
                isUpdateOpp = true;
            }
        }

        //Validations   
        if(opp.Canal_Origen__c != null && !utilitiesClass.ValidatePicklist('Opportunity','Canal_Origen__c',opp.Canal_Origen__c)){
            opp.Canal_Origen__c = defaultValue;
        }
        if(opp.Numero_Hijos__c != null && !utilitiesClass.ValidatePicklist('Opportunity','Numero_Hijos__c',opp.Numero_Hijos__c)){
            opp.Numero_Hijos__c = 'Sin información';
        }

        //INSERT / UPDATE OPP
        if(!isUpdateOpp){
            //INSERT
            if(String.isEmpty(opp.Name) || String.isEmpty(opp.StageName) || opp.CloseDate == null){
                res = CreateResponse(newRequest, opp,'Opportunity required field missing (Name, StageName, CloseDate)', '-2',null);
                return res;
            }
            //GET the Acc Salesforce Id
            opp.AccountId = getClient(newRequest.PPN_HASHEADO_PACIENTE);
            if(opp.AccountId != null){
                //Required CloseDate - AccID - Stage - Name
                opp.StageName = opp.StageName != null ? opp.StageName : 'Solicitud';
                system.debug('OPP ANTES DE INSERT'+opp);
                resultMsg = 'OPPORTUNITY INSERTED';
                insert opp;
            }else{
                res = CreateResponse(newRequest, opp,'PPN Client Not Found', '-2',null);
                return res;
            }

        }else{
            system.debug('OPP ANTES DE UPDATE'+opp);
            resultMsg = 'OPPORTUNITY UPDATED';
            update opp;

        }
        //Create Files
        if(newRequest.FILES != null && !newRequest.FILES.isempty()){
            //Create Files List to Quote
            for(file f:newRequest.FILES){
                UtilitiesClass.createFileSubclass fileToCreate = new UtilitiesClass.createFileSubclass();
                fileToCreate.parentId = opp.id;
                fileToCreate.fileName = f.NOMBREARCHIVO;
                fileToCreate.base64Data = f.DATA;
                fileToCreate.tag = 'IntegrationCreated';
                files.add(fileToCreate);
            }
            //Create File in Quote
            result = utilitiesClass.createFileMethod(files);
            for(Map<String, String> file : result){
                resFile rfile = new resFile();
                rfile.NOMBREARCHIVO = file.get('Title');
                resFileList.add(rfile);
            }
        }
        //CONSTRUC RESPONSE
        //Build State
        //CreateResponse(REQUEST resquest, Opportunity opp, String Msg, String Code, List<ResFile> resFileList)
        res = CreateResponse(newRequest, opp,resultMsg,'0',resFileList);

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
    
    private static id getClient(String clientPPN){
        List<Account> accList = [SELECT PPN__c, Id, Name FROM Account WHERE PPN__c =: clientPPN];
        system.debug('Accs'+accList);
        if(accList.isEmpty()){
            system.debug('Acc NULL');
            return null;
            //return null if no default
        }else{
            return accList[0].id;
        }
    }

    private static RESPONSE CreateResponse(REQUEST resquest, Opportunity opp, String Msg, String Code, List<ResFile> resFileList){
        RESPONSE res = new RESPONSE();
        state sta = new state();
        
        sta.CODIGO = Code;
        sta.MENSAJE = Msg;
        res.ESTADO = sta;
        res.FECHAENVIO = resquest.FECHAENVIO;
        res.IDENVIO = resquest.IDENVIO;
        res.PPN_HASHEADO_PACIENTE = resquest.PPN_HASHEADO_PACIENTE;
        res.FILES = resFileList;
        res.OPPORTUNITY = opp;
        return res;
    }
    
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //
    //      WRAPPERS
    //
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////      
    /* REQUEST WRAPPER START*/
    Global class REQUEST {
        public String FECHAENVIO;
        public Integer IDENVIO;
        public String PPN_HASHEADO_PACIENTE;
        public Opportunity OPPORTUNITY;
        public List<File> FILES;
        
    }
    public class File{
        public String NOMBREARCHIVO;
        public String DATA;
    }

    

    /* REQUEST WRAPPER END*/
    
    /* RESPONSE WRAPPER START*/
    Global class RESPONSE {
        public String FECHAENVIO;
        public Integer IDENVIO;
        public String PPN_HASHEADO_PACIENTE;
        public Opportunity OPPORTUNITY;
        public List<ResFile> FILES;
        public state ESTADO;
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