/**
 * @description	   :
 * @author			: Yashdeep Prajapati
 * @group			 :
 * @last modified on  : 01-25-2022
 * @last modified by  : Yashdeep Prajapati
 **/
public with sharing class NokiaCPQ_EaControllerExtension {
private final CPQ_ExportAttach__c ea;
public NokiaCPQ_EaControllerExtension(ApexPages.StandardController stdController) {
	this.ea = (CPQ_ExportAttach__c)stdController.getRecord();
}
public String getAccount() {
	return ea.CPQ_Account__c;
}
}