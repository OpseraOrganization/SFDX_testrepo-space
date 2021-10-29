global class clearTechPubsRegistrationCaseBatch implements Database.Batchable<sObject>,Schedulable {

    global void execute(SchedulableContext ctx) {
        database.executeBatch(new clearTechPubsRegistrationCaseBatch(),50);
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        string query='select id from case where subject=\'New User Registered for Technical Publications\' and recordtype.name=\'Tech Pubs\' and isclosed=false';
        return database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc, List<sobject> cases){
      List<case> updateCases=new List<Case>();
      for(sobject c:cases){
        case c1=(Case)c;
        c1.status='Done';
        c1.ownerId=userinfo.getUserId();
        updateCases.add(c1);
      }
      
      update updateCases;
    }    
    
    global void finish(Database.BatchableContext bc){
    }    
}