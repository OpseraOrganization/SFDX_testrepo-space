/*******************************************************************************
Name         : Constants
Created By   : Anusuya Murugiah
Company Name : NTT Data
Project      : Phase-II, HealthCheck
Created Date : 11 November 2013
Usages       : This Class a generic Constant/String declaration which is used in 
               ObjCaseHelper class.    
Modification History  :
Date          Version No.     Modified by     Brief Description of Modification
11 Oct 2010   1.1             NTTDATA         HAN-0263 Healtcheck Sprint 2 
*******************************************************************************/
@isTest()
private class ConstantsForCaseWFDelegate_Test {


    static testMethod void myUnitTest() {
        ConstantsForCaseWFDelegate cfcd= new ConstantsForCaseWFDelegate();
        string a=ConstantsForCaseWFDelegate.ORIGIN_WEB;
       
    }
      // HAN-0263 HealthCheck - Start
    static testmethod void TestCaseWorkflowDelegate3(){     
    
        /*ConstantsForCaseWFDelegate cfcd= new ConstantsForCaseWFDelegate();
        cfcd.ORIGIN_WEB='Web';
        cfcd.TYPE_INVOICE_DISPUTES='Invoice/Disputes';*/
        //creating account;
        user runUser=[select id,name from user where id=:userinfo.getuserid()];
        system.runas(runUser){
        
        Account acc= new Account(name='Test Account');
        insert acc;
        
        //creating contact;
        Contact cont=new Contact(firstname='Test',LastName='Contact',AccountId=acc.Id,Phone_3__c='9986502495', Phone_Tree_Extn__c='1234',
        Contact_Is_Employee__c=true,  Contact_Status__c='Active', Employee_Contact_Role__c='Analyst',Employee_Number__c='E123567');
        insert cont;
        
        Schema.DescribeSObjectResult CaseDesc = Schema.SObjectType.Case;
        Map<String,Schema.RecordTypeInfo> CasertMapByName = CaseDesc.getRecordTypeInfosByName();
        Schema.RecordTypeInfo CaseRTByName = CasertMapByName.get('Orders');
        ID ordersRT = CaseRTByName.getRecordTypeId();  
        
        list<Group> grouplist=new list<Group>();
        Group g1 = new Group(Name='group name', type='Queue');
        grouplist.add(g1);
        Group g2 = new Group(Name='group name1', type='Queue');
        grouplist.add(g2);
        Group g3 = new Group(Name='group name2', type='Queue');
        grouplist.add(g3);
        Group g4 = new Group(Name='group name3', type='Queue');
        grouplist.add(g4);
        Group g5 = new Group(Name='group name4', type='Queue');
        grouplist.add(g5);
        Group g6 = new Group(Name='group name5', type='Queue');
        grouplist.add(g6);
        Group g7 = new Group(Name='group name6', type='Queue');
        grouplist.add(g7);
        Group g8 = new Group(Name='group name7', type='Queue');
        grouplist.add(g8);
        Group g9 = new Group(Name='group name8', type='Queue');
        grouplist.add(g9);
        Group g10 = new Group(Name='group name9', type='Queue');
        grouplist.add(g10);
        Group g11 = new Group(Name='group name10', type='Queue');
        grouplist.add(g11);
        Group g12 = new Group(Name='group name11', type='Queue');
        grouplist.add(g12);
        
        insert grouplist;
        
        list<QueuesObject> queuelist=new list<QueuesObject>();
        QueuesObject q1 = new QueueSObject(QueueID = g1.id, SobjectType = 'case');
        queuelist.add(q1);
        QueuesObject q2 = new QueueSObject(QueueID = g2.id, SobjectType = 'case');
        queuelist.add(q2);
        QueuesObject q3 = new QueueSObject(QueueID = g3.id, SobjectType = 'case');
        queuelist.add(q3);
        QueuesObject q4 = new QueueSObject(QueueID = g4.id, SobjectType = 'case');
        queuelist.add(q4);
        QueuesObject q5 = new QueueSObject(QueueID = g5.id, SobjectType = 'case');
        queuelist.add(q5);
        QueuesObject q6 = new QueueSObject(QueueID = g6.id, SobjectType = 'case');
        queuelist.add(q6);
        QueuesObject q7 = new QueueSObject(QueueID = g7.id, SobjectType = 'case');
        queuelist.add(q7);
        QueuesObject q8 = new QueueSObject(QueueID = g8.id, SobjectType = 'case');
        queuelist.add(q8);
        QueuesObject q9 = new QueueSObject(QueueID = g9.id, SobjectType = 'case');
        queuelist.add(q9);
        QueuesObject q10 = new QueueSObject(QueueID = g10.id, SobjectType = 'case');
        queuelist.add(q10);
        QueuesObject q11 = new QueueSObject(QueueID = g11.id, SobjectType = 'case');
        queuelist.add(q11);
        QueuesObject q12 = new QueueSObject(QueueID = g12.id, SobjectType = 'case');
        queuelist.add(q12);
        
        insert queuelist;
        
        list<GroupMember> gmemberlist=new list<GroupMember>();
        GroupMember member = new GroupMember(UserOrGroupId = Userinfo.getUserId(),GroupId = g1.Id);
        gmemberlist.add(member);
        GroupMember member1 = new GroupMember(UserOrGroupId = Userinfo.getUserId(),GroupId = g2.Id);
        gmemberlist.add(member1);
        GroupMember member2 = new GroupMember(UserOrGroupId = Userinfo.getUserId(),GroupId = g3.Id);
        gmemberlist.add(member2);
        GroupMember member3 = new GroupMember(UserOrGroupId = Userinfo.getUserId(),GroupId = g4.Id);
        gmemberlist.add(member3);
        GroupMember member4 = new GroupMember(UserOrGroupId = Userinfo.getUserId(),GroupId = g5.Id);
        gmemberlist.add(member4);
        GroupMember member5 = new GroupMember(UserOrGroupId = Userinfo.getUserId(),GroupId = g6.Id);
        gmemberlist.add(member5);
        GroupMember member6 = new GroupMember(UserOrGroupId = Userinfo.getUserId(),GroupId = g7.Id);
        gmemberlist.add(member6);
        GroupMember member7 = new GroupMember(UserOrGroupId = Userinfo.getUserId(),GroupId = g8.Id);
        gmemberlist.add(member7);
        GroupMember member8 = new GroupMember(UserOrGroupId = Userinfo.getUserId(),GroupId = g9.Id);
        gmemberlist.add(member8);
        GroupMember member9 = new GroupMember(UserOrGroupId = Userinfo.getUserId(),GroupId = g10.Id);
        gmemberlist.add(member9);
        GroupMember member10 = new GroupMember(UserOrGroupId = Userinfo.getUserId(),GroupId = g11.Id);
        gmemberlist.add(member10);
        GroupMember member11 = new GroupMember(UserOrGroupId = Userinfo.getUserId(),GroupId = g12.Id);
        gmemberlist.add(member11);
        insert gmemberlist;
        
        list<QueueTeam__c> queueTeamList=new list<QueueTeam__c>();
        QueueTeam__c qteam=new QueueTeam__c(name='Invoice/Disputes Team',queueid__c=q1.id);
        queueTeamList.add(qteam);
        QueueTeam__c qteam1=new QueueTeam__c(name='Pubs Team',queueid__c=q2.id);
        queueTeamList.add(qteam1);
        QueueTeam__c qteam2=new QueueTeam__c(name='Returns Team',queueid__c=q3.id);
        queueTeamList.add(qteam2);
        QueueTeam__c qteam3=new QueueTeam__c(name='Warranty Team',queueid__c=q4.id);
        queueTeamList.add(qteam3);
        QueueTeam__c qteam4=new QueueTeam__c(name='TOC Team',queueid__c=q5.id);
        queueTeamList.add(qteam4);
        QueueTeam__c qteam5=new QueueTeam__c(name='D&S Orders Team',queueid__c=q6.id);
        queueTeamList.add(qteam5);
        QueueTeam__c qteam6=new QueueTeam__c(name='Quotes Team',queueid__c=q7.id);
        queueTeamList.add(qteam6);
        QueueTeam__c qteam7=new QueueTeam__c(name='Order Status Team',queueid__c=q8.id);
        queueTeamList.add(qteam7);
        QueueTeam__c qteam8=new QueueTeam__c(name='CSO R&O Team',queueid__c=q9.id);
        queueTeamList.add(qteam8);
        QueueTeam__c qteam9=new QueueTeam__c(name='Orders Team',queueid__c=q10.id);
        queueTeamList.add(qteam9);
        QueueTeam__c qteam10=new QueueTeam__c(name='Order Changes Team',queueid__c=q11.id);
        queueTeamList.add(qteam10);
        QueueTeam__c qteam11=new QueueTeam__c(name='R&O Quotes Team',queueid__c=q12.id);
        queueTeamList.add(qteam11);
        insert queueTeamList;
        
        list<ClassificationList__c> classificationList=new list<ClassificationList__c>();
        ClassificationList__c clasific=new ClassificationList__c(name='CSO Special Programs',classification__c='CSO Special Programs');
        classificationList.add(clasific);
        ClassificationList__c clasific1=new ClassificationList__c(name='CSO Spares',classification__c='CSO Spares');
        classificationList.add(clasific1);
        ClassificationList__c clasific2=new ClassificationList__c(name='CSO Warranty',classification__c='CSO Warranty');
        classificationList.add(clasific2);
        ClassificationList__c clasific3=new ClassificationList__c(name='GTO Tech Operations Center',classification__c='GTO Tech Operations Center');
        classificationList.add(clasific3);
        ClassificationList__c clasific4=new ClassificationList__c(name='CSO D&S Internal',classification__c='CSO D&S Internal');
        classificationList.add(clasific4);
        ClassificationList__c clasific5=new ClassificationList__c(name='CSO Repair/Overhaul',classification__c='CSO Repair/Overhaul');
        classificationList.add(clasific5);
        ClassificationList__c clasific6=new ClassificationList__c(name='GTO D&S Technical Issue',classification__c='GTO D&S Technical Issue');
        classificationList.add(clasific6);
        ClassificationList__c clasific7=new ClassificationList__c(name='Tech Pubs',classification__c='Tech Pubs');
        classificationList.add(clasific7);
        ClassificationList__c clasific8=new ClassificationList__c(name='R&O Issue',classification__c='R&O Issue');
        classificationList.add(clasific8);
        ClassificationList__c clasific9=new ClassificationList__c(name='R&O Quote',classification__c='R&O Quote');
        classificationList.add(clasific9);
        insert classificationList;
        
        list<SubClassList__c> subclassList=new list<SubClassList__c>();
        SubClassList__c subcase=new SubClassList__c(Name='Invoice/Disputes',subclass__c='Invoice/Disputes');
        subclassList.add(subcase);
        SubClassList__c subcase1=new SubClassList__c(Name='Publications',subclass__c='Publications');
        subclassList.add(subcase1);
        SubClassList__c subcase2=new SubClassList__c(Name='Wheels & Brakes',subclass__c='Wheels & Brakes');
        subclassList.add(subcase2);
        SubClassList__c subcase3=new SubClassList__c(Name='Redmond',subclass__c='Redmond');
        subclassList.add(subcase3);
        SubClassList__c subcase4=new SubClassList__c(Name='New Spare',subclass__c='New Spare');
        subclassList.add(subcase4);
        SubClassList__c subcase5=new SubClassList__c(Name='Bendix/King',subclass__c='Bendix/King');
        subclassList.add(subcase5);
        SubClassList__c subcase6=new SubClassList__c(Name='Electrical (R&O)',subclass__c='Electrical (R&O)');
        subclassList.add(subcase6);
        SubClassList__c subcase7=new SubClassList__c(Name='Mechanical (R&O)',subclass__c='Mechanical (R&O)');
        subclassList.add(subcase7);
        SubClassList__c subcase8=new SubClassList__c(Name='Bendix-King',subclass__c='Bendix-King');
        subclassList.add(subcase8);
        SubClassList__c subcase9=new SubClassList__c(Name='Software',subclass__c='Software');
        subclassList.add(subcase9);
        SubClassList__c subcase10=new SubClassList__c(Name='Global Material Services (GMS)',subclass__c='Global Material Services (GMS)');
        subclassList.add(subcase10);
        SubClassList__c subcase11=new SubClassList__c(Name='HON International SARL (HIS)',subclass__c='HON International SARL (HIS)');
        subclassList.add(subcase11);
        SubClassList__c subcase12=new SubClassList__c(Name='SPEX/Exchange',subclass__c='SPEX/Exchange');
        subclassList.add(subcase12);
        SubClassList__c subcase13=new SubClassList__c(Name='Deferred Online Order',subclass__c='Deferred Online Order');
        subclassList.add(subcase13);
        SubClassList__c subcase14=new SubClassList__c(Name='Avionics LRU',subclass__c='Avionics LRU');
        subclassList.add(subcase14);
        insert subclassList;
        
        
        Test.startTest();
        TriggerInactive.testTrigger = true;
        ID csoROTeamQ = [SELECT Type, Id FROM Group where type = 'Queue' and name ='CSO R&O Team' ].id;
        //try{       
        Map<String,QueueTeam__c> mapQueueID = QueueTeam__c.getALL();         
        Map<String,ClassificationList__c> mapClassification = ClassificationList__c.getALL();
        Map<String,SubClassList__c> mapSubClass = SubClassList__c.getALL();
        
       // }catch(Exception e){
        //System.debug('Exception while assigning the map variable in TestPreventCaseCreation Class'+e);
       // }    
         
        List<Case> caseList = new List<Case>();
        Case cases3=new Case(AccountId=acc.Id,ContactId=cont.Id,Sales_Order_Number__c='test1234',Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',origin='Web',
        //No_FCR_Reason__c='Not Trained',
        recordtypeid=ordersRT ,Type='Invoice/Disputes', classification__c = 'EMS');         
        caseList.add(cases3);
        
        Case case1=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',origin='Web',
        //No_FCR_Reason__c='Not Trained',
        recordtypeid=ordersRT ,Type='Tech Pubs',Sales_Order_Number__c='test1234', classification__c = 'EMS');         
        caseList.add(case1);
        
        Case case2=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',origin='Web',
        //No_FCR_Reason__c='Not Trained' ,
        recordtypeid=ordersRT,Type='Returns',Sales_Order_Number__c='test1234', classification__c = 'EMS');         
        caseList.add(case2);
        
