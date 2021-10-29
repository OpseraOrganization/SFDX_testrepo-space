trigger RnOCaseOwnerUpdate on Agent_Contact_Mapping__c (after update) 
{
    List<Agent_Contact_Mapping__c> lstMappingObj = [select id,Modify_case__c,Contact__c,Process__c,CSR__c from Agent_Contact_Mapping__c where id in:Trigger.NewMap.keySet()];
    List<Agent_Contact_Mapping__c> lstOldMappingObj = [select id,Modify_case__c,Contact__c,Process__c,CSR__c from Agent_Contact_Mapping__c where id in:Trigger.OldMap.keySet()];
    List<Id> lstConID = new List<Id>();
    List<ID> lstOldOwnerID = new List<ID>();
    List<string> lstProduct = new List<string>();
    List<case> lstCase;
    List<case> lstUpdateNewcase;
    //Id recordtypeid = [select id from recordtype where name='Repair & Overhaul' and sobjecttype='case' limit 1].Id;
    Id recordtypeid = label.Repair_Overhaul_RT_ID;

    for(Agent_Contact_Mapping__c objACM:lstMappingObj)
    {
        lstConID.add(objACM.Contact__c);
        lstProduct.add(objACM.Process__c);
    }
    
    for (Agent_Contact_Mapping__c objOldACM : lstOldMappingObj)
    {
        lstOldOwnerId.add(Trigger.oldMap.get(objOldACM.Id).CSR__c);    
    }

    //modified for ticket :348365. Four new processes/sites added to the condition. The mailbox id/name stored in field R_O_Case_Origin__c
    lstCase = [select id,OwnerId,RecordTypeId,R_O_Case_Origin__c,ContactId from Case where Case.ContactId in:lstConID 
                and Case.R_O_Case_Origin__c in:lstProduct and Case.ownerid in:lstOldOwnerID and isClosed = false];
                
    string Ordersid;
    string Ordersid1;
    Ordersid = label.Orders_Rec_ID;
    Ordersid1 = label.OEM_Quotes_Orders_ID;
    
    if(lstCase.size()> 0)
    {
        for(Agent_Contact_Mapping__c objACM:lstMappingObj)
        {
            for(case objCase:lstCase)
            {
                if(objCase.ContactId == objACM.Contact__c && objCase.R_O_Case_Origin__c == objACM.Process__c 
                    && (objCase.RecordTypeId == recordtypeid || objCase.RecordTypeId == Ordersid || objCase.RecordTypeId == Ordersid1))
                {
                  if(Trigger.oldMap.get(objACM.Id).CSR__c != Trigger.NewMap.get(objACM.Id).CSR__c)
                    System.debug('objACM.CSR__c'+objACM.CSR__c);
                    objCase.OwnerId=objACM.CSR__c;                  
                }
            }
        }
        update lstCase;
    }
}