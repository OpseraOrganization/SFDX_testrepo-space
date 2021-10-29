@isTest(seealldata=true)
private class ATR_Survey_Comparison_Cls_Test {

   static testMethod void TestATRSurveComp() 
    {
        Account acc= new Account();
        acc = [select id from account where id='0013000000bFxi9'];        
                
        ApexPages.StandardController con2 = new ApexPages.StandardController(acc);
        ATR_Survey_Comparison_Cls atrsc= new ATR_Survey_Comparison_Cls();  
        PageReference pageRef = Page.CSWI_ListView;
        Test.setCurrentPage(pageRef); 
        
        atrsc.previous();
        atrsc.next();
        atrsc.sortExpression='';
        atrsc.getSortDirection();
        atrsc.sortExpression='DESC';
        atrsc.getSortDirection();
        atrsc.setSortDirection('DESC');
        atrsc.ViewData();
        ApexPages.StandardSetController cs =null;

        ATR_Survey_Comparison_Cls atrsc1= new ATR_Survey_Comparison_Cls();  
        PageReference pageRef1 = Page.CSWI_ListView;
        Test.setCurrentPage(pageRef1); 
        
        atrsc1.previous();
        atrsc1.next();
        atrsc1.sortExpression='name';
        atrsc1.getSortDirection();
        atrsc1.sortExpression='ASC';
        atrsc1.getSortDirection();
        atrsc1.setSortDirection('ASC');
        ATR_Survey_Comparison_Cls atrsc2= new ATR_Survey_Comparison_Cls(con2); 
    }
    
 }