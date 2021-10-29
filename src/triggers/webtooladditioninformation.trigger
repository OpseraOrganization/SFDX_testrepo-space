trigger webtooladditioninformation on Web_Portal_Contact_Citizenship__c (after insert,after update){
    List<Web_Portal_Contact_Citizenship__c> wpcList = new List<Web_Portal_Contact_Citizenship__c>();
    List<Web_Portal_Contact_Citizenship__c> wpcList1= new List<Web_Portal_Contact_Citizenship__c>();
    wpcList = [Select id,Contact_Birth_Country__c,Passport_Expiry_Date__c from Web_Portal_Contact_Citizenship__c where createddate < today];
    String uid;
    set<Id> parentid = new set<Id>(); 
    if(wpcList.size()>0){
        for(Web_Portal_Contact_Citizenship__c wpc:wpcList){
            wpcList1.add(wpc);
        }
        if(wpcList1.size()>0)
        delete wpcList1;
    }
   
    for(Web_Portal_Contact_Citizenship__c wc: Trigger.New){ 
            uid = Userinfo.getuserid();
            //uid='005e0000000vEAoAAM';
            parentid.add(wc.id);
        }
        
        List<contact> lstcon=new List<contact>();
        List<User> use=new List<User>(); 
        List<User> use1=new List<User>();         
        List<user> usr=new List<user>(); 
        usr = [Select id,UserRoleId,firstname,lastname,CompanyName,title,phone,city,state,country,postalcode,Email,MobilePhone,fax,Extension,Federation_Formula__c  from User where id =: uid];       
        system.debug('user test'+usr);
        user user3=[select id,name,Federation_Formula__c  from user where id =: uid limit 1];
        List<contact> contactUpdate=new List<contact>();        
        contactUpdate =[SELECT FirstName,LastName,Postal_Code__c,Address_Line_1__c,Address_Line_2__c,Address_Line_3__c,AccountId,Web_Portal_Company_Name__c,Phone_1_Ext__c,Visa_Type__c,Visa_Number__c,Visa_Expiry_Date__c,Country_Name__c,State_Code__c,Company_Address__c,Phone_1__c,Company_E_Mail_Address__c,Email,City_Name__c,Passport_Number__c,Passport_Expiry_Date__c,Is_US_Citizen__c,Primary_Email_Address__c,Contact_Birth_Country__c,Citizenship_Country__c,Dual_Citizenship_Country__c,MobilePhone,Customer_Portal_UserId__c,Honeywell_ID__c  FROM Contact WHERE Customer_Portal_UserId__c = :uid and Honeywell_ID__c = :user3.Federation_Formula__c  limit 1];
         
        Web_Portal_Contact_Citizenship__c c=[select id,name,First_Name__c,Last_Name__c,Email_Address__c,Company_Name__c,Job_Title__c,City_Name__c,Company_E_Mail_Address__c,
                                              Primary_Work_Number__c,Alternate_Work_Number__c,Fax_Number__c,Market__c,State_Code__c,Phone_1_Ext__c,MobilePhone__c,Country_Name__c,
                                              Postal_Code__c,Birth_city__c,Contact_Birth_Country__c,Contact_Citizenship_Country__c,Contact_Citizenship_Country2__c,Is_US_Citizen__c,Passport_Number__c,Passport_Expiry_Date__c,
                                              Visa_Type__c,Visa_Number__c,Visa_Expiry_Date__c,Do_you_own_Operate_or_Maintain_Honeywell__c,Address_Line_1_c__c,Address_Line_2__c,Address_Line_3__c,Web_Additional_form_flag__c from Web_Portal_Contact_Citizenship__c where id=:parentid
                                            ]; 
        if(contactUpdate.size()>0)
        {
            system.debug('----test---->'+contactUpdate);
            for(contact con:contactUpdate){                
                con.FirstName=c.First_Name__c;
                con.LastName=c.Last_Name__c;          
                con.Alternate_Email_Address__c=c.Email_Address__c;
                con.AccountId=c.Company_Name__c;
                con.Job_Title__c=c.Job_Title__c;
                con.City_Name__c=c.City_Name__c;
                con.Email=c.Company_E_Mail_Address__c;
                //con.Primary_Email_Address__c=c.Company_E_Mail_Address__c;            
                con.Phone_1__c=c.Primary_Work_Number__c;
                con.Phone_2__c=c.Alternate_Work_Number__c;
                con.Phone_3__c=c.Fax_Number__c;
                con.Market__c=c.Market__c;           
                con.State_Code__c=c.State_Code__c;           
                con.Phone_1_Ext__c=c.Phone_1_Ext__c;
                con.MobilePhone=c.MobilePhone__c;
                con.Country_Name__c=c.Country_Name__c;
                con.Postal_Code__c=c.Postal_Code__c;                                
                con.Birth_City__c=c.Birth_city__c;                           
                con.Contact_Birth_Country__c=c.Contact_Birth_Country__c;
                con.Citizenship_Country__c=c.Contact_Citizenship_Country__c;
                con.Dual_Citizenship_Country__c=c.Contact_Citizenship_Country2__c;
                con.Is_US_Citizen__c=c.Is_US_Citizen__c;           
                con.Passport_Number__c=c.Passport_Number__c;
                con.Passport_Expiry_Date__c=c.Passport_Expiry_Date__c;
                con.Visa_Type__c = c.Visa_Type__c;
                con.Visa_Number__c=c.Visa_Number__c;
                con.Visa_Expiry_Date__c=c.Visa_Expiry_Date__c;
                con.Address_Line_1__c=c.Address_Line_1_c__c;
                con.Address_Line_2__c=c.Address_Line_2__c;
                con.Address_Line_3__c=c.Address_Line_3__c;
                con.Do_you_own_Operate_or_Maintain_Honeywell__c=c.Do_you_own_Operate_or_Maintain_Honeywell__c;          
                 if(c.Web_Additional_form_flag__c == True)
                {
                con.Additional_form_flag__c= True;
                con.Additional_form_fill_date__c = system.today();  
                } 
                lstcon.add(con);
                system.debug('test222'+lstcon);
                if(lstcon.size()>0)
                {       
                update lstcon;
                system.debug('test3333'+lstcon);
                }  
            } 
            for(contact con1:contactUpdate)
            {
                if(con1.AccountId != c.Company_Name__c)
                {
                    for(user u:usr){
                        u.firstname = c.First_Name__c;
                        u.lastname=c.Last_Name__c;
                        u.email=c.Company_E_Mail_Address__c;                        
                        u.title = c.Job_Title__c;                               
                        u.phone = c.Primary_Work_Number__c;
                        u.Extension = c.Phone_1_Ext__c; 
                        u.MobilePhone = c.MobilePhone__c; 
                        u.fax = c.Fax_Number__c; 
                        u.postalcode = c.Postal_Code__c; 
                        u.city = c.City_Name__c;
                        u.state = c.State_Name__c;              
                        u.country = c.Country_Name__c;
                        use.add(u);
                    }
                    if(use.size()>0)
                    {
                        update use;
                    }
                }               
            }       
        }                           
}