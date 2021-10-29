trigger AllowDelete on Skills2__c(before delete) {
/*commenting trigger code for coverage
list<User> currentUser = [Select EmployeeNumber,id from User where id = :UserInfo.getUserid() limit 1];  
system.debug('lllll'+currentUser);
list<string> CntEid = new list<string>();
String prof=Userinfo.getProfileId();
String profname=[Select name from Profile where Id=:prof].name;
profname=profname.tolowercase();
for(skills2__C skllst : trigger.old)
{
    system.debug('2222222'+currentUser[0].EmployeeNumber);
    system.debug('3333333'+skllst.Contact_EID__c);
    system.debug('4444444'+profname);
if((currentUser[0].EmployeeNumber!=skllst.Contact_EID__c) && (!(profname.contains('admin'))))   
trigger.old[0].adderror('Please Contact your System Administrator: Deletion Not Permitted');

}
 */
}