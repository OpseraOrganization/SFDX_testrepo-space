trigger updateAuthorizedServiceTool on Account (after insert, after update) {
String profid=(UserInfo.getProfileId().substring(0,15));
if(profid!=label.DeniedpartyAPIuserprofile){
List<Account> updatesAccountsList = Trigger.new;
Set<Id> templateIds=new Set<Id>();
List<Id> accIds=new List<Id>();
List<Account_Tools__c> accTools=new List<Account_Tools__c>();
List<Portal_Tools_Master__c> ptm=[SELECT Id, Name FROM Portal_Tools_Master__c where Name = 'Authorized Service Centers' and Tool_Active__c = TRUE];
List<Account_Tools__c> toolExists=[select id from Account_Tools__c where Account_Name__c in :Trigger.new and Name = 'Authorized Service Centers'];
System.debug('toolExists : '+toolExists);
System.debug('toolExists Size : '+toolExists.size());
Boolean flag = false;
for(Account acc : updatesAccountsList){
if(acc.Authorized_Service_Center__c == true && ptm.size()>0 && (toolExists.size() == 0) && acc.Customer_Status__c!='Inactive'){ //
flag = false;
Account_Tools__c accTool=new Account_Tools__c();
accTool.Account_Name__c = acc.Id;
accTool.Portal_Tool_Master_Name__c = ptm[0].Id;
accTool.Name = ptm[0].Name;
accTool.Authorization_Method__c = 'Auto Approved';
accTools.add(accTool);
}else{
accIds.add(acc.Id);
flag = true;
}
}
if(flag == false){
if(accTools!=null && accTools.size()>0){
try {
insert accTools;
}catch(Exception ex){}
}
}else {
if(toolExists.size() == 0){
List<Account_Tools__c> delAccTools=[select id from Account_Tools__c where Account_Name__c in :accIds and Name = 'Authorized Service Centers'];
if(delAccTools!=null && delAccTools.size()>0){
    try {
        Database.delete(delAccTools);
    }catch(Exception ex){}
}
}
}
}
}