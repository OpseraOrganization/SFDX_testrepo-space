@isTest (seealldata = true)
public class Discretionary_WorkflowTest{
    testMethod static void discritionaryTest(){
        Opportunity opp = [select id from opportunity limit 1];
            
        Discretionary__C disc= new Discretionary__C();
        disc.Type__c='Bid & Praposal';
        disc.SBU__c='ATR';
        
        //disc.CBT__c='EMS';
        disc.ownerid=UserInfo.getUserid();
        disc.Estimated_Completion_Date__c = System.today();
        disc.opportunity__c=opp.id;
        insert disc;
        
        Discretionary_Line_item__c DLI=new Discretionary_Line_item__c();
        DLI.Funding_Amount__c=4000;
        dli.Requested_Amount__c=5000;
        DLI.Discretionary_Request__c = disc.id;
        Test.starttest();
        insert DLI;
        disc.Approval_Status__c = 'Pending Approval';
        disc.SBU__c='D&S';
        disc.CBT__c='Advanced Technology';
        disc.Type__c='Bid & Proposal';
        update disc;
        //disc.opportunity__c=null;
        disc.SBU__c='ATR';
        update disc;
        Test.stoptest();
    }
    
    testMethod static void discritionaryTest1(){
        Opportunity opp = [select id from opportunity limit 1];
            
        Discretionary__C disc= new Discretionary__C();
        disc.Type__c='Bid & Praposal';
        disc.SBU__c='ATR';
        
        disc.CBT__c='EMS';
        disc.ownerid=UserInfo.getUserid();
        disc.Estimated_Completion_Date__c = System.today();
        disc.opportunity__c=opp.id;
        insert disc;
        
        Discretionary_Line_item__c DLI=new Discretionary_Line_item__c();
        DLI.Funding_Amount__c=4000;
        dli.Requested_Amount__c=5000;
        DLI.Discretionary_Request__c = disc.id;
        Test.starttest();
        insert DLI;
        disc.Approval_Status__c = 'Pending Approval';
        disc.SBU__c='D&S';
        //disc.CBT__c='Advanced Technology';
        disc.Type__c='Bid & Proposal';
        update disc;
        //disc.opportunity__c=null;
        disc.SBU__c=null;
        update disc;
        Test.stoptest();
    }

     testMethod static void discritionaryTest2(){
        Opportunity opp = [select id from opportunity limit 1];
            
        Discretionary__C disc= new Discretionary__C();
        disc.Type__c='Bid & Praposal';
        disc.SBU__c='ATR';
        User userValue1 = [select id,Discretionary_Workflow_Approver__c from User where id !=:UserInfo.getUserid() and isActive=true limit 1];
        User userValue = [select id,Discretionary_Workflow_Approver__c from User where id=:UserInfo.getUserid()];
        if(userValue.Discretionary_Workflow_Approver__c == null){
            userValue.Discretionary_Workflow_Approver__c = userValue1.id;
            userValue.Discretionary_Workflow_Approver_Amount__c = 500;
            update userValue;
        }
        disc.CBT__c='EMS';
        disc.ownerid=userValue.id;
        disc.Estimated_Completion_Date__c = System.today();
        disc.opportunity__c=opp.id;
        insert disc;
        
        Discretionary_Line_item__c DLI=new Discretionary_Line_item__c();
        DLI.Funding_Amount__c=40;
        dli.Requested_Amount__c=50;
        DLI.Discretionary_Request__c = disc.id;
        Test.starttest();
        insert DLI;
        disc.Approval_Status__c = 'Pending Approval';
        disc.SBU__c='D&S';
        //disc.CBT__c='Advanced Technology';
        disc.Type__c='Bid & Proposal';
        update disc;
        //disc.opportunity__c=null;
        
        dli.Requested_Amount__c=0;
        update DLI;
        disc.ownerid=userValue.id;
        disc.SBU__c='ACS Labs';
        disc.Escalate_To_Delegate__c=true;
        update disc;
        Test.stoptest();
    }
}