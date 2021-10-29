public class Activatesendemail{
 public Id recid;
 public Boolean backon{get; set;}
 public Activatesendemail(ApexPages.StandardController controller) {
   recid=System.currentPageReference().getParameters().get('id');
 }
 public pagereference updateActivate_send_Email_field(){
 String userId = UserInfo.getuserId();
 User activeUser = [Select Email From User where id= : userId limit 1];
 String userEmail = activeUser.Email;
  Discretionary_Line_Item__c dlt=[select id,AccountOpener__c,Account_Opener_Backup__c,Activate_send_Email__c from Discretionary_Line_Item__c where id =:recid];
  string ud=UserInfo.getProfileId();

  String backup=dlt.Account_Opener_Backup__c;
  
  string accountopeneremail=dlt.AccountOpener__c;
  if( (userEmail==accountopeneremail )|| (userEmail==backup )|| (ud.contains(label.DS_Sales_Admin_Label))){
  dlt.Site_Comment_Drop_Down__c='Close';
  update dlt;
  }else{
  ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Only Account Opener and D&S Sales Admin can close');
  ApexPages.addMessage(myMsg);
  backon=true;
  return null;
  }
  PageReference pageRef = new PageReference('/'+recid);
  return pageref;
 }
 public pagereference back(){
 PageReference pageRef = new PageReference('/'+recid);
 return pageref;
 }
}