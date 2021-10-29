trigger NotificationtoSBULeader on Case_Extension__c (After Update) {
    set<id> casid = new set<id>();
    List<string> casexthonid = new List<String>();
    List<Portal_Honeywell_ID__c> phid = new List<Portal_Honeywell_ID__c>();
    List<Portal_Honeywell_ID__c> Phidlst = new List<Portal_Honeywell_ID__c>();
    List<Case_Extension__c> casextion =new List<Case_Extension__c>(); 
    for(Case_Extension__c ce:trigger.new){
        if(ce.Case_object__c!=null && (ce.Four_Owner_Changes_Date__c!=null || ce.Three_Re_Opens_Date__c!=null || ce.Eight_Emails_on_Case_Date__c!=null || ce.X7_Days_Case_Age_date__c!=null)){
            casid.add(ce.Case_object__c);
        }
        if(ce.Case_object__c!=null && (ce.MyMaintainer_Roles__c!=null && Trigger.OldMap.get(ce.Id).MyMaintainer_Roles__c!=ce.MyMaintainer_Roles__c)){
            if(ce.portal_honeywell_id__c!=null)
            casexthonid.add(ce.portal_honeywell_id__c);
        }
    }
    if(casexthonid!=null && casexthonid.size()>0){
        phid = [Select id,name,status__c,MiddleName__c,MyMaintainer_Roles__c,Primary_Honeywell_ID__c,account_name__c,Account_Type__c,Address_Line_1__c,Primary_Email_Address__c,phone__c,Fax__c,FirstName__c,LastName__c,Name__c from Portal_Honeywell_ID__c where name IN:casexthonid and Primary_Honeywell_ID__c=true limit 1];
    }
    for(Case_Extension__c ce:trigger.new){
        if(ce.Case_object__c!=null && (ce.MyMaintainer_Roles__c!=null && Trigger.OldMap.get(ce.Id).MyMaintainer_Roles__c!=ce.MyMaintainer_Roles__c)){
            if(phid!=null && phid.size()>0){
                Portal_Honeywell_ID__c ph = new Portal_Honeywell_ID__c(id=phid[0].id);
                if(ce.account_name__c!=null)
                    ph.account_name__c = ce.account_name__c;
                if(ce.Account_Type__c!=null)
                    ph.Account_Type__c = ce.Account_Type__c;
                if(ce.Address_Line_1__c!=null)
                    ph.Address_Line_1__c = ce.Address_Line_1__c;
                if(ce.Primary_Email_Address__c!=null)
                    ph.Primary_Email_Address__c = ce.Primary_Email_Address__c;
                if(ce.phone__c!=null)
                    ph.phone__c = ce.phone__c;
                if(ce.Fax__c!=null)
                    ph.Fax__c = ce.Fax__c;
                if(ce.FirstName__c!=null)
                    ph.FirstName__c = ce.FirstName__c;
                if(ce.LastName__c!=null)
                    ph.LastName__c = ce.LastName__c;
                if(ce.Name__c!=null)
                    ph.Name__c = ce.Name__c;
                if(ce.MyMaintainer_Roles__c!=null)
                    ph.MyMaintainer_Roles__c = ce.MyMaintainer_Roles__c;
                if(ce.status__c!=null)
                    ph.status__c = ce.status__c;
                if(ce.MiddleName__c!=null)
                    ph.MiddleName__c = ce.MiddleName__c;
                Phidlst.add(ph);
            }
        }
    }
    if(Phidlst.size()>0){
        update Phidlst;
    }
    if(casid!=null){
        Date dt = date.valueOf(label.Created_Date_31Aug2015);
        List<Messaging.SingleEmailMessage> msgList = new List<Messaging.SingleEmailMessage>();
        List<Case_Extension__c> casext = [Select id,Four_Owner_Changes_Date__c,Three_Re_Opens_Date__c,Eight_Emails_on_Case_Date__c,X7_Days_Case_Age_date__c,Case_object__r.CaseNumber, Case_object__r.Subject, Case_object__r.Status, Case_object__r.Sub_Status__c,Case_object__r.SBU__c,Case_object__r.IsClosed, Case_object__r.Case_Record_Type__c from Case_Extension__c where Case_object__c IN:casid and Case_object__r.CreatedDate>:dt and Case_object__r.SBU__c!=null and Case_object__r.Isclosed=False and (Case_object__r.Case_Record_Type__c='Orders' or Case_object__r.Case_Record_Type__c = 'Quotes' or Case_object__r.Case_Record_Type__c = 'Repair & Overhaul' or Case_object__r.Case_Record_Type__c = 'Internal Escalations' or Case_object__r.Case_Record_Type__c = 'OEM Quotes Orders')];
        if(casext.size()>0){
            List<Messaging.SingleEmailMessage> bulkEmails = new List<Messaging.SingleEmailMessage>();  
            for(Case_Extension__c ce:casext){
                system.debug('inside for');
                Id whatid = ce.Case_object__c;
                Contact cnt = new Contact(id=Label.UFR_Cont_Id);
                String[] toaddress = new String[]{};
                String emails;              
                List<String> toadd = new List<String>();
                Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
                if(ce.Case_object__r.SBU__c == 'ATR' || ce.Case_object__r.SBU__c == 'BGA' || ce.Case_object__r.SBU__c == 'D&S'){
                    if(ce.Case_object__r.SBU__c == 'ATR'){
                        emails = label.Notification_Mail_ATR_SBU;
                        toadd = emails.split(',');
                        system.debug('ATR Mails==== '+toadd);
                    }
                    else if(ce.Case_object__r.SBU__c == 'BGA'){
                        emails = label.Notification_Mail_BGA_SBU;
                        toadd = emails.split(',');
                        system.debug('BGA Mails==== '+toadd);
                    }
                    else if(ce.Case_object__r.SBU__c == 'D&S'){
                        emails = label.Notification_Mail_D_S_SBU;
                        toadd = emails.split(',');
                        system.debug('D&S Mails====' +toadd);
                    }
                    if(toadd!=null && toadd.size()>0){
                        for(String st:toadd){
                            toaddress.add(st);                
                        }
                        system.debug('EMails list==== '+toaddress);
                    }    
                    if(toaddress!=null && toaddress.size()>0){
                        msg.setToAddresses(toaddress);
                        system.debug('00000000000 '+toaddress);
                        if(Trigger.OldMap.get(ce.Id).Four_Owner_Changes_Date__c == null && ce.Four_Owner_Changes_Date__c!=null){
                            system.debug('2222222222222');
                            if((Trigger.OldMap.get(ce.Id).Three_Re_Opens_Date__c == null && ce.Three_Re_Opens_Date__c!=null) || (Trigger.OldMap.get(ce.Id).Eight_Emails_on_Case_Date__c == null && ce.Eight_Emails_on_Case_Date__c!=null) || (Trigger.OldMap.get(ce.Id).X7_Days_Case_Age_date__c == null && ce.X7_Days_Case_Age_date__c!=null)){
                                system.debug('2222222222222 Inside if');
                                msg.setTemplateId(label.One_or_More_Email_Temp_Id);
                            }else{
                                system.debug('2222222222222 Inside else');
                                msg.setTemplateId(label.X4_owner_changes_Temp_ID);
                            }
                        }
                        else if(Trigger.OldMap.get(ce.Id).Three_Re_Opens_Date__c == null && ce.Three_Re_Opens_Date__c!=null){
                            system.debug('33333333333333');
                            if((Trigger.OldMap.get(ce.Id).Four_Owner_Changes_Date__c == null && ce.Four_Owner_Changes_Date__c!=null) || (Trigger.OldMap.get(ce.Id).Eight_Emails_on_Case_Date__c == null && ce.Eight_Emails_on_Case_Date__c!=null) || (Trigger.OldMap.get(ce.Id).X7_Days_Case_Age_date__c == null && ce.X7_Days_Case_Age_date__c!=null)){
                                system.debug('33333333333333 Inside if');
                                msg.setTemplateId(label.One_or_More_Email_Temp_Id);
                            }else{
                                system.debug('33333333333333 Inside else');
                                msg.setTemplateId(label.X4_Reopens_Template_Id);
                            }
                        }
                        else if(Trigger.OldMap.get(ce.Id).Eight_Emails_on_Case_Date__c == null && ce.Eight_Emails_on_Case_Date__c!=null){
                            system.debug('4444444444444');
                            if((Trigger.OldMap.get(ce.Id).Four_Owner_Changes_Date__c == null && ce.Four_Owner_Changes_Date__c!=null) || (Trigger.OldMap.get(ce.Id).Three_Re_Opens_Date__c == null && ce.Three_Re_Opens_Date__c!=null) || (Trigger.OldMap.get(ce.Id).X7_Days_Case_Age_date__c == null && ce.X7_Days_Case_Age_date__c!=null)){
                                system.debug('4444444444444 Inside if');
                                msg.setTemplateId(label.One_or_More_Email_Temp_Id);
                            }else{
                                system.debug('4444444444444 Inside else');
                                msg.setTemplateId(label.X8_Emails_Template_Id);
                            }
                        }
                        else if(Trigger.OldMap.get(ce.Id).X7_Days_Case_Age_date__c == null && ce.X7_Days_Case_Age_date__c!=null){
                            system.debug('5555555555555');
                            if((Trigger.OldMap.get(ce.Id).Four_Owner_Changes_Date__c == null && ce.Four_Owner_Changes_Date__c!=null) || (Trigger.OldMap.get(ce.Id).Three_Re_Opens_Date__c == null && ce.Three_Re_Opens_Date__c!=null) || (Trigger.OldMap.get(ce.Id).Eight_Emails_on_Case_Date__c == null && ce.Eight_Emails_on_Case_Date__c!=null)){
                                system.debug('5555555555555 Inside if');
                                msg.setTemplateId(label.One_or_More_Email_Temp_Id);
                            }else{
                                system.debug('5555555555555 Inside else');
                                msg.setTemplateId(label.X7_days_Case_age_template_id);
                            }
                        }
                        msg.setWhatId(whatid);
                        msg.setTargetObjectId(cnt.id);
                        msg.setOrgWideEmailAddressId(label.AeroNo_Reply_email_ID);
                        msgList.add(msg);
                        system.debug(msgList);
                        Savepoint sp = Database.setSavepoint();
                        if(msg.getTemplateId()!=null)
                            Messaging.sendEmail(msgList);
                        Database.rollback(sp);
                        if(msgList.size()>0){
                            for(Messaging.SingleEmailMessage email : msgList){
                                Messaging.SingleEmailMessage emailToSend = new Messaging.SingleEmailMessage();
                                emailToSend.setToAddresses(email.getToAddresses());
                                if(null!=email.getCcAddresses())
                                    emailToSend.setCcAddresses(email.getCcAddresses());
                                emailToSend.setPlainTextBody(email.getPlainTextBody());
                                emailToSend.setHTMLBody(email.getHTMLBody());
                                emailToSend.setSubject(email.getSubject());
                                emailToSend.setOrgWideEmailAddressId(email.getOrgWideEmailAddressId());
                                if(emailToSend.getHTMLBody()!=null)
                                    bulkEmails.add(emailToSend);
                            }
                        }
                    }
                }
            }
            if(bulkEmails.size()>0){
                Messaging.sendEmail(bulkEmails);
            }
        }
    }   
}