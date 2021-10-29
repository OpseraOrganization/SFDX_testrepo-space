public with sharing class Marcomrequestformcls {
    private Marcom_Service_Request__c cas;
    public Marcomrequestformcls(ApexPages.StandardController controller) {
      this.cas=(Marcom_Service_Request__c)controller.getRecord();   
    }
    Public Attachment myfile;
    Public Attachment getmyfile()
    {
        myfile = new Attachment();
        return myfile;
    }
    public pagereference dosave()
    {   
         /*attachment rule */ 
        insert cas;
        Attachment a = new Attachment(parentId = cas.id, name=myfile.name, body = myfile.body);
        try{
            insert a; 
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,' Request sucessfully created')); 
           }
        catch(Exception e){
         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Fatal,'Problem in inserting record'));
        }
       PageReference pageRef =new  PageReference('/apex/MarkCommListView?Var01=true');
       return pageRef;
        
            
    }
    
}