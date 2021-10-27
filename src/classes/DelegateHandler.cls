/****************************************
 * Class Name : DelegateHandler
 * Created Date: 9th Sep 2017
 * Created By : Accenture
 * Last Modified by: Accenture
 * Last Modified Date: 
 * Description : Handle the sequence of the DelegateHelper
 * Test Class: 
 *****************************************/
 
 

public with sharing class DelegateHandler{

 @TestVisible Private Static List<Apttus_Approval__Backup_Approver__c> ApproverRec =new List<Apttus_Approval__Backup_Approver__c>();
 @TestVisible Private Static List<Apttus_Approval__Backup_Approver__c> DelegateRec=new List<Apttus_Approval__Backup_Approver__c>();

 /********************
	*Method Name: BeforeInsert
	*Parameter: Apttus_Approval__Backup_Approver__c  List
	*Description: Used to pass the input data into handler
	*******************/
	public static void BeforeInsert(List<Apttus_Approval__Backup_Approver__c > DelegateInfo){
	try{
	if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id)){
	  for(Apttus_Approval__Backup_Approver__c  Delrec:DelegateInfo)
	  {
		if(Delrec<>Null)
		DelegateRec.add(Delrec);
	  }
		   if(!DelegateRec.isEmpty())
			DelegateHelper.UserNSACheck(DelegateRec);
			 DelegateHelper.DelegateUpdate(DelegateRec);
	 }  
	 }
	 
	  catch (Exception ex) 
		   { ExceptionHandler.addException(ex, GlobalConstants.DELEGATE_HANDLER, GlobalConstants.BEFORE_INSERT);
		 } 

	 }
	 
	 
	 
 /********************
	*Method Name: BeforeUpdate
	*Parameter: Apttus_Approval__Backup_Approver__c  List
	*Description: Used to pass the input data into handler
	*******************/
	public static void BeforeUpdate(List<Apttus_Approval__Backup_Approver__c > NewDelegateInfo ,Map<Id,Apttus_Approval__Backup_Approver__c > OldDelegateInfo){
	
	List<Apttus_Approval__Backup_Approver__c> DeleRec= new List<Apttus_Approval__Backup_Approver__c>();
	try{
	for(Apttus_Approval__Backup_Approver__c Delegaterec:NewDelegateInfo)
	{
	  System.debug('--->'+Delegaterec.Apttus_Approval__InEffect__c);
	  if(Delegaterec.Apttus_Approval__IsActive__c==True && Delegaterec.Apttus_Approval__InEffect__c==TRUE && OldDelegateInfo.get(Delegaterec.id).Apttus_Approval__InEffect__c<>True  )
	  ApproverRec.add(Delegaterec);
	  
	  
	 }
 
 if(!ApproverRec.isEmpty() && !UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id))  
  DelegateHelper.UserNSACheck(ApproverRec);
 
 DelegateHelper.DelegateUpdate(NewDelegateInfo);
  
  }
  catch (Exception ex) 
		   { ExceptionHandler.addException(ex, GlobalConstants.DELEGATE_HANDLER, GlobalConstants.BEFORE_UPDATE);
		 } 
 
 }
	 
	 
	 


  }