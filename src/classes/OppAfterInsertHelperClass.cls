/*******************************************************************************
Name         : OppAfterInsertHelperClass
Created By   : Anusuya Murugiah
Company Name : NTT Data
Project      : <Phase-II>, <HealthCheck - Sprint3> 
Created Date : 26 Decmber 2013
Usages       : This Class is to consolidate the AfterInsert functionality of opportunity which
               splited across in different triggers.                             
* Modification History  :
* Date             Version No.    Modified by           Brief Description of Modification
* 12-Feb-2015      1.3            NTTDATA               INC000008286465 - ATR RMU Opportunity Creation from CLI
*******************************************************************************/
public class OppAfterInsertHelperClass
{
    public static void afterInsertMethod(List<Opportunity> listObjOppNew,Map<ID,Opportunity> oldMap )
    {
        
        List<Opportunity_Sales_Team__c> oppSalesTeamList = new List<Opportunity_Sales_Team__c>();
        List<Opportunity> listOppToUpdate = new List<Opportunity>();
        List<Opportunity> listOppToUpdate1 = new List<Opportunity>();
        Opportunity_Sales_Team__c oppInsert = new Opportunity_Sales_Team__c();                    
        List<String> oppRecType = new List<String>();
        // Code Added for SR# INC000008286465 - ATR RMU Opp Creation Mail Trigger - Start
        List<Messaging.SingleEmailMessage> bulkEmails = new List<Messaging.SingleEmailMessage>();
        List<String> atrToAddresses=new List<String>(); 
        // Code Added for SR# INC000008286465 - ATR RMU Opp Creation Mail Trigger - End       
        for(Opportunity opp: listObjOppNew)
        {
             if(opp.record_type_name__c!= 'BGA OE' && opp.record_type_name__c!= 'BGA AM')
            {
                oppRecType.add(opp.Record_Type_Name__C);
            }
        }
        List<Matrix__c> matrixOppRecType= [select Phase__C,serial_no__c,stage__C,Opportunity_Type__C from Matrix__c where Opportunity_Type__c in:oppRecType order by serial_no__c];
        Map<id,opportunity> mapOppFinal = new Map<id,opportunity>([select id,Record_Type_Name__C ,next_phase__c ,owner.name,owner.email,
            account.ownerid,account.owner.functional_role__C,account.CBT__c,account.CBT_Team__c,account.CBT_Directorate__c,account.Sales_Channel__c,account.SC1__c,account.SC2__c,Appendix_Review_Engineer__r.email,account.owner.email,License_Draft__c,License_Review__c,Workbook_Complete__c,WorkbookComplete__c,Engineer_Manager_Review__c,Engineer_Manager_Review_Date__c,Account_manager_review_Date__c,Account_Contact_Name__c,Account_Contact_Name__r.Primary_Email_Address__c,Record_Data_Owner__c,Record_Data_Owner__r.Primary_Email_Address__c,BusinessContact__c,BusinessContact__r.email,HIPI_Accounts__c,AccountId from opportunity where id in: listObjOppNew]);        
        List<Opportunity_Gate__c> listOppGate = new List<Opportunity_Gate__c>();
        Opportunity_Gate__c optyg = new Opportunity_Gate__c() ;
        /* for(Opportunity opp:listObjOppNew)
         //  [select id,Record_Type_Name__c,next_phase__c ,
           // account.ownerid,account.owner.functional_role__C from opportunity where id in: listObjOppNew] )
        {
            if(mapOppFinal.get(opp.id).Record_Type_Name__C == 'D&S PrePriced' || mapOppFinal.get(opp.id).Record_Type_Name__C == 'D&S Run Rate' ||mapOppFinal.get(opp.id).Record_Type_Name__C == 'D&S Key' 
                                    || mapOppFinal.get(opp.id).Record_Type_Name__C == 'D&S Complex' || mapOppFinal.get(opp.id).Record_Type_Name__C == 'D&S Standard'
                        || mapOppFinal.get(opp.id).Record_Type_Name__C == 'D&S Focus' )//&& chkFlag==false)
                        {
                         System.debug('Entering Loop');
                         Opportunity tempopp = mapOppFinal.get(opp.id);
                         tempopp.next_phase__c = 'Launch';
                         listOppToUpdate.add(tempopp);
                         //chkFlag=true;
                        }   
        }*/
        //SF2SF Integration starts
       /* List<Opportunity> draftplafOppToUpdate = new List<Opportunity>();
        Date fiscalquarterdate= [Select EndDate From Period Where type = 'Quarter' and StartDate = THIS_FISCAL_QUARTER].EndDate;        
        decimal draft1;*/
        Messaging.SingleEmailMessage MPMmail = new Messaging.SingleEmailMessage();
        set<id> appendixengid = new set<id>();
        set<id> accownerid = new set<id>();
        string appendixenggemail = '';
        string accowneremail = '';
        List<Opportunity> Opportunitylst = new List<Opportunity>(); 
        Opportunitylst = mapOppFinal.values();  
        //SF2SF Integration ends
        for(Opportunity opp: listObjOppNew)
        {                          
            if(opp.SBU__c == 'ATR' && null!=mapOppFinal.get(opp.id).accountid && null!=mapOppFinal.get(opp.id).account.ownerid){
                oppInsert = new Opportunity_Sales_Team__c();   
                System.debug('Functional Role : ' +opp.account.owner.Functional_Role__c);         
                oppInsert.Opportunity_Team_Role__c = mapOppFinal.get(opp.id).account.owner.functional_role__C;
                oppInsert.Opportunity__c = opp.Id;
                System.debug('Owner ID : ' +opp.account.ownerid);
                oppInsert.User__c = mapOppFinal.get(opp.id).account.ownerid; 
                //oppSalesTeamList.add(oppInsert);
            }
            // Moved the below code out of if condition as we need to create a team role with the owner of the opp.
            oppInsert = new Opportunity_Sales_Team__c(); 
            oppInsert.Opportunity__c=opp.Id;
            oppInsert.user__c=opp.ownerid;
            oppSalesTeamList.add(oppInsert );
            if(opp.record_type_name__c!= 'BGA OE' && opp.record_type_name__c!= 'BGA AM')
            {
                /*oppInsert = new Opportunity_Sales_Team__c(); 
                oppInsert.Opportunity__c=opp.Id;
                oppInsert.user__c=opp.ownerid;
                oppSalesTeamList.add(oppInsert );*/
                
                integer chkFlag=0;
                for(integer i=0;i<matrixOppRecType.size();i++)
                {
                    System.debug('FLAG VALUE'+chkFlag);
                    if(opp.Record_Type_Name__C ==matrixOppRecType[i].Opportunity_Type__c) {
                        optyg = new Opportunity_Gate__c();
                        optyg.Opportunity__c = opp.id;
                        optyg.name =matrixOppRecType[i].Phase__C;
                        optyg.stage__c =matrixOppRecType[i].stage__C;
                        optyg.serial_no__c =matrixOppRecType[i].serial_no__c;
                        optyg.Opportunity_Type__c =matrixOppRecType[i].Opportunity_Type__C;
                        optyg.status__c='Open';
                        listOppGate.add(optyg);
                        if((mapOppFinal.get(opp.id).Record_Type_Name__C == 'D&S PrePriced' || mapOppFinal.get(opp.id).Record_Type_Name__C == 'D&S Run Rate' ||mapOppFinal.get(opp.id).Record_Type_Name__C == 'Key' 
                        || mapOppFinal.get(opp.id).Record_Type_Name__C == 'D&S Complex' || mapOppFinal.get(opp.id).Record_Type_Name__C == 'D&S Standard'
                        || mapOppFinal.get(opp.id).Record_Type_Name__C == 'Focus') && chkFlag==0)
                        {
                         System.debug('Entering Loop');
                         Opportunity tempopp = mapOppFinal.get(opp.id);
                         tempopp.next_phase__c = matrixOppRecType[i].Phase__C;
                         listOppToUpdate.add(tempopp);
                         chkFlag=1;
                        } 
                    }
                    
                }
            }
            // Added code for INC000006769488
            if(opp.Tech_Sales__c == 'AT' && opp.SBUFormulae__c == 'D&S'){
            system.debug('CBT_Tier_2__c referece');
            Opportunity tempopp = mapOppFinal.get(opp.id);
              tempopp.CBT_Tier_2__c = mapOppFinal.get(opp.id).account.CBT__c;
              tempopp.CBT_Team_Tier_3__c = mapOppFinal.get(opp.id).account.CBT_Team__c;
              tempopp.CBT_Directorate__c = mapOppFinal.get(opp.id).account.CBT_Directorate__c;
              tempopp.Sales_Channel__c = mapOppFinal.get(opp.id).account.Sales_Channel__c;
              tempopp.SC1__c = mapOppFinal.get(opp.id).account.Sc1__c;
              tempopp.SC2__c = mapOppFinal.get(opp.id).account.Sc2__c;
              listOppToUpdate1.add(tempopp );
              
            }
            // End code for INC000006769488 
            // Code Added for SR# INC000008286465 - ATR RMU Opp Creation Mail Trigger - Start
                System.debug('Inside ATR RMU changes'+label.AM_Complex); 
            //if(opp.recordtypeid==label.AM_Complex && opp.createdbyid=='005a0000008FL7PAAW')
            if(opp.recordtypeid==label.AM_Complex && opp.createdbyid==label.ATR_API_User_id)
            {
                System.debug('Inside ATR RMU changes'); 
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                String strOwnerName = '';
                if(null!=mapOppFinal && mapOppFinal.get(opp.id)!=null){
                    strOwnerName = mapOppFinal.get(opp.id).owner.name;
                    atrToAddresses.add(mapOppFinal.get(opp.id).owner.email);
                }    
                String subject='An Opportunity is assigned to you, please review & happy selling!';
                String body='<style>.fontlabel{'+
                
                'font-family:Arial, Helvetica, sans-serif;'+
                'color:#333;'+
                'font-size:74%;'+
                '}'+
                '.fontlabelred'+
                '{'+
                '    font-family:Arial, Helvetica, sans-serif;'+
                '    color:red;'+
                '    font-size:74%;'+
                '}'+
                '.fontlabelblue'+
                '{'+
                '    font-family:Arial, Helvetica, sans-serif;'+
                '    color:blue;'+
                '    font-size:74%;'+
                '}'+
                '.tablewithbottomborder'+
                '{'+
                 '   border-bottom:3px solid #e39321;'+
                '}'+
                '.tablewiththreesideborder'+
                ' {'+
                  '  border-top:1px solid #e39321;'+
                  '  border-bottom:1px solid #e39321;'+
                  '  font-family:Arial, Helvetica, sans-serif;'+
                 '   color:#333;'+
                '    font-size:100%;'+
                ' }'+
                ' </style>'+
                ' <table  width=100%>'+
                   ' <tr>'+
                        '<td class=fontlabel>'+
                            'Dear '+ strOwnerName +', <br><br>'+
                            'A valued customer just visited the Performance Accelerator and expressed interest in this Service Bulletin. '+
                            'Please contact the customer within 24 hours, while the lead is still warm.'+'<br><br>'+
                            'Be sure to click the SFDC link below and update the Opportunity after your initial discussion. Good luck and happy selling! '+
                            '<br><br>'+                
                                '<table width=100% class="tablewiththreesideborder" cellspacing=0 cellpadding=0>'+
                               ' <tr> <td height=25 colspan=2 ><br></td></tr>'+                
                               ' <tr> <td height=25 colspan=2 bgcolor="#eeeeee"><b>Opportunity Details</b></td></tr>'+
                               ' <tr> <td height=30><b>Opportunity Name </b> </td>'+                                                              
                              '  <td> <a href='+URL.getSalesforceBaseUrl().toExternalForm()+'/'+opp.Id+'>'+opp.name+'</a></td> </tr>'+                                                 
                             '   </table> '+           
                            '<br><br>'+
                            'We appreciate your fast response and commitment. Honeywell couldn’t do it without you!'+ 
                            '<br><br>'+               
                            'Thank you,<br>Honeywell Flight Support Services'+                
                            '<br><br></td></tr></table>';        
                body=body+'</table></body></html>';       
                message.setSubject(subject);
                message.setHtmlBody(body);                                   
                message.setBccSender(false);
                message.setUseSignature(false);
                message.setOrgWideEmailAddressId(label.Yourresponse_OrgId);
                message.setSaveAsActivity(false); 
                if(atrToAddresses.size()>0){
                    message.setToAddresses(atrToAddresses);
                    bulkEmails.add(message);
                }    
            }
            //License project AERO - CORP SF2SF integration starts
          
         /*   if((opp.Record_Type_Name__c == 'M&PM SIM Licensing')) 
            {
                if((opp.CUSTOMER_LICENSE_NEED_DATE__c != null)) 
                {
                    Date closeDate1=opp.CUSTOMER_LICENSE_NEED_DATE__c;
                    system.debug('closeDate1----->'+closeDate1);
                    integer diff;
                    if(closedate1<fiscalquarterdate)
                    {
                      system.debug('insideif1----->'+closedate1);
                      system.debug('insideif1----->'+fiscalquarterdate);
                      diff=closedate1.daysbetween(fiscalquarterdate);
                    }
                    if(closedate1>fiscalquarterdate)
                    {
                      system.debug('insideif2----->'+closedate1);
                      diff=fiscalquarterdate.daysbetween(closedate1);  
                    }
                    system.debug('diff----->'+diff);
                    decimal draft=((90-(diff))/30);
                    system.debug('draft-----'+draft);
                    draft1=(draft+3).setScale(2);
                    system.debug('draft1-----'+draft1);
                    Opportunity tempopp = new opportunity(id=opp.id);
                    draftplafOppToUpdate.add(tempopp);
                }
                else
                {
                    Opportunity tempopp = new opportunity(id=opp.id);
                    draftplafOppToUpdate.add(tempopp);
                }
                                  
            }*/
            //License project AERO - CORP SF2SF ends            
        }
        //M&Pm SIM License
        
        Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
        List<Messaging.SingleEmailMessage> msgList = new List<Messaging.SingleEmailMessage>();
        List<Messaging.SingleEmailMessage> bulkEmails1 = new List<Messaging.SingleEmailMessage>();
        string conid=Label.UFR_Cont_Id;     
        for(opportunity opp2:Opportunitylst)
        {
            if((opp2.License_Draft__c != null && opp2.License_Draft__c == Date.Today())&&(opp2.Record_Type_Name__c == 'M&PM SIM Licensing'))
            {
                if(opp2.Record_Data_Owner__c != null)
                {                   
                    msg.setTargetObjectId(opp2.Record_Data_Owner__c);
                    msg.setTemplateId(label.Sim_License_Appendix_Eng);
                    msg.setWhatId(opp2.id);
                    msg.setOrgWideEmailAddressId(label.AeroNo_Reply_email_ID);               
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[]{ msg });                     
                } 
                else if(opp2.BusinessContact__c != null)
                {
                    msg.setTargetObjectId(conid);
                    msg.setsaveAsActivity(false);
                    msg.setTemplateId(label.Sim_License_Acct_Mng);
                    msg.setWhatId(opp2.id);
                    msg.setOrgWideEmailAddressId(label.AeroNo_Reply_email_ID);  
                    msgList.add(msg);
                    system.debug(msgList);
                     String[] toAddresses = new String[] {opp2.BusinessContact__r.email};    
                    Savepoint sp = Database.setSavepoint();                 
                    if(msg.getTemplateId()!=null)
                            Messaging.sendEmail(msgList);
                        Database.rollback(sp);
                        if(msgList.size()>0){
                            for(Messaging.SingleEmailMessage email : msgList){
                                Messaging.SingleEmailMessage emailToSend = new Messaging.SingleEmailMessage();
                                emailToSend.setToAddresses(toAddresses);                                
                                emailToSend.setPlainTextBody(email.getPlainTextBody());
                                emailToSend.setHTMLBody(email.getHTMLBody());
                                emailToSend.setSubject(email.getSubject());
                                emailToSend.setOrgWideEmailAddressId(email.getOrgWideEmailAddressId());
                                if(emailToSend.getHTMLBody()!=null)
                                    bulkEmails1.add(emailToSend);
                            }
                        }                                               
                } 
            }
            /*
            if((opp2.Engineer_Manager_Review_Date__c != null)&&(opp2.Record_Type_Name__c == 'M&PM SIM Licensing'))
            {
                system.debug('inside opp2'+opp2.Engineer_Manager_Review__c);
                if(opp2.BusinessContact__c != null)
                {
                    msg.setTargetObjectId(conid);
                    msg.setsaveAsActivity(false);
                    msg.setTemplateId(label.Sim_License_Acct_Mng);
                    msg.setWhatId(opp2.id);
                    msg.setOrgWideEmailAddressId(label.AeroNo_Reply_email_ID);  
                    msgList.add(msg);
                    system.debug(msgList);
                     String[] toAddresses = new String[] {opp2.BusinessContact__r.email};    
                    Savepoint sp = Database.setSavepoint();                 
                    if(msg.getTemplateId()!=null)
                            Messaging.sendEmail(msgList);
                        Database.rollback(sp);
                        if(msgList.size()>0){
                            for(Messaging.SingleEmailMessage email : msgList){
                                Messaging.SingleEmailMessage emailToSend = new Messaging.SingleEmailMessage();
                                emailToSend.setToAddresses(toAddresses);                                
                                emailToSend.setPlainTextBody(email.getPlainTextBody());
                                emailToSend.setHTMLBody(email.getHTMLBody());
                                emailToSend.setSubject(email.getSubject());
                                emailToSend.setOrgWideEmailAddressId(email.getOrgWideEmailAddressId());
                                if(emailToSend.getHTMLBody()!=null)
                                    bulkEmails1.add(emailToSend);
                            }
                        }                 
                }
            }*/
        }
        if(bulkEmails1.size()>0){
            Messaging.sendEmail(bulkEmails1);
        }    
            
