@isTest
private class CSWIListViewCls_Test {

   static testMethod void TestCSWIListViewCls() 
    {
        Customer_Specific_Work_Instruction__c cs= new Customer_Specific_Work_Instruction__c();
        ApexPages.StandardController con2 = new ApexPages.StandardController(cs);
        CSWI_ListViewCls cswii= new CSWI_ListViewCls();  
        PageReference pageRef = Page.CSWI_ListView;
        Test.setCurrentPage(pageRef); 
        cswii.previous();
        cswii.next();
        cswii.getSortDirection();
        //cswii.setSortDirection();
        cswii.ViewData();  
        Boolean a = cswii.hasPrevious;
        Boolean b = cswii.hasnext;     
        Integer c = cswii.pagenumber;   
        cswii.setSortDirection('ASC');
        List<Customer_Specific_Work_Instruction__c> ab = cswii.AllSearchcase;
        String ac = cswii.sortExpression;
    }
 }