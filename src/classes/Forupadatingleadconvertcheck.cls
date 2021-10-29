Public class Forupadatingleadconvertcheck{
public string leadid ;
   public  Forupadatingleadconvertcheck(ApexPages.StandardController controller) 
    {
     leadid =Apexpages.currentPage().getParameters().get('id');         
    }
    
    public PageReference updatelead(){
    Lead ld= [select id,LeadConvert_Check__c from lead where id=:leadid]; 
    ld.LeadConvert_Check__c=true;
    try{
    update ld;
    }catch (Exception e){
    //String err=e;
    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,''
          +e);
        ApexPages.addMessage(myMsg); 
    //ApexPages.addMessage (new ApexPages.Message(ApexPages.Severity.ERROR,''));  
    }
     PageReference pageRef = new PageReference('/lead/leadconvert.jsp?retURL=%2F'+ld.id+'&id='+ld.id);
     return pageRef ;
    }
}