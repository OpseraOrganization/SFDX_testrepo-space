/** 
* File Name: Thankyou_page_emailnotificationTest
* Description: Test Method
* Test Method for  Thankyou_page_emailnotification
* Copyright : Wipro Technologies Limited Copyright (c) 2010 * 
* @author : Wipro
* Modification Log 
* =============================================================== 
* Ver   Date        Author      Modification 
* --- ---- ------ ------------- ---------------------------------
* 1.0  Wipro  Created 
*/ 
@isTest
public class Thankyou_page_emailnotificationTest
{
 //Test method for Delegate_Confirmation_ACL
  static testMethod void testThankyou_page_emailnotification(){

 PageReference pageRef = Page.CustomizeApproval_eGreensheet;
  Test.setCurrentPage(pageRef);
 Thankyou_page_emailnotification wrkDetails=new Thankyou_page_emailnotification();
wrkDetails.thankyou();
}
}