/*****************************************
* Created Date: 5 April 2021
* Created By : Standav (Ravi)
* Description : To flag proposal on quote contract discount create/edit/delete
* Test Class: 
*****************************************/

public with sharing class QuoteContractDiscHelper{

public static void updatequotecheck(List<CPQ_QuoteContractualDiscount__c> quotecontdiscNew){

List<Apttus_Proposal__Proposal__c> propList = new List<Apttus_Proposal__Proposal__c>();
set<Id> propSet = new set<Id>();

for(CPQ_QuoteContractualDiscount__c qc:quotecontdiscNew){
propSet.add(qc.CPQ_Proposal__c);
}

for(Apttus_Proposal__Proposal__c pr:[select id,CPQ_Contractual_Discounts_Updated__c from Apttus_Proposal__Proposal__c where id IN: propSet AND CPQ_Contractual_Discounts_Updated__c = false
AND CPQ_CQ_Check__c = true]){
pr.CPQ_Contractual_Discounts_Updated__c = true;
propList.add(pr);
}

if(!propList.isEmpty()){
update propList;
}

}

public static void updatequotecheckonUpdate(List<CPQ_QuoteContractualDiscount__c> quotecontdiscNew,
Map<Id,CPQ_QuoteContractualDiscount__c> oldTriggerMap){

List<Apttus_Proposal__Proposal__c> propList = new List<Apttus_Proposal__Proposal__c>();
set<Id> propSet = new set<Id>();

for(CPQ_QuoteContractualDiscount__c qc:quotecontdiscNew){
if((oldTriggerMap.get(qc.Id).CPQ_QLD_ICD_ID__c != qc.CPQ_QLD_ICD_ID__c) || (oldTriggerMap.get(qc.Id).CPQ_Sequence__c != qc.CPQ_Sequence__c)){
propSet.add(qc.CPQ_Proposal__c);
}
}

for(Apttus_Proposal__Proposal__c pr:[select id,CPQ_Contractual_Discounts_Updated__c from Apttus_Proposal__Proposal__c where id IN: propSet AND CPQ_Contractual_Discounts_Updated__c = false
AND CPQ_CQ_Check__c = true]){
pr.CPQ_Contractual_Discounts_Updated__c = true;
propList.add(pr);
}

if(!propList.isEmpty()){
update propList;
}

}

}