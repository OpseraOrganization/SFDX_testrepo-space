@isTest
public class QuoteRelatedListController_Test { 
    static Account acc; 
    static String BENDIXKING = 'BendixKing';
    static testMethod void NewQuoteTestMethod(){
        test.startTest();
        Profile ProfRec = [select name,id from Profile where name = 'System Administrator' limit 1];
        User userRec = [select id from user where ProfileId = :ProfRec.Id and isActive=true limit 1];
        system.runas(userRec)
        {
            NewQuoteAccountFieldValidator__c nqf = new NewQuoteAccountFieldValidator__c();
            nqf.name='NewQuoteAccountFieldValidator';
            nqf.CBT__c ='BGA Aftermarket';
            nqf.SBU__c= 'BGA';
            nqf.STATUS__c= 'True';
            nqf.TYPE__c='MRO';
            insert nqf;
            
            /* acc = new Account();
acc.Name = 'Test Account';
acc.Customer_Status__c = 'Active';
acc.Strategic_Business_Unit__c = 'BGA';
acc.CBT__c = 'BGA Aftermarket';
acc.Region_Name__c = 'Americas';
acc.Sub_Region_Name__c = 'Canada';
acc.Service_Level__c = 'Unauthorized Dist/Brkr';
acc.Type = 'MRO';
acc.REPORT_ACCOUNT_NAME__c = 'Test Account';
acc.Market_Name__c = 'Business Aviation';
acc.ATR_Channel_Partner__c= true;
insert acc; */
            acc = new TestAccountBuilder()
                .addField( 'Name', 'Test Account' )
                .addField( 'Customer_Status__c', 'Active' )
                .addField( 'Strategic_Business_Unit__c', 'BGA' )
                .addField( 'CBT__c', 'BGA Aftermarket' )
                .addField( 'Region_Name__c', 'Americas' )
                .addField( 'Sub_Region_Name__c', 'Canada' )
                .addField( 'Service_Level__c', 'Unauthorized Dist/Brkr' )
                .addField( 'Type', 'MRO' )
                .addField( 'REPORT_ACCOUNT_NAME__c', 'Test Account' )
                .addField( 'Market_Name__c', 'Business Aviation' )
                .addField( 'ATR_Channel_Partner__c', TRUE )
                .generate();
            opportunity opp= new TestOpportunityBuilder( 'Test', BENDIXKING )
                .addField( 'AccountId', acc.Id )
                .addField( 'SBU__c', 'BGA' )
                .addField( 'StageName', 'Propose' )
                .addField( 'Solution_Type__c', 'Repair and Overhaul' )
                .addField( 'Sub_Solution_Type__c', 'Flat Rate' )
                .generate();
            List<Opportunity> lstopp =[select id from opportunity where accountid=: acc.id];
            system.assertEquals(1,lstopp.size());
            Contact contact=new contact();
            User userOne=new user();
            contact = new TestContactBuilder().generate();
            userOne = new TestUserBuilder()
                .setFirstName( 'John' )
                .setLastName( 'Doe' )
                .generate();
            Opportunity_Sales_Team__c oppTeam = new TestOpportunityTeamBuilder()
                .addField('Opportunity__c', opp.Id)
                .addField('Contact__c', contact.Id)
                .generate();
            List<Opportunity_Sales_Team__c> oppSalesList =[select id from Opportunity_Sales_Team__c where Opportunity__c=: opp.Id];
            system.debug('oppSalesList==>' +oppSalesList);
            
            system.assert(oppSalesList.size()>0);  
            User newUser = new TestUserBuilder()
                .setFirstName( 'Jane' )
                .setLastName( 'Doe' )
                .generate();
            
            opp.OwnerId = newUser.Id;
            update opp;         
            quote__c quo=new quote__c();
            quo.name='123';
            
            insert quo;
            QuoteRelatedListController.QuoteWrapper qw = new QuoteRelatedListController.QuoteWrapper();
            QuoteRelatedListController.getContacts(opp.id);
            system.debug('test debug2==' + QuoteRelatedListController.getContacts(opp.id));
            QuoteRelatedListController.delteQuoteById(quo.id);
            qw= QuoteRelatedListController.getContacts(opp.id);
            system.assertEquals(qw.viewAllFlag , false); 
            system.assertEquals(qw.oppObjRec.AccountID, opp.AccountID);  
            system.assertEquals(qw.oppObjRec.ID, opp.ID);
            System.assertEquals(0, [select count() from quote__c where id = :quo.id]);
        }
        test.stopTest();
    }
    static testMethod void NewQuoteTestMethod1(){
        test.startTest();
        Profile ProfRec = [select name,id from Profile where name = 'System Administrator' limit 1];
        User userRec = [select id from user where ProfileId = :ProfRec.Id and isActive=true limit 1];
        system.runas(userRec)
        {
            NewQuoteAccountFieldValidator__c nqf = new NewQuoteAccountFieldValidator__c();
            nqf.name='NewQuoteAccountFieldValidator';
            nqf.CBT__c ='BGA Aftermarket';
            nqf.SBU__c= 'BGA';
            nqf.STATUS__c= 'True';
            nqf.TYPE__c='MRO';
            insert nqf;
            
            acc = new Account();
            acc.Name = 'Test Account';
            acc.Customer_Status__c = 'Active';
            acc.Strategic_Business_Unit__c = 'BGA';
            acc.CBT__c = 'BGA Aftermarket';
            acc.Region_Name__c = 'Americas';
            acc.Sub_Region_Name__c = 'Canada';
            acc.Service_Level__c = 'Unauthorized Dist/Brkr';
            acc.Type = 'MRO';
            acc.REPORT_ACCOUNT_NAME__c = 'Test Account';
            acc.Market_Name__c = 'Business Aviation';
            acc.ATR_Channel_Partner__c= false;
            insert acc; 
            opportunity opp= new TestOpportunityBuilder( 'Test', BENDIXKING )
                .addField( 'AccountId', acc.Id )
                .addField( 'SBU__c', 'BGA' )
                .addField( 'StageName', 'Propose' )
                .addField( 'Solution_Type__c', 'Repair and Overhaul' )
                .addField( 'Sub_Solution_Type__c', 'Flat Rate' )
                .generate();
            List<Opportunity> lstopp =[select id from opportunity where accountid=: acc.id];
            system.assertEquals(1,lstopp.size());
            Contact contact=new contact();
            User userOne=new user();
            contact = new TestContactBuilder().generate();
            userOne = new TestUserBuilder()
                .setFirstName( 'John' )
                .setLastName( 'Doe' )
                .generate();
            Opportunity_Sales_Team__c oppTeam = new TestOpportunityTeamBuilder()
                .addField('Opportunity__c', opp.Id)
                .addField('Contact__c', contact.Id)
                .generate();
            List<Opportunity_Sales_Team__c> oppSalesList =[select id from Opportunity_Sales_Team__c where Opportunity__c=: opp.Id];
            system.assert(oppSalesList.size()>0);      
            User newUser = new TestUserBuilder()
                .setFirstName( 'Jane' )
                .setLastName( 'Doe' )
                .generate();
            
            opp.OwnerId = newUser.Id;
            update opp;         
            quote__c quo=new quote__c();
            quo.name='123';
            
            insert quo;  
            QuoteRelatedListController.QuoteWrapper qw = new QuoteRelatedListController.QuoteWrapper();
            QuoteRelatedListController.getContacts(opp.id);
            system.debug('test debug1==' + QuoteRelatedListController.getContacts(opp.id));
            QuoteRelatedListController.delteQuoteById(quo.id);
            qw= QuoteRelatedListController.getContacts(opp.id);
            system.assertEquals(qw.viewAllFlag , false); 
            system.assertEquals(qw.oppObjRec.AccountID, opp.AccountID);  
            system.assertEquals(qw.oppObjRec.ID, opp.ID);
            System.assertEquals(0, [select count() from quote__c where id = :quo.id]);    
        }
        test.stopTest();
    }
    static testMethod void NewQuoteTestMethod2(){
        test.startTest();
        Profile ProfRec = [select name,id from Profile where name = 'System Administrator' limit 1];
        User userRec = [select id from user where ProfileId = :ProfRec.Id and isActive=true limit 1];
        system.runas(userRec)
        {
            NewQuoteAccountFieldValidator__c nqf = new NewQuoteAccountFieldValidator__c();
            nqf.name='NewQuoteAccountFieldValidator';
            nqf.CBT__c ='Airlines';
            nqf.SBU__c= 'ATR';
            nqf.STATUS__c= 'True';
            nqf.TYPE__c='Air Cargo Transporter';
            insert nqf;
            NewQuoteAccountFieldValidator__c nqA = [select id,name from NewQuoteAccountFieldValidator__c where id = :nqf.id];
            system.assertEquals(nqA.Name,'NewQuoteAccountFieldValidator');
            acc = new Account();
            acc.Name = 'Test Account';
            acc.Customer_Status__c = 'Active';
            acc.Strategic_Business_Unit__c = 'ATR';
            acc.CBT__c = 'Airlines';
            acc.Region_Name__c = 'Americas';
            acc.Sub_Region_Name__c = 'Canada';
            acc.Service_Level__c = 'Unauthorized Dist/Brkr';
            acc.Type = 'Air Cargo Transporter';
            acc.REPORT_ACCOUNT_NAME__c = 'Test Account';
            acc.Market_Name__c = 'Business Aviation';
            acc.ATR_Channel_Partner__c= false;
            insert acc;
            opportunity opp= new TestOpportunityBuilder( 'Test', BENDIXKING )
                .addField( 'AccountId', acc.Id )
                .addField( 'SBU__c', 'BGA' )
                .addField( 'StageName', 'Propose' )
                .addField( 'Solution_Type__c', 'Repair and Overhaul' )
                .addField( 'Sub_Solution_Type__c', 'Flat Rate' )
                .generate();
            
            List<Opportunity> lstopp =[select id from opportunity where accountid=: acc.id];
            system.assertEquals(1,lstopp.size());
            Contact contact=new contact();
            User userOne=new user();
            contact = new TestContactBuilder().generate();
            userOne = new TestUserBuilder()
                .setFirstName( 'John' )
                .setLastName( 'Doe' )
                .generate();
            Opportunity_Sales_Team__c oppTeam = new TestOpportunityTeamBuilder()
                .addField('Opportunity__c', opp.Id)
                .addField('Contact__c', contact.Id)
                .generate();
            List<Opportunity_Sales_Team__c> oppSalesList =[select id from Opportunity_Sales_Team__c where Opportunity__c=: opp.Id];
            system.assert(oppSalesList.size()>0);   
            User newUser = new TestUserBuilder()
                .setFirstName( 'Jane' )
                .setLastName( 'Doe' )
                .generate();
            
            opp.OwnerId = newUser.Id;
            update opp;     
            quote__c quo=new quote__c();
            quo.name='123';
            
            insert quo;  
            
            QuoteRelatedListController.QuoteWrapper qw = new QuoteRelatedListController.QuoteWrapper();
            QuoteRelatedListController.getContacts(opp.id);
            system.debug('test debug==' + QuoteRelatedListController.getContacts(opp.id));
            QuoteRelatedListController.delteQuoteById(quo.id);
            System.assertEquals(0, [select count() from quote__c where id = :quo.id]);
            qw= QuoteRelatedListController.getContacts(opp.id);
            system.assertEquals(qw.viewAllFlag , false); 
            system.assertEquals(qw.oppObjRec.AccountID, opp.AccountID);  
            system.assertEquals(qw.oppObjRec.ID, opp.ID);
        }
        test.stopTest();
    }
}