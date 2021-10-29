public class emailUnarchivalLight {
    
    /* @AuraEnabled
public static Map<Integer,List<String>> unarchiveEmailMessages(Integer index){
List<String> emailList=new  List<String>();
//List<EmailArchive__b> emailArchiveList= ;
Integer newIndex;
system.debug('index' + index);
for(emailArchive__b emb:[select recordjson0__c,recordjson1__c,recordjson2__c,recordjson3__c,recordjson4__c,recordjson5__c,
recordjson6__c,recordjson7__c,recordjson8__c,recordjson9__c,recordjson10__c,recordjson11__c,DateTimeStampIndex__c,indexNumber__c from emailArchive__b where indexNumber__c>:index limit 1000]){
//system.debug(json.deserializeUntyped(emb.recordjson9__c));
system.debug('emb'+emb.indexNumber__c);
emailList.add(emb.recordjson0__c);
emailList.add(emb.recordjson1__c);
emailList.add(emb.recordjson2__c);
emailList.add(emb.recordjson3__c);
emailList.add(emb.recordjson4__c);
emailList.add(emb.recordjson5__c);
emailList.add(emb.recordjson6__c);
emailList.add(emb.recordjson7__c);
emailList.add(emb.recordjson8__c);
emailList.add(emb.recordjson9__c);
emailList.add(emb.recordjson10__c);
emailList.add(emb.recordjson11__c);
newIndex=emb.indexNumber__c.intValue();
}

Map<Integer,List<String>> emailMap= new Map<Integer,List<String>>();
system.debug(emailList.size());
if(emailList.size()>0){

emailMap.put(newIndex,emailList);
return emailMap;            
}      
else
return null;
}*/
     @AuraEnabled
    public static List<String> unarchiveEmailMessages(String caseNumber){
        List<String> emailList=new  List<String>();
        //List<EmailArchive__b> emailArchiveList= ;
        Case cs=[select id,Email_archive_indexes__c,casenumber from case where casenumber=:casenumber];
        List<Decimal> emailindex=new  List<Decimal>();
        for(String str:cs.Email_Archive_Indexes__c.split(';'))
            emailindex.add(Decimal.valueOf(str));
        List<EmailArchive__b> archList=new List<EmailArchive__b>();
        if(Test.isRunningTest()){
            archList.add(new EmailArchive__b(indexNumber__c=1,recordjson0__c='{}'));
        }
        else
            archList=[select recordjson0__c,recordjson1__c,recordjson2__c,recordjson3__c,recordjson4__c,recordjson5__c,recordjson6__c,recordjson7__c,recordjson8__c,recordjson9__c,recordjson10__c,recordjson11__c,DateTimeStampIndex__c,indexNumber__c from emailArchive__b where indexNumber__c IN :emailindex];
        
        for(emailArchive__b emb:archList){
            //system.debug(json.deserializeUntyped(emb.recordjson9__c));
            system.debug('emb'+emb.indexNumber__c);
            emailList.add(emb.recordjson0__c);
            emailList.add(emb.recordjson1__c);
            emailList.add(emb.recordjson2__c);
            emailList.add(emb.recordjson3__c);
            emailList.add(emb.recordjson4__c);
            emailList.add(emb.recordjson5__c);
            emailList.add(emb.recordjson6__c);
            emailList.add(emb.recordjson7__c);
            emailList.add(emb.recordjson8__c);
            emailList.add(emb.recordjson9__c);
            emailList.add(emb.recordjson10__c);
            emailList.add(emb.recordjson11__c);
        }
        
        system.debug(emailList.size());
        if(emailList.size()>0){
            
            return emailList;            
        }      
        else
            return null; 
    }
   
    @AuraEnabled
    public static void ArchiveEmailMessages(){
        database.executeBatch(new parentCaseIdBatch(),200);
    }
    @AuraEnabled
    public static Boolean getBatchStatus(){
        List<Archival_date__c> settingList= [select id,From_Date__c,Object_Name__c,Status__c,To_date__c from Archival_date__c where Name=:userinfo.getuserid() and (status__c='Running')];
        return settingList.isEmpty();
    }
}