// Controller to achieve My tasks List View in VF
public without sharing class AccountWebForm{
    ///Id InactiveuserId,MasterDatauserId,CaserecordtypeId;
    //Id InactiveuserId=[Select Id from user where name='Inactive Record Owner'].Id;
    //Id MasterDatauserId=[Select Id from user where name='Salesforce Customer Master'].Id;
    //Id CaserecordtypeId=[select Id from RecordType where SobjectType = 'Case' and (DeveloperName = 'Account WebForm Creation')].Id;

    Account accounts = new Account();
    Account accounts1 = new Account();
    Boolean casecreated = false;
    string accname;
    Id attid;
    //private list<Attachment> lisatt=new list<Attachment>();
    Case cases = new Case();
    Case caseCreate = new Case();
    transient public  Attachment  myAttachment;
    //Attachment upatt = new Attachment();
    //myAttachment = new Attachment();
    public String firstname{get; set;}
    public String lastname{get; set;}
    public String Email{get; set;}
    public String Currentlydoingbusiness{get; set;}
    public String TypeofRequest{get; set;}
    public String CRMID{get; set;}
    public String ACCNAME1{get; set;}
    public String changetype{get; set;}
    public String ChangeDescription{get; set;}
    public String AccountNameweb{get; set;}
    public String CompanyWebsiteURL{get; set;}
    public String AddressLine1{get; set;}
    public String AccountPrimaryPhoneNumber{get; set;}
    public String AddressLine2{get; set;}
    public String AccountFaxNumber{get; set;}
    public String AddressLine3{get; set;}
    public String CountryName{get; set;}
    public String CityName{get; set;}
    public String StateCode{get; set;}
    public String PostalCode{get; set;}
    //SR#388667 - code change starts
    public String SBU{get; set;}
    public String CBT{get; set;}
    public String CBTTeam{get; set;}
    public String CBTDirectorate{get; set;}
    public String Market{get; set;}
    //SR#388667 - code change Ends
    
    public string fileName
    {    get;set;    }  

    transient public Blob fileBody   
    {    get;set;    }  

    public Boolean showsection   
    {    get;set;    }  

    public Boolean Showfile  
    {    get;set;    }     

    public Boolean showdocLoaded
    {    get;set;     } 
    

    //variable declarations
    //constructor
    public AccountWebForm(ApexPages.StandardController controller) {

    }

    public void UploadFile()  
    {   
         myAttachment = new Attachment();
            
        if(fileName != null && filebody != null)  
        {       
            system.debug('Eneteredafterif'+fileName);                  
            accname=fileName;
            //lisatt.add(myAttachment);
            Integer fileCharacters = filebody.size();
             if(fileCharacters >=10485760){     
             ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR,'File size exceeded the maximum limit');  
             ApexPages.addMessage(myMsg1);
             }
             else{  
             caseCreate.First_Name__c=firstname;
             caseCreate.Last_Name__c=lastname;
             caseCreate.Account_Webform_Submitter_Email__c=Email;
             caseCreate.Account_Number_web__c=CRMID;
             caseCreate.Currently_Doing_Business__c=Currentlydoingbusiness;
             caseCreate.Type_of_Request__c=TypeofRequest;  
             caseCreate.Origin='Web';
             caseCreate.ownerId=label.Customer_Master_Data_SFDC_Accounts;
             caseCreate.status='Open';
             caseCreate.RecordtypeId=label.Account_WebForm_Creation_RecordType;
             caseCreate.Export_Compliance_Content_ITAR_EAR__c='No';
             caseCreate.Government_Compliance_SM_M_Content__c='No';
             caseCreate.subject=TypeofRequest;
             caseCreate.Change_Type__c=changetype;
           //  caseCreate.Change_Description__c=ChangeDescription;
             caseCreate.Description = ChangeDescription;
             caseCreate.Account_Name_web__c= AccountNameweb;
             caseCreate.Company_Website_URL__c=CompanyWebsiteURL;
             caseCreate.Address_Line_1__c=AddressLine1;
             caseCreate.Account_Primary_Phone_Number__c=AccountPrimaryPhoneNumber;
             caseCreate.Address_Line_2__c=AddressLine2;
             caseCreate.Account_Fax_Number__c=AccountFaxNumber;
             caseCreate.Address_Line_3__c=AddressLine3;
             caseCreate.Country_Name__c=CountryName;
             caseCreate.City_Name__c=CityName;
             caseCreate.State_Code__c=StateCode;
             caseCreate.Postal_Code__c=PostalCode;
                                 

             insert caseCreate;
             casecreated=true;
                myAttachment.Name = fileName; 
                myAttachment.Body =filebody ;
                myAttachment.parentid=caseCreate.id;
                insert myAttachment;
             Showfile=false;
             showdocLoaded=true;
            }
          }
        }
        
    public String getmyAttach(){
        return accname;
    }

    public Account getaccounts1(){
        return accounts1;
    }

    public Case getCaseCreate(){
        return Casecreate;
    }

    public PageReference Refresh(){


    //PageReference pageRef = new PageReference('https://c.na1.visual.force.com/apex/AccountWebForm');
      PageReference pageRef = new PageReference('/apex/AccountWebForm');

       // PageReference pageRef = new PageReference('https://c.cs0.visual.force.com/apex/AccountWebForm');
        return pageRef ;
    }

