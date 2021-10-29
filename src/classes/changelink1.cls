public with sharing class changelink1{
public String  uid ;
public Boolean callwindow{get;set;}
List<Case> cs = new List<Case>();
public String posId=ApexPages.currentPage().getParameters().get('Id');
public changelink1(ApexPages.StandardController controller) {
    uid = Userinfo.getuserid();
    callwindow = false;
}
public pagereference UpdateOwner()
{
 //PageReference pageRef1 = new PageReference('https://na13.salesforce.com/'+posId+'/a?retURL=%2F'+posId);
 String strbaseURL = URL.getSalesforceBaseUrl().toExternalForm();
 PageReference pageRef1 = new PageReference(strbaseURL +'/'+posId+'/a?retURL=%2F'+posId);
 return pageRef1;
}
public void redirect()
{
 callwindow = true;
 //PageReference pageRef = new PageReference('https://www.visualcompliance.com/logon.html');
 //return pageRef;
}
}