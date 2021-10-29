/*******************************************************************************
Name            :   USERDATASFDCTOSITECORE
Created By      :   Venkatesh A 
Company Name    :   NTT Data
Project         :   ADE
Created Date    :   28-August-2015
Usages          :   Creating Case based on SAP and sending response as Case Number 
Modification History  :
Date        Version No.     Modified by         Brief Description of Modification
05-Jun-17   0.17            Harikishore         INC000011969245 -Added Contact Status condition to retrieve 
                                                only Active contacts information
*******************************************************************************/
global class UserDatasitecoretoSFDC{
    global class UserData{
        webservice string Useremail;
    }
     
    global class UserDataSFDCtoSitecore{
        webservice List<UserListDetails> Userdetailslst;
        webservice string message;
    } 
    global class UserListDetails{
        webservice string Email;
        webservice string Honeywellid; 
        webservice string FullName;
        webservice string Company;    
        webservice string StreetAddress;
        webservice string StreetAddress2;
        webservice string Roles;
        webservice string SblRoles;
        webservice string ContactRecordType;
        webservice string City;
        webservice string State;
        webservice string Zip;
        webservice string Country;
        webservice string Phone;
        webservice string JobTitle;
    }  
    webservice static UserDataSFDCtoSitecore Userdetails(UserData us){
        
        UserDataSFDCtoSitecore user= new UserDataSFDCtoSitecore();
        //List<UserDataSFDCtoSitecore.UserListDetails> Userdetailslst1 = new List<UserDataSFDCtoSitecore.UserListDetails>();        
        String useremaailslst= us.Useremail;
        String[] useremails = useremaailslst.split(',');
        if(us.UserEmail != null)
        {
            system.debug('us.UserEmail----'+us.UserEmail);
            List<contact> con =new List<contact>();
            List<Account_Contact__c> relatedAcc = new List<Account_Contact__c>();
            // Added Contact Status condition to retrieve only Active Contact record for INC000011969245
            con = [select Id,name, EMAIL,Contact_Status__c, AccountID,FirstName, LastName, Portal_Company_Name__c,Address_Line_1__c,Address_Line_2__c,Honeywell_ID__c,City_Name__c,State_Code__c,Country_Name__c,Postal_Code__c,Phone_1__c,Job_Title__c,RecordType.name,Account.Portal_Permissioned_Content__c,Account.Sbl_Account_Row_Id__c,(select id,Sbl_Account_Row_ID__c,Contact__c from Contact.Account_Contacts1__r) from contact where Honeywell_ID__c  IN: useremails and Contact_Status__c='Active'];
            system.debug('con'+con);
            if(con.size()>0 )
            {               
                
                integer consize=con.size();
                List<UserDatasitecoretoSFDC.UserListDetails> reslst = new List< UserDatasitecoretoSFDC.UserListDetails>();
                for(contact c:con)
                {
                    
                    UserListDetails res = new UserListDetails();
                    string Sblroles1='';
                    res.FullName = c.name;
                    res.Email = c.EMAIL;
                    res.HoneywellID = c.Honeywell_ID__c;
                    res.StreetAddress = c.Address_Line_1__c;
                    res.StreetAddress2 = c.Address_Line_2__c;
                    res.Company = c.Portal_Company_Name__c;
                    res.Roles = c.Account.Portal_Permissioned_Content__c;
                    List<Account_Contact__c> accont = new List<Account_Contact__c>();
                    system.debug('account contact size'+c.Account_Contacts1__r.size());
                    if(c.Account_Contacts1__r!=null && c.Account_Contacts1__r.size()>0)
                    {
                        relatedAcc = c.Account_Contacts1__r;
                    }
                    for(Account_Contact__c ac:relatedAcc)
                    {
                        system.debug('inside sbi row id');
                        if(ac.Sbl_Account_Row_ID__c != null)
                        Sblroles1 += ac.Sbl_Account_Row_ID__c+',';
                        //relatedAcc.add(accont.Sbl_Account_Row_ID__c);
                        // Sblroles1 = accont.Sbl_Account_Row_ID__c;
                    }
                    //Sblroles1 += c.Account.Sbl_Account_Row_Id__c;
                    Sblroles1 += c.Account.Sbl_Account_Row_Id__c;
                    // Sblroles1  = c.Sbl_Account_Row_ID__c;
                    res.SblRoles = Sblroles1;
                    res.ContactRecordType = c.RecordType.name;
                    res.City = c.City_Name__c;
                    res.State = c.State_Code__c;
                    res.Zip = c.Postal_Code__c;
                    res.Phone = c.Phone_1__c;
                    res.JobTitle = c.Job_Title__c;
                    res.Country = c.Country_Name__c;
                    reslst.add(res);                 
                }
                user.Userdetailslst= reslst;
                user.message = 'List of User Records'+consize;
            }
            else
            {
               // user.Userdetailslst= Userdetailslst1;
                user.message = 'No Records matching with this email address';
            }
        } 
         system.debug('User-------->'+user);
        return user;
       
    }
    
       
}