        //M&PM Sim License      
        //License project AERO - CORP SF2SF integration starts 
      /*  if(draftplafOppToUpdate.size()>0)
        {
            try
            {
               
                if(string.valueof(draft1) != null)
                {
                    draftplafOppToUpdate[0].Current_end_of_fiscal_quarter_date1__c=fiscalquarterdate;
                    draftplafOppToUpdate[0].Draft_Priority_Flag__c=string.valueof(draft1);                  
                }
                draftplafOppToUpdate[0].Current_end_of_fiscal_quarter_date__c=fiscalquarterdate;
                update draftplafOppToUpdate;                
            }
            catch(Exception e)
            {
                System.debug('Exception in updating opportunity in OppAfterUpdateHelperclass'+e);
            }
        }*/
        //License project AERO - CORP SF2SF ends            
        if(!(Test.isRunningTest()))
        {
            Messaging.reserveSingleEmailCapacity(trigger.size);
            Messaging.sendEmail(bulkEmails);    
        }   
        // Code Added for SR# INC000008286465 - ATR RMU Opp Creation Mail Trigger - End 
        OppClassForPublicMethods objtemp = new OppClassForPublicMethods();
        List<Opportunity_Sales_Team__c> tempOppList = objtemp.Opportunity_insert_opportunityteam(listObjOppNew,oldMap);
        
