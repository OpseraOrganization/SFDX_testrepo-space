@isTest(SeeAllData=true)
public class ATR_TEST_ApexTrigger_ATRInsertOppPhases
{
    static testmethod void insertOppPhases()
    {
        Account a1 = New Account(Name= 'sbuaccount',Strategic_Business_Unit__c = ']',   CBT__c = 'HTSI');
        insert a1;
        Date d1 =Date.newInstance(2009,08,12);
        Profile pf= [select id from Profile where name = 'ATR Sales'];
        User u1 = new User(LastName = 'Test User',Username = 'tu1wewe@test.com',Email = 'testuser@test.com',Alias = 'tu1' ,CommunityNickname= 'tu1' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'ATR');
        insert u1;
        User uNew = new User(LastName = 'Test User',Username = 'honnewwewew@test.com',Email = 'testuser@test.com',Alias = 'tu1' ,CommunityNickname= 'tu1honey' ,
        TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US'
        ,EmailEncodingKey= 'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'ATR',MobilePhone='123');
        insert uNew;
        System.runas(u1){
        uNew.MobilePhone='53';
        //update uNew;
        //update uNew;
        }
        RecordType r1 = [select id , name from RecordType where name='AM Complex'];
        RecordType r2 = [select id , name from RecordType where name='AM Standard'];
        Date yest=System.today()-1;
        List<Opportunity> opps=new List<Opportunity>();
        Matrix__c m1= new Matrix__c(Phase__c= 'p1',Opportunity_Type__c = 'AM Standard');
        insert m1;
        Matrix__c m3= new Matrix__c(Phase__c= 'p1',Opportunity_Type__c = 'AM Complex');
        insert m3;
        Opportunity o1 = new Opportunity(Name='Standardopp',recordtypeid =r1.id,Accountid=a1.Id,StageName='Cultivate',CloseDate=d1, Type_of_Opportunity__c = 'RMU – Level 3 (Low Probability)',Amount=1,Program_Terms__c='1'  );
        insert o1;
        Opportunity o2 = new Opportunity(Name='Complexopp',recordtypeid =r2.id,Accountid=a1.Id,StageName='Closed Won',CloseDate=System.Today()-1,SBU__c='ATR', Type_of_Opportunity__c = 'RMU – Level 3 (Low Probability)',Amount=1,Program_Terms__c='1'  );
        insert o2;
   
                   
        VF_Template_Controller OppClosedYest=new VF_Template_Controller();
        Opportunity o3 = new Opportunity(Name='Complexopp',recordtypeid =r2.id,Accountid=a1.Id,StageName='Closed Won',CloseDate=yest, SBU__c='ATR', Type_of_Opportunity__c = 'RMU – Level 3 (Low Probability)',Amount=1,Program_Terms__c='1');
        insert o3;
        System.Debug('o3'+o3);
        opps=OppClosedYest.getClosedYest();
        
        /*Test.startTest();
        Opportunity o4 = new Opportunity(Name='Complexopp',recordtypeid =r2.id,Accountid=a1.Id,StageName='Closed Won',CloseDate=yest, SBU__c='ATR');
        insert o4;
        ATR_Opp_Closed_yest  sched=new ATR_Opp_Closed_yest();
        String sch='0 0 23 * * ?';   
        System.schedule('Sample Scheduling',sch,sched);
        test.stopTest();*/
}
}