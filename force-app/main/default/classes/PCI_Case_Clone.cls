/**
 * @description       : 
 * @author            : hmanosas
 * @group             : 
 * @last modified on  : 05-17-2022
 * @last modified by  : hmanosas
**/
public class PCI_Case_Clone {
    
    
    @InvocableMethod(label='Clone Case' description='Clona el Caso con todos los adjuntos relacionados a los casos' category='Case')
    public static list<String> cloneWithItems(list<casesIdRequest> request) 
    {        
        list<String> oldCaseId = request.get(0).oldCaseId;
        Case newCase = request.get(0).newCase[0];
        list<Id> newCaseId = new list<Id>();
        
        List<EmailMessage> listNewEmail = new List<EmailMessage>();
        List<ContentVersion> finalVersion = new List<ContentVersion>();
        List<ContentVersion> finalEmailAttachment = new List<ContentVersion>();
        List<ContentDocumentLink> finalContentDocLink = new List<ContentDocumentLink>();
        List<ContentDocumentLink> finalContentDocLinkEmailAttachment = new List<ContentDocumentLink>();
        Map<id,ContentDocumentLink> mapContentDocumentId = new Map<id,ContentDocumentLink>();
        set<ID> setContentDocID = new set<ID>();
        set<ID> setContentDocIDEmailOld = new set<ID>();
        
        //Clone Case
        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.AssignmentRuleHeader.useDefaultRule = true;

        newCase.setOptions(dmo);
        insert newCase;
        newCaseId.add(newCase.Id);
        
        //CASE ATTACHMENTS        
        for (ContentDocumentLink attachment: [select ContentDocumentId, LinkedEntityId, ContentDocument.Title,
                                              ContentDocument.ContentModifiedDate, ContentDocument.ContentSize from ContentDocumentLink where LinkedEntityId IN :oldCaseId]) 
        {
            setContentDocID.add(attachment.ContentDocumentId);
            mapContentDocumentId.put(attachment.ContentDocumentId, attachment);
            
        }
        
        if(setContentDocID.size() > 0){
            for(ContentVersion contentVer: [Select id,ContentDocumentId,PathOnClient,Title,VersionData,IsLatest, Description   
                                            from ContentVersion where ContentDocumentId in : setContentDocID ])
            {
                if(mapContentDocumentId.containsKey(contentVer.ContentDocumentId) && contentVer.Description == null){
                    ContentVersion newContentVer = new ContentVersion();
                    newContentVer.ContentLocation = 'S';
                    newContentVer.PathOnClient = contentVer.PathOnClient;
                    newContentVer.Title = contentVer.Title;
                    newContentVer.Description = newCase.Id; //Case or Email Id
                    newContentVer.VersionData= contentVer.VersionData;
                    FinalVersion.add(newContentVer);
                }
                
            }
            
            if(FinalVersion.size() >0){
                Insert FinalVersion;
            }
            
            
            for(ContentVersion insertedContentV: [Select ContentDocumentid ,PathOnClient ,Description,Title,VersionData,IsLatest 
                                                  from contentVersion Where id =: FinalVersion])
            {
                ContentDocumentLink docLink = new ContentDocumentLink();
                doclink.ContentDocumentId = insertedContentV.ContentDocumentId;
                doclink.LinkedEntityId = newCase.Id;
                doclink.ShareType = 'V';
                doclink.Visibility = 'AllUsers';
                finalContentDocLink.add(doclink); 
            }
            
            if(finalContentDocLink.size() > 0){
                insert finalContentDocLink;
            }
        }
        
        //CASE COMMENTS
        List<CaseComment> casecomments = new List<CaseComment>();
        for(CaseComment cc : [Select Id, ParentId, IsPublished, CommentBody, CreatedById, CreatedDate, SystemModstamp, LastModifiedDate, LastModifiedById, IsDeleted 
                              From CaseComment where ParentId IN:oldCaseId]){
                                  CaseComment newcasecomment = cc.clone(false, true);
                                  newcasecomment.ParentId = newCase.Id;
                                  casecomments.add(newcasecomment);
                              }
        if(casecomments.size() > 0){
            insert casecomments;            
        }
        
        //CASE TASKS
        List<Task> clonedTasks = new List<Task>();
        for(Task t : [Select id, WhatId, Subject, Status from Task where WhatId IN:oldCaseId]){
            Task newtask = t.clone(false, true);
            newtask.WhatId = newCase.Id;
            clonedTasks.add(newtask);
        }
        if(clonedTasks.size() > 0){
            insert clonedTasks;
        }        
        
        //CASE EVENTS
        List<Event> clonedEvent = new List<Event>();
        for(Event e : [Select id, Location, Description, Type, WhatId, DurationInMinutes, ActivityDateTime from Event where WhatId IN: oldCaseId]){
            Event newevent = e.clone(false, true);
            newevent.WhatId = newCase.Id;
            clonedEvent.add(newevent);
        }
        if(clonedEvent.size() > 0){
            insert clonedEvent;
        }
        
        //CASE EMAIL MESSAGE
        Map<Id, EmailMessage> mapOldNewEmail = new Map<Id, EmailMessage>();
        
        List<EmailMessage> listOldEmail = new List<EmailMessage>();
        List<Id> ListOldEmailId = new List<Id>();
        
        //Emails Message del Caso Origen
        listOldEmail = [Select id, ParentId, ActivityId, BccAddress, CcAddress, FromAddress, FromName, Subject, TextBody 
                        from EmailMessage where ParentId IN: oldCaseId];
        
        for(EmailMessage email :listOldEmail)
        {   
            ListOldEmailId.add(email.Id);
            EmailMessage newemail = email.clone(false, true);
            newemail.ParentId = newCase.Id;
            mapOldNewEmail.put(email.Id, newemail);
        }
        if(mapOldNewEmail.size() > 0)
        {
            insert mapOldNewEmail.values();
        }
        
        //EMAIL ATTACHMENT
        if(ListOldEmailId.size() > 0){
            
            //Obtenemos los Email Messages clonados
            listNewEmail = [Select id, ParentId, ActivityId, BccAddress, CcAddress, FromAddress, FromName, Subject, TextBody 
                            from EmailMessage where ParentId =: newCase.Id];
            
            //Obtenemos los Attachments de los Email Messages origen
            Map<Id, ContentDocumentLink> mapEmailOldAttachment = new Map<Id, ContentDocumentLink>();
            for (ContentDocumentLink attachment: [select ContentDocumentId, LinkedEntityId, ContentDocument.Title, 
                                                  ContentDocument.ContentModifiedDate, ContentDocument.ContentSize from ContentDocumentLink where LinkedEntityId IN :ListOldEmailId])
            {
                setContentDocIDEmailOld.add(attachment.ContentDocumentId);
                mapEmailOldAttachment.put(attachment.ContentDocumentId, attachment);
                
            }        
            
            if(setContentDocIDEmailOld.size() > 0)
            {
                for(ContentVersion contentVer: [Select id,ContentDocumentId,PathOnClient,Title,VersionData,IsLatest   
                                                from ContentVersion where ContentDocumentId in : setContentDocIDEmailOld])
                {
                    ContentVersion newContentVer = new ContentVersion();
                    newContentVer.ContentLocation = 'S';
                    newContentVer.PathOnClient = contentVer.PathOnClient;
                    newContentVer.Title = contentVer.Title;
                    
                    Id OldEmailId = mapEmailOldAttachment.get(contentver.ContentDocumentId).LinkedEntityId;           
                    
                    newContentVer.Description = mapOldNewEmail.get(OldEmailId).Id; //Case or Email Id
                    //newContentVer.Description = newCase.Id;
                    newContentVer.VersionData= contentVer.VersionData;
                    
                    finalEmailAttachment.add(newContentVer);
                }
                
                if(finalEmailAttachment.size() > 0)
                {
                    insert finalEmailAttachment;
                }
                
                
                for(ContentVersion insertedContentV: [Select ContentDocumentid ,PathOnClient ,Description,Title,VersionData,IsLatest 
                                                      from contentVersion Where id =: finalEmailAttachment])
                {
                    ContentDocumentLink docLink = new ContentDocumentLink();
                    doclink.ContentDocumentId = insertedContentV.ContentDocumentId;
                    doclink.LinkedEntityId = insertedContentV.Description;
                    //doclink.LinkedEntityId = listNewEmail[0].Id;
                    doclink.ShareType = 'V';
                    doclink.Visibility = 'AllUsers';
                    
                    finalContentDocLinkEmailAttachment.add(doclink);
                    
                    ContentDocumentLink casedocLink = new ContentDocumentLink();
                    casedocLink.ContentDocumentId = insertedContentV.ContentDocumentId;
                    casedocLink.LinkedEntityId = newCase.Id;
                    casedocLink.ShareType = 'V';
                    casedocLink.Visibility = 'AllUsers';
                    
                    finalContentDocLinkEmailAttachment.add(casedocLink);
                }
                
                if(finalContentDocLinkEmailAttachment.size() > 0)
                {                    
                    insert finalContentDocLinkEmailAttachment;
                }                
            }
            
            
        }
       
        
        return newCaseId;

    }
  
    
    public class casesIdRequest{
        @InvocableVariable
        public list<String> oldCaseId;
        
        @InvocableVariable
        public list<Case> newCase;
    }
    
}