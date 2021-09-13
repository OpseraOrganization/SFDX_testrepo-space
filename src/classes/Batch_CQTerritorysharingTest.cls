@istest
public class Batch_CQTerritorysharingTest {
	
	
	private static testmethod void preparedata(){
		
		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		insert userCreation;
		System.RunAs(userCreation){
		 
			Account[] acc = TestDataFactory.createAccount(1);
			database.insert(acc);
			
			Id terrid1 = TestDataFactory.getL7TerritoryId();
			Id terrid2 = TestDataFactory.getAnotherL7TerritoryId();
			system.debug('terrid1: '+terrid1);
			system.debug('terrid2: '+terrid2);
			system.debug('acct territory: '+ [select id, objectId,territory2Id from ObjectTerritory2Association where objectId = :acc[0].Id]);
			ObjectTerritory2Association objterr = TestDataFactory.assigningAccountToTerritory(1,acc[0],terrid1)[0];
			database.insert(objterr);
			system.debug('acct territory: '+ [select id, objectId,territory2Id from ObjectTerritory2Association where objectId = :acc[0].Id]);
			database.insert(TestDataFactory.assigningUserToTerritory(1,userCreation,terrid1));
			system.debug('grps: '+  [SELECT Id,RelatedId,Type FROM Group WHERE Type = 'territory']);
			Opportunity opp1 = TestDataFactory.OpportunityCreation(1,acc[0])[0];
			opp1.StageName='Create Offer (Bid)';
			opp1.Phase_Status__c = 'Offer in Progress';
			database.insert(opp1);
			
					  
			Apttus_Proposal__Proposal__c cq1 = TestDataFactory.createCQ(1,acc[0],opp1)[0];
			cq1.NokiaCPQ_Proposal_Id__c= 'cq1234';
			
			
			Apttus_Proposal__Proposal__c cq2 = TestDataFactory.createCQ(1,acc[0],opp1)[0];
			cq2.NokiaCPQ_Proposal_Id__c= 'cq1235';
			
			
			Apttus_Proposal__Proposal__c[] cq = new Apttus_Proposal__Proposal__c[]{};
			cq.add(cq1);
			cq.add(cq2);
			database.insert(cq);
			
			system.debug('share before job run: '+ [SELECT ParentId,RowCause,UserOrGroupId,Id,Parent.quote_type__c,UserOrGroup.Type FROM Apttus_Proposal__Proposal__Share]);
			system.debug('usergroup type:'+ [SELECT ParentId,RowCause,UserOrGroupId,Id,Parent.quote_type__c,UserOrGroup.Type FROM Apttus_Proposal__Proposal__Share limit 1].UserOrGroup.Type);
			ObjectTerritory2Association objterr2 = TestDataFactory.assigningAccountToTerritory(1,acc[0],terrid2)[0];
			database.insert(objterr2);
			
			Test.startTest();
			
			Batch_CQTerritorysharing batch = new Batch_CQTerritorysharing();
			database.executeBatch(batch,100);
			
			test.stopTest();
			
			system.debug('share after job run: '+ [SELECT ParentId,RowCause,UserOrGroupId,Id FROM Apttus_Proposal__Proposal__Share where Parent.quote_type__c = 'CQ' and UserOrGroup.Type = 'Queue']);
		
}
		
	}
	
	public static testmethod void testscheduling(){
		
		Test.starttest();
		Batch_CQTerritorysharing batch = new Batch_CQTerritorysharing();

		String sch = '20 30 8 10 2 ?';
		String jobID = system.schedule('Merge Job', sch, batch);
		
		Test.stopTest();
		
	}
	
	

}