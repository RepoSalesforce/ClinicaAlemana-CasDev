global class SRV_MigrateEmailAndFiles {
    @InvocableMethod(label='Migrate Email and Files' 
                     description='migra los emails y archivos de un caso de origen a otro de destino' 
                     category='Case')
    public static void MigrateEmailMessageAndFiles(List<migrateResquest> migrateList) {
        system.debug('START MIGRATION');
        List<ContentDocumentLink> OriginDocuments = new List<ContentDocumentLink>();
        Map<Id,Id> OriginDestinationCaseIds = new Map<Id,Id>();
        List<ContentDocumentLink> LinksToInsert = new List<ContentDocumentLink>();
        
        //MAP Origin Case and Target Case
        for(migrateResquest mr :  migrateList){
            OriginDestinationCaseIds.put(mr.OriginCaseID,mr.TargetCaseID);
        }
        
        //Set Key for query Error
        Set<Id> newSet = OriginDestinationCaseIds.keySet();
        List<Id> newList = new List<Id>();
        newList.addAll(newSet);
        
        // Clone Case Task START
        /*
        List<Task> clonedTasks = new List<Task>();
        for(Task t : [Select id, WhatId, OwnerId, Subject, Status, ActivityDate, Priority 
                      from Task 
                      where WhatId =: newList]){
            Task newtask = t.clone(false, true);
            newtask.WhatId = OriginDestinationCaseIds.get(t.WhatId);
            //newtask.WhatId = newCase.id;
            System.debug('newtask.WhatId'+newtask.WhatId);
            clonedTasks.add(newtask);
        }
        if(!clonedTasks.isEmpty()){
            System.debug('Inside ClonedTasks');
            System.debug('ClonedTasks'+clonedTasks.size());
            insert clonedTasks; 
        }
		*/
        // Clone Case Task END
        
        // Clone Case Event START
        /*
        List<Event> clonedEvent = new List<Event>();
        for(Event e : [Select id, Subject, Location, Description, DurationInMinutes, ActivityDateTime, 
                       EndDateTime, RecurrenceStartDateTime, StartDateTime, Type, WhatId 
                       from Event 
                       where WhatId =:  newList]){
            Event newevent = e.clone(false, true);
             newevent.WhatId = OriginDestinationCaseIds.get(e.WhatId);
                           //newevent.WhatId = newCase.id;
            System.debug('newevent.WhatId'+newevent.WhatId);
            clonedEvent.add(newevent);
        }
        if(!clonedEvent.isEmpty()){
            System.debug('Inside ClonedEvent');
            System.debug('ClonedEvent'+clonedEvent.size());
            insert clonedEvent; 
        }
		*/
        // Clone Case Event END

        // Clone Case Email Message START
        List<EmailMessage> clonedEmail = new List<EmailMessage>();
        List<EmailMessage> OriginalEM = [SELECT Id, ParentId, ActivityId, CreatedById, CreatedDate, LastModifiedDate, 
                                     LastModifiedById, SystemModstamp, TextBody, HtmlBody, Headers, Subject, 
                                     FromName, FromAddress, ToAddress, CcAddress, BccAddress, 
                                     Incoming, HasAttachment, Status, MessageDate, IsDeleted, ReplyToEmailMessageId, 
                                     IsExternallyVisible, MessageIdentifier, ThreadIdentifier, IsClientManaged, 
                                     RelatedToId, IsTracked, IsOpened, FirstOpenedDate, LastOpenedDate, IsBounced, 
                                     EmailTemplateId,
                                  	 (Select id, ContentDocumentId, LinkedEntityId, ShareType, Visibility
                           			 from ContentDocumentLinks)
                                     FROM EmailMessage 
                                     where parentId =: newList];
        for(EmailMessage email : OriginalEM){
                                         
            EmailMessage newemail = email.clone(false, true,true,true);
            newemail.SVR_OldEmailMessageId__c = email.id;
            newemail.ParentId = OriginDestinationCaseIds.get(email.parentId);
            newemail.RelatedToId = OriginDestinationCaseIds.get(email.parentId);
            //newemail.ParentId = newCase.id;           
            //newemail.FromAddress ='supportsandbox@nextracker.com';
            clonedEmail.add(newemail);
      }
        if(!clonedEmail.isEmpty()){
            System.debug('Inside ClonedEmail');
            System.debug('ClonedEmail'+clonedEmail.size());
            insert clonedEmail; 
        }
        // Clone Case Email Message END
        
        // Map Origin Email to Destiny Email START
        Map<id,id> OldEmailNewEmailMap = new Map<id,id>();
        for(EmailMessage newEmail : clonedEmail){
            OldEmailNewEmailMap.put(newEmail.SVR_OldEmailMessageId__c, newEmail.Id);
        }
        // Map Origin Email to Destiny Email END
        
        // Clone Case Email Message Documents START
        for(EmailMessage email : OriginalEM){
            for(ContentDocumentLink cvLink : email.ContentDocumentLinks){
                ContentDocumentLink newLinkToNewEmail = cvLink.clone(false,true);
                newLinkToNewEmail.LinkedEntityId = OldEmailNewEmailMap.get(cvLink.LinkedEntityId);
                system.debug(newLinkToNewEmail.ContentDocumentId + ' -> ' + newLinkToNewEmail.LinkedEntityId);
                LinksToInsert.add(newLinkToNewEmail);
                ContentDocumentLink newLinkToNewCase = cvLink.clone(false,true);
                newLinkToNewCase.LinkedEntityId = OriginDestinationCaseIds.get(email.parentId);
                system.debug(newLinkToNewCase.ContentDocumentId + ' -> ' + newLinkToNewCase.LinkedEntityId);
                LinksToInsert.add(newLinkToNewCase);
            }
        }
        // Clone Case Email Message Documents END        
        
        // CLone Documents Links START
        OriginDocuments = [Select id, ContentDocumentId, LinkedEntityId, ShareType,Visibility
                           from ContentDocumentLink 
                           where LinkedEntityId IN: newList];
        for(ContentDocumentLink cvLink : OriginDocuments){
            ContentDocumentLink newLink = cvLink.clone(false,true);
            newLink.LinkedEntityId = OriginDestinationCaseIds.get(cvLink.LinkedEntityId);
            system.debug(newlink.ContentDocumentId + ' -> ' + newLink.LinkedEntityId);
            LinksToInsert.add(newLink);
                /*
            	ContentDocumentId = cvLink.ContentDocumentId,
            	LinkedEntityId = OriginDestinationCaseIds.get(cvLink.LinkedEntityId),
            	ShareType = cvLink.ShareType,
            	Visibility = cvLink.Visibility);
				*/
        }
        if(!LinksToInsert.isEmpty()){
        	insert LinksToInsert;
        }
        // CLone Documents Links END
    }
    global class migrateResquest{
        @InvocableVariable
        global ID OriginCaseID;
        @InvocableVariable
        global ID TargetCaseID;
    }
}