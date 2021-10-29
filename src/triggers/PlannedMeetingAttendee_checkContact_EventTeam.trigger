/** * File Name: PlannedMeetingAttendee_checkContact_EventTeam
* Description : Trigger is ensure that Planned Meeting Attendee is  a member of the event team associated to the event
* Copyright : Wipro Technologies Limited Copyright (c) 2010
* * @author : wipro
* Modification Log =============================================================== 
Ver Date Author Modification --- ---- ------ -------------
* */ 

trigger PlannedMeetingAttendee_checkContact_EventTeam on Planned_Meeting_Attendee__c (after insert, after update) {
   //Variable Declaration
    /*commenting trigger code for coverage
    List<Planned_Meeting_Attendee__c> PMAlist=Trigger.new;
    Map<Id,Id> attendee_PM_map=new Map<Id,Id>();
    Map<Id,Id> Team_Contact_map=new Map<Id,Id>();
    List<Id> PM_Contact_list=new List<Id>();
    List<Id> PM_user_list=new List<Id>();
    List<Id> Team_Contact_list=new List<Id>();
    List<Id> Team_User_list=new List<Id>();
    List<Id> pids=new List<Id>();
    List<Planned_Meeting_Attendee__c> errorlst=new List<Planned_Meeting_Attendee__c>();
    List<Planned_Meeting_Attendee__c> errorlst1=new List<Planned_Meeting_Attendee__c>();
    Map<Id,String> m=new Map<Id,String>();
    Integer p=1;
    
    if(PMAList.size()>0){
        for(Integer i=0;i<PMAlist.size();i++){
             if(PMAList[i].Planned_Meeting_RecordType__c!='Opportunity Review'){
                  if(Trigger.new[i].Contact__c!=null && Trigger.new[i].Contact_isInternal__c=='TRUE'){
                     attendee_PM_map.put(PMAlist[i].Id,PMAlist[i].Event_Formula__c); 
                    PM_Contact_list.add(PMAlist[i].Contact__c);
                }
                if(Trigger.new[i].User__c!=null){
                    attendee_PM_map.put(PMAlist[i].Id,PMAlist[i].Event_Formula__c);
                    PM_user_list.add(PMAlist[i].User__c);
                }
            }
        }
    }
     if(attendee_PM_map.size()>0){
        for(Event_Team__c team:[Select Contact__c,Event__c,User__c from Event_Team__c where Event__c IN :attendee_PM_map.values()]){
            Team_Contact_map.put(team.Id,team.Contact__c);
            Team_Contact_list.add(team.Contact__c);
            Team_User_list.add(team.User__c);
        }
        if(PM_Contact_list.size()>0 && Team_Contact_list.size()>0){
              integer Contactflag=0;
            for(Integer j=0;j<PM_Contact_list.size();j++){
           Contactflag=0;
                for(Integer k=0;k<Team_Contact_list.size();k++){
                     if(PM_Contact_list[j]==Team_Contact_list[k]){
                        p=0;Contactflag=1;
                       // errorlst.clear();
                       // break;

                    }
                    else
                   {}
                }//end of for
                   if(Contactflag==0)
                   errorlst.add(Trigger.new[j]);
                       //Trigger.new[0].addError('Contact not in Event team');
                     //  errorlst.add(Trigger.new[j]);
                
            }
             if(errorlst.size()>0){
                for(Integer g=0;g<errorlst.size();g++){
                    errorlst[g].addError('The Internal Contact that you are trying to add as Planned Meeting Attendee is not part of the Event team of the Event associated with this Planned meeting');
                }
            }    
        }
        if(PM_User_list.size()>0 && Team_User_list.size()>0){
         integer Userflag=0;
            for(Integer j=0;j<PM_User_list.size();j++){
            Userflag=0;
                for(Integer k=0;k<Team_User_list.size();k++){
                     if(PM_User_list[j]==Team_User_list[k]){
                        p=0;Userflag=1;
                        //errorlst1.clear();
                        //break;

                    }
                    else{}
                       //Trigger.new[0].addError('Contact not in Event team');
                       //errorlst1.add(Trigger.new[j]);
                }// end of for
                            if(Userflag==0)
                             errorlst1.add(Trigger.new[j]);
            }
              if(errorlst1.size()>0){
                for(Integer g=0;g<errorlst1.size();g++){
                    errorlst1[g].addError('The User that you are trying to add as Planned Meeting Attendee is not part of the Event team of the Event associated with this Planned meeting');
                }
            }    
        }
    }*/
         
}