@isTest
public class DSPC_Campaign_List_controller_test {
    static testMethod void myUnitTest() {
        test.startTest();
        integer i;
        List<Campaign> cmp = new List<Campaign>();
        for(i=0;i<11;i++) {
        cmp.add(new Campaign(
        Name = 'Test Campaign1',
        CampaignPrimarySBU__c = 'D&S',
        CampaignPrimaryCBTTier2__c = 'DSPC',
        CBT_Team__c = 'ORION',
        Type = 'Catalog',
        D_S_Campaign__c = true,
        IsActive = true));
        }
        insert cmp;
        system.debug('&&&&&&&&&&&&&&&&&'+cmp.size());
        PageReference pageRef = Page.DSPC_Campaign_List;
        Test.setCurrentPage(pageRef);
        for(Campaign c: cmp) {
            pageRef.getParameters().put('id',c.id);
            }
            DSPC_Campaign_List_controller Cntlr = new DSPC_Campaign_List_controller();        
        Cntlr.previous();
        Cntlr.next();
        //Cntlr.hasNext=true;
        List<Campaign> lstCampaignTest = Cntlr.AllSearchcams;
        Boolean bhasNext = Cntlr.hasNext;
        //cntlr.hasPrevious=true;
        Boolean bhasPrevious = Cntlr.hasPrevious;
        //cntlr.pageNumber=1;
        Integer ipageNumber = Cntlr.pageNumber;
        system.debug('&&&&&&&&&&&&&&&&&'+Cntlr);
        test.stopTest();
                
    }    
}