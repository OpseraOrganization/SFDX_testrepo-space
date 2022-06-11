/****************************************
* Class Name : HWS_ProcessversionItem_SVC
* Created Date: 1 July 2020
* Created By : Sai Lakshman Kanukollu 
* Last Modified by: Sai Lakshman Kanukollu
* Last Modified Date: 1 July 2020
* Description : This class is used to update Product from PMDI Mapping object
* Reference: NOKIASC-28644
* Test Class: HWS_PMDSoRImportSubAssemtoProduct_Test
*****************************************/
public class HWS_ProcessversionItem_SVC{
	
	public static List<Product2> updateTarget(List<HWS_Product_Version_Item__c> psrcrecs, Map<String,String> productMap, 
											  String ptobject, List<NokiaCPQ_PMDI_Parameter__c> pmapping)
	{		
		
		Product2 o_newrec;
		List<Product2> productList = new List<Product2>();
		for(HWS_Product_Version_Item__c srcrec : psrcrecs)
		{			
			o_newrec = new Product2();
			for(NokiaCPQ_PMDI_Parameter__c para : pmapping)
			{
				if(para.NokiaCPQ_ParaType__c.equalsIgnoreCase('MAPPING RULE')){
					o_newrec.put(para.NokiaCPQ_ParaTo__c, srcrec.get(para.NokiaCPQ_ParaFrom__c));
				}
				
				if(para.NokiaCPQ_ParaType__c.equalsIgnoreCase('DIRECT_VALUE')){
					o_newrec.put(para.NokiaCPQ_ParaTo__c, para.NokiaCPQ_ParaFrom__c);
				}
				
			}
			if(productMap.containsKey((String)o_newrec.get('HWS_NSNPartCode__c'))){
				
				Product2 product;
				product = o_newrec.clone(true);
				product.Id = productMap.get((String)o_newrec.get('HWS_NSNPartCode__c'));
				product.put('HWS_NSNPartCode__c',(String)o_newrec.get('HWS_NSNPartCode__c'));
				product.put('Created_by_PMDI__c',true);
				System.debug('product22222'+product.HWS_NSNPartCode__c);
				productList.add(product); 
			}
			else{
				o_newrec.put('Created_by_PMDI__c',true);
				productList.add(o_newrec);
			}
		}  
		return productList;  
	}
	
}