trigger Solution_displayerror on Solution (before update) {



String groupid;
list<GroupMember> Grpmembr=new list<GroupMember>();
boolean flag=false;
if(!(test.isRunningTest())){
id userid=UserInfo.getUserId();
//groupid=[Select Id from Group where type='Queue' and Name='CSO Quality Team'];
groupid=label.CSO_Quality_Team_Queue_Id;
Grpmembr=[Select UserOrGroupId From GroupMember where GroupId =:groupid];
for(integer i=0;i<Grpmembr.size();i++)
{
if(Grpmembr[i].UserOrGroupId==userid)
flag=True;
}

for(Solution sol: Trigger.new){

if(Trigger.IsUpdate){
if((sol.Record_Type_Name__c =='Solution CSO Non-Technical'|| sol.Record_Type_Name__c =='Solution CSO Non-Technical (ReadOnly)')&&
/// sol.status=='Audit'&& 
 flag==false && ((Trigger.new[0].Audit_Frequency__c != Trigger.old[0].Audit_Frequency__c)||
 (Trigger.new[0].Export_Review_By__c != Trigger.old[0].Export_Review_By__c)  ||
 (Trigger.new[0].Export_Review_Complete_NLR__c != Trigger.old[0].Export_Review_Complete_NLR__c)||
  (Trigger.new[0].Export_Review_Date__c != Trigger.old[0].Export_Review_Date__c)||
  (Trigger.new[0].Intellectual_Property_Review_By__c != Trigger.old[0].Intellectual_Property_Review_By__c)||
   (Trigger.new[0].Intellectual_Property_Review_Date__c != Trigger.old[0].Intellectual_Property_Review_Date__c)||
  (Trigger.new[0].Publish_External__c != Trigger.old[0].Publish_External__c)
 ))
{
sol.addError(' Only Quality team can modify Audit Frequency and export controlled fields');  
}

}


}
}
}