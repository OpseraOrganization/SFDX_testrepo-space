public with sharing class HwTrng_Enroll_Registration_cls {
 
    public Web_Portal_Contact_Citizenship__c opp{get;set;}
    ApexPages.StandardController sController;
      public string radiovalue{get;set;}
      public string radiovalue1{get;set;}
      public boolean nonhoneywell12{get;set;}
      public boolean callwindow{get;set;}
      public boolean requiredval{get;set;}
      public Boolean isChecked { get; set; }
      public contact lstcon;
      public string firstname{get;set;}
      public string lastname{get;set;}
      public string primaryaddress{get;set;}
      public string companyaddress{get;set;}
      public String  uid ;
      Id i;
      public account account { get; set; }
      public List<SelectOption> getoptions() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Yes','Yes'));
        options.add(new SelectOption('No','No'));
        return options;
    }
 
    
    public HwTrng_Enroll_Registration_cls(ApexPages.StandardController controller) {
       
          i = ApexPages.currentPage().getParameters().get('Class_Name__c');
          system.debug('class id---->'+i);
          uid = Userinfo.getuserid(); 
          //uid='005c0000000nKzSAAU';
       radiovalue='Yes';
       radiovalue1='Yes';
       user usr = [Select id,UserRoleId,firstname,lastname,CompanyName,title,phone,city,state,country,postalcode,Email,MobilePhone,fax,Extension,Federation_Formula__c  from User where id =: uid limit 1];       
       lstcon=[SELECT FirstName,LastName,Phone_1_Ext__c,Is_US_Citizen__c,Passport_Expiry_Date__c,Passport_Number__c,City_Name__c,Dual_Citizenship_Country__c,
               Citizenship_Country__c,State_Code__c,Address_Line_1__c,Portal_Company_Name__c,Contact_Birth_Country__c,Job_Title__c,Phone_1__c,Phone_2__c,Phone_3__c,
               Country_Name__c,Company_Address__c,Address_Line_2__c,Do_you_own_Operate_or_Maintain_Honeywell__c,Address_Line_3__c,Visa_Expiry_Date__c,Visa_Number__c,Visa_Type__c,AccountId ,Birth_City__c,Web_Portal_Company_Name__c,MobilePhone,Market__c,Alternate_Email_Address__c,Company_E_Mail_Address__c,Primary_Email_Address__c,Customer_Portal_UserId__c,Postal_Code__c FROM Contact WHERE Customer_Portal_UserId__c = :uid and Honeywell_ID__c = :usr.Federation_Formula__c limit 1];   
       
        sController = controller;        
        opp = (Web_Portal_Contact_Citizenship__c)controller.getRecord();
        opp.First_Name__c=lstcon.FirstName;
        opp.Last_Name__c=lstcon.LastName;
        opp.City_Name__c=lstcon.City_Name__c;
        opp.Company_E_Mail_Address__c=lstcon.Primary_Email_Address__c;        
        opp.Company_Name__c=lstcon.AccountId;
        opp.Job_Title__c=lstcon.Job_Title__c;
        opp.Address_Line_1_c__c=lstcon.Address_Line_1__c;
        opp.Address_Line_2__c=lstcon.Address_Line_2__c;
        opp.Address_Line_3__c=lstcon.Address_Line_3__c;
        opp.Market__c=lstcon.Market__c;
        opp.Contact_Birth_Country__c=lstcon.Contact_Birth_Country__c;
        opp.Birth_City__c=lstcon.Birth_City__c;
        opp.Email_Address__c=lstcon.Alternate_Email_Address__c;
        opp.Primary_Work_Number__c=lstcon.Phone_1__c;
        opp.Phone_1_Ext__c=lstcon.Phone_1_Ext__c;
        opp.MobilePhone__c=lstcon.MobilePhone;
        opp.Fax_Number__c=lstcon.Phone_3__c;
        opp.Company_Address__c=lstcon.Company_Address__c;
        opp.State_Code__c=lstcon.State_Code__c;
        opp.Country_Name__c=lstcon.Country_Name__c;
        opp.Postal_Code__c=lstcon.Postal_Code__c;
        opp.Contact_Citizenship_Country__c=lstcon.Citizenship_Country__c;
        opp.Contact_Citizenship_Country2__c=lstcon.Dual_Citizenship_Country__c;
        opp.Do_you_own_Operate_or_Maintain_Honeywell__c=lstcon.Do_you_own_Operate_or_Maintain_Honeywell__c;
        opp.Web_Additional_form_flag__c = True;
        opp.Class_Name__c = i;
        /*if(lstcon.Do_you_own_Operate_or_Maintain_Honeywell__c ==true)
        {
          radiovalue1='Yes';
        }
        else
        {
          radiovalue1='No';
        }*/       
        
    }   
      public contact getLstcon() 
    {  
         return lstcon;
    }
    public void makereq()
    {
        if(radiovalue=='No')
         requiredval=true;
        if(radiovalue=='Yes') 
             requiredval=false;
    } 
     public void nonhoneywell1()
    {
       if(radiovalue1=='No')
         nonhoneywell12=true;
        if(radiovalue1=='Yes') 
             nonhoneywell12=false;
    }      
    public void save11()
    {
      
        if(radiovalue1=='Yes')
        {
          opp.Do_you_own_Operate_or_Maintain_Honeywell__c=true;
        }
        else
        {
          //opp.State_Code__c='N/A';
          opp.Do_you_own_Operate_or_Maintain_Honeywell__c=false;
          return ;
          
        }
        if(radiovalue=='Yes')
        { 
        
        opp.Is_US_Citizen__c= true;
        }
        else
        {
         opp.State_Code__c='N/A';
         opp.Is_US_Citizen__c= false;
        }
       callwindow=true;
        
       try{
         sController.save();
         system.debug('Test class id---->'+i);
         Class__c c1=[select id,name,Reserve_Class__c from Class__c where id=: i limit 1];
          c1.Reserve_Class__c = true;
          update c1; 
       } catch(Exception e) {
        }
     }
      public PageReference doCancel()
  {
     return sController.cancel();
  }
 
    public PageReference MyMethod(){
        account = [SELECT Id FROM Account WHERE IsCustomerPortal = true limit 10];    
        return null;
    }

}