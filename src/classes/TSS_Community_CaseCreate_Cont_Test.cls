@isTest(seeAllData=true)
public class TSS_Community_CaseCreate_Cont_Test {
    static testMethod void TSSCaseCreateTest1(){
        test.startTest();
        
        Profile p = [select id from profile where name ='Overage Authenticated Website User' limit 1];
        system.debug('>>>>>>>>>>>>>>>>>>>>>>p<<<<<<<<<<<<<<<'+p);
        
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'ATR';
        acc.CBT__c = 'Airbus';
        acc.Region_Name__c = 'Americas';
        acc.Sub_Region_Name__c = 'Canada';
        acc.Service_Level__c = 'Standard';
        acc.Type = 'OEM';
        acc.REPORT_ACCOUNT_NAME__c = 'Test Account';
        acc.Market_Name__c = 'Marine';
        insert acc;
        system.debug('>>>>>acc Sumit>>>>'+acc);
        
        Contact con = new Contact();
        con.LastName = 'Gupta';
        con.FirstName = 'Sumit';
        con.AccountId = acc.Id;
        con.Primary_Email_Address__c = 'sumit13.gupta@nttdata.com';
        con.Email='sumit13.gupta@nttdata.com';
        insert con;
        system.debug('>>>>>con Sumit>>>>'+con);
               
        //For Line 34
        User usr = new User();
        usr.alias = 'Sumit';
        usr.email = 'sumit@test.com';
        usr.emailencodingkey='UTF-8';
        usr.lastname='G';
        usr.languagelocalekey='en_US';
        usr.localesidkey='en_US';
        usr.profileid = p.Id;
        usr.timezonesidkey='America/Los_Angeles';
        usr.username='standarduser@testing.com';
        usr.isactive=true;
        usr.contactId=con.Id;
        insert usr;
        
        User usr1 = new User();
        usr1.alias = 'Sumit1';
        usr1.email = 'sumit1@test.com';
        usr1.emailencodingkey='UTF-8';
        usr1.lastname='G';
        usr1.languagelocalekey='en_US';
        usr1.localesidkey='en_US';
        usr1.profileid = Label.Hon_System_Admin_Profile_Id;
        usr1.timezonesidkey='America/Los_Angeles';
        usr1.username='standarduser2@testing.com';
        usr1.isactive=true;
        insert usr1;
        system.debug('>>>>>>>>>>>>usr<<<<<<<<<<<'+usr);
        
        Platform__c ptform = new Platform__c ();
        ptform.Name = 'ACCELEROMETER';
        insert ptform;
        
        TSS_Community_CaseCreate_Cont tsc = new TSS_Community_CaseCreate_Cont();
        
        Supported_Products__c sp=new Supported_Products__c();
        sp.Name='test sp Name';
        sp.Product_Type__c='Electrical';// Line 56
        insert sp;
            system.debug('<<<<<<<<<<<<<sp>>>>>>>>>>'+sp);        
               
        String a = string.valueof(sp.Id);
        tsc.Product_TypeId_var=a;// line 52
        String b = 'test Part number';
        tsc.Part_Number_var=b;// Line 75
        String c = 'test subject id';
        tsc.Subject_Id_var=c;// Line 78
        String d = 'test description';
        tsc.Description_Id_var=d;// Line 81
        String e = 'test inquiry';
        tsc.Inquiry_Type_Details_var=e;// Line 113
        //String f =  + '';
        tsc.Aircraft_TypeId_var= ptform.id;// Line 114
        String g = 'test ATA Chapter';
        tsc.ATA_Chapter_var=g;// Line 117
        
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        tsc.Case_Attachment= new Attachment(Name='test attachment name',ParentId=acc.id, body=bodyBlob);// Line 123
        //insert tsc.Case_Attachment;
        system.debug('<<<<<<<<<<<<<tsc.Case_Attachment>>>>>>>>>>'+tsc.Case_Attachment);
                
        TSS_Community_CaseCreate_Cont.GetInquiryTypeVal();// Line 142
        TSS_Community_CaseCreate_Cont.GetInquiryDetails();// Line 167
        TSS_Community_CaseCreate_Cont.SearchAircraft('BAe Hawk');// Line 193
        TSS_Community_CaseCreate_Cont.SearchProduct('ALF502 Engine');// Line 200
        TSS_Community_CaseCreate_Cont.GetATA_Chapter();// Line 208
        
        AccountTeamMember atm = new AccountTeamMember(userId=usr1.id, AccountId=acc.Id, TeamMemberRole='Field Service Engineer (FSE) - Mech');
        insert atm;
        System.debug('<<<<ATM>>>>'+atm);
        //tsc.CreateCase();
        system.runAs(usr){
            try{
                tsc.CreateCase(); // Line 19
                system.debug('WWWWWWWWWWWWWWWWWWWWWWWWWWWWW'+tsc);
            }catch(Exception ex){
                system.debug('>>>>>ex<<<<<'+ex);
            }
            //Supported_Products__c sp1 =[SELECT Id,Name,Product_Type__c,Status__c FROM Supported_Products__c WHERE id =: sp.Id LIMIT 1];
            //system.debug('>>>>>sp1<<<<<'+sp1);
        }
        test.stopTest();
    }
    
