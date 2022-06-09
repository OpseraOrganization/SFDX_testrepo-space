/*************************************************************************************************
* Class Name : CH_ODRProduct
* Created Date: 13 May 2019
* Created By : TCS
* Descsription: Server Side Controller for CH_ODRUnitscustomLookup/CH_ODRProductcustomLookup lightning component
* Last Modified by: 
* Last Modified Date: 
* Description : 
*************************************************************************************************/
public class CH_ODRProduct {
	
	public static  List < CH_ODRProductUnitsData__c > returnList ;
	 /*****************************************************
	* Method Name : userProfileCheck
	* Created Date: 2 May 2019
	* Created By : TCS
	* Descsription: Check if logged in user profile is CH_Agent or not
	* Parameter: N/A
	* Return: CH_Agent true or flase
	* Last Modified by: 
	* Last Modified Date: 
	* Description: 
	*******************************************/   
	@AuraEnabled
	public static List < CH_ODRProductUnitsData__c > fetchProduct(String searchKeyWord) {
		returnList = new List < CH_ODRProductUnitsData__c > ();  
		String searchKey = searchKeyWord + '%';
		List < CH_ODRProductUnitsData__c > lstOfProduct = [select id, Product__c from CH_ODRProductUnitsData__c where Product__c LIKE: searchKey];
		for (CH_ODRProductUnitsData__c acc: lstOfProduct) {
			returnList.add(acc);
		}
		System.debug('returnList'+returnList);  
		return returnList;
		
	}
	
	@AuraEnabled
	public static List < CH_ODRProductUnitsData__c > builtPicklistString(String selectedProduct){
		System.debug('selectedProduct ma'+selectedProduct);
		List<CH_ODRProductUnitsData__c> unitListForString =new List<CH_ODRProductUnitsData__c>();
		String productdata = selectedProduct;
		String pickListString;
		integer lstCounter =0;
		List < CH_ODRProductUnitsData__c > lstOfUnit = [select id, Unit__c from CH_ODRProductUnitsData__c where Product__c = :productdata];
		system.debug('lstOfUnit' +lstOfUnit);
		
		//changes was done for user story 22823
		if(lstOfUnit.size()==0){
			CH_ODRProductUnitsData__c odrProdUnit = new CH_ODRProductUnitsData__c();
			 odrProdUnit.Unit__c='Percent Affected';
			odrProdUnit.Name = 'Percent Affected';
			odrProdUnit.Status__c='Active';
			odrProdUnit.Product__c=productdata;
			insert odrProdUnit;
			lstOfUnit.add(odrProdUnit);
		}
		for(CH_ODRProductUnitsData__c c1:lstOfUnit){
			unitListForString.add(c1);
		}
		return unitListForString;
	}
	
	@AuraEnabled 
	public static List < CH_ODRProductUnitsData__c > fetchUnits(String searchKeyWord ,string selectedProduct) {
		System.debug('selectProduct Test' +selectedProduct);  
		String productdata = selectedProduct;
		String searchKey = searchKeyWord + '%';
		String picklistString;
		List < CH_ODRProductUnitsData__c > returnList1 = new List < CH_ODRProductUnitsData__c > ();
		List < CH_ODRProductUnitsData__c > lstOfUnits = [select id, Unit__c from CH_ODRProductUnitsData__c where Product__c = :productdata AND Unit__c LIKE: searchKey];
		System.debug('************lstOfUnits: '+ lstOfUnits);
		for (CH_ODRProductUnitsData__c acc: lstOfUnits) {
			returnList1.add(acc);
		}
		return returnList1;
	}
	
	@AuraEnabled
	public static CH_ODRProductUnitsData__c OdrUnitsdata(String outageId,string selectedProduct,string selectedUnit){
		System.debug('outageId Test' +outageId);   
		System.debug('selectedProduct Test' +selectedProduct);   
		System.debug('selectedUnit Test' +selectedUnit);   
		CH_ODRProductUnitsData__c  c1=[select id,Name from CH_ODRProductUnitsData__c where product__c = :selectedProduct and Unit__c =:selectedUnit];
		System.debug('c1 values'+c1);
	
	CH_OutageDuration__c durReco=new CH_OutageDuration__c();
		
		durReco.id=outageId;
		durReco.CH_Outage_Units_ODR__c=c1.id;
		system.debug('test lookup value before' +durReco.CH_Outage_Units_ODR__c);
			update durReco;
		system.debug('test lookup value after' +durReco.CH_Outage_Units_ODR__c);
		system.debug('test c1'+  c1);
		return null;   
	}
	 /*****************************************************
	* Method Name : userProfileCheck
	* Created Date: 2 May 2019
	* Created By : Nokia
	* Descsription: getProductId
	* Parameter: N/A
	* Return: CH_Agent true or flase
	* Last Modified by: 
	* Last Modified Date: 
	* Description: 
	*******************************************/ 
	@AuraEnabled
	public static  Case getProductFromCase(string caseId){
		system.debug(' getProductFromCase Method starts here '+caseId);
		Case objCase = [Select id, productId, Product.Name from case where id = : caseId];
		system.debug(caseId+' objCase --> '+objCase);
		return objCase;
	}
}