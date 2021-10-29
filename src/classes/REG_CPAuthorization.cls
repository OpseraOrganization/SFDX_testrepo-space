public  class REG_CPAuthorization {
     public Case cas{get;set;}
	  public static void saveCPAuthorizationCase(id conId,id caseId,string primaryEmail){
        List<Contact> conList = new List<contact>();
        List<AccountTeamMember> accTeam = new List<AccountTeamMember>();
        List<AccountTeamMember> accTeam1 = new List<AccountTeamMember>();
        
        if(conId!=null){
            conList=[select id,email,AccountId from contact where id=:conId];           
        }
          system.debug('conList***'+conList);
        if(primaryEmail!=null){           
            //cas.Requestor_Email__c=primaryEmail;
        }

        if(conlist.size()>0 && conlist[0].AccountId !=null){
            accTeam = [Select id, UserId,user.email from AccountTeamMember where AccountId=:conlist[0].AccountId and (TeamMemberRole = 'MSP Administrator' OR TeamMemberRole = 'Customer Service Manager')];
            accTeam1 = [Select id, UserId,user.email from AccountTeamMember where AccountId=:conlist[0].AccountId and TeamMemberRole = 'Customer Business Manager (CBM)'];
        }
    
        system.debug('1111111111111111111111'+accTeam);
        system.debug('2222222222222222222222'+accTeam1);
        /*cas.recordtypeId=label.CP_Outside_Purchase_Request_RT_ID;
        cas.Origin='Web';
        if(cas.Part_Number_Needed__c!=null)
            cas.Subject = 'CP Authorization '+cas.Part_Number_Needed__c;
        else
            cas.Subject = 'CP Authorization ';
        cas.SuppliedEmail = cas.Primary_Email__c; 
        cas.OwnerId = Label.CP_Outside_Purchase_Case_OwnerID;
        insert cas;*/
        Case c = [select Id,CaseNumber,Description,contactid,Contact_Name__c,Account_Name__c,Product_Part__c,Part_Number_Needed__c,Primary_Email_Address__c,Engine_Out_Date__c,Quote_Number__c,Price__c,Proposed_Supplier__c,Case_Ref_ID__c,SuppliedEmail,OwnerId,Subject,Additional_Information__c,Engine_Received_Date__c,Engine_S_N__c from Case where id=:caseId];
        system.debug('case***'+c);
          String mydate = '';
        if(c.Engine_Out_Date__c!=null){
            DateTime dt = c.Engine_Out_Date__c;
            mydate = dt.format('MM/dd/yyyy');
        }
        //String body = '<font size="3" style="font-family:arial">For your information, we received a request from '+c.Contact_Name__c+' at '+c.Account_Name__c+'<br/>for outside purchase of part number '+c.Part_Number_Needed__c+'. Additional information is shown below. <br/><br/>Description: '+c.Description+'<br/>Primary Email Address: '+c.Primary_Email_Address__c+'<br/>Quote Number: '+c.Quote_Number__c+'<br/>Price: '+c.Price__c+'<br/>Proposed Supplier: '+c.Proposed_Supplier__c+'<br/><br/>Thank you.<br/><br/>'+c.Case_Ref_ID__c;
        String body = '<font size="3" style="font-family:arial">For your information, we received a request from '+c.Contact_Name__c+' at '+c.Account_Name__c+'<br/>for outside purchase of part number '+c.Part_Number_Needed__c+'. Additional information is shown below. <br/><br/>Description: '+(String.isNotBlank(c.Description)? c.Description: '')+'<br/>Primary Email Address: '+c.Primary_Email_Address__c+'<br/>Price: '+(String.isNotBlank(c.Price__c)?c.Price__c:'')+'<br/>Proposed Supplier: '+(String.isNotBlank(c.Proposed_Supplier__c)?c.Proposed_Supplier__c:'')+'<br/><br/>Thank you.<br/><br/>'+c.Case_Ref_ID__c;
        String sub1 = c.CaseNumber; 
        String sub2 = ':'; 
        String sub3 = c.Case_Ref_ID__c;
        String sub = sub1+sub2+sub3;
        List<Messaging.SingleEmailMessage> bulkEmails = new List<Messaging.SingleEmailMessage>();
        if(accTeam.size()>0 && accTeam!=null){
            system.debug('333');
            for(Integer i=0;i<accTeam.size();i++){
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                message.setTargetObjectId(accTeam[i].UserId);
                message.setOrgWideEmailAddressId(label.Yourresponse_OrgId);
                message.setSubject('CP Request for OP '+sub);
                message.setHtmlBody(body);
                message.setBccSender(false);             
                message.setUseSignature(true);
                message.setSaveAsActivity(false); 
                bulkEmails.add(message);
            }
            //Messaging.sendEmail(bulkEmails);
        }
        String body1 = '<font size="3" style="font-family:arial">We have received a request from '+c.Contact_Name__c+' at '+c.Account_Name__c+' for <br/>outside purchase of part number '+c.Part_Number_Needed__c+'. Additional information is shown below. <br/><br/>Description: '+(String.isNotBlank(c.Description)? c.Description: '')+'<br/>Primary Email Address: '+c.Primary_Email_Address__c+'<br/>Price: '+(String.isNotBlank(c.Price__c)? c.Price__c: '')+'<br/>Proposed Supplier: '+(String.isNotBlank(c.Proposed_Supplier__c)? c.Proposed_Supplier__c: '')+'<br/><br/>Please Approve or Reject by clicking on the appropriate link<br/><br/><a href="'+ label.CP_Approve_Reject +'?CaseRecord='+c.id+'&Accept=true">Approve</a><br/><br/><a href="'+ label.CP_Approve_Reject +'?CaseRecord='+c.id+'&Reject=true">Reject</a><br/><br/>Thank you.<br/><br/>'+c.Case_Ref_ID__c;
        //String sub1 = c.Case_Ref_ID__c;
        if(accTeam1.size()>0 && accTeam1!=null){
            system.debug('4444');
            for(Integer i=0;i<accTeam1.size();i++){
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                if(accTeam1[i].UserId == label.SharBucknerUserID && label.EmailtoShar=='No')
                    message.setTargetObjectId(label.FabiolaLaraUserid);
                else
                    message.setTargetObjectId(accTeam1[i].UserId);
                message.setOrgWideEmailAddressId(label.Yourresponse_OrgId);
                message.setSubject('CP Request for Authorization '+sub);
                message.setHtmlBody(body1);
                message.setBccSender(false);             
                message.setUseSignature(true);
                message.setSaveAsActivity(false); 
                bulkEmails.add(message);
            }
            //Messaging.sendEmail(bulkEmails);
        } 
        else if(accTeam1.size()==0){
            system.debug('55555');
            String[] toadd = new String[]{'Mike.Formanek@honeywell.com'};
            //String[] toadd = new String[]{'mariakitheri.tiinulin@nttdata.com'};
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setToAddresses(toadd);
            message.setOrgWideEmailAddressId(label.Yourresponse_OrgId);
            message.setSubject('CP Request for Authorization '+sub);
            message.setHtmlBody(body1);
            message.setBccSender(false);             
            message.setUseSignature(true);
            message.setSaveAsActivity(false); 
            bulkEmails.add(message);
            //Messaging.sendEmail(bulkEmails);
        } 
        
        //if(c.SuppliedEmail != null) {
          if(c.Account_Name__c == 'STANDARD AERO INC'){
        string SubjectText = c.Subject+' : '+c.CaseNumber+' '+c.Case_Ref_ID__c;
        string LBody = '<div style="width:100%"><img src="https://c.cs23.content.force.com/servlet/servlet.ImageServer?id=015c0000000F81e&oid=00Dc0000003sFDB&lastMod=1406717490000"/>'
                       +'<div style="word-wrap: break-word; width:500px;"><font size="2" style="font-family:arial;"><br/>Thank you for contacting Honeywell Aerospace Customer Support.  Your case tracking number for this inquiry is provided above.  If you wish to communicate with us further about this inquiry, you may reply to this e-mail -- please leave the Reference Case # within the subject line for quicker responses.</div>'
                       +'<font size="3" style="font-family:arial;"><br/>Your request for authorization is summarized below.<br/>'
                       +'<ul type="disc" font size="2" style="font-family:arial; word-wrap: break-word"><li>Part Number: '+c.Part_Number_Needed__c+'</li><li>Proposed Supplier: '+c.Proposed_Supplier__c+'</li><li>Price: '+c.Price__c+'</li><li>Additional Info: '+c.Additional_Information__c+'</li><li>Engine Received Date: '+c.Engine_Received_Date__c+'</li><li>Engine S/N: '+c.Engine_S_N__c+'</li></ul>'
                       +'<br/><font size="3" style="font-family:arial; word-wrap: break-word">Honeywell Aerospace<br/>Customer &amp; Product Support<br/>Web:  <a href ="http://www.Aerospace.com">http://www.Aerospace.com</a>'
                       +'<br/><br/><font size="3" style="font-family:arial; font-weight:bold; text-decoration: underline">ORIGINAL CORRESPONDENCE:</font>'           
                       +'<br/><font size="3" style="font-family:arial; font-weight:normal;"'+c.Subject+'</font>'
                       +'<br/><br/><div style="word-wrap: break-word; width:500px; text-decoration: none"><font size="2" style="font-weight:normal; text-decoration: none;">Due to government regulations and/or contractual limitations, all data and/or attachments containing export control information and/or containing details related to Space, Munitions and Missiles items is not authorized for entry or use in our applications or systems at the present time.</font></div>'
                       +'<br/><br/><img src="https://c.cs23.content.force.com/servlet/servlet.ImageServer?id=015c0000000F81e&oid=00Dc0000003sFDB&lastMod=1406717490000"/><br/>'
                       +'<br/><img src="https://c.cs23.content.force.com/servlet/servlet.ImageServer?id=015c0000000F81e&oid=00Dc0000003sFDB&lastMod=1406717490000"/></div>';
        
        //String[] toadd = new String[]{c.SuppliedEmail};
        list<string> toadd = new list<string>();
        //toadd.add(c.SuppliedEmail);
        //if(c.Account_Name__c == 'STANDARD AERO INC')
        toadd.add('larry.powell@standardaero.com');
        //system.debug('###################################'+c.SuppliedEmail);
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setToAddresses(toadd);
        message.setOrgWideEmailAddressId(label.Yourresponse_OrgId);
        message.setSubject(SubjectText);
        message.setHtmlBody(LBody);
        message.setBccSender(false);             
        message.setUseSignature(true);
        message.setSaveAsActivity(false); 
        bulkEmails.add(message);
        }
        
        
        if(bulkEmails.size()>0){
            Messaging.sendEmail(bulkEmails);
        }
          system.debug('bulkEmails***'+bulkEmails);
    }    
}