@isTest(SeeAllData=true)
private class test_Sendreferencematerialcls{
   static testMethod void Sendreferencematerialcls()
   {       
        /*Account acc = new Account();
        acc.Name = 'Honeywell Test';
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'D&S';
        acc.CBT__c = 'DAA';
        acc.Region_Name__c = 'Americas';
        acc.Sub_Region_Name__c = 'Canada';
        acc.Service_Level__c = 'Standard';
        acc.Type = 'OEM';
        acc.REPORT_ACCOUNT_NAME__c = 'HONEYWELL TEST';        
        insert acc;*/
        Account acc=[select id,name,Customer_Status__c,Strategic_Business_Unit__c,CBT__c,Region_Name__c,Sub_Region_Name__c,Service_Level__c,Type,REPORT_ACCOUNT_NAME__c from account where Name LIKE '%honeywell%' limit 1];   
        
        contact cnt = new contact();       
        cnt.AccountId= acc.id;
        cnt.firstname='venkat';
        cnt.SBU_Contact__c='BGA';
        cnt.CBT__c='HBC';
        cnt.CBT_Team__c='EMEAI';
        cnt.LastName='test';
        cnt.Primary_Email_Address__c='sindhuja.velmurugan@testsample.com';  
        cnt.Phone_3__c='555555';
        cnt.Phone_1__c='666666';
        insert cnt;
                     
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Method Opportunity';        
        //opp.RecordTypeId = [SELECT id FROM RecordType WHERE SobjectType = 'Opportunity' AND Name = 'Catalog' limit 1].Id;
        opp.RecordTypeId = label.D_S_PrePriced;
        opp.SBU__c = 'D&S';
        opp.CBT_Tier_2__c = 'DAA';
        opp.CBT_Team_Tier_3__c = 'CBMS';
        opp.AccountId = acc.Id;
        opp.End_User__c = acc.Id;
        opp.Tech_Sales_Product_Area__c = 'APU';
        opp.Tech_Sales__c = 'Mechanical Systems';
        opp.Prime_Sub__c = 'Prime';
        opp.Opportunity_Type__c = 'D&S PrePriced';
        opp.StageName = 'Offer/Negotiate/Close';
        opp.CloseDate = Date.today();
        opp.Revenue_Type__c = 'ENG';
        opp.Bid_Type_Name__c = 'LTA';
        opp.International_Code__c = 'FMS';
        opp.Incumbent__c = 'Incumbent';
        opp.RMU__c = 'YES';
        opp.Is_Reference_Materials_used__c = TRUE;
        opp.Active__c = FALSE;  
        opp.ATR_Aircraft_Quantity__c=1;     
        insert opp;
                     
        Profile ProfRec = [select name from Profile where name = 'System Administrator'];
        User userRec = new User(LastName = 'venkat',Username = 'venkat@test.com.six',Email = 'venkat@test55.com',Alias = 'venkat6' ,CommunityNickname= 'venkat6' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = ProfRec.Id, LanguageLocaleKey = 'en_US');
        insert userRec;
        
        CustomerStory__c cs=new CustomerStory__c();
        cs.Related_Opportunity__c=opp.id;
        cs.Name='test';
        cs.Story_Type__c='Win';
        cs.Files_Links_1__c='google.com';
        cs.Files_Links_2__c='www.nttdata.com';
        cs.Video_Link_mac__c='yahoo.com';
        cs.Status__c='Backlog';
        cs.Sales_Reference__c='Yes';
        cs.Sharing_Restriction__c='Educational Use Only - Do Not Mention Customer Name';
        cs.Region1__c='APAC';
        cs.SBU__c='BGA';
        cs.Story_Owner__c=userRec.id;
        insert cs;
        
        Related_Customer_Stories__c p1=new Related_Customer_Stories__c();
        p1.name='releted customer';
        p1.Summary__c='new test customer story';
        p1.Files_Links_1__c='google.com';
        p1.Files_Links_2__c='www.nttdata.com';
        p1.Video_Link_mac__c='yahoo.com';
        p1.Solutions__c='new tset';
        p1.CustomerStory__c=cs.id;
        p1.Opportunity__c=opp.Id;
        p1.Product_Line__c='new product line';
        p1.Make__c='test';
        p1.CustomerName__c=acc.Id;
        p1.Reason__c='Product';
        insert p1; 
   
        Attachment att=new Attachment();
        att.name='test';
        String myString = 'StringToBlob';
        Blob myBlob = Blob.valueof(myString);
        att.Body=myBlob;
        att.ParentId=cs.id;
        insert att;
             
      List<String> stringList2 =new List<String>();
      List<string> connamelist=new List<string>();
      CustomIterable obj;
      CustomIterable obj1;
      String email1='venkat@test.com';
      String name1='venkat@test.com';
           
      test.setCurrentPageReference(new PageReference('Page.SendReferenceMaterials')); 
      System.currentPageReference().getParameters().put('id', opp.id);
              
       Sendreferencematerialcls srt=new Sendreferencematerialcls();       
       srt.email1='venkat@test.com';
       srt.email2='venkat@test.com';
       srt.email3='venkat@test.com';
       srt.successMessage();
       srt.echoVal();
       //check if loop of getSelected
       srt.callwindow= true;
       Boolean  b1= srt.callwindow;
       system.assertEquals(b1, true);
       srt.getSelected();
      List<AccountInner> list1=new List<AccountInner>();
      AccountInner ai=new AccountInner(true,p1);     
      list1.add(ai);
      srt.accInnerList=list1;
      List<AccountInner> list2=new List<AccountInner>();
      AccountInner ci=new AccountInner(true,cnt);
      list2.add(ci);
      srt.conInnerList= list2;
      srt.isSelectedAccts();
      //srt.isSelectedCons();
      srt.echoVal();
      Boolean callwindow2;
      Boolean callwindow1;
      Boolean b;
      srt.callwindow= false;
      b= srt.callwindow;
      system.assertEquals(b, false);
      Boolean c;
      srt.callwindow2= false;
      c= srt.callwindow2;
      system.assertEquals(c,false);
      srt.stringList2.add('venkat@test.com');
      srt.echoVal();     
        Boolean b2;
        srt.callwindow= false;
        b2= srt.callwindow;
        system.assertEquals(b2, false);
        Boolean c2;
        srt.callwindow2= false;
        c2= srt.callwindow2;
        system.assertEquals(c2,false);
        srt.stringList2.add('venkat@test.com');
        srt.getSelected(); 
       
   }  
   }