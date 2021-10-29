public with sharing class Assigntome{
public String  uid ;
public Boolean callwindow{get;set;}
List<Case> cs = new List<Case>();
public String posId=ApexPages.currentPage().getParameters().get('Id');
public Assigntome(ApexPages.StandardController controller) {
    uid = Userinfo.getuserid();
    callwindow = false;
}
public void UpdateOwner(){
    Case cas = [select id,Denied_Party_Alert__c,OwnerID from Case where Id=:posId];
    cas.OwnerId = uid;
    update cas;
    callwindow = true;
}
public pagereference redirect()
{
 PageReference pageRef = new PageReference('https://www.visualcompliance.com/logon.html');
 return pageRef;
}
}