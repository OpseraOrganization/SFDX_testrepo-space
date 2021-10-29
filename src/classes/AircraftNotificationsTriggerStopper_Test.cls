@isTest
public class AircraftNotificationsTriggerStopper_Test
{
       
      boolean isAlreadyExecuted = True;
      boolean isAlreadyExecutedPPO = True;
      
      
      boolean isAlreadyExecutedORdersRT = True;
    static testMethod void TriggerStopperTestMethod() {
    test.starttest();
    Platform__c p = new Platform__c();
        p.Name = 'Test Platform11';
        p.Model__c = '36-16A';
        p.Make__c = 'VARIOUS OEMS';
        insert p;
        
         Fleet_Asset_Detail__c fleetAssetDetail = new Fleet_Asset_Detail__c();
         fleetAssetDetail.Name='testFleetAsset';
         fleetAssetDetail.Serial_Number__c ='SN61611';
         fleetAssetDetail.New_Alert_Identification__c = true;
         
         fleetAssetDetail.Platform_Name__c = p.id;
         fleetAssetDetail.State__c='canada';
        // fleetAssetDetail.Model__c='34-tr';
         insert fleetAssetDetail;
         
         Attachment attach=new Attachment();     
            attach.Name='Unit Test Attachment';
            Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
            attach.body=bodyBlob;
            attach.parentId=fleetAssetDetail.id;
            insert attach;
            
        fleetAssetDetail.Fleet_Asset_Notification__c = true; 
       
        Case c1 = new Case();
        c1.Origin = 'web';
        c1.Status = 'Open';  
        c1.SuppliedEmail = 'mariakitheri.tinulin@nttdata.com';
        c1.Browser__c = 'N/A';
        //c1.ContactId = con.id;
        //c1.AccountId =acc.id;        
        c1.Notes__c = 'Test';
        c1.OwnerId = Label.AEROBIZOwner_ID;
        c1.RecordtypeId = Label.AerobizRecType;
        c1.type = 'FSS';
        c1.Classification__c = 'CSO Repair Order';        
        c1.Export_Compliance_Content_ITAR_EAR__c = 'No';
        c1.Government_Compliance_SM_M_Content__c = 'No';
        c1.Sales_Order_Number__c = '12345678';
        c1.CaseOwnerChanged__c = 'mariakitheri.tinulin@nttdata.com';         
        c1.Requestor_Email__c = '';
        
        Insert C1;
          //update fleetAssetDetail;
        case cas=[select origin,status,Sales_Order_Number__c from case where id=:c1.id];
        cas.Sales_Order_Number__c='444444';
        boolean isAlreadyExecutedPFECN = True;
        update cas;
    test.stoptest();
    }
    static testMethod void TriggerStopperTestMethod1() {
    test.starttest();
    
        Case c1 = new Case();
        c1.Origin = 'web';
        c1.Status = 'Open';  
        c1.SuppliedEmail = 'mariakitheri.tinulin@nttdata.com';
        c1.Browser__c = 'N/A';
        //c1.ContactId = con.id;
        //c1.AccountId =acc.id;        
        c1.Notes__c = 'Test';
        c1.OwnerId = Label.AEROBIZOwner_ID;
        c1.RecordtypeId = Label.AerobizRecType;
        c1.type = 'FSS';
        c1.Classification__c = 'CSO Repair Order';        
        c1.Export_Compliance_Content_ITAR_EAR__c = 'No';
        c1.Government_Compliance_SM_M_Content__c = 'No';
        c1.Sales_Order_Number__c = '12345678';
        c1.CaseOwnerChanged__c = 'mariakitheri.tinulin@nttdata.com';         
        c1.Requestor_Email__c = '';
        
        Insert C1;
          //update fleetAssetDetail;
        case cas=[select origin,status,Sales_Order_Number__c from case where id=:c1.id];
        cas.Sales_Order_Number__c='444444';
        boolean isAlreadyExecutedNavdb = True;
        update cas;
    test.stoptest();
    } 
    
 }