@isTest
public class UtilitiesTestClass {
    
    public static User createUser(id profId, String alias){
        User us = new User();
        us.Alias = alias;
        us.Email = 'test@test.cl';
        us.IsActive = true;
        us.ProfileId = profId;
        us.Username = 'test123123@t2es123t.cl';
        us.LastName = 'test';
        us.TimeZoneSidKey = 'America/Denver';
        us.LanguageLocaleKey = 'en_US';
        us.EmailEncodingKey = 'UTF-8';
        us.LocaleSidKey = 'en_US';
        return us;        
    }
    
    public static Account createAccount(String lastName, String ppn, String typeIdent, String numIdent){
        
        List<RecordType> recordTList = [SELECT Id, Name, DeveloperName  
                                        FROM RecordType 
                                        WHERE SobjectType='Account' 
                                        AND DeveloperName  = 'PersonAccount' 
                                        LIMIT 1];
        Account acc = new Account();        
        acc.RecordTypeId = recordTList[0].id;
        acc.Salutation = 'Mr.';
        acc.FirstName = 'Luis';
        acc.MiddleName = 'Alberto';
        acc.LastName = lastName;
        acc.PPN__c = ppn; 										//External Id
        acc.Tipo_de_Identificacion__c = typeIdent; 				//1=RUT
        acc.Numero_de_Identificacion__c = numIdent;
        acc.Sexo__pc = 'M';
        acc.PersonBirthdate = Date.newInstance(1990, 03, 25);
        acc.Estado_civil__pc = 'S';
        acc.Nacionalidad__pc = '49'; 							//Chile
        acc.PersonEmail = 'luis.jara@gmail.com';
        acc.PersonHasOptedOutOfEmail = false;
        acc.PersonMobilePhone = '+56956332245';        
        acc.PersonHomePhone = '452697845';
        acc.Prevision__pc = '85'; 								//Fonasa
        acc.Empresa__c = '3'; 									//Temuco
        acc.Actividad__pc = '2'; 								//Abogado
        acc.Acreditado__pc = true;
        acc.Flag_defuncion__pc = false;
        acc.Cliente_vigente__c = true;
        acc.Fecha_de_defuncion__pc = null;
        acc.Direccion_particular__pc = 'Las Cucarachas N° 007';
        acc.Comuna_particular__pc = '9101'; 					//Temuco
        acc.Ciudad_Direccion_Particular__pc = 'Temuco';
        acc.Pais_particular__pc = '49'; 						//Chile
        acc.Direccion_Comercial_del__c = 'Av. Las Perdices N° 1313';
        acc.Comuna_Comercial__c = '9101';						//Temuco
        acc.Ciudad_Direccion_Comercial__c = 'Temuco';
        acc.Pais_comercial__c = '49';							//Chile
        
        return acc;        
    }
    
    public static Opportunity createOpportunity(id medicoId, id accId, String numIdent){
        
        Opportunity opp = new Opportunity();
        opp.Score__c = 100;
        opp.Fecha_Creacion__c = Date.today();
        opp.Name = 'Test'+numIdent;
        opp.Codigo_Cirugia_CAS__c = '0001';
        opp.Descripcion_Cirugia__c = 'Test Cirugia';
        opp.CloseDate = date.today().addDays(Date.daysInMonth(date.today().year(), date.today().month()) + 90);
        //opp.Fecha_Real_de_Hospitalizacion__c = Date.newInstance(2022, 11, 05);
        opp.Nombre_Medico__c = medicoId;
        opp.Canal_Origen__c = 'W';
        opp.Especialidad__c = 'CAR';
        opp.Total_Honorarios_Medico__c = 250000;
        opp.Total_Clinica__c = 1000000;
        opp.Amount = 5000;
        opp.AccountId = accId;
        opp.Numero_de_Identificacion__c = numIdent;
        opp.Sexo__c	= 'S';
        opp.Telefono_Movil__c = '+56956241789';
        opp.Prevision__c = '85';								//Fonasa
        opp.CEI__c = false;
        opp.Simulacion__c = 'Pendiente';
        opp.Seguro_Complementario__c = 'BiceVida';
        opp.Descuento_Honorarios_Medico__c = 20;
        opp.Descuento_Clinica__c = 20;
        opp.Gestion__c = 'Sin Contacto';
        opp.No_embarazada__c = true;
        opp.Motivo_Rechazo__c = 'Otro';
        opp.Tipo_Embarazo__c = 'U';
        opp.Otro_Motivo__c = 'Test Motivo';
        opp.Numero_Hijos__c = '1';
        opp.Clinica_Alternativa__c = 'Hospital';
        opp.Paciente_Internacional__c = false;
        opp.Todo_Alemana__c = false;
        opp.Alemana_Total__c = false;
        opp.Rebaja_Deducible__c = true;
        opp.Plan_Preferente__c = false;
        opp.Indicador_A__c = false;
        opp.StageName = 'Solicitud';
        opp.Probability = 20;
        opp.Paciente_Hospitalizado__c = false;
        opp.Fecha_Pabellon_Agendada__c= date.today().addDays(Date.daysInMonth(date.today().year(), date.today().month()) - 1);
        opp.Descripcion_Pabellon__c = 'Test Pabellon'; 
        
        return opp;        
    }
    