public List<SelectOption> getlistofTyperequest()    
 {      
   //string str=(Userinfo.getuserid()).substring(0,15); 
   List<SelectOption> options = new List<SelectOption>();                    
   options.add(new SelectOption('0001','--None--'));                           
                  options.add(new SelectOption('SFDC New Account Creation','SFDC New Account Creation'));
                  options.add(new SelectOption('Account Change','Account Change'));            
           return options;   
 }
 public List<SelectOption> getlistofTypechange()    
 {      
   //string str=(Userinfo.getuserid()).substring(0,15); 
   List<SelectOption> options = new List<SelectOption>();                    
   options.add(new SelectOption('0001','--None--'));                           
                  options.add(new SelectOption('Address Update','Address Update'));
                  options.add(new SelectOption('Name Change','Name Change')); 
                  options.add(new SelectOption('Parenting Change','Parenting Change'));
                  options.add(new SelectOption('Market Details','Market Details'));
                  options.add(new SelectOption('Other','Other'));              
           return options;   
 }

public List<SelectOption> getlistofDobuss()    
 {      
   //string str=(Userinfo.getuserid()).substring(0,15); 
   List<SelectOption> options = new List<SelectOption>();                    
   options.add(new SelectOption('0001','--None--'));                           
                  options.add(new SelectOption('Yes','Yes'));
                  options.add(new SelectOption('No','No')); 
                                
           return options;   
 }
    public PageReference ShowDetails(){
      if(!(Email.contains('@')&&Email.contains('.com')))
        {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'Invalid Email Address'));
        }else{
        Showfile=true;
        showdocLoaded=false;
        showsection=false;
        
        if(TypeofRequest=='Account Change'){
            if(CRMID==null  || CRMID==''){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'Please enter the sfdc Number of account to update'));  
            }
            else{
                String rowId=caseCreate.Account_Number_web__c;
                try{
                    //Included the SBU, CBT, CBT Team, CBT Directorate and market in the below query for SR#388667.
                    accounts1=[Select Id,name ,website ,phone ,fax,Address_Line_1__c,
                    Address_Line_2__c,Address_Line_3__c,City_Name__c,State_Code__c,Country_Name__c,Postal_Code__c,Strategic_Business_Unit__c,CBT__c,CBT_Team__c,Market_Name__c,CBT_Directorate__c
                    from account where
                    Sbl_Account_Row_Id__c=:CRMID];
                    ACCNAME1= accounts1.name ;
                    system.debug('%%%%%%%%%%'+ACCNAME1);
                    showsection=true;
                }
                catch(Exception e){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'Account you entered not existing')); 
                }
            }
            return null;   
        }
        else{
            showsection=true;
            return null;
        }
      } 
      return null; 
    }

    public PageReference caseSave(){
        //try{ 
        
            caseCreate.First_Name__c=firstname;
            caseCreate.Last_Name__c=lastname;
            caseCreate.Account_Webform_Submitter_Email__c=Email;
            caseCreate.Account_Number_web__c=CRMID;
            caseCreate.Currently_Doing_Business__c=Currentlydoingbusiness;
            caseCreate.Type_of_Request__c=TypeofRequest;           
            caseCreate.Origin='Web';
            caseCreate.ownerId=label.Customer_Master_Data_SFDC_Accounts;
            caseCreate.status='Open';
            caseCreate.IsAccountWebform__c=true;
            caseCreate.RecordtypeId=label.Account_WebForm_Creation_RecordType;
            caseCreate.Export_Compliance_Content_ITAR_EAR__c='No';
            caseCreate.Government_Compliance_SM_M_Content__c='No';
            caseCreate.subject=TypeofRequest;
            caseCreate.Change_Type__c=changetype;
            //caseCreate.Change_Description__c=ChangeDescription;
            caseCreate.Description=ChangeDescription;
            caseCreate.Account_Name_web__c= AccountNameweb;
            caseCreate.Company_Website_URL__c=CompanyWebsiteURL;
            caseCreate.Address_Line_1__c=AddressLine1;
            caseCreate.Account_Primary_Phone_Number__c=AccountPrimaryPhoneNumber;
            caseCreate.Address_Line_2__c=AddressLine2;
            caseCreate.Account_Fax_Number__c=AccountFaxNumber;
            caseCreate.Address_Line_3__c=AddressLine3;
            caseCreate.Country_Name__c=CountryName;
            caseCreate.City_Name__c=CityName;
            caseCreate.State_Code__c=StateCode;
            caseCreate.Postal_Code__c=PostalCode;
           caseCreate.Market_1__c=accounts1.Market_Name__c;
             caseCreate.CBT_Directorate_1__c=accounts1.CBT_Directorate__c;
             caseCreate.CBT_Team_1__c=accounts1.CBT_Team__c;
             caseCreate.CBT_1__c=accounts1.CBT__c;
             caseCreate.SBU_1__c=accounts1.Strategic_Business_Unit__c;
             system.debug('ggggg'+caseCreate.SBU_1__c);
            if(casecreated==false)
            insert caseCreate;
            if(casecreated==true)
            update caseCreate;

       // }
       // catch(Exception e){
       // system.debug('$$$$$$$$$$$$$$$$'+e);
       // }
 //PageReference pageRef = new PageReference('https://c.na1.visual.force.com/apex/ThankYouPage');
 PageReference pageRef = new PageReference('/apex/ThankYouPage');
       // PageReference pageRef = new PageReference('https://c.cs0.visual.force.com/apex/ThankYouPage');
        return pageRef ;
    }
}// end of Class