/*******************************************************************************
Name         : EMBeforeInsertHelperClass
Created By   : Anusuya Murugiah
Company Name : NTT Data 
Project      : Fix for SOQL 101 Error 
Created Date : 22 December 2014
Usages       : This Trigger is to replace the set of Email Message Triggers split across 
               into single trigger call. 
Modification History
Date            Version No.     Modified by     Brief Description of Modification
12-Jul-2017     1.1             NTTDATA         INC000012050233 - to prevent case creation from "caragian@ceid.upatras.gr" email  
13-Sep-2017     1.2             NTTDATA         INC000012036807 - Modified preventing cases for JUNK subject if Subject contains REF ID             
*******************************************************************************/
public class EMBeforeInsertHelperClass
{   
    //public  Map<id,Case> mapCase= new Map<id,Case>();
    public static void emBeforeInsertMethod(List<EmailMessage> listObjEM,Map<ID,EmailMessage> oldMap ){
        String sub='';
        list<case_lookup__c> Lookuplist= new list<case_lookup__c>(); 
        Lookuplist=[select subject__c from case_lookup__c];
        // new_case trigger - start
        list<case> clist= new list<case>();
        list<EmailMessage> elist= new list<EmailMessage>();
        List <ACT_Case_Escalation__c> alist = ACT_Case_Escalation__c.getall().values();
        List<Task> TaskDelete = new List<Task>();
        List<Task> TaskInsert = new List<Task>();
        
        List<Case> casetoUpdate= new List<Case>();
        List<Case> cases= new List<Case>();
        List<Id> updateTaskIds1=new List<Id>();
        
        List<Id> caseIDList=new List<Id>();
        Map<id,Case> mapCase= new Map<id,Case>();
        Map<String,String> mapOriginOwnerId = new Map<String,String>();
        
        string s1,s2;
                        /* start of SCTASK2693383 edited by saurabh*/

        List<string> Fromaddress=new List<String>();
                   /* end of SCTASK2693383*/
     
        List<Case> p2cCases = new List<Case>();//added for propose to close functinality
        List<EmailMessage> p2cEmails = new List<EmailMessage>();//added for propose to close functinality
        Long hours;//added for propose to close functinality
        //It is used to create New case based on Case_ref_ID //INC0000214866 
        List<Case> lstcs = new List<Case>();
        String emorgin ='';
        String EmailOrigin='';
        
        for(EmailMessage e : listObjEM) 
        {
                        /* start of SCTASK2693383 edited by saurabh*/

            fromaddress.add(e.fromaddress);
                            /* end of SCTASK2693383*/

            if(e.ParentId != null){
                s1 = e.ParentID;
                if(s1.substring(0,3)=='500')
                {
                    caseIDList.add(e.ParentId);
                }
            }
        }
                

        if(caseIDList.size()>0)
        {
            mapCase = new Map<id,Case>([select isClosed,OwnerId,status ,Case_Ref_ID__c,OpenTask__c,ID,ContactID,Subject,Description,CaseNumber,OwnerId__r.IsActive,E2CP__Case_Thread_Id__c,origin,
            Activate_ACT__c, Emailbox_Origin__c,recordtypeid, recordtype.name,closeddate,(Select Id,subject from Tasks) from case where id in:caseIDList ]); 
        }
        Set<String> stEmailOrgin = new set<String>();
        
        for(Id casId : mapCase.keyset()){
            if(mapCase.get(casId).Emailbox_Origin__c !=null){
                system.debug('====orging===='+mapCase.get(casId).Emailbox_Origin__c);
                stEmailOrgin.add(mapCase.get(casId).Emailbox_Origin__c);
                
                
            }
        }
        
        if(stEmailOrgin.size()>0){
            List<Case_Matrix__c> lstCM = [select Id,Name,OwnerId__c,DetailClass__c,classification__c,type__c from Case_Matrix__c where Name IN: stEmailOrgin limit 1];
            if(lstCM.size()>0){
                mapOriginOwnerId.put(lstCM[0].Name,lstCM[0].OwnerId__c);
                
            }
        }
        // new_case trigger - end
        try
        { 
            for( emailmessage e:listObjEM) {     

                    //INC0000214866 start Instead of Reopening a case we are creating new case for RO, DOD, OEM,Quotes,Oredrs, Returns and RPRO RT in case
                    system.debug('=ParentID======'+e.ParentId+'esubjectat87line'+e.subject+'===ToAdd'+e.ToAddress+'===closedda'+mapCase.get(e.ParentId).closeddate+'==RT='+mapCase.get(e.ParentId).recordtypeid+'===='+mapCase.get(e.ParentId).IsClosed);
                //21-Nov-19:RAPD-3922:added for on/off junk cases to monitor
                if((e.ToAddress == null) && (e.CCAddress == null) && (Label.AOG_SPEX_Junk_Cases == 'OFF'))    
                {
                    e.subject.addError('Spam Message should not create case'); 
                }//21-Nov-19:RAPD-3922:end
                else{
                    //Added code changes for Email Template 
                    if(e.ParentId != null && e.subject != null && e.htmlbody != null ){
                    
                      system.debug('***Incoming mail from aerorepairs***');
                        e.htmlbody = e.htmlbody.replace('<p class="MsoNormal"><span style="font-family:&quot;Arial&quot;,sans-serif"><o:p>&nbsp;</o:p></span></p>','');
                        e.htmlbody = e.htmlbody.replace('<p class="MsoNormal"><o:p></o:p></p>','');
                        //removing to avoid email templates to have \n instead of <br/> for INC0003307529
                        //e.htmlbody = e.htmlbody.replace('<br/>','/n');
                        //end INC0003307529
                        e.htmlbody = e.htmlbody.replace('<p class="MsoNormal"><span lang="EN-IN"><o:p>&nbsp;</o:p></span></p>',''); 
                        e.htmlbody = e.htmlbody.replace('<p class="MsoNormal"><o:p>&nbsp;</o:p></p>',''); 
                        e.htmlbody = e.htmlbody.replace('<p class="MsoNormal">',''); 
                        e.htmlbody = e.htmlbody.replace('</p>','');
                        e.htmlbody = e.htmlbody.replace('<span style="font-family:">&nbsp;</span>',''); 
                        e.htmlbody = e.htmlbody.replace('<o:p></o:p>','');
                        e.htmlbody = e.htmlbody.replace('class="MsoNormalTable"','');
                        e.htmlbody = e.htmlbody.replace('"MsoNormal"','');
                    }                   
                   //ended changes
                   
                    if(e.ParentId != null && mapCase.get(e.ParentId).IsClosed == True && mapCase.get(e.ParentId).recordtypeid != null)
                    {
                        Datetime clsDateAdd7 = mapCase.get(e.ParentId).closeddate.addDays(7);
                        Datetime todayDate = system.today();
                        
                        if(Test.IsRunningTest()){
                            todayDate = todayDate.addDays(1);
                            clsDateAdd7 = system.today();
                        }
                      /*  if(e.ParentId != null && e.Incoming && (mapCase.get(e.ParentId).recordtypeid == Label.TechnicalIssueId || mapCase.get(e.ParentId).recordtypeid == Label.Case_AOG_RecordType) && (mapCase.get(e.ParentId).status=='Closed-No response' || mapCase.get(e.ParentId).status=='Closed-Approved'))
                        {
                        
                            system.debug('======Entered==='+e.subject);
                            if(mapCase.get(e.ParentId).Emailbox_Origin__c !=null)
                                EmailOrigin = mapCase.get(e.ParentId).Emailbox_Origin__c;
                            
                            if(e.subject != null)
                            {
                                if(e.subject.contains(mapCase.get(e.ParentId).Case_Ref_ID__c)) {
                                    
                                    system.debug('========entered our condition====');
                                    case c = new case();
                                        c.ParentId = e.ParentId;
                                        c.status = 'Open';
                                        c.recordtypeid = mapCase.get(e.ParentId).recordtypeid;
                                        c.ContactID = mapCase.get(e.ParentId).ContactID;
                                        c.Subject = mapCase.get(e.ParentId).Subject;
                                        c.origin = mapCase.get(e.ParentId).origin;
                                        c.Activate_ACT__c = mapCase.get(e.ParentId).Activate_ACT__c;
                                      if(mapOriginOwnerId.containsKey(EmailOrigin))
                                            c.OwnerId = mapOriginOwnerId.get(EmailOrigin);
                                        else if(mapCase.get(e.ParentId).OwnerId__r.IsActive== True)
                                            c.OwnerId = mapCase.get(e.ParentId).OwnerId;
                                        else 
                                            c.OwnerId = Label.aero_default_user_id;
                                        c.Emailbox_Origin__c=mapCase.get(e.ParentId).Emailbox_Origin__c;
                                    lstcs.add(c);
                                }
                             }
                             
                            
                            
                            
                         }*/
                         
                             //Changed for SCTASK2986118 to create new case when email is sent to a closed FSS Technical Issue case after 7 days
                        system.debug('todayDate:'+todayDate+', '+'clsDateAdd7:'+clsDateAdd7);   
                        system.debug('mapCase.get(e.ParentId).recordtypeid:'+mapCase.get(e.ParentId).recordtypeid);
                        system.debug('e.Incoming'+e.Incoming);
                        if( e.Incoming && todayDate> clsDateAdd7  && (mapCase.get(e.ParentId).recordtypeid == Label.FSS_Tech_Issue_RT_ID || mapCase.get(e.ParentId).recordtypeid == Label.AeroCustomerSupportRecTypeId) ){

                                if((e.subject != null && e.subject.contains(mapCase.get(e.ParentId).Case_Ref_ID__c)) ||(e.textbody!= null && e.textbody.contains(mapCase.get(e.ParentId).Case_Ref_ID__c)) ) {    
                                      
                                    system.debug('========entered our condition====');
                                        e.subject=e.subject.remove(mapCase.get(e.ParentId).Case_Ref_ID__c);
                                        e.textbody=e.textbody.remove(mapCase.get(e.ParentId).Case_Ref_ID__c);                    
                                    case c = new case();
                                        c.status = 'Open';
                                        c.recordtypeid = mapCase.get(e.ParentId).recordtypeid;
                                        c.Subject = e.subject;
                                        c.contactid=mapCase.get(e.ParentId).contactid;
                                        //if(mapCase.get(e.ParentId).origin !=null && mapCase.get(e.ParentId).origin !='')
                                         //   c.origin = mapCase.get(e.ParentId).origin;
                                        //system.debug('====case Matrinx==='+mapOriginOwnerId.get(emorgin));
                                         //c.description=e.textbody;
                                         String s = e.textbody;
                                         String stext = s.abbreviate(31900);
                                         System.debug('text body truncate length :'+stext.length());                                    
                                        //System.assertEquals(31900, s2.length());
                                         c.Description = stext;
                                         c.Emailbox_Origin__c ='Email-FSS Tech Support';
                                         c.origin = 'Email-FSS Tech Support';
                                   lstcs.add(c);
                            }
                            
                            }
                            //end SCTASK2986118 
                        else if(e.Incoming && todayDate> clsDateAdd7 && (mapCase.get(e.ParentId).recordtypeid == Label.Case_RT_R_O || mapCase.get(e.ParentId).recordtypeid == Label.R_O_DoD_Need_Contract || mapCase.get(e.ParentId).recordtypeid == Label.Case_RT_OEM_Quotes_Orders || mapCase.get(e.ParentId).recordtypeid == Label.QuotesRecordID || mapCase.get(e.ParentId).recordtypeid == Label.Order_RecordType || mapCase.get(e.ParentId).recordtypeid == Label.Case_Return_RecordType || mapCase.get(e.ParentId).recordtypeid == Label.ReturnsPRO_Id))
                        {
                            system.debug('======Entered==='+e.subject);
                            //system.debug('======second map values==='+mapOriginCM.get(emorgin).OwnerId__c);
                            
                            if(mapCase.get(e.ParentId).Emailbox_Origin__c !=null)
                      
                                emorgin = mapCase.get(e.ParentId).Emailbox_Origin__c;
                            system.debug('======Entered==='+emorgin);
                            if(e.subject != null)
                                
                            {
                                system.debug('email subject======>'+mapCase.get(e.ParentId).Case_Ref_ID__c);
                                system.debug('esubject====>'+e.subject);
                                if(e.subject.contains(mapCase.get(e.ParentId).Case_Ref_ID__c)) {
                                    
                                    system.debug('========entered our condition====');
                                   
                                    case c = new case();
                                        c.ParentId = e.ParentId;
                                        c.status = 'Open';
                                        c.recordtypeid = mapCase.get(e.ParentId).recordtypeid;
                                        if(mapCase.get(e.ParentId).ContactID !=null)
                                            c.ContactID = mapCase.get(e.ParentId).ContactID;
                                        c.Subject = mapCase.get(e.ParentId).Subject;
                                        //if(mapCase.get(e.ParentId).origin !=null && mapCase.get(e.ParentId).origin !='')
                                         c.origin = mapCase.get(e.ParentId).Emailbox_Origin__c;//change as per SCTASK2719062
                                        //c.origin = 'Email'; //change as per SCTASK2719062
                                        if(mapCase.get(e.ParentId).Activate_ACT__c)
                                            c.Activate_ACT__c = mapCase.get(e.ParentId).Activate_ACT__c;
                                        system.debug('====case Matrinx=contains=='+mapOriginOwnerId.containsKey(emorgin));
                                        //system.debug('====case Matrinx==='+mapOriginOwnerId.get(emorgin));
                                        if(mapOriginOwnerId.containsKey(emorgin))
                                            c.OwnerId = mapOriginOwnerId.get(emorgin);
                                        else if(mapCase.get(e.ParentId).OwnerId__r.IsActive== True)
                                            c.OwnerId = mapCase.get(e.ParentId).OwnerId;
                                        else 
                                            c.OwnerId = Label.aero_default_user_id;
                                            
                                    lstcs.add(c);
                                   
                                }
                                else if(e.textBody != null){
                                    if(e.TextBody.contains(mapCase.get(e.ParentId).Case_Ref_ID__c)){
                                        system.debug('========entered text condition====');
                                        
                                        case c = new case();
                                            c.ParentId = e.ParentId;
                                            c.status = 'Open';
                                            c.recordtypeid = mapCase.get(e.ParentId).recordtypeid;
                                            if(mapCase.get(e.ParentId).ContactID !=null)
                                            c.ContactID = mapCase.get(e.ParentId).ContactID;
                                            c.Subject = mapCase.get(e.ParentId).Subject;
                                            //if(mapCase.get(e.ParentId).origin !=null && mapCase.get(e.ParentId).origin !='')
                                            c.origin = mapCase.get(e.ParentId).Emailbox_Origin__c;//change as per SCTASK2719062
                                        //c.origin = 'Email'; //change as per SCTASK2719062
                                            if(mapCase.get(e.ParentId).Activate_ACT__c)
                                                c.Activate_ACT__c = mapCase.get(e.ParentId).Activate_ACT__c;
                                            system.debug('====case Matrinx=contains=='+mapOriginOwnerId.containsKey(emorgin));
                                            if(mapOriginOwnerId.containsKey(emorgin))
                                                c.OwnerId = mapOriginOwnerId.get(emorgin);
                                            else if(mapCase.get(e.ParentId).OwnerId__r.IsActive== True)
                                                c.OwnerId = mapCase.get(e.ParentId).OwnerId;
                                            else 
                                                c.OwnerId = Label.aero_default_user_id;
                                            
                                        lstcs.add(c);
                                    }
                                }
                           }else if(e.textBody != null){
                                if(e.TextBody.contains(mapCase.get(e.ParentId).Case_Ref_ID__c)){
                                    system.debug('========entered text condition====');
                                    
                                    case c = new case();
                                        c.ParentId = e.ParentId;
                                        c.status = 'Open';
                                        c.recordtypeid = mapCase.get(e.ParentId).recordtypeid;
                                        if(mapCase.get(e.ParentId).ContactID !=null)
                                            c.ContactID = mapCase.get(e.ParentId).ContactID;
                                        c.Subject = mapCase.get(e.ParentId).Subject;
                                        //if(mapCase.get(e.ParentId).origin !=null && mapCase.get(e.ParentId).origin !='')
                                        c.origin = mapCase.get(e.ParentId).Emailbox_Origin__c;//change as per SCTASK2719062
                                        //c.origin = 'Email'; //change as per SCTASK2719062
                                        if(mapCase.get(e.ParentId).Activate_ACT__c)
                                            c.Activate_ACT__c = mapCase.get(e.ParentId).Activate_ACT__c;
                                        system.debug('====case Matrinx=contains=='+mapOriginOwnerId.containsKey(emorgin));
                                        if(mapOriginOwnerId.containsKey(emorgin))
                                            c.OwnerId = mapOriginOwnerId.get(emorgin);
                                        else if(mapCase.get(e.ParentId).OwnerId__r.IsActive== True)
                                            c.OwnerId = mapCase.get(e.ParentId).OwnerId;
                                        else 
                                            c.OwnerId = Label.aero_default_user_id;
                                        
                                    lstcs.add(c);
                                }
                            }
                        }
                    }
                    if((e.subject != null && e.subject.contains('has sent fax'))   
                    && ( (e.ToAddress=='CPSQuotesCOE@honeywell.com')
                        ||(e.ToAddress=='cpsquotescoe@13qh3mz6no8wpkr8ylhp1blea.tkl3bmaw.t.case.sandbox.salesforce.com')                
                        ||(e.ToAddress==' cpsquotescoeanntmptuc@honeywell.com')
                        ||(e.ToAddress=='cpsquotescoeanntmptuc@8-1w6thgf4qjhu48aibw28cwvqq.tkl3bmaw.t.case.sandbox.salesforce.com')                
                        ||(e.ToAddress=='cpsquotescoedvcr@honeywell.com')                
                        ||(e.ToAddress=='cpsquotescoedvcr@d-23mzup5pabj2c3kvcjval56bg.tkl3bmaw.t.case.sandbox.salesforce.com')                
                        ||(e.ToAddress=='cpsquotescoephx@honeywell.com')                
                        ||(e.ToAddress=='cpsquotescoephx@o-2kdepgpghd1sp02h8wwvxssae.tkl3bmaw.t.case.sandbox.salesforce.com')                
                       )
                    ){                
                      e.subject.addError('Email Message having success for Fax Creation not needed');                  
                    }                
                    // Added code for INC000012050233 to prevent Case creation
                    String FromEmailRestriction = Label.FromEmailRestrictionOnCaseCreate;
                    if(e.FromAddress!=null && FromEmailRestriction.contains(e.FromAddress)){
                        system.debug('inside email exception');
                        e.addError('To stop Case creation for mails available in FromEmailRestriction');
                    }
                    // End code for INC000012050233 to prevent Case creation
                    if(e.subject != null&&((e.ToAddress=='fs1@mygdc.com')||(e.ToAddress=='fs1@x-4ynyyuc7ondi6lxgj67uy91lq.3dwxyeau.3.case.salesforce.com')
                    ||(e.ToAddress=='fs@mygdc.com')||(e.ToAddress=='fs@2hcgiys4cnff8g1jhmcztboh8.3dwxyeau.3.case.salesforce.com')
                    ||(e.ToAddress=='gfo@mygdc.com')||(e.ToAddress=='gfo@v-30fe36sg7jwdbs9uz1oysh36.3dwxyeau.3.case.salesforce.com')))
                    {                 
                          if((e.subject.contains('Reservation Details'))||(e.subject.contains('Acquire Reservation'))||(e.subject.contains('Confirm Reservation'))
                          ||(e.subject.contains('Blackberry Summary'))||(e.subject.contains('FAA Command Center Message'))||(e.subject.contains('Global Data Center CDM'))
                          ||(e.subject.contains('Global Data Center FS Daily'))||(e.subject.contains('ITF Trip'))||(e.subject.contains('Flight Plan Summary'))
                          ||(e.subject.contains('Undelivered Mail Return to Sender'))||(e.subject.contains('Western Service Area Outlook'))
                          ||(e.subject.contains('[NBAA-GADesk]'))||(e.subject.contains('Email/Manual Fax'))||(e.subject.contains('Scan From a Xerox Workcentre'))
                          ||(e.subject.contains('FrontierMedex'))||(e.subject.contains('TRC Report'))||(e.subject.contains('Western Service Area Outlook'))||(e.subject.contains('FAA COMMAND CENTER MESSAGE'))||(e.subject.contains('Mail System Error')))
                          {
                                  e.subject.addError('Spam Message should not create case'); 
                          }
                          if((e.ToAddress=='fs@mygdc.com')||(e.ToAddress=='fs@2hcgiys4cnff8g1jhmcztboh8.3dwxyeau.3.case.salesforce.com')
                          ||(e.ToAddress=='gfo@mygdc.com')||(e.ToAddress=='gfo@v-30fe36sg7jwdbs9uz1oysh36.3dwxyeau.3.case.salesforce.com')){
                              if((e.subject.contains('ADNS MESSAGE TO KSNAXGXS'))||(e.subject.contains('FAA ICAO FPL ACK'))||(e.subject.contains('FAA ICAO FPL REJ'))||(e.subject.contains('Updated Manual Fax'))||(e.subject.contains('New Manual Fax'))||(e.subject.contains('Fax Status Alert'))||(e.subject.contains('Manual PKG:'))){ 
                                e.subject.addError('Spam Message should not create case');   
                              }
                          }
                          if((e.ToAddress=='fs@mygdc.com')||(e.ToAddress=='fs@2hcgiys4cnff8g1jhmcztboh8.3dwxyeau.3.case.salesforce.com')){
                              if((e.subject.contains('XOJET MSG'))||(e.subject.contains('FS MESSAGE'))){
                               e.subject.addError('Spam Message should not create case'); 
                              }
                          }
                          if((e.ToAddress=='gfo@mygdc.com')||(e.ToAddress=='gfo@v-30fe36sg7jwdbs9uz1oysh36.3dwxyeau.3.case.salesforce.com')){
                              if((e.subject.contains('NET JET MSG'))||(e.subject.contains('OTHER MSG'))||(e.subject.contains('Flight Plan Request'))||(e.subject.contains('Weather Request -'))||(e.subject.contains('Submission From'))){
                               e.subject.addError('Spam Message should not create case'); 
                              }
                          }
                          if((e.ToAddress=='fs1@mygdc.com')||(e.ToAddress=='fs1@x-4ynyyuc7ondi6lxgj67uy91lq.3dwxyeau.3.case.salesforce.com'))
                          {
                              if((e.subject.contains('New ITF trip for'))||(e.subject.contains('ITF trip changed'))){
                               e.subject.addError('Spam Message should not create case'); 
                              }
                          }
                    } 
                    if(((e.FromAddress=='george.risinger@honeywell.com')||(e.FromAddress=='APISConfirmNoReply@dhs.gov')||(e.FromAddress=='news@aviationnews.us')) 
                    || ((e.subject != null)&&(e.ToAddress=='aerosfdccustomermaster@honeywell.com'||e.ToAddress=='aerosfdccustomermaster@1sprm798xiyf6nzq46mjz43miujobodml8qnmrkfc9xjxuyg0k.18-careai.cs23.case.sandbox.salesforce.com')&&(e.subject.contains('Contract Expiration Mail')))
                    || (null!=e.htmlbody && e.htmlbody.contains('Delivery to these recipients or groups is complete, but no delivery notification was sent by the destination server:')) // SR-449243
                    ){
                        e.subject.addError('Spam Message should not create case'); 
                    }
                    /************************** Added For Dual Criteria **************************/ 
                    if((e.FromAddress=='gfo@mygdc.com')||(e.FromAddress=='gfo@v-30fe36sg7jwdbs9uz1oysh36.3dwxyeau.3.case.salesforce.com')){
                        if((e.subject.contains('Flight Plan Request'))||(e.subject.contains('Weather Request -'))||(e.subject.contains('Submission From'))){
                            e.subject.addError('Spam Message should not create case');
                        }    
                    }    
                    /************************** Added For Dual Criteria **************************/
                    
                    /************************** Added For gdc.accounts@honeywell.com **************************/
                    if((e.FromAddress=='CTSEFTCW@HONEYWELL.COM') || (e.FromAddress=='wawfnoreply@csd.disa.mil')){
                      if((e.ToAddress=='gdc.accounts@honeywell.com') || (e.ToAddress=='gdc.accounts@n-4j9j61s4n03qnjgi9kl45ik4n.3dwxyeau.3.case.salesforce.com')){
                          e.subject.addError('Spam Message should not create case');    
                      }
                    }
                    /*****************Added for SCTASK3638751********************/
                    if(((e.ToAddress=='CAMPIssues@honeywell.com') || (e.ToAddress=='campissues.honeywell@1tipvjlrnl52eqr5q51ighqtrfacamoag3qlhdg9foghr3s1ko.3k-rmyua2.cs125.apex.sandbox.salesforce.com')) && e.FromAddress!='trendsupport@campsystems.com'){
                       e.subject.addError('Spam Message should not create case');    
                    }
                    /******************End of SCTASK3638751***********************/
                    /************************** Added For gdc.accounts@honeywell.com **************************/                                                
                    
                    /*****************Added for SCTASK3756724********************/
                   if(((e.ToAddress=='wbrepairorders@honeywell.com') || (e.CcAddress =='wbrepairorders@honeywell.com') || (e.ToAddress=='wbrepairorders@i-1isy9vtz4m5xjx0tiwwn0oaqianu2n38dqegm203iecmuuzzzx.7c-8sdqbeae.cs191.case.sandbox.salesforce.com')) && e.FromAddress =='workbench-NoReply@corp.ds.fedex.com' && ((e.subject.contains('Change Notice for FedEx Order Number'))||(e.subject.contains('SO Details For Order Number')))){
                       e.subject.addError('Spam Message should not create case');    
                    } 
                    /*****************End of SCTASK3756724********************/
                    
                    /*****************Added for SCTASK3765934********************/
                    if(((e.ToAddress=='AeroExportHolds@Honeywell.com') || ((e.CcAddress != null) && (e.CcAddress =='AeroExportHolds@Honeywell.com'))|| (e.ToAddress=='aeroexportholds@28ooyysnxi3r8nirp0o7ar7xdsh41smbvdaxtr6dkwd3k6o8az.3k-rmyua2.cs125.case.sandbox.salesforce.com')) && e.FromAddress =='easeadmin@ocr-inc.com'){
                       e.subject.addError('Spam Message should not create case');    
                    }
                    /*****************End of SCTASK3765934********************/
                    
                    /*****************Added for SCTASK3947305********************/
                    if(e.FromAddress == 'mercadoextranjeroselec2018@gmail.com' || e.FromAddress == 'notifications@owler.com'){
                     e.subject.addError('Spam Message should not create case'); 
                     }
                     /*****************Added for SCTASK3947305********************/
                    
                    if(e.subject != null){
                        sub = e.subject.toUpperCase();
                        // Added code for INC000012036807
                        Boolean subwithref = sub.containsIgnoreCase('ref:');
                        Boolean LookupSub = FALSE;
                        if(subwithref == FALSE)
                        {
                            for(integer i=0;i<Lookuplist.size();i++)
                            {   
                                // Changing logic to email Subject to check "Ref"
                                //if(Lookuplist[i].subject__C !=null && sub.contains(Lookuplist[i].subject__C.toUpperCase()) && ((!(Lookuplist[i].subject__C.containsIgnoreCase('out of office')) || !(Lookuplist[i].subject__C.containsIgnoreCase('out of the office')))&& (Lookuplist[i].subject__C.containsIgnoreCase('ref:')) ) )
                                if(Lookuplist[i].subject__C !=null && sub.contains(Lookuplist[i].subject__C.toUpperCase()) && LookupSub==FALSE)
                                {
                                    LookupSub = TRUE;
                                }                                                         
                            } 
                            if(LookupSub == TRUE)
                            {
                                e.subject.addError('Email Message with Junk Subjects Cannot be created');                                                   
                            }
                        }
                        // End code for INC000012036807
                    }
                /////// new_case trigger - Start
                    
                    if(( (e.ToAddress=='act@8-hbe4c1d5dfteqeiw3jhxk5fx.tkl3bmaw.t.case.sandbox.salesforce.com') 
                    || (e.ToAddress=='act@1fo28z5m6b6dsgbiv00hrfk4otaezk3o7vmo1xxvrkr39huq1ta.18-careai.cs23.case.sandbox.salesforce.com')
                    || (e.ToAddress=='act@honeywell.com')||(e.ToAddress=='apacactinternal@honeywell.com')
                    ||(e.ToAddress=='apacactinternal@v-4xx1vrdag3t7ojs2k1euga1v8.tkl3bmaw.t.case.sandbox.salesforce.com')
                    ||(e.ToAddress=='emeaactinternal@n-14iawb9e1cwos260gdtkw8m2a.tkl3bmaw.t.case.sandbox.salesforce.com')    
                    ||(e.ToAddress=='emeaactinternal@honeywell.com'))                    
                    && (e.ParentId != null))
                    { 
                        
                        s2 = e.ParentId;
                        if( s2.substring(0,3)=='500')
                        {
                            
                            if(null!=mapCase.get(e.ParentId) && mapCase.get(e.ParentId).Activate_ACT__c == false && mapCase.get(e.ParentId).subject!=e.Subject )
                            {
                            
                                case c= new case();
                                if( (e.ToAddress=='act@x-qlflmob3g4wuxzwhg5ke7n3g.in.sandbox.salesforce.com')
                                || (e.ToAddress=='act@1fo28z5m6b6dsgbiv00hrfk4otaezk3o7vmo1xxvrr39huq1ta.18-careai.cs23.case.sandbox.salesforce.com')
                                || (e.ToAddress=='act@honeywell.com'))
                                {
                                    c.Mail_Box_Name__c= 'Email-ACTinternal';
                                    c.Type='Internal Communication';
                                    c.Classification__c='US ACT Internal';
                                }
                                if((e.ToAddress=='APACACTinternal@honeywell.com')
                                ||(e.ToAddress=='apacactinternal@j-2tbxqhn05b4op6uf2x7y17shp.qc3zuma0.q.case.sandbox.salesforce.com'))
                                {
                                    c.Mail_Box_Name__c = 'Email-APACACTinternal';
                                    c.Classification__c='APAC ACT Internal';
                                }
                                if((e.ToAddress=='emeaactinternal@6kqi66hb66i8ylkwblqnaddhs.qc3zuma0.q.case.sandbox.salesforce.com')
                                ||(e.ToAddress=='EMEAACTInternal@Honeywell.com'))
                                {
                                    c.Mail_Box_Name__c = 'Email-EMEAACTInternal';
                                    c.Classification__c='EMEA ACT Internal'; 
                                }
                                c.Origin='Email';
                                c.Status='Open';
                                c.Activate_ACT__c=true;                                               
                                c.Type='Internal Communication';
                                c.ownerid = alist[0].ACT_Queue__c;
                                c.Recordtypeid = alist[0].RecordType_Id__c;
                                c.SuppliedEmail=e.FromAddress; 
                                c.ContactID = mapCase.get(e.ParentId).ContactID;
                                c.subject=mapCase.get(e.ParentId).Subject;
                                //Please write the logic to update
                                // c.ownerId='00G30000001zX8x';
                                // c.Recordtypeid='01230000000Zen1';
                                c.Export_Compliance_Content_ITAR_EAR__c='Undetermined';
                                c.Government_Compliance_SM_M_Content__c='Undetermined';
                                clist.add(c);
                                elist.add(e);
                                //Code modifying for ACT task deletion  
                                String newsub='Email: '+e.subject ;
                                if(mapCase.get(e.ParentId).tasks.size()>0 ){
                                    List<Task> tasklist = mapCase.get(e.ParentId).tasks;
                                    for(Task taskid : tasklist)
                                        if( taskid.subject == newsub)
                                            TaskDelete.add(taskId);
                                }   
                                //Code end modifying for ACT task deletion  
                                  
                            }
                        }
                    }
                    
                 
                    if(e.status=='0'){
                       
                        integer flag=0;
                        for(integer i=0;i<elist.size();i++){
                       
                            if(e.Id==elist[i].Id)
                                flag=1;
                        }
                        if(flag==0){
                            updateTaskIds1.add(e.ParentId);
                            
                        }
                    }
                ////// new_case trigger - End 
                }
                } // enf for                                                   
        }// try
        catch(Exception e){
        System.debug('Exception'+e.getLineNumber());
        }
        // Create new case when case associated with the email is already closed//
        List<Messaging.SingleEmailMessage> bulkEmails = new List<Messaging.SingleEmailMessage>();
        list<string> ems;
        string ems1; string emfrom; 
        list<Case_Matrix__c> cm = new list<Case_Matrix__c>();
        list<string> val;
        list<E2CP__casepref__c> e2cp = new list<E2CP__casepref__c>();
        list<Contact> con = new list<Contact>();
                /* start of SCTASK2693383 edited by saurabh */
              
                boolean isTechIssue=false;
        for(emailmessage e:listObjEM){
         if(e.Incoming &&  null!=mapCase.get(e.ParentId) && (mapCase.get(e.ParentId).isclosed) && ( mapCase.get(e.ParentId).status != 'Propose to Close'  && mapCase.get(e.ParentId).status != 'Tech Issue-SR Assigned'  && (mapCase.get(e.ParentId).recordtype.name =='Technical Issue' || mapCase.get(e.ParentId).recordtypeid == Label.AeroCustomerSupportRecTypeId) )){
              isTechIssue=true;    
              break;
              }
        }
         List<Contact> contactlist=new List<contact>();     
        if(isTechIssue)       
            contactlist=[select id from contact where email IN :fromaddress and Contact_Status__c='Active'];
          /* start of SCTASK2693383 */
       for( emailmessage e:listObjEM) { 
        s2 = e.ParentId;
        /* commenting to rollback case re-open functionality
        integer DaysBetween = 0;
        if(e.Incoming &&  null!=mapCase.get(e.ParentId) && mapCase.get(e.ParentId).isclosed ){
            DaysBetween=(mapCase.get(e.ParentId).closeddate.date()).daysBetween(system.today());
        }
        system.debug('cm**********'+DaysBetween);*/
          if( s2.substring(0,3)=='500')
            {
                if(e.Incoming &&  null!=mapCase.get(e.ParentId) 
                 && (mapCase.get(e.ParentId).isclosed) && ( mapCase.get(e.ParentId).status != 'Propose to Close'  &&
                 /* Changed for INC0002616246 to avoid creation of new case when customer replies to an existing closed case
                 (mapCase.get(e.ParentId).recordtype.name =='AOG' || 
                 */
                  (mapCase.get(e.ParentId).recordtype.name =='Technical Issue' || mapCase.get(e.ParentId).recordtypeid == Label.AeroCustomerSupportRecTypeId)
                 /* commenting to rollback case re-open functionality
                 || ((mapCase.get(e.ParentId).recordtype.name =='Orders'
                 || mapCase.get(e.ParentId).recordtype.name =='Quotes'
                 || mapCase.get(e.ParentId).recordtype.name =='OEM Quotes Orders'
                 || mapCase.get(e.ParentId).recordtype.name =='Repair & Overhaul'
                 || mapCase.get(e.ParentId).recordtype.name =='Returns'
                 || mapCase.get(e.ParentId).recordtype.name =='ReturnsPRO'
                 || mapCase.get(e.ParentId).recordtype.name =='Internal Escalations') && DaysBetween>=90 &&
                  (mapCase.get(e.ParentId).status != 'Closed' || mapCase.get(e.ParentId).origin == 'SAP Interface') )
                  */
                 ))
                {
                    Try
                    {
                        if(e.subject != null)
                        {
                            if(e.subject.contains(mapCase.get(e.ParentId).Case_Ref_ID__c)) {
                               /* start of SCTASK2693383  edited by saurabh */
                                   e.subject=e.subject.remove(mapCase.get(e.ParentId).Case_Ref_ID__c);
                                e.textbody=e.textbody.remove(mapCase.get(e.ParentId).Case_Ref_ID__c);                                
                                 if(mapCase.get(e.ParentId).Emailbox_Origin__c !=null)
                                    EmailOrigin = mapCase.get(e.ParentId).Emailbox_Origin__c;
                                
                                system.debug('========entered our condition====');
                                case c = new case();
                                    c.ParentId = e.ParentId;
                                    c.status = 'Open';
                                    c.recordtypeid = mapCase.get(e.ParentId).recordtypeid;
                                    c.Subject = e.Subject;
                                    String s = e.Textbody;
                                    String stext = s.abbreviate(31900);
                                    System.debug('text body truncate length :'+stext.length());                                    
                                    //System.assertEquals(31900, s2.length());
                                     c.Description = stext;
                                     if(contactlist.size()==1){
                                         c.contactid=contactlist[0].id;
                                     }
                                     else
                                     {
                                         c.SuppliedEmail= e.fromaddress;
                                     }
                                     c.origin = 'Email-AeroTechSupport';
                                    //c.ContactID = mapCase.get(e.ParentId).ContactID;
                                    //c.Subject = mapCase.get(e.ParentId).Subject;
                                   // c.Description = mapCase.get(e.ParentId).Description;
                                   // c.origin = mapCase.get(e.ParentId).origin;
                               /* end of SCTASK2693383*/
                                    c.Activate_ACT__c = mapCase.get(e.ParentId).Activate_ACT__c;
                                    if(mapOriginOwnerId.containsKey(EmailOrigin))
                                        c.OwnerId = mapOriginOwnerId.get(EmailOrigin);
                                    else if(mapCase.get(e.ParentId).OwnerId__r.IsActive== True)
                                        c.OwnerId = mapCase.get(e.ParentId).OwnerId;
                                    else 
                                        c.OwnerId = Label.aero_default_user_id;
                                    c.Emailbox_Origin__c=mapCase.get(e.ParentId).Emailbox_Origin__c;
                                lstcs.add(c);
                            }
                            else if(e.TextBody.contains(mapCase.get(e.ParentId).Case_Ref_ID__c)) {  //'if' condition changed to 'else if' for INC0001582128 because duplicate cases are getting created 
                                /* start of SCTASK2693383  edited by saurabh */
                               e.subject=e.subject.remove(mapCase.get(e.ParentId).Case_Ref_ID__c);
                                e.textbody=e.textbody.remove(mapCase.get(e.ParentId).Case_Ref_ID__c);                                
                                 if(mapCase.get(e.ParentId).Emailbox_Origin__c !=null)
                                    EmailOrigin = mapCase.get(e.ParentId).Emailbox_Origin__c;
                                
                                system.debug('========entered else if condition====');
                                case c = new case();
                                    c.ParentId = e.ParentId;
                                    c.status = 'Open';
                                    c.recordtypeid = mapCase.get(e.ParentId).recordtypeid;
                                      c.recordtypeid = mapCase.get(e.ParentId).recordtypeid;
                                              c.Subject = e.Subject;
                                     String s = e.Textbody;
                                    String stext = s.abbreviate(31900);
                                    System.debug('text body truncate length :'+stext.length());                                    
                                    //System.assertEquals(31900, s2.length());
                                     c.Description = stext;
                                     if(contactlist.size()==1){
                                         c.contactid=contactlist[0].id;
                                     }
                                     else
                                     {
                                         c.SuppliedEmail= e.fromaddress;
                                     }
                                     c.origin = 'Email-AeroTechSupport';
                                    //c.ContactID = mapCase.get(e.ParentId).ContactID;
                                    //c.Subject = mapCase.get(e.ParentId).Subject;
                                   // c.Description = mapCase.get(e.ParentId).Description;
                                  //  c.origin = mapCase.get(e.ParentId).origin;
                                    c.Activate_ACT__c = mapCase.get(e.ParentId).Activate_ACT__c;
                               /* end of SCTASK2693383*/
                                    if(mapOriginOwnerId.containsKey(EmailOrigin))
                                        c.OwnerId = mapOriginOwnerId.get(EmailOrigin);
                                    else if(mapCase.get(e.ParentId).OwnerId__r.IsActive== True)
                                        c.OwnerId = mapCase.get(e.ParentId).OwnerId;
                                    else 
                                        c.OwnerId = Label.aero_default_user_id;
                                    c.Emailbox_Origin__c=mapCase.get(e.ParentId).Emailbox_Origin__c;
                                lstcs.add(c);
                            }
                        }
                        
                     /*        
                           
                    if(e.toaddress != null)
                    {
                        ems1 = e.toaddress;
                    }
                    if(e.ccaddress != null)
                    { 
                        ems1 = ems1+';'+e.ccaddress;
                    }        
                        ems = ems1.split('\\;');
                        emfrom = e.fromaddress;
                        System.debug('Exception'+ems1);
                    Try
                    {
                        if(emfrom!= null){
                            Con = [select id from contact where email =: emfrom limit 1]; 
                        }

                        if(ems!=null && !ems.isempty())
                        {
                            e2cp =[SELECT E2CP__preflong__c,E2CP__prefval__c FROM E2CP__casepref__c where E2CP__preflong__c in: ems limit 1];
                   
                            System.debug('Exception'+e2cp);
                            if(e2cp!=null && !e2cp.isempty())
                            {
                                val = e2cp[0].E2CP__prefval__c.split(',');
                                //string emailbox = 'Email-'+val[0];
                                string emailbox = val[0];
                                cm =[select name, OwnerId__c, Classification__c, DetailClass__c,SubClass__c, 
                                type__c,RecordTypeId__c from Case_Matrix__c where name =:emailbox];
                                    system.debug('cm**********'+cm);
                            }
                                        
                        }
                        case c = new case();
                            c.status = 'Open';
                            system.debug('inside email message');
                            system.debug('c.ownerid in EMBeforeInsertHelperClass'+cm[0].ownerid__c);
                        if(cm!=null && !cm.isempty()){
                            if(cm[0].ownerid__c != null){
                                c.ownerid =cm[0].ownerid__c;
                            }
                            c.detail_class__c  = cm[0].detailClass__c;
                            c.priority = val[1];
                            if(cm[0].recordtypeid__c != null){
                                c.recordtypeid = cm[0].recordtypeid__c;
                            }
                            c.classification__c = cm[0].classification__c;
                            c.type =cm[0].type__c;
                            c.sub_class__c = cm[0].subclass__c;
                            c.origin  = 'Email';
                            c.Emailbox_Origin__c = cm[0].name;
                        }else{
                            c.origin  = val[0];
                            c.priority = val[1];
                            c.recordtypeid = val[2];
                        }
                        system.debug('Case details');
                        c.status = 'Open';
                        c.SuppliedEmail = e.FromAddress;
                        c.Case_Subject__c = e.ParentId;
                        if(con!=null && !con.isempty()){
                            c.contactid = con[0].id;
                        }else{
                            c.SuppliedEmail = e.FromAddress;
                        }
                        
                        /*String threadId =mapCase.get(e.ParentId).E2CP__Case_Thread_Id__c;
                        if(e.subject != null && e.subject != ''){ 
                        e.subject = e.subject.replace(threadId,'').replace(threadId.mid(2,30),'').replace(mapCase.get(e.ParentId).casenumber,'');
                        }
                        if(e.textBody != null && e.textBody != ''){ 
                        e.textBody = e.textBody.replace(threadId,'').replace(threadId.mid(2,30),'').replace(mapCase.get(e.ParentId).casenumber,'');
                        }
                        if(e.htmlBody != null && e.htmlBody != ''){ 
                        e.htmlBody = e.htmlBody.replace(threadId,'').replace(threadId.mid(2,30),'').replace(mapCase.get(e.ParentId).casenumber,'');
                        }
                        //e.parentid = c.id;
                        c.subject = mapCase.get(e.ParentId).Subject;
                        c.Description = mapCase.get(e.ParentId).Description;
                        c.Export_Compliance_Content_ITAR_EAR__c = 'No';
                        c.Government_Compliance_SM_M_Content__c = 'No';
                        c.IncomingNewEmail__c = true;
                        EmailMessage em = e.clone();
                        insert c;
                        // System.debug('Exception'+c.id);
                        //system.debug('email message id'+e.id);
                        //inserting a new comment
                        string s = URL.getSalesforceBaseUrl().toExternalForm()+'/'+mapCase.get(e.ParentId).id;
                        string s4 = URL.getSalesforceBaseUrl().toExternalForm()+'/'+c.id;
                        string s3 = URL.getSalesforceBaseUrl().toExternalForm()+'/'+e.id;
                        CaseComment newComment= new CaseComment();
                        newComment.CommentBody = 'This case was created from '+
                        mapCase.get(e.ParentId).CaseNumber+' with an email containing the old Cases’'+
                         ' Ref ID number (no re-open after final close). Case link: '+s.replaceFirst('http:', 'https:'); // +' Email link:'+s3;
                        newComment.IsPublished = False;
                        newComment.ParentId = c.id;
                        insert newComment;
                        em.parentid = c.id;
                        insert em;
                        case newc= [select casenumber from case where id=:c.id];
                        CaseComment newComment1= new CaseComment();
                        newComment1.CommentBody = 'Email received after 90 days so case did not re-open – new '+
                        newc.CaseNumber+' was created.'+
                         'New Case link: '+s4.replaceFirst('http:', 'https:'); // +' Email link:'+s3;
                        newComment1.IsPublished = False;
                        newComment1.ParentId = e.ParentId;
                        insert newComment1;
                        */
                    }catch (exception e1) {}
                }
            }
        }
        
        /*if( bulkEmails.size() >0){
                Messaging.reserveSingleEmailCapacity(trigger.size);
                Messaging.sendEmail(bulkEmails); 
                }*/
        
        if(lstcs.size()>0){
            system.debug('====lstcs====='+lstcs);
            try{
                Insert lstcs;
                system.debug('====lstcs===after insert=='+lstcs);
            }
            Catch(Exception ex){
            }
            for(case c : lstcs){
                for(emailmessage e : listObjEM){
                     if(e.ParentId == c.parentId || 
                     //Changed for SCTASK2986118 to create new case when email is sent to a closed FSS Technical Issue case after 7 days
                     (mapCase.containsKey(e.ParentId) && (mapCase.get(e.ParentId).recordtypeId==label.FSS_Tech_Issue_RT_ID || mapCase.get(e.ParentId).recordtypeId==label.AeroCustomerSupportRecTypeId) )){
                     //end of SCTASK2986118 
                        e.ParentId = c.id;
                        system.debug('====e====='+e);
                    }
                }
                system.debug('====lstcs=====');
            }
        }
        
        //Code modifying for ACT task deletion 
        if(TaskDelete.size()>0){
            delete TaskDelete;
        }
        //Code end modifying for ACT task deletion 
        if(clist.size()>0)
            casetoUpdate.addAll(clist);
        if(updateTaskIds1.size()>0){
            //"isclosed=false" condition is added in the query to prevent the reopened cases getting updated
            //cases=[Select Id,OwnerId,status ,OpenTask__c   from case where Id in:updateTaskIds1 and isClosed=false];
            //cases = mapcase.values();            
                //for(integer i=0;i<updateTaskIds1.size();i++){
            for(Id ids:updateTaskIds1){
                if(null!=mapcase.get(ids) && mapcase.get(ids).isClosed==false ){
                
                    String owner=mapcase.get(ids).OwnerId;
                    owner=owner.substring(0,3);
                    if(owner !='00G'){
                     
                        mapcase.get(ids).OpenTask__c=true;
                        casetoUpdate.add(mapcase.get(ids));
                    }
                }
            }                       
        }
        if(casetoUpdate.size()>0){
                try{
                    Upsert casetoUpdate;
                }catch(Exception e){
                }
        }
        for(integer i=0;i< clist.size();i++)
        { 
            Task t=new Task();
            t.whatId= clist[i].Id;
            t.subject='Email:'+clist[i].subject;
            TaskInsert.add(t);
            
            elist[i].ParentId=clist[i].id;
            elist[i].subject=clist[i].subject;
        }
        if(TaskInsert.size()>0)
            insert TaskInsert;
    }
}