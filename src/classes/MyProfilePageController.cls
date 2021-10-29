public with sharing class MyProfilePageController {

    private User user;
    private contact con;
    public Web_Portal_Contact_Citizenship__c opp=new Web_Portal_Contact_Citizenship__c();
    private boolean isEdit = false;
    public string conemail;
    
    public MyProfilePageController() {
        user = [SELECT id, email,username, usertype, communitynickname, timezonesidkey, languagelocalekey, firstname, lastname, phone, title,
                street, city,name, country, postalcode,Federation_Formula__c, state, localesidkey, mobilephone, extension, fax, contact.email
                FROM User
                WHERE id = :UserInfo.getUserId()];
        // guest users should never be able to access this page
        
        con=[SELECT FirstName,LastName,Phone_1_Ext__c,Is_US_Citizen__c,Passport_Expiry_Date__c,Passport_Number__c,Dual_Citizenship_Country__c,
             Citizenship_Country__c,State_Code__c,Contact_Birth_Country__c,Job_Title__c,Phone_1__c,Phone_2__c,Phone_3__c,
             Country_Name__c,Company_Address__c,Phone,MobilePhone,Address_Line_1__c,Address_Line_2__c,Address_Line_3__c,Email,Birth_City__c,Market__c,AccountId,Visa_Type__c,Visa_Number__c,Visa_Expiry_Date__c,Primary_Email_Address__c,Customer_Portal_UserId__c,Postal_Code__c FROM Contact where Customer_Portal_UserId__c = :UserInfo.getUserId() and Honeywell_ID__c = :user.Federation_Formula__c limit 1];
          if(con != null)
          {              
            opp.First_Name__c=con.firstName;
            opp.Last_Name__c=con.lastname;           
            opp.Email__c=con.Email;
            opp.Company_E_Mail_Address__c=con.Email; 
            opp.Company_Name__c=con.AccountId;
            opp.Job_Title__c=user.title;            
            opp.Market__c=con.Market__c; 
            opp.Extension__c=con.Phone_1_Ext__c;                       
            opp.Alternate_Work_Number__c=con.Phone_2__c;
            opp.Fax_Number__c=user.fax;
            opp.Company_Address__c=con.Company_Address__c;
            opp.State_Code__c=con.State_Code__c;
            opp.Country_Name__c=con.Country_Name__c;
            opp.Postal_Code__c=con.Postal_Code__c;                                
            opp.Birth_city__c=con.Birth_City__c;                        
            opp.Contact_Birth_Country__c=con.Contact_Birth_Country__c;
            opp.Contact_Citizenship_Country__c=con.Citizenship_Country__c;
            opp.Contact_Citizenship_Country2__c=con.Dual_Citizenship_Country__c;
            opp.Is_US_Citizen__c=con.Is_US_Citizen__c;           
            opp.Passport_Number__c=con.Passport_Number__c;
            opp.Passport_Expiry_Date__c=con.Passport_Expiry_Date__c;
            opp.Visa_Type__c = con.Visa_Type__c;
            opp.Visa_Number__c=con.Visa_Number__c;
            opp.Visa_Expiry_Date__c=con.Visa_Expiry_Date__c;
            opp.Address_Line_1_c__c=con.Address_Line_1__c;
            opp.Address_Line_2__c=con.Address_Line_2__c;
            opp.Address_Line_3__c=con.Address_Line_3__c;

            user.MobilePhone=con.MobilePhone;           
         }       
        if (user.usertype == 'GUEST') 
        {
            throw new NoAccessException();
        }
    }
    public User getUser() 
    {
        return user;
    }
    public contact getcon() 
    {
        return con;        
    }
    public Web_Portal_Contact_Citizenship__c getopp() {
        return opp;        
    }
    public Boolean getIsEdit() {
        return isEdit;
    }
    
    public void edit() {
        isEdit=true;
    }       
    public pagereference save() 
    {        
        try {
            update user;            
            if (user.contact != null) 
            {              
                Updateopp(user);                             
            }  
            opp.Company_E_Mail_Address__c=opp.email__c; 
            opp.Phone_1_Ext__c=opp.Extension__c;
            upsert opp;                       
            isEdit=false;
            
        } catch(DmlException e) {
            ApexPages.addMessages(e);
        }
        //PageReference reference=new PageReference('https://c.na13.visual.force.com/apex/MyProfilePage');
        String strbaseURL = URL.getSalesforceBaseUrl().toExternalForm();
        System.debug('strbaseURL '+strbaseURL );
        PageReference reference=new PageReference(strbaseURL+'/apex/MyProfilePage');
            reference.setRedirect(true);
            return reference;
    }   
    public PageReference changePassword() 
    {
        return Page.ChangePassword;
    }   
    public void cancel() 
    {
        isEdit=false;
        user = [SELECT id, email, username, communitynickname, timezonesidkey, languagelocalekey, firstname, lastname, phone, title,
                street, city, country, postalcode, state, localesidkey, mobilephone, extension, fax, contact.email
                FROM User WHERE id = :UserInfo.getUserId()];
    }        
    public void Updateopp(User u)
    {   opp.First_Name__c=u.firstname;                     
        opp.Job_Title__c=u.Title;                                                     
        opp.Fax_Number__c=u.fax;            
        opp.City_Name__c=u.city;
        opp.State_Name__c=u.State;
        opp.Postal_Code__c=u.postalcode; 
        opp.Country_Name__c=u.country;
        opp.MobilePhone__c=u.mobilephone;
        opp.Primary_Work_Number__c=u.phone;     
           
    }
  
}