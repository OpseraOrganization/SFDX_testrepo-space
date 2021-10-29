/*
Created By : Akash kingare
Created Date : Jan-15-2019
Usages : test class methods for ordersCase class
*/
@isTest
public class ordersCaseTest {
    
     @testSetup
    static void setupData() {
         Case cas = (Case)SObjectFactory.create(
               Case.sObjectType, new Map<Schema.SObjectField, Object>
                {   Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'Order Status', 
                    Case.recordtypeid => RecordTypeServices.getRecordTypeByName('Orders','Case').Id ,
                    Case.Status =>'Open',
                    Case.Sub_Status__c => 'WIS',
                    Case.Tool_Name__c=> 'test',
                    case.Description => 'Part/Product #:123456',
                    case.subject => 'Webform;Place an Order; RFQ'
                });  
    }
    
    static testMethod void testMethodCaseTrigger1(){
        Test.startTest();
        case parentCase = [SELECT id, caseNumber FROM Case LIMIT 1];
        Case cas = (Case)SObjectFactory.create(Case.sObjectType, new Map<Schema.SObjectField, Object>
                        {   Case.OwnerId => UserInfo.getUserId(),
                            Case.Type => 'Order Status', 
                            Case.recordtypeid => RecordTypeServices.getRecordTypeByName('Orders','Case').Id ,
                            Case.Status =>'Open',
                            Case.Sub_Status__c => 'WIS',
                            Case.Tool_Name__c=> 'test',
                            case.Description => 'Quote Case Number:'+parentCase.caseNumber,
                            case.subject => 'Webform;Place an Order; RFQ'
                       });
        Test.stopTest();
    }
}