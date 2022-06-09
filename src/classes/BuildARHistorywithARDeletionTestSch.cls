@isTest
public class BuildARHistorywithARDeletionTestSch{
public static testmethod void test1(){

Test.startTest();
//SchedulableBuildARHistorywithARDeletion sh1 = new SchedulableBuildARHistorywithARDeletion();

System.schedule('Schedule J Name Second weekly', '0 0 12 ? * WED', new SchedulableBuildARHistorywithARDeletion (200));
//Weekly 12 ok clock wedenesday

Test.stopTest();
   
} 
}