        Case case3=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',origin='Web',
        //No_FCR_Reason__c='Not Trained' ,
        recordtypeid=ordersRT,Type='Warranty',Sales_Order_Number__c='test1234', classification__c = 'EMS');         
        caseList.add(case3);
        
        Case case4=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',origin='Web',
        //No_FCR_Reason__c='Not Trained',
        recordtypeid=ordersRT,Type='Technical Issue',Sales_Order_Number__c='test1234', classification__c = 'EMS');         
        caseList.add(case4);
        
        CaseRTByName = CasertMapByName.get('D&S Quotes Orders');
        ID caseRT_DS = CaseRTByName.getRecordTypeId();          
        
        /*Case case5=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',origin='Web',
        No_FCR_Reason__c='Not Trained',recordtypeid = caseRT_DS,Type='Place Order', classification__c = 'EMS');         
        caseList.add(case5);
        */
                   
        Case case61=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',origin='Web',
        recordtypeid=ordersRT,Type='Quotes/Availability',cage_code__c = '55284',Sales_Order_Number__c='test1234', classification__c = 'EMS');         
        caseList.add(case61);
        
        Case case62=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',origin='Web',
        //No_FCR_Reason__c='Not Trained',
        recordtypeid=ordersRT,Type='Quotes/Availability',cage_code__c = '97896',Sales_Order_Number__c='test1234', classification__c = 'EMS');         
        caseList.add(case62);
        
        Case case63=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',origin='Web',
        recordtypeid=ordersRT,Type='Quotes/Availability',cage_code__c = '55939',Sales_Order_Number__c='test1234', classification__c = 'EMS');         
        caseList.add(case63);
        
        Case case64=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',origin='Web',
        recordtypeid=ordersRT,Type='Quotes/Availability',cage_code__c = '22373',Sales_Order_Number__c='test1234', classification__c = 'EMS');         
        caseList.add(case64);
        
        Case case65=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',origin='Web',
        recordtypeid=ordersRT,Type='Quotes/Availability',cage_code__c = '2237344',Sales_Order_Number__c='test1234', classification__c = 'EMS');         
        caseList.add(case65);
        
        
        //WF - WebCaseOrder Status Services
        Case case10=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',origin='Web',
        recordtypeid=ordersRT,Type='Order Status',Order_Type__c='Services',Detail_Type__c='Detail part',cage_code__c = '22373',Sales_Order_Number__c='test1234', classification__c = 'EMS');         
        caseList.add(case10);
        
        Case case5=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',origin='Web',
        recordtypeid=ordersRT,Type='Order Status',Order_Type__c='Spares',cage_code__c = '22373',Sales_Order_Number__c='test1234', classification__c = 'EMS');         
        caseList.add(case5);
        
        Case case6=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',origin='Web',
        recordtypeid=ordersRT,Type='Order Status',Order_Type__c='Repair/Overhaul',cage_code__c = '22373',Sales_Order_Number__c='test1234', classification__c = 'EMS');         
        caseList.add(case6);  
          
        Case case6i=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',origin='Web',
        recordtypeid=ordersRT,Type='Order Status',Order_Type__c='Services',cage_code__c = '2237333',Sales_Order_Number__c='test1234', classification__c = 'EMS');         
        caseList.add(case6i);  
        Case case6i1=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',origin='Web',
        recordtypeid=ordersRT,Type='Order Status',Order_Type__c='Spares',cage_code__c = '2237333',Sales_Order_Number__c='test1234', classification__c = 'EMS');         
        caseList.add(case6i1);
        Case case6i2=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',origin='Web',
        recordtypeid=ordersRT,Type='Order Status',Order_Type__c='Repair/Overhaul',cage_code__c = '2237333',Sales_Order_Number__c='test1234', classification__c = 'EMS');         
        caseList.add(case6i2);   
        
        // Not Order Status Repair/Overhaul
        Case case7=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',origin='Web',
        recordtypeid=ordersRT,Type='Order Changes',Order_Type__c='Repair/Overhaul',Product_Type__c='Lighting',cage_code__c = '2237344',Sales_Order_Number__c='test1234', classification__c = 'EMS');         
        caseList.add(case7);
        Case case8=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',origin='Web',
        recordtypeid=ordersRT,Type='Order Changes',Order_Type__c='Repair/Overhaul',Product_Type__c='Mechanical',cage_code__c = '2237344',Sales_Order_Number__c='test1234', classification__c = 'EMS');         
        caseList.add(case8);
        Case case9=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',origin='Web',
        recordtypeid=ordersRT,Type='Order Changes',Order_Type__c='Repair/Overhaul',Product_Type__c='Electrical',cage_code__c = '2237344',Sales_Order_Number__c='test1234', classification__c = 'EMS');         
        caseList.add(case9);
        
        // Not Order Status Spares
        Case case7i=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',origin='Web',
        recordtypeid=ordersRT,Type='Order Changes',Order_Type__c='Spares',Product_Type__c='Lighting',cage_code__c = '2237344',Sales_Order_Number__c='test1234', classification__c = 'EMS');         
        caseList.add(case7i);
        Case case8i=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',origin='Web',
        recordtypeid=ordersRT,Type='Order Changes',Order_Type__c='Spares',Product_Type__c='Mechanical',cage_code__c = '2237344',Sales_Order_Number__c='test1234', classification__c = 'EMS');         
        caseList.add(case8i);
        Case case9i=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',origin='Web',
        recordtypeid=ordersRT,Type='Order Changes',Order_Type__c='Spares',Product_Type__c='Electrical',cage_code__c = '2237344',Sales_Order_Number__c='test1234', classification__c = 'EMS');         
        caseList.add(case9i);
        Case case9i1=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',origin='Web',
        recordtypeid=ordersRT,Type='Order Changes',Order_Type__c='Spares',Product_Type__c='Bendix-King',cage_code__c = '2237344',Sales_Order_Number__c='test1234', classification__c = 'EMS');         
        caseList.add(case9i1);
        
        //Place Order , Spares
        Case case10i=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',origin='Web',
        recordtypeid=ordersRT,Type='Place Order',Detail_Type__c='Software',Order_Type__c='Spares',Product_Type__c='Electrical',Country__c='American Samoa',cage_code__c = '2237344',Sales_Order_Number__c='test1234', classification__c = 'EMS');         
        caseList.add(case10i);
        Case case10i1=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',origin='Web',
        recordtypeid=ordersRT,Type='Place Order',Detail_Type__c='Detail part',Order_Type__c='Spares',Product_Type__c='Electrical',Country__c='Afghanistan',cage_code__c = '2237344',Sales_Order_Number__c='test1234', classification__c = 'EMS');         
        caseList.add(case10i1);
        Case case10i11=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',origin='Web',
        recordtypeid=ordersRT,Type='Place Order',Detail_Type__c='Detail part',Order_Type__c='Spares',Product_Type__c='Electrical',Country__c='American Samoa',cage_code__c = '2237344',Sales_Order_Number__c='test1234', classification__c = 'EMS');         
        caseList.add(case10i11);
        
        Case case10i2=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',origin='Web',
        recordtypeid=ordersRT,Type='Place Order',Detail_Type__c='LRU',Order_Type__c='Spares',Product_Type__c='Electrical',Country__c='Afghanistan',cage_code__c = '2237344',Sales_Order_Number__c='test1234', classification__c = 'EMS');         
        caseList.add(case10i2);
        Case case10i3=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',origin='Web',
        recordtypeid=ordersRT,Type='Place Order',Detail_Type__c='Software',Order_Type__c='Spares',Product_Type__c='Electrical',Country__c='Afghanistan',cage_code__c = '2237344',Sales_Order_Number__c='test1234', classification__c = 'EMS');         
        caseList.add(case10i3);
        Case case10i4=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',origin='Web',
        recordtypeid=ordersRT,Type='Place Order',Detail_Type__c='SPEX/Exchange',Order_Type__c='Spares',Product_Type__c='Electrical',Country__c='Afghanistan',cage_code__c = '2237344',Sales_Order_Number__c='test1234', classification__c = 'EMS');         
        caseList.add(case10i4);
        
        //lighting 
        Case case10i5=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',origin='Web',
        recordtypeid=ordersRT,Type='Place Order',Detail_Type__c='Detail part',Order_Type__c='Spares',Product_Type__c='Lighting',Country__c='Afghanistan',cage_code__c = '2237344',Sales_Order_Number__c='test1234', classification__c = 'EMS');         
        caseList.add(case10i5);
        Case case10i6=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',origin='Web',
        recordtypeid=ordersRT,Type='Place Order',Detail_Type__c='Software',Order_Type__c='Spares',Product_Type__c='Mechanical',Country__c='Afghanistan',cage_code__c = '2237344',Sales_Order_Number__c='test1234', classification__c = 'EMS');         
        caseList.add(case10i6);
        Case case10i7=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',origin='Web',
        recordtypeid=ordersRT,Type='Place Order',Detail_Type__c='Detail part',Order_Type__c='Spares',Product_Type__c='Bendix-King',Country__c='Afghanistan',cage_code__c = '2237344',Sales_Order_Number__c='test1234', classification__c = 'EMS');         
        caseList.add(case10i7);
        Case case10i8=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',origin='Web',
        recordtypeid=ordersRT,Type='Place Order',Detail_Type__c='Software',Order_Type__c='Spares',Product_Type__c='Bendix-King',Country__c='Afghanistan',cage_code__c = '2237344',Sales_Order_Number__c='test1234', classification__c = 'EMS');         
        caseList.add(case10i8);
        Case case10i9=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',origin='Web',
        recordtypeid=ordersRT,Type='Place Order',Detail_Type__c='SPEX/Exchange',Order_Type__c='Spares',Product_Type__c='Wheels & Brakes',Country__c='Afghanistan',cage_code__c = '2237344',Sales_Order_Number__c='test1234', classification__c = 'EMS');         
        caseList.add(case10i9);
        
        //Order Type Services
        Case case10j1=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',origin='Web',
        recordtypeid=ordersRT,Type='Place Order',Detail_Type__c='SPEX/Exchange',Order_Type__c='Services',Product_Type__c='Lighting',Country__c='Afghanistan',cage_code__c = '2237344',Sales_Order_Number__c='test1234', classification__c = 'EMS');         
        caseList.add(case10j1);
        Case case10j2=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',origin='Web',
        recordtypeid=ordersRT,Type='Place Order',Detail_Type__c='SPEX/Exchange',Order_Type__c='Services',Product_Type__c='Bendix-King',Country__c='Afghanistan',cage_code__c = '2237344',Sales_Order_Number__c='test1234', classification__c = 'EMS');         
        caseList.add(case10j2);
        Case case10j3=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',origin='Web',
        recordtypeid=ordersRT,Type='Place Order',Detail_Type__c='SPEX/Exchange',Order_Type__c='Services',Product_Type__c='Wheels & Brakes',Country__c='Afghanistan',cage_code__c = '2237344',Sales_Order_Number__c='test1234', classification__c = 'EMS');         
        caseList.add(case10j3);
        Case case10j4=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',origin='Web',
        recordtypeid=ordersRT,Type='Place Order',Detail_Type__c='SPEX/Exchange',Order_Type__c='Services',Product_Type__c='Electrical',Country__c='Afghanistan',cage_code__c = '2237344',Sales_Order_Number__c='test1234', classification__c = 'EMS');         
        caseList.add(case10j4);
        
        //Order Type Repair/Overhaul
        Case case10k1=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',origin='Web',
        recordtypeid=ordersRT,Type='Place Order',Detail_Type__c='SPEX/Exchange',Order_Type__c='Repair/Overhaul',Product_Type__c='Wheels & Brakes',Country__c='Afghanistan',cage_code__c = '2237344',Sales_Order_Number__c='test1234', classification__c = 'EMS');         
        caseList.add(case10k1);
        Case case10k2=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',origin='Web',
        recordtypeid=ordersRT,Type='Place Order',Detail_Type__c='SPEX/Exchange',Order_Type__c='Repair/Overhaul',Product_Type__c='Lighting',Country__c='Afghanistan',cage_code__c = '2237344',Sales_Order_Number__c='test1234', classification__c = 'EMS');         
        caseList.add(case10k2);
        Case case10k3=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',origin='Web',
        recordtypeid=ordersRT,Type='Place Order',Detail_Type__c='SPEX/Exchange',Order_Type__c='Repair/Overhaul',Product_Type__c='Bendix-King',Country__c='Afghanistan',cage_code__c = '2237344',Sales_Order_Number__c='test1234', classification__c = 'EMS');         
        caseList.add(case10k3);
        
        // PLANTCODE_55284,PLANTCODE_22373,PLANTCODE_97896,PLANTCODE_55939
        Case case10p1=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',origin='Web',
        recordtypeid=ordersRT,Type='Order Status',Detail_Type__c='SPEX/Exchange',Order_Type__c='Repair/Overhaul',Product_Type__c='Bendix-King',Country__c='Afghanistan',cage_code__c = '55939',Sales_Order_Number__c='test1234', classification__c = 'EMS');         
        caseList.add(case10p1);
        Case case10p2=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',origin='Web',
        recordtypeid=ordersRT,Type='Place Order',Detail_Type__c='SPEX/Exchange',Order_Type__c='Spares',Product_Type__c='Bendix-King',Country__c='Afghanistan',cage_code__c = '55939',Sales_Order_Number__c='test1234', classification__c = 'EMS');         
        caseList.add(case10p2);
        Case case10p3=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',origin='Web',
        recordtypeid=ordersRT,Type='Order Changes',Detail_Type__c='SPEX/Exchange',Order_Type__c='Repair/Overhaul',Product_Type__c='Bendix-King',Country__c='Afghanistan',cage_code__c = '97896',Sales_Order_Number__c='test1234', classification__c = 'EMS');         
        caseList.add(case10p3);
        Case case10p4=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',origin='Web',
        recordtypeid=ordersRT,Type='Order Changes',Detail_Type__c='SPEX/Exchange',Order_Type__c='Repair/Overhaul',Product_Type__c='Bendix-King',Country__c='Afghanistan',cage_code__c = '22373',Sales_Order_Number__c='test1234', classification__c = 'EMS');         
        caseList.add(case10p4);
        Case case10p5=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',origin='Web',
        recordtypeid=ordersRT,Type='Order Changes',Detail_Type__c='SPEX/Exchange',Order_Type__c='Repair/Overhaul',Product_Type__c='Bendix-King',Country__c='Afghanistan',cage_code__c = '55284',Sales_Order_Number__c='test1234', classification__c = 'EMS');         
        caseList.add(case10p5);
        
        Case case10p6=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',origin='Web',
        recordtypeid=ordersRT,Type='Order Changes',Detail_Type__c='SPEX/Exchange',Order_Type__c='Spares',Product_Type__c='Bendix-King',Country__c='Afghanistan',cage_code__c = '55284',Sales_Order_Number__c='test1234', classification__c = 'EMS');         
        caseList.add(case10p6);
        Case case10p7=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',origin='Web',
        recordtypeid=ordersRT,Type='Order Changes',Detail_Type__c='SPEX/Exchange',Order_Type__c='Spares',Product_Type__c='Bendix-King',Country__c='Afghanistan',cage_code__c = '97896',Sales_Order_Number__c='test1234', classification__c = 'EMS');         
        caseList.add(case10p7);
        Case case10p8=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',origin='Web',
        recordtypeid=ordersRT,Type='Order Changes',Detail_Type__c='SPEX/Exchange',Order_Type__c='Spares',Product_Type__c='Bendix-King',Country__c='Afghanistan',cage_code__c = '55939',Sales_Order_Number__c='test1234', classification__c = 'EMS');         
        caseList.add(case10p8);
        //insert caseList;         
        CaseWorkflowDelegate.caseWFDelegate(caseList);
        CaseWorkflowDelegate.caseWFDelegateUpdate(caseList);
        Test.stopTest();
        }    
    }
    /*static testmethod void TestCaseWorkflowDelegate4(){     
        //creating account;
        Account acc= new Account(name='Test Account');
        insert acc;
        
        //creating contact;
        Contact cont=new Contact(firstname='Test',LastName='Contact',AccountId=acc.Id,Phone_3__c='9986502495', Phone_Tree_Extn__c='1234',
        Contact_Is_Employee__c=true,  Contact_Status__c='Active', Employee_Contact_Role__c='Analyst',Employee_Number__c='E123567');
        insert cont;
        
        Schema.DescribeSObjectResult CaseDesc = Schema.SObjectType.Case;
        Map<String,Schema.RecordTypeInfo> CasertMapByName = CaseDesc.getRecordTypeInfosByName();
        Schema.RecordTypeInfo CaseRTByName = CasertMapByName.get('Orders');
        ID ordersRT = CaseRTByName.getRecordTypeId();  
        
        
        
        
        Test.startTest();
        TriggerInactive.testTrigger = true;
        ID csoROTeamQ = [SELECT Type, Id FROM Group where type = 'Queue' and name ='CSO R&O Team' ].id;
        //try{       
        Map<String,QueueTeam__c> mapQueueID = QueueTeam__c.getALL();         
        Map<String,ClassificationList__c> mapClassification = ClassificationList__c.getALL();
        Map<String,SubClassList__c> mapSubClass = SubClassList__c.getALL();
        //}catch(Exception e){
        //System.debug('Exception while assigning the map variable in TestPreventCaseCreation Class'+e);
        //}    
         
        List<Case> caseList = new List<Case>();                 
        Case case63=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',origin='Web',
        //No_FCR_Reason__c='Not Trained',
        Type='Quotes/Availability',cage_code__c = '55939',Sales_Order_Number__c='test1234', classification__c = 'EMS');         
        caseList.add(case63);
        
        Case case64=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',origin='Web',
        //No_FCR_Reason__c='Not Trained',
        Type='Quotes/Availability',cage_code__c = '22373',Sales_Order_Number__c='test1234', classification__c = 'EMS');
        caseList.add(case64);
        
        Case case65=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',origin='Web',
        //No_FCR_Reason__c='Not Trained',
        Type='Order Status',Order_Type__c = 'Services',Product_Type__c = null,Sales_Order_Number__c='test1234', Detail_Type__c =null,cage_code__c = '123', classification__c = 'EMS');
        caseList.add(case65);
        
        Case case66=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',origin='Web',
        //No_FCR_Reason__c='Not Trained',
        recordtypeid=ordersRT,Type='Order Status',Order_Type__c = 'Spares',Sales_Order_Number__c='test1234',cage_code__c = '123', classification__c = 'EMS');
        caseList.add(case66);
        
        Case case67=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',origin='Web',
        //No_FCR_Reason__c='Not Trained',
        recordtypeid=ordersRT,Type='Order Changes',Order_Type__c = 'Repair/Overhaul',Product_Type__c = 'Mechanical',
        cage_code__c = '123',Sales_Order_Number__c='test1234', classification__c = 'EMS');
        caseList.add(case67);
        
        Case case7=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',origin='Web',
        //No_FCR_Reason__c='Not Trained',
        recordtypeid=ordersRT,Sales_Order_Number__c='test1234',Type='Order Status',Order_Type__c = 'Repair/Overhaul',
        cage_code__c = '123', classification__c = 'EMS');
        caseList.add(case7);
        
        Case case7_1=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',origin='Web',
        //No_FCR_Reason__c='Not Trained',
        recordtypeid=ordersRT,Type='Place Order',Order_Type__c = 'Spares',Product_Type__c = 'Electrical', Detail_Type__c ='Software',
        cage_code__c = '121',Sales_Order_Number__c='test1234',classification__c = 'EMS');
        caseList.add(case7_1);         
        
        Case case71=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',origin='Web',
        //No_FCR_Reason__c='Not Trained',
        recordtypeid=ordersRT,Type='Order Changes',Order_Type__c = 'Repair/Overhaul',Product_Type__c = 'Electrical', Detail_Type__c =null,
        cage_code__c = '3232',Sales_Order_Number__c='test1234', classification__c = 'EMS');
        caseList.add(case71);
        
        Case case72=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',origin='Web',
        //No_FCR_Reason__c='Not Trained',
        recordtypeid=ordersRT,Type='Order Changes',Order_Type__c = 'Spares',Product_Type__c = 'Mechanical', Detail_Type__c =null,
        cage_code__c = '123',Sales_Order_Number__c='test1234',classification__c = 'EMS');
        caseList.add(case72);
        
        Case case73=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',origin='Web',
        //No_FCR_Reason__c='Not Trained',
        recordtypeid=ordersRT,Type='Order Changes',Order_Type__c = 'Services',Product_Type__c = 'Wheels & Brakes', Detail_Type__c =null,
        cage_code__c = '123',Sales_Order_Number__c='test1234', classification__c = 'EMS');
        caseList.add(case73);
        
        insert caseList;         
        
        Test.stopTest();    
    }
    static testmethod void TestCaseWorkflowDelegate2(){     
        //creating account;
        Account acc= new Account(name='Test Account');
        insert acc;
        
        //creating contact;
        Contact cont=new Contact(firstname='Test',LastName='Contact',AccountId=acc.Id,Phone_3__c='9986502495', Phone_Tree_Extn__c='1234',
        Contact_Is_Employee__c=true,  Contact_Status__c='Active', Employee_Contact_Role__c='Analyst',Employee_Number__c='E123567');
        insert cont;
        
        Schema.DescribeSObjectResult CaseDesc = Schema.SObjectType.Case;
        Map<String,Schema.RecordTypeInfo> CasertMapByName = CaseDesc.getRecordTypeInfosByName();
        Schema.RecordTypeInfo CaseRTByName = CasertMapByName.get('Orders');
        ID ordersRT = CaseRTByName.getRecordTypeId();  
        
        Test.startTest();
        TriggerInactive.testTrigger = true;
        ID csoROTeamQ = [SELECT Type, Id FROM Group where type = 'Queue' and name ='CSO R&O Team' ].id;
       // try{       
        Map<String,QueueTeam__c> mapQueueID = QueueTeam__c.getALL();         
        Map<String,ClassificationList__c> mapClassification = ClassificationList__c.getALL();
        Map<String,SubClassList__c> mapSubClass = SubClassList__c.getALL();
        //}catch(Exception e){
        //System.debug('Exception while assigning the map variable in TestPreventCaseCreation Class'+e);
        //}    
         
        List<Case> caseList = new List<Case>();
        
        Case case13=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',origin='Web',
        //No_FCR_Reason__c='Not Trained',
        recordtypeid=ordersRT,Type='Order Changes',Order_Type__c = 'Repair/Overhaul',
        cage_code__c = '55284',Sales_Order_Number__c='test1234', classification__c = 'EMS');
        caseList.add(case13);
        
        Case case14=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',origin='Web',
        //No_FCR_Reason__c='Not Trained',
        recordtypeid=ordersRT,Type='Order Changes',Order_Type__c = 'Spares',
        cage_code__c = '97896',Sales_Order_Number__c='test1234', classification__c = 'EMS');
        caseList.add(case14);
        
        Case case15=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',origin='Web',
        //No_FCR_Reason__c='Not Trained',
        recordtypeid=ordersRT,Type='Order Changes',Order_Type__c = 'Spares',
        cage_code__c = '55939',Sales_Order_Number__c='test1234', classification__c = 'EMS');
        caseList.add(case15);
        
        Case case16=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',origin='Web',
        //No_FCR_Reason__c='Not Trained',
        recordtypeid=ordersRT,Type='Order Changes',Order_Type__c = 'Spares',
        cage_code__c = '22373', Sales_Order_Number__c='test1234',classification__c = 'EMS');
        caseList.add(case16);
        
        Case case17=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',origin='Web',
        //No_FCR_Reason__c='Not Trained',
        recordtypeid=ordersRT,Type='Order Changes',Order_Type__c = 'Spares',
        cage_code__c = '55284',Sales_Order_Number__c='test1234', classification__c = 'EMS');
        caseList.add(case17);
        
          
        insert caseList;
        
        
        Test.stopTest();  
    }
    static testmethod void TestCaseWorkflowDelegate1(){     
        //creating account;
        Account acc= new Account(name='Test Account');
        insert acc;
        
        //creating contact;
        Contact cont=new Contact(firstname='Test',LastName='Contact',AccountId=acc.Id,Phone_3__c='9986502495', Phone_Tree_Extn__c='1234',
        Contact_Is_Employee__c=true,  Contact_Status__c='Active', Employee_Contact_Role__c='Analyst',Employee_Number__c='E123567');
        insert cont;
        
        Schema.DescribeSObjectResult CaseDesc = Schema.SObjectType.Case;
        Map<String,Schema.RecordTypeInfo> CasertMapByName = CaseDesc.getRecordTypeInfosByName();
        Schema.RecordTypeInfo CaseRTByName = CasertMapByName.get('Orders');
        ID ordersRT = CaseRTByName.getRecordTypeId();  
        
        Test.startTest();
        TriggerInactive.testTrigger = true;
        ID csoROTeamQ = [SELECT Type, Id FROM Group where type = 'Queue' and name ='CSO R&O Team' ].id;
        //try{       
        Map<String,QueueTeam__c> mapQueueID = QueueTeam__c.getALL();         
        Map<String,ClassificationList__c> mapClassification = ClassificationList__c.getALL();
        Map<String,SubClassList__c> mapSubClass = SubClassList__c.getALL();
        //}catch(Exception e){
        //System.debug('Exception while assigning the map variable in TestPreventCaseCreation Class'+e);
        //}    
         
        List<Case> caseList = new List<Case>();
        
        Case case74=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',origin='Web',
        //No_FCR_Reason__c='Not Trained',
        recordtypeid=ordersRT,Type='Order Changes',Order_Type__c = 'Repair/Overhaul',Product_Type__c = 'Lighting', Detail_Type__c =null,
        cage_code__c = '123',Sales_Order_Number__c='test1234', classification__c = 'EMS');
        caseList.add(case74);
        
        Case case75=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',origin='Web',
        //No_FCR_Reason__c='Not Trained',
        recordtypeid=ordersRT,Type='Order Status',Order_Type__c = 'Repair/Overhaul',Product_Type__c = null, Detail_Type__c =null,
        cage_code__c = '55939',Sales_Order_Number__c='test1234', classification__c = 'EMS');
        caseList.add(case75);
        
        Case case8=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',origin='Web',
        //No_FCR_Reason__c='Not Trained',
        recordtypeid=ordersRT,Type='Order Changes',Order_Type__c = 'Spares',Product_Type__c = 'Bendix-King', Detail_type__c = null,
        cage_code__c = '123',Sales_Order_Number__c='test1234', classification__c = 'EMS');
        caseList.add(case8);
        
        Case case10=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',origin='Web',
        //No_FCR_Reason__c='Not Trained',
        recordtypeid=ordersRT,Type='Order Changes',Order_Type__c = 'Repair/Overhaul',
        cage_code__c = '97896',Sales_Order_Number__c='test1234', classification__c = 'EMS');
        caseList.add(case10);
        
        Case case11=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',origin='Web',
        //No_FCR_Reason__c='Not Trained',
        recordtypeid=ordersRT,Type='Order Changes',Order_Type__c = 'Repair/Overhaul',
        cage_code__c = '55939',Sales_Order_Number__c='test1234', classification__c = 'EMS');
        caseList.add(case11);
        
        Case case12=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',origin='Web',
        //No_FCR_Reason__c='Not Trained',
        recordtypeid=ordersRT,Type='Order Changes',Order_Type__c = 'Repair/Overhaul',
        cage_code__c = '22373',Sales_Order_Number__c='test1234', classification__c = 'EMS');
        caseList.add(case12);        
          
        insert caseList;        
        
        Test.stopTest();  
    }
    // HAN-0263 HealthCheck - End
    
    ///// Sprint 2
    static testmethod void TestCaseWorkflowDelegate5(){     
    
        
        Schema.DescribeSObjectResult CaseDesc = Schema.SObjectType.Case;
        Map<String,Schema.RecordTypeInfo> CasertMapByName = CaseDesc.getRecordTypeInfosByName();
        Schema.RecordTypeInfo CaseRTByName = CasertMapByName.get('Orders');
        ID ordersRT = CaseRTByName.getRecordTypeId();  
        
        
        TriggerInactive.testTrigger = true;
        //ID csoROTeamQ = [SELECT Type, Id FROM Group where type = 'Queue' and name ='CSO R&O Team' ].id;
        //try{       
        Map<String,QueueTeam__c> mapQueueID = QueueTeam__c.getALL();         
        Map<String,ClassificationList__c> mapClassification = ClassificationList__c.getALL();
        Map<String,SubClassList__c> mapSubClass = SubClassList__c.getALL();
        //}catch(Exception e){
        //System.debug('Exception while assigning the map variable in TestPreventCaseCreation Class'+e);
        //} 
        
        Profile pf= [select id from Profile where name = 'System Administrator'];
        User usr = new User(FirstName = 'API User', LastName = 'SFDC Cust Master',Username = 'testingsysadm@test.com',
        Email = 'testuser@newslett.com',Alias = 'apiuser' ,CommunityNickname= 'apiuser' ,TimeZoneSidKey = 'America/Los_Angeles',
        LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S');
        insert usr;  
        
        User usr1 = new User(FirstName = 'User', LastName = 'SFDC',Username = 'usersfdc@test.com',
        Email = 'testuser@newslett.com',Alias = 'sfdcuser' ,CommunityNickname= 'sfdcuser' ,TimeZoneSidKey = 'America/Los_Angeles',
        LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S');
        insert usr1;
          
        //creating account;
        Account acc= new Account(name='Test Account',ownerid=usr.id,Strategic_Business_Unit__c='ATR',CBT__c='Airlines',Service_Level__c='Comprehensive');
        insert acc;
        
        AccountTeamMember accTeammem = new AccountTeamMember(accountid=acc.id,userid=usr1.id);
        insert accTeamMem;
        
        //creating contact;
        Contact cont=new Contact(firstname='Test',LastName='Contact',AccountId=acc.Id,Phone_3__c='9986502495', Phone_Tree_Extn__c='1234',
        Contact_Is_Employee__c=true,  Contact_Status__c='Active', Employee_Contact_Role__c='Analyst',Employee_Number__c='E123567');
        insert cont;
        
        Portal_Honeywell_ID__c portalcont = new Portal_Honeywell_ID__c(name='Test',Contact__c=cont.id);
        insert portalcont;
        
        List<Case> caseList = new List<Case>();
        CaseRTByName = CasertMapByName.get('WEB Portal Registration');
        ID webRT = CaseRTByName.getRecordTypeId(); 
        
        
        Case case1=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',origin='Web',
        //No_FCR_Reason__c='Not Trained',
        recordtypeid=webRT,Type='WEB Portal Registration',Tool_name__c='MCORE',status='Open',
        cage_code__c = '1234',Sales_Order_Number__c='test1234',classification__c = 'EMS');
        insert case1;
        
        
        
        // Sprint 2- Only for Code Coverage - Start        
        //case1.ownerid=label.R_O_Basingstoke_Quotes_Queue_ID;
        //update case1;        
        // Sprint 2- Only for Code Coverage - End
        Test.startTest();
        case1.OwnerId = label.CSR_Online_Ordering_Approval_Queue;     
        case1.Status='Approved';
        update case1;
        
        Case case2=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', 
        Government_Compliance_SM_M_Content__c='No',origin='Email-GDC Accounts',recordtypeid=ordersRT,Type='Order Changes',
        Order_Type__c = 'Spares',Subject='OCD Updates 623',Sales_Order_Number__c='test1234',
        classification__c = 'EMS');
        caseList.add(case2);         
         
        Case case11=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
        origin='Web',recordtypeid=label.Order_recordtype,Sales_Order_Number__c='test1234', cage_code__c = '123',classification__c = 'EMS');
        //caseList.add(case11);
        insert case11; 
        TriggerInactive.testTrigger = true;////////////////////
        case11.Type='Place Order';
        case11.order_Type__c = 'Spares';
        case11.Product_type__c='Electrical';
        case11.detail_type__C='Detail part';       
        case11.country__c='Belarus';
        update case11;
        
        insert caseList;
        
        Test.stopTest();  
    }
    static testmethod void TestCaseWorkflowDelegate6(){
    
    
        List<Case> caseList = new List<Case>();
        
        Test.startTest();
          
        Account acc= new Account(name='Test Account',Strategic_Business_Unit__c='ATR',CBT__c='Airlines');
        insert acc;
        
        Contact cont=new Contact(firstname='Test',LastName='Contact',AccountId=acc.Id,Phone_3__c='9986502495', Phone_Tree_Extn__c='1234',
        Contact_Is_Employee__c=true,  Contact_Status__c='Active', Employee_Contact_Role__c='Analyst',Employee_Number__c='E123567');
        insert cont;
        
        Case case1=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
        origin='Web',recordtypeid=label.Order_recordtype,Type='Place Order',Order_Type__c = 'Spares',Product_type__c='Electrical',
        cage_code__c = '123',Sales_Order_Number__c='test1234',detail_type__C='Detail part', classification__c = 'EMS',country__c='Myanmar');
        caseList.add(case1);
        //insert case1;        
        //case1.country__c='Belarus';
        //update case1;
        
        Case case2=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
        origin='Web',recordtypeid=label.Order_recordtype,Type='Place Order',Order_Type__c = 'Spares',Product_type__c='Electrical',
        cage_code__c = '123',Sales_Order_Number__c='test1234',detail_type__C='Detail part', classification__c = 'EMS',country__c='Angola');        
        caseList.add(case2);
        
        Case case4=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
        origin='Web',recordtypeid=label.Order_recordtype,Type='Place Order',Order_Type__c = 'Spares',Product_type__c='Electrical',
        cage_code__c = '123',detail_type__C='Detail part',Sales_Order_Number__c='test1234', classification__c = 'EMS');
        caseList.add(case4);
        
        Case case5=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
        origin='Web',recordtypeid=label.Order_recordtype,Type='Place Order',Order_Type__c = 'Spares',Product_type__c='Electrical',
        cage_code__c = '123',detail_type__c='LRU',Sales_Order_Number__c='test1234', classification__c = 'EMS');
        caseList.add(case5);
        
        Case case6=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
        origin='Web',recordtypeid=label.Order_recordtype,Type='Place Order',Order_Type__c = 'Spares',Product_type__c='Electrical',
        cage_code__c = '123',detail_type__c='SPEX/Exchange',Sales_Order_Number__c='test1234', classification__c = 'EMS');
        caseList.add(case6);
                   
        Case case7=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
        origin='Web',recordtypeid=label.Order_recordtype,Type='Place Order',Order_Type__c = 'Spares',Product_type__c='Lighting',
        cage_code__c = '123',detail_type__c='Detail part',Sales_Order_Number__c='test1234', classification__c = 'EMS');
        caseList.add(case7);
        
        Case case8=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
        origin='Web',recordtypeid=label.Order_recordtype,Type='Place Order',Order_Type__c = 'Spares',Product_type__c='Mechanical',
        cage_code__c = '123',detail_type__c='Software',Sales_Order_Number__c='test1234', classification__c = 'EMS');
        caseList.add(case8);
        
        Case case9=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
        origin='Web',recordtypeid=label.Order_recordtype,Type='Place Order',Order_Type__c = 'Spares',Product_type__c='Bendix-King',
        cage_code__c = '123',detail_type__c='LRU', Sales_Order_Number__c='test1234',classification__c = 'EMS');
        caseList.add(case9);
        
        Case case10=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
        origin='Web',recordtypeid=label.Order_recordtype,Type='Place Order',Order_Type__c = 'Spares',Product_type__c='Bendix-King',
        cage_code__c = '123',detail_type__c='Detail part',Sales_Order_Number__c='test1234', classification__c = 'EMS');
        caseList.add(case10);
        
        Case case11=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
        origin='Web',recordtypeid=label.Order_recordtype,Type='Place Order',Order_Type__c = 'Spares',Product_Type__c = 'Wheels & Brakes', 
        Detail_Type__c ='LRU',cage_code__c = '121',Sales_Order_Number__c='test1234',classification__c = 'EMS');
        caseList.add(case11); 
        
        Case case12=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
        origin='Web',recordtypeid=label.Order_recordtype,Type='Place Order',Order_Type__c = 'Services',Product_Type__c = 'Lighting', 
        Detail_Type__c ='LRU',cage_code__c = '121',Sales_Order_Number__c='test1234', classification__c = 'EMS');
        caseList.add(case12);         
        Case case13=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
        origin='Web',recordtypeid=label.Order_recordtype,Type='Place Order',Order_Type__c = 'Services',Product_Type__c = 'Bendix-King', 
        Detail_Type__c ='LRU',cage_code__c = '121',Sales_Order_Number__c='test1234', classification__c = 'EMS');
        caseList.add(case13); 
        Case case14=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
        origin='Web',recordtypeid=label.Order_recordtype,Type='Place Order',Order_Type__c = 'Services',Product_Type__c = 'Wheels & Brakes', 
        Detail_Type__c ='LRU',cage_code__c = '121',Sales_Order_Number__c='test1234', classification__c = 'EMS');
        caseList.add(case14); 
        Case case15=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
        origin='Web',recordtypeid=label.Order_recordtype,Type='Place Order',Order_Type__c = 'Services',Product_Type__c = 'Electrical', 
        Detail_Type__c ='LRU',cage_code__c = '121',Sales_Order_Number__c='test1234', classification__c = 'EMS');
        caseList.add(case15); 
        
        
        Case case16=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
        origin='Web',recordtypeid=label.Order_recordtype,Type='Place Order',Order_Type__c = 'Repair/Overhaul',Product_Type__c = 'Lighting', 
        Detail_Type__c ='LRU',cage_code__c = '121',Sales_Order_Number__c='test1234',classification__c = 'EMS');
        caseList.add(case16);         
        Case case17=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
        origin='Web',recordtypeid=label.Order_recordtype,Type='Place Order',Order_Type__c = 'Repair/Overhaul',Product_Type__c = 'Bendix-King', 
        Detail_Type__c ='LRU',cage_code__c = '121',Sales_Order_Number__c='test1234', classification__c = 'EMS');
        caseList.add(case17); 
        Case case18=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
        origin='Web',recordtypeid=label.Order_recordtype,Type='Place Order',Order_Type__c = 'Repair/Overhaul',Product_Type__c = 'Wheels & Brakes', 
        Detail_Type__c ='LRU',cage_code__c = '121',Sales_Order_Number__c='test1234',classification__c = 'EMS');
        caseList.add(case18); 
        
        
        Case case19=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
        origin='Web',recordtypeid=label.Order_recordtype,Type='Place Order',Order_Type__c = 'Spares',Product_type__c='Bendix-King',
        cage_code__c = '55939',detail_type__c='Detail part',Sales_Order_Number__c='test1234', classification__c = 'EMS');
        caseList.add(case19);        
        insert caseList;
        
        
    
        Test.stopTest();
    }
   static testmethod void TestCaseWorkflowDelegate7(){
        /// To cover Case_provideAccess
        
        Profile pf= [select id from Profile where name = 'System Administrator'];

        User usr = new User(FirstName = 'UserTestUser', LastName = 'UserTestUser',Username = 'UserTestUser@test.com',
        Email = 'UserTestUser@newslett.com',Alias = 'apiuser' ,CommunityNickname= 'utu' ,TimeZoneSidKey = 'America/Los_Angeles',
        LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S');
        insert usr;
        
        Account acc= new Account(name='NO ACCOUNT FOUND',Strategic_Business_Unit__c='ATR',CBT__c='Airlines',Service_Level__c='Unauthorized Dist/Brkr');
        insert acc;
        
        Account acc1= new Account(name='Test Account',Strategic_Business_Unit__c='ATR',CBT__c='Airlines',Service_Level__c='Unauthorized Dist/Brkr');
        insert acc1;
        
        AccountTeamMember accTeamMem = new AccountTeamMember(userid=usr.id,TeamMemberRole='Field Service Engineer'
            ,accountid=acc.id );
        insert accTeamMem ;
            
        Contact cont=new Contact(firstname='Test',LastName='Contact',AccountId=acc.Id,Phone_3__c='9986502495', Phone_Tree_Extn__c='1234',
        Contact_Is_Employee__c=true,  Contact_Status__c='Active', Employee_Contact_Role__c='Analyst',Employee_Number__c='E123567');
        insert cont;
        
        Case cases = new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='Undetermined', Government_Compliance_SM_M_Content__c='Undetermined',
        //No_FCR_Reason__c='Not Trained',
        recordtypeid=label.Order_recordtype,origin='Email',classification__c = 'CSO Spares',Type='Order');
        insert cases;
       
        
        ///
    
    }
    static testmethod void TestCaseWorkflowDelegate8(){     
    
        
        Schema.DescribeSObjectResult CaseDesc = Schema.SObjectType.Case;
        Map<String,Schema.RecordTypeInfo> CasertMapByName = CaseDesc.getRecordTypeInfosByName();
        Schema.RecordTypeInfo CaseRTByName = CasertMapByName.get('Orders');
        ID ordersRT = CaseRTByName.getRecordTypeId();  
        
        
        TriggerInactive.testTrigger = true;
        //ID csoROTeamQ = [SELECT Type, Id FROM Group where type = 'Queue' and name ='CSO R&O Team' ].id;
        //try{       
        Map<String,QueueTeam__c> mapQueueID = QueueTeam__c.getALL();         
        Map<String,ClassificationList__c> mapClassification = ClassificationList__c.getALL();
        Map<String,SubClassList__c> mapSubClass = SubClassList__c.getALL();
        //}catch(Exception e){
        //System.debug('Exception while assigning the map variable in TestPreventCaseCreation Class'+e);
        //} 
        
        Profile pf= [select id from Profile where name = 'System Administrator'];
        User usr = new User(FirstName = 'API User', LastName = 'SFDC Cust Master',Username = 'testingsysadm@test.com',
        Email = 'testuser@newslett.com',Alias = 'apiuser' ,CommunityNickname= 'apiuser' ,TimeZoneSidKey = 'America/Los_Angeles',
        LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S');
        insert usr;  
        
        User usr1 = new User(FirstName = 'User', LastName = 'SFDC',Username = 'usersfdc@test.com',
        Email = 'testuser@newslett.com',Alias = 'sfdcuser' ,CommunityNickname= 'sfdcuser' ,TimeZoneSidKey = 'America/Los_Angeles',
        LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S');
        insert usr1;
          
        //creating account;
        Account acc= new Account(name='Test Account',ownerid=usr.id,Strategic_Business_Unit__c='ATR',CBT__c='Airlines',Service_Level__c='Comprehensive');
        insert acc;
                
        AccountTeamMember accTeammem = new AccountTeamMember(accountid=acc.id,userid=usr1.id);
        insert accTeamMem;
        
        //creating contact;
        Contact cont=new Contact(firstname='Test',LastName='Contact',AccountId=acc.Id,Phone_3__c='9986502495', Phone_Tree_Extn__c='1234',
        Contact_Is_Employee__c=true,  Contact_Status__c='Active', Employee_Contact_Role__c='Analyst',Employee_Number__c='E123567',Email='dhivya11.santhanakumar@nttdata.com');
        insert cont;
        
        Portal_Honeywell_ID__c portalcont = new Portal_Honeywell_ID__c(name='Test',Contact__c=cont.id);
        insert portalcont;
        
        List<Case> caseList = new List<Case>();
        CaseRTByName = CasertMapByName.get('WEB Portal Registration');
        ID webRT = CaseRTByName.getRecordTypeId(); 
        
        
        Case case1=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',origin='Web',
        //No_FCR_Reason__c='Not Trained',
        recordtypeid=webRT,Type='WEB Portal Registration',Tool_name__c='MCORE',status='Open',
        cage_code__c = '1234',classification__c = 'EMS');
        insert case1;
        
        
        Case case2=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',origin='Web',
        //No_FCR_Reason__c='Not Trained',
        recordtypeid=webRT,Type='WEB Portal Registration',Tool_name__c='MCORE',status='Open',
        cage_code__c = '1234',classification__c = 'Auto-COMM');
        insert case2;
        
        
        Test.startTest();
        Case1.recordTypeid=label.GDC_Accounts;      
        case1.Status='Approved';
        update case1;
           
        
        Case2.recordTypeid=label.GDC_Tech_Issue;      
        case2.Status='Approved';
        update case2;
                
        Test.stopTest();  
    }
    static testmethod void TestCaseWorkflowDelegate9(){     
    
        
        Schema.DescribeSObjectResult CaseDesc = Schema.SObjectType.Case;
        Map<String,Schema.RecordTypeInfo> CasertMapByName = CaseDesc.getRecordTypeInfosByName();
        Schema.RecordTypeInfo CaseRTByName = CasertMapByName.get('Orders');
        ID ordersRT = CaseRTByName.getRecordTypeId();  
        
        
        TriggerInactive.testTrigger = true;
        //ID csoROTeamQ = [SELECT Type, Id FROM Group where type = 'Queue' and name ='CSO R&O Team' ].id;
        //try{       
        Map<String,QueueTeam__c> mapQueueID = QueueTeam__c.getALL();         
        Map<String,ClassificationList__c> mapClassification = ClassificationList__c.getALL();
        Map<String,SubClassList__c> mapSubClass = SubClassList__c.getALL();
        //}catch(Exception e){
        //System.debug('Exception while assigning the map variable in TestPreventCaseCreation Class'+e);
        //} 
        
        Profile pf= [select id from Profile where name = 'System Administrator'];
        User usr = new User(FirstName = 'API User', LastName = 'SFDC Cust Master',Username = 'testingsysadm@test.com',
        Email = 'testuser@newslett.com',Alias = 'apiuser' ,CommunityNickname= 'apiuser' ,TimeZoneSidKey = 'America/Los_Angeles',
        LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S');
        insert usr;  
        
        User usr1 = new User(FirstName = 'User', LastName = 'SFDC',Username = 'usersfdc@test.com',
        Email = 'testuser@newslett.com',Alias = 'sfdcuser' ,CommunityNickname= 'sfdcuser' ,TimeZoneSidKey = 'America/Los_Angeles',
        LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S');
        insert usr1;
          
        //creating account;
        Account acc= new Account(name='Test Account',ownerid=usr.id,Strategic_Business_Unit__c='ATR',CBT__c='Airlines',Service_Level__c='Comprehensive');
        insert acc;
                
        AccountTeamMember accTeammem = new AccountTeamMember(accountid=acc.id,userid=usr1.id);
        insert accTeamMem;
        
        //creating contact;
        Contact cont=new Contact(firstname='Test',LastName='Contact',AccountId=acc.Id,Phone_3__c='9986502495', Phone_Tree_Extn__c='1234',
        Contact_Is_Employee__c=true,  Contact_Status__c='Active', Employee_Contact_Role__c='Analyst',Employee_Number__c='E123567',Email='dhivya11.santhanakumar@nttdata.com');
        insert cont;
        
        Portal_Honeywell_ID__c portalcont = new Portal_Honeywell_ID__c(name='Test',Contact__c=cont.id);
        insert portalcont;
        
        List<Case> caseList = new List<Case>();
        CaseRTByName = CasertMapByName.get('WEB Portal Registration');
        ID webRT = CaseRTByName.getRecordTypeId(); 
        
        
        Case case1=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',origin='Web',
        //No_FCR_Reason__c='Not Trained',
        recordtypeid=webRT,Type='WEB Portal Registration',Tool_name__c='MCORE',status='Open',
        cage_code__c = '1234', classification__c = 'EMS');
        insert case1;
        
        
        Case case2=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',origin='Web',
        //No_FCR_Reason__c='Not Trained',
        recordtypeid=webRT,Type='WEB Portal Registration',Tool_name__c='MCORE',status='Open',
        cage_code__c = '1234', classification__c = 'EMS');
        insert case2;
        
        
        Test.startTest();
        //case1.OwnerId = label.CSR_Online_Ordering_Approval_Queue; 
        Case1.recordTypeid=label.Web_Support_Rec_Type_ID;      
        case1.Status='Done';
        case1.type = 'MyAero web portal issue';
        update case1;
           
        
        Case2.recordTypeid=label.MSP_Contract;      
        case2.Status='Done';
        update case2;
        
        Case1.recordTypeid=label.NavDB_Accts;      
        case1.Status='Done';
        update case1;
        
                
        Test.stopTest();  
    }
    static testmethod void TestCaseWorkflowDelegate10(){     
    
        
        Schema.DescribeSObjectResult CaseDesc = Schema.SObjectType.Case;
        Map<String,Schema.RecordTypeInfo> CasertMapByName = CaseDesc.getRecordTypeInfosByName();
        Schema.RecordTypeInfo CaseRTByName = CasertMapByName.get('Orders');
        ID ordersRT = CaseRTByName.getRecordTypeId();  
        
        
        TriggerInactive.testTrigger = true;
        //ID csoROTeamQ = [SELECT Type, Id FROM Group where type = 'Queue' and name ='CSO R&O Team' ].id;
        //try{       
        Map<String,QueueTeam__c> mapQueueID = QueueTeam__c.getALL();         
        Map<String,ClassificationList__c> mapClassification = ClassificationList__c.getALL();
        Map<String,SubClassList__c> mapSubClass = SubClassList__c.getALL();
        //}catch(Exception e){
        //System.debug('Exception while assigning the map variable in TestPreventCaseCreation Class'+e);
        //} 
        
        Profile pf= [select id from Profile where name = 'System Administrator'];
        User usr = new User(FirstName = 'API User', LastName = 'SFDC Cust Master',Username = 'testingsysadm@test.com',
        Email = 'testuser@newslett.com',Alias = 'apiuser' ,CommunityNickname= 'apiuser' ,TimeZoneSidKey = 'America/Los_Angeles',
        LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S');
        insert usr;  
        
        User usr1 = new User(FirstName = 'User', LastName = 'SFDC',Username = 'usersfdc@test.com',
        Email = 'testuser@newslett.com',Alias = 'sfdcuser' ,CommunityNickname= 'sfdcuser' ,TimeZoneSidKey = 'America/Los_Angeles',
        LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S');
        insert usr1;
          
        //creating account;
        Account acc= new Account(name='Test Account',ownerid=usr.id,Strategic_Business_Unit__c='ATR',CBT__c='Airlines',Service_Level__c='Comprehensive');
        insert acc;
                
        AccountTeamMember accTeammem = new AccountTeamMember(accountid=acc.id,userid=usr1.id);
        insert accTeamMem;
        
        //creating contact;
        Contact cont=new Contact(firstname='Test',LastName='Contact',AccountId=acc.Id,Phone_3__c='9986502495', Phone_Tree_Extn__c='1234',Last_Survey_Date__c=date.parse('5/6/2015'),
        Contact_Is_Employee__c=true,  Contact_Status__c='Active', Employee_Contact_Role__c='Analyst',Employee_Number__c='E123567',Email='dhivya11.santhanakumar@nttdata.com');
        insert cont;
        
        Portal_Honeywell_ID__c portalcont = new Portal_Honeywell_ID__c(name='Test',Contact__c=cont.id);
        insert portalcont;
        
        List<Case> caseList = new List<Case>();
        CaseRTByName = CasertMapByName.get('WEB Portal Registration');
        ID webRT = CaseRTByName.getRecordTypeId(); 
        
        
        Case case1=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',origin='Web',
        //No_FCR_Reason__c='Not Trained',
        recordtypeid=webRT,Type='WEB Portal Registration',Tool_name__c='MCORE',status='Open',
        cage_code__c = '1234', classification__c = 'EMS');
        insert case1;
        
        
        Case case2=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',origin='Web',
        //No_FCR_Reason__c='Not Trained',
        recordtypeid=webRT,Type='WEB Portal Registration',Tool_name__c='MCORE',status='Open',
        cage_code__c = '1234', classification__c = 'EMS');
        insert case2;
        
        
        Test.startTest();
        Case1.recordTypeid=label.NavDB_Accts;      
        case1.Status='Done';
        update case1;
           
        
        Case2.recordTypeid=label.HAPP_Accts;      
        case2.Status='Closed';
        case2.Sub_Status__c='Cancelled';
        update case2;
        
        case1.recordTypeid=label.GDC_Call;
         case1.Status='Done';
        update case1;
                        
        Test.stopTest();  
    }
         ///// Sprint 2 /////
         static testmethod void TestCaseWorkflowDelegate11(){     
    
        
        Schema.DescribeSObjectResult CaseDesc = Schema.SObjectType.Case;
        Map<String,Schema.RecordTypeInfo> CasertMapByName = CaseDesc.getRecordTypeInfosByName();
        Schema.RecordTypeInfo CaseRTByName = CasertMapByName.get('Orders');
        ID ordersRT = CaseRTByName.getRecordTypeId();  
        
        
        TriggerInactive.testTrigger = true;
        //ID csoROTeamQ = [SELECT Type, Id FROM Group where type = 'Queue' and name ='CSO R&O Team' ].id;
        //try{       
        Map<String,QueueTeam__c> mapQueueID = QueueTeam__c.getALL();         
        Map<String,ClassificationList__c> mapClassification = ClassificationList__c.getALL();
        Map<String,SubClassList__c> mapSubClass = SubClassList__c.getALL();
        //}catch(Exception e){
        //System.debug('Exception while assigning the map variable in TestPreventCaseCreation Class'+e);
        //} 
        
        Profile pf= [select id from Profile where name = 'System Administrator'];
        User usr = new User(FirstName = 'API User', LastName = 'SFDC Cust Master',Username = 'testingsysadm@test.com',
        Email = 'testuser@newslett.com',Alias = 'apiuser' ,CommunityNickname= 'apiuser' ,TimeZoneSidKey = 'America/Los_Angeles',
        LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S');
        insert usr;  
        
        User usr1 = new User(FirstName = 'User', LastName = 'SFDC',Username = 'usersfdc@test.com',
        Email = 'testuser@newslett.com',Alias = 'sfdcuser' ,CommunityNickname= 'sfdcuser' ,TimeZoneSidKey = 'America/Los_Angeles',
        LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S');
        insert usr1;
          
        //creating account;
        Account acc= new Account(name='Test Account',ownerid=usr.id,Strategic_Business_Unit__c='ATR',CBT__c='Airlines',Service_Level__c='Comprehensive');
        insert acc;
                
        AccountTeamMember accTeammem = new AccountTeamMember(accountid=acc.id,userid=usr1.id);
        insert accTeamMem;
        
        //creating contact;
        Contact cont=new Contact(firstname='Test',LastName='Contact',AccountId=acc.Id,Phone_3__c='9986502495', Phone_Tree_Extn__c='1234',Last_Survey_Date__c=date.parse('5/6/2016'),
        Contact_Is_Employee__c=true,  Contact_Status__c='Active', Employee_Contact_Role__c='Analyst',Employee_Number__c='E123567',Email='dhivya11.santhanakumar@nttdata.com');
        insert cont;
        
        Portal_Honeywell_ID__c portalcont = new Portal_Honeywell_ID__c(name='Test',Contact__c=cont.id);
        insert portalcont;
        
        List<Case> caseList = new List<Case>();
        CaseRTByName = CasertMapByName.get('WEB Portal Registration');
        ID webRT = CaseRTByName.getRecordTypeId(); 
        
        
        Case case1=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',origin='Web',
        //No_FCR_Reason__c='Not Trained',
        recordtypeid=webRT,Type='WEB Portal Registration',Tool_name__c='MCORE',status='Open',
        cage_code__c = '1234', classification__c = 'EMS');
        insert case1;
        
        
        Case case2=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',origin='Web',
        //No_FCR_Reason__c='Not Trained',
        recordtypeid=webRT,Type='WEB Portal Registration',Tool_name__c='MCORE',status='Open',
        cage_code__c = '1234', classification__c = 'EMS');
        insert case2;
        
        
        Test.startTest();
        
        Case2.recordTypeid=label.HAPP_Accts;      
        case2.Status='Closed';
        case2.Sub_Status__c='Cancelled';
        update case2;
        
        Test.stopTest();  
    }
    static testmethod void TestCaseWorkflowDelegate12(){     
    
        
        Schema.DescribeSObjectResult CaseDesc = Schema.SObjectType.Case;
        Map<String,Schema.RecordTypeInfo> CasertMapByName = CaseDesc.getRecordTypeInfosByName();
        Schema.RecordTypeInfo CaseRTByName = CasertMapByName.get('Orders');
        ID ordersRT = CaseRTByName.getRecordTypeId();  
        
        
        TriggerInactive.testTrigger = true;
        //ID csoROTeamQ = [SELECT Type, Id FROM Group where type = 'Queue' and name ='CSO R&O Team' ].id;
        //try{       
        Map<String,QueueTeam__c> mapQueueID = QueueTeam__c.getALL();         
        Map<String,ClassificationList__c> mapClassification = ClassificationList__c.getALL();
        Map<String,SubClassList__c> mapSubClass = SubClassList__c.getALL();
        //}catch(Exception e){
        //System.debug('Exception while assigning the map variable in TestPreventCaseCreation Class'+e);
        //} 
        
        Profile pf= [select id from Profile where name = 'System Administrator'];
        User usr = new User(FirstName = 'Salesforce', LastName = 'Customer Master',Username = 'testingsysadm@test.com',
        Email = 'testuser@newslett.com',Alias = 'apiuser' ,CommunityNickname= 'apiuser' ,TimeZoneSidKey = 'America/Los_Angeles',
        LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S');
        insert usr;  
        
        User usr1 = new User(FirstName = 'User', LastName = 'SFDC',Username = 'usersfdc@test.com',
        Email = 'testuser@newslett.com',Alias = 'sfdcuser' ,CommunityNickname= 'sfdcuser' ,TimeZoneSidKey = 'America/Los_Angeles',
        LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S');
        insert usr1;
          
        //creating account;
        Account acc= new Account(name='Test Account',ownerid=usr.id,Strategic_Business_Unit__c='ATR',CBT__c='Airlines',CBT_Team__c='Americas',Service_Level__c='Comprehensive');
        insert acc;
                
        AccountTeamMember accTeammem = new AccountTeamMember(accountid=acc.id,userid=usr1.id);
        insert accTeamMem;
        
        acc.CBT_Team__c='EMEAI ATR';
        update acc;
        
        acc.CBT_Team__c='Americas';
        update acc;
        
        //creating contact;
        Contact cont=new Contact(firstname='Test',LastName='Contact',AccountId=acc.Id,Phone_3__c='9986502495', Phone_Tree_Extn__c='1234',Last_Survey_Date__c=date.parse('5/6/2016'),
        Contact_Is_Employee__c=true,  Contact_Status__c='Active', Employee_Contact_Role__c='Analyst',Employee_Number__c='E123567',Email='dhivya11.santhanakumar@honeywell.com');
        insert cont;
        
        Portal_Honeywell_ID__c portalcont = new Portal_Honeywell_ID__c(name='Test',Contact__c=cont.id);
        insert portalcont;
        
        List<Case> caseList = new List<Case>();
        CaseRTByName = CasertMapByName.get('WEB Portal Registration');
        ID webRT = CaseRTByName.getRecordTypeId(); 
        
        Test.startTest();
        Case case1=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',origin='Web',
        //No_FCR_Reason__c='Not Trained',
        recordtypeid=webRT,Type='WEB Portal Registration',Tool_name__c='MCORE',status='Open',
        cage_code__c = '1234', classification__c = 'EMS');
        insert case1;
        
        
         Test.stopTest();  
    }*/
       
}