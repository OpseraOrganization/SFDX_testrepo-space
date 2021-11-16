public class CH_UpdateServiceContractSharingAsync implements Queueable {
	
	Map<Id,Account> oOldAccounts = new Map<Id, Account>();
	Map<Id,Account> oNewAccounts = new Map<Id, Account>();
	
	public CH_UpdateServiceContractSharingAsync(Map<Id,Account> oOldAccounts, Map<Id,Account> oNewAccounts) {
		this.oOldAccounts = oOldAccounts;
		this.oNewAccounts = oNewAccounts;
	}
	
	public void execute(QueueableContext context) {
		CH_UpdateServiceContractSharing.execute(oOldAccounts, oNewAccounts);
	}
}