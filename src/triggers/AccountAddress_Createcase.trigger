trigger AccountAddress_Createcase on Account_Address__c (after update){

    list<case> insertcas = New list<case>();
    
    string AccAddress;
    //SR#425182 BGA channel partner changes starts
    //string Accowneremail;
    string Accownername;
    boolean MobileAppVisibility;
    string accownermanageremail;
    set<id> acdid=new set<id>();
    List<Account_Address__C> accadd3=new List<Account_Address__C>();
    //set<id> accownerid=new set<id>();
    string accaccountid;
    string accownerid;
    //SR#425182 BGA channel partner changes ends
    for(Account_Address__C acd: trigger.new){
        if((Trigger.newMap.get(acd.id).Denied_Party_Status__c!=Trigger.oldMap.get(acd.id).Denied_Party_Status__c)&&(Trigger.newMap.get(acd.id).Denied_Party_Status__c=='Further Review Needed')&&((Trigger.oldMap.get(acd.id).Denied_Party_Status__c=='Pending Block')||(Trigger.oldMap.get(acd.id).Denied_Party_Status__c=='Not Reviewed')))
        {
        system.debug('****************Entered if'+acd.Denied_Party_Status__c);
        system.debug('****************Entered if'+acd.Denied_Party_Status__c);
            if((acd.Address_Name__c.length()>60)){
             system.debug('****************Entered if if');
                AccAddress=(acd.Address_Name__c).substring(0, 59);
            }else{
                AccAddress=acd.Address_Name__c;
                 system.debug('****************Entered if else');
            }
            case cas= New case ();
            cas.Accountid=acd.Account_Name__c;
            cas.Account_Address_Name__c=AccAddress;
            cas.subject='Further Review Needed';
            cas.ownerid=label.Customer_Master_Data_SFDC_Accounts;
            cas.origin='Denied Party Screening';
            cas.recordtypeid=label.Customer_Master_Data_Record_Type;
            //cas.Contactid=label.Honeywell_Default_Contact_Id;
            cas.Classification__c='Customer Master Data / Team eBusiness';
            cas.Government_Compliance_SM_M_Content__c='No';
            cas.Export_Compliance_Content_ITAR_EAR__c='No';
            cas.Type='AERO SFDC';
            insertcas.add(cas);
            system.debug('**************** Case inserted');
        }
        //SR#425182 BGA channel partner changes starts
        if(Trigger.newMap.get(acd.id).BGAMob_Contact_Name__c!=Trigger.oldMap.get(acd.id).BGAMob_Contact_Name__c
            || Trigger.newMap.get(acd.id).BGAMob_Customer_Phone__c !=Trigger.oldMap.get(acd.id).BGAMob_Customer_Phone__c
            || Trigger.newMap.get(acd.id).BGAMob_Contact_Email__c !=Trigger.oldMap.get(acd.id).BGAMob_Contact_Email__c
            || Trigger.newMap.get(acd.id).BGAMob_Website__c !=Trigger.oldMap.get(acd.id).BGAMob_Website__c
            || Trigger.newMap.get(acd.id).Mobile_App_Visibility__c !=Trigger.oldMap.get(acd.id).Mobile_App_Visibility__c
            || Trigger.newMap.get(acd.id).BGAMob_Address_1__c !=Trigger.oldMap.get(acd.id).BGAMob_Address_1__c
            || Trigger.newMap.get(acd.id).BGAMob_Address_2__c !=Trigger.oldMap.get(acd.id).BGAMob_Address_2__c
            || Trigger.newMap.get(acd.id).BGAMob_Address_3__c !=Trigger.oldMap.get(acd.id).BGAMob_Address_3__c
            || Trigger.newMap.get(acd.id).BGAMob_City_Name__c !=Trigger.oldMap.get(acd.id).BGAMob_City_Name__c
            || Trigger.newMap.get(acd.id).BGAMob_Postal_Code__c !=Trigger.oldMap.get(acd.id).BGAMob_Postal_Code__c
            || Trigger.newMap.get(acd.id).BGAMob_State_Province__c !=Trigger.oldMap.get(acd.id).BGAMob_State_Province__c
            || Trigger.newMap.get(acd.id).BGAMob_Country_Nm__c !=Trigger.oldMap.get(acd.id).BGAMob_Country_Nm__c
            || Trigger.newMap.get(acd.id).Mechanical_Product_Lines__c !=Trigger.oldMap.get(acd.id).Mechanical_Product_Lines__c
            || Trigger.newMap.get(acd.id).Authorized_Mechanical_Service_Center__c !=Trigger.oldMap.get(acd.id).Authorized_Mechanical_Service_Center__c         
            || Trigger.newMap.get(acd.id).Engine_Authorization__c !=Trigger.oldMap.get(acd.id).Engine_Authorization__c         
            || Trigger.newMap.get(acd.id).Avionics_Support_Level__c !=Trigger.oldMap.get(acd.id).Avionics_Support_Level__c         
            || Trigger.newMap.get(acd.id).Authorized_Avionics_Dealer__c !=Trigger.oldMap.get(acd.id).Authorized_Avionics_Dealer__c         
           )
        {
            //Accowneremail=acd.AccountOwner_Email__c;
            Accownername=acd.Report_Account_name__c;
            accaccountid=acd.Account_Name__c;
            system.debug('venkat1111---->'+accaccountid);
            //system.debug('venkat22222---->'+Accowneremail);
            MobileAppVisibility=acd.Mobile_App_Visibility_Uncheck__c;
            acdid.add(acd.id);          
        }
    }
    system.debug('**************** Case inserted'+insertcas.size());
    if(insertcas.size()>0)
    insert insertcas;
    system.debug('**************** Case log'+insertcas);
    //SR#425182 BGA channel partner changes starts
    if(acdid.size()>0 && MobileAppVisibility == false)
    {
        String htmlBody='';
        String htmlBody1='<font  style="font-family:Times New Roman">&nbsp;&nbsp;&nbsp;&nbsp;Email : <a href="aeroapps.servicedesk@honeywell.com">aeroapps.servicedesk@honeywell.com.</a><br/>&nbsp;&nbsp;&nbsp;&nbsp;o   Phone:  1-866-469-5237 (toll free US & Canada) / 781-350-1965 (International)<br/></font>';
        htmlbody = '<font style="font-family:Times New Roman">Dear Rosela</font>,'
        +'<font style="font-family:Times New Roman"><br/><br/>This email notification is to inform you that a change was made to a BGA Service Center or Dealer in SFDC.  Please verify that the “Direct Access” app (directory for business aviation) channel partner information is updated correctly in SFDC.  Please refer to the attachment for the impacted fields and process steps.</font>'
        +'<font style="font-family:Times New Roman"><br/><br/>Account Name:&nbsp;&nbsp;</font>' +'<font style="font-family:Times New Roman">'+Accownername+'</font>'+',<br/>'
        +'<font style="font-family:Times New Roman">Account Link:&nbsp;&nbsp;</font>' +'<font style="font-family:Times New Roman"><a href="'+ label.ServerName +'/'+accaccountid +'">'+ label.ServerName +'/'+accaccountid +'</a></font><br/>'
        +'<font style="font-family:Times New Roman"><br/>If you have questions, please contact the Aero Application Help Desk and request SFDC support.<br/></font>'
        +htmlBody1
        +'<font style="font-family:Times New Roman"><br/><br/><br/><br/>Thank you!</></font>'
        +'<font style="font-family:Times New Roman"><br/><br/>Direct Access Quality Control</font>';
        if(accaccountid != null)
        {
            account acc=[select id,name,OwnerId from account where id=:accaccountid];
            accownerid=acc.OwnerId;
            system.debug('venkat3333----->'+accownerid);
            user u=[select id,name,ManagerId from user where id=:acc.OwnerId ];
        }    
           /*code commented for SR452372 - start
            if(u.ManagerId  != null)
            {
            user u1=[select id,email from user where id=:u.ManagerId ];
            accownermanageremail=u1.email;
            }  
         } 
        system.debug('venkat4444----->'+accownerid);  
          
         if(Accowneremail != null && accownermanageremail != null && accownerid != null && accownerid != label.API_User_SFDC_Cust_Master)
        {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {label.Service_Centers_Dealers1}; 
            //String[] toAddresses = new String[] {'venkatesh.athanti@nttdata.com'};                                           
            mail.setToAddresses(toAddresses);            
            String[] ccAddresses = new String[] {label.Service_Centers_Dealers,Accowneremail,accownermanageremail};  
            //String[] ccAddresses = new String[] {'Latha.Priya@nttdata.com',Accowneremail,accownermanageremail};  
            mail.setCcAddresses(ccAddresses);
            mail.setSubject('Direct Access App – Request to update SFDC Contact data');
            mail.setHtmlBody(htmlBody);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[]{ mail });
        }
        else if(Accowneremail != null && accownerid != null && accownerid != label.API_User_SFDC_Cust_Master)
        {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {label.Service_Centers_Dealers1}; 
            //String[] toAddresses = new String[] {'venkatesh.athanti@nttdata.com'};                                           
            mail.setToAddresses(toAddresses);            
            String[] ccAddresses = new String[] {label.Service_Centers_Dealers,Accowneremail};  
            //String[] ccAddresses = new String[] {'Latha.Priya@nttdata.com',Accowneremail};  
            mail.setCcAddresses(ccAddresses);
            mail.setSubject('Direct Access App – Request to update SFDC Contact data');
            mail.setHtmlBody(htmlBody);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[]{ mail });
        }
        else
        //code commented for SR452372 - End */
        /* code commented for SCTASK1799289 start
        If(accownerid != null && accownerid != label.API_User_SFDC_Cust_Master)
        {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {label.Service_Centers_Dealers1}; 
            //String[] toAddresses = new String[] {'venkatesh.athanti@nttdata.com'};          
            mail.setToAddresses(toAddresses);
            String[] ccAddresses = new String[] {label.Service_Centers_Dealers};
            //String[] ccAddresses = new String[] {'Latha.Priya@nttdata.com'};          
            mail.setCcAddresses(ccAddresses);
            mail.setSubject('Direct Access App – Request to update SFDC Contact data');
            mail.setHtmlBody(htmlBody);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[]{ mail }); 
        }
        code commented for SCTASK1799289 end */
    }
    else
    {
        system.debug('venkattest123----->'+acdid);
        List<Account_Address__C> accadd1=[select id,name,Mobile_App_Visibility_Uncheck__c from Account_Address__C where id=:acdid and Mobile_App_Visibility_Uncheck__c = true]; 
        system.debug('venkattest456----->'+accadd1.size());     
        if(accadd1.size()>0)
        {
            for(Account_Address__C accadd2:accadd1)
            {
                accadd2.Mobile_App_Visibility_Uncheck__c=false;
                accadd3.add(accadd2);
            }
            update accadd3; 
            system.debug('venkattest789----->'+accadd3);
        }
    }
    //SR#425182 BGA channel partner changes ends
}