@isTest
private class new_solution_class_edit_TestClass{

static testMethod void new_solution_class_edit_TM()
 {
   /* Solution newsol = [select id,SolutionName,SolutionNumber,Status,Categorization__c,
    Product_Support_Engineer_Email__c,SBL_Solution_Legacy_Number__c,RecordTypeid,Approved_Date__c,
    Export_Controlled__c,Secure_Notes__c,FAQ__c,SolutionNote,Product_Type__c,Catalog_Product_Group__c,
    Supported_Product__c,Primary__c,Secondary__c,Product_Number__c,Audit_Frequency__c,Publish_Internal__c,
    Intellectual_Property_Review_By__c,Export_Review_Complete_NLR__c,
    Export_Review_Date__c,Expiration_Date__c,Publish_External__c,Intellectual_Property_Review_Date__c,
    Export_Review_By__c,Standards_Review_Approved_By__c,Technical_Review_Audit_Approved_By__c,
    Technical_Review_Approved_By__c,Approver__c,Approver_Name__c,Rejected_By__c,Legacy_Created_by__c,
    Legacy_Created_Date__c,Legacy_Solution_Approval_Date__c,Legacy_Last_Modified_by__c,
    Legacy_Last_Modifed_Date__c from solution where SolutionName != null and
    Export_Controlled__c !='Yes' limit 1];
    
    */
    
     
     /*  Profile pf= [select id from Profile where name = 'System Administrator'];
 User u1 = new User(LastName = 'Test User',Username = 'testuser@test.com.honeywell122',Email = 'testuser@test.com',Alias = 'tu6767' ,CommunityNickname= 'tuser454' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 'en_US',Functional_Role__c='testroleuser');
insert u1;   


  User usr = new User(LastName = 'Test UserSol1',Username = 'tu1cso@test.com',
  Email = 'testuser@test.com',Alias = 'tu1' ,CommunityNickname= 'tu1sol1' ,
  TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',
  ProfileId = pf.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S');
  insert usr;

     */
     
         
    Solution newsol= new solution(SolutionName ='Sample',Catalog_Product_Group__c='Displays(BK)',FAQ__c='test',
    Secure_Notes__c='test', Export_Review_Date__c=System.today(),Supported_Product__c='AV8OR', 
    Export_Review_By__c=UserInfo.getUserId()); 
    insert newsol;
    
    
    
    
    
    




    
    ApexPages.CurrentPage().getParameters().Put('id',newsol.id); 
    ApexPages.CurrentPage().getParameters().Put('solno',newsol.SolutionNumber);   
    ApexPages.StandardController std = new ApexPages.StandardController(newsol);  
    new_solution_class_edit test1 = new new_solution_class_edit(std);
            
    List<Platform__c> plat = [select id, Name from platform__c where name like  'A%' limit 1];
    System.debug(plat);   
   
    test1.getsolno();
    test1.list2 = 'A-E';
    test1.navigate();
    test1.list2 = 'F-J';
    test1.navigate();
    test1.list2 = 'K-O';
    test1.navigate();
    test1.list2 = 'P-T';
    test1.navigate();
    test1.list2 = 'U-Z';
    test1.navigate();
    test1.docancel();
    test1.dosave();
    test1.doSaveandNew();
    test1.list1 = plat;
    test1.getvalues();
    test1.getlist1();
        
    boolean b = test1.getevallist();
    solution s = test1.getsol();
    test1.setsol(s);
       
     
 /*   Solution sol2= new solution(SolutionName ='Sample',Catalog_Product_Group__c='',FAQ__c='test',
    Secure_Notes__c='test', Export_Review_Date__c=System.today(),
    Export_Review_By__c=UserInfo.getUserId()); 
    insert sol2;
    
    system.debug('SOL2'+sol2.Supported_Product__c);
    ApexPages.CurrentPage().getParameters().Put('id',sol2.id);
    ApexPages.CurrentPage().getParameters().Put('solno',sol2.SolutionNumber);
    ApexPages.StandardController std2 = new ApexPages.StandardController(sol2);  
    new_solution_class_edit test2 = new new_solution_class_edit(std2);
    
    List<Platform__c> plat2 = [select id, Name from platform__c where name like  'A%' limit 1];
    
    test2.getsolno();
    test2.list2 = 'A-E';
    test2.navigate();
    test2.list2 = 'F-J';
    test2.navigate();
    test2.list2 = 'K-O';
    test2.navigate();
    test2.list2 = 'P-T';
    test2.navigate();
    test2.list2 = 'U-Z';
    test2.navigate();
    test2.docancel();
    test2.dosave();
    test2.doSaveandNew();
    test2.list1 = plat2;
    test2.getvalues();
    test2.getlist1();
        
    boolean b2 = test2.getevallist();
    solution s2 = test2.getsol();
    test2.setsol(s2);


    Solution sol3= new solution(SolutionName ='Sample',Catalog_Product_Group__c='Displays(BK)',
    FAQ__c='test',Supported_Product__c='',
    Secure_Notes__c='test', Export_Review_Date__c=System.today(),
 Export_Review_By__c=UserInfo.getUserId()); 
    insert sol3;
    
    ApexPages.CurrentPage().getParameters().Put('id',sol3.id);
    ApexPages.CurrentPage().getParameters().Put('solno',sol3.SolutionNumber);
    ApexPages.StandardController std3 = new ApexPages.StandardController(sol3);  
    new_solution_class_edit test3 = new new_solution_class_edit(std3);
    
    List<Platform__c> plat3 = [select id, Name from platform__c where name like  'A%' limit 1];
    
    test3.getsolno();
    test3.list2 = 'A-E';
    test3.navigate();
    test3.list2 = 'F-J';
    test3.navigate();
    test3.list2 = 'K-O';
    test3.navigate();
    test3.list2 = 'P-T';
    test3.navigate();
    test3.list2 = 'U-Z';
    test3.navigate();
    test3.docancel();
    test3.dosave();
    test3.doSaveandNew();
    test3.list1 = plat3;
    test3.getvalues();
    test3.getlist1();
        
    boolean b3 = test3.getevallist();
    solution s3 = test3.getsol();
    test3.setsol(s3);
    
    Solution sol4= new solution(SolutionName ='Sample',Product_Type__c='Bendix-King',
    Catalog_Product_Group__c='Displays(BK)',Supported_Product__c='AV8OR',Export_Controlled__c='yes',
    FAQ__c='test',Secure_Notes__c='test',  Export_Review_Date__c=System.today(),
 Export_Review_By__c=UserInfo.getUserId()); 
    insert sol4;
    
    ApexPages.CurrentPage().getParameters().Put('id',sol4.id);
    ApexPages.CurrentPage().getParameters().Put('solno',sol4.SolutionNumber);
    ApexPages.StandardController std4 = new ApexPages.StandardController(sol4);  
    new_solution_class_edit test4 = new new_solution_class_edit(std4);
    
    List<Platform__c> plat4 = [select id, Name from platform__c where name like  'A%' limit 1];
    
    test4.getsolno();
    test4.list2 = 'A-E';
    test4.navigate();
    test4.list2 = 'F-J';
    test4.navigate();
    test4.list2 = 'K-O';
    test4.navigate();
    test4.list2 = 'P-T';
    test4.navigate();
    test4.list2 = 'U-Z';
    test4.navigate();
    test4.docancel();
    test4.dosave();
    test4.doSaveandNew();
    test4.list1 = plat4;
    test4.getvalues();
    test4.getlist1();
   
    boolean b4 = test4.getevallist();
    solution s4 = test4.getsol();
    test4.setsol(s4);
    
  
    Solution sol5= new solution( SolutionName ='Sample',Product_Type__c='Bendix-King',
    Catalog_Product_Group__c='Displays(BK)',Supported_Product__c='AV8OR',
    Export_Controlled__c='yes',FAQ__c='test',Publish_External__c = TRUE,
    Secure_Notes__c='test', Export_Review_Date__c=System.today(),
    Export_Review_By__c=UserInfo.getUserId()); 
    insert sol5;
    
    ApexPages.CurrentPage().getParameters().Put('id',sol5.id);
    ApexPages.CurrentPage().getParameters().Put('solno',sol5.SolutionNumber);
    ApexPages.StandardController std5 = new ApexPages.StandardController(sol5);  
    new_solution_class_edit test5 = new new_solution_class_edit(std5);
    
    List<Platform__c> plat5 = [select id, Name from platform__c where name like  'A%' limit 1];
    
    test5.getsolno();
    test5.list2 = 'A-E';
    test5.navigate();
    test5.list2 = 'F-J';
    test5.navigate();
    test5.list2 = 'K-O';
    test5.navigate();
    test5.list2 = 'P-T';
    test5.navigate();
    test5.list2 = 'U-Z';
    test5.navigate();
    test5.docancel();
    test5.dosave();
    test5.doSaveandNew();
    test5.list1 = plat5;
    test5.getvalues();
    test5.getlist1();
     
    boolean b5 = test5.getevallist();
    solution s5 = test5.getsol();
    test5.setsol(s5);    
      
      
    Solution sol6= new solution(Secure_Notes__c='testing', SolutionName ='Sample',
    Product_Type__c='Bendix-King',Catalog_Product_Group__c='Displays(BK)',Supported_Product__c='AV8OR',
    Export_Controlled__c='yes',FAQ__c='test',Publish_External__c = TRUE,
 Export_Review_Date__c=System.today(),
 Export_Review_By__c=UserInfo.getUserId()); 
    insert sol6;
    ApexPages.CurrentPage().getParameters().Put('id',sol6.id);
    ApexPages.CurrentPage().getParameters().Put('solno',sol6.SolutionNumber);
    ApexPages.StandardController std6 = new ApexPages.StandardController(sol6);  
    new_solution_class_edit test6 = new new_solution_class_edit(std6);
    
    List<Platform__c> plat6 = [select id, Name from platform__c where name like  'A%' limit 1];
    
    test6.getsolno();
    test6.list2 = 'A-E';
    test6.navigate();
    test6.list2 = 'F-J';
    test6.navigate();
    test6.list2 = 'K-O';
    test6.navigate();
    test6.list2 = 'P-T';
    test6.navigate();
    test6.list2 = 'U-Z';
    test6.navigate();
    test6.docancel();
    test6.dosave();
    test6.doSaveandNew();
    test6.list1 = plat6;
    test6.getvalues();
    test6.getlist1();
    
    boolean b6 = test6.getevallist();
    solution s6 = test6.getsol();
    test6.setsol(s6);  
    
    
    Solution sol7= new solution(Secure_Notes__c='testing',
    SolutionName ='Sample',Product_Type__c='Bendix-King',Catalog_Product_Group__c='Displays(BK)',
    Supported_Product__c='AV8OR',Export_Controlled__c='yes',FAQ__c='test',Publish_External__c = TRUE,
     Export_Review_Date__c=System.today(),
    Export_Review_By__c=UserInfo.getUserId()); 
    insert sol7;
    ApexPages.CurrentPage().getParameters().Put('id',sol7.id);
    ApexPages.CurrentPage().getParameters().Put('solno',sol7.SolutionNumber);
    ApexPages.StandardController std7 = new ApexPages.StandardController(sol7);  
    new_solution_class_edit test7 = new new_solution_class_edit(std7);
    
    List<Platform__c> plat7 = [select id, Name from platform__c where name like  'A%' limit 1];
    
    test7.getsolno();
    test7.list2 = 'A-E';
    test7.navigate();
    test7.list2 = 'F-J';
    test7.navigate();
    test7.list2 = 'K-O';
    test7.navigate();
    test7.list2 = 'P-T';
    test7.navigate();
    test7.list2 = 'U-Z';
    test7.navigate();
    test7.docancel();
    test7.dosave();
    test7.doSaveandNew();
    test7.list1 = plat7;
    test7.getvalues();
    test7.getlist1();
    
    boolean b7 = test7.getevallist();
    solution s7 = test7.getsol();
    test7.setsol(s7);*/
  }
}