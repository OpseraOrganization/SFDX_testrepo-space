@isTest(seeAllData = true)
public  class D_S_test_ApexTrigger_InsertCampaignGates
{
  /****  static testmethod void Campaign_InsertCampaignGates()
    {
        Profile pf = [select name from Profile where name = 'D&S Sales'];
        Account a1 = New Account(Name= 'sbuaccount' ,Strategic_Business_Unit__c = 'D&S',   CBT__c = 'HTSI');
        insert a1;
        Campaign c1 = new Campaign(Name='Complexcamp',Type ='Competitive',Account_Name__c=a1.Id );
        insert c1;
        Campaign c2 = new Campaign(Name='Focuscamp',Type ='Focus',Account_Name__c=a1.Id );
        insert c2;
        Campaign c3 = new Campaign(Name='Keycamp',Type ='Key',Account_Name__c=a1.Id );
        insert c3;
        Campaign c4 = new Campaign(Name='Complexcamp');
        insert c4;
        Contact cnt1 = new Contact(LastName = 'Test contact',firstname='Test',Contact_Is_Employee__c =True,Functional_Role__c='testrole',phone_3__c='89652',Employee_Number__c='E123567',Employee_Contact_Role__c='Administrator' );
        insert cnt1;
        cnt1.Functional_Role__c='testrolesupdate';
        update cnt1;
        User u1 = new User(LastName = 'Test User',Username = 'testuserrewwwd@test.com.honeywell',Email = 'testuser@test.com',Alias = 'tuser' ,CommunityNickname= 'tuser' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 'en_US',Functional_Role__c='testroleuser');
        insert u1;
        u1.Functional_Role__c='testroleupdate';
        update u1;
        User u2 = new User(LastName = 'Test User 2 ',Username = 'test2wwww00@test.com.honeywell',Email = 'testuser2@test.com',Alias = 'tuser2' ,CommunityNickname= 'tuser2' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId =pf.Id, LanguageLocaleKey = 'en_US');
        insert u2;
        Campaign_Team__c ct1 = new Campaign_Team__c(Campaign__c = c4.Id,Contact__c = cnt1.Id);
        Campaign_Team__c ct2 = new Campaign_Team__c(Campaign__c = c4.Id,Team_User__c = u1.Id);
        List<Campaign_Team__c> ctlist = new List<Campaign_Team__c>();
        List<Campaign_Team__c> ctlist1 = new List<Campaign_Team__c>();
        List<Campaign_Team__c> ctlist2 = new List<Campaign_Team__c>();
        ctlist.add(ct1);
        ctlist.add(ct2);
        insert ctlist;
        Campaign_Team__c ct8 = new Campaign_Team__c(Campaign__c = c4.Id,Team_User__c = u1.Id);
        Campaign_Team__c ct9 = new Campaign_Team__c(Campaign__c = c4.Id,Team_User__c = u1.Id);
        ctlist1.add(ct8);
        ctlist1.add(ct9);
        try
        {
            insert ctlist1;
        }
        catch(System.DMLException e){System.assert(e.getMessage().contains(
                'This User is already a Campaign Team Member'),
                  e.getMessage());
        }
        Campaign_Team__c ct10 = new Campaign_Team__c(Campaign__c = c4.Id,Contact__c = cnt1.Id);
        Campaign_Team__c ct11 = new Campaign_Team__c(Campaign__c = c4.Id,Contact__c = cnt1.Id);
        ctlist2.add(ct10);
        ctlist2.add(ct11);
        try
        {
            insert ctlist2;
        }
        catch(System.DMLException e){System.assert(e.getMessage().contains(
                'This Contact is already a Campaign Team Member'),
                  e.getMessage());
        }

        Campaign_Team__c ct3 = new Campaign_Team__c(Campaign__c = c3.Id,Contact__c = cnt1.Id);
        insert ct3;
        Campaign_Team__c ct4 = new Campaign_Team__c(Campaign__c = c3.Id,Contact__c = cnt1.Id);
        try
        {
            insert ct4;
        }
        catch(System.DMLException e){System.assert(e.getMessage().contains(
                'This Contact is already a Campaign Team Member'),
                  e.getMessage());
        }
        Campaign_Team__c ct5 = new Campaign_Team__c(Campaign__c = c2.Id,Team_User__c = u1.Id);
        insert ct5;
        Campaign_Team__c ct6 = new Campaign_Team__c(Campaign__c = c2.Id,Team_User__c = u2.Id);
        insert ct6;
        Campaign_Team__c ct7 = new Campaign_Team__c(Campaign__c = c2.Id,Team_User__c = u2.Id);
        try
        {
            insert ct7;
        }
        catch(System.DMLException e){System.assert(e.getMessage().contains(
                'This User is already a Campaign Team Member'),
                  e.getMessage());
        }
        Campaign c100 = new Campaign(Name='Focuscamp100',Type ='Focus',CampaignPrimarySBU__c = 'D&S',CampaignPrimaryCBTTier2__c = 'Advanced Technology',CBT_Team__c = 'ASM: Advanced Sensors & Microsystems');
        insert c100;
        if(c100 != null)
        {
            List<Campaign_Gate__c> cg = [select id from Campaign_Gate__c where campaign__c = :c100.id];
            if(cg.size()>0)
            {
                Date d1 =Date.newInstance(2009,08,12);
                Date d2 =Date.newInstance(2009,08,12);
                Date d3 =Date.newInstance(2010,08,12);
                cg[0].Expected_DAte__c = d1;
                //cg[1].Expected_DAte__c = d1;
                update cg[0];
                //update cg[1];
                Planned_Meeting__C p= new Planned_Meeting__C(Name = 'test meeting',Start__c=d1,End__c= d2);
                insert p;
                //cg[0].Planned_Meeting__C = p.id;
                cg[0].Actual_date__c = d2;
                update cg[0];
                cg[0].Actual_date__c = null;
                update cg[0];
                c100.status = 'Cancel';
                update c100;
            }
        }
        Campaign cc = [select id,type,RecordTypeId from Campaign where recordTypeId !=:label.Id_of_BGA_record_type_of_Campaign limit 1]; 
        List<Campaign> c11 = new List<Campaign>();
        Campaign cvv = new campaign(name='test',type='focus',recordTypeId=cc.RecordTypeId,Account_Name__c=a1.Id);
        Campaign cvv1 = new campaign(name='test',type='key',recordTypeId=cc.RecordTypeId,Account_Name__c=a1.Id);
        c11.add(cvv);
        c11.add(cvv1);
        insert c11;
    }****/
    static testmethod void Campaign_UpdateTollGates(){
        Account a1 = New Account(Name= 'sbuaccount' ,Strategic_Business_Unit__c = 'D&S',   CBT__c = 'HTSI');
        insert a1;
        Matrix__c m = new Matrix__c(Campaign_Type__c='Competitive',Serial_No__c=1,Phase__c='Closed');
        insert m;       
        Campaign c1 = new Campaign(Name='Complexcamp',Type ='D&S Complex',Account_Name__c=a1.Id, Status = 'Completed', Recordtypeid='01230000000ZQCl');
        insert c1;
        Campaign c11 = new Campaign(Name='Complexcamp',Type ='Competitive',Account_Name__c=a1.Id, Status = 'Planned', Recordtypeid='01230000000ZQCl');
       // insert c11;
       // c11.Status = 'Completed';
       // update c11;
         Campaign cc11 = new Campaign(Name='Complexcamp',Type ='Key',Account_Name__c=a1.Id, Status = 'Planned', Recordtypeid='01230000000ZQCl');
      //  insert cc11;
      //  cc11.Status = 'Completed';
      //  update cc11;
         Campaign c111 = new Campaign(Name='Complexcamp',Type ='Focus',Account_Name__c=a1.Id, Status = 'Planned', Recordtypeid='01230000000ZQCl');
      //  insert c111;
      //  c111.Status = 'Completed';
      //  update c111;
        List<Campaign> cb = new List<Campaign>();
        cb.add(c11);
        cb.add(c111);
        cb.add(cc11);
        insert cb;
        Date d =Date.newInstance(2017,06,21);
        List<Campaign_Gate__c> cg1 = [select id,Expected_Date__c,Is_Campaign_Completed__c from Campaign_Gate__c where campaign__c = :c111.id];
        if(cg1.size()>0){
            cg1[0].Expected_Date__c = d;
            update cg1[0];
        }
        Account acc = new Account();
        acc.Name = 'Honeywell Test';
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'D&S';
        acc.CBT__c = 'DAA';
        acc.Region_Name__c = 'Americas';
        acc.Sub_Region_Name__c = 'Canada';
        acc.Service_Level__c = 'Standard';
        acc.Type = 'OEM';
        acc.Authorized_Service_Center__c = true;
        acc.REPORT_ACCOUNT_NAME__c = 'HONEYWELL TEST';
        insert acc;
    }
}