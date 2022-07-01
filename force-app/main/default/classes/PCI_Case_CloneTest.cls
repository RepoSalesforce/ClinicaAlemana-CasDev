/**
 * @description       : 
 * @author            : hmanosas
 * @group             : 
 * @last modified on  : 05-17-2022
 * @last modified by  : hmanosas
**/
@isTest
public class PCI_Case_CloneTest {
    
    
    @testSetup static void setup(){
        
        Id idRecord = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('PCI_Caso_Imagen').getRecordTypeId();
        
        //Create Case
        Case c = new Case();
        c.Subject = 'Test Caso Padre';
        c.Origin = 'Manual';
        c.SRV_Web_Autorizo_a_ser_notificado_por_em__c = '';
        c.Description = 'Esto es una descripción';
        c.RecordTypeId = idRecord;
        c.Status = 'En proceso de análisis';
        c.PCI_Categoria__c = 'Gestión de reservas';
        c.PCI_Subcategoria__c = 'Confirmación de reserva';
        c.PCI_Servicios__c = 'Ecotomografía';
        c.SuppliedName = 'Usuario1';
        c.SuppliedEmail = 'usuario@email.com';
        insert c;
        
        Case c2 = new Case();
        c2.Subject = 'Test Caso a Clonar';
        c2.Origin = 'Manual';
        c2.SRV_Web_Autorizo_a_ser_notificado_por_em__c = '';
        c2.Description = 'Esto es una descripción';
        c2.RecordTypeId = idRecord;
        c2.Status = 'En proceso de análisis';
        c2.PCI_Categoria__c = 'Gestión de reservas';
        c2.PCI_Subcategoria__c = 'Confirmación de reserva';
        c2.PCI_Servicios__c = 'Ecotomografía';
        c2.SuppliedName = 'Usuario1';
        c2.SuppliedEmail = 'usuario@email.com';
        insert c2;

        //Create Email Message
        EmailMessage email = new EmailMessage();
        email.FromAddress = 'test@abc.org';
        email.Incoming = True;
        email.ToAddress= 'test@xyz.org';
        email.Subject = 'Test email';
        email.HtmlBody = 'Test email body';
        email.ParentId = c.Id;
        insert email;
        
        //Create Content Version Case
        list<ContentVersion> listContentVersion = new list<ContentVersion>();
        
        ContentVersion contentVersion = new ContentVersion();        
        contentVersion.Title = 'Test' ;
        contentVersion.PathOnClient = 'Test.pdf' ;
        contentVersion.VersionData = Blob.valueOf('Test Content Data') ;
        contentVersion.IsMajorVersion = true;
        listContentVersion.add(contentVersion);
        
        ContentVersion contentVersion2 = new ContentVersion();        
        contentVersion2.Title = 'Test email' ;
        contentVersion2.PathOnClient = 'Test.pdf' ;
        contentVersion2.VersionData = Blob.valueOf('Test Content Data Email') ;
        contentVersion2.IsMajorVersion = true;
        listContentVersion.add(contentVersion2);
        
        insert listContentVersion;
        
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
                
        //Create ContentDocumentLink Case
        list<ContentDocumentLink> listcdl = new list<ContentDocumentLink>();
        
        ContentDocumentLink cdl = new ContentDocumentLink();        
        cdl.LinkedEntityId = c.Id;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.Visibility = 'AllUsers';
        cdl.ShareType = 'V';
        listcdl.add(cdl);
        
        ContentDocumentLink cdl2 = new ContentDocumentLink();        
        cdl2.LinkedEntityId = email.Id;
        cdl2.ContentDocumentId = documents[1].Id;
        cdl2.Visibility = 'AllUsers';
        cdl2.ShareType = 'V';
        listcdl.add(cdl2);
        
        insert listcdl;
        
        CaseComment tComment = new CaseComment();
        tComment.ParentId = c.Id;
        tComment.CommentBody = 'Some Comment';
        tComment.IsPublished = TRUE;        
        insert tComment;
        
        Task tsk = new Task();
        tsk.WhatId = c.Id;
        tsk.Subject = 'test';
        tsk.Status = 'Abierta';
        insert tsk;
        
        Event evt = new Event();
        evt.Location = 'Case';
        evt.Description = 'Test';
        evt.Type = 'Email';
        evt.WhatId = c.Id;
        evt.DurationInMinutes = 10;
        evt.ActivityDateTime = system.NOW();
        insert evt;
            
    }

    private static testMethod void testClone()
    {
        Test.startTest();

        List<Case> listCase = [SELECT Id FROM Case WHERE Subject = 'Test Caso Padre'];
       
        Id idRecord = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('PCI_Caso_Imagen').getRecordTypeId();
        
        Case c2 = new Case();
        c2.Subject = 'Test Caso a Clonar';
        c2.Origin = 'Manual';
        c2.SRV_Web_Autorizo_a_ser_notificado_por_em__c = '';
        c2.Description = 'Esto es una descripción';
        c2.RecordTypeId = idRecord;
        c2.Status = 'En proceso de análisis';
        c2.PCI_Categoria__c = 'Gestión de reservas';
        c2.PCI_Subcategoria__c = 'Confirmación de reserva';
        c2.PCI_Servicios__c = 'Ecotomografía';
        c2.SuppliedName = 'Usuario1';
        c2.SuppliedEmail = 'usuario@email.com';
        
        list<Case> lst2 = new list<Case>{c2};
        
        PCI_Case_Clone.casesIdRequest cr = new PCI_Case_Clone.casesIdRequest();
        
        list<string> lst1 = new list<string>{String.ValueOf(listCase[0].Id)};
        //list<string> lst2 = new list<string>{String.ValueOf(listCase[1].Id)};
        cr.oldCaseId = lst1;
        //cr.newCaseId = lst2;
        cr.newCase = lst2;

        List<PCI_Case_Clone.casesIdRequest> listRequest = new List<PCI_Case_Clone.casesIdRequest>{cr};
        PCI_Case_Clone.cloneWithItems(listRequest);

        Test.stopTest();
    }
    
    
    
}