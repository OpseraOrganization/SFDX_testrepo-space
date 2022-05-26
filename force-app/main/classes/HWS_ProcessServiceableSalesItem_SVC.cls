/*Class to process HWS Service Sales Item */
public class HWS_ProcessServiceableSalesItem_SVC{

 public static List<Product2> updateTarget(List<sObject> psrcrecs, Map<String,String> productMap, 
			 String ptobject, List<NokiaCPQ_PMDI_Parameter__c> pmapping)
	{		
	   
	  Product2 o_newrec;
	  List<Product2> productList = new List<Product2>();
	  for(sObject srcrec : psrcrecs)
		{			
			o_newrec = new Product2();
			for(NokiaCPQ_PMDI_Parameter__c para : pmapping)
			{
				o_newrec.put(para.NokiaCPQ_ParaTo__c, srcrec.get(para.NokiaCPQ_ParaFrom__c));
				System.debug('product111111'+srcrec.get(para.NokiaCPQ_ParaFrom__c));
			}   
 
			if(productMap.containsKey((String)o_newrec.get('HWS_NSNPartCode__c'))){
				 
					System.debug('');
					Product2 product;
					product = o_newrec.clone(true);
					product.Id = productMap.get((String)o_newrec.get('HWS_NSNPartCode__c'));
					product.put('HWS_NSNPartCode__c',(String)o_newrec.get('HWS_NSNPartCode__c'));
					System.debug('product22222'+product.HWS_NSNPartCode__c);
					productList.add(product); 
			}	
	   }  
		   return productList;  
	}
  
}