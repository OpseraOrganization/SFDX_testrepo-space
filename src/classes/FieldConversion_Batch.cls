global with sharing class FieldConversion_Batch implements Database.Batchable<sObject>
{
	String oldType ='';
	String newType ='';
	List<Database.SaveResult> resultsFromUpdate =  new List<Database.SaveResult>();

	public FieldConversion_Batch(String oldType,String newType)
	{
		this.oldType = oldType;
		this.newType = newType;
	}

	/****************************************
	* Name : start
	* Author : Bruno Palma
	* Description : this method will contain the SOQL query for the batch
	*****************************************/
	global Database.QueryLocator start(Database.BatchableContext BC)
	{
		return Database.getQueryLocator([SELECT Id,name,offer_description__c FROM Offer__c]);
	}//END START METHOD

	/****************************************
	* Name : execute
	* Author : Bruno Palma
	* Description : Execution of the batch
	*****************************************/
	global void execute(Database.BatchableContext BC, List<Offer__c> offersList)
	{
		if(oldType.equals('Rich Text') && newType.equals('Long Text'))
			updateOfferDescriptionOnOffer(offersList);
	}//END EXECUTE METHOD

	global void finish(Database.BatchableContext BC)
	{
		OrgWideEmailAddress owa = [select id, DisplayName, Address from OrgWideEmailAddress limit 1];

		String htmlBody = '';

		for(Database.saveResult sr : resultsFromUpdate)
		{
			if(!sr.isSuccess())
				for(Database.Error err : sr.getErrors())
				{
					htmlBody+=err.getStatusCode() + ': ' + err.getMessage();
				}
		}

		Messaging.Singleemailmessage email = new Messaging.Singleemailmessage();
		email.setOrgWideEmailAddressId(owa.id);
		email.setToAddresses(new List<String>{'bruno.palma@nokia.com'});
		email.setSaveAsActivity(false);
		email.setHtmlBody(htmlBody);

		Messaging.sendEmail(new Messaging.SingleEmailmessage[] {email});
		System.debug('FieldConversion_Batch Finished...');
	}

	private void updateOfferDescriptionOnOffer(List<Offer__c> offersList)
	{
		if(!this.oldType.equals('Rich Text') && !this.newType.equals('Long Text'))
			return;

		List <Offer__c> offersToBeUpdated = new List <Offer__c>();

		for(Offer__c currentOffer : offersList)
		{
			if(String.isNotEmpty(currentOffer.Offer_Description__c))
			{
				/*
				currentOffer.Offer_Description__c = (currentOffer.Offer_Description__c).replaceAll('<p>','');
				currentOffer.Offer_Description__c = (currentOffer.Offer_Description__c).replaceAll('</p>','');
				currentOffer.Offer_Description__c = (currentOffer.Offer_Description__c).replaceAll('<h1>','');
				currentOffer.Offer_Description__c = (currentOffer.Offer_Description__c).replaceAll('</h1>','');
				currentOffer.Offer_Description__c = (currentOffer.Offer_Description__c).replaceAll('<b>','');
				currentOffer.Offer_Description__c = (currentOffer.Offer_Description__c).replaceAll('</b>','');
				currentOffer.Offer_Description__c = (currentOffer.Offer_Description__c).replaceAll('<i>','');
				currentOffer.Offer_Description__c = (currentOffer.Offer_Description__c).replaceAll('</i>','');
				currentOffer.Offer_Description__c = (currentOffer.Offer_Description__c).replaceAll('<u>','');
				currentOffer.Offer_Description__c = (currentOffer.Offer_Description__c).replaceAll('</u>','');
				currentOffer.Offer_Description__c = (currentOffer.Offer_Description__c).replaceAll('<ul>','');
				currentOffer.Offer_Description__c = (currentOffer.Offer_Description__c).replaceAll('</ul>','');
				currentOffer.Offer_Description__c = (currentOffer.Offer_Description__c).replaceAll('<ol>','');
				currentOffer.Offer_Description__c = (currentOffer.Offer_Description__c).replaceAll('</ol>','');
				currentOffer.Offer_Description__c = (currentOffer.Offer_Description__c).replaceAll('<colgroup>','');
				currentOffer.Offer_Description__c = (currentOffer.Offer_Description__c).replaceAll('</colgroup>','');
				currentOffer.Offer_Description__c = (currentOffer.Offer_Description__c).replaceAll('<li>','');
				currentOffer.Offer_Description__c = (currentOffer.Offer_Description__c).replaceAll('</li>','');
				currentOffer.Offer_Description__c = (currentOffer.Offer_Description__c).replaceAll('<br>','');
				currentOffer.Offer_Description__c = (currentOffer.Offer_Description__c).replaceAll('<tbody>','');
				currentOffer.Offer_Description__c = (currentOffer.Offer_Description__c).replaceAll('</tbody>','');
				currentOffer.Offer_Description__c = (currentOffer.Offer_Description__c).replaceAll('</col>','');
				currentOffer.Offer_Description__c = (currentOffer.Offer_Description__c).replaceAll('</span>','');
				currentOffer.Offer_Description__c = (currentOffer.Offer_Description__c).replaceAll('</td>','');
				currentOffer.Offer_Description__c = (currentOffer.Offer_Description__c).replaceAll('</tr>','');
				currentOffer.Offer_Description__c = (currentOffer.Offer_Description__c).replaceAll('</img>','');
				*/
				System.debug('currentOffer.Offer_Description__c BEFORE --> '+currentOffer.Offer_Description__c);
				currentOffer.Offer_Description__c = (currentOffer.Offer_Description__c).replaceAll('<[^>]+>','');
				System.debug('currentOffer.Offer_Description__c AFTER --> '+currentOffer.Offer_Description__c);
				currentOffer.Offer_Description__c = (currentOffer.Offer_Description__c).replaceAll('&#39;','\'');
				currentOffer.Offer_Description__c = (currentOffer.Offer_Description__c).replaceAll('&amp;','&');
				currentOffer.Offer_Description__c = (currentOffer.Offer_Description__c).replaceAll('&quot;','"');
				currentOffer.Offer_Description__c = (currentOffer.Offer_Description__c).replaceAll('&gt;','>');
				currentOffer.Offer_Description__c = (currentOffer.Offer_Description__c).replaceAll('&lt;','<');
				offersToBeUpdated.add(currentOffer);
			}//END ISEMPTY Offer_Description__c IF
		}//END OFFER FOR LOOP
		List<Database.SaveResult> resultsFromDatabase = Database.update(offersToBeUpdated, false);
		for(Database.SaveResult sr : resultsFromDatabase)
			resultsFromUpdate.add(sr);
	}
}//end FieldConversion_Batch Class