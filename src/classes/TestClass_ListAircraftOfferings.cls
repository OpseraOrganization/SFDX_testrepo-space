/** * File Name: TestClass_ListAircraftOfferings
* Description Test Method
* Copyright : Wipro Technologies Limited Copyright (c) 2010
* * @author : Wipro
* Modification Log =============================================================== 
Ver Date Author Modification --- ---- ------ -------------
* */ 
@isTest
private class TestClass_ListAircraftOfferings
{
 static testMethod void ListAircraftOfferings(){
    Profile pf = [select name from Profile where name = 'BGA After Market'];
     User testUser = new User(LastName = 'listoff Test User',Username = 'listoffuser@test.com.honeywell',Email = 'listoff@test.com',Alias = 
        'offuser' ,CommunityNickname= 'offuserhoney' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 
        'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 
        'en_US',Functional_Role__c='testrole',SBU_User__c='testsbu',CBT__c='HTSI',CBT_Team__c ='testcbtteam');
      insert testUser;
      Account tstAcc = New Account(Name= 'listoff Test Account');
                insert tstAcc;
                system.runAs(testUser){
                
                Platform__c plt = new Platform__c(Name='listoff test plt',OEM_Name__c=tstAcc.id);
                insert plt;
                
                Test.startTest();
                try{
                Fleet_Asset_Detail__c FAD= New Fleet_Asset_Detail__c(Name='listoff test fleet',Platform_Name__c=plt.id);
                insert FAD;
                Opportunity tstOpp = new Opportunity(Name='listoff Opp',Accountid=tstAcc.Id,StageName='Prospecting',
                    CloseDate=System.today(), Owner=testUser,Aircraft_ref__c=FAD.Id);
                insert tstOpp;
                Aircraft_Offerings__c InsRmu = New Aircraft_Offerings__c(Aircraft_Customer_Fleet__c=FAD.id);
                insert InsRmu;
                OFFERING_MAPPER__c offmap =New OFFERING_MAPPER__c(Name='listoff',Aircraft_Platform__c=plt.id);
                insert offmap;
                 //ApexPages.StandardController tstController = new ApexPages.StandardController() ;
                 Apexpages.currentpage().getParameters().put('airId',FAD.id);
                 ListAircraftOfferings tstListAircraftOfferings = New ListAircraftOfferings(); 
                 tstListAircraftOfferings.airPlatOfferOpp[0].actionRecord =true;
                 tstListAircraftOfferings.installOffering();
                 tstListAircraftOfferings.listInstalledSection[0].actionRecord =true;
                 tstListAircraftOfferings.unInstallOffering();
                 tstListAircraftOfferings.listInstalledSection[0].actionRecord =true;
                 tstListAircraftOfferings.saveInstallOffering();
                 tstListAircraftOfferings.getlistRelatedOpportunities();
                }catch(Exception e)
                {
                }
                Test.stopTest();
                }
             }
         }