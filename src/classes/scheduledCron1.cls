/*public class updateCounterFieldOnContact{
public static void methodToUpdate(Contact c){
if(c.Counter_on_update__c==1){
c.Counter_on_update__c=0;
update c;
}
}
}
*/

global class scheduledCron1  implements Database.Batchable<SObject>{

global String query;
global id con;

global scheduledCron1(Contact c){
system.debug('inside the schedule class');
con=c.id;
system.debug('the contact value is'+con);
}


global Database.QueryLocator start(Database.BatchableContext bc){
query='select id,Counter_on_update__c from Contact where id =:con';
system.debug('the query result is'+query);
return Database.getQueryLocator(query);

}

global void execute(Database.batchableContext bc,List<SObject> scope){
for(Sobject s : scope){
      Contact newCont = (Contact) s;
      if(newCont.Counter_on_update__c ==1){
      newCont.Counter_on_update__c=0;
      update newCont;
      system.debug('the contact is updated'+newCont);
      }
}
}

global void finish(Database.BatchableContext bc){

}

}