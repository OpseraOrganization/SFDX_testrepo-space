public class ContactToolAccessExportController{
public List<Contact_Tool_Access__c> lstCntToolAccess{get;set;}
public ContactToolAccessExportController(){
lstCntToolAccess=exportCntToolAccessList();
}
public List<Contact_Tool_Access__c> exportCntToolAccessList(){
List<Contact_Tool_Access__c> tempList=[select name,CRM_Contact_ID__c,Portal_Tool_Master__c,Account_Name__c,Request_Status__c,Request_Date__c from Contact_Tool_Access__c limit 50000];
return tempList;
}
}