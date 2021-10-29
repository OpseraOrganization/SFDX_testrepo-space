public with sharing class NewReservationcls {

    public Reservation__c resrev{get;set;}
    public String  uid ;
    public string paramval{get;set;}
    private ApexPages.StandardController sController; 
    public NewReservationcls(ApexPages.StandardController controller) {
        
        sController = controller;  
        resrev = (Reservation__c )controller.getRecord();
        resrev.Class_Name__c = (Id) ApexPages.currentPage().getParameters().get('ClassName');
        uid = Userinfo.getuserid();  
    }
    public pagereference save11()
    {      
       upsert resrev;      
       user use1=[select id,Batch_User__c,ProfileId,name,ContactId from user where id=:uid ];   
       if(use1.Batch_User__c == true)
       {
       pagereference ref=new pagereference('/'+resrev.id);
       return ref;
       }
       else
       {
       pagereference ref=new pagereference('/apex/ReservationDetails?id='+resrev.id);
       return ref;
       }
       
    }
    public pagereference savenew()
    {
       upsert resrev;

       pagereference ref=new pagereference('/apex/NewReservation?ClassName=' + resrev.Class_Name__c );
       ref.setRedirect(true);
       return ref;
    }
    public pagereference cancel()
    {
       //pagereference ref=new pagereference('https://c.na13.visual.force.com/apex/ClassDetail?id='+resrev.Class_Name__c+'&sfdc.override=1');
       String strbaseURL = URL.getSalesforceBaseUrl().toExternalForm();
       pagereference ref=new pagereference(strbaseURL +'/apex/ClassDetail?id='+resrev.Class_Name__c+'&sfdc.override=1');
       return ref;
    }
}