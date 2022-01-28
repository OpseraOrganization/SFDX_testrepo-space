@isTest
public class UploadPOPClaimTest {
	@isTest
	public static void uploadPOPFile(){	 
		List<user> runAsUSer = new List<user>();
		runAsUSer = TestDataFactory.userCreation(1,'System Administrator');
		runAsUSer[0].UserRoleId  = system.Label.Global_Role_ID;
		runAsUSer[0].NSA_Compliant__c = true;
		runAsUSer[0].Nokia_ID__c= '6777777666';
		database.insert(runAsUSer);
		system.runAs(runAsUSer[0]){
			Account acc = new Account();
			acc = TestDataFactory.createAccount(1)[0];
			acc.Enrolled_in_Co_Op__c = true;
			insert acc;
			
			Fund__c fd = new Fund__c(Name = 'abcd', /*Partner_Name__c = acc.id,*/ PRM_Main_Fund__c=true);
			insert fd;
			
			Co_Op_Activity__c activity = new Co_Op_Activity__c(Partner_Account__c = acc.id, Activity_Type__c = 'Advertising', Start_Date__c = system.today()+15, End_Date__c = system.today()+100, Fund_Id__c = fd.id, Activity_Status__c = 'New', Cost_of_Activity__c = 100, Reimbursement_Amount_Requested__c = 90);
			insert activity;
			Co_Op_Activity__c actTest = [Select Id from Co_Op_Activity__c where Id =: activity.Id];
			
			
			Claim__c claim = new Claim__c();
			claim.Activity_Type__c = 'Advertising';
			claim.Activity_Number__c = actTest.Id;
			
			
			database.insert(claim);
			claim.Attached_POP__c = 'Sample of magazine/newspaper incl. ad and date';		   
			database.update(claim);		 
			Claim__c claimTest = [Select Id,Activity_Type__c,Attached_POP__c from Claim__c where Id =: claim.Id];		   
			List<ContentVersion> contentVersionList = TestDataFactory.createContentVersion(2);
			
			insert contentVersionList;
			ContentVersion contentVer = [Select ContentDocumentId,Proof_of_Performance__c from ContentVersion where Id =: contentVersionList[0].Id ];		   
			String claimId = String.valueOf(claimTest.Id);
			String activityId = String.valueOf(claimTest.Activity_Type__c);
			String docId = String.valueOf(contentVer.ContentDocumentId);
			claim.Attached_POP__c = 'Itemized production and publisher invoices';		   
			database.update(claim);
			

			Test.startTest();
			UploadPOPClaim.getClaimData(claimId);
			UploadPOPClaim.getPOPValues(activityId);			
			UploadPOPClaim.updateContentVersion(docId, activityId, 'Test String',claimId);		  
			//System.assertEquals(claim.Attached_POP__c,'Itemized 3rd party invoices');		
			uploadPOPClaim.getFileLists(claimId);
			ContentDocumentlink condoc = new ContentDocumentlink();
			condoc.linkedEntityId = claimId;
			condoc.ContentDocumentId = contentVer.ContentDocumentId;
			condoc.ShareType ='V';
			insert condoc;
			uploadPOPClaim.deleteFileRecord(docId,claimId);
			List<Claim__c> claimlist1 =[select id from claim__c where id=: claim.id];
		   // system.assertEquals(1,claimlist1.size());
			Test.stopTest();
		}
	}
}