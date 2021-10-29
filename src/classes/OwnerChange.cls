public class OwnerChange {
    public String  uid ;
    public Boolean callwindow{get;set;}
    public Boolean callwindow1{get;set;}
    public String posId=ApexPages.currentPage().getParameters().get('Id');
    public OwnerChange(ApexPages.StandardController controller) {
        uid = UserInfo.getUserId();  
        callwindow = false; 
        callwindow1= false; 
    }     
    public pagereference popup()
    {
       Case cas = [select id, Denied_Party_Alert__c from Case where id =:posId];
       if(cas.Denied_Party_Alert__c != null)
       {
       callwindow = true;
       }
       else
       {
       callwindow1= true;
       //pagereference ref=new pagereference('https://cs15.salesforce.com/'+posId+'/a?retURL=%2F'+posId);
       //return ref;
       }
       return null;
    }
}