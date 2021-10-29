@isTest
public class TestClassltIE9Check_Controller{ 
   static testmethod void  ltIE9Check_Controller(){



      ltIE9Check_Controller test = new ltIE9Check_Controller();
        test.userAgent='MSIE';
        test.getIE8Fix();
        test.userAgent='test';
        test.getIE8Fix();

    }
}