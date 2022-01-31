public class CQ_CustomerContactCreationController {
	
	/*******************************
Method Name: getAccount
Description:  
Parameters: Quote/Proposal record id
*******************************/
	@AuraEnabled
	public static String getAccount(String quoId){
		String accId='';
		try{
			//System.debug('Inside getAccount#################');
			Apttus_Proposal__Proposal__c quo = [Select Id,Apttus_Proposal__Account__c 
												FROM Apttus_Proposal__Proposal__c
												WHERE Id =: quoId];
			accId=quo.Apttus_Proposal__Account__c;
			//System.debug('accId:::::::>'+accId);
		   Integer PrimaryCount=[Select Count() FROM CQ_Customer_Contact__c WHERE CQ_CQ_Name__c =: quoId AND CQ_Is_Primary__c=true];
			if(PrimaryCount>0)
				accId +=';true';
			if(PrimaryCount==0) 
				accId +=';false';
		}
		catch(Exception ex){
			ExceptionHandler.addException(ex,GlobalConstants.CQ_CLONEQUOTECONTROLLER , GlobalConstants.CQ_CLONECUSTOMERCONTACT);
		}
		return accId;
	}
	
	/*******************************
Method Name: saveCustomerContact
Description:  
Parameters: 
*******************************/
	@AuraEnabled
	public static void saveCustomerContact(string contList, string quoteId, string AccId){
		try{
			List<quoteContactWrapper> wrapperList = (List<quoteContactWrapper>) JSON.deserialize(contList, List<quoteContactWrapper>.class);
			List<CQ_Customer_Contact__c> newConList = new List<CQ_Customer_Contact__c>();
			String primcon;
			Boolean clearflag = true;
			//System.debug('wrapperList ::> '+wrapperList.size());
			for(quoteContactWrapper obj : wrapperList ){
				if(obj.Cus_Contacts.Id<>NULL){
					CQ_Customer_Contact__c cc = new CQ_Customer_Contact__c();
					cc.CQ_Contact__c = obj.Cus_Contacts.Id;
					cc.CQ_isCloned__c = TRUE;
					cc.CQ_CQ_Name__c = quoteId;
					cc.CQ_Account__c = AccId;
					if(obj.isPrimary<>NULL && obj.isPrimary || wrapperList.size() == Globalconstants.VALUE_ONE)
					{
						cc.CQ_Is_Primary__c = TRUE;
						primcon = obj.Cus_Contacts.Id;
					}
					else
						cc.CQ_Is_Primary__c = FALSE;
					newConList.add(cc);
					//System.debug('newConList::> '+newConList);
				}
			}
			List<Database.SaveResult> savedResults = Database.insert(newConList, false);
			for(Database.SaveResult sr : savedResults){
				if (!sr.isSuccess()) {
					clearflag = false;
					for (Database.Error err: sr.getErrors()) {
						String msg = err.getMessage();
						System.debug('Error while inserting quote team::> '+err.getStatusCode()+'::> '+msg);
						//System.debug('Fields that affected this error : ' + err.getFields());
					}
				}
			}
			if(clearflag)
				clearPrimaryFlag(primcon,quoteId);
		}
		catch(Exception ex){
			ExceptionHandler.addException(ex,GlobalConstants.CQ_CLONEQUOTECONTROLLER , GlobalConstants.CQ_CLONECUSTOMERCONTACT);
		}
	}
	/*******************************
Method Name: clearPrimaryFlag
Description:  
Parameters: 
*******************************/
	public static void clearPrimaryFlag(String conId, String quoId){
		List<CQ_Customer_Contact__c> updateConList = new List<CQ_Customer_Contact__c>();
		try{
			for(CQ_Customer_Contact__c cont : [Select Id,CQ_Contact__c,CQ_Is_Primary__c
											   FROM CQ_Customer_Contact__c 
											   WHERE CQ_CQ_Name__c =: quoId AND CQ_Contact__c != :conId])
			{
				cont.CQ_isCloned__c = TRUE;
				cont.CQ_Is_Primary__c = FALSE;
				updateConList.add(cont);
			}
			//System.debug('Inside flag update#############');
			if(!updateConList.isEmpty())
				Database.update(updateConList,false);
		}
		catch(Exception ex){
			ExceptionHandler.addException(ex,GlobalConstants.CQ_CLONEQUOTECONTROLLER , GlobalConstants.CQ_CLONECUSTOMERCONTACT);
		}
	}
	/*******************************
Method Name: quoteContactWrapper
Description:  
Parameters: 
*******************************/
	public class quoteContactWrapper{
		@AuraEnabled public Contact Cus_Contacts {get;set;}
		@AuraEnabled public String consearch {get;set;}
		@AuraEnabled public Boolean isPrimary {get;set;}
	}
}