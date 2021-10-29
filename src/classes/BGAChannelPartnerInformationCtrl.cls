/** * File Name:BGAChannelPartnerInformationCtrl
    * Description This class is to create a Channel Partner VF Page to add the details for the Users
    * @author : TCS-GTO Team
* */

public with sharing class BGAChannelPartnerInformationCtrl 
{ 
       //Variable Declaration
       public Account acc { get; set; }
       public Account_Address__c accAddress { get; set; }
       public String renderAs {get;set;}
       public boolean editMode {get;set;}
       
      
   /** Constructor : Fields are added to List and the variables 'renderAs' and 'editmode' are assigned values**/      
       
      public BGAChannelPartnerInformationCtrl(ApexPages.StandardController stdController)
        {
               
               String accId = ApexPages.currentPage().getParameters().get('Id');
               
               editMode =false;
               try{
               acc  = [Select Id ,Name, POC__c,Tier_1__c,Tier_2__c,Tier_3__c,Tier_4__c,Postal_Code__c,TPE331_Details__c,TPE331LOA__c,TFE731_Details__c,TFE731LOA__c,APU_Details__c,APU_LOA__c,HTF_Details__c,HTF_LOA__c,Service_Territory__c,TPE331__c,TFE731__c,APU__c, HTF__c,Account_Owner__c,Pricing_Setting__c,Amendment_Avionics_Dealer__c,Amendment_Service_Center__c,Mechanical_License_Agreement__c,Dealer_Tech_Pub_Categorization__c,Avionics_License_Agreement__c,Customer_Group__c,E_mail_address__c ,Account_Adress__c,State_Code__c,Region_Name__c,City_Name__c,Website,Country__c,Phone,POC_Management__c,SC_locator_visibility__c,GTA_number__c,SAP_account_sold_to__c  from Account where Id =: accId];
             
               Account_Address__c accAddress1 = new Account_Address__c(Account_Name__c = acc.Id);
               accAddress =[select Id,AccountOwner_Email__c,Mobile_App_Visibility__c,Engine_Authorization__c,Avionics_Support_Level__c,Authorized_Avionics_Dealer__c,Authorized_Mechanical_Service_Center__c from Account_Address__c where Account_Name__c =:acc.Id limit 1];
              
               if(accAddress ==  null){
                accAddress = accAddress1;
               }
               }
               catch(Exception e){
               
                ApexPages.Message msg =new ApexPages.Message(ApexPages.severity.ERROR,'First enter Account address.Click <a href=\'https://cs28.salesforce.com/a0o/o\'>Link</a>');
               ApexPages.addmessage(msg);

                System.debug('The exception is' +e.getMessage());
                }
                if(!String.isBlank(ApexPages.currentPage().getParameters().get('renderAs'))){
                    renderAs='pdf';  
                 }
               if (String.isBlank(ApexPages.currentPage().getParameters().get('renderAs'))) {         
                renderAs=''; 
                }
       } 
      
       
       
  /** * Method Name:cancel
      * Description : This method returns to the Standard Account Layout 
   * */     
       
         public Pagereference cancel()
           {
               editMode =false;
               PageReference newPage = new PageReference('/'+acc.Id);  
               newPage.setRedirect(true);
               return newPage;
           }
           
         
  /** * Method Name:back
      * Description : This method redirects to the Non-editable VF Page
  * */ 
            
         public Pagereference back()
          {
             editMode =true;
             PageReference prevPage = new PageReference('/apex/BGAChannelPartnerInformationCtrlPage?id='+acc.Id);
             prevPage.setRedirect(true);
             return prevPage;
          }
     
          
   /** * Method Name:edita
       * Description : This method redirects to the Editable VF Page
   * */        
          
          public Pagereference edita() 
          { 
           editMode =true;  
           return null; 
              
          }
         
          
  /** * Method Name:save
      * Description : This method saves the User entries into the Database.
  * */          
            
         public Pagereference save()
          {  
             
             update acc;  
             if(accAddress==null)
             {
              ApexPages.Message msg=  new ApexPages.Message(ApexPages.severity.ERROR,'First enter Account address.Click <a href="https://cs28.salesforce.com/a0o/o">Link</a>');
              return null;
              }
            
             else
             {
             upsert accAddress; 
             PageReference nextPage = new PageReference('/apex/BGAChannelPartnerInformationCtrlPage?id='+acc.Id);
             nextpage.setRedirect(true);
             return nextpage; 
             }
           }
         
           
   /** * Method Name:OpenPdf
       * Description : This method opens the Pdf converted page.
   * */        
             
         public PageReference OpenPdf()
         {
      
             if (String.isBlank(ApexPages.currentPage().getParameters().get('renderAs'))) 
             {
                 System.debug('**');
                 PageReference pageRef = new PageReference('/apex/BGAChannelPartnerInformationCtrlPage?id='+acc.Id+'&renderAs=pdf');  
                 pageRef.setRedirect(true);
                 return pageRef;
                
             }
              return null;
         }  
               
       
   /** *  Description : This is an object defined. * */   
             
         public Attachment attachment 
         {
          get {
              if (attachment == null)
              attachment = new Attachment();
              return attachment;
              }
          set;
      }
     
    
    /** * Method Name:upload
        * Description : This method is used to upload the Users documents.
     * */  
 
      public PageReference upload()
      {
        attachment.OwnerId = UserInfo.getUserId();
        attachment.ParentId = acc.Id; // the record the file is attached to
        attachment.IsPrivate = true;
    
        try 
        {
          insert attachment;
        } catch (DMLException e)
         {
          ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading attachment'));
          return null;
        } 
        finally 
        {
          attachment = new Attachment(); 
        }
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Attachment uploaded successfully'));
        return null;
      }
       
 }