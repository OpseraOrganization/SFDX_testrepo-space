/*****************************************
* Created Date: 5 April 2021
* Created By : Standav (Ravi)
* Description : To flag proposal on quote contract discount create/edit/delete
* Test Class: 
*****************************************/
trigger QuoteContractDiscTrigger on CPQ_QuoteContractualDiscount__c(after insert,after update,after delete){

if(trigger.isAfter && trigger.isInsert){
QuoteContractDiscHelper.updatequotecheck(trigger.new);
}

if(trigger.isAfter && trigger.isUpdate){
QuoteContractDiscHelper.updatequotecheckonUpdate(trigger.new,Trigger.oldMap);
}

if(trigger.isAfter && trigger.isDelete){
QuoteContractDiscHelper.updatequotecheck(trigger.old);
}

}