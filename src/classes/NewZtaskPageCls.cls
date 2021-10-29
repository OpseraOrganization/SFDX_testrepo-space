public with sharing class NewZtaskPageCls {
    public Z_Task__c ZTask{get;set;}
    public string taskid{get;set;} 
    public string caseid{get;set;} 
    Public String Clone1;   
    public NewZtaskPageCls(ApexPages.StandardController controller) {
        Clone1= ApexPages.currentPage().getParameters().get('Cloneid'); 
        ZTask = new Z_Task__c();
        taskid = ApexPages.currentPage().getParameters().get('id');
        system.debug('Ztask.Status__c line 10'+Ztask.Status__c);
        system.debug('Ztask.SubType__c line 24'+Ztask.Sub_Type__c);
        //caseid=ApexPages.currentPage().getParameters().get('CF00N56000000VYtl_lkid');
        caseid=ApexPages.currentPage().getParameters().get(label.SI_TaskActivitiescaseno);
        User u = [select id,firstname,lastname,name,FederationIdentifier  from user where id=:userinfo.getuserid()]; 
        if(caseid !=null){
            ZTask.RelatedTo__c=caseid;       
        }
        ZTask.Ownerid=u.id;
        string FederationIdentifier='';
        if(u.FederationIdentifier != null)
        FederationIdentifier=+'('+u.FederationIdentifier+')';
        List<Case_Extension__c> sfdccaseext = [select id,APU_Workcenter__c,Warranty_requested__c,Warranty_Accepted__c,Warranty_Start_Date__c,Warranty_End_Date__c,Notification_Number__c,Receipt_Date__c,IDS_OTTR_Date__c from Case_Extension__c where Case_object__c=:caseId limit 1];
        if(sfdccaseext.size()>0)
        {
        ZTask.Case_Extension__c=sfdccaseext[0].id;
        }
      // ZTask.Comments__c=system.now()+' '+u.name+' '+FederationIdentifier;
        ZTask.Comments__c='';       
    }
    
    public pagereference CustomSave(){
        system.debug('Ztask.Status__c line 24'+Ztask.Status__c);
        User u = [select id,firstname,lastname,name,FederationIdentifier  from user where id=:userinfo.getuserid()];
        string FederationIdentifier='';
        if(u.FederationIdentifier != null)
        FederationIdentifier=+'('+u.FederationIdentifier+')';
        system.debug('Ztask.Status__c line 28'+Ztask.Status__c); 
        if(ZTask.Comments__c != null)
        {
            ZTask.Long_Text__c=system.now()+' '+u.name+' '+FederationIdentifier+ ' ' + ZTask.Requote_Reason__c +'\n'+ZTask.Comments__c;
            ZTask.New_Long_Text__c = ZTask.Comments__c;
            ZTask.Comments__c='';           
        }
        if(ZTask.Event_Type__c == null)
        {     
            system.debug('Ztask.Status__c line 38'+Ztask.Status__c);
            if(ZTask.Status__c != 'Closed')
            {
                ZTask.Event_Type__c = 'TASK CREATION';
            }
            
            else if(ZTask.Status__c == 'Closed')
            {
                system.debug('Ztask.Status__c line 47'+Ztask.Status__c);
                ZTask.Event_Type__c = 'TASK CLOSE';
            }
            
            else 
            {
                system.debug('Ztask.Status__c line 52'+Ztask.Status__c);
                ZTask.Event_Type__c = 'TASK CREATION';
            }
        }
        ZTask.Name=ZTask.type__c;
        ZTask.Task_Created_By__c=u.name;
        ZTask.Task_Created_Date_Time__c=system.now();
        system.debug('Ztask.Status__c line 57'+Ztask.Status__c);
        system.debug('shorttext---'+ZTask.Sub_Type__c); 
        if(ZTask.Sub_Type__c == null)
        {
            system.debug('inside shorttext---'+ZTask.Sub_Type__c); 
            ZTask.Sub_Type__c='';
        }
        insert ZTask;
        system.debug('Ztask----->'+ZTask);
        system.debug('Ztask1----->'+ZTask.Task_Created_By__c);
        system.debug('Ztask2----->'+ZTask.Task_Created_Date_Time__c);
        
                
        /*try{
            if(Clone1=='1')
            {
            ZTask.id = null;
            insert ZTask;
            }
            else
            {
            ZTask.Id = ZTask.id;
            Update ZTask;
            }
        }
        catch(Exception e){
        ApexPages.addMessages(e);
        return null;
        }*/     
        //Update ZTask;
        system.debug('ZTask.Status__c#######'+ZTask.Status__c);
        if(ZTask.Status__c =='Close Follow-Up Task')
        {
            system.debug('inside closed follow');
            ZTask.Status__c='Closed';
            Update ZTask; 
            PageReference pageRef= new PageReference('/apex/ZtaskEditPage?Cloneid='+1+'&id='+ZTask.id);
            pageRef.setRedirect(true); 
            return pageRef;
        }
        else
        {
            return new PageReference('/'+ZTask.id);
        }
    }
    public Void changeshorttext() {
        system.debug('inside chnageshorttext---'+ZTask.Sub_Type__c);        
        if(ZTask.Sub_Type__c != null)
        {   string ztasksubtype= ZTask.Sub_Type__c;
            string ztaskothersubtype= ZTask.Other_Short_Text__c;
            system.debug('ztasksubtype#####'+ztasksubtype);
            system.debug('(ZTask.Sub_Type__c#####'+ZTask.Sub_Type__c);
            if(ztasksubtype.contains('[Case #]'))
            {
                string casenumber='';
                string Createddate='';
                string FederationIdentifier='';             
                if(caseid != null)
                {
                    case c=[select id,casenumber from case where id=:caseid];
                    casenumber=c.casenumber;                    
                }
                User u = [select id,firstname,lastname,name,FederationIdentifier  from user where id=:userinfo.getuserid()]; 
                if(u.FederationIdentifier != null)
                FederationIdentifier='CBM '+u.FederationIdentifier;
                string FederationIdentifier1=FederationIdentifier;  
                string caseno=casenumber;
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
            else if(ztasksubtype == 'Other')
            {
                if(ztaskothersubtype != null)
                {
                   ZTask.Short_Text__c = ztaskothersubtype;
                }
                else
                {
                    ZTask.Short_Text__c = ztasksubtype;
                }
            }
            else
            {
                ZTask.Short_Text__c = ztasksubtype;
            }           
        }
        else
        {
            ZTask.Short_Text__c = '';
            system.debug('venkattestZTask.Short_Text__c------>'+ZTask.Short_Text__c);
        }       
    }
}