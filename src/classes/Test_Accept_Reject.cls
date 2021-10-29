@isTest
private class Test_Accept_Reject{ 

static testMethod void Accept_Reject_Testcls()
{

Product2 ProdRec=new product2();
ProdRec.name='Test';
insert ProdRec;

ApexPages.StandardController controller= new ApexPages.StandardController(ProdRec);
//System.currentPagereference().getParameters().put('id',savDr.id);
Accept_Reject wrkDetails=new Accept_Reject(controller);
wrkDetails.getproducts();

Approval.ProcessSubmitRequest req1 = 
            new Approval.ProcessSubmitRequest();
        req1.setComments('Submitting request for approval.');
        req1.setObjectId(ProdRec.id);

 
}

}