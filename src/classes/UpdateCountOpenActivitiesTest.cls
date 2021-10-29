@isTest
public class UpdateCountOpenActivitiesTest{
    
    static testMethod void myUniTest(){
        
        Integer eCount = 0;
        List<Case> cases=new List<Case>();
        List<Task> task1=new List<Task>();
        List<Case> casetoUpdate= new List<Case>();
        TriggerInactive.testTrigger = false;
        Account acc = new Account();
        acc.Name = 'Honeywell Test';
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'ATR';
        acc.CBT__c = 'Airbus';
        acc.Region_Name__c = 'Americas';
        acc.Sub_Region_Name__c = 'Canada';
        acc.Service_Level__c = 'Standard';
        acc.Type = 'OEM';
        acc.REPORT_ACCOUNT_NAME__c = 'HONEYWELL TEST';
        try {
            insert acc;
        }catch(Exception ex){}
        
        Contact con = new Contact();
        con.FirstName = 'KapilM';
        con.LastName = 'Singh';
        con.AccountId = acc.Id;
        con.Primary_Email_Address__c = 'kapil.nowhere13@gmail.com';
        con.Email='kapil.nowhere12@gmail.com';
        try {
            insert con;
        }catch(Exception ex){}
        
        if(con.FirstName == NULL){con.FirstName = 'KapilM1';try {update con;}Catch(Exception ex){}}
        
        Case cs = new Case();
        cs.Origin = 'Phone';
        cs.Status = 'Open';
        if(con.Id != NULL || con.Id != ''){
            cs.ContactId = con.Id;
        }
        else {
            cs.ContactId = [Select Id from Contact limit 1].Id;
        }
        cs.Classification__c = 'GTO Field Service';
        cs.HON_Commit_Date__c = System.now() + 1;
        cs.Export_Compliance_Content_ITAR_EAR__c = 'NO';
        cs.Government_Compliance_SM_M_Content__c = 'NO';
        //cs.No_FCR_Reason__c='Not Trained'; For Ticket INC000009687923
        try {
            insert cs;
        }catch(Exception ex){}
        
        UserRole role = [select Id, Name from UserRole where name = 'ALT' limit 1];
        
        Profile profile = [select id from Profile where name = 'System Administrator'];
        User manager = new User(LastName = 'Test Task Manager and Role',FirstName = 'TestFirstName', Username = 'testtaskmanagerandrole@test.com',
                                Email = 'testmanager@test.com',Alias = 'tm1' ,CommunityNickname= 'tmanager' ,
                                TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',
                                ProfileId = profile.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S');
        try {
            insert manager;
        }catch(Exception ex){}
        
        User manager1 = new User(LastName = 'Test Task Manager and Role',FirstName = 'TestFirstName', Username = 'testtaskmanagerandrole@test.com',
                                Email = 'testmanager@test.com',Alias = 'tm1' ,CommunityNickname= 'tmanager' ,
                                TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',
                                ProfileId = profile.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S');
        try {
            insert manager1;
        }catch(Exception ex){}
        
        Task task = new Task();
        task.OwnerId = manager.Id;
        task.Priority = 'Normal';
        task.Status = 'Open';
        task.Assigned_Manager__c = manager.Id;
        task.Assigned_Role__c = role.Id;
        task.whatId = cs.Id;
        try {
            insert task;
        }catch(Exception ex){}
        Task tasknew = new Task();
        tasknew.OwnerId = manager1.Id;
        tasknew.Priority = 'Normal';
        tasknew.Status = 'Open';
        tasknew.Assigned_Manager__c = manager.Id;
        tasknew.Assigned_Role__c = role.Id;
        tasknew.whatId = cs.Id;
        try {
            insert tasknew;
        }catch(Exception ex){}
        
        List<Id> updateTaskIds1=new List<Id>();
        
        String parent=task.whatId;
        if(parent!=null){
            parent=parent.substring(0,3);
            if(parent=='500'){
                updateTaskIds1.add(task.whatId);
            }
        }   
        
        
        List<Id> deletedList=new List<Id>();
        
        String parents=tasknew.whatId;
        if(parents!=null){
            parents=parents.substring(0,3);
            if(parents=='500'){
                deletedList.add(tasknew.whatId);
            }
        }   
        
        
        
        /*if(cases.size()>0){
            for(integer i=0;i<cases.size();i++){
                eCount = 0;
                for(Integer j=0;j<task1.size();j++){ 
                    if(cases[i].Id == task1[j].whatId){
                        eCount = eCount + 1;   
                    }
                }
                //cases[i].Email_Count__c=eCount;
                cases[i].of_Open_Activity__c=eCount;
                casetoUpdate.add(cases[i]);
            }
        }*/
        /*if(casetoUpdate.size()>0){
            try{
                update casetoUpdate;
            }catch(Exception e){
            }
        }*/
        UpdateCountOpenActivities uc = new UpdateCountOpenActivities();
        UpdateCountOpenActivities.updateCountOpenActivity(updateTaskIds1, deletedList);
    }
}