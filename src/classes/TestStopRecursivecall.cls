@isTest 
private class TestStopRecursivecall{
     static testMethod void methodStopRecursivecallTest() {
         StopRecursivecall.hasUpdate_OnBehalfendUserStatus();
         StopRecursivecall.getRecursiveStatus();
         StopRecursivecall.setUpdate_OnBehalfendUserStatus();
         StopRecursivecall.updateRecursiveStatus();
     }
}