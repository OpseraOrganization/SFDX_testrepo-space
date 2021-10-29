@isTest(SeeAllData=false)
Public class  CreateCIJButtonController_Test
{
 static Id recId; 
 static final Integer CASE_COUNT = 10;
 
   @testSetup
    static void setupData() {
      Test.startTest(); 
      TriggerInactive.testTrigger = false;
        List<Account> lstAccount= SObjectFactory.build(1,Account.sObjectType);
        lstAccount[0].Name = 'Salesforce Customer Master';
        lstAccount[0].Customer_Status__c = 'Active';
        lstAccount[0].Strategic_Business_Unit__c = 'ATR';
        lstAccount[0].CBT__c = 'Airlines';
        lstAccount[0].Region_Name__c = 'Americas';
        lstAccount[0].Sub_Region_Name__c = 'Canada';
        lstAccount[0].Service_Level__c = 'Refer to Network';           
        lstAccount[0].Type = 'OEM';
        lstAccount[0].REPORT_ACCOUNT_NAME__c = 'Test Account';
        lstAccount[0].Market_Name__c = 'Marine';
        lstAccount[0].CBT_Team__c='Americas';
        lstAccount[0].CurrencyIsoCode='USD';
        
        if(!lstAccount.isEmpty()){
            insert lstAccount;
        }
        List<Contact> lstContact= SObjectFactory.build(2,Contact.sObjectType);
        lstContact[0].LastName = 'Santhanakumar';
        lstContact[0].FirstName = 'Dhivya';
        lstContact[0].AccountId = lstAccount[0].Id;
        lstContact[0].Primary_Email_Address__c = 'dhivya11.santhanakumar@nttdata.com';
        lstContact[0].Address_Line_1__c='Address 1';
        lstContact[0].Address_Line_2__c='Address 1';
        lstContact[0].Address_Line_3__c='Address 1';
        lstContact[0].City_Name__c='MN';
        lstContact[0].State_Code__c='55667';
        lstContact[0].Country_Name__c='USA';
        lstContact[0].Email='dhivya11222@HONEYWELL.COM'; 
        lstContact[1].LastName = 'Kauvya';
        lstContact[1].FirstName = 'Dhivya';
        lstContact[1].AccountId = lstAccount[0].Id;
        lstContact[1].Primary_Email_Address__c = 'dhivya11.santnakumar@nttdata.com';
        lstContact[1].Address_Line_1__c='Address 1';
        lstContact[1].Address_Line_2__c='Address 1';
        lstContact[1].Address_Line_3__c='Address 1';
        lstContact[1].City_Name__c='MN';
        lstContact[1].State_Code__c='55669';
        lstContact[1].Country_Name__c='Canada';
        lstContact[1].Email='dhivya1165@HONEY.COM';
        lstContact[1].Honeywell_ID__c = 'ABC123'; 
        if(!lstContact.isEmpty()){
            insert lstContact;
        }
      Test.stopTest();    
  }
    static testMethod void onBeforeInsertMethod(){
      Test.startTest(); 
      TriggerInactive.testTrigger = false;
       Case caseRelatedToCLI = new Case();
        account accountWithATR =[SELECT Id, Name FROM Account WHERE Name=:'Salesforce Customer Master' LIMIT 1];
        Contact contactWithATR =[SELECT Id, Name FROM Contact WHERE AccountId=:accountWithATR.Id LIMIT 1]; 
        Set<Id> setCaseIds= new Set<Id>();
        recId = RecordTypeServices.getRecordTypeByName('D&S Clearing House Proposal','Case').Id;       
        //create case records
        
        List<Case> list_CaseOrder= SObjectFactory.create(
        CASE_COUNT, Case.sObjectType, new Map<Schema.SObjectField, Object>
        {
            Case.Origin =>'Email-Quotes',
            Case.Status => 'Open',
            Case.Sub_Status__c=>'Waiting for TCT',
            Case.Subject=>'OCD Updates 620',
            Case.Ownerid => userinfo.getuserId(),
            Case.RecordTypeId=> recId,
            Case.SBU_w2c__c=>'D&S',
            Case.Tool_Name__c=>'MCORE',
            Case.Classification__c => 'US ACT Internal',
            Case.ContactId =>contactWithATR.Id,
            Case.AccountId=>accountWithATR.id,
            Case.Type => 'Other',
            Case.Part_Number__c=>'Test', 
            Case.NSN__c=>'Test',
            Case.CSM_Region__c => 'Americas',
            Case.Workstrem__c => 'Spares',
            Case.Export_Compliance_Content_ITAR_EAR__c => 'NO',
            Case.Government_Compliance_SM_M_Content__c => 'NO',
            Case.CEC_Record_Type__c => 'C3 Test CEC Technical Issue'                               
        });
        
         for(Case objCase: list_CaseOrder){
            setCaseIds.add(objCase.Id);
            }
              
        caseRelatedToCLI = list_CaseOrder[0];
        Case_Line_Item__c caseLookupRec = (Case_Line_Item__c) SObjectFactory.create(Case_Line_Item__c.SObjectType,
            new Map<SObjectField, Object>{
                Case_Line_Item__c.Case_Number__c=> caseRelatedToCLI.Id,
                Case_Line_Item__c.Price__c => 20,
                Case_Line_Item__c.Quantity__c => 2,
                Case_Line_Item__c.RecordTypeId=>RecordTypeServices.getRecordTypeByName('DS Clearing House Proposal','Case_Line_Item__c').Id
            }
        ); 
        Id recTypeId =  Schema.SObjectType.Commercial_Item_Justification__c.getRecordTypeInfosByName().get('Transactional CIJ').getRecordTypeId();
        Id recTypeId1 =  Schema.SObjectType.Commercial_Item_Justification__c.getRecordTypeInfosByName().get('OPRO CIJ').getRecordTypeId();
       // Id gsRecordTypeID = Schema.getGlobalDescribe().get('Commercial_Item_Justification__c').getDescribe().getRecordTypeInfosByName().get('Transactional CIJ').getRecordTypeId();
        List<Commercial_Item_Justification__c> listCIJ = SObjectFactory.create(CASE_COUNT,Commercial_Item_Justification__c.SObjectType,
            new Map<Schema.SObjectField, Object>{
                Commercial_Item_Justification__c.Case_Line_Item__c=> caseLookupRec.Id,
                Commercial_Item_Justification__c.Escalated_Last_Price_Paid__c=> 11123,
                Commercial_Item_Justification__c.RecordTypeId=>recTypeId,               
                
                Commercial_Item_Justification__c.Case_Line_Item__c=> caseLookupRec.Id,
                Commercial_Item_Justification__c.Escalated_Last_Price_Paid__c=> 11123,
                Commercial_Item_Justification__c.RecordTypeId=>recTypeId1
               
            }
        ); 
        
        ApexPages.currentPage().getParameters().put('id',caseLookupRec.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(caseLookupRec);        
        String id = ApexPages.currentPage().getParameters().get('id');
        System.assert(true,id==null);
        //CIJTriggerHandler.onBeforeInsert(listCIJ);
        CreateCIJButtonController  cijObj = new CreateCIJButtonController(sc);
        cijObj.recTypeId=recTypeId;
        cijObj.listCLJObj =listCIJ;        
        cijObj.isCIJRecord =true;
        cijObj.getRecTypeOptions();
        cijObj.continueBtn();
        cijObj.cancel();
        
        CreateCIJButtonController  cijObj2;
        CreateCIJButtonController  cijObj1 = new CreateCIJButtonController(sc);
        cijObj1.recTypeId=recTypeId1;
        //cijObj1.newCIJRec = cijObj2;       
        cijObj1.isCIJRecord =true;
        cijObj1.getRecTypeOptions();
        cijObj1.continueBtn();
        cijObj1.cancel();
        
                
        ApexPages.currentPage().getParameters().put('id',caseRelatedToCLI.Id);
        ApexPages.StandardController sc1 = new ApexPages.StandardController(caseRelatedToCLI);        
        String id1 = ApexPages.currentPage().getParameters().get('id');
        System.assert(true,id1==null);
        //CIJTriggerHandler.onBeforeInsert(listCIJ);
        CIJRequestBtnController cseObj = new CIJRequestBtnController(sc1);
         
         cseObj.recTypeId=recTypeId1;
         cseObj.getRecTypeOptions();
         cseObj.continueBtn();
         cseObj.cancel();        
        
        
        Test.stopTest();  
        }
}