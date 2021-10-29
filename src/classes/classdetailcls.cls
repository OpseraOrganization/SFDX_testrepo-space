public with sharing class classdetailcls {

    public String  uid ;
    public String stremail;
    public String domainemail;     
    public string paramval{get;set;}
    private integer index = 0;
    private integer blockSize = 5;    
    public final Class__c cls;
    public integer totalRecs=0; 
    public String posId;    
    public user use;
    public boolean showContent{get;set;} 
    public boolean showContent1{get;set;}      
    public String posName;
    public boolean prev;
    public boolean nxt;
    
    public classdetailcls(ApexPages.StandardController controller) {
        uid = Userinfo.getuserid();
        this.cls= (Class__c) controller.getRecord();
        posId= this.cls.Id;
        showContent1=false;            
    }
    public user getuse()
    {
      user use=[select id,Batch_User__c ,ProfileId,name,ContactId from user where id=:uid ];
      return use;
    }
    
    public List<Reservation__c> getMemb() 
    {
            user use=[select id,Batch_User__c ,ProfileId,name,ContactId from user where id=:uid ];     
            if(use.ContactId  != null && use.Batch_User__c == true && (use.ProfileId == label.Training_Customer_Portal_label || use.ProfileId == label.Training_and_Idea_Customer_Portal_label))
            {
               showContent=true;  
               Class__c cls=[select id,name,End_Date__c,Seats_Remaining__c from Class__c where id=:posId];
               if(cls.Seats_Remaining__c >0 && cls.End_Date__c >= System.Today())
               {
                 showContent1=true;            
               }
               contact c=[select id,name,email from contact where id=:use.ContactId];
               stremail=c.email;
               domainemail=stremail.substring(stremail.indexof('@')+1,stremail.length());          
               totalRecs = [select count() from  Reservation__c WHERE Class_Name__c =:posId and email__c like :'%'+domainemail+'%'];             
               List<Reservation__c> attList = [SELECT id,Class_Name__c,Reservation_Name__c,Class__c,Attended__c,Student__c,Course_Name__c,Reservation_Status__c,email__c,Name FROM Reservation__c WHERE Class_Name__c =:posId and email__c like :'%'+domainemail+'%' LIMIT :blockSize OFFSET :index];                      
               return attList;           
            }
            else if(use.ContactId  != null && use.Batch_User__c == false && (use.ProfileId == label.Training_Customer_Portal_label || use.ProfileId == label.Training_and_Idea_Customer_Portal_label))
           {
               showContent=true;  
               Class__c cls=[select id,name,End_Date__c,Seats_Remaining__c from Class__c where id=:posId];
               if(cls.Seats_Remaining__c >0 && cls.End_Date__c >= System.Today())
               {
                 showContent1=true;            
               }
               contact c=[select id,name,email from contact where id=:use.ContactId];
               stremail=c.email;
               domainemail=stremail.substring(stremail.indexof('@')+1,stremail.length());          
               totalRecs = [select count() from  Reservation__c WHERE Class_Name__c =:posId and Student__c=:use.ContactId];             
               List<Reservation__c> attList = [SELECT id,Class_Name__c,Reservation_Name__c,Class__c,Attended__c,Student__c,Course_Name__c,Reservation_Status__c,email__c,Name FROM Reservation__c WHERE Class_Name__c =:posId and Student__c=:use.ContactId LIMIT :blockSize OFFSET :index];                      
               return attList;
           }           
           List<Reservation__c> attList = [SELECT id,Class_Name__c,Reservation_Name__c,Class__c,Attended__c,Student__c,Course_Name__c,Reservation_Status__c,email__c,Name FROM Reservation__c WHERE Class_Name__c =:posId  LIMIT :blockSize OFFSET :index];                      
           return attList;                          
    }
   
    public pagereference reserve()
    {
        pagereference ref=new pagereference('/'+paramval);
       return ref;
    } 
    public void previous()
    {
        index = index - blockSize;
    }
     public void next()
    {
        index = index + blockSize;
    }
    public boolean getprev()
    {
        if(index == 0)
        return false;
        else
        return true;
    } 
    public boolean getnxt()
    {
        if((index + blockSize) > totalRecs)
        return false;
        else
        return true;
    }
        
    public pagereference newreservation()
    {
      pagereference ref=new pagereference('/apex/NewReservation?ClassName=' +posId);
      return ref;
    }
    public pagereference reserveedit()
    {
      //pagereference ref1=new pagereference('https://c.na13.salesforce.com/'+paramval+'/e?retURL=%2Fapex%2FClassDetail%3Fid%3D'+posId+'%26sfdc.override%3D1%26core.apexpages.devmode.url%3D1');
      String strbaseURL = URL.getSalesforceBaseUrl().toExternalForm();
      pagereference ref1=new pagereference(strbaseURL +'/'+paramval+'/e?retURL=%2Fapex%2FClassDetail%3Fid%3D'+posId+'%26sfdc.override%3D1%26core.apexpages.devmode.url%3D1');
      return ref1;
    }    
}