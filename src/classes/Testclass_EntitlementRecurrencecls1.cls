@isTest
    public class Testclass_EntitlementRecurrencecls1{

        public static testmethod void Test_EntitlementRecurrencecls1(){
            Entitlement__c Ent1 = new Entitlement__c();
            test.starttest();
              Account acc= new Account(name = 'Test Account',Market_name__C = 'Military');
                insert acc;
              Contract cont= new Contract (name='Test',accountId= acc.Id);
                insert cont;
              Entitlement__c Ent= New Entitlement__c();
               Ent.Contract_Number__c = cont.id; 
               Ent.Entitlement_Start_Date__c = system.today()-3;
               Ent.End_Date__c =system.today()-1;
                insert Ent;
            
              PageReference pageRef = page.EntitlementRecurrence1;
                 
                pageRef.getParameters().put('Contract',cont.Id);   
                pageRef.getParameters().put('Entitlement',Ent.Id); 
                Test.setCurrentPage(pageRef);
                ApexPages.StandardController std = new ApexPages.StandardController(Ent);
                
                EntitlementRecurrencecls1 cont1 = new EntitlementRecurrencecls1(std);
                 cont1.Noc =2;
                 cont1.Recurencetype = 'yearly';
                 cont1.datename1 = system.today(); 
                 cont1.edit();
                 cont1.save1();
                EntitlementRecurrencecls1 cont2 = new EntitlementRecurrencecls1(std);
                 cont2.Noc = 0;
                 cont2.datename = system.today().addyears(1);
                 cont2.Recurencetype = 'yearly';
                 cont2.datename1 = system.today();
                 cont2.save1();
                     
            test.stopTest();
        }
                  
        public static testmethod void Test1_EntitlementRecurrencecls1(){
            Entitlement__c Ent1 = new Entitlement__c();
            test.starttest();
            Account acc= new Account(name = 'Test Account',Market_name__C = 'Military');
                insert acc;
            Contract cont= new Contract (name='Test',accountId= acc.Id);
                insert cont;
            Entitlement__c Ent= New Entitlement__c();
               Ent.Contract_Number__c = cont.id; 
               Ent.Entitlement_Start_Date__c = system.today()-3;
               Ent.End_Date__c =system.today()-1;
               insert Ent;
            PageReference pageRef = page.EntitlementRecurrence1;
                pageRef.getParameters().put('Contract',cont.Id);   
                pageRef.getParameters().put('Entitlement',Ent.Id); 
                Test.setCurrentPage(pageRef);
                ApexPages.StandardController std = new ApexPages.StandardController(Ent);
                
                EntitlementRecurrencecls1 cont1 = new EntitlementRecurrencecls1(std);
                cont1.Noc =2;
                cont1.Recurencetype = 'Monthly';
                cont1.datename1 = system.today(); 
                cont1.edit();
                cont1.save1();
                EntitlementRecurrencecls1 cont2 = new EntitlementRecurrencecls1(std);
                cont2.Recurencetype = 'Monthly';
                cont2.Noc = 0;
                cont2.datename1 = system.today();
                cont2.datename = system.today().addmonths(1);
                cont2.save1();
                    
            test.stopTest();
        }
                  
        public static testmethod void Test2_EntitlementRecurrencecls1(){
            Entitlement__c Ent1 = new Entitlement__c();
              
            test.starttest();
            Account acc= new Account(name = 'Test Account',Market_name__C = 'Military');
                insert acc;
            Contract cont= new Contract (name='Test',accountId= acc.Id);
                insert cont;
            Entitlement__c Ent= New Entitlement__c();
               Ent.Contract_Number__c = cont.id; 
               Ent.Entitlement_Start_Date__c = system.today()-3;
               Ent.End_Date__c =system.today()-1;
               insert Ent;
             
            PageReference pageRef = page.EntitlementRecurrence1;
                pageRef.getParameters().put('Contract',cont.Id);   
                pageRef.getParameters().put('Entitlement',Ent.Id); 
                Test.setCurrentPage(pageRef);
                ApexPages.StandardController std = new ApexPages.StandardController(Ent);
                    
                EntitlementRecurrencecls1 cont1 = new EntitlementRecurrencecls1(std);
                    
                cont1.Noc =2;
                cont1.Recurencetype = 'Quarterly';
                cont1.datename1 = system.today(); 
                cont1.edit();
                cont1.save1();
                EntitlementRecurrencecls1 cont2 = new EntitlementRecurrencecls1(std);
                cont2.Noc = 0;
                cont2.datename = system.today().addmonths(4);
                cont2.Recurencetype = 'Quarterly';
                cont2.datename1 = system.today(); 
                cont2.save1();
                    
            test.stopTest();
        }
          
    }