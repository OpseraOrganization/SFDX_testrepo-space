/************* Trigger to update the fields in the Deliverable Item if a SR Number is selceted *********/

trigger Update_SR_Fields on Deliverable_Item__c (Before Insert, Before Update) {

List<ID> SerReqID = new List<ID>();
List<Deliverable_Item__c> DelList = new List<Deliverable_Item__c>();
List<Service_Request__c> SRList = new List<Service_Request__c>();
Map<ID,Service_Request__c> SRMap = new Map<ID,Service_Request__c>();
List<RecordType> rt=new List<RecordType>();
rt=[SELECT Id, Name FROM RecordType WHERE Name='SR Required'];

    for(Deliverable_Item__c del : trigger.new){
        if(del.SR_Number__c != null){
            SerReqID.add(del.SR_Number__c);
            DelList.add(del);
            system.debug('!!!!!!!!!'+SerReqID);
            system.debug('@@@@@@@@@'+DelList);
        }
    }
    
    if(SerReqID.size()>0){
        SRList = [Select Atr__c, CreatedDate, Date_Initiated__c, Customer_Due_Date__c, Date_Closed__c, sr_owner__c, Status__c, Problem_Description__c, Deliverable__c, Status_Resolution__c,SR_Site__c,Summary_of_SR_Progress__c from Service_Request__c where ID in : SerReqID ];
        for(Service_Request__c SR : SRList){
            SRMap.put(SR.ID,SR);
            system.debug('##########'+SRMap);
        }
    }
    
    for(Deliverable_Item__c delItem : trigger.new){
        if(delItem.SR_Number__c != null && SRMap.size()>0){
            delItem.Attribute__c = SRMap.get(delItem.SR_Number__c).Atr__c;
            delItem.Initiated_Date__c = SRMap.get(delItem.SR_Number__c).CreatedDate;
            delItem.Customer_Due_Date__c = SRMap.get(delItem.SR_Number__c).Customer_Due_Date__c;
            delItem.Closed_Date__c = SRMap.get(delItem.SR_Number__c).Date_Closed__c;
            //delItem.CSB_Owner__c = SRMap.get(delItem.SR_Number__c).sr_owner__c;
            delItem.Status__c = SRMap.get(delItem.SR_Number__c).Status__c;
            delItem.Problem_Description__c = SRMap.get(delItem.SR_Number__c).Problem_Description__c;
            delItem.Deliverable__c = SRMap.get(delItem.SR_Number__c).Deliverable__c;
            delItem.Resolution__c = SRMap.get(delItem.SR_Number__c).Status_Resolution__c;
            //Code changes for SR#395383 Starts
             if (delItem.RecordTypeID  == rt[0].id) {
                if (SRMap.get(delItem.SR_Number__c).Status__c == 'Closed')
                  delItem.Resolution__c = SRMap.get(delItem.SR_Number__c).Status_Resolution__c; 
                else if (SRMap.get(delItem.SR_Number__c).Status__c == 'Open'){      
                  string Temp=(SRMap.get(delItem.SR_Number__c).Status_Resolution__c!=null?SRMap.get(delItem.SR_Number__c).Status_Resolution__c:'') +(SRMap.get(delItem.SR_Number__c).Status_Resolution__c!=null?',':'')+(SRMap.get(delItem.SR_Number__c).Summary_of_SR_Progress__c!=null?SRMap.get(delItem.SR_Number__c).Summary_of_SR_Progress__c:'');
                  delItem.Resolution__c =Temp;
                 }  
             if (delItem.Honeywell_Site__c==Null){
                system.debug('AAAAAAAAAAAAAAAAAAAAAAA'+SRMap.get(delItem.SR_Number__c).SR_Site__c);
                delItem.Honeywell_Site__c = SRMap.get(delItem.SR_Number__c).SR_Site__c;
                }
            } 
            //Code Changes for SR#395383 Ends 
        }
    }
}