    /***************************************Test Method2******************************************/
    static testMethod void TSSCaseCreateTest2(){
        test.startTest();
        
        Profile p = [select id from profile where name ='Overage Authenticated Website User' limit 1];
        system.debug('>>>>>>>>>>>>>>>>>>>>>>p<<<<<<<<<<<<<<<'+p);
        
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'ATR';
        acc.CBT__c = 'Airbus';
        acc.Region_Name__c = 'Americas';
        acc.Sub_Region_Name__c = 'Canada';
        acc.Service_Level__c = 'Standard';
        acc.Type = 'OEM';
        acc.REPORT_ACCOUNT_NAME__c = 'Test Account';
        acc.Market_Name__c = 'Marine';
        insert acc;
        system.debug('>>>>>acc Sumit>>>>'+acc);
        
        Contact con = new Contact();
        con.LastName = 'Gupta';
        con.FirstName = 'Sumit';
        con.AccountId = acc.Id;
        con.Primary_Email_Address__c = 'sumit13.gupta@nttdata.com';
        con.Email='sumit13.gupta@nttdata.com';
        insert con;
        system.debug('>>>>>con Sumit>>>>'+con);
               
        //For Line 34
        User usr = new User();
        usr.alias = 'Sumit';
        usr.email = 'sumit@test.com';
        usr.emailencodingkey='UTF-8';
        usr.lastname='G';
        usr.languagelocalekey='en_US';
        usr.localesidkey='en_US';
        usr.profileid = p.Id;
        usr.timezonesidkey='America/Los_Angeles';
        usr.username='standarduser@testing.com';
        usr.isactive=true;
        usr.contactId=con.Id;
        insert usr;
        
        User usr1 = new User();
        usr1.alias = 'Sumit1';
        usr1.email = 'sumit1@test.com';
        usr1.emailencodingkey='UTF-8';
        usr1.lastname='G';
        usr1.languagelocalekey='en_US';
        usr1.localesidkey='en_US';
        usr1.profileid = Label.Hon_System_Admin_Profile_Id;
        usr1.timezonesidkey='America/Los_Angeles';
        usr1.username='standarduser2@testing.com';
        usr1.isactive=true;
        insert usr1;
        system.debug('>>>>>>>>>>>>usr<<<<<<<<<<<'+usr);
        
        Platform__c ptform = new Platform__c ();
        ptform.Name = 'ACCELEROMETER';
        insert ptform;
        
        TSS_Community_CaseCreate_Cont tsc = new TSS_Community_CaseCreate_Cont();
        
        Supported_Products__c sp=new Supported_Products__c();
        sp.Name='test sp Name';
        sp.Product_Type__c='Mechanical';// Line 56
        insert sp;
            system.debug('<<<<<<<<<<<<<sp>>>>>>>>>>'+sp);        
               
        String a = string.valueof(sp.Id);
        tsc.Product_TypeId_var=a;// line 52
        String b = 'test Part number';
        tsc.Part_Number_var=b;// Line 75
        String c = 'test subject id';
        tsc.Subject_Id_var=c;// Line 78
        String d = 'test description';
        tsc.Description_Id_var=d;// Line 81
        String e = 'test inquiry';
        tsc.Inquiry_Type_Details_var=e;// Line 113
        //String f =  + '';
        tsc.Aircraft_TypeId_var= ptform.id;// Line 114
        String g = 'test ATA Chapter';
        tsc.ATA_Chapter_var=g;// Line 117
        
        //Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        //tsc.Case_Attachment= new Attachment(Name='test attachment name',ParentId=acc.id, body=bodyBlob);// Line 123
        //insert tsc.Case_Attachment;
        //system.debug('<<<<<<<<<<<<<tsc.Case_Attachment>>>>>>>>>>'+tsc.Case_Attachment);
                
        TSS_Community_CaseCreate_Cont.GetInquiryTypeVal();// Line 142
        TSS_Community_CaseCreate_Cont.GetInquiryDetails();// Line 167
        TSS_Community_CaseCreate_Cont.SearchAircraft('BAe Hawk');// Line 193
        TSS_Community_CaseCreate_Cont.SearchProduct('ALF502 Engine');// Line 200
        TSS_Community_CaseCreate_Cont.GetATA_Chapter();// Line 208
        
        AccountTeamMember atm = new AccountTeamMember(userId=usr1.id, AccountId=acc.Id, TeamMemberRole='Field Service Engineer (FSE) - Mech');
        insert atm;
        System.debug('<<<<ATM>>>>'+atm);
        //tsc.CreateCase();
        system.runAs(usr){
            try{
                tsc.CreateCase(); // Line 19
                system.debug('WWWWWWWWWWWWWWWWWWWWWWWWWWWWW'+tsc);
            }catch(Exception ex){
                system.debug('>>>>>ex<<<<<'+ex);
            }
            //Supported_Products__c sp1 =[SELECT Id,Name,Product_Type__c,Status__c FROM Supported_Products__c WHERE id =: sp.Id LIMIT 1];
            //system.debug('>>>>>sp1<<<<<'+sp1);
        }
        test.stopTest();
    } 
    
