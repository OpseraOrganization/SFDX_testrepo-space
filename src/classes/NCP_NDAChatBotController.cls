/******************************************************************************************************************************
* Class Name:   NCP_NDAChatBotController
* Test Class:   NCP_NDAChatBotControllerTest
* Date		  Modified By	 Demand	  Remarks
* 27/01/2021	Soham		   DEM0053592  Created - To check if the Logged in User is a Guest User or not. This is developed as part of 
											DEM0053592 - Enabling the NDA Chat Bot
*******************************************************************************************************************************/
public with sharing class NCP_NDAChatBotController{
	/**************************************************************************************************
	*Method Name:   isRendered
	*Parameter:	 NA
	*Return:		Boolean
	*Date		   Modified By	 Demand	  Remarks
	 27/01/2021	 Soham		   DEM0053592  Created - To check if the Logged in User is a Guest User or not. This is developed as part of 
												DEM0053592 - Enabling the NDA Chat Bot
	**************************************************************************************************/
	@AuraEnabled
	public static Boolean isRendered(){
		return UserInfo.getUserType() == 'Guest' ? false : true;
	}
}