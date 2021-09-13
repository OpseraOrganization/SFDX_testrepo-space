/****************************************
 * Class Name : DelegateHelper
 * Created Date: 9th Sep 2017
 * Created By : Accenture
 * Last Modified by: Accenture
 * Last Modified Date: 
 * Description : Used to check the NSA info of Backup and Delegate Users
 * Test Class: 
 *****************************************/
 
 

public with sharing class DelegateHelper{


 


 /********************
	*Method Name: UserNSACheck
	*Parameter: Apttus_Approval__Backup_Approver__c  List
	*Description: Used to check the NSA info of User info
	*******************/
	public static void UserNSACheck(List<Apttus_Approval__Backup_Approver__c > DelegateInfo){
	Map<Integer,id> Userid =new Map<Integer,ID>();
	Map<Integer,ID> CurrentUser =new Map<Integer,ID>();
	Map<ID,Boolean> UserNSAInfo =new Map<ID,Boolean>();
	Set<ID> Usersrec= new Set<ID>();
	 Boolean NSACheckStatus =False;
	 
  try{
	  for(Apttus_Approval__Backup_Approver__c DelRec:DelegateInfo)
	  {
		  Integer Count=0;

	   Userid.put(Count,DelRec.Apttus_Approval__Current_User__c);
	   Usersrec.add(DelRec.Apttus_Approval__Current_User__c);
	   System.debug('Dele-->'+DelRec.Apttus_Approval__DelegateUserIds__c);
		if(DelRec.Apttus_Approval__DelegateUserIds__c<>Null && !DelRec.Apttus_Approval__DelegateUserIds__c.contains(','))
		 {
		 Userid.put(Count+1,DelRec.Apttus_Approval__DelegateUserIds__c);
		 Usersrec.add(DelRec.Apttus_Approval__DelegateUserIds__c);
		 }
		 else
		 if(DelRec.Apttus_Approval__DelegateUserIds__c<>Null && DelRec.Apttus_Approval__DelegateUserIds__c.contains(','))
		  {
			String[] delegateApproverIds = DelRec.Apttus_Approval__DelegateUserIds__c.split(',');
			for (string delegateapproverId: delegateApproverIds) {
				Userid.put(Count+1,delegateapproverId);
				 Usersrec.add(delegateapproverId);  
		  }
		 
		}
   }	 
	   if(UserID.size()>0) {  
	 for(User Userinfo:[Select id,NSA_Compliant__c from User where id=:Usersrec])
   UserNSAInfo.put(Userinfo.ID,Userinfo.NSA_Compliant__c);
   
 for(Apttus_Approval__Backup_Approver__c DelRec:DelegateInfo){

   System.debug('Loop-->'+UserNSAInfo);
   if(UserNSAInfo.get(Userid.get(0))<>Null && UserNSAInfo.get(Userid.get(0))==True)
   {
   System.debug('Inside Loop-->');
	  if(UserNSAInfo.get(Userid.get(1))<>NULL && UserNSAInfo.get(Userid.get(1))==False)
	  NSACheckStatus=true;
	 
	  else
	  if(UserNSAInfo.get(Userid.get(2))<>NULL && UserNSAInfo.get(Userid.get(2))==False)
		 NSACheckStatus=true;
	  else
	  if(UserNSAInfo.get(Userid.get(3))<>NULL && UserNSAInfo.get(Userid.get(3))==False)
	  NSACheckStatus=true;
		  

	  }
   
		  if(NSACheckStatus==true)
		   DelRec.adderror(Label.NF_NSA_Check);
		  
	   
		 }   
	 }
		
	 
  }
	catch (Exception ex) 
		   { ExceptionHandler.addException(ex, GlobalConstants.DELEGATE_HELPER, GlobalConstants.USER_NSA_CHECK);
		 } 
  
}  
  
  
  /********************
	*Method Name: DelegateUpdate
	*Parameter: Apttus_Approval__Backup_Approver__c  List
	*Description: Used to Update the Delegate Approver field
	*******************/
	public static void DelegateUpdate(List<Apttus_Approval__Backup_Approver__c > DelegateInfo){
Map<Integer,id> Userid =new Map<Integer,ID>();

try{
	
	   for(Apttus_Approval__Backup_Approver__c DelRec:DelegateInfo)
	  {
	  
		  Integer Count=0;
 
		 if(DelRec.Apttus_Approval__DelegateUserIds__c<>Null && DelRec.Apttus_Approval__IsDelegate__c==True)
		  {
			String[] delegateApproverIds = DelRec.Apttus_Approval__DelegateUserIds__c.split(',');
			for (string delegateapproverId: delegateApproverIds) {
				count = count + 1;
				Userid.put(Count,delegateapproverId);   
		  }
		 
			 system.debug('UserId:'+UserId);
			//commented on 2018-06-19 to change logic of udpate Delegate Approver 1-3 by chen chen <chen.8.chen.ext@nokia.com>
			/*
			 if(Userid.get(1)<>Null)
				DelRec.Delegate_Approver1__c=Userid.get(1);
				if(Userid.get(2)<>Null)
				DelRec.Delegate_Approver2__c=Userid.get(2);
				if(Userid.get(3)<>Null)
				DelRec.Delegate_Approver3__c=Userid.get(3);
			*/
			//end commented on 2018-06-19 by chen chen
			//added on 2018-06-19 to update Delegate_Approver1__c, Delegate_Approver2__c and Delegate_Approver3__c by chen chen <chen.8.chen.ext@nokia.com>
			DelRec.Delegate_Approver1__c = Userid.get(1);
			DelRec.Delegate_Approver2__c = Userid.get(2);
			DelRec.Delegate_Approver3__c = Userid.get(3);
			//end added on 2018-06-19 to update Delegate_Approver1__c, Delegate_Approver2__c and Delegate_Approver3__c by chen chen
			}
			
			 else if(DelRec.Apttus_Approval__IsDelegate__c==False)
			 {
			 DelRec.Delegate_Approver1__c=Null;
			 DelRec.Delegate_Approver2__c=NUll;
			 DelRec.Delegate_Approver3__c=Null;
			 }
			
			
			 
		 } 
	
	
	   }
	   catch (Exception ex) 
		   { ExceptionHandler.addException(ex, GlobalConstants.DELEGATE_HELPER, GlobalConstants.DELEGATE_UPDATE);
		 } 
 
 }
 
   
  
 
	  
	  

 }