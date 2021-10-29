public class FutureMethodForCreatingUser{
    public static boolean enableUser_Sync_FunctionalRoles = true;
    @future
    public static void createuser(set<id> con,set<Id> wtool){
        enableUser_Sync_FunctionalRoles = false;
        string alia;
        integer len;
        set<Id> caseidset=new set<Id>();
        list<Contact> updatecont=New list<Contact>();
        list<user> userlist=New list<user>();
        list<case> caselist=New list<case>();
        list<case> updatecase=New list<case>();
        List<User> userLists =new List<User>();   
        list<Contact_Tool_Access__c> cta=New List<Contact_Tool_Access__c>([select id,CRM_Contact_ID__c,CRM_Contact_ID__r.FIRSTNAME,CRM_Contact_ID__r.Honeywell_ID__c,CRM_Contact_ID__r.LASTNAME,CRM_Contact_ID__r.EMAIL,CRM_Contact_ID__r.SBU_Contact__c,CRM_Contact_ID__r.Country_Name__c,CRM_Contact_ID__r.CBT__c,CRM_Contact_ID__r.CBT_Team__c,Name,Request_Status__c from Contact_Tool_Access__c where Id in: wtool]);
        List<user> userList1=[SELECT ID,IsActive, ContactId, Contact.Firstname, Contact.Lastname, ProfileId, Profile.Name FROM User WHERE ContactID IN : con];
         system.debug('userList1'+userList1);
        if (userList1.isEmpty())
        {  
            for(Contact_Tool_Access__c cta1:cta){
                if((cta1.Name=='Honeywell Training'&& cta1.Request_Status__c=='Approved'&& cta1.CRM_Contact_ID__c != null && cta1.CRM_Contact_ID__r.Honeywell_ID__c !=null) || 
                   (cta1.Name=='Technical Knowledge Center'&& cta1.Request_Status__c=='Approved'&& cta1.CRM_Contact_ID__c != null && cta1.CRM_Contact_ID__r.Honeywell_ID__c !=null)
                  ) {
                    user use=New user();
                    // use.ProfileId='00e30000001Y38l';
                    //for at2
                    use.ProfileId=label.Custom_Customer_Portal;
                    use.FIRSTNAME=cta1.CRM_Contact_ID__r.FIRSTNAME;
                    use.LASTNAME=cta1.CRM_Contact_ID__r.LASTNAME;
                    use.EMAIL=cta1.CRM_Contact_ID__r.EMAIL;
                    use.Contactid=cta1.CRM_Contact_ID__c;
                    use.TimeZoneSidKey = 'America/Los_Angeles';
                    use.LocaleSidKey='en_US';
                    use.EmailEncodingKey = 'ISO-8859-1';
                    use.LanguageLocaleKey = 'en_US';
                    if(((use.LASTNAME).length())>=4){
                        alia=(((cta1.CRM_Contact_ID__r.FIRSTNAME).substring(0,1))+((cta1.CRM_Contact_ID__r.LASTNAME).substring(0,4)));
                    }else{
                        len=(use.LASTNAME).length();
                        alia=(((cta1.CRM_Contact_ID__r.FIRSTNAME).substring(0,1))+((cta1.CRM_Contact_ID__r.LASTNAME).substring(0,len)));
                    }
                    use.Alias=alia;
                    string usenam='@Honeywell.com.qa';
                    //use.Username=(((cta1.CRM_Contact_ID__r.FIRSTNAME))+'.'+((cta1.CRM_Contact_ID__r.LASTNAME))+usenam);
                    use.username=cta1.CRM_Contact_ID__r.EMAIL+'.portal';
                    use.CommunityNickname=((cta1.CRM_Contact_ID__r.EMAIL).split('@',2)[0])+' portal';
                    use.FederationIdentifier=cta1.CRM_Contact_ID__r.Honeywell_ID__c.tolowerCase();
                    
                    
                    System.debug('&&&&&&&&&&&&&&&&&&&&&FederationIdentifier'+use.FederationIdentifier);
                    use.SBU_User__c=cta1.CRM_Contact_ID__r.SBU_Contact__c;
                    use.Country__c=cta1.CRM_Contact_ID__r.Country_Name__c;
                    if(cta1.CRM_Contact_ID__r.CBT__c!= null)
                        use.CBT__c=cta1.CRM_Contact_ID__r.CBT__c;
                    if(cta1.CRM_Contact_ID__r.CBT_Team__c!= null)
                        use.CBT_Team__c=cta1.CRM_Contact_ID__r.CBT_Team__c;
                    caseidset.add(cta1.CRM_Contact_ID__c);      
                    userlist.add(use);
                }
            }
            
            insert userlist;
            
            for(User usel:userlist){
                Contact cont = New Contact(Id=usel.Contactid);
                cont.Customer_Portal_UserId__c=usel.id;
                updatecont.add(cont);
            }
            //Contact cont=[Select Id, Customer_Portal_UserId__c from Contact where Id =:cta[0].CRM_Contact_ID__c];
            //cont.Customer_Portal_UserId__c=userlist[0].Id;
            update updatecont;
        }else{
            system.debug('else section');
              //user inactive and profile name is Idea and training authenticated website user then activate user.
            	if(userList1[0].IsActive!=true && userList1[0].ProfileId==label.Custom_Customer_Portal){
                	 for(user usr : userList1){
                         //if(usr.IsActive==false && usr.ProfileId==label.Custom_Customer_Portal){
                         usr.IsActive=true;
                         userLists.add(usr);
                     }
                }


            system.debug('userLists'+userLists);
            	if(!userLists.isEmpty()){
           			update userLists;
      			}
        }
        caselist=[select id , Subject,Resolution__c,isclosed,Sub_Class__c from case where
                  subject='MyAerospace Registration Request – Honeywell Training'
                  and 
                  
                  Contactid in: caseidset];
        for(case cas:caselist){
            // cas.subject='MyAerospace Registration Request – Honeywell Training';
            cas.Resolution__c='None';
            cas.status='Approved';
            Cas.Sub_Class__c='';
            cas.Export_Compliance_Content_ITAR_EAR__c='No';
            cas.Government_Compliance_SM_M_Content__c='No';
            updatecase.add(cas);
        }
        update updatecase;
    }
}