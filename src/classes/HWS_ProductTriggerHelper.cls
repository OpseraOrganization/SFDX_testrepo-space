/****************************************
* Name : HWS_ProductTriggerHelper
* Author : TCS
* Description : This class is for loading data in Product as per Source
****************************************/
Public class HWS_ProductTriggerHelper {
	Public static void sourceFieldUpdate(Map<Id, Product2> oldProductMap, List<Product2> newProductList){
		for(Product2 p : newProductList)
		{
			if(p.HWS_Source__c =='PUMA1' && oldProductMap.get(p.id).HWS_Source__c == 'PuMA2')
			{
				p.HWS_Discontinued_Advanced_Exchange_Date__c =  oldProductMap.get(p.id).HWS_Discontinued_Advanced_Exchange_Date__c;
				p.HWS_SupportbyDerogationEndDate__c =  oldProductMap.get(p.id).HWS_SupportbyDerogationEndDate__c;
				p.HWS_Discontinued_Repair_Date__c =  oldProductMap.get(p.id).HWS_Discontinued_Repair_Date__c;
				p.HWS_Discontinued_Advanced_Exchange_Date__c=  oldProductMap.get(p.id).HWS_Discontinued_Advanced_Exchange_Date__c;
				//p.HWS_OEM_manufacturer_part_code__c=p.HWS_OEM_manufacturer_part_code__c ;
				//p.HWS_SPS_Last_Order_Date__c = p.HWS_SPS_Last_Order_Date__c ;
				//p.HWS_SAP_Status__c = p.HWS_SAP_Status__c;
				//p.HWS_No_Swap_Flag__c =p.HWS_No_Swap_Flag__c;
				//p.HWS_Material_Type__c=p.HWS_Material_Type__c;
				//p.HWS_Manufacturer__c=p.HWS_Manufacturer__c;
				//p.HWS_Life_Extender__c=p.HWS_Life_Extender__c;
				//p.HWS_Status__c=p.HWS_Status__c;
				p.HWS_IsValidForBoth__c=true;			   
			} 
			if(p.HWS_Source__c =='PuMA2' && oldProductMap.get(p.id).HWS_Source__c=='PUMA1')
			{
				//p.HWS_Discontinued_Advanced_Exchange_Date__c =  p.HWS_Discontinued_Advanced_Exchange_Date__c;
				//p.HWS_SupportbyDerogationEndDate__c =  p.HWS_SupportbyDerogationEndDate__c;
				//p.HWS_Discontinued_Repair_Date__c =  p.HWS_Discontinued_Repair_Date__c;
				//p.HWS_Discontinued_Advanced_Exchange_Date__c=  p.HWS_Discontinued_Advanced_Exchange_Date__c;
				p.HWS_OEM_manufacturer_part_code__c=oldProductMap.get(p.id).HWS_OEM_manufacturer_part_code__c ;
				p.HWS_SPS_Last_Order_Date__c = oldProductMap.get(p.id).HWS_SPS_Last_Order_Date__c ;
				p.HWS_SAP_Status__c = oldProductMap.get(p.id).HWS_SAP_Status__c;
				p.HWS_No_Swap_Flag__c =oldProductMap.get(p.id).HWS_No_Swap_Flag__c;
				p.HWS_Material_Type__c=oldProductMap.get(p.id).HWS_Material_Type__c;
				p.HWS_Manufacturer__c=oldProductMap.get(p.id).HWS_Manufacturer__c;
				p.HWS_Life_Extender__c=oldProductMap.get(p.id).HWS_Life_Extender__c;
				p.HWS_Status__c=oldProductMap.get(p.id).HWS_Status__c;
				p.HWS_IsValidForBoth__c=true;			   
			} 
		}
	}
}