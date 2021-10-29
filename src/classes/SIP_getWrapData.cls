public class SIP_getWrapData{

    public SIP_getWrapData(ApexPages.StandardController controller) {

    }


    List<wrapperclass> wrapList = new List<wrapperclass>();
    set<id> targetid=new set<id>();
    public List<wrapperclass> getWrapList() 
    {
        for(ProcessInstance pi: [SELECT Id, Status, TargetObjectId, TargetObject.Name,(SELECT Id, ActorId, Actor.Name, OriginalActorId, OriginalActor.Name, StepStatus, Comments, ProcessNode.Name, CreatedDate FROM StepsAndWorkitems WHERE StepStatus =: 'Pending') FROM ProcessInstance WHERE Status =: 'Pending' ORDER BY TargetObjectId])
        {
            if(String.valueOf(pi.TargetObjectId.getSObjectType()).split('__')[0] == 'SIP_Tickets')
            targetid.add(pi.TargetObjectId);
        }
        map<id,SIP_Tickets__c> sipticket=new map<id,SIP_Tickets__c>();
        for(SIP_Tickets__c obj:[select id,Ticket_on_behalf_of__c,Ticket_on_behalf_of__r.name,createddate from SIP_Tickets__c where id =:targetid])
        {
            //SIP_Tickets__c st = (SIP_Tickets__c)obj;
            sipticket.put(obj.id,obj);
        }       
        for (ProcessInstance pi: [SELECT Id, Status, TargetObjectId, TargetObject.Name, 
                (SELECT Id, ActorId, Actor.Name, OriginalActorId, OriginalActor.Name, StepStatus, Comments, ProcessNode.Name, CreatedDate FROM StepsAndWorkitems WHERE StepStatus =: 'Pending') 
                FROM ProcessInstance   ORDER BY TargetObjectId] ) 
        {
                for (ProcessInstanceHistory pih : pi.StepsAndWorkItems) 
                {
                    if(String.valueOf(pi.TargetObjectId.getSObjectType()).split('__')[0] == 'SIP_Tickets')
                    {
                        wrapperClass pendingApprovalWrap = new wrapperClass();
                        pendingApprovalWrap.Status = pih.StepStatus;
                        pendingApprovalWrap.RecordName = String.valueOf(pi.TargetObject.Name);
                        pendingApprovalWrap.RecordId = String.valueOf(pi.TargetObjectId);
                        pendingApprovalWrap.RecordObject = String.valueOf(pi.TargetObjectId.getSObjectType()).split('__')[0];
                        pendingApprovalWrap.AssignedToName = String.valueOf(pih.OriginalActor.Name);
                        pendingApprovalWrap.ApproverName = pih.Actor.Name;
                        pendingApprovalWrap.CreatedDate = String.valueOf(pih.CreatedDate); 
                        if(sipticket.containskey(pi.TargetObjectId))
                        {                           
                        pendingApprovalWrap.TicketonBehalfof= String.valueOf(sipticket.get(pi.TargetObjectId).Ticket_on_behalf_of__r.name);
                        pendingApprovalWrap.sipCreatedDate= String.valueOf(sipticket.get(pi.TargetObjectId).createddate);
                        }
                        wrapList.add(pendingApprovalWrap);
                    }
                }          
        }
        return wrapList;
    }
    public class wrapperClass{
        public String Status {get; set;}
        public String RecordName {get; set;}
        public String RecordId {get; set;}
        public String RecordObject {get; set;}
        public String AssignedToName {get; set;}
        public String ApproverName {get; set;}
        public String CreatedDate {get; set;}
        public string TicketonBehalfof{get;set;}
        public String sipCreatedDate {get; set;}
    }
}