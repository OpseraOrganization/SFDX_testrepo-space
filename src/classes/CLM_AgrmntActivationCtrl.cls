public without sharing class CLM_AgrmntActivationCtrl implements Queueable {
	Private String agrmntId;
	Private List<String> activateDocIds;
	Private List<String> remDocIds;
	
	public CLM_AgrmntActivationCtrl(String agrmntId,List<String> activateDocIds, List<String> remDocIds){
		this.agrmntId = agrmntId;
		this.activateDocIds = activateDocIds;
		this.remDocIds = remDocIds;
	}
	public void execute(QueueableContext context) {
		try{
			Apttus.AgreementWebService.activateAgreement(agrmntId, activateDocIds, remDocIds); 
		}catch(Exception e){
			system.debug('==>>5555>>'+e.getMessage()+'===='+e.getLineNumber());
		
		}
			 
	}
}