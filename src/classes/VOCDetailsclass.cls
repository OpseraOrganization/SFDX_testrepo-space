public class VOCDetailsclass
{
   public Voice_of_Customer__c ExceptionRecord{get;set;}
   public transient list<attachment> attach{get;set;}
   public string creatorname{get;set;}
   public string ownername{get;set;}
   public string keytakeway{get;set;}
   public VOCDetailsclass(ApexPages.StandardController controller)
    {
           // ExceptionRecord= (Voice_of_Customer__c)controller.getRecord();
            ExceptionRecord= [select Title__c,Honeywell__c,name,Date_of_VOC__c,Source__c,selectedgroup__c,StartDateval__c,VOC_Account__r.name,SBU__c,OEM__c,CreatedById,
                              Platform__r.name,Product_Family__c,Competitor__c,Sensitive__c,Other_Hoenywell_Attendees__c,Key_Takeaways1__c,Product_Name__c,recordtype.name, 
                              Disposition__c,Key_Action_Items__c,Action_Tracking__c,OwnerId from Voice_of_Customer__c
                              where id =:apexpages.currentpage().getparameters().get('id')];
            if(ExceptionRecord.CreatedById!=null){
            user u=[select name from user where id=:ExceptionRecord.CreatedById];
             if(u.name!=null)
               creatorname=u.name;
               }
             system.debug('ExceptionRecord.ownerid$$$$$$$$$$$$$$$$$$'+ExceptionRecord.ownerid);
            if(ExceptionRecord.ownerid!=null){
            list<user>u1=new list<user>();
            u1=[select name from user where id=:ExceptionRecord.ownerid];
            if(u1.size()>0)
                ownername=u1[0].name;
            else{
            Group g1=[select name  from Group where id=:ExceptionRecord.ownerid and type='Queue'];
             if(g1.name!=null)
               ownername=g1.name;
             }}
            /*if(ExceptionRecord.Key_Takeaways__c!=null)
               keytakeway=ExceptionRecord.Key_Takeaways__c.replaceAll('<[/a-zAZ0-9]*>','');*/
            attach=new list<attachment>();
            attach=[select id,parentid,Name from attachment where parentid=:apexpages.currentpage().getparameters().get('id')];
    }
    public pagereference redirect()
    {
      system.debug('ttttttttttttttttttt');
     if(apexpages.currentpage().getparameters().get('createpage')=='true')
        return page.voccreate;
     else
      return page.VOCSearchPage;
    }
   
}