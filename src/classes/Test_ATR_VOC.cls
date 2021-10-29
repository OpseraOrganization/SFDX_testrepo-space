@isTest(SeeAllData=true)
private class Test_ATR_VOC {
    
    
    static testMethod void Test_ATR() {
      
        
        Test.startTest();
        

       
        ATR_VOC controller = new ATR_VOC();
        controller.selectedAccout='test';
        list<string> styp= new list<string>{ 'ALL','ALL','ALL','' };
          ATR_VOC.RemFeedback(styp);
          controller.setInputvalue();
          controller.getAccountList();
          string accname='test';
          ATR_VOC.searchAccount(accname);
        Test.stopTest();
    }
static testMethod void Test_ATR1() {
      
        
        Test.startTest();
        

       
        ATR_VOC controller = new ATR_VOC();
        controller.selectedAccout='test';
        list<string> styp= new list<string>{ 'airbus','Avionics','2015','test' };
          ATR_VOC.RemFeedback(styp);
          controller.setInputvalue();
          controller.getAccountList();
          string accname='test';
          ATR_VOC.searchAccount(accname);
        Test.stopTest();
    }
    
}