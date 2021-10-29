trigger updatecaseField on Feedback__c (After insert,after update) {

//AutofillTheAccountFields.demo(trigger.new);

set<ID> Feedid =new set<ID>();
list<Case> caselist=new List<Case>();
//Map<Id,Case> casemap=new Map<ID,Case>();
List<Case> updatedcaselist=new List<case>();

List<Case_Extension__c> updatedcaseExtnlist=new List<Case_Extension__c>();
for(Feedback__c co:Trigger.new){
if(co.Case__c!=Null)
{
 
 string recordtypename = Schema.SObjectType.Feedback__c.getRecordTypeInfosByName().get('Article Feedback').getRecordTypeId();
 string quoteSurveryRecord= Schema.SObjectType.Feedback__c.getRecordTypeInfosByName().get('Quote Survey').getRecordTypeId();
 string orderstatusrecord = Schema.SObjectType.Feedback__c.getRecordTypeInfosByName().get('Order Status Survey').getRecordTypeId();
 string techpubrecordtype= Schema.SObjectType.Feedback__c.getRecordTypeInfosByName().get('Technical Publication Survey').getRecordTypeId();
 
if(co.RecordTypeId != recordtypename  && co.RecordTypeId != quoteSurveryRecord && co.RecordTypeId != orderstatusrecord && co.RecordTypeId != techpubrecordtype)
Feedid.add(co.Case__c);
}
}
if(Feedid.size()>0)
{
    system.debug('Test SOFI1');
caselist = [SELECT id,P2C_Survey_Comments__c,CES_Score__c,Overall_Sat__c,No_of_Contacts_to_Resolve__c,  NPS_Recommend__c,(SELECT ID,CES_Score__c,Timeliness_of_response__c,Quality_and_Accuracy__c,Overall_satisfaction__c,Courtesy_and_Professionalism__c,No_of_Contacts_to_Resolve__c,NPS_Recommend__c,Comments__c  FROM Feedback__r),(select id, Timeliness_of_response__c,Quality_accuracy_of_response__c,Agent_courtesy_and_professionalism__c from Case_Extensions__r) FROM Case WHERE ID IN :Feedid];
    for (Case c : caselist){
     System.debug('Is Entering Case loop SOFFF');
        for (Feedback__c fob:trigger.new ){
         system.debug('Is Entering CaseFeedback loop SOFFF');
            c.NPS_Recommend__c = fob.NPS_Recommend__c;
            c.CES_Score__c = fob.CES_Score__c;
            c.Overall_Sat__c = fob.Overall_satisfaction__c;
            c.No_of_Contacts_to_Resolve__c = fob.No_of_Contacts_to_Resolve__c;
            c.P2C_Survey_Comments__c =  fob.Comments__c;
            DateTime dt =fob.CreatedDate;
            Date myDate = date.newinstance(dT.year(), dT.month(), dT.day());
            c.Response_Date__c =myDate;
            system.debug('@@@@date@@@@@'+dt);
             if(c.Case_Extensions__r!=null && c.Case_Extensions__r.size()>0)
             { 
                 System.debug('Is Entering CasExt loop SOFFF');
                 Case_Extension__c CasExt = new Case_Extension__c();     
                 CasExt = c.Case_Extensions__r; 
                 CasExt.Timeliness_of_response__c=fob.Timeliness_of_response__c;
                 CasExt.Quality_accuracy_of_response__c = fob.Quality_and_Accuracy__c;
                 CasExt.Agent_courtesy_and_professionalism__c = fob.Courtesy_and_Professionalism__c;
                 updatedcaseExtnlist.add(CasExt);
             }
            updatedcaselist.add(c);
          }  
       }
    
update updatedcaselist;
update updatedcaseExtnlist;
}
}