/** * File Name: Test_AOGGetOneCase
* Description Test Method
* Copyright : Wipro Technologies Limited Copyright (c) 2010
* * @author : Wipro
* Modification Log =============================================================== 
Ver Date Author Modification --- ---- ------ -------------
* */ 
@isTest
private  class Test_AOGGetOneCase {
    static testmethod void testAOGGetOneCasePage(){
    
Id RecId = [select Id from RecordType where SobjectType = 'Case' and (DeveloperName = 'AOG')].Id;
      Account acc= new Account(name='Test Account');
     insert acc;
     Case cases= new Case (AccountId=acc.Id,X4_Hour_AOG__c='4-hour',recordtypeId=RecId, status='Open');
     insert cases;
          PageReference pageRef = Page.AOG_getCase;
          
         pageRef.getParameters().put('CASE',cases.Id);
          Test.setCurrentPage(pageRef);
    
     //ApexPages.StandardController sc = new ApexPages.StandardController(cases);
   AOGGetOneCase  caseCon= new AOGGetOneCase();
   AOGGetOneCaseSPEX  caseConspex= new AOGGetOneCaseSPEX();
   
   

     caseCon.getCase_one();
     caseConspex.getCase_one();
     
     
     
    }
}