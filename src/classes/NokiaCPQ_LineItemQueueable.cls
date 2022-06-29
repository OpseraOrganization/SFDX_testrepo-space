/**
 * @description	   :
 * @author			: Yashdeep Prajapati
 * @group			 :
 * @last modified on  : 09-19-2021
 * @last modified by  : Yashdeep Prajapati
 **/
public inherited sharing class NokiaCPQ_LineItemQueueable implements Queueable {
public List<Apttus_Config2__LineItem__c> lineItems;
public NokiaCPQ_LineItemQueueable(List<Apttus_Config2__LineItem__c> lineItems) {
	this.lineItems = lineItems;
}
public void execute(QueueableContext context) {
	Set<Id> configSet = new Set<Id>();
	for (Apttus_Config2__LineItem__c line : lineItems) {
		configSet.add(line.Apttus_Config2__ConfigurationId__c);
	}
	Nokia_CPQ_Utility.sitePhaseConfigCheck(configSet);
}

}