    /***************************************Test Method2******************************************/
    static testMethod void TSSCaseCreateTest3(){
        test.startTest();
        
        Profile p = [select id from profile where name ='Overage Authenticated Website User' limit 1];
        system.debug('>>>>>>>>>>>>>>>>>>>>>>p<<<<<<<<<<<<<<<'+p);
        
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'ATR';
        acc.CBT__c = 'Airbus';
        acc.Region_Name__c = 'Americas';
        acc.Sub_Region_Name__c = 'Canada';
        acc.Service_Level__c = 'Standard';
        acc.Type = 'OEM';
        acc.REPORT_ACCOUNT_NAME__c = 'Test Account';
        acc.Market_Name__c = 'Marine';
        insert acc;
        system.debug('>>>>>acc Sumit>>>>'+acc);
        
        Contact con = new Contact();
        con.LastName = 'Gupta';
        con.FirstName = 'Sumit';
        con.AccountId = acc.Id;
        con.Primary_Email_Address__c = 'sumit13.gupta@nttdata.com';
        con.Email='sumit13.gupta@nttdata.com';
        insert con;
        system.debug('>>>>>con Sumit>>>>'+con);
               
        //For Line 34
        User usr = new User();
        usr.alias = 'Sumit';
        usr.email = 'sumit@test.com';
        usr.emailencodingkey='UTF-8';
        usr.lastname='G';
        usr.languagelocalekey='en_US';
        usr.localesidkey='en_US';
        usr.profileid = p.Id;
        usr.timezonesidkey='America/Los_Angeles';
        usr.username='standarduser@testing.com';
        usr.isactive=true;
        usr.contactId=con.Id;
        insert usr;
        
        User usr1 = new User();
        usr1.alias = 'Sumit1';
        usr1.email = 'sumit1@test.com';
        usr1.emailencodingkey='UTF-8';
        usr1.lastname='G';
        usr1.languagelocalekey='en_US';
        usr1.localesidkey='en_US';
        usr1.profileid = Label.Hon_System_Admin_Profile_Id;
        usr1.timezonesidkey='America/Los_Angeles';
        usr1.username='standarduser2@testing.com';
        usr1.isactive=true;
        insert usr1;
        system.debug('>>>>>>>>>>>>usr<<<<<<<<<<<'+usr);
        
        Platform__c ptform = new Platform__c ();
        ptform.Name = 'ACCELEROMETER';
        insert ptform;
        
        TSS_Community_CaseCreate_Cont tsc = new TSS_Community_CaseCreate_Cont();
        
        Supported_Products__c sp=new Supported_Products__c();
        sp.Name='test sp Name';
        sp.Product_Type__c='Mec';// Line 56
        insert sp;
            system.debug('<<<<<<<<<<<<<sp>>>>>>>>>>'+sp);        
               
        String a = string.valueof(sp.Id);
        tsc.Product_TypeId_var=a;// line 52
        String b = 'test Part number';
        tsc.Part_Number_var=b;// Line 75
        String c = 'test subject id';
        tsc.Subject_Id_var=c;// Line 78
        String d = 'test description';
        tsc.Description_Id_var=d;// Line 81
        String e = 'test inquiry';
        tsc.Inquiry_Type_Details_var=e;// Line 113
        //String f =  + '';
        tsc.Aircraft_TypeId_var= ptform.id;// Line 114
        String g = 'test ATA Chapter';
        tsc.ATA_Chapter_var=g;// Line 117
        
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        tsc.Case_Attachment= new Attachment(Name='test attachment name',ParentId=acc.id, body=bodyBlob);// Line 123
        insert tsc.Case_Attachment;
        //system.debug('<<<<<<<<<<<<<tsc.Case_Attachment>>>>>>>>>>'+tsc.Case_Attachment);
                
        TSS_Community_CaseCreate_Cont.GetInquiryTypeVal();// Line 142
        TSS_Community_CaseCreate_Cont.GetInquiryDetails();// Line 167
        TSS_Community_CaseCreate_Cont.SearchAircraft('BAe Hawk');// Line 193
        TSS_Community_CaseCreate_Cont.SearchProduct('ALF502 Engine');// Line 200
        TSS_Community_CaseCreate_Cont.GetATA_Chapter();// Line 208
        
        AccountTeamMember atm = new AccountTeamMember(userId=usr1.id, AccountId=acc.Id, TeamMemberRole='Field Service Engineer (FSE) - Mech');
        insert atm;
        System.debug('<<<<ATM>>>>'+atm);
        //tsc.CreateCase();
        system.runAs(usr){
            try{
                tsc.CreateCase(); // Line 19
                system.debug('WWWWWWWWWWWWWWWWWWWWWWWWWWWWW'+tsc);
            }catch(Exception ex){
                system.debug('>>>>>ex<<<<<'+ex);
            }
            //Supported_Products__c sp1 =[SELECT Id,Name,Product_Type__c,Status__c FROM Supported_Products__c WHERE id =: sp.Id LIMIT 1];
            //system.debug('>>>>>sp1<<<<<'+sp1);
        }
        test.stopTest();
    } 
}