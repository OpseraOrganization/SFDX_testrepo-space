/************* Trigger to update the fields in the Deliverable Item if a SR Number is updated *********/

trigger Update_DI_Fields on Service_Request__c (After Update) {

List<ID> SerReqID = new List<ID>();
List<Deliverable_Item__c> DelList = new List<Deliverable_Item__c>();
List<Service_Request__c> SRList = new List<Service_Request__c>();
Map<ID,Service_Request__c> SRMap = new Map<ID,Service_Request__c>();

    for(Service_Request__c ser : trigger.new){
        
            SerReqID.add(ser.id);
           // DelList.add(del);
            system.debug('!!!!!!!!!'+SerReqID);
            system.debug('@@@@@@@@@'+DelList);
        
    }
    
    if(SerReqID.size()>0){
        SRList = [Select Atr__c, CreatedDate, Date_Initiated__c, Customer_Due_Date__c, Date_Closed__c, sr_owner__c, Status__c, Problem_Description__c, Deliverable__c, Status_Resolution__c from Service_Request__c where ID in : SerReqID ];
        for(Service_Request__c SR : SRList){
            SRMap.put(SR.ID,SR);
            system.debug('##########'+SRMap);
        }
    }
     DelList = [Select id,SR_Number__c from Deliverable_Item__c where SR_Number__c in : SerReqID];
     
    for(Deliverable_Item__c delItem : DelList){
        if(delItem.SR_Number__c != null && SRMap.size()>0){
            delItem.Attribute__c = SRMap.get(delItem.SR_Number__c).Atr__c;
            delItem.Initiated_Date__c = SRMap.get(delItem.SR_Number__c).CreatedDate;
            delItem.Customer_Due_Date__c = SRMap.get(delItem.SR_Number__c).Customer_Due_Date__c;
            delItem.Closed_Date__c = SRMap.get(delItem.SR_Number__c).Date_Closed__c;
           // delItem.CSB_Owner__c = SRMap.get(delItem.SR_Number__c).sr_owner__c;
            delItem.Status__c = SRMap.get(delItem.SR_Number__c).Status__c;
            delItem.Problem_Description__c = SRMap.get(delItem.SR_Number__c).Problem_Description__c;
            delItem.Deliverable__c = SRMap.get(delItem.SR_Number__c).Deliverable__c;
            delItem.Resolution__c = SRMap.get(delItem.SR_Number__c).Status_Resolution__c;
        }
        Update DelList;
    }
}