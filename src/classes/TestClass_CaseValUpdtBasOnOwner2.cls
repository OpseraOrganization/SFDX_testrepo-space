/***********************************************************************************************************
* Company Name          : Honeywell Aero
* Name                  : TestClass_CaseValUpdtBasOnOwner
* Description           : Test Class to test the functionality of the trigger CaseValUpdtBasOnOwner.
* 
* Modification History  :
* Date             Version No.    Modified by           Brief Description of Modification
* 18-Jun-2013      0.01           NTTData               Initial Version
* Nov-08-2013      1.0            Anusuy Murugiah       Wrapping the testmethod with Start and Stop
* Oct 27-2014      1.1            Harikishore           INC000006656211--Commented Code where Shanghai R&O Avionics,R&O Wheels and Brakes/Greer contains
***********************************************************************************************************/
@isTest(SeeAllData=true)
private class TestClass_CaseValUpdtBasOnOwner2{
    static testMethod void TestMthd_CaseValUpdtBasOnOwner2(){  
        
        List<case> lstcase=new List<case>();   
        List<case> lstcase1=new List<case>();   
        List<R_O_Case_Reassignment_Queue__c> objCaseAssignQueue = R_O_Case_Reassignment_Queue__c.getall().values(); //get the values from R&O Case Reassignment Queue in custom settings
        Test.startTest();
        Account objAccnt = new Account();
        objAccnt.Name = 'Honeywell Test2';
        objAccnt.Customer_Status__c = 'Active';
        objAccnt.Strategic_Business_Unit__c = 'D&S';
        objAccnt.CBT__c = 'DAA';
        objAccnt.Region_Name__c = 'Americas';
        objAccnt.Sub_Region_Name__c = 'Canada';
        objAccnt.Service_Level__c = 'Standard';
        objAccnt.Type = 'OEM';
        objAccnt.REPORT_ACCOUNT_NAME__c = 'HONEYWELL TEST';        
        insert objAccnt;
        
        Contact objContact = new Contact();
        objContact.LastName = 'Hari';
        objContact.FirstName = 'vnv';
        objContact.AccountId = objAccnt.Id;
        objContact.Primary_Email_Address__c = 'harikishore.vutukuri@nttdata.com';
        objContact.Email='harikishore.vutukuri@nttdata.com';        
        insert objContact;
              
        Case objInsrtCase1 = new Case();
        objInsrtCase1.Origin = 'Email';
        objInsrtCase1.Status = 'Open';
        objInsrtCase1.ContactId = objContact.Id;
        objInsrtCase1.HON_Commit_Date__c = System.now();
        objInsrtCase1.Sub_Class__c = '';
        objInsrtCase1.Classification__c = 'CSO Repair/Overhaul';
        objInsrtCase1.recordtypeid=label.Repair_Overhaul_RT_ID;
        objInsrtCase1.Type = 'Shipping/Invoicing';
        objInsrtCase1.Repair_Location__c = 'EMEAI Avionics';
        objInsrtCase1.ownerId=getOwnerId('ROEMEAShipping/InvoicingAvionics_Queue',objCaseAssignQueue); 
        lstcase.add(objInsrtCase1);
    
        Case objInsrtCase2 = new Case();
        objInsrtCase2.Origin = 'Email';
        objInsrtCase2.Status = 'Open';
        objInsrtCase2.ContactId = objContact.Id;
        objInsrtCase2.HON_Commit_Date__c = System.now();
        objInsrtCase2.Sub_Class__c = '';
        objInsrtCase2.Classification__c = 'CSO Repair/Overhaul';
        objInsrtCase2.Repair_Location__c = 'EMEAI Mechanical';
        objInsrtCase2.recordtypeid=label.Repair_Overhaul_RT_ID;
        objInsrtCase2.Type = 'Shipping/Invoicing';
        objInsrtCase2.ownerId=getOwnerId('ROEMEAShipping/InvoicingMech_Queue',objCaseAssignQueue); 
        lstcase.add(objInsrtCase2);
    
        Case objInsrtCase3 = new Case();
        objInsrtCase3.Origin = 'Email';
        objInsrtCase3.Status = 'Open';
        objInsrtCase3.ContactId = objContact.Id;
        objInsrtCase3.HON_Commit_Date__c = System.now();
        objInsrtCase3.Sub_Class__c = 'FastShop';
        objInsrtCase3.Classification__c = 'CSO Repair/Overhaul';
        objInsrtCase3.Detail_Class__c = '';
        objInsrtCase3.recordtypeid=label.Repair_Overhaul_RT_ID;
        objInsrtCase3.Type = 'Repair Inquiry';
        objInsrtCase3.ownerId=getOwnerId('R&O FastShop_Queue',objCaseAssignQueue);
        lstcase.add(objInsrtCase3);
    
        Case objInsrtCase4 = new Case();
        objInsrtCase4.Origin = 'Email';
        objInsrtCase4.Status = 'Open';
        objInsrtCase4.ContactId = objContact.Id;
        objInsrtCase4.HON_Commit_Date__c = System.now();
        objInsrtCase4.Sub_Class__c = 'Mech Components';
        objInsrtCase4.Classification__c = 'CSO Repair/Overhaul';
        objInsrtCase4.Detail_Class__c = '';
        objInsrtCase4.recordtypeid=label.Repair_Overhaul_RT_ID;
        objInsrtCase4.Type = 'Repair Inquiry';
        objInsrtCase4.ownerId=getOwnerId('R&O Mech Components_Queue',objCaseAssignQueue);
        lstcase.add(objInsrtCase4);
        
        /*Case objInsrtCase5 = new Case();
        objInsrtCase5.Origin = 'Email';
        objInsrtCase5.Status = 'Open';
        objInsrtCase5.ContactId = objContact.Id;
        objInsrtCase5.HON_Commit_Date__c = System.now();
        objInsrtCase5.Sub_Class__c = 'W&B/Greer';
        objInsrtCase5.Classification__c = 'CSO Repair/Overhaul';
        objInsrtCase5.recordtypeid=label.Repair_Overhaul_RT_ID;
        objInsrtCase5.Type = 'Repair Inquiry';
        objInsrtCase5.Detail_Class__c = '';
        objInsrtCase5.ownerId=getOwnerId('R&O Wheels and Brakes/Greer_Queue',objCaseAssignQueue);
        lstcase.add(objInsrtCase5);*/
        
        Case objInsrtCase6 = new Case();
        objInsrtCase6.Origin = 'Email';
        objInsrtCase6.Status = 'Open';
        objInsrtCase6.ContactId = objContact.Id;
        objInsrtCase6.HON_Commit_Date__c = System.now();
        objInsrtCase6.Sub_Class__c = 'Engines';
        objInsrtCase6.Classification__c = 'CSO Repair/Overhaul';
        objInsrtCase6.recordtypeid=label.Repair_Overhaul_RT_ID;
        objInsrtCase6.Type = 'Repair Inquiry';
        objInsrtCase6.Detail_Class__c = '';
        objInsrtCase6.ownerId=getOwnerId('R&O Engines_Queue',objCaseAssignQueue);
        lstcase.add(objInsrtCase6);
        
        /*Case objInsrtCase7 = new Case();
        objInsrtCase7.Origin = 'Email';
        objInsrtCase7.Status = 'Open';
        objInsrtCase7.ContactId = objContact.Id;
        objInsrtCase7.HON_Commit_Date__c = System.now();
        objInsrtCase7.Sub_Class__c = '';
        objInsrtCase7.Classification__c = 'CSO Repair/Overhaul';
        objInsrtCase7.Repair_Location__c = 'Shanghai AvEi';
        objInsrtCase7.recordtypeid=label.Repair_Overhaul_RT_ID;
        objInsrtCase7.Type = '';
        objInsrtCase7.ownerId=getOwnerId('Shanghai R&O Avionics_Queue',objCaseAssignQueue); 
        lstcase.add(objInsrtCase7);*/
        
        insert lstcase; 
        Test.stopTest();
    } 
    private Static String getOwnerName(String strOwnerId, List<R_O_Case_Reassignment_Queue__c> lstRoObj){
        Integer intQtypeSize = lstRoObj.size();        
        for(Integer i=0; i<intQtypeSize; i++){            
            if(lstRoObj[i].QueueId__c.equals(strOwnerId)){
                return lstRoObj[i].name;
            }
        }        
        System.debug('Failure Case');
        return '';
    }
    private static String getOwnerId(String strOwnerName, List<R_O_Case_Reassignment_Queue__c> lstRoObj){
        Integer intQtypeSize = lstRoObj.size();
        for(Integer i=0; i<intQtypeSize; i++){            
            if(lstRoObj[i].Name.equals(strOwnerName)){
                return lstRoObj[i].Queueid__c;
            }
        }        
        System.debug('Failure Case');
        return '';
    }
}