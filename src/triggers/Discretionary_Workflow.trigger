/** * File Name: Discretionary_Workflow 
* Description Trigger to update Discretionary fields based on Opportunity, Campaign and User
* Copyright : Wipro Technologies Limited Copyright (c) 2010
* * @author : wipro
* Modification Log =============================================================== 
Ver Date Author Modification --- ---- ------ -------------
* */ 

trigger Discretionary_Workflow on Discretionary__C(before update,before insert)
 {
        List<Id>oppId=new List<Id>();
        List<Id>cmpId=new List<Id>();
        List<Id>ownId=new List<Id>();
        List <Discretionary__C>dis1=Trigger.new ;
        List <Discretionary__C>dis = new list<Discretionary__C>();
        set<string> sbuSet = new set<string>();
        set<string> cbtSet = new set<string>();
        set<string> gbeSet = new set<string>();
        set<id> opportunityIdSet = new set<id>();
        List <Discretionary__C> disUp = new list<Discretionary__C>();
        
       
        set<id> discretionaryOwners = new set<id>();
        map<id,User> userData = new map<id,User>();
        for (Discretionary__C dr : dis1)
            {
                opportunityIdSet.add(dr.Opportunity__c);
                if(dr.Approval_Status__c == 'Pending Approval' || dr.Approval_Status__c == 'New')
                {
                    dis.add(dr);
                    if(dr.Approval_Status__c == 'Pending Approval'){
                        sbuSet.add(dr.SBU__c);
                        cbtSet.add(dr.CBT__c);
                        gbeSet.add(dr.GBE__c);
                    }
                }
                if(dr.SBU__c == 'ACS Labs'){
                    discretionaryOwners.add(dr.ownerId);
                }
            }            
        if(discretionaryOwners.size()>0){
            userData = new Map<id,User>([select id,name,email,Discretionary_Workflow_Approver__r.Full_Name__c,Discretionary_Workflow_Approver__c,Discretionary_Workflow_Approver__r.email,Discretionary_Workflow_Backup__c,Discretionary_Workflow_Backup__r.email,DelegatedApproverId from User where id in :discretionaryOwners]);
        }
        for (Discretionary__C D : dis)
            {
            D.Owner__c = D.OwnerID;
            
            //Code change for SR#383122  - Start
            if(trigger.isinsert || (D.CBT__c!=Trigger.oldMap.get(D.Id).CBT__c)) 
            {
               if(D.CBT__c=='EMS')
                {
                      D.OwnerID=null;
                      choosemanager t = new choosemanager();
                      t.approverselect(D);
                }
            }
            //Code change for SR#383122  - End 
             
                 
            if (D.SBU__c==null)
                {
                    D.SBU__c =  D.SBUFormulae__c;
                }
            if (D.CBT__c==null)
                {
                     D.CBT__c = D.CBTFormulae__c;
                }
                            
            /* Update CBT Team,CBT Directorate, Program and Account from Opportunity */
            if(D.CBT_Team__c==null)
                {
                    D.CBT_Team__c = D.CBT_Team_Formula__c;
                }
                if(D.CBT_Directorate__c==null)
                {
                    D.CBT_Directorate__c=D.CBT_Directorate_formula__c;
                }
            
            /* Update owner and Account from Opportunity when the Request is associated to a Opportunity */
            if(D.Opportunity__c != null)
                {
                     D.OwnerId = D.OpportunityOwner__c;
                     D.Account__c = D.Customer_Opp_Formula__c;   
                }
            /* Update Account from Campaign when the Request is associated to a Campaign */
            else if (D.Campaign__c!=null)
                {
                    D.Account__c = D.Customer__c;
                } 


            system.debug('D.Discretionary_Workflow_Approver_Amount__c -- '+D.Discretionary_Workflow_Approver_Amount__c);
            system.debug('D.Owner__r.Discretionary_Workflow_Approver_Amount__c -- '+D.Owner__r.Discretionary_Workflow_Approver_Amount__c);
            system.debug('D.Total_Request_Amount_rollup__c -- '+D.Total_Request_Amount_rollup__c);
            system.debug('D.SBU__c -- '+D.SBU__c);
            Decimal requestAmt = 0.0;
            if(D.Discretionary_Workflow_Approver_Amount__c != null){
                requestAmt = decimal.valueOf(D.Discretionary_Workflow_Approver_Amount__c);
            }                
                 
            if (D.Total_Request_Amount_rollup__c!=0 && D.Total_Request_Amount_rollup__c!=null)
            {
                system.debug('Inside main check'+D);
                system.debug('requestAmt :'+requestAmt);
                if (requestAmt!=null && D.Total_Request_Amount_rollup__c< requestAmt)
                {
                    system.debug('D.CurrentUserEmail__c -- '+D.CurrentUserEmail__c);
                    system.debug('D.CurrentUserBackup__c -- '+D.CurrentUserBackup__c);
                    User ownerDetails = userData.get(D.OwnerId);
            if(ownerDetails != null){
            D.Approver_EmailId__c=ownerDetails.Email;
            D.Current_Approver__c=ownerDetails.Name;
            }
                    
                    D.Backup_EmailId__c=D.CurrentUserBackup__c;
                    
                    system.debug('D.Owner.Name value:'+D.Owner.Name);
                }else if(D.SBU__c=='ACS Labs' && requestAmt!=null && D.Total_Request_Amount_rollup__c<= requestAmt){
                      system.debug('Iam Here line1');
                      User ownerDetails = userData.get(D.OwnerId);
              if(ownerDetails != null){
            D.Approver_EmailId__c=ownerDetails.Email;
            D.Current_Approver__c=ownerDetails.Name;
              }
                    
                    D.Backup_EmailId__c=D.CurrentUserBackup__c;
                    
                }else if(D.SBU__c=='ACS Labs' && requestAmt!=null && D.Total_Request_Amount_rollup__c> requestAmt){
                    system.debug('requestAmt:'+requestAmt+' D.Total_Request_Amount_rollup__c:'+D.Total_Request_Amount_rollup__c);
                    system.debug('Iam Here line2');
                    User ownerDetails = userData.get(D.OwnerId);
            if(ownerDetails != null){
            D.Approver_EmailId__c=ownerDetails.Discretionary_Workflow_Approver__r.email;
            D.Backup_EmailId__c=ownerDetails.Discretionary_Workflow_Backup__r.email;
            }
                    
                    if(D.Discretionary_Workflow_Approver__c != null){
                                system.debug('Iam Here line3');
            if(ownerDetails != null){
                D.Current_Approver__c=ownerDetails.Discretionary_Workflow_Approver__r.Full_Name__c;
            }
                    }else{
                            system.debug('Iam Here line4');
                        D.addError('Over discretionary spend approval limit and no overspend approver identified. Please contact your Salesforce administrator.');
                    }
                }
                else
                {
                    system.debug('Else block');
                    choosemanager t = new choosemanager();
                    t.approverselect(D);    
                }
            }
            if(D.SBU__c=='ACS Labs' && Trigger.isUpdate && D.Escalate_To_Delegate__c){
                User ownerDetails = userData.get(D.OwnerId);
        if(ownerDetails != null){
            User userDeatils = [select id,email,Full_Name__c from user where id =:ownerDetails.DelegatedApproverId];
            D.Approver_EmailId__c=userDeatils.email;
            D.Current_Approver__c=userDeatils.Full_Name__c;
        }
            }
          }
          
          // Logic written for ticket#:237
          if(Trigger.isUpdate){
            boolean foundWithGbe = false;
            system.debug('sbuSet value:'+sbuSet);
            system.debug('cbtSet value:'+cbtSet);
            system.debug('gbeSet value:'+gbeSet);
            list<DR_Approvers_List__c> DRAlist = new list<DR_Approvers_List__c>();
            if(sbuSet.size()>0 && cbtSet.size()>0 && gbeSet.size()>0){
                DRAlist = new list<DR_Approvers_List__c>([SELECT Id,Approver__c,Approver__r.Full_Name__c,Approver_Email__c FROM DR_Approvers_List__c WHERE SBU__c =:sbuset AND CBT__c =: cbtset AND GBE__c =:gbeset]);
                if(DRAlist != null && DRAlist.size()>0){
                    foundWithGbe = true;
                }
            }
            if(sbuSet.size()>0 && cbtSet.size()>0 && !foundWithGbe){
                DRAlist = new list<DR_Approvers_List__c>([SELECT Id,Approver__c,Approver__r.Full_Name__c,Approver_Email__c FROM DR_Approvers_List__c WHERE SBU__c =:sbuset AND CBT__c =: cbtset]);
                system.debug('After query'+DRAlist);
            }
            map<id,Opportunity> oppMap = new map<id,Opportunity>();
            if(opportunityIdSet.size()> 0){
                oppMap = new map<id,Opportunity>([select owner.name,owner.id,owner.email,owner.UserRole.name from Opportunity where id in :opportunityIdSet]);
            }
            system.debug('Inside 121'+DRAlist);
            if(DRAlist != null && DRAlist.size()>0){
                for (Discretionary__C dr : dis1){
                   
                        dr.DR_Approver_ID__c = DRAlist.get(0).id;
                        dr.Current_Approver__c = DRAlist.get(0).Approver__r.Full_Name__c ;
                        dr.Approver_EmailId__c = DRAlist.get(0).Approver_Email__c;
                   
                    
                }
            }
            for (Discretionary__C dr : dis1){
                    system.debug('Inside 123'+dr.sbu__c+','+dr.Type__c+','+dr.Total_Request_Amount_rollup__c);
                    if(dr.SBU__c =='D&S' && dr.CBT__c=='Advanced Technology' && dr.Total_Request_Amount_rollup__c <30000){
                        system.debug('My Line 1');
                        Opportunity opp = oppMap.get(dr.Opportunity__c);
                        system.debug('Inside 125'+opp.owner.UserRole.name);
                        
                        if(opp != null && (opp.owner.UserRole.name.contains('Americas AM')||opp.owner.UserRole.name.contains('D&S AT'))){
                            system.debug('Inside 128');
                            //dr.DR_Approver_ID__c = opp.owner.id;
                            dr.Current_Approver__c = opp.owner.name;
                            system.debug('My Line 3');
                            dr.Approver_EmailId__c = opp.owner.email;
                        }else{
                            system.debug('Inside 133');
                            //dr.DR_Approver_ID__c = '005300000041mID'; // Defaulting to Julian Bristow
                            dr.Current_Approver__c = 'Julian Bristow';
                            system.debug('My Line 4');
                            dr.Approver_EmailId__c = 'julian.bristow@honeywell.com';
                        }
                    }else if(dr.SBU__c =='D&S' && dr.CBT__c=='Advanced Technology' && dr.Total_Request_Amount_rollup__c >=30000){
                            //dr.DR_Approver_ID__c = '005300000041mID'; // Defaulting to Julian Bristow
                            dr.Current_Approver__c = 'Julian Bristow';
                            dr.Approver_EmailId__c = 'julian.bristow@honeywell.com';
                    }
                    
                }
          }
        //  code adding to update status closed
        //for (Discretionary__C drup : dis1){
         //if((drup.SBU__c == 'ATR' || drup.SBU__c == 'BGA') && (drup.Total_Approved_Amount__c == drup.Total_Spent_Amount__c) && (drup.Total_Approved_Amount__c !=0 ||  drup.Total_Spent_Amount__c !=0)){
               //drup.Approval_Status__c = 'Closed';
               // disUp.add(drup);
            //}
        //}
}