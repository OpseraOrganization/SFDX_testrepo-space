@isTest(SeeAllData=true)
public class IdeaExchPostclsTest{
    static testMethod void test1(){
        
        IdeaExchPostcls.getProductorgLists();
        IdeaExchPostcls.getstatusLists();
        IdeaExchPostcls.getCatergoriesLists();
        IdeaExchPostcls.insertpost('Other','Test Title', 'Test description', 'Test Prod'); 
    }

}