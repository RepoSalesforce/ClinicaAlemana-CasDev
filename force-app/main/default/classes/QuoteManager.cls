@RestResource(urlMapping='/V1/Quote/*')
global with sharing class QuoteManager {
    
    /*
@HttpGet
global static Account getAccountById() {
return null;
}
*/
    
    @HttpPost
    global static Response createQuoteWithFiles() {
        Opportunity opp = new Opportunity();
        Quote q = new Quote();
        RESPONSE res = new RESPONSE();
        state sta = new state();
        List<ResFile> resFileList = new List<ResFile>();
        List<Map<String, String>> result = new List<Map<String, String>>();
        List<UtilitiesClass.createFileSubclass> files = new List<UtilitiesClass.createFileSubclass>();
        List<utilitiesClass.createRelationshipFilesSubclass> linkFiles = new List<utilitiesClass.createRelationshipFilesSubclass>();
        //GET de body from request
        REQUEST newRequest = (REQUEST)JSON.deserialize(RestContext.request.requestBody.toString(), REQUEST.class);
        system.debug('REQUEST '+newRequest);
        opp = newRequest.OPPORTUNITY;
        q = newRequest.PRESUPUESTO;
        if(opp != null && !String.isEmpty(opp.id)){
            List<opportunity> OppExist = new List<opportunity>([select id from opportunity where id =:opp.Id Limit 1]);
            if(OppExist.isempty()){
                res = CreateResponse(newRequest, opp, q,'Opportunity ID Not Found', 'NOOK',null);
                return res;
            }
        }else{
            res = CreateResponse(newRequest, opp, q,'Opportunity ID empty', 'NOOK',null);
            return res;
        }
        
        system.debug('opp '+ opp);
        //GET the medic Salesforce Id
        opp.Nombre_Medico__c = getMedico(newRequest.PPN_MEDICO);
        q.Medico_Tratante__c = opp.Nombre_Medico__c;
        system.debug('OPP DESPUES DE GETMEDICO'+opp);
        //INSERT Quote AND UPDATE Opportunity
        if(q != null && opp != null){
            q.OpportunityId = opp.id;
            q.Fecha_probable_hospitalizacion__c = opp.CloseDate;
            insert q;
            
        }
        
        //Create Files
        if(newRequest.FILES != null && !newRequest.FILES.isempty() && q != null){
            //Create Files List to Quote
            for(file f:newRequest.FILES){
                UtilitiesClass.createFileSubclass fileToCreate = new UtilitiesClass.createFileSubclass();
                fileToCreate.parentId = q.id;
                fileToCreate.fileName = f.NOMBREARCHIVO;
                fileToCreate.base64Data = f.DATA;
                fileToCreate.tag = 'ApexCreated';
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
        
        //UPDATE Quote para sincronizar
        if(q != null && opp != null){
            // after inserting the quote we need to update the opportunity
            opp.SyncedQuoteId = q.Id;
            system.debug('OPP ANTES DE UPDATE'+opp);
            update opp;
        }
        //CONSTRUC RESPONSE
        //Build State
        sta.CODIGO = 'OK';
        sta.MENSAJE = 'Todo esta bien';
        res.ESTADO = sta;
        res.FECHAENVIO = newRequest.FECHAENVIO;
        res.IDENVIO = newRequest.IDENVIO;
        res.PPN_MEDICO = newRequest.PPN_MEDICO;
        res.FILES = resFileList;
        res.OPPORTUNITY = opp;
        res.PRESUPUESTO = q;
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
     private static id getMedico(String ppnMedico){
         List<Medico__c> medicList = [SELECT PPN_Medico__c, Id, Name FROM Medico__c WHERE PPN_Medico__c =: ppnMedico];
         List<Medico__c> lstMedico = new List<Medico__c>();
         system.debug('MEdicos'+medicList);
         if(medicList.isEmpty()){
             
             //Query for custom Setting
             List<DefaultObjectValue__mdt> DefaultMedic = [SELECT Id, recordId__c FROM DefaultObjectValue__mdt WHERE Objecto__c = 'Medico__c'];
             system.debug('MEDICO STANDARD '+ DefaultMedic);
             if(!DefaultMedic.isEmpty() && !String.isEmpty(DefaultMedic[0].recordId__c)){
                 system.debug('MEDICO DEFAULT'+DefaultMedic[0]);
                  lstMedico = [SELECT id FROM Medico__c WHERE id=:DefaultMedic[0].recordId__c];
             }
             if(!lstMedico.isEmpty()){
                 return DefaultMedic[0].recordId__c;
             }else{
                 system.debug('MEDICO NULL');
                 return null;
                 //return null if no default
             }
         }else{
             return medicList[0].id;
         }

     }
    private static RESPONSE CreateResponse(REQUEST resquest, Opportunity opp, quote q, String Msg, String Code, List<ResFile> resFileList){
        RESPONSE res = new RESPONSE();
        state sta = new state();
        
        sta.CODIGO = Code;
        sta.MENSAJE = Msg;
        res.ESTADO = sta;
        res.FECHAENVIO = resquest.FECHAENVIO;
        res.IDENVIO = resquest.IDENVIO;
        res.PPN_MEDICO = resquest.PPN_MEDICO;
        res.FILES = resFileList;
        res.OPPORTUNITY = opp;
        res.PRESUPUESTO = q;
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
        public String PPN_MEDICO;
        public Opportunity OPPORTUNITY;
        public Quote PRESUPUESTO;
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
        public String PPN_MEDICO;
        public Opportunity OPPORTUNITY;
        public Quote PRESUPUESTO;
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