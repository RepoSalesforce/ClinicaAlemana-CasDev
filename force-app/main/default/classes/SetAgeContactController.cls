/*********************************************************************************
Name         : SetAgeContactController
Project      : CAS
Created By   : Everis
Created Date : 05/08/2020
Description  : Class SetAgeContactController
User Story   : ---
History                                                            
-------                                                            
VERSION  AUTHOR         DATE            Description
1.0      Everis       	05/08/2020      initial version 
********************************************************************************/
global without sharing class SetAgeContactController {
    private List<Contact> listContactUpdate = new List<Contact>();
    /********************************************************************************
Author       : Everis
Company      : Everis
Description  : Metodo que actualiza age
Inputs       : List<Contact> listContact
Returns      : -
History      : -------
AUTHOR          DATE              Description
everis        05/08/2020         Versión inicial
********************************************************************************/     
    public void SetAge(List<Contact> listContact){
        String stringDateTime;
        for (Contact contact : listContact) {
            stringDateTime = String.valueOf(DateTime.now());
            contact.fax = stringDateTime;
            listContactUpdate.add(contact);
        }
        update listContactUpdate;
    }
}