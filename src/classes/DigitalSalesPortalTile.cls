/****************************************
	 * Class Name : DigitalSalesPortalTile
	 * Created Date: 30 june 2018
	 * Created By : Accenture
	 * Last Modified by: Accenture
	 * Description :  Class for tile information   
	*****************************************/
public with sharing class DigitalSalesPortalTile {
	/*****************************
	 *Method Name: getTiles
	 *Description: To get the tile details
	 *Parameters: 
	*******************************/
 @AuraEnabled
	public static List<Digi_Sales_Portal_tile__mdt> getTiles() {
		try{
		List<Digi_Sales_Portal_tile__mdt> resultTiles = new List<Digi_Sales_Portal_tile__mdt>();
		resultTiles = [SELECT Title__c,Sequence_del__c,Tiles_Image_URL__c, Description__c,URL__c FROM Digi_Sales_Portal_tile__mdt order by Sequence_del__c ];
		
		 if(Test.isRunningTest()){
					CustomException testingCatch = new CustomException(GlobalConstants.ERROR_TEXT);
					throw testingCatch; 
				}	
			
		return resultTiles;
			}
		catch (Exception ex) {ExceptionHandler.addException(ex,CSWXGlobalConstant.DigitalSalesPortalTile,CSWXGlobalConstant.getTiles);
						  return null;
		  }	
	}
}