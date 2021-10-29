trigger Account_updateAccountaddress on Account (after update,after insert) 
{
    Set<id> accid = New set<Id>();
    list<Account_Address__c> accadd = New list<Account_Address__c>();
    list<Account_Address__c> updateaccadd=New list<Account_Address__c>();
    //SR#425128 starts
    string accownermanageremail;
    string Accowneremail;
    string Accownername;
    string accownerid;
    String htmlBody2='';      
    List<Account_Address__c> accaddress=new List<Account_Address__c>();
    //SR#425128 ends here
    for(Account acc: trigger.new)
    {
        if((Trigger.isupdate&&Trigger.newMap.get(acc.id).Strategic_Business_Unit__c!=Trigger.oldMap.get(acc.id).Strategic_Business_Unit__c)&&((Trigger.newMap.get(acc.id).Strategic_Business_Unit__c !='Intercompany'&&Trigger.oldMap.get(acc.id).Strategic_Business_Unit__c =='Intercompany')||Trigger.newMap.get(acc.id).Strategic_Business_Unit__c =='Intercompany'))
        {
            accid.add(acc.id);
        }
        else if(trigger.isinsert && acc.Strategic_Business_Unit__c=='Intercompany')
        {
            accid.add(acc.id);
        }
    }
  if(accid.size()>0)
  accadd=[select id,Denied_Party_Status__c,Account_Name__r.Strategic_Business_Unit__c from Account_Address__c where Account_Name__c in: accid];
  for(Account_Address__c aa:accadd)
  {
      if(aa.Account_Name__r.Strategic_Business_Unit__c=='Intercompany')
      {
            AA.Denied_Party_Status__c='Whitelist';
      }
      else if(aa.Account_Name__r.Strategic_Business_Unit__c!='Intercompany')
      {
            AA.Denied_Party_Status__c='Not Reviewed';
      }
            updateaccadd.add(aa);
  }
  
    if(updateaccadd.size()>0)
    update updateaccadd; 
  
    //start -- Service Request 413034----------
    Set<id> accvocid = New set<Id>();
    list<voc_accounts__c> accvocins = New list<voc_accounts__c>();
    list<voc_accounts__c> accvocupd = New list<voc_accounts__c>();
    list<voc_accounts__c> accvocupdnew = New list<voc_accounts__c>();
    for(Account accc: trigger.new)
    {
        if(trigger.isinsert)
        {
            voc_accounts__c vocacc = new voc_accounts__c (account__c = accc.id, name = accc.name);
            accvocins.add(vocacc);
        }
        else if(trigger.isupdate && Trigger.newMap.get(accc.id).name!=Trigger.oldMap.get(accc.id).name)
        {
            accvocid.add(accc.id);
        }
    }
    if(accvocins.size()>0)
    insert accvocins; 
    if(accvocid.size()>0)
    accvocupd = [select id, account__c,account__r.name from voc_accounts__c where account__c in:accvocid];
    for(voc_accounts__c va:accvocupd){
    voc_accounts__c vocaccupdn = new voc_accounts__c (id = va.id, name = va.account__r.name);
    accvocupdnew.add(vocaccupdn);
    }
    if(accvocupdnew.size()>0)
    update accvocupdnew; 
  
    //end -- Service Request 413034----------
    
    //start -- Service Request 425128----------
    if(trigger.isupdate)
    {
        Set<id> acccid = New set<Id>();
        Set<id> acccid1 = New set<Id>();
        for(Account acc:Trigger.new)
        {
            if(Trigger.newMap.get(acc.id).Customer_Status__c == 'active'&& Trigger.newMap.get(acc.id).Customer_Status__c != Trigger.oldMap.get(acc.id).Customer_Status__c)
            {
                system.debug('test123---->'+acc.id);
                system.debug('venkat1111---->'+acc.OwnerId);
                acccid.add(acc.id);
            } 
            if((Trigger.oldMap.get(acc.id).Strategic_Business_Unit__c =='BGA' && Trigger.newMap.get(acc.id).Name != Trigger.oldMap.get(acc.id).Name) 
               || (Trigger.oldMap.get(acc.id).Strategic_Business_Unit__c =='BGA' && Trigger.newMap.get(acc.id).Type !=Trigger.oldMap.get(acc.id).Type)
               || (Trigger.newMap.get(acc.id).Strategic_Business_Unit__c !=Trigger.oldMap.get(acc.id).Strategic_Business_Unit__c && Trigger.newMap.get(acc.id).Strategic_Business_Unit__c =='BGA')
               || (Trigger.newMap.get(acc.id).Strategic_Business_Unit__c !=Trigger.oldMap.get(acc.id).Strategic_Business_Unit__c && Trigger.oldMap.get(acc.id).Strategic_Business_Unit__c =='BGA')
               )
            {
                system.debug('test123---->'+acc.id);
                system.debug('venkat555---->'+acc.OwnerId);
                acccid1.add(acc.id);
            }
            if(Trigger.oldMap.get(acc.id).Strategic_Business_Unit__c =='BGA' && Trigger.newMap.get(acc.id).Name != Trigger.oldMap.get(acc.id).Name)
            {
                htmlBody2='<br/><font  style="font-family:Times New Roman">&nbsp;&nbsp;&nbsp;&nbsp;o changed Name from</font> '+Trigger.oldMap.get(acc.id).Name +'&nbsp;to&nbsp;'+Trigger.newMap.get(acc.id).Name;                    
            }
            if(Trigger.oldMap.get(acc.id).Strategic_Business_Unit__c =='BGA' && Trigger.newMap.get(acc.id).Type !=Trigger.oldMap.get(acc.id).Type)
            {
                htmlBody2+='</br/><font  style="font-family:Times New Roman">&nbsp;&nbsp;&nbsp;&nbsp;o changed Type from</font> '+Trigger.oldMap.get(acc.id).Type +'&nbsp;to&nbsp;'+Trigger.newMap.get(acc.id).Type; 
            }
            if(Trigger.newMap.get(acc.id).Strategic_Business_Unit__c !=Trigger.oldMap.get(acc.id).Strategic_Business_Unit__c && Trigger.newMap.get(acc.id).Strategic_Business_Unit__c =='BGA')
            {
                htmlBody2+='<br/><font  style="font-family:Times New Roman">&nbsp;&nbsp;&nbsp;&nbsp;o changed SBU from</font> '+Trigger.oldMap.get(acc.id).Strategic_Business_Unit__c +'&nbsp;to&nbsp;'+Trigger.newMap.get(acc.id).Strategic_Business_Unit__c; 
            }
            if(Trigger.newMap.get(acc.id).Strategic_Business_Unit__c !=Trigger.oldMap.get(acc.id).Strategic_Business_Unit__c && Trigger.oldMap.get(acc.id).Strategic_Business_Unit__c =='BGA')
            {
                htmlBody2+='<br/><font  style="font-family:Times New Roman">&nbsp;&nbsp;&nbsp;&nbsp;o changed SBU from</font> '+Trigger.oldMap.get(acc.id).Strategic_Business_Unit__c +'&nbsp;to&nbsp;'+Trigger.newMap.get(acc.id).Strategic_Business_Unit__c; 
            }           
        }
        if(acccid.size()>0)
        {
            system.debug('test456---->'+acccid.size());
            List<Account_Address__c> accaddress1=[select id,name,Mobile_App_Visibility__c,Mobile_App_Visibility_Check__c from Account_Address__c where Account_Name__c=:acccid and Mobile_App_Visibility__c=false and Mobile_App_Visibility_Check__c=true];
            system.debug('check accaddress1---->'+accaddress1.size());
            if(accaddress1.size()>0)
            {               
                for(Account_Address__c accadd1:accaddress1)
                {
                    system.debug('test789---->'+accadd1.Mobile_App_Visibility__c);
                    accadd1.Mobile_App_Visibility__c=true;
                    accadd1.Mobile_App_Visibility_Uncheck__c=true;
                    accaddress.add(accadd1);
                }
                update accaddress;
            }
        }
        /*if(acccid1.size()>0)
        {
            //List<account> accemail=[select id,name,owner.email,ownerid where id=:acccid1 and Mobile_App_Visibility__c=true];
            account acc=[select id,name,OwnerId,owner.email from account where id=:acccid1];
            //Commented the below lines for SR 452372
            //Accowneremail=acc.owner.email;
            Accownername=acc.name;
            accownerid=acc.id;
            String htmlBody='';
            String htmlBody1='<font  style="font-family:Times New Roman">&nbsp;&nbsp;&nbsp;&nbsp;o Email : <a href="aeroapps.servicedesk@honeywell.com">aeroapps.servicedesk@honeywell.com.</a><br/>&nbsp;&nbsp;&nbsp;&nbsp;o   Phone:  1-866-469-5237 (toll free US & Canada) / 781-350-1965 (International)<br/></font>';
            htmlbody ='<font style="font-family:Times New Roman">Dear Rosela</font>,'
            +'<font style="font-family:Times New Roman"><br/><br/>This email notification is to inform you that a change was made to a BGA Service Center or Dealer in SFDC.  Please verify that the “Direct Access” app (directory for business aviation) channel partner information is updated correctly in SFDC.</font>'
            +'<br/>'+htmlBody2
            +'<font style="font-family:Times New Roman"><br/><br/>Account Name:&nbsp;&nbsp;</font>' +'<font  style="font-family:Times New Roman">'+Accownername+'</font>'+'<br/>'
            +'<font  style="font-family:Times New Roman">Account Link:&nbsp;&nbsp;</font>' +'<font  style="font-family:Times New Roman"><a href="'+ label.ServerName +'/'+accownerid +'">'+label.ServerName +'/'+accownerid +'</a></font><br/>'
            +'<font style="font-family:Times New Roman"><br/>If you have questions, please contact the Aero Application Help Desk and request SFDC support.<br/></font>'
            +htmlBody1
            +'<font style="font-family:Times New Roman"><br/><br/>Thank you!</></font>'
            +'<font  style="font-family:Times New Roman"><br/><br/>Direct Access Quality Control</font>';
            /* commented the lines for SR452372 - start
            if(acc.OwnerId != null)
            {
                user u=[select id,name,ManagerId from user where id=:acc.OwnerId ];
                if(u.ManagerId  != null)
                {
                user u1=[select id,email from user where id=:u.ManagerId ];
                accownermanageremail=u1.email;
                }
            }
            if(Accowneremail != null && accownermanageremail != null && acc.OwnerId != null && acc.OwnerId != label.API_User_SFDC_Cust_Master)
            {
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String[] toAddresses = new String[] {label.Service_Centers_Dealers1};                                           
                mail.setToAddresses(toAddresses);            
                String[] ccAddresses = new String[] {label.Service_Centers_Dealers,Accowneremail,accownermanageremail};  
                mail.setCcAddresses(ccAddresses);
                mail.setSubject('Direct Access App – Request to update SFDC Service Center & Dealer data');
                mail.setHtmlBody(htmlBody);
                Messaging.sendEmail(new Messaging.SingleEmailMessage[]{ mail });
            }
            else if(Accowneremail != null && acc.OwnerId != null && acc.OwnerId != label.API_User_SFDC_Cust_Master)
            {
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String[] toAddresses = new String[] {label.Service_Centers_Dealers1};                                           
                mail.setToAddresses(toAddresses);            
                String[] ccAddresses = new String[] {label.Service_Centers_Dealers,Accowneremail};   
                mail.setCcAddresses(ccAddresses);
                mail.setSubject('Direct Access App – Request to update SFDC Service Center & Dealer data');
                mail.setHtmlBody(htmlBody);
                Messaging.sendEmail(new Messaging.SingleEmailMessage[]{ mail });
            }
            else   commented the lines for SR452372 - End */
            /*code commented for SCTASK1799289 start
            If (acc.OwnerId != null && acc.OwnerId != label.API_User_SFDC_Cust_Master)
            {
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String[] toAddresses = new String[] {label.Service_Centers_Dealers1};          
                mail.setToAddresses(toAddresses);
                String[] ccAddresses = new String[] {label.Service_Centers_Dealers};         
                mail.setCcAddresses(ccAddresses);
                mail.setSubject('Direct Access App – Request to update SFDC Service Center & Dealer data');
                mail.setHtmlBody(htmlBody);
                Messaging.sendEmail(new Messaging.SingleEmailMessage[]{ mail }); 
            } 
            code commented for SCTASK1799289 end*/          
        //}
        
    }
    //end -- Service Request 425128------------
}