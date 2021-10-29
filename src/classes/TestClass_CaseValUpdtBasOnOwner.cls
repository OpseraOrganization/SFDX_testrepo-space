/***********************************************************************************************************
* Company Name          : Honeywell Aero
* Name                  : TestClass_CaseValUpdtBasOnOwner
* Description           : Test Class to test the functionality of the trigger CaseValUpdtBasOnOwner.
* 
* Modification History  :
* Date             Version No.    Modified by           Brief Description of Modification
* 06-Sep-2012      0.01           Mythreyee NTTData     Initial Version
* Nov-08-2013      1.0            Anusuy Murugiah       Wrapping the testmethod with Start and Stop
***********************************************************************************************************/
@isTest(SeeAllData=true)
private class TestClass_CaseValUpdtBasOnOwner{
    static testMethod void TestMthd_CaseValUpdtBasOnOwner(){  
        Test.startTest();
        List<case> lstcase=new List<case>();    
        List<case> lstcase1=new List<case>();    
        List<R_O_Case_Reassignment_Queue__c> objCaseAssignQueue = R_O_Case_Reassignment_Queue__c.getall().values(); //get the values from R&O Case Reassignment Queue in custom settings
        Account objAccnt = new Account();
        objAccnt.Name = 'Honeywell Test';
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
        objContact.LastName = 'SureshKumar';
        objContact.FirstName = 'Mythreyee';
        objContact.AccountId = objAccnt.Id;
        objContact.Primary_Email_Address__c = 'mythreyee.sureshkumar@nttdata.com';
        objContact.Email='mythreyee.sureshkumar@nttdata.com';        
        insert objContact;
        
        Case objInsrtCase = new Case();
        objInsrtCase.Origin = 'Email';
        objInsrtCase.Status = 'Open';
        objInsrtCase.ContactId = objContact.Id;
        objInsrtCase.Classification__c = 'CSO Repair/Overhaul';
        objInsrtCase.HON_Commit_Date__c = System.now() + 1;
        objInsrtCase.Export_Compliance_Content_ITAR_EAR__c = 'NO';
        objInsrtCase.Government_Compliance_SM_M_Content__c = 'NO';
        objInsrtCase.recordtypeid=label.Repair_Overhaul_RT_ID;
        objInsrtCase.Sub_Class__c = '';
        objInsrtCase.Type = '';
        //objInsrtCase.No_FCR_Reason__c = 'true'; For Ticket INC000009687923
        objInsrtCase.Repair_Location__c = 'Secan';
        objInsrtCase.ownerId=getOwnerId('Secan R&O_Queue',objCaseAssignQueue); 
        lstcase.add(objInsrtCase);    
        //insert objInsrtCase;
     
        Case objInsrtCase1 = new Case();
        objInsrtCase1.Origin = 'Email';
        objInsrtCase1.Status = 'Open';
        objInsrtCase1.ContactId = objContact.Id;
        objInsrtCase1.HON_Commit_Date__c = System.now();
        objInsrtCase1.Sub_Class__c = 'Boeing';
        objInsrtCase1.Classification__c = 'CSO OEM - ATR';
        objInsrtCase1.Detail_Class__c = '';
        objInsrtCase1.recordtypeid=label.OEM_Quotes_Orders_ID;
        objInsrtCase1.Type = '';
        objInsrtCase1.ownerId=getOwnerId('ATR OEM Boeing_Queue',objCaseAssignQueue); 
        lstcase.add(objInsrtCase1);
        //update objInsrtCase1;
        
        Case objInsrtCase2 = new Case();
        objInsrtCase2.Origin = 'Email';
        objInsrtCase2.Status = 'Open';
        objInsrtCase2.ContactId = objContact.Id;
        objInsrtCase2.HON_Commit_Date__c = System.now();
        objInsrtCase2.Sub_Class__c = '';
        objInsrtCase2.Classification__c = 'CSO Repair/Overhaul';
        objInsrtCase2.Type = 'Other';
        objInsrtCase2.Detail_Class__c = '';
        objInsrtCase2.recordtypeid=label.Repair_Overhaul_RT_ID;
        objInsrtCase2.ownerId=getOwnerId('R&O EMEAI Avionics_Queue',objCaseAssignQueue); 
        lstcase.add(objInsrtCase2);
        //update objInsrtCase2;
    
        Case objInsrtCase3 = new Case();
        objInsrtCase3.Origin = 'Email';
        objInsrtCase3.Status = 'Open';
        objInsrtCase3.ContactId = objContact.Id;
        objInsrtCase3.Sub_Class__c = '';
        objInsrtCase3.Classification__c = 'CSO Repair/Overhaul';
        objInsrtCase3.Type = 'Quotes/Availability';
        objInsrtCase3.Detail_Class__c = 'COE';
        objInsrtCase3.recordtypeid=label.Repair_Overhaul_RT_ID;
        objInsrtCase3.ownerId=getOwnerId('R&O EMEA Quotes Team_Queue',objCaseAssignQueue); 
        lstcase.add(objInsrtCase3);
        //update objInsrtCase2;
    
        Case objInsrtCase4 = new Case();
        objInsrtCase4.Origin = 'Email';
        objInsrtCase4.Status = 'Open';
        objInsrtCase4.ContactId = objContact.Id;
        objInsrtCase4.Sub_Class__c = '';
        objInsrtCase4.Classification__c = 'CSO Repair/Overhaul';
        objInsrtCase4.Type = 'Other';
        objInsrtCase4.Detail_Class__c = '';
        objInsrtCase4.recordtypeid=label.Repair_Overhaul_RT_ID;
        objInsrtCase4.ownerId=getOwnerId('R&O EMEAI Mechanical_Queue',objCaseAssignQueue); 
        lstcase.add(objInsrtCase4);
        //update objInsrtCase2;
    
        Case objInsrtCase5 = new Case();
        objInsrtCase5.Origin = 'Email';
        objInsrtCase5.Status = 'Open';
        objInsrtCase5.ContactId = objContact.Id;
        objInsrtCase5.Sub_Class__c = 'Secan';
        objInsrtCase5.Classification__c = 'CSO Spares';
        objInsrtCase5.Repair_Location__c = 'Gennevilliers';
        objInsrtCase5.Type = '';
        objInsrtCase5.Detail_Class__c = '';
        objInsrtCase5.recordtypeid=label.Orders_Rec_ID;
        objInsrtCase5.ownerId=getOwnerId('Secan Spares_Queue',objCaseAssignQueue); 
        lstcase.add(objInsrtCase5);
        //update objInsrtCase2;
    
        //insert lstcase;
    
        Case objInsrtCase6 = new Case();
        objInsrtCase6.Origin = 'Email';
        objInsrtCase6.Status = 'Open';
        objInsrtCase6.ContactId = objContact.Id;
        objInsrtCase6.Sub_Class__c = 'Quotes COE - Customer Response';
        objInsrtCase6.Classification__c = 'CSO Repair/Overhaul';    
        objInsrtCase6.Type = 'Quotes/Availability';
        objInsrtCase6.Detail_Class__c = '';
        objInsrtCase5.Repair_Location__c = '';
        objInsrtCase6.recordtypeid=label.GSS_Quotes_Orders;
       // objInsrtCase6.ownerId=getOwnerId('R&O Quotes Team_Queue',objCaseAssignQueue); 
        lstcase.add(objInsrtCase6);
        //insert lstcase;
        //update lstcase1;
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