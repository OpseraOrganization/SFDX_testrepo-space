@isTest(SeeAllData=false)
public class Create_contrts_entmnts_batch_Test{
static testMethod void Test1() {
        Account tstAccRec = new Account(name = 'Test Account' );
        insert tstAccRec;
        Platform__c plat = new Platform__c(Name='Test Platform',Platform_Type__c='test',Model__c='test',Make__c='test',Managing_SBU__c='ATR');
        insert plat;
        
         Fleet_Asset_Detail__c fleetAssetDetail = new Fleet_Asset_Detail__c();
         fleetAssetDetail.Name='testFleetAsset';
         fleetAssetDetail.Serial_Number__c ='SN61611';
         fleetAssetDetail.New_Alert_Identification__c = true;
         fleetAssetDetail.Account__c=tstAccRec.id;
         fleetAssetDetail.Platform_Name__c = plat.id;
         fleetAssetDetail.State__c='canada';
         fleetAssetDetail.aircraft_delivery_date__c=date.today();
         insert fleetAssetDetail;
         
         Location__c l = new Location__c(Name = 'Place Holder', recordtypeid='01230000000azArAAI',Region__c = 'cochin');
         insert l;
        
        Product2 p1 = new Product2();
        p1.Name = 'test product';
        p1.Description = 'test product';
        p1.Keywords__c = 'ADM';
        p1.Make_this_course_public__c = 'Yes';
        p1.isActive = TRUE;
        p1.recordtypeid='01230000000azJe';
        p1.Level__c='Level I';
        p1.Prerequisites__c='Good';
        p1.Who_Should_Attend__c='Very good class';
        p1.Hours_of_Instruction__c=12;
        p1.Duration__c='23';
        p1.Make_this_course_public__c='Yes'; 
        insert p1;
         Entitlement_Matrix__c em= new Entitlement_Matrix__c(); 
            em.Make__c='test';
            em.Model__c='test';
            em.Class_Id__c = p1.id;
            em.Time_Period__c = 2;
            em.Number_of_seats__c =2;
            insert em;
    Test.StartTest();
       Create_contrts_entmnts_batch EntitlementBatch1 = new Create_contrts_entmnts_batch();
       database.executeBatch(EntitlementBatch1,200);
    Test.StopTest();
    }

  }