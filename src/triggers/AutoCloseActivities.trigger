/***************************************************
**File Name: AutoCloseActivities
**Description: Trigger is automatically close all open activities when Case status changed to cancelled/discard.
**Company Name : Honeywell Aero
**Date Of Creation:16-Oct-2012
**Version No:1.00
**Created By:Harikishore
** 
*****************************************************/ 
trigger AutoCloseActivities on Case (before update){
/*commenting inactive trigger code to improve code coverage-----
    If (TriggerInactive.TestCaseCancelled){
        string que,usr,que1,usr1;// Added for SR#:370862
        set<id> idSet = new set<id>();
        List<Task> taskList = new List<Task>();
        List<Case> caseList = new List<case>();
        integer flag = 0;
        for(Case Casee:Trigger.new){
            if(Casee.Status == 'Cancelled' || Casee.Status == 'Discard'){
                idSet.add(Casee.Id);
                flag = 1;
            }
            // Added code for SR#:370862
            que = System.Trigger.OldMap.get(casee.Id).OwnerId;
            usr = System.Trigger.NewMap.get(casee.Id).OwnerId;
            que1 = que.substring(0,3);
            usr1 = usr.substring(0,3);
            if(System.Trigger.OldMap.get(casee.Id).OwnerId != System.Trigger.NewMap.get(casee.Id).OwnerId){
                if(que1 != usr1 && (que1=='00G' && usr1 == '005')){
                    casee.Date_Time_Stamp_First_Assigned_to_User__c = system.now();
                }else if(que1=='005' && usr1=='005'){
                    casee.Date_Time_Stamp_User_Assignment_Change__c = system.now();
                }else if(que1=='005' && usr1=='00G'){
                    casee.Date_Time_Stamp_First_Assigned_to_User__c = null;
                    casee.Date_Time_Stamp_User_Assignment_Change__c = null;
                }
            }
            // End code for SR#:370862
            // Added code for SR#399645
            String str1 = System.Trigger.OldMap.get(casee.Id).Status;
            String str2 = System.Trigger.NewMap.get(casee.Id).Status;
            if(System.Trigger.OldMap.get(casee.Id).Status!=System.Trigger.NewMap.get(casee.Id).Status){
                if(str1 == 'Open' && str2 == 'On Hold')
                    casee.Status_changed__c = true;
                else if(str1 == 'Re-Open' && str2 == 'On Hold')
                    casee.Status_changed1__c = true;
                else{
                    casee.Status_changed__c = false;
                    casee.Status_changed1__c = false;
                }
            }
            // End for SR#399645
        }
        if (flag == 1)
        {
            try{
                caseList = [Select id,Status from case where id IN:idSet];
            }catch(QueryException e){
            System.debug('Exception occured '+e);
            }
            if(idSet !=null && idSet.size() >0){
                taskList = [Select id,Status from  Task where whatid IN:idSet];
            }
            if( caseList != null && caseList.size() > 0){
                for(Case Casee:caseList){
                    if(taskList != null && taskList.size() > 0){
                        for(Task tsk:taskList){
                            tsk.Status = 'Completed';
                        }
                        try{
                            update taskList;
                        }Catch(DMLException ex)
                        {
                        System.debug('Exception occured '+ex);
                        }
                    }
                }
            }
            return;
        }
    }*/
}