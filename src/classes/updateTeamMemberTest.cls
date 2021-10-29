@istest
  
    public class updateTeamMemberTest{
    
        testmethod static void updateTeamtest1(){

         
          Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
         
          User us3 = new User(Alias = 'standt@3', Email='standarduser3@testforceorg.com', 
          EmailEncodingKey='UTF-8', LastName='Testing@3', LanguageLocaleKey='en_US', 
          LocaleSidKey='en_US', ProfileId = p.Id, 
          TimeZoneSidKey='America/Los_Angeles', UserName='standarduser3@forceorg.com');
          insert us3;
          system.debug('user 11@@'+us3); 
          
          User us2 = new User(Alias = 'standt@2', Email='standarduser2@testforceorg.com', 
          EmailEncodingKey='UTF-8', LastName='Testing@2', LanguageLocaleKey='en_US', 
          LocaleSidKey='en_US', ProfileId = p.Id, 
          TimeZoneSidKey='America/Los_Angeles', UserName='standarduser2@forceorg.com');
          insert us2;
          system.debug('user 11@@'+us2);
          
           User us1 = new User(Alias = 'standt@1', Email='standarduser1@testforceorg.com', 
        EmailEncodingKey='UTF-8', LastName='Contact', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='standarduser1@forceorg.com');
         insert us1;
         system.debug('user 11@@'+us1);
         
           User us4 = new User(Alias = 'standt@4', Email='standarduser4@testforceorg.com', 
        EmailEncodingKey='UTF-8', LastName='Contact', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='standarduser4@forceorg.com');
         insert us4;
         system.debug('user 11@@'+us4);
         
           User us5 = new User(Alias = 'standt@5', Email='standarduser5@testforceorg.com', 
        EmailEncodingKey='UTF-8', LastName='Contact', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='standarduser5@forceorg.com');
         insert us5;
         system.debug('user 11@@'+us5);
         
           Account acc=new account(Name='Test Account',Strategic_Business_Unit__c='ATR',REPORT_ACCOUNT_NAME__c='Test Account');
         
           Insert acc;
         
            
           
           
             Contact con1=new Contact(LastName='Contact1',AccountId =acc.id,Email='standarduser3@testforceorg.com');
                try{
                Insert con1;
                }catch(exception e){
                
                }
                
               Contact con2=new Contact(LastName='Contact2',AccountId =acc.id,Email='standarduser2@testforceorg.com');
               try{
                Insert con2;
                }catch(exception e){
                
                }
                
                Contact con3=new Contact(LastName='Contact3',AccountId =acc.id,Email='standarduser4@testforceorg.com');
               try{
                Insert con3;
                }catch(exception e){
                
                }
                
                Contact con4=new Contact(LastName='Contact4',AccountId =acc.id,Email='standarduser5@testforceorg.com');
               try{
                Insert con4;
                }catch(exception e){
                
                }
                
                 
                acc.Customer_Support_Focal__c=con1.id;
                acc.Business_Focal__c=con2.id;
                acc.Area_Sales_Mgr__c =us1.id;
                acc.Customer_Support_Escalation__c = con3.id;
                acc.Business_Escalation__c = con4.id;
                Update acc;
            
                acc.Customer_Support_Focal__c=null;
                acc.Business_Focal__c=null;
                acc.Area_Sales_Mgr__c =null;
                acc.Customer_Support_Escalation__c = null;
                acc.Business_Escalation__c = null;
                Update acc;
               
                       
     
        
        
        }
        
   
  }