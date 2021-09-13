@isTest
private class FieldConversion_Batch_TEST
{
	private static User runUser;
	private static Account acc;
	private static Opportunity opp;
	private static Offer__c off;

	@testSetup static void dataSetup()
	{
		runUser = TestDataFactory.userCreation(1,'System Administrator')[0];
		runUser.firstName = 'Bruno';
		runUser.lastName = 'Palma Test';
		insert runUser;
		acc = TestDataFactory.createAccount(1)[0];
		insert acc;
		opp = TestDataFactory.OpportunityCreation(1,acc)[0];
		insert opp;
		off = TestDataFactory.OfferCreation(1,opp)[0];
		off.Offer_Description__c = '<p><b>Bruno Palma &amp;  &quot;Company&quot; is here</b></p>';
		insert off;
		System.debug('[BP] : finish dataSetup...');
	}//END dataSetup method

	@isTest static void runScriptToUpdateOfferDescriptionInOffer()
	{
		runUser = [SELECT id,name,profile.name
					FROM User
					WHERE firstName='Bruno'
					AND lastName = 'Palma Test'];
		System.debug('[BP] : runUser --> '+runUser);
		System.runAs(runUser)
		{
			FieldConversion_Batch runScript = new FieldConversion_Batch('Rich Text','Long Text');
			Database.executeBatch(runScript,200);
		}
	}
}////END FieldConversion_Batch_TEST CLASS