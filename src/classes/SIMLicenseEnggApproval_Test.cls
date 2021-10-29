@isTest(seealldata=true)
public class SIMLicenseEnggApproval_Test{
    static testMethod void myUnitTest() 
    {                      
        opportunity opp=[select id,name from opportunity limit 1];
        PageReference pgr = page.AppendixEngApprove;
        pgr.getparameters().put('review' , 'engapprove');
        pgr.getparameters().put('Oppid' , opp.id);
        Test.SetCurrentPage(pgr);
        System.currentPageReference().getparameters().put('review' , 'engapprove');
        System.currentPageReference().getparameters().put('Oppid' , opp.id);       
        ApexPages.StandardController stdController = new ApexPages.StandardController(opp);     
        SIMLicenseEnggApproval HIPI= new SIMLicenseEnggApproval(); 
        HIPI.Approve();      
        HIPI.getcomments(); 
        HIPI.setcomments('test');              
    }
    static testMethod void myUnitTest1() 
    {                      
        opportunity opp=[select id,name from opportunity limit 1];
        PageReference pgr = page.AppendixEngApprove;
        pgr.getparameters().put('review' , 'mngapprove');
        pgr.getparameters().put('Oppid' , opp.id);
        Test.SetCurrentPage(pgr);
        System.currentPageReference().getparameters().put('review' , 'mngapprove');
        System.currentPageReference().getparameters().put('Oppid' , opp.id);        
        ApexPages.StandardController stdController = new ApexPages.StandardController(opp);     
        SIMLicenseEnggApproval HIPI= new SIMLicenseEnggApproval(); 
        HIPI.Approve();      
        HIPI.getcomments(); 
        HIPI.setcomments('test');             
    }
}