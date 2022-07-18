/******************************************************************************************************************************
* Class Name:   NCP_NDAChatBotController
* Test Class:   NCP_NDAChatBotControllerTest
* Date	Modified By	 Demand	  Remarks
* 27/01/2021	Soham	 DEM0053592  Created - To check if the Logged in User is a Guest User or not. This is developed as part of 
		DEM0053592 - Enabling the NDA Chat Bot
*******************************************************************************************************************************/
public with sharing class NCP_NDAChatBotController{
	/**************************************************************************************************
	*Method Name:   chatBotRefresh
	*Parameter:	 NA
	*Return:		Boolean
	*Date		   Modified By	 Demand	  Remarks
	 27/01/2021	 Soham		   SP-66	   Created - To check if the new User Login to Community
	**************************************************************************************************/
	@AuraEnabled
	public static String chatBotRefresh(){
		return  UserInfo.getSessionID();
	}

	 /**************************************************************************************************
	*Method Name:   isProductionOrg
	*Parameter:	 NA
	*Return:		Boolean
	*Date		   Modified By	 Demand	  Remarks
	 27/01/2021	 Soham		   SP-66	   Created - To check if the Org is a Production org
	**************************************************************************************************/
	@AuraEnabled
	public static Boolean isProductionOrg(){
		return !NCP_Utils.isSandbox();
	}
	/**************************************************************************************************
	*Method Name:   isGuestUser 
	*Parameter:	 NA
	*Return:		Boolean
	*Date	 Modified By	 Demand	  Remarks
	*10/5/2021 Karan	 Guest User check
	**************************************************************************************************/
	@AuraEnabled
	public static Boolean isGuestUser(){
		return (UserInfo.getUserType() == 'Guest')  ? true : false;
	}
}