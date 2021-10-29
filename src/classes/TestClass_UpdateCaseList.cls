@isTest(seeallData=True)
public class TestClass_UpdateCaseList{
    static testMethod void UpdateCaseList(){
        Test.startTest();
        Set<Id> classSet = new set<Id>{'500a000000RIruu','500a000000PWLqU','500a000000RIruu'};
        System.debug(classSet);
        UpdateCaseList UC = new UpdateCaseList();
        UpdateCaseList.updateCase(classSet);
        Test.stoptest();        
    }
}