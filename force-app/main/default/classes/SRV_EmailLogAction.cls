/**
 * @description       : 
 * @author            : fbizamam@everis.com
 * @group             : 
 * @last modified on  : 07-15-2021
 * @last modified by  : fbizamam@everis.com
 * Modifications Log 
 * Ver   Date         Author                Modification
 * 1.0   07-15-2021   fbizamam@everis.com   Initial Version
**/
global class SRV_EmailLogAction {
    @InvocableMethod(label='Create email Log' description='crea emailmessage para que se pueda visualizar los envios por medio de email alert' category='Case')
    public static void createEmailMessageLog(List<sendEmailRequest> sendEmailRequests) {
        List<emailmessage> emToInsert = new List<emailmessage>();
        list<String> templateUniqueNames = new list<String>();
        for(sendEmailRequest ser : sendEmailRequests){
            templateUniqueNames.add(ser.TemplateUniqueName);
        }
    
		Map<String, Id> DevNameIDMap = new Map<String, Id>();
        for(emailtemplate et :[Select Id,DeveloperName from emailtemplate where DeveloperName =:  templateUniqueNames]){
            DevNameIDMap.put(et.developerName, et.Id);
        }
        for(sendEmailRequest ser : sendEmailRequests){
            List<Id> ContactList = New List<Id>();
            if(!(String.isEmpty(ser.ContactID) || ser.ContactID == null)){
                ContactList.add(ser.ContactID);
            }else{
                ser.ContactID = null;
            }
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail = Messaging.renderStoredEmailTemplate(DevNameIDMap.get(ser.TemplateUniqueName), ser.ContactID, ser.CaseID);
            EmailMessage em = new EmailMessage();
            em.FromAddress = ser.FromAddress;
            em.FromName = ser.FromName;
            em.ParentId = ser.CaseId;
            em.RelatedToId = ser.CaseId;
            em.Status = '3';
            em.EmailTemplateId = DevNameIDMap.get(ser.TemplateUniqueName);
            em.HtmlBody = mail.getHtmlBody();
            em.subject = mail.getSubject();            
            em.ToAddress = ser.ToAddress;
            em.ToIds = ContactList;
            emToInsert.add(em);
        }
        insert emToInsert;
    }      
    global class sendEmailRequest{
        @InvocableVariable
        global ID CaseID;
        @InvocableVariable
        global String ContactID;
        @InvocableVariable
        global String FromAddress;
        @InvocableVariable
        global String FromName;
        @InvocableVariable
        global String TemplateUniqueName;
        @InvocableVariable
        global String ToAddress;
    }
}