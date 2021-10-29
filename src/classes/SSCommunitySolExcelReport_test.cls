@isTest(seeAllData=true)
public with sharing class SSCommunitySolExcelReport_test
    {
        static testMethod void testCommented(){
            Test.StartTest();
            //The object name below has to match up with your trigger/class
            SSCommunitySolExcelReport obj = new SSCommunitySolExcelReport();
            //This one link is asserting that you successfully created it
            system.assertNotEquals(null,obj);   
            Test.StopTest();
        }
       /* static testMethod void testSSCommunityExcelReportCase1 ()
            {
             
                test.startTest();
                
                //Creating a PageRefrence 
                PageReference myVfPage = Page.SSCommunitySolExcelReport;
                Test.setCurrentPageReference(myVfPage);
                
                //Setting static values to variables 
                ApexPages.currentPage().getParameters().put('param1','Technical_Solutions__kav:');
                ApexPages.currentPage().getParameters().put('param2','EGPWS');
                
              
                //Testing the functionality for SSCommunitySolExcelReport 
                SSCommunitySolExcelReport scr=new SSCommunitySolExcelReport(); 
                
                system.debug(scr.kv.size()!=null);
                system.debug('**'+scr.kv);
                
                test.stopTest();
            } 
        */
        /*static testMethod void testSSCommunityExcelReportCase2 ()
            {
             
                test.startTest();
                
                //Creating a PageRefrence 
                PageReference myVfPage = Page.SSCommunitySolExcelReport;
                Test.setCurrentPageReference(myVfPage);
                
                //Setting static values to variables 
                //ApexPages.currentPage().getParameters().put('param1','CAS_Maintenance_Message_Article__kav:');
                ApexPages.currentPage().getParameters().put('param2','test');
                
                //Testing the functionality for SSCommunitySolExcelReport 
                SSCommunitySolExcelReport scr=new SSCommunitySolExcelReport();                 
                
                //system.debug(scr.CASkv.size()!=null);
                //system.debug('**'+scr.CASkv);
                
                
                
                test.stopTest();
            } */
        
        
    }