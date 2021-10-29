@isTest
public class bundle_Account_Update_Test{

    static testmethod void method1()
     
    {
        User usr =[select id,name,Primary_Manager_Name__c,Primary_Manager_EID__c from user where profile.name = 'System Administrator' and isactive = true order by createddate asc limit 1];
        system.runAs(usr)
        {
        Account acc=new Account(name='NTT Offshore Test Account');
        insert acc;
        Contact objContact1 = new Contact(FirstName = 'Barb', LastName = 'Ciani', AccountId = acc.Id, Employee_Number__c = '123' );
        insert objContact1;
        Contact objContact2 = new Contact(FirstName = 'test', LastName = 'name', AccountId = acc.Id, Employee_Number__c = '456' );
        insert objContact2;
        Contact objContact = new Contact(FirstName = 'test1', LastName = 'name1', AccountId = acc.Id, Employee_Manager_Name__c = objContact1.Id);
        insert objContact;      
        Account_Focal__c afc = new Account_Focal__c(Account__c = acc.id, Default__c = false, Customer_Support_Focal__c=objContact.Id, Sold_To__c='123', BusinessFocal__c=objContact1.Id, Customer_Business_Manager_CBM__c=usr.id, Customer_Support_Manager_CSM__c= usr.id, Customer_Support_Project_Manager_CSPM__c =usr.id, Area_Sales_Manager_ASM__c = usr.Id);
        if(afc.Sold_To__c  != NULL && afc.Sold_To__c.length() < 10 )
            {
                Integer i = afc.Sold_To__c.length();
                i = 10 - i;
                String temp ='';
                for (Integer j = 0; j < i; j++ )
                {
                    temp += '0';
                }
                afc.Sold_To__c = temp+afc.Sold_To__c;   
            }           
            if(afc.Customer_Support_Focal__c != null){
            afc.Customer_Support_Focal__c = objContact.Id ;
            }
            if(afc.BusinessFocal__c != null){
            afc.BusinessFocal__c = objContact1.Id;
            }        
        Contact con = [SELECT Id, Name,Employee_Manager_Name__c FROM Contact limit 1];        
            if(con.Employee_Manager_Name__c != null){
            con.Id = '';
            con.Employee_Manager_Name__c = '';
            }                 
            if(afc.Customer_Support_Focal__c != null){
            afc.Customer_Support_Escalation__c = afc.Customer_Support_Focal__c;
            }
            if(afc.BusinessFocal__c != null){
            afc.Business_Escalation__c = afc.BusinessFocal__c;
            }                     
           Account UpdateAccount = new Account();                                  
           if((afc.Customer_Support_Focal__c != null) && (afc.Default__c == true))
            {
                 if(afc.Account__c != null)
                {                   
                    UpdateAccount.Customer_Support_Focal__c = afc.Customer_Support_Focal__c;
                    UpdateAccount.Customer_Support_Escalation__c = afc.Customer_Support_Escalation__c;
                } 
            }
            if((afc.BusinessFocal__c != null) && (afc.Default__c == true)){
                if(afc.Account__c != null)
                {
                    UpdateAccount.Business_Focal__c = afc.BusinessFocal__c;
                    UpdateAccount.Business_Escalation__c = afc.Business_Escalation__c;
                } 
            }
            if(afc.id != null ){
                afc.Default__c = true;
                afc.Account__c = acc.id;
            }
            insert afc;     
            if(afc.Customer_Support_Manager_CSM__c != NULL)
            {
                AccountTeamMember aTM = new AccountTeamMember();
                aTM.AccountId = afc.Account__c;
                aTM.UserId = afc.Customer_Support_Manager_CSM__c;
                aTM.TeamMemberRole = 'Customer Support Manager (CSM)';
                insert aTM;
            }
            if(afc.Customer_Support_Project_Manager_CSPM__c != NULL)
            {
                AccountTeamMember aTM = new  AccountTeamMember();
                aTM.AccountId = afc.Account__c;
                aTM.UserId = afc.Customer_Support_Project_Manager_CSPM__c ;
                aTM.TeamMemberRole = 'Customer Service Project Manager (CSPM)';
               insert aTM;
            }
            if(afc.Customer_Business_Manager_CBM__c != NULL)
            {
                AccountTeamMember aTM = new AccountTeamMember();
                aTM.AccountId = afc.Account__c;
                aTM.UserId = afc.Customer_Business_Manager_CBM__c ;
                aTM.TeamMemberRole = 'Customer Business Manager (CBM)';
               insert aTM;
            }
            if(afc.Area_Sales_Manager_ASM__c != NULL)
            {
                AccountTeamMember aTM = new AccountTeamMember();
                aTM.AccountId = afc.Account__c;
                aTM.UserId = afc.Area_Sales_Manager_ASM__c ;
                aTM.TeamMemberRole = 'Area Sales Manager (ASM)';
              insert aTM;  
            }        
          update afc; 
        }            
    }   
}