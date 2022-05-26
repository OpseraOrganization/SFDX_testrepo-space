/*******************************
	*Class name: quoteShareonAccountOwnerChange_DS
	*Description: This Class will share DS quote with New account owner and remove old user sharing 
	*Parameter: Account Values
	*******************************/ 
public class DS_quoteShareonAccountOwnerChange implements Queueable {
	private List<Account> accountListOld;
	private List<Account> accountListNew;
	
	public DS_quoteShareonAccountOwnerChange(List<Account> accountListOld , List<Account> accountListNew) {
		this.accountListOld  = accountListOld;
		this.accountListNew = accountListNew;
	}
	
	public void execute(QueueableContext context) {
		try{
			system.debug('accountListOld : '+ accountListOld);
			system.debug('accountListNew : '+ accountListNew);
			map<id, id> oldAccOwner = new map<id, id>();
			map<id, id> newAccOwner = new map<id, id>();
			list<Apttus_Proposal__Proposal__Share> quoteShareList = new list<Apttus_Proposal__Proposal__Share>();
			list<Apttus_Proposal__Proposal__Share> toBeDeletedQuoteShare = new list<Apttus_Proposal__Proposal__Share>();
			map<id,id> quoteToAccount = new map<id, id>();
			for(account acc : accountListOld){
				oldAccOwner.put(acc.id, acc.ownerid);
			}
			for(account acc : accountListNew){
				newAccOwner.put(acc.id, acc.ownerid);
			}
			system.debug('newAccOwner : '+ newAccOwner);
			system.debug('oldAccOwner : '+ oldAccOwner);
						
			list<Apttus_Proposal__Proposal__c> allQuotes = [select id, ownerid, Apttus_Proposal__Account__c, Apttus_Proposal__Account__r.ownerid from Apttus_Proposal__Proposal__c where Apttus_Proposal__Account__c in: accountListNew];
			
			system.debug('accountListOld : '+ accountListOld);
			for(Apttus_Proposal__Proposal__c quote : allQuotes){
				quoteToAccount.put(quote.id, quote.Apttus_Proposal__Account__c);
				
			}
			system.debug('quoteToAccount : '+ quoteToAccount);
			//create share records for new owner
			for(Apttus_Proposal__Proposal__c quote : allQuotes){
				if(quote.ownerid != newAccOwner.get(quote.Apttus_Proposal__Account__c)){
					Apttus_Proposal__Proposal__Share QuoteShare= new Apttus_Proposal__Proposal__Share();
					QuoteShare.AccessLevel = 'Edit';
					QuoteShare.ParentID = quote.id;
					QuoteShare.RowCause = 'Manual';
					QuoteShare.UserOrGroupId = newAccOwner.get(quote.Apttus_Proposal__Account__c);
					quoteShareList.add(QuoteShare);
				}
			}
			system.debug('quoteShareList : '+ quoteShareList);
			
			//delete sharing for old owner
			list<Apttus_Proposal__Proposal__Share> allQuotesShare = [select id, ParentID, UserOrGroupId, RowCause from Apttus_Proposal__Proposal__Share where ParentID in: allQuotes AND RowCause = 'Manual'];
			
			system.debug('accountListOld : '+ accountListOld);
			for(Apttus_Proposal__Proposal__Share quoteShare : allQuotesShare){
				if(quoteShare.UserOrGroupId == oldAccOwner.get(quoteToAccount.get(quoteShare.ParentID))){
					toBeDeletedQuoteShare.add(quoteShare);
				}
				
			}
			system.debug('toBeDeletedQuoteShare : '+ toBeDeletedQuoteShare);
			if(!quoteShareList.isEmpty()){
				database.insert(quoteShareList,false);
			}
			if(!toBeDeletedQuoteShare.isEmpty()){
				database.delete(toBeDeletedQuoteShare,false);
			}
		
		}
		catch(Exception e) {
			ExceptionHandler.addException(e, 'shareDSQuotewithNewAccOwner', 'shareDSQuotewithNewAccOwner');}  
	}
	
}