        if(null!=tempOppList && tempOppList.size()>0)
        {
            System.debug('tempOppList:::'+tempOppList.size());
            oppSalesTeamList.addAll(tempOppList);
        }
        
        if(oppSalesTeamList.size()>0)
        {
            try 
            {                
                System.debug('oppSalesTeamList:::'+oppSalesTeamList.size());
                insert oppSalesTeamList ;
            }catch(Exception ex){        
                System.debug('Exception in inserting opportunity Sales Team in OppAfterInsertHelperclass'+ex);
            }
        }
        if(listOppGate.size()>0)
        {
            try
            {
                insert listOppGate;
                System.Debug('Insert');
            }
            catch(Exception e)
            {
                System.debug('Exception in inserting opportunity gates in OppAfterInsertHelperclass'+e);
            }
        }
        if(listOppToUpdate.size()>0)
        {
            try
            {
                update listOppToUpdate;
                System.Debug('Insert');
            }
            catch(Exception e)
            {
                System.debug('Exception in inserting opportunity in OppAfterInsertHelperclass'+e);
            }
        }  
        // Added code for INC000006769488
         if(listOppToUpdate1.size()>0)
        {
            try
            {
                update listOppToUpdate1;
             
            }
            catch(Exception e)
            {
                System.debug('Exception in inserting opportunity in OppAfterInsertHelperclass'+e);
            }
        }  
      // Added code for INC000006769488     

      //Added code for leadupadate
      if(listObjOppNew.size()==1){
          Opportunity opp = listObjOppNew.get(0);
          if(opp.lead_id__c != null){
              Lead leadRec = [select id,Opportunity_Name__c from Lead where id=:opp.lead_id__c];
              leadRec.Opportunity_Name__c = opp.id;
              //leadRec.Opportunity_Search_Confirmation__c = false;
              update leadRec;
          }
      } 
    }
}