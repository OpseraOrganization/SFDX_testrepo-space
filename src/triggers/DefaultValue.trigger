trigger DefaultValue on Service_Request__c (before insert) {

for(Service_Request__c sr:Trigger.new){
if(sr.recordtypeid ==label.Srrequestfeedbackrecord){
if(sr.Near_Term_Alternate_Fix__c==null){
sr.Near_Term_Alternate_Fix__c='Need Evaluation';
}
}
else{}

}
}