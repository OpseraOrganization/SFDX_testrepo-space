@isTest(seeAllData=true)
public class SSCommunityCases_Test {
    
    static testMethod void testCommented(){
        Test.StartTest();
        //The object name below has to match up with your trigger/class
        SSCommunityCases_Cntrl obj = new SSCommunityCases_Cntrl();
        //This one link is asserting that you successfully created it
        system.assertNotEquals(null,obj);   
        Test.StopTest();
    }
  /*  static testMethod void testSSCommunityCases1(){
        
        
        SSCommunityCases_Cntrl sc = new SSCommunityCases_Cntrl();
        
        Test.startTest(); 
         Profile p1 = [SELECT Id FROM Profile WHERE Name ='System Administrator'];
        User testUser = (User)SObjectFactory.create(User.sObjectType,new Map<Schema.SObjectField, Object>
                {
                    User.FirstName => 'TestFirstName',
                    User.LastName => 'TestLastName',
                    User.Email => 'test@in.ibm.com',
                    User.Username => 'testm@in.ibm.com.sstesssss',
                    User.Alias => 'TestF',
                    User.ProfileId => p1.Id,
                    User.TimeZoneSidKey => 'America/Denver',
                    User.LocaleSidKey => 'en_US',
                    User.EmailEncodingKey => 'UTF-8',
                    User.LanguageLocaleKey => 'en_US'
                });
             user currentUser = (User) SObjectFactory.create(
            User.SObjectType,
            new Map<SObjectField, Object>{
                User.Alias => 'wvarg',
                User.Email => 'testtest=honeywell.com@example.com',
                User.EmailEncodingKey => 'UTF-8',
                User.LastName => 'Customer Master',
                User.FirstName=>'Salesforce',    
                User.LanguageLocaleKey => 'en_US',
                User.LocalesIdKey => 'en_US',
                User.ProfileId => UserInfo.getProfileId(),
                User.TimezonesIdKey => 'America/Los_Angeles',
                //User.Username => 'wilnellies.vargas@honeywell.com'
                User.Username => 'testtest@honeywell.com.sstesssss'
            }
        );     
    account objAccount= (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
            account.OwnerId => UserInfo.getUserId(),
            account.Name => 'Test Account2',
            account.type => 'Energy',
            account.Strategic_Business_Unit__c => 'D&S',
            account.Service_Level__c => 'Unauthorized Dist/Brkr',
            account.Do_Not_Send_to_Portal__c => false,
            
            Account.PFECN__c => null,
            account.Region_Name__c => 'Asia/Pacific Rim'         
            });
     contact objContact= (contact)SObjectFactory.create(
            contact.sObjectType, new Map<Schema.SObjectField, Object>
            {
            contact.OwnerId => UserInfo.getUserId(),
            contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
            contact.AccountId => objAccount.Id,
            contact.fax_web__C => '4343434343',
            contact.Email=>'test@in.ibm.com'
            }); 
         User runUser = [Select id From User Where Username =: 'testm@in.ibm.com.sstesssss' Limit 1];
        System.runAs(runUser ){ 
      TriggerInactive.testTrigger = false;
      //data create
      Contact cont;
      cont = [SELECT Id FROM Contact where email='test@in.ibm.com'];
      Account acc;
      acc = [SELECT Id FROM Account WHERE  Name ='Test Account2' LIMIT 1];
      List<Case> caseList = new List<case>();  
        case Cas1 = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
            Case.OwnerId => UserInfo.getUserId(),
            Case.Type => 'CPS BGA Process', 
            Case.Subject => 'Test',
            Case.Status=>'On Hold',
            Case.Sub_Status__c => 'Accts',
            Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('General','Case').Id,
            Case.SuppliedEmail => 'Test@gulfstream.com',
            Case.Origin => 'Email-AOG',
            Case.AccountId=> acc.Id,
            Case.ContactId=> cont.Id,
            Case.NSN__c => 'Test;NSN', 
            Case.Part_Number__c => 'Test;Part',
            Case.AOG__c=> False      
        });
        Service_Request__c sr = new Service_Request__c();
        sr.subject__c ='test';
       // sr.Customer_Due_Date_BGA_S__c = system.today();
        sr.Function_Responsible__c = 'Support & Services';
        sr.Issue_Type__c = 'Technical';
        sr.SR_type__c = 'Technical Issue';
        sr.Customer_Due_Date__c = Date.today();
        insert sr;
        
       // String sortVar = Date.today().format()
        String sortVar = 'lastUpdated';
        Technical_Solutions__kav kavForId=[SELECT Id,Title,KnowledgeArticleId,Article_Details_del__c FROM Technical_Solutions__kav WHERE Language = 'en_US' AND PublishStatus = 'online' LIMIT 1];
        String stringKavForId = string.valueOf(kavForId.Id);      
        try{
        vote v=new vote();
        v.ParentId =kavForId.KnowledgeArticleId;
        v.type='2';
        //insert v;
        SSCommunityCases_Cntrl.RateArticleMethod(stringKavForId,v.type );
        
        sc.recordId=stringKavForId;// LINE 3
        }
        catch(Exception e)
        {
            System.assert(e.getMessage().contains('Invalid vote type'), 'message=' + e.getMessage());
        }
        // Line 6
        //sc.getRecordData();
        
        
         //Line 17
         list<string> flist = new list<string>();
         flist.add('All');
         list<case> lcas = new list<case>();
        lcas.add(Cas1);
         insert lcas;
        sc.CaseExportList = lcas;
       
         SSCommunityCases_Cntrl.getUserIsEmloyee();
         
         
        sc.GenerateReport();  
         
         //Line 8-18
         SSCommunityCases_Cntrl ctr = new SSCommunityCases_Cntrl();
         ctr.data = 'test';
         ctr.Inquiry_Type_Details_var = 'test';
         ctr.Aircraft_TypeId_var = 'test';
         ctr.ATA_Chapter_var = 'test';
         ctr.Product_TypeId_var = 'test';
         ctr.Part_Number_var = 'test';
         ctr.Subject_Id_var = 'test';
         ctr.Case_Attachment =[Select id from attachment limit 1];
         ctr.Description_Id_var = 'test';        
         ctr.AirId = 'test';
         ctr.CaseNumber = 'test';
            
         //Line 40
        
        Test.setCurrentPageReference(new pageReference('Page.TSSCommunityCases'));
        System.currentPageReference().getParameters().put('SelectedId', 'ka2m123ka2m');
        System.currentPageReference().getParameters().put('SelectedId', 'ka31123ka31');
        System.currentPageReference().getParameters().put('cka', '1234');
        
         //Line 733
         
         ctr.modelno = 'test';
         ctr.partno = 'test';
         ctr.articletitle = 'test';
         ctr.articledescription = 'test';
         ctr.kcssp = 'test';
         ctr.kcsas = 'test';
         ctr.kcsfde = 'test';
         ctr.kcsfm = 'test';
         ctr.kcspf = 'test';
         ctr.kcscause = 'test';
         ctr.kcsrl = 'test';
         ctr.kcsswv = 'test';
         

        //Line 109
        CaseComment casCom1 = new CaseComment();
        casCom1.CommentBody = 'Test Case Comment Body 1';
        casCom1.ParentId=Cas1.id;
        casCom1.isPublished=true;
        insert casCom1;
        
        // For Line 158
        List<sObject> r = new List<sObject>();
        Map<Id,integer> y = new Map<Id,integer>();
        Map<Id,datetime> z = new Map<Id,datetime>();
        Map<Id,List<String>> b = new Map<Id,List<String>>();
        Map<Id,List<String>> c = new Map<Id,List<String>>();
        Map<Id,List<datetime>> d = new Map<Id,List<datetime>>();
        datetime e = Date.today(); //system.today();
        Map<Id,decimal> f = new Map<Id,decimal>();
        string co;
        string ac;
        SSCommunityCases_Cntrl.CaseWithComments wrapClass1 = new SSCommunityCases_Cntrl.CaseWithComments(r,y,z,b,c,d,e,f,co,ac);
        
        // For Line 181 (Case Details).
        
        SSCommunityCases_Cntrl.SRDetails(sr.id);
        // Getting Id in String format from the inserted Case above
        String aCaseId=String.valueOf(Cas1.Id);
        system.debug('<<<acaseId>>>Sumit>>'+aCaseId);
        system.debug('<<<cas.Id>>>Sumit >>'+Cas1.Id);
        // For Line 198 
        SSCommunityCases_Cntrl.AddComments(aCaseId,'lastUpdated');
        
                
              SSCommunityCases_Cntrl.CaseDetails(Cas1.id);
            
         
        Test.stopTest();
    }
   }
    static testMethod void testSSCommunityCases2(){
        Test.startTest();
        SSCommunityCases_Cntrl sc = new SSCommunityCases_Cntrl();
            Knowledge_Article__kav kavForId=[SELECT Id,Title,ArticleNumber,KnowledgeArticleId FROM Knowledge_Article__kav WHERE Language = 'en_US' AND PublishStatus = 'online' LIMIT 1];
            
            String stringKavForId = string.valueOf(kavForId.Id);
            
            
            SSCommunityCases_Cntrl.GetKnowledgedetails(stringKavForId);
            SSCommunityCases_Cntrl.GetKnowledgedetails1(kavForId.KnowledgeArticleId);
            SSCommunityCases_Cntrl.getUserIsEmloyee();
        String sortVar = 'lastUpdated';
        // For Line 214 (rate Article Method)
        // Rate Value is less than 3 to comply with the condition of Email.
        //SSCommunityCases_Cntrl.RateArticleMethod(stringKavForId,'2');
        
        // For Line 239 (Retrieve User's article rating)
        SSCommunityCases_Cntrl.RateArticleRetrieveMethod(stringKavForId);
        
        // For Line 251 (Get Article Average rating)
        SSCommunityCases_Cntrl.ArticleVoteStat(stringKavForId);
        

        Map<Id,String> cc = new Map<Id,String>();
        /////SSCommunityCases_Cntrl.LandingCaseWithComments wrapClass2 = new SSCommunityCases_Cntrl.LandingCaseWithComments(x,e,cc);
        
        // For Line 397 (Returns details of an article when a particular article is clicked) 
        SSCommunityCases_Cntrl.getArticleOnClick(stringKavForId);
        //sc.GenerateReport();        
        
        //controller method
        
        PageReference pageRef = Page.TSSCommunityCases;
        Test.setCurrentPage(pageRef);
       // Add parameters to page URL
        ApexPages.currentPage().getParameters().put('KID', kavForId.Id);

        
        SSCommunityCases_Cntrl controller = new SSCommunityCases_Cntrl();
        controller.exptopdf();
        //SSCommunityCases_Cntrl.RateArticleMethod (kavForId.Id, '2');
        SSCommunityCases_Cntrl.caseSearch('Test','Recent Activity', 'ALL','ALL' ); 
        SSCommunityCases_Cntrl.caseSearch('Test','Date Created', 'Boeing','Electrical'  );
        SSCommunityCases_Cntrl.caseSearch('Test','Status', 'Boeing','Mechanical'  );
        SSCommunityCases_Cntrl.CaseLandingSearch('Recent Activity', 'ALL','ALL' );
        SSCommunityCases_Cntrl.CaseLandingSearch('Date Created', 'test','test' );
        SSCommunityCases_Cntrl.CaseLandingSearch('atachap', 'test','test' );
        SSCommunityCases_Cntrl.CaseLandingSearch('prodtype', 'test','test' );
        //SSCommunityCases_Cntrl.CaseLandingSearch('partno', 'test','test' );
        SSCommunityCases_Cntrl.CaseLandingSearch('subject', 'test','test' );
        SSCommunityCases_Cntrl.CaseLandingSearch('status', 'test','test' );
        SSCommunityCases_Cntrl.CaseLandingSearch('aircrafttype', 'test', 'test');
        
        Test.stopTest();
    }
   
       static testMethod void testSSCommunityCases3(){
       Test.startTest();
       Account acc = new Account();
        acc.Name = 'Test Account3';
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'ATR';
        acc.CBT__c = 'Airbus';
        acc.Region_Name__c = 'Americas';
        acc.Sub_Region_Name__c = 'Canada';
        acc.Service_Level__c = 'Standard';
        acc.Type = 'OEM';
        acc.REPORT_ACCOUNT_NAME__c = 'Test Account3';
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
        
       // Profile p = [select id from profile where name ='Customer Self Service Community Profile' limit 1];
        //system.debug('>>>>>>>>>>>>>>>>>>>>>>p<<<<<<<<<<<>>>>'+p);

        User adminUser = new User();
    adminUser.FirstName = 'Test';
    adminUser.LastName = 'Test';
    adminUser.Alias = 'Test';
    adminUser.Email = 'someemail@blabla.com';
    adminUser.UserName = 'someemail@blabla.com';
    adminUser.EmailEncodingKey = 'UTF-8';
    adminUser.LanguageLocaleKey = 'en_US';
    adminUser.LocaleSidKey = 'en_US';
    adminUser.TimezoneSidKey = 'America/Los_Angeles';
    adminUser.ProfileId = [
                SELECT Id
                FROM Profile
                WHERE Name = 'System Administrator'
        ].Id;
    adminUser.UserRole =[SELECT Id FROM UserRole Where name = 'IT'];
    insert adminUser;
        
        //system.runAs(usr){
        //test.startTest();
        
        SSCommunityCases_Cntrl sc = new SSCommunityCases_Cntrl();
          sc.Inquiry_Type_Details_var     = 'Electrical';
          sc.Subject_Id_var = 'Test Please ignore';
          sc.Description_Id_var =  'Test Please ignore';
          sc.Aircraft_TypeId_var = [Select id from platform__c where Active__c = true limit 1].id;
          sc.ATA_Chapter_var = 'test';
          sc.Product_TypeId_var =[Select id from supported_products__c limit 1].id;
          sc.Part_Number_var = '123';
          sc.Case_Attachment =[Select id from attachment limit 1];
          //sc.CreateCase();
          string cd =sc.Product_TypeId_var+','+sc.Subject_Id_var+','+
          sc.Part_Number_var+','+sc.Description_Id_var+','+sc.Aircraft_TypeId_var+','+
          sc.ATA_Chapter_var+','+sc.Inquiry_Type_Details_var+','+null+','+null+','+null;
          
          SSCommunityCases_Cntrl.createCaseRemote(cd);
          SSCommunityCases_Cntrl.SearchAircraft();
          SSCommunityCases_Cntrl.aircraftValues();
           
          //String article = sc.articleId;
          //KnowledgeArticleVersion art = new KnowledgeArticleVersion();
          //KnowledgeArticle kno = new KnowledgeArticle();
          //art.id = article;
          //art.ArticleType = 'Knowledge_Article__kav';
          //art.KnowledgeArticleId = kno.id;
          //art.Title = 'test';
          SSCommunityCases_Cntrl.productTypeValues();
          
        Test.stopTest();
        }
   // } 
   
    static testMethod void testSSCommunityCases5(){
       
        SSCommunityCases_Cntrl sc = new SSCommunityCases_Cntrl();
            
            Technical_solutions__kav kavForId=[SELECT Id,Title,KnowledgeArticleId FROM Technical_solutions__kav WHERE Language = 'en_US' AND PublishStatus = 'online' LIMIT 1];
            String stringKavForId = string.valueOf(kavForId.Id);
            
            Technical_videos__kav kavForId1=[SELECT Id,Title,KnowledgeArticleId FROM Technical_videos__kav WHERE Language = 'en_US' AND PublishStatus = 'online' LIMIT 1];
            String stringKavForId1 = string.valueOf(kavForId1.Id);
            
            
            Knowledge_Article__kav kavForId2=[SELECT Id,ArticleType,UrlName,CreatedDate,ArchivedDate, Title,ArticleNumber,Summary,LastPublishedDate,LastModifiedById,FirstPublishedDate,KnowledgeArticleId,Question_Problem__c,AC_Type__c,AC_Type__r.Model_Name_without_Hypen__c,Supported_Products__r.name,PN__c,SW_Version__c,Phase_of_Flight__c,Fault_Messages__c,FDE_Event__c,Answer_Solution__c,Related_Links__c,Cause_Optional__c,PublishStatus FROM Knowledge_Article__kav  WHERE  
            language='en_US' AND PublishStatus='online' and (Not title like 'Test%' ) LIMIT 1];
            
            //CAS_Maintenance_Message_Article__kav kavForId2=[SELECT Id,Title,KnowledgeArticleId FROM CAS_Maintenance_Message_Article__kav WHERE Language = 'en_US' AND PublishStatus = 'online' LIMIT 1];
            //String stringKavForId2 = string.valueOf(kavForId2.Id);
            
        SSCommunityCases_Cntrl.getArticleOnClick(stringKavForId);
        SSCommunityCases_Cntrl.getArticleOnClick(stringKavForId1);
        //SSCommunityCases_Cntrl.getArticleOnClick(stringKavForId2);
        //controller method
        PageReference pageRef = Page.TSSCommunityCases;
        Test.setCurrentPage(pageRef);
       // Add parameters to page URL
        ApexPages.currentPage().getParameters().put('KID', kavForId.Id);
        SSCommunityCases_Cntrl controller = new SSCommunityCases_Cntrl();
        SSCommunityCases_Cntrl controller1 = new SSCommunityCases_Cntrl();
        
        controller.exptopdf();        
        ApexPages.currentPage().getParameters().put('KID', kavForId1.Id);
        controller.exptopdf();
        ApexPages.currentPage().getParameters().put('KID', kavForId2.Id);
        controller.exptopdf();
        controller.rateIds1 = 'Yes';
        controller.rateIds2 = 'No';
        controller.articleId = kavForId.Id;
        controller.mytext = 'Test';

        controller.updateArticleValues();
        ApexPages.currentPage().getParameters().put('Id', kavForId.id);
        ApexPages.currentPage().getParameters().put('Select', 'No');
        Feedback__c feed = new Feedback__c();
        
        String ids = ApexPages.currentPage().getParameters().put('Select', 'Yes');
        feed.Was_Article_Helpful__c = ids  ;
        feed.Interviewer_Name__c = UserInfo.getUserId();
        feed.Article_Id__c = kavForId.Id;
        feed.Article_Name__c = 'test';
        feed.Article_Type__c = 'Technical_Solutions__kav';
        controller.istrue = 'Yes';
        
        
        Test.startTest();
        
        insert feed;
        
       
        
        controller.updateArticleValues();
        
        Feedback__c obj = new Feedback__c();
          
        obj.Was_Article_Helpful__c = 'Yes'  ;
        obj.Interviewer_Name__c = UserInfo.getUserId();
        obj.Article_Id__c = '1234';
        obj.Article_Name__c = 'Test Article';
        obj.Article_Type__c = 'Technical_Videos__kav';
        obj.Comments__c = '';
        
        insert obj;
          Test.stopTest();
        controller1.updateArticleValues();

        
        //ApexPages.currentPage().getParameters().put('KID', kavForId2.Id);
        //controller.exptopdf();
        
        //Line 1044
        controller.getitems1();
        controller.getitems2();
        
    }*/
    
}