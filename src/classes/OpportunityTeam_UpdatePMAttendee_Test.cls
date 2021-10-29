@isTest(seeAlldata=true)
public class OpportunityTeam_UpdatePMAttendee_Test{
    public static TestMethod void OpportunityTeam_UpdatePMAttendee_Test(){
        Opportunity_Gate__c og = [select id,Opportunity__c from Opportunity_Gate__c where actual_Date__c =null and planned_Meeting__c !=null limit 1];
        Opportunity opp = [select id from opportunity where id =:og.Opportunity__c limit 1];
        
        Profile profid = [Select id from Profile where name='Sales Admin' limit 1];
        User usr = [select id from User where IsActive = true and profileId=:profid.id limit 1];
        Opportunity_Sales_Team__c ost = new Opportunity_Sales_Team__c();
        ost.user__c = Userinfo.getUserId();
        ost.Opportunity_Team_Role__c = 'Area Sales';
        ost.Opportunity__c = opp.id;
        insert ost;
       
        delete ost;

}

}