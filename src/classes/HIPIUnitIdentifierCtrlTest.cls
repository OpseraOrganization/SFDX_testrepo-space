@isTest(seealldata=true)
public class HIPIUnitIdentifierCtrlTest{
    static testMethod void myUnitTest() 
    {
    
        opportunity opp=new opportunity();
        opp.name='Test Opp';
        opp.CloseDate=date.parse('04/24/2016');        
        insert opp;
        ApexPages.StandardController stdController = new ApexPages.StandardController(opp);
        HIPIUnitIdentifierCtrl HIPI= new HIPIUnitIdentifierCtrl(stdController);
        HIPI.getvalues();
        HIPI.sbg='AERO';
        HIPI.sbu='BGA';
        HIPI.sbe='Aero Services';
        HIPI.grp='Maintenance Services';
        HIPI.line='Ground Support Solutions';
        HIPI.type='Ground Support Solutions';
        HIPI.spc='2001000007';
        HIPI.allocation='100';
        
        
    }
        
}