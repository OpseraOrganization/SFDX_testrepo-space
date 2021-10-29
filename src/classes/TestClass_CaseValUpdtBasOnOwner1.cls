/***********************************************************************************************************
* Company Name          : Honeywell Aero
* Name                  : TestClass_CaseValUpdtBasOnOwner
* Description           : Test Class to test the functionality of the trigger CaseValUpdtBasOnOwner.
* 
* Modification History  :
* Date             Version No.    Modified by           Brief Description of Modification
* 06-Sep-2012      0.01           Mythreyee NTTData     Initial Version
* Nov-08-2013      1.0            Anusuy Murugiah       Wrapping the testmethod with Start and Stop
* OCt 27-2014      1.1            Harikishore           INC000006656211--Commented Code where Xiamen R&O Mechanical,Shanghai R&O OE contains 
***********************************************************************************************************/
@isTest(SeeAllData=true)
private class TestClass_CaseValUpdtBasOnOwner1{
    static testMethod void TestMthd_CaseValUpdtBasOnOwner1(){  
        
        List<case> lstcase=new List<case>();   
        List<case> lstcase1=new List<case>();   
        List<R_O_Case_Reassignment_Queue__c> objCaseAssignQueue = R_O_Case_Reassignment_Queue__c.getall().values(); //get the values from R&O Case Reassignment Queue in custom settings
        Test.startTest();
        Account objAccnt = new Account();
        objAccnt.Name = 'Honeywell Test1';
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
        objContact.LastName = 'SureshKumar1';
        objContact.FirstName = 'Mythreyee1';
        objContact.AccountId = objAccnt.Id;
        objContact.Primary_Email_Address__c = 'venkatesh.athanti@nttdata.com';
        objContact.Email='venkatesh.athanti@nttdata.com';        
        insert objContact;
              
        Case objInsrtCase7 = new Case();
        objInsrtCase7.Origin = 'Email';
        objInsrtCase7.Status = 'Open';
        objInsrtCase7.ContactId = objContact.Id;
        objInsrtCase7.Sub_Class__c = 'Quotes COE - Customer Response';
        objInsrtCase7.Classification__c = 'CSO Repair/Overhaul';    
        objInsrtCase7.Type = 'Quotes/Availability';
        objInsrtCase7.Detail_Class__c = '';
        objInsrtCase7.Repair_Location__c = '';
        objInsrtCase7.ownerId=getOwnerId('R&O Quotes Team Escalation_Queue',objCaseAssignQueue); 
        lstcase.add(objInsrtCase7);
             
        Case objInsrtCase1 = new Case();
        objInsrtCase1.Origin = 'Email';
        objInsrtCase1.Status = 'Open';
        objInsrtCase1.ContactId = objContact.Id;
        objInsrtCase1.HON_Commit_Date__c = System.now();
        objInsrtCase1.Sub_Class__c = '';
        objInsrtCase1.Classification__c = 'CSO OEM - ATR';
        objInsrtCase1.Detail_Class__c = '';
        objInsrtCase1.recordtypeid=label.OEM_Quotes_Orders_ID;
        objInsrtCase1.Type = '';
        objInsrtCase1.ownerId=getOwnerId('ATR OEM Airbus_Queue',objCaseAssignQueue); 
        lstcase.add(objInsrtCase1);
    
        /*Case objInsrtCase2 = new Case();
        objInsrtCase2.Origin = 'Email';
        objInsrtCase2.Status = 'Open';
        objInsrtCase2.ContactId = objContact.Id;
        objInsrtCase2.HON_Commit_Date__c = System.now();
        objInsrtCase2.Sub_Class__c = '';
        objInsrtCase2.Classification__c = 'CSO Repair/Overhaul';
        objInsrtCase2.Repair_Location__c = 'Shanghai Quote/OE';
        objInsrtCase2.recordtypeid=label.Repair_Overhaul_RT_ID;
        objInsrtCase2.Type = 'Place Order';
        objInsrtCase2.ownerId=getOwnerId('Shanghai R&O OE_Queue',objCaseAssignQueue); 
        lstcase.add(objInsrtCase2);*/
    
        Case objInsrtCase3 = new Case();
        objInsrtCase3.Origin = 'Email';
        objInsrtCase3.Status = 'Open';
        objInsrtCase3.ContactId = objContact.Id;
        objInsrtCase3.HON_Commit_Date__c = System.now();
        objInsrtCase3.Sub_Class__c = '';
        objInsrtCase3.Classification__c = 'CSO OEM - ATR';
        objInsrtCase3.Detail_Class__c = '';
        objInsrtCase3.recordtypeid=label.OEM_Quotes_Orders_ID;
        objInsrtCase3.Type = '';
        objInsrtCase3.ownerId=label.CSO_BGA_OEM_Team_label;
        lstcase.add(objInsrtCase3);
    
        Case objInsrtCase4 = new Case();
        objInsrtCase4.Origin = 'Email';
        objInsrtCase4.Status = 'Open';
        objInsrtCase4.ContactId = objContact.Id;
        objInsrtCase4.HON_Commit_Date__c = System.now();
        objInsrtCase4.Sub_Class__c = '';
        objInsrtCase4.Classification__c = 'CSO OEM – ATR';
        objInsrtCase4.Detail_Class__c = '';
        objInsrtCase4.recordtypeid=label.OEM_Quotes_Orders_ID;
        objInsrtCase4.Type = '';
        objInsrtCase4.ownerId=getOwnerId('ATR OEM Components_Queue',objCaseAssignQueue);
        lstcase.add(objInsrtCase4);
        
        Case objInsrtCase5 = new Case();
        objInsrtCase5.Origin = 'Email';
        objInsrtCase5.Status = 'Open';
        objInsrtCase5.ContactId = objContact.Id;
        objInsrtCase5.HON_Commit_Date__c = System.now();
        objInsrtCase5.Sub_Class__c = '';
        objInsrtCase5.Repair_Location__c = 'EMEAI Avionics';
        objInsrtCase5.Classification__c = 'CSO Repair/Overhaul';
        objInsrtCase5.recordtypeid=label.Repair_Overhaul_RT_ID;
        objInsrtCase5.Type = 'Place Order';
        objInsrtCase5.ownerId=getOwnerId('R&O EMEA Order Entry Avionics_Queue',objCaseAssignQueue);
        lstcase.add(objInsrtCase5);
        
        /*Case objInsrtCase6 = new Case();
        objInsrtCase6.Origin = 'Email';
        objInsrtCase6.Status = 'Open';
        objInsrtCase6.ContactId = objContact.Id;
        objInsrtCase6.HON_Commit_Date__c = System.now();
        objInsrtCase6.Sub_Class__c = '';
        objInsrtCase6.Repair_Location__c = 'XiaMen';
        objInsrtCase6.Classification__c = 'CSO Repair/Overhaul';
        objInsrtCase6.recordtypeid=label.Repair_Overhaul_RT_ID;
        objInsrtCase6.Type = '';
        objInsrtCase6.ownerId=getOwnerId('Xiamen R&O Mechanical_Queue',objCaseAssignQueue);
        lstcase.add(objInsrtCase6);*/
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