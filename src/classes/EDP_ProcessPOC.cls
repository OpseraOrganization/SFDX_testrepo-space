public class EDP_ProcessPOC
{	   
	public static List<Product2> updateTarget(List<sObject> p_srcrecs, Map<String, List<String>> productMap, String p_tobject, List<NokiaCPQ_PMDI_Parameter__c> p_mapping, Map<Object, String> paraValueMap)
	{		
	   
		// local declarations
		String s_updquery;
		Product2 o_newrec;
		//List<sObject> l_trgrecs = new List<sObject>();
		List<Product2> productList = new List<Product2>();
		
		for(sObject srcrec : p_srcrecs)
		{			
			System.debug('srcrec:'+srcrec);
			o_newrec = new Product2();
			for(NokiaCPQ_PMDI_Parameter__c para : p_mapping)
			{
				if(para.NokiaCPQ_ReqMap__c == true)
				{				   
					if(paraValueMap.containsKey(srcrec.get(para.NokiaCPQ_ParaFrom__c)))
					{
						// The source value from the rule fits with the content in the source record
						o_newrec.put(para.NokiaCPQ_ParaTo__c, paraValueMap.get(srcrec.get(para.NokiaCPQ_ParaFrom__c)));
					}
				}
				else
				{
					// we can store the value without transformation
					if(para.NokiaCPQ_ParaType__c.equalsIgnoreCase('MAPPING RULE'))
						o_newrec.put(para.NokiaCPQ_ParaTo__c, srcrec.get(para.NokiaCPQ_ParaFrom__c));
					else if(para.NokiaCPQ_ParaType__c.equalsIgnoreCase('DIRECT_VALUE'))
						o_newrec.put(para.NokiaCPQ_ParaTo__c, para.NokiaCPQ_ParaFrom__c);				   
				}  
				
			}   

			o_newrec.put('IsActive',true);
							   
			if(o_newrec.get('ProductCode') != null && productMap.containsKey((String)o_newrec.get('ProductCode')))
			{
				Boolean stagingRecAvailable = false;
				String portfolio;
				List<String> recs = productMap.get((String)o_newrec.get('ProductCode'));
				if(recs!= null && !recs.isEmpty())
				{
					Product2 product;
					for(integer i=0; i<recs.size(); i++)
					{//String record : recs
						//System.debug(record);
						product = o_newrec.clone(true);
						product.Id = recs[i].substringBefore(',');
						portfolio = recs[i].substringAfter(',');
						System.debug('portfolio: '+portfolio);
						if(portfolio == 'null' || portfolio == null || portfolio == '')
							product.put('APTS_Ext_ID__c',(String)o_newrec.get('ProductCode'));
						else
						{
							product.put('APTS_Ext_ID__c',(String)o_newrec.get('ProductCode')+portfolio);	
						}						
						//System.debug(product);
						//add the product to the productlist
						if(!productList.contains(product))
		productList.add(product);
						//System.debug(productlist);
					}	
				}									  
			}
			else
			{
				o_newrec.put('APTS_Ext_ID__c',(String)o_newrec.get('ProductCode'));
				o_newrec.put('Created_by_PMDI__c',true);
				productList.add(o_newrec);
			}					  
		}
		//System.debug(productlist);
		return productList;				
	}		
 
}