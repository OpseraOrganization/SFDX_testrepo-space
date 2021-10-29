/***********************************************************************************************************
* Company Name          : NTT Data
* Name                  : ContAlertCls
* Description           : Controller for the Contactalertpage to display banner in Portal contact 
* 
* Modification History  :
* Date             Version No.    Modified by           Brief Description of Modification
* Nov-26-2014      1.1            NTTData               SR# INC000006702002- Controller for the Contactalertpage to display banner in Portal contact   
***********************************************************************************************************/
public class ContAlertcls {
    public boolean displayPopup {get; set;} 
    public boolean displayAccPop {get; set;}
    public boolean displayPopup1 {get; set;} 
    public boolean displayalert{get; set;}  
    public ApexPages.StandardController stdController;
    contact contact{get;set;}
    //public boolean bol{get;set;}
   // public list<Portal_Honeywell_ID__c> lstphid {get;set;}
    public User usr{get;set;}
   
    public contact sr{get;set;} 

    public ContAlertcls(ApexPages.StandardController stdcontroller) {
    
        //bol=false;
        contact= (contact)stdController.getRecord();
        system.debug('Contacttt'+contact);
        displayalert=false;
        displayPopUp=false;
        displayPopUp1=false;
        displayAccPop=false;
        
       string userprofileid=userinfo.getprofileid();
       system.debug('userprofileid'+userprofileid);
       sr = [SELECT Id,Contact_Is_Employee__c,Honeywell_Id__c,Account.US_Govt_Sanctioned__c FROM contact 
                   WHERE Id = :ApexPages.currentPage().getParameters().get('id')];
                   system.debug('srrrrr'+sr);
       if(((null != sr.Honeywell_ID__c)&& sr.Honeywell_ID__c!=null && sr.Contact_Is_Employee__c == false )
      &&(userprofileid != label.Sys_Admin_Profile_Id && userprofileid != label.Honeywell_System_Administrator && userprofileid != label.Honeywell_System_Administrator_Non_US_PFID && userprofileid != label.Honeywell_System_Administrator_US && userprofileid != label.Web_Support_CSR) && sr.Account.US_Govt_Sanctioned__c != true)      
      
       {
           system.debug('displayyy alerttt1');
           displayalert=true;  
           //displayAccPop=false;
       }
        else if(((null != sr.Honeywell_ID__c)&& sr.Honeywell_ID__c!=null && sr.Contact_Is_Employee__c == false )
      &&(userprofileid != label.Sys_Admin_Profile_Id && userprofileid != label.Honeywell_System_Administrator && userprofileid != label.Honeywell_System_Administrator_Non_US_PFID && userprofileid != label.Honeywell_System_Administrator_US && userprofileid != label.Web_Support_CSR) && sr.Account.US_Govt_Sanctioned__c == true)      
      
       {
           system.debug('displayyy alerttt2');
           displayalert=true;  
		   displayAccPop=true;
       }
       else if(sr.Honeywell_ID__c!=null && sr.Contact_Is_Employee__c == false && sr.Account.US_Govt_Sanctioned__c != true)
       {
           displayPopUp=true;
           //displayAccPop=false;
           }
         else if(sr.Honeywell_ID__c!=null && sr.Contact_Is_Employee__c == false && sr.Account.US_Govt_Sanctioned__c == true)
       {
           displayPopUp=true;
		   displayAccPop=true;
           }
           else if(userprofileid != label.Sys_Admin_Profile_Id && userprofileid != label.Honeywell_System_Administrator && userprofileid != label.Honeywell_System_Administrator_Non_US_PFID && userprofileid != label.Honeywell_System_Administrator_US && userprofileid != label.Web_Support_CSR && sr.Account.US_Govt_Sanctioned__c != true)
           {
           displayPopUp1=true;
           //displayAccPop=false;
           }      
           else if(userprofileid != label.Sys_Admin_Profile_Id && userprofileid != label.Honeywell_System_Administrator && userprofileid != label.Honeywell_System_Administrator_Non_US_PFID && userprofileid != label.Honeywell_System_Administrator_US && userprofileid != label.Web_Support_CSR && sr.Account.US_Govt_Sanctioned__c == true)
           {
           displayPopUp1=true;
		   displayAccPop=true;
           }
		   else if(sr.Account.US_Govt_Sanctioned__c == true)
		   {
		   displayAccPop=true;
		   }
      //displayPopup =false;
      // if(sr.Honeywell_ID__c != null && sr.Contact_Is_Employee__c == false)
       //{
       //system.debug('Displayyy poppppp');
       //displayPopup =true;
       //}
      }
       
    public contact getcontact() {
        return contact;
    }
  
         
   /* public void closePopup() {  
        displayPopup = false; 
        displayPopup1 = false;
       //sr.Previous_Email__c = sr.Email;
       //update sr;
    }     
    
     public void closePopup1() {   
       sr.Email= sr.Previous_Email__c;
       update sr;
    } 
    
    public void showPopup() {        
        displayPopup = true; 
        //displayPopup1 = true; 
       // displayalert=true; 
    }
    public void showPopup1() {        
       // displayPopup = true; 
        displayalert=true; 
    }*/
    
}