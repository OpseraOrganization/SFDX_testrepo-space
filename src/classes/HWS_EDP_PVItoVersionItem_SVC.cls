/*Class to process Product Version item Items */
public class HWS_EDP_PVItoVersionItem_SVC {

 public static List<HWS_VersionItem__c> updateTarget(List<sObject> paraSrcRecs, Map<String, List<String>> productMap, 
			  List<NokiaCPQ_PMDI_Parameter__c> paraMapping)
	{		
	   
	  HWS_VersionItem__c versionRec;
	  List<HWS_VersionItem__c> productList = new List<HWS_VersionItem__c>();
	  for(sObject srcrec : paraSrcRecs)
		{			
			versionRec = new HWS_VersionItem__c();
			for(NokiaCPQ_PMDI_Parameter__c para : paraMapping)
		{
			versionRec.put(para.NokiaCPQ_ParaTo__c, srcrec.get(para.NokiaCPQ_ParaFrom__c));
			}   

			if(versionRec.get('HWS_NSNCode__c') != null && productMap.containsKey((String)versionRec.get('HWS_NSNCode__c')))
			{
				 
				String portfolio;
				List<String> recs = productMap.get((String)versionRec.get('HWS_NSNCode__c'));
				if(recs!= null && !recs.isEmpty())
				{
					HWS_VersionItem__c product;
					for(integer i=0; i<recs.size(); i++)
					{
						product = versionRec.clone(true);
						product.Id = recs[i];
						product.put('HWS_NSNCode__c',(String)versionRec.get('HWS_NSNCode__c'));
						if(!productList.contains(product)){
						productList.add(product);
						}
					}	
				}									  
			}
								 
		}
		return productList;				
	}		
 
}