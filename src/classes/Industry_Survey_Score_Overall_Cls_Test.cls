/** * File Name: Industry_Survey_Score_Overall_Cls_Test 
* Description :Test class for Industry_Survey_Score_Overall_Cls
* Copyright : NTTDATA 2015 *
 * @author : NTTDATA
 * Modification Log =============================================================== Ver Date Author Modification --- ---- ------ -------------*
**/
@isTest
private class Industry_Survey_Score_Overall_Cls_Test {

   
 static testMethod void TestIndustrySurveComp() 
    {
        Account acc= new Account(name='Test Account');
 insert acc; 
 Integer Year = Date.Today().Year();
 
Contact con = new Contact();
        con.LastName = 'tt';
        con.FirstName = 'tt';
        con.AccountId = acc.Id;
        con.SBU_Contact__c='ACS Labs';
        con.CBT__c='ACS Sensors Lab';
        con.CBT_Team__c='ACS Advanced Sensors';        
        con.Email='test.test@test.com';        
        insert con;
        
Schema.DescribeSObjectResult Feedback = Schema.SObjectType.Feedback__c;
Map<String, Schema.RecordTypeInfo> FBMapByName = Feedback.getRecordTypeInfosByName();
Schema.RecordTypeInfo FBRTName = FBMapByName.get('ATR VOC');

 List<Feedback__C> lstvoc= new List<Feedback__C>();
 Feedback__C voc= new Feedback__C(RecordTypeId=FBRTName.getRecordTypeId(),Delivery_Weight__c=100, account__c=acc.id,contact__c=con.id,
     Metric_for_Delivery__c='4' ,Metric_for_Value__c ='2',Metric_for_Reliability__c='1' ,Metric_for_Service_Support__c='1',
     Metric_for_Responsiveness__c ='2',Year__c=String.valueOf(year));
 insert voc;
 
 voc.year__c='2014';
update voc;
System.debug(voc.year__C);
System.debug(voc.Consolidated_score__c);


            
        ApexPages.StandardController con2 = new ApexPages.StandardController(acc);
        
        Industry_Survey_Score_Overall_Cls atrsc1= new Industry_Survey_Score_Overall_Cls(con2);
     }
       
 }