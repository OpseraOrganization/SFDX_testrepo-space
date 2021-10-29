@isTest(seealldata=true)
public class HwTrng_TestClass5
{
    static testmethod void dotest()
    {
        Account AcctRec= New Account(Name= 'sbuaccount',Strategic_Business_Unit__c = 'D&S', CBT__c = 'HTSI');
        insert AcctRec;
    
        Contact CntRec=new Contact(lastname='Honeywell',accountId=AcctRec.Id,Contact_Is_Employee__c=true,Phone_3__c ='9986555678',Functional_Role__c='FunctionalRole1678',CBT__c = 'HTSI', Employee_Contact_Role__c='Analyst',Employee_Number__c='T123567',Customer_Portal_UserId__c = '');
        insert CntRec;
    
        /*Profile pf = [select name from Profile where name = 'Custom Customer Portal'];
         
        User UsrCstPrtl= new User(LastName = 'Test User',Username = 'testuser@test.com.honeywell',Email = 'testuser@test.com',Alias ='tuser' ,CommunityNickname= 'tuserhoney' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 
                              'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey ='en_US',Functional_Role__c='testrole',SBU_User__c='testsbu',CBT__c='HTSI',CBT_Team__c ='testcbtteam',contactid =CntRec.id);
                              
        insert UsrCstPrtl;*/
        
       // User UsrCstPrtl;
          profile p=[select id,name from profile where name='Custom Customer Portal' limit 1];
          User UsrCstPrtl = new User(alias = 'test123', email='test123@noemail.com',
                emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                localesidkey='en_US', profileid = p.id, country='United States',IsActive =true,
                ContactId = CntRec.Id,
                timezonesidkey='America/Los_Angeles', username='tester@noemail.com');
       
        insert UsrCstPrtl;
       /* List<User> lstU1 = [select id from user where profileid = '00e30000001Y4ARAA0' and IsActive =true];
        if(lstU1!=null && lstU1.size() > 0)
        {
            UsrCstPrtl=lstu1[0];
        }
        else
        {
            UsrCstPrtl=new User (id=userinfo.getuserid());
        }*/
        System.runas(UsrCstPrtl)
        {
            List<Contact> contactlst = new List<Contact>();
            UsrCstPrtl.firstname='Testmethod';
            list<id> UserId=new list<id>();
            UserId.add(UsrCstPrtl.id);
            list<id> CntLstId=new list<id>();
            contactlst = [select name,Id,Customer_Portal_UserId__c from Contact where id in :CntLstId and Customer_Portal_UserId__c = ''];
            CntLstId.add(UsrCstPrtl.contactid);
            //HwTrng_Updatescontact HwTrngRec =HwTrng_Updatescontact(UserId);
            Test.startTest();   
            //HwTrng_Updatescontact.Updatescontact(CntLstId,UserId);
            HwTrng_Updatescontact.Updatescontact(new list<id>{CntRec.id},new list<id>{UsrCstPrtl.id});
            //system.assertEquals('Testmethod',lstU1[0].firstname);               
            system.assertEquals(CntRec.id,UsrCstPrtl.contactid);
            Test.stopTest();
        }
        
    }
    
}