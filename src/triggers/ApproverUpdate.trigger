trigger ApproverUpdate on WorkFlow_Approval_History__c (After Insert, After Update) {
List<WorkFlow_Approval_History__c> WAHlist = new List<WorkFlow_Approval_History__c>();
List<Approver__c> APPlist = new List<Approver__c>();
Approver__c app =new Approver__c();
List<Id> appid = new List<ID>();
List<WorkFlow_Approval_History__c> UPList = new List<WorkFlow_Approval_History__c>();

    if(Trigger.IsAfter){
        for(WorkFlow_Approval_History__c WAH : Trigger.new)
        {
            if(WAH.Select_Approver__c != null){
                WAHlist.add(WAH);
                appid.add(WAH.Select_Approver__c);
            }
        }
        system.debug('NNNNNNNNNNNNNNNN'+WAHlist);
        
        List<WorkFlow_Approval_History__c> newWAH = new List<WorkFlow_Approval_History__c>();
        List<WorkFlow_Approval_History__c> upWAH = new List<WorkFlow_Approval_History__c>();
        if(WAHlist.size()>0)
        newWAH = [Select id,Select_Approver__c,Approver__c,Approval_submitted_date__c from WorkFlow_Approval_History__c where id in : WAHlist];
        system.debug('VVVVVVVVVVVVVVVVVVV'+newWAH);
        if(newWAH.size()>0)
        Applist = [select Delegate_Name_Text1__c, Delegate_Name1__c, Delegation_Valid_From1__c, Delegation_Valid_To1__c, Out_of_Office1__c, Delegate_Email_1__c, Approver_Name__c,Approver_Name__r.name,Ownerid,Delegate_Name_dummy__c,To__c,From__c,id, Out_of_Office__c, Delegate_Name__c, Delegate_Email__c, 
                   Delegate_Name_Text2__c, Delegate_Name2__c, Delegation_Valid_From2__c, Delegation_Valid_To2__c, Out_of_Office2__c, Delegate_Email_2__c, 
                   Delegate_Name_Text3__c, Delegate_Name3__c, Delegation_Valid_From3__c, Delegation_Valid_To3__c, Out_of_Office3__c, Delegate_Email_3__c, 
                   Delegate_Name_Text4__c, Delegate_Name4__c, Delegation_Valid_From4__c, Delegation_Valid_To4__c, Out_of_Office4__c, Delegate_Email_4__c, Delegation_Required_From__c, Delegation_Required_To__c from Approver__c where id in : appid];
        
        if(Applist.size()>0){
            for(WorkFlow_Approval_History__c WAHlist1 : newWAH){
                for(Approver__c app1 : Applist){
                    if(WAHlist1.Select_Approver__c == app1.id){
                        if(app1.Out_of_Office__c){
                            if(WAHlist1.Approval_submitted_date__c >= app1.From__c && WAHlist1.Approval_submitted_date__c <= app1.To__c){
                                if(app1.Delegate_Email__c != null && app1.Delegate_Email__c != ''){
                                    app=[ Select id,ownerid from Approver__c where Email_from_user__c =: app1.Delegate_Email__c limit 1]; 
                                    WAHlist1.Select_Approver__c = app.id;
                                    WAHlist1.ownerid = app.ownerid;
                                    upWAH.add(WAHlist1);
                                }
                            }
                        }
            
                        else if(app1.Out_of_Office1__c){
                            if(WAHlist1.Approval_submitted_date__c >= app1.Delegation_Valid_From1__c && WAHlist1.Approval_submitted_date__c <= app1.Delegation_Valid_To1__c){
                                if(app1.Delegate_Email_1__c != null && app1.Delegate_Email_1__c != ''){
                                    app=[ Select id,ownerid from Approver__c where Email_from_user__c =: app1.Delegate_Email_1__c limit 1]; 
                                    WAHlist1.Select_Approver__c = app.id;
                                    WAHlist1.ownerid = app.ownerid;
                                    upWAH.add(WAHlist1);
                                }
                            }
                        }
            
                       else if(app1.Out_of_Office2__c){
                            if(WAHlist1.Approval_submitted_date__c >= app1.Delegation_Valid_From2__c && WAHlist1.Approval_submitted_date__c <= app1.Delegation_Valid_To2__c){
                                if(app1.Delegate_Email_2__c != null && app1.Delegate_Email_2__c != ''){
                                    app=[ Select id,ownerid from Approver__c where Email_from_user__c =: app1.Delegate_Email_2__c limit 1]; 
                                    WAHlist1.Select_Approver__c = app.id;
                                    WAHlist1.ownerid = app.ownerid;
                                    upWAH.add(WAHlist1);
                                }
                            }
                        }
            
                        else if(app1.Out_of_Office3__c){
                            if(WAHlist1.Approval_submitted_date__c >= app1.Delegation_Valid_From3__c && WAHlist1.Approval_submitted_date__c <= app1.Delegation_Valid_To3__c){
                                if(app1.Delegate_Email_3__c != null && app1.Delegate_Email_3__c != ''){
                                    app=[ Select id,ownerid from Approver__c where Email_from_user__c =: app1.Delegate_Email_3__c limit 1]; 
                                    WAHlist1.Select_Approver__c = app.id;
                                    WAHlist1.ownerid = app.ownerid;
                                    upWAH.add(WAHlist1);
                                }
                            }
                        }
            
                       else if(app1.Out_of_Office4__c){
                            if(WAHlist1.Approval_submitted_date__c >= app1.Delegation_Valid_From4__c && WAHlist1.Approval_submitted_date__c <= app1.Delegation_Valid_To4__c){
                                if(app1.Delegate_Email_4__c != null && app1.Delegate_Email_4__c != ''){
                                    app=[ Select id,ownerid from Approver__c where Email_from_user__c =: app1.Delegate_Email_4__c limit 1]; 
                                    WAHlist1.Select_Approver__c = app.id;
                                    WAHlist1.ownerid = app.ownerid;
                                    upWAH.add(WAHlist1);
                                }
                            }
                        }
                    }
                }
            }  
        }
        
        try{
            system.debug('UUUUUUUUUUUUUU'+upWAH);
            update upWAH;
        }
        catch(DMlException e){
        }
    
    }
}