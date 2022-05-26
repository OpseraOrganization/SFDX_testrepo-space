public class ValidateCSPExportController{
	public Id recId {get;set;}
	Public String appName {get; set;}
	public List<String> warningMessageList {get;set;}
	private ApexPages.StandardController standardController;
	Public List <String> status = System.Label.ProductStage.split(',');
	
	public ValidateCSPExportController(ApexPages.StandardController standardController)
	{
		this.standardController = standardController;
		recId = standardController.getId();
		//System.debug('recId -->'+recId);
		appName = ApexPages.currentPage().getParameters().get('appName');
	}
	
	public PageReference validateProducts(){
		PageReference pgRef;
		//system.debug('appName-->' +appName);
		List<Apttus_Proposal__Proposal_Line_Item__c> nonOrderableProducts = New List<Apttus_Proposal__Proposal_Line_Item__c>();
		nonOrderableProducts = [Select id,Name,Apttus_QPConfig__LineType__c,Apttus_Proposal__Product__c,Apttus_Proposal__Product__r.NokiaCPQ_State__c,Apttus_Proposal__Product__r.ProductCode,Apttus_Proposal__Product__r.Name,Apttus_QPConfig__LineNumber__c,Apttus_QPConfig__OptionId__r.Name,Apttus_QPConfig__OptionId__r.NokiaCPQ_State__c,Apttus_QPConfig__OptionId__r.ProductCode,Apttus_QPConfig__ParentBundleNumber__c from Apttus_Proposal__Proposal_Line_Item__c where Apttus_Proposal__Proposal__c = :recId and (Apttus_Proposal__Product__r.NokiaCPQ_State__c IN :status OR Apttus_QPConfig__OptionId__r.NokiaCPQ_State__c IN :status)limit 50000];
		warningMessageList = New  List<String>(); 
		for(Apttus_Proposal__Proposal_Line_Item__c pli :nonOrderableProducts)
		{
		   if(pli.Apttus_QPConfig__LineType__c.equalsIgnoreCase('Product/Service') && pli.Apttus_QPConfig__ParentBundleNumber__c == null){
				warningMessageList.add('# '+pli.Apttus_QPConfig__LineNumber__c+ '. '+pli.Apttus_Proposal__Product__r.Name+' -- item '+pli.Apttus_Proposal__Product__r.ProductCode+' is in '+pli.Apttus_Proposal__Product__r.NokiaCPQ_State__c+ ' state');
			}
			else if(pli.Apttus_QPConfig__LineType__c.equalsIgnoreCase('Option') && status.Contains(pli.Apttus_QPConfig__OptionId__r.NokiaCPQ_State__c)){ 
				//System.debug('status-->'+status);
				warningMessageList.add('# '+pli.Apttus_QPConfig__LineNumber__c+ '. '+pli.Apttus_Proposal__Product__r.Name+' -- item '+pli.Apttus_QPConfig__OptionId__r.ProductCode+' is in '+pli.Apttus_QPConfig__OptionId__r.NokiaCPQ_State__c+ ' state');
			}
			
		}
		
		if(nonOrderableProducts.isEmpty()){
			pgRef= new PageReference('/apex/Apttus_XApps__EditInExcelLaunch?selectedRecordId='+recId+'&appName='+appName+'&mode=touchless&outputType=None');
			pgRef.setRedirect(true);
			return pgRef;
		}
		else
			return null;
	}
	
	public PageReference redirectToApp(){
		//System.debug('App Name'+ ApexPages.currentPage().getParameters().get('appName'));
		PageReference reRend = new PageReference('/apex/Apttus_XApps__EditInExcelLaunch?selectedRecordId='+recId+'&appName='+appName+'&mode=touchless&outputType=None');
		reRend.setRedirect(true);
		return reRend;
	}
	
	public PageReference cancel(){
		PageReference returntoQuote = standardController.cancel();
		return returntoQuote;
	}
	
}