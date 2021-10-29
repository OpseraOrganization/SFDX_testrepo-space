trigger SIPFieldsAutoPopulate on SIP_Tickets__c(before insert, before update, after insert, after update) {
    
    if(Trigger.isBefore){
    set < id > userId = new set < id > ();
    // set<id> userId1= new set<id>(); 
    for (SIP_Tickets__c sipObj: trigger.new) {
        system.debug('Entry1');
        if (sipObj.Ticket_on_behalf_of__c != null) {
            system.debug('Entry2');
            userId.add(sipObj.Ticket_on_behalf_of__c);
        }
    }
    Map < Id, user > userMap = new Map < Id, user > ([select Id, SIP_Primary_Mgr__c, SIP_Secondary_Mgr__c, SIP_Tertiary_Mgr__c, Comp_and_Ben_Owner__c, Finance__c, SIP_Team_Owner__c, SIP_Current_Title__c from user where Id in: userId]);
    Map < Id, User > userMap1 = new Map < Id, User > ([select Id, SIP_Team_Owner__c, SIP_Current_Title__c from user where SIP_Team_Owner__c in: userId]);
    System.debug('userMap1 ' + userMap1);

    List < User > userList = new List < User > ([select SIP_Team_Owner__c,SIP_Current_Title__c from User where Id in: userId]);

    for (SIP_Tickets__c sipObj1: trigger.new) {
        system.debug('Entry3');
        if (sipObj1.Ticket_on_behalf_of__c != null && sipObj1.RecordTypeId == System.label.SIP_Ticket) {
            system.debug('Entry4');
            sipObj1.Primary_Sales_Mgr__c = userMap.get(sipObj1.Ticket_on_behalf_of__c).SIP_Primary_Mgr__c;
            sipObj1.Secondary_Sales_Mgr__c = userMap.get(sipObj1.Ticket_on_behalf_of__c).SIP_Secondary_Mgr__c;
            sipObj1.Tertiary_Sales_Mgr__c = userMap.get(sipObj1.Ticket_on_behalf_of__c).SIP_Tertiary_Mgr__c;
            sipObj1.Comp_and_Ben_Owner__c = userMap.get(sipObj1.Ticket_on_behalf_of__c).Comp_and_Ben_Owner__c;
            sipObj1.Finance__c = userMap.get(sipObj1.Ticket_on_behalf_of__c).Finance__c;
            // sipObj1.SIP_Team_Owner_User_Record__c=userMap1.get(sipObj1.Ticket_on_behalf_of__c).SIP_Team_Owner__c ;
            // sipObj1.SIP_Team_Owner_User_Record__c=userMap.get(sipObj1.Ticket_on_behalf_of__c).SIP_Team_Owner__c ;
        }
     }
    }
    if(RecursiveTriggerHandler.isFirstTime) {
    if((Trigger.isAfter && Trigger.IsInsert) || (Trigger.isAfter && Trigger.IsUpdate))  {
        system.debug('<<<<<<<isafter trigger>>>>');
        // new
        RecursiveTriggerHandler.isFirstTime = false;
        List<SIP_Tickets__c> usrIdList = new List<SIP_Tickets__c>();
        Set<Id> usrIdSet = new Set<Id>();
        usrIdList = [Select Ticket_on_behalf_of__c from SIP_Tickets__c where Id IN :trigger.new];
        for(SIP_Tickets__c idv: usrIdList)
        {
            usrIdSet.add(idv.Ticket_on_behalf_of__c);
        }
        Map<Id, User> TickBehalfMap = new  Map<Id, User>([Select Id, SIP_Current_Title__c from User where Id IN :usrIdSet]);
        // new
        
        List<SIP_Tickets__c> sipObjList = new List<SIP_Tickets__c>();
        for (SIP_Tickets__c sipObj1: trigger.new){
            
            SIP_Tickets__c sipObj2 = new SIP_Tickets__c();
            sipObj2.Id = sipObj1.Id;
            if(sipObj1.Primary_Sales_Mgr__c != null) {
               sipObj2.ownerid = sipObj1.Primary_Sales_Mgr__c ;
           }
            
            else if(TickBehalfMap.containskey(sipObj1.Ticket_on_behalf_of__c) && TickBehalfMap.get(sipObj1.Ticket_on_behalf_of__c).SIP_Current_Title__c == 'Sales Mgr') {
               
               system.debug('Entry6');
               sipObj2.ownerid =  sipObj1.Ticket_on_behalf_of__c;
           }
           else {
               system.debug('Entry5');
               sipObj2.ownerid = sipObj1.CreatedByid;
           } 
          
           sipObjList.add(sipObj2);
           system.debug('<<<<<<<sipObjList trigger>>>>'+sipObjList);
           
        }
        Update sipObjList;
    }
    }
}