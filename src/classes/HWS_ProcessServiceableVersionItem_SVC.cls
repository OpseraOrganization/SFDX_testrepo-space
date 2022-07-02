public class HWS_ProcessServiceableVersionItem_SVC {

	public static List<HWS_VersionItem__c> updateTarget(List<sObject> psrcrecs,
				 List<NokiaCPQ_PMDI_Parameter__c> pmapping)
	{	  
	  HWS_VersionItem__c onewrec;
	  List<HWS_VersionItem__c> productList = new List<HWS_VersionItem__c>();
	  for(sObject srcrec : psrcrecs)
		{			
			onewrec = new HWS_VersionItem__c();
			for(NokiaCPQ_PMDI_Parameter__c para : pmapping)
			{
				onewrec.put(para.NokiaCPQ_ParaTo__c, srcrec.get(para.NokiaCPQ_ParaFrom__c));
			}
				onewrec.put('HWS_NSNCode__c',(String)onewrec.get('HWS_NSNCode__c'));
				onewrec.put('Created_by_PMDI__c',true);
				productList.add(onewrec);
								 
		}
		return productList;				
	} 
}