public class BlockGoGreen_CLS {

    public BlockGoGreen_CLS(ApexPages.StandardController controller) {}
    public PageReference go(){
        //PageReference ref=new PageReference('https://cs3.salesforce.com/a1U/o');
        //PageReference ref=new PageReference('https://na13.salesforce.com/a1U/o');
        String strbaseURL = URL.getSalesforceBaseUrl().toExternalForm();
        PageReference ref=new PageReference(strbaseURL +'/a1U/o');
            ref.setRedirect(true);
            return ref;
    }
}