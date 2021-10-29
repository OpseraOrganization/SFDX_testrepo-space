@isTest 
private class CreateSalesCompetencyRatings_Test {
    static testMethod void CreateSalesCompetencyRatings_Test() {
        
        User u = [ select Id from User where id =: UserInfo.getUserId() ];
        
        Sales_Competency__c sc = new Sales_Competency__c();
        sc.user__c = u.id;
        sc.Job_Title__c = 'sales';
        sc.Status__c = 'Self Assessment (Employee)';
        sc.Role_Category__c = 'A';
        sc.Job_Category__c = 'Sales';
        sc.Name = 'test';
        sc.Level_1_Manager__c = u.id;
       
        insert sc;
    }
    
    static testMethod void CreateSalesCompetencyRatings_Test2() {
        
        User u = [ select Id from User where id =: UserInfo.getUserId() ];
        
        Sales_Competency__c sc = new Sales_Competency__c();
        sc.user__c = u.id;
        sc.Job_Title__c = 'sales';
        sc.Status__c = 'Self Assessment (Employee)';
        sc.Role_Category__c = 'A';
        sc.Job_Category__c = 'Sales Support';
        sc.Name = 'test';
        sc.Level_1_Manager__c = u.id;
       
        insert sc;
        
        sc.Status__c = 'Draft (Manager)';
        update sc;
    }
    
    static testMethod void CreateSalesCompetencyRatings_Test3() {
        
        User u = [ select Id from User where id =: UserInfo.getUserId() ];
        
        Sales_Competency__c sc = new Sales_Competency__c();
        sc.user__c = u.id;
        sc.Job_Title__c = 'sales';
        sc.Status__c = 'Self Assessment (Employee)';
        sc.Role_Category__c = 'A';
        sc.Job_Category__c = 'Sales Leader';
        sc.Name = 'test';
        sc.Level_1_Manager__c = u.id;
       
        insert sc;
        
        sc.Status__c = 'Draft (Manager)';
        update sc;
    }
}