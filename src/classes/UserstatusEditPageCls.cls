public with sharing class UserstatusEditPageCls {
    public Activitiy_Line_Item__c Userstatus{get;set;}
    public string Userstatusid{get;set;} 
    public boolean editlayout{get;set;}
    public boolean viewlayout{get;set;}   
    public UserstatusEditPageCls(ApexPages.StandardController controller) {
        Userstatus = new Activitiy_Line_Item__c();
        Userstatusid = ApexPages.currentPage().getParameters().get('id');
        if(Userstatusid !=null){
            Userstatus=[select id,name,Case__c,CaseNumber__c,ChangeNumber__c ,Email_flag__c,Email_Status__c,Name__c ,Name_Link__c,Notification_Number__c,ParentObjectNo__c,ParentRoot__c,SAPUserStatusObjectNumber__c,Status__c,Task_Activities__c from Activitiy_Line_Item__c where id=:Userstatusid];                 
            editlayout=true;
            viewlayout=false;
            system.debug('Userstatus.status__c------>'+Userstatus.status__c);
            if(Userstatus.Task_Activities__c != null && Userstatus.status__c != 'closed')
            {
                system.debug('inside if');
                editlayout=true;
                viewlayout=false;
            }
            else if(Userstatus.Task_Activities__c == null ||  Userstatus.status__c == 'closed')
            {
                system.debug('inside else');
                editlayout=false;
                viewlayout=true;
            }                     
        }
    }
    public pagereference CustomSave()
    {            
        try{
            Userstatus.Id = Userstatus.id;
            Userstatus.status__c=Userstatus.status__c;
            Update Userstatus;
        }
        catch(Exception e){
        ApexPages.addMessages(e);
        return null;
        }
        return new PageReference('/'+Userstatus.id);
    }
}