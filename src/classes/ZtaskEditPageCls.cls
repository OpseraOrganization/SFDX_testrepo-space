Global with sharing class ZtaskEditPageCls {
    public Z_Task__c ZTask{get;set;}
    public Z_Task__c ZTask1{get;set;}
    public string taskid{get;set;} 
    Public String Clone1; 
    public boolean editlayout{get;set;}
    public boolean viewlayout{get;set;} 
    public boolean followuptask{get;set;}
    public boolean closetask{get;set;}  
    public boolean Savefollowuptask{get;set;}
    public boolean showuserstatus{get;set;}
    //Our collection of the class/wrapper objects userstatus
    public List<UserstatusInner> UserstatusInnerlist {get; set;}
    public List<Activitiy_Line_Item__c> selectedstatus{get;set;}    
    public ZtaskEditPageCls(ApexPages.StandardController controller) {
        Clone1= ApexPages.currentPage().getParameters().get('Cloneid'); 
        ZTask = new Z_Task__c();
        ZTask1 = new Z_Task__c();
        taskid = ApexPages.currentPage().getParameters().get('id');
        User u = [select id,firstname,lastname,name,FederationIdentifier  from user where id=:userinfo.getuserid()]; 
        if(taskid !=null){
            ZTask=[select id,name,createddate,OwnerId ,Followuptask__c,Followup_Task__c,Requote_Reason__c,Followup_Task1__c,Other_Short_Text__c ,Language_Key__c,Account_Name__c,Comments__c,Description__c,Details__c,Due_Date__c,type__c,Sub_Type__c,Short_Text__c,Long_Text__c,Priority__c,Project_Name__c,RelatedTo__c,CaseNumber__c,Resolution__c,SAP_ZTask_Number__c,Status__c,Subject__c,To__c,Z_Task__c from Z_Task__c where id=:taskid];       
            string FederationIdentifier='';
            if(u.FederationIdentifier != null)
            FederationIdentifier=+'('+u.FederationIdentifier+')';
            //ZTask.Comments__c=system.now()+' '+u.name+' '+FederationIdentifier;
            editlayout=true;
            viewlayout=false;
            followuptask=true;
            Savefollowuptask=false;
            system.debug('ZTask.status__c------>'+ZTask.status__c);
            if( ZTask.status__c != 'Closed')
            {
                system.debug('inside if');
                editlayout=true;
                viewlayout=false;
            }
            else
            {
                system.debug('inside else');
                editlayout=false;
                viewlayout=true;
            }
            if(UserstatusInnerlist == null) {
                UserstatusInnerlist = new List<UserstatusInner>();
                List<String> userstatuslist = new List<String>(); 
                String[] userstatuslst = (label.Ztask_User_Status).split(';');        
                if(userstatuslst.size() > 0){            
                    for(String i : userstatuslst){
                        userstatuslist.add(i);
                    }
                }
                for(Activitiy_Line_Item__c a: [select id,name,name__c,status__c,Notification_Number__c,Description__c,Task_Activities__c from Activitiy_Line_Item__c where case__c =:ZTask.RelatedTo__c  and status__c='open' and name__c =:userstatuslist]) 
                {
                    UserstatusInnerlist.add(new UserstatusInner(a));
                }
            }
            if(ztask.name==label.z136task || ztask.name==label.z146task || ztask.name==label.z156task)  
            {
               showuserstatus=true;             
            }
            else{           
                showuserstatus=true; 
            }           
        }
        if(Clone1=='1')
        {
            //ZTask.Comments__c='';
            string FederationIdentifier='';
            if(u.FederationIdentifier != null)
            FederationIdentifier=+'('+u.FederationIdentifier+')';
            //ZTask.Comments__c=system.now()+' '+u.name+' '+FederationIdentifier;    
            ZTask.Long_Text__c='';
            ZTask.Type__c=ZTask.Followup_Task1__c;
            ZTask.Followup_Task__c='';
            ZTask.Followup_Task1__c='';
            ZTask.Short_Text__c='';
            ZTask.Status__c='Open';
            editlayout=true;
            viewlayout=false;
            followuptask=false;
            Savefollowuptask=true;
        }
    }
    public pagereference CustomSave(){
        User u = [select id,firstname,lastname,name,FederationIdentifier  from user where id=:userinfo.getuserid()]; 
        string FederationIdentifier='';
        if(u.FederationIdentifier != null)
        FederationIdentifier=+'('+u.FederationIdentifier+')'; 
        if(ZTask.Comments__c != null)
        {
            ZTask.New_Long_Text__c = ZTask.Comments__c;        
            if(ZTask.Long_Text__c != '' && ZTask.Long_Text__c != null)
            {
                ZTask.Long_Text__c= system.now()+' '+u.name+' '+FederationIdentifier+'\n'+ZTask.Comments__c+'\n'+ZTask.Long_Text__c;
                ZTask.Comments__c='';
            }
            else 
            {
                ZTask.Long_Text__c=system.now()+' '+u.name+' '+FederationIdentifier+'\n'+ZTask.Comments__c;
                ZTask.Comments__c='';
            }
        }
        else
        {
            ZTask.New_Long_Text__c = '';
        }       
        //ZTask.Task_Changed_Date_Time__c=system.now();
        //ZTask.Task_Changed_By__c=u.name;
        ZTask.Name=ZTask.Type__c;
        try{
            if(Clone1=='1')
            {
                ZTask.id = null;
                ZTask.Comments__c='';
                ZTask.Event_Type__c='TASK CREATION';
                //ZTask.Status__c='Open'; 
                ZTask.recordtypeid=label.TaskActivitiesRecordType;
                ZTask.Task_Created_By__c=u.name;
                //ZTask.Task_Changed_By__c=null;
                //ZTask.Task_Changed_Date_Time__c='';
                ZTask.Task_Created_Date_Time__c=system.now();
                ZTask.New_Followup_Task__c=true;
                insert ZTask;
                if(ZTask.Status__c =='Closed')
                {
                    ZTask.Event_Type__c ='TASK CLOSE';
                }
                else
                {
                    ZTask.Event_Type__c='TASK CREATION';
                }
                List<Z_Task__c> FollowupZTask=new List<Z_Task__c>();
                FollowupZTask=[select id,name,Event_Type__c,createddate,Followuptask__c,OwnerId ,Followup_Task__c,Followup_Task1__c,Other_Short_Text__c ,Language_Key__c,Account_Name__c,Comments__c,Description__c,Details__c,Due_Date__c,type__c,Sub_Type__c,Short_Text__c,Long_Text__c,Priority__c,Project_Name__c,RelatedTo__c,CaseNumber__c,Resolution__c,SAP_ZTask_Number__c,Status__c,Subject__c,To__c,Z_Task__c from Z_Task__c where id=:taskid]; 
                if(FollowupZTask.size()>0)
                {
                    if(FollowupZTask[0].Status__c !='Closed' )
                    {
                        FollowupZTask[0].Status__c ='Closed';
                        FollowupZTask[0].Event_Type__c ='TASK CLOSE';
                        FollowupZTask[0].Followup_Task__c =FollowupZTask[0].Followup_Task1__c;
                        FollowupZTask[0].Followuptask__c=true;
                        update FollowupZTask[0];
                    }
                }
                List<id> taskids=new List<id>();
                taskids.add(ZTask.id);
                taskids.add(taskid);
                SI_ZtaskStatustoSAP1.SendTaskStatus(taskids); 
            }
            else
            {
                ZTask.Id = ZTask.id;
                ZTask.Task_Changed_Date_Time__c=system.now();
                ZTask.Task_Changed_By__c=u.name;
                ZTask.Event_Type__c='TASK UPDATE';
                Update ZTask;
            }
        }
        catch(Exception e){
        ApexPages.addMessages(e);
        return null;
        }
        //Update ZTask;
        system.debug(' ZTask.Status__c'+ ZTask.Status__c);
        if(ZTask.Status__c =='Closed')
        {
            system.debug('inside closed follow');
            ZTask.Event_Type__c ='TASK CLOSE';
            Update ZTask; 
            PageReference pageRef= new PageReference('/'+ZTask.id);
            pageRef.setRedirect(true); 
            return pageRef;
        }
        else
        {
            return new PageReference('/'+ZTask.id);
        }
    }
    public pagereference cancelfollowup()
    {
        taskid = ApexPages.currentPage().getParameters().get('id');
        ZTask1=[select id,name,createddate,OwnerId ,Followup_Task__c,Followuptask__c,Followup_Task1__c,Other_Short_Text__c ,Language_Key__c,Account_Name__c,Comments__c,Description__c,Details__c,Due_Date__c,type__c,Sub_Type__c,Short_Text__c,Long_Text__c,Priority__c,Project_Name__c,RelatedTo__c,CaseNumber__c,Resolution__c,SAP_ZTask_Number__c,Status__c,Subject__c,To__c,Z_Task__c from Z_Task__c where id=:taskid];       
        ZTask1.Followup_Task1__c='No Followup Task';
        ZTask1.Followup_Task__c='No Followup Task';
        system.debug('inside cancel------');
        if(ZTask1.Followuptask__c != false)
        ZTask1.Followuptask__c = false;
        system.debug('inside cancel1------'+ZTask1.Followuptask__c);
        ZTask1.Status__c='Open';
        update ztask1;
        set<id> taskid=new set<id>();
        taskid.add(ztask1.id);
        //SI_ZtaskStatustoSAP.SendTaskStatus(taskid); 
        return new PageReference('/'+ztask1.id);
    }
    public pagereference CloseSave(){
        User u = [select id,firstname,lastname,name,FederationIdentifier  from user where id=:userinfo.getuserid()]; 
        string FederationIdentifier='';
        if(u.FederationIdentifier != null)
        FederationIdentifier=+'('+u.FederationIdentifier+')'; 
        if(ZTask.Comments__c != null)
        {
            ZTask.New_Long_Text__c = ZTask.Comments__c;        
            if(ZTask.Long_Text__c != '' && ZTask.Long_Text__c != null)
            {
                ZTask.Long_Text__c= system.now()+' '+u.name+' '+FederationIdentifier+ + ' ' + ZTask.Requote_Reason__c + '\n'+ZTask.Comments__c+'\n'+ZTask.Long_Text__c;
                ZTask.Comments__c='';
            }
            else 
            {
                ZTask.Long_Text__c=system.now()+' '+u.name+' '+FederationIdentifier+'\n'+ZTask.Comments__c;
                ZTask.Comments__c='';
            }
        }
        else
        {
            ZTask.New_Long_Text__c = '';
        }
        ZTask.Task_Changed_Date_Time__c=system.now();
        ZTask.Task_Changed_By__c=u.name;
        try{
            if(Clone1=='1')
            {
                ZTask.id = null;
                ZTask.Comments__c='';
                ZTask.Event_Type__c='TASK CREATION';
                ZTask.Type__c=ZTask.Followup_Task__c;
                if(ZTask.Status__c =='Closed')
                {
                    ZTask.Event_Type__c ='TASK CLOSE';
                }
                else
                {
                    ZTask.Event_Type__c='TASK CREATION';
                }
                insert ZTask;
                List<Z_Task__c> FollowupZTask=new List<Z_Task__c>();
                FollowupZTask=[select id,name,Event_Type__c,createddate,OwnerId ,Followup_Task__c,Followup_Task1__c,Other_Short_Text__c ,Language_Key__c,Account_Name__c,Comments__c,Description__c,Details__c,Due_Date__c,type__c,Sub_Type__c,Short_Text__c,Long_Text__c,Priority__c,Project_Name__c,RelatedTo__c,CaseNumber__c,Resolution__c,SAP_ZTask_Number__c,Status__c,Subject__c,To__c,Z_Task__c from Z_Task__c where id=:taskid]; 
                if(FollowupZTask.size()>0)
                {
                    if(FollowupZTask[0].Status__c !='Closed' )
                    {
                        FollowupZTask[0].Status__c ='Closed';
                        FollowupZTask[0].Event_Type__c ='TASK CLOSE';
                        FollowupZTask[0].Followup_Task__c =FollowupZTask[0].Followup_Task1__c;
                        update FollowupZTask[0];
                    }
                }
            }
            else
            {
                ZTask.Id = ZTask.id;
                system.debug('inside else----'+ZTask.Id);
                /* if(ZTask.Followup_Task__c !='No Followup Task')
                {
                    ZTask.Status__c ='Closed';
                    ZTask.Event_Type__c='TASK CLOSE';
                }
                else
                {
                    ZTask.Event_Type__c='TASK UPDATE';
                } */
                system.debug('inside status----'+ZTask.Status__c);
                system.debug('inside status----'+ZTask.Followup_Task__c);
                if(ZTask.Status__c =='Closed' && (ZTask.Followup_Task__c=='No Followup Task' || ZTask.Followup_Task__c==null ))
                {
                    ZTask.Event_Type__c ='TASK CLOSE';
                    if(ZTask.Followuptask__c != false)
                    ZTask.Followuptask__c = false;
                }
                else if(ZTask.Status__c =='Open' && ZTask.Followup_Task__c=='No Followup Task')
                {
                    ZTask.Event_Type__c='TASK UPDATE';
                    ZTask.Followup_Task1__c='No Followup Task';
                    if(ZTask.Followuptask__c != false)
                    ZTask.Followuptask__c = false;
                }
                if(ZTask.Status__c =='Closed' && ZTask.Followup_Task__c !='No Followup Task' && ZTask.Followup_Task__c!=null)
                {
                    system.debug('inside closed----'+ZTask.Followup_Task__c);
                    ZTask.Status__c ='Open';
                    ZTask.Event_Type__c ='TASK UPDATE';
                    ZTask.Followup_Task1__c=ZTask.Followup_Task__c;
                    ZTask.Followup_Task__c='No Followup Task';
                }
                else if(ZTask.Status__c =='Open' && ZTask.Followup_Task__c !='No Followup Task')
                {
                    system.debug('inside Open----'+ZTask.Followup_Task__c);
                    ZTask.Event_Type__c='TASK UPDATE';
                    ZTask.Followup_Task1__c=ZTask.Followup_Task__c;
                    ZTask.Followup_Task__c='No Followup Task';
                }
                system.debug('inside status----'+ZTask.Status__c);
                system.debug('inside event type----'+ZTask.Event_Type__c);
                system.debug('inside followup task1----'+ZTask.Followup_Task1__c);
                system.debug('inside followup task----'+ZTask.Followup_Task__c);
                Update ZTask;
            }
        }
        catch(Exception e){
        ApexPages.addMessages(e);
        return null;
        }       
        if(ZTask.Followup_Task1__c !='No Followup Task' && ZTask.Followup_Task1__c !='' && ZTask.Followup_Task1__c !='null' && ZTask.Followup_Task1__c != null)
        {
            system.debug('inside followup task2----'+ZTask.Followup_Task1__c);
            PageReference pageRef= new PageReference('/apex/ZtaskEditPage?Cloneid='+1+'&id='+ZTask.id);
            pageRef.setRedirect(true); 
            return pageRef;
        }
        else
        {
            system.debug('inside else ----'+ZTask.id);
            return new PageReference('/'+ZTask.id);
        }
    }
    public Void changeshorttext() {
        if(ZTask.Sub_Type__c != null)
        {   string ztasksubtype= ZTask.Sub_Type__c; 
            string ztaskothersubtype= ZTask.Other_Short_Text__c; 
            system.debug('ztasksubtype----'+ztasksubtype);
            string FederationIdentifier='';
            User u = [select id,firstname,lastname,name,FederationIdentifier  from user where id=:userinfo.getuserid()]; 
            if(u.FederationIdentifier != null)
            FederationIdentifier='CBM '+u.FederationIdentifier;
            string FederationIdentifier1=FederationIdentifier;              
            if(ztasksubtype.contains('[Case #]'))
            {
                string caseno=ZTask.CaseNumber__c;
                if(caseno != '' && caseno != null)
                {
                    string subtype=ZTask.Sub_Type__c;
                    system.debug('venkattest------>'+subtype);
                    String repl = subtype.replace('[Case #]',caseno);
                    String repl1 = repl.replaceAll('Date',' ');
                    String repl2 = repl1.replaceAll('date',' ');
                    
                    if(repl2.contains('CBM EID'))
                    {                   
                        String repl3 = repl2.replaceAll('CBM EID',FederationIdentifier1);
                        string subtype1 = repl3;
                        system.debug('venkattest11111------>'+subtype1);
                        ZTask.Short_Text__c = subtype1+system.now();
                    }
                    else
                    {
                    string subtype1 = repl2;
                    system.debug('venkattest11111------>'+subtype1);
                    ZTask.Short_Text__c = subtype1+system.now();
                    } 
                }                               
                //string subtype1 = repl2;
                //ZTask.Short_Text__c = subtype1+ZTask.Createddate;
            }
            else if(ztasksubtype == 'Other')
            {
                ZTask.Short_Text__c = ztaskothersubtype;
            }
            else
            {
                ZTask.Short_Text__c = ztasksubtype;
            }           
        }       
    }
    @RemoteAction
    Global static List<Activitiy_Line_Item__c> getstatuslst(id taskid)
    {
        List<Activitiy_Line_Item__c> tasktUserstatuslist = new List<Activitiy_Line_Item__c>();
        List<String> userstatuslist = new List<String>(); 
        String[] userstatuslst = (label.Ztask_User_Status).split(';');        
        if(userstatuslst.size() > 0){            
            for(String i : userstatuslst){
                userstatuslist.add(i);
            }
        }
        Z_Task__c ZTask=[select id,name,createddate,OwnerId ,Followuptask__c,Followup_Task__c,Followup_Task1__c,Other_Short_Text__c ,Language_Key__c,Account_Name__c,Comments__c,Description__c,Details__c,Due_Date__c,type__c,Sub_Type__c,Short_Text__c,Long_Text__c,Priority__c,Project_Name__c,RelatedTo__c,CaseNumber__c,Resolution__c,SAP_ZTask_Number__c,Status__c,Subject__c,To__c,Z_Task__c from Z_Task__c where id=:taskid];
        //to get list of open Z136/Z146/Z156 task count 
        List<Z_Task__c> ZTasklst=[select id,name,createddate,OwnerId ,Followuptask__c,Followup_Task__c,Followup_Task1__c,Other_Short_Text__c ,Language_Key__c,Account_Name__c,Comments__c,Description__c,Details__c,Due_Date__c,type__c,Sub_Type__c,Short_Text__c,Long_Text__c,Priority__c,Project_Name__c,RelatedTo__c,CaseNumber__c,Resolution__c,SAP_ZTask_Number__c,Status__c,Subject__c,To__c,Z_Task__c from Z_Task__c where id !=:taskid and (name =: label.Z136task or name =: label.Z146task or name =: label.Z156task ) and status__c ='open' and RelatedTo__c =:ZTask.RelatedTo__c];
        system.debug('&&&&&&ZTasklst'+ZTasklst);
        system.debug('&&&&&&ZTasklst'+ZTasklst.size());
        if(ZTasklst.size()>0)
        {
            //closetask=false;
        }
        else{
            system.debug('&&&&&&ZTask.name'+ZTask.name);
            if(ZTask.name == label.Z136task || ZTask.name == label.Z146task || ZTask.name == label.Z156task )
            {
            tasktUserstatuslist =[select id,name,name__c,status__c,Task_Activities__c from Activitiy_Line_Item__c where Case__c=:ZTask.RelatedTo__c and  status__c='open' and name__c =:userstatuslist
            //and (Task_Activities__r.name =: label.Z136task or Task_Activities__r.name =: label.Z146task or Task_Activities__r.name =: label.Z156task )
            ];
            }
            else{
            }
        }   
        
        return tasktUserstatuslist ;        
    }
    @RemoteAction
    Global static List<Activitiy_Line_Item__c> getstatus(id taskid)
    {
        List<Activitiy_Line_Item__c> tasktUserstatuslist1 = new List<Activitiy_Line_Item__c>();
        tasktUserstatuslist1 =[select id,name,status__c,Task_Activities__c from Activitiy_Line_Item__c where Task_Activities__c=:taskid and status__c='open'];
        return tasktUserstatuslist1 ;        
    }
    //display userstatus list related list
    public List<Activitiy_Line_Item__c> getuserstatuslist() 
    {
        List<Activitiy_Line_Item__c> tasktUserstatuslist1 = new List<Activitiy_Line_Item__c>();
        tasktUserstatuslist1 =[select id,name,name__c,status__c,Notification_Number__c,Description__c,Task_Activities__c from Activitiy_Line_Item__c where Task_Activities__c=:taskid and status__c='open'];
        return tasktUserstatuslist1 ;
    }
    public void closeuserstatus() {
        selectedstatus = new List<Activitiy_Line_Item__c>();
        Z_Task__c ZTask=[select id,RelatedTo__c from Z_Task__c where id=:taskid];
        for(UserstatusInner UserstatusInnerObj : UserstatusInnerlist) {
            if(UserstatusInnerObj.selected == true) {
                selectedstatus.add(UserstatusInnerObj.acc);
            }
        }
        List<Activitiy_Line_Item__c> closestatuslst = new List<Activitiy_Line_Item__c>();
        if(selectedstatus.size()>0)
        {
            for(Activitiy_Line_Item__c accline:selectedstatus)
            {
                accline.status__c='closed';
                closestatuslst.add(accline);
            }
        }
        if(closestatuslst.size()>0)
        {
            update closestatuslst;
            UserstatusInnerlist = new List<UserstatusInner>();
            List<String> userstatuslist = new List<String>(); 
            String[] userstatuslst = (label.Ztask_User_Status).split(';');        
            if(userstatuslst.size() > 0){            
                for(String i : userstatuslst){
                    userstatuslist.add(i);
                }
            }
            for(Activitiy_Line_Item__c a: [select id,name,name__c,status__c,Notification_Number__c,Description__c,Task_Activities__c from Activitiy_Line_Item__c where case__c =:ZTask.RelatedTo__c  and status__c='open' and name__c =:userstatuslist])                
            {
                UserstatusInnerlist.add(new UserstatusInner(a));
            }
        }
    }
    public class UserstatusInner {
        public Activitiy_Line_Item__c acc {get; set;}
        public Boolean selected {get; set;}
 
        public UserstatusInner(Activitiy_Line_Item__c a) {
            acc = a;
            selected = false;
        }
    }   
}