    public static Case createStandardCase(id accId){
        Case cas = new Case();
        cas.AccountId = accId;
        cas.Subject = 'subject';
        cas.Status = 'New';
        cas.Description = 'Test';
        cas.Comments = 'Test';
        return cas;
    }
    
    public static Task createTask(id ownId, id objId){
        Task tas = new Task();
        tas.OwnerId = ownId;
        tas.Status = 'Abierta';
        tas.Priority = 'Normal';
        tas.Subject = 'Solicitar documentos al paciente';
        tas.WhatId = objId;
        return tas;
    }
    
    public static Lead createLead(String idNoClient, String typeIdent, String numIdent){
        List<RecordType> recordTList = [SELECT Id, Name, DeveloperName  
                                        FROM RecordType 
                                        WHERE SobjectType='Lead' 
                                        AND DeveloperName  = 'Lead_Ventas' 
                                        LIMIT 1];
        
        Lead le = new Lead();
        le.RecordTypeId = recordTList[0].id;
        le.Tipo_de_identificacion__c = typeIdent;				//1=RUT
        le.Numero_de_identificacion__c = numIdent;
        le.Salutation = 'Ms.';
        le.Nacionalidad__c = '49';								//Chile
        le.FirstName = 'Rosa';
        le.MiddleName = 'Maria';
        le.LastName = 'Perez';
        le.Prevision__c = '85';									//Fonasa
        le.Sexo__c = 'F';
        le.Status = 'Nuevo';
        le.Fecha_nacimiento__c = Date.newInstance(1992, 05, 04);
        le.Phone = '+56989745632';
        le.Email = 'rosa.perez@gmail.com';
        le.LeadSource = 'O';									//Formulario web	
        le.ID_No_Cliente__c = idNoClient;
        le.Categoria_de_charla_o_campana_asociada__c = 'Test';
        le.Vigente__c = true;
        le.Fecha_interes_1__c = date.today().addDays(Date.daysInMonth(date.today().year(), date.today().month()) - 10);
        le.Fecha_interes_2__c = date.today().addDays(Date.daysInMonth(date.today().year(), date.today().month()) + 10);
        le.Embarazada__c = false;
        le.HasOptedOutOfEmail = false;
        le.Comuna__c = '9101';									//Temuco
        le.Ciudad__c = 'Temuco';
        
        return le;        
    }
    
    public static Quote createQuote(id contId, String presCasId, id oppId, id sucId){
        
        Quote quot = new Quote();
        quot.AdditionalName = 'Test'; 
        quot.Name = 'Test';
        quot.ExpirationDate = date.today().addDays(Date.daysInMonth(date.today().year(), date.today().month()) + 90);
        quot.OpportunityId = oppId;
        quot.Status = 'Draft';
        quot.Description = 'Test Presupuesto';
        quot.ContactId = contId;
        quot.Sucursal__c = sucId;
        quot.Fecha_probable_hospitalizacion__c = date.today().addDays(Date.daysInMonth(date.today().year(), date.today().month()) - 1);
        quot.Tipo_presupuesto__c = '2';												//Cirugia
        quot.Fecha_Creacion__c = date.today().addDays(Date.daysInMonth(date.today().year(), date.today().month()) - 32);
        quot.Codigo_de_prestacion__c = '0012';
        quot.Vigente__c = true;
        quot.Email = 'test@gmail.com';
        quot.Phone = '+56978899878';
        quot.QuoteToName = 'Test Test';		
        quot.BillingName = 'Test Presupuesto';
        quot.ShippingName = 'Test Presupuesto';        
        quot.Codigo_CAS_1__c = '0001';
        quot.Codigo_CAS_2__c = '0002';
        quot.Codigo_CAS_3__c = '0003';
        quot.Codigo_CAS_4__c = '0004';
        quot.Codigo_Fonasa_1__c = '0001';
        quot.Codigo_Fonasa_2__c = '0001';
        quot.Codigo_Fonasa_3__c = '0001';
        quot.Codigo_Fonasa_4__c = '0001';
        quot.Fecha_Version__c = date.today().addDays(Date.daysInMonth(date.today().year(), date.today().month()) - 32);
        quot.ID_Presupuesto_CAS__c = presCasId;
        quot.Importe__c = 250000;
        quot.Nombre_Intervencion_1__c = '0001';
        quot.Nombre_Intervencion_2__c = '0002';
        quot.Nombre_Intervencion_3__c = '0003';
        quot.Nombre_Intervencion_4__c = '0004';
        quot.Numero_Dias__c = '5';
        quot.Numero_Version__c = 3;
        quot.Tipo_Hospitalizacion__c = '1';
        quot.Total_Clinica__c = 1000000;
        quot.Total_Honorarios_Medico__c = 500000;
        return quot;        
    }
    
    public static Medico__c createMedico(String ppn, String numIdent, String typeIdent){
        Medico__c med = new Medico__c();
        
        med.Name = 'Medico Test';
        med.Correo_Electronico__c = 'test@gmail.com';
        med.No_recibir_ninguna_notificacion__c	 = true;
        med.No_recibir_notificacion_paciente_acepta__c = true;
        med.No_recibir_notificacion_paciente_rechaza__c = true;
        med.No_recibir_notificacion_presupuesto__c = true;
        med.Numero_Identificacion__c = numIdent;
        med.PPN_Medico__c = ppn;
        med.Tipo_de_Identificacion__c = typeIdent;
        med.Tipo__c = 'Staff';
        return med;
    }
    
    public static SRV_Sucursal__c createSucursal(String idCodigo, String idDireccion, String Name){
        SRV_Sucursal__c suc = new SRV_Sucursal__c();
        
        suc.SRV_Codigo__c = idCodigo;
        suc.SRV_Direccion__c = idDireccion;
        suc.Name = Name;
        
        return suc;
    }
    
    public static SRV_Unidad_responsable__c createUnidadResponsable(String idCod, String Name,ID idSucursal,ID jefeArea ){
        SRV_Unidad_responsable__c unr = new SRV_Unidad_responsable__c();
        
        unr.SRV_Codigo__c = idCod;
        unr.Name = Name;
        unr.SRV_Sucursal__c = idSucursal; 
        unr.SRV_Jefe_de_Area__c = jefeArea;
        
        return unr;
    }
    
    public static SRV_Funcionario__c createFuncionario(String correoElectronico, String Name){
        SRV_Funcionario__c fun = new SRV_Funcionario__c();
        
        fun.SRV_Correo_Electronico__c = correoElectronico;
        fun.Name = Name;
        
        return fun;
    }
    
    public static Case createCaseGeneral(String Status,ID ContactId){
        List<RecordType> recordTList = [SELECT Id, Name, DeveloperName  
                                        FROM RecordType 
                                        WHERE SobjectType='Case' 
                                        AND DeveloperName  = 'SRV_Caso_General' 
                                        LIMIT 1];
        Case caso = new Case();
        caso.subject = 'Test Case';
        caso.Origin = 'Presencial';
        caso.RecordTypeId = recordTList[0].id;
        caso.Status = Status;
        caso.Description = 'TEST DESCRIPTION';
        caso.ContactId = ContactId;
        return caso;
    }
    
    public static Case createCaseFast(String Status,ID ContactId){
        List<RecordType> recordTList = [SELECT Id, Name, DeveloperName  
                                        FROM RecordType 
                                        WHERE SobjectType='Case' 
                                        AND DeveloperName  = 'SRV_Caso_Resolucion_Rapida' 
                                        LIMIT 1];
        Case caso = new Case();
        caso.subject = 'Test Case Fast';
        caso.Origin = 'Presencial';
        caso.RecordTypeId = recordTList[0].id;
        caso.Status = Status;
        caso.Description = 'TEST DESCRIPTION';
        caso.ContactId = ContactId;
        return caso;
    }
    
    public static emailmessage createEmailmessage(String CaseID, String fromAd){
        EmailMessage em = new EmailMessage();
        em.FromAddress = fromAd;
        em.FromName = 'TestEMAIL';
        em.ParentId = CaseID;
        em.RelatedToId = CaseID;
        em.Status = '3';
        em.HtmlBody = 'HOLA COMO ESTAS';
        em.subject = 'SUBJECT GENERICO';            
        em.ToAddress = 'test@testing.test';
        return em;
    }
    
    public static contentVersion createContentVersion (String FPL){
        ContentVersion cv = new ContentVersion();
        cv.ContentLocation = 'S';
        cv.VersionData =  Blob.valueOf('iVBORw0KGgoAAAANSUhEUgAAAAEAAAABAQMAAAAl21bKAAAAA1BMVEUAAACnej3aAAAAAXRSTlMAQObYZgAAAApJREFUCNdjYAAAAAIAAeIhvDMAAAAASUVORK5CYII=');
        cv.Title = 'fileNameTest';
        cv.PathOnClient = 'titleTest.png';
        cv.FirstPublishLocationId = FPL;        
        return cv;
    }
    public static contentDocumentLink createContentDocumentLink (){
        return null;
    }  
}