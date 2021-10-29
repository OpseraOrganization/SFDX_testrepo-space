@isTest(SeeAllData=true)
private class SPEX_Pilatus_OEM_Dashboard_cls_TestClass
{
    
    static testMethod void SPEX_Pilatus_OEM_Dashboard_cls_Method1()
    {
        test.startTest();
        SPEX_Pilatus_OEM_Dashboard_cls spexPilatus = new SPEX_Pilatus_OEM_Dashboard_cls();
        
        PageReference pageRef1 = page.SPEX_Dashboard_OEM_Details; //SPEX_Dashboard_OEM_Details
        Test.setCurrentPage(pageRef1);

        ApexPages.currentPage().getParameters().put('OEM', 'Dassault1');
        SPEX_Inv_Platform_Sel_cls invPlatSel = new SPEX_Inv_Platform_Sel_cls();
        
        //2nd page---------------------------------
        
        PageReference pageRef2 = Page.SPEX_Dashboard_Platform;
        Test.setCurrentPage(pageRef2);
        //System.currentPageReference().getParameters().put('OEM', 'DASSAULT&PLATFORM');
        //System.currentPageReference().getParameters().put('', 'FALCON 900');
        
        ApexPages.currentPage().getParameters().put('OEM', 'Dassault1');
        ApexPages.currentPage().getParameters().put('PLATFORM', 'Falcon 20001');

        SPEX_Inv_Platform_Detail_cls invPlatDetails = new SPEX_Inv_Platform_Detail_cls();
        test.stopTest();
    }
}