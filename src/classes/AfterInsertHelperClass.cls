/*******************************************************************************
Name         : AfterInsertHelperClass
Created By   : Anusuya Murugiah
Company Name : NTT Data
Project      : <Phase-II>, <HealthCheck - Sprint 2> 
Created Date : 22 October 2013
Usages       : This Class is to consolidate the AfterInsert functionality which
               splited across in different triggers.  
Modification History  :
Date            Version No.     Modified by     Brief Description of Modification
23-Jan-2015     1.1             NTTDATA         INC000008227994 ATR RMU TOOL owner assignment 
31-Aug-2015     1.2             NTTDATA         Changes done for INC000008986324
30-Nov-2015     1.3             NTTDATA         INC000009169188 - BRD On Hold Consolidation
26-Feb-2015     1.4             NTTDATA         Changes added for MyMaintainer Portal Registration 2.0
22-Jul-2016     1.5             NTTDATA         INC000009995133 - Time to SBU Determined
12 Jan - 2017   1.6             TCS Run Team     INC000011154656-  Added the case extension functionality for Core recovery 
31-08-2018 We are not using this class so commening this code
*******************************************************************************/
public class AfterInsertHelperClass
{
    
    public static void afterInsertMethod(List<Case> listObjCaseNew,Map<ID,Case> oldMap){
         
         /*CaseClassForPublicMethods ccfpm= new CaseClassForPublicMethods();
         //ccfpm.plannedmeetingcreation(listObjCaseNew,oldMap);Commented for ticket INC000009687923
         //ccfpm.UpdateOppProposalCase(listObjCaseNew,oldMap);
         CaseOnHoldPublicMethods.CaseOnHoldMethod(listObjCaseNew,oldMap);
         system.debug('^^^^^^^^^^^^^^'+oldMap);
        /////////////////////////// RnOCaseOwnerAssignOnCreation ///////////////////////////
        Boolean bolChangesPresent = false;
        Set<id> setList = new Set<id>();
        /////////////////////////// RnOCaseOwnerAssignOnCreation ///////////////////////////
        ////////////////////////// sendEmailForMCOREToolRequest  Trigger After Insert /////////////
        Schema.DescribeSObjectResult CaseDesc = Schema.SObjectType.Case;
        Map<ID,Schema.RecordTypeInfo> CasertMapByName = CaseDesc.getRecordTypeInfosById();
        Schema.RecordTypeInfo casertName;
        
        List<Messaging.SingleEmailMessage> bulkEmails = new List<Messaging.SingleEmailMessage>(); 
            
        Set<id> acctidset = new Set<ID>();
        Set<id> contidset = new Set<ID>(); 
         // SF2SF
         Set<id> setList1 = new Set<id>();
         // SF2SF   
        List<Case_Extension__c> cextlist = new List<Case_Extension__c>(); // Added code for INC000008986324
        Set<id> cascextid = new Set<id>(); // Added code for INC000009995133
        Set<id> casidforExt = new Set<id>();// Added code for INC000008986324
        List<Case_Extension__c> sbucextlist = new List<Case_Extension__c>();//Added for INC000009995133
        Date dt = date.valueOf(label.Created_Date_31Aug2015); //  added code for INC000008986324
        Date Createddatee;
        // GTO Usability project Changes Start
        List<Case> onholdcaselist = new List<Case>();   
        Map<id,String> onholdids = new Map<ID,String>();
        List<Technical_Issue_Case_Extensions__c> caseextlist = new List<Technical_Issue_Case_Extensions__c>();
        for(Case objCs : listObjCaseNew )
        { 
            if(objCs.Status == 'On Hold' &&  objCs.Sub_Status__c =='Waiting for TCT' && objCs.Case_Record_Type__c == 'Technical Issue')         
            onholdids.put(objCs.id,'Waiting for TCT');
            else if(objCs.Status == 'On Hold' &&  objCs.Sub_Status__c =='Waiting for Customer Feedback' && objCs.Case_Record_Type__c == 'Technical Issue')         
            onholdids.put(objCs.id,'Waiting for Customer Feedback');
            else if(objCs.Status == 'On Hold' &&  objCs.Sub_Status__c =='Waiting for EPS/Engineering' && objCs.Case_Record_Type__c == 'Technical Issue')         
            onholdids.put(objCs.id,'Waiting for EPS/Engineering');
            else if(objCs.Status == 'On Hold' &&  objCs.Sub_Status__c =='Waiting for Honeywell Internal' && objCs.Case_Record_Type__c == 'Technical Issue')         
            onholdids.put(objCs.id,'Waiting for Honeywell Internal');
            
            // Added code for INC000008986324
            Createddatee = Date.valueOf(objCs.Createddate);
            if(Createddatee>dt && null!=objCs.Case_Record_Type__c && (objCs.Case_Record_Type__c == 'Orders' || objCs.Case_Record_Type__c == 'Quotes' || objCs.Case_Record_Type__c == 'Repair & Overhaul'  || objCs.Case_Record_Type__c == 'OEM/Spares'|| objCs.Case_Record_Type__c == 'Internal Escalations' || objCs.Case_Record_Type__c == 'OEM Quotes Orders' || objCs.Case_Record_Type__c == 'WEB Portal Registration'|| objCs.Case_Record_Type__c == 'Core Recovery')){
                casidforExt.add(objCs.id);
            // End code for INC000008986324
           
             
        }

 // Added code for INC000009995133 
            //Createddatee = Date.valueOf(objCs.Createddate);
            if(null!=objCs.Case_Record_Type__c && (objCs.recordtypeid == label.General_RT_ID || objCs.recordtypeid == label.OEM_Quotes_Orders_ID || objCs.recordtypeid == label.Orders_Rec_ID || objCs.recordtypeid == label.Returns_Recordtypeid || objCs.recordtypeid == label.Repair_Overhaul_RT_ID || objCs.recordtypeid == Label.OEM_Spares || objCs.recordtypeid == label.QuotesRecordID ||objCs.recordtypeid == Label.Core_Recovery_Record_ID ))
             cascextid.add(objCs.id);
           
            // End code for INC000009995133 
           
         // SF2SF - Start
            if(objCs.recordtypeid == label.TechPubs_RecordType_ID && objCs.HIPI_Opportunity__c == true){
                system.debug('inside techpubs if'+objCs.recordtypeid);
                setList1.add(objCs.id);
                system.debug('sf2sf'+setList1);
            }
            // SF2SF - End          
        }
         // SF2SF - Start
        if(setList1.size()>0) {
        system.debug('outside techpubs if'+setList1.size());
         CallServicetoCreateClass.classService(setList1);
         }
         // SF2SF - End
             
       
        if(!onholdids.isEmpty() || !casidforExt.isEmpty() || !cascextid.isEmpty()){
            onholdcaselist = [select id,CaseNumber,contactid,Contact.Name,Subject,accountid,Account.Type,Contact.Address_Line_1__c,Contact.Honeywell_ID__c,recordtypeid,SBU__c,Contact.Account_Name__c,Contact.Fax,Contact.Email,Contact.FirstName,Contact.Middle_Name__c,Contact.LastName,Sub_Status__c,Case_Record_Type__c,status,(select id,case_object__c,Waiting_for_TCT_Start_Time__c,Waiting_for_TCT_End_Time__c,Customer_Feedback_Hold_End_time__c,Customer_Feedback_Hold_Start_time__c,EPS_Engineering_Hold_End_time__c,EPS_Engineering_Hold_Start_Time__c,Honeywell_Internal_Hold_End_time__c,Honeywell_Internal_Hold_Start_time__c from case.Technical_Issue_Case_Extensions__r), (select id,Case_object__c,Date_Time_Stamp_of_SBU_Determined__c from Case_Extensions__r) from case where id in : onholdids.keySet() or id IN:casidforExt or id IN:cascextid ];
        }
        
        for(case cas:onholdcaselist){       
            if(cas.Case_Record_Type__c == 'Technical Issue'){
                Technical_Issue_Case_Extensions__c CasExt = new Technical_Issue_Case_Extensions__c();
                for(Technical_Issue_Case_Extensions__c ce : cas.Technical_Issue_Case_Extensions__r){
                    CasExt.id = ce.id; 
                }
                if(onholdids.get(cas.Id) == 'Waiting for TCT')
                CasExt.Waiting_for_TCT_Start_Time__c = system.now();
                else if(onholdids.get(cas.Id) == 'Waiting for Customer Feedback')
                    CasExt.Customer_Feedback_Hold_Start_time__c = system.now();
                 else if(onholdids.get(cas.Id) == 'Waiting for EPS/Engineering')
                    CasExt.EPS_Engineering_Hold_Start_Time__c = system.now();
                else if(onholdids.get(cas.Id) == 'Waiting for Honeywell Internal')
                    CasExt.Honeywell_Internal_Hold_Start_time__c = system.now();
                
                caseextlist.add(CasExt);  
            }
            // Added code for INC000008986324
             system.debug('Case Extension test PPO');
            if((Createddatee>dt && null!=cas.Case_Record_Type__c && (cas.Case_Record_Type__c == 'Orders' || cas.Case_Record_Type__c == 'Quotes' || cas.Case_Record_Type__c == 'Repair & Overhaul' || cas.Case_Record_Type__c == 'OEM/Spares' || cas.Case_Record_Type__c == 'Internal Escalations' || cas.Case_Record_Type__c == 'OEM Quotes Orders' || (cas.Case_Record_Type__c == 'WEB Portal Registration' && (cas.Subject!=null && cas.Subject.toUpperCase().contains('MYMAINTAINER')))) )|| (null!=cas.Case_Record_Type__c && (cas.recordtypeid == label.General_RT_ID || cas.recordtypeid == label.OEM_Quotes_Orders_ID || cas.recordtypeid == label.Orders_Rec_ID || cas.recordtypeid == label.Returns_Recordtypeid || cas.recordtypeid == label.Repair_Overhaul_RT_ID || cas.recordtypeid == label.QuotesRecordID ||cas.recordtypeid == Label.Core_Recovery_Record_ID )) ){
                system.debug('Case Extension');
                Case_Extension__c CasExt = new Case_Extension__c();
                CasExt.Name = cas.CaseNumber+'_Ext';
                if(cas.Case_Extensions__r!=null && cas.Case_Extensions__r.size()>0){
                    system.debug('---->If');
                    CasExt = cas.Case_Extensions__r;
                }else{
                    system.debug('---->else');
                    CasExt.Case_object__c = cas.id;                
                }
                cextlist.add(CasExt);
 if(cas.SBU__c!= null && cas.SBU__c!='Intercompany'){
                CasExt.Date_Time_Stamp_of_SBU_Determined__c=system.now();
                sbucextlist.add(CasExt);
                }
            }
            // End code for INC000008986324
        }       
        if(!caseextlist.isEmpty()){ 
            upsert caseextlist;
        }
        // GTO Usability project Changes End     
        // Added code for INC000008986324
        if(!cextlist.isEmpty()){ 
            upsert cextlist;
        }
        // End code for INC000008986324
if(!sbucextlist.isEmpty()){
        system.debug('---->sbucextlist1'+sbucextlist);
        upsert sbucextlist;
        system.debug('---->sbucextlist2'+sbucextlist);
        }
          
        for(Case objCs : listObjCaseNew )
        { 
            if(null!=objCs.accountid)
                acctidset.add(objCs.accountid);    
            if(null!=objCs.contactid)
                contidset.add(objCs.contactid);                  
            /////////////////////////// RnOCaseOwnerAssignOnCreation ///////////////////////////
            bolChangesPresent = true;                                
            setList.add(objCs.id);
            /////////////////////////// RnOCaseOwnerAssignOnCreation ///////////////////////////
        }
        
        Map<ID, Account> accountMapMain = new Map<ID, Account>();
        Map<ID, Contact> contList = new Map<ID, Contact>();
        if(acctidset.size()>0)
            accountMapMain = new Map<ID, Account>([Select id,owner.Email, owner.Name, CBT__c, CBT_Team__c,Strategic_Business_Unit__c,(select userid,user.name,user.Email,TeamMemberRole from AccountTeamMembers where (TeamMemberRole='Customer Business Manager (CBM)' or TeamMemberRole='Customer Business Director') ) from Account where id =:acctidset]);       

        // Changed as per bug : MCORE Admin not getting the mails == INC000008474436 ==
        if(contidset.size()>0)
            contList = new Map<ID, Contact>([select id,Account.Name,Phone_1__c,Honeywell_ID__c,Email,Address_Line_1__c,Address_Line_2__c,Address_Line_3__c,City_Name__c,State_Code__c,Name,Country_Name__c from contact where id=:contidset]);
        
        String[] mcoreAdmin=new String[]{};
        
        List<Contact> superAdmins=[select email from Contact where id in (select CRM_Contact_ID__c from Contact_Tool_Access__c where (Name='MCORE'  or Name = 'MCORE (Maintenance Cost Reduction)') and MCORE_IS_Super_Admin__c=true)];
        for(Contact conts : superAdmins)
        {
            mcoreAdmin.add(conts.email);
        }
             
        Account acctTemp = new Account();
        Contact contTemp = new Contact();
        List<AccountTeamMember> accTeam = new List<AccountTeamMember>();    
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();   
        //Code added for SR# INC000008227994 ATR RMU TOOL Start
        String strOwnerName ='';
        List<String> atrToAddresses=new List<String>();
        //Code added for SR# INC000008227994 ATR RMU TOOL End
        for(Case objCase : listObjCaseNew ){               
            casertName = CasertMapByName.get(objCase.recordtypeid);                            
            acctTemp = accountMapMain.get(objCase.accountid);
            contTemp = contList.get(objCase.contactid);
            if(Trigger.isInsert){      
                 if(objCase !=null && casertName.getName().equals(ConstantsForCaseWFDelegate.RT_WEB_PORTAL_REG) 
                 && objCase.Tool_Name__c!=null && objCase.Tool_Name__c!='' && (objCase.Tool_Name__c== ConstantsForCaseWFDelegate.MCORE 
                 || objCase.Tool_Name__c==ConstantsForCaseWFDelegate.MCORE_MAINTENANCE_COST_REDUCTION )&& objCase.status=='Open' )
                {                       
                    List<String> accOwners=new List<String>();    
                    List<String> ccAddresses=new List<String>();
                    //Added by Kapil for Account Owner Code Change
                    if(null != acctTemp){
                        if(acctTemp.owner.Name == ConstantsForCaseWFDelegate.OWNER_NM_SALECUSTMAST  
                        && acctTemp.Strategic_Business_Unit__c == ConstantsForCaseWFDelegate.STR_BUSIN_UNT_ATR  
                        && acctTemp.CBT__c == ConstantsForCaseWFDelegate.CBT_AIRLINES )
                        {
                            if(acctTemp.CBT_Team__c == ConstantsForCaseWFDelegate.CBT_TEAM_AMERICAS ){
                                accOwners.add('rocky.advani@honeywell.com');
                            }else if(acctTemp.CBT_Team__c == ConstantsForCaseWFDelegate.CBT_EMEAI_ATR ){
                                accOwners.add('dan.wisniewski@honeywell.com');
                            }else if(acctTemp.CBT_Team__c == ConstantsForCaseWFDelegate.CBT_APAC_ATR ) {
                                accOwners.add('joel.miranda@honeywell.com');
                            }
                            
                        }
                        else {
                            accOwners.add(acctTemp.owner.Email);
                        }
                    }
                    //Added by Kapil for Account Owner Code Change
                    if(null != accountMapMain.get(objCase.accountid))
                    accTeam = accountMapMain.get(objCase.accountid).AccountTeamMembers;
                    if(null != contTemp){                            
                        if(contTemp.Email!=null && contTemp.Email.toUpperCase().contains('HONEYWELL.COM')){
                            accOwners.clear();
                            accOwners.addAll(mcoreAdmin);
                        }else{
                            if(accTeam!=null){
                                for(AccountTeamMember atm: accTeam){
                                    ccAddresses.add(atm.user.Email);    
                                }
                            }
                            ccAddresses.addAll(mcoreAdmin);                                   
                        } 
                        mail.setToAddresses(accOwners);
                        mail.setCcAddresses(ccAddresses);                       
                        if(accOwners!=null && accOwners.size()>0){
                            String addr='';
                            if(contTemp.Address_Line_1__c!=null){
                                addr=addr+contTemp.Address_Line_1__c+'<BR/>';
                            }
                            if(contTemp.Address_Line_2__c!=null){
                                addr=addr+contTemp.Address_Line_2__c+'<BR/>';
                            }
                            if(contTemp.Address_Line_3__c!=null){
                                addr=addr+contTemp.Address_Line_3__c+'<BR/>';
                            }
                            if(contTemp.City_Name__c!=null){
                                addr=addr+contTemp.City_Name__c+'<BR/>';
                            }
                            if(contTemp.State_Code__c!=null){
                                addr=addr+contTemp.State_Code__c+'<BR/>';
                            }
                            if(contTemp.Country_Name__c!=null){
                                addr=addr+contTemp.Country_Name__c+'<BR/>';
                            }
                            String serverURL = URL.getSalesforceBaseUrl().toExternalForm();                        
                            String subject='Request for MCORE Tool Access';
                            String body='<html><body><table>'+
                            '<tr><td colspan="2"> Dear Administrator,   </td></tr>'+
                            '<tr><td colspan="2"> The following SFDC Registration Case has been assigned to you:   </td></tr>'+
                            '<tr><td colspan="2">'+objCase.CaseNumber+'</td></tr>'+ 
                            '<tr><td colspan="2"><U>Below are the details of the request:</U></td></tr>'+
                            '<tr><td><b>Tool Name :</b></td><td>'+objCase.Tool_Name__c+'</td></tr>'+ 
                            '<tr><td><b>Honeywell ID :</b></td><td>'+contTemp.Honeywell_ID__c+'</td></tr>'+ 
                            '<tr><td><b>Contact Name :</b></td><td>'+contTemp.Name+'</td></tr>'+ 
                            '<tr><td><b>Email Address :</b></td><td>'+contTemp.Email+'</td></tr>'+ 
                            '<tr><td><b>Company Name :</b></td><td>'+contTemp.Account.Name+'</td></tr>'+ 
                            '<tr><td><b>Contact Phone Number :</b></td><td>'+contTemp.Phone_1__c+'</td></tr>'+                    
                            '<tr><td valign="top"><b>Contact Address :</b></td><td>'+addr+'</td></tr>'+                    
                            '<tr><td colspan="2">Click on the link to access the case:</td></tr>'+
                            '<tr><td colspan="2">'+serverURL+'/'+objCase.Id+'</td></tr>'+ 
                            '<tr><td colspan="2">Thank You,</td></tr>'+ 
                            '<tr><td colspan="2">Self service registration team</td></tr>';        
                            body=body+'</table></body></html>';       
                            mail.setSubject(subject);
                            mail.setHtmlBody(body); 
                            bulkEmails.add(mail);                               
                        }
                    }
                } 
                 // Added code for SR INC000008696104 autoclose starts
            system.debug('auto-close before entry');
             
            if(objCase.Contactid!=null && (objCase.Origin!=null && (objCase.Origin =='Email-Quotes' || objCase.Origin =='Email-Orders' || objCase.Origin =='Email-Order Changes' 
             || objCase.Origin =='Email-Order Status') && objCase.Origin.contains('Email')) && objCase.SBU__c=='D&S' && objCase.Service_Level__c=='Refer to Network' && objCase.PFECN__c== '')
                {
                    system.debug('PFECN Field:'+objCase.PFECN__c);
                    //objCase.OwnerId=label.AERODEFAULTUSER;
                    
                    // The email template ID used for the email
                    //Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                    mail.setTargetObjectId(objCase.contactId);
                    mail.setWhatId(objCase.ID);                        
                    mail.setBccSender(false);
                    mail.setUseSignature(false);
                    mail.setOrgWideEmailAddressId(label.Yourresponse_OrgId);
                    mail.setSaveAsActivity(false); 
                    mail.setOrgWideEmailAddressId(label.Yourresponse_OrgId);
                    mail.setTemplateId(label.D_S_Refer_to_Network);
                    bulkEmails.add(mail);
                                       
                }    
        // // Added code for SR INC000008696104 autoclose ends
        
                //Code added for SR# INC000008227994 ATR RMU TOOL Start
                else if(objCase.recordtypeid==label.ATR_Case_Recordtype && objCase.createdbyid==label.ATR_API_User_id)
                {
                    //accTeam = accountMapMain.get(objCase.accountid).AccountTeamMembers;
                    */
                    //---Don't remove below comments start---
                    /*
                    if(accTeam.size()>0){
                        strOwnerName = accTeam[0].user.name;
                        for(AccountTeamMember atm: accTeam){
                            if(atm.TeamMemberRole=='Customer Business Manager (CBM)'){                                
                                atrToAddresses.add(atm.user.Email);
                            }   
                        }
                    }
                    else{
                        //objCase.ownerid=label.ATR_Default_Owner;
                        strOwnerName = 'Carrie Kendrick';
                        atrToAddresses.add('carrie.kendrick@honeywell.com');                 
                    } 
                    */                   
                    // Comment this while moving to Prod                    
                    /*atrToAddresses.add('anusuya.murugiah@nttdata.com');
                    atrToAddresses.add('Adam.Olshansky@Honeywell.com');
                    */
                    //---Don't remove below comments end---
                    // Comment this while moving to Prod
                    /*
                    Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                    strOwnerName = 'Todd Van Sooy';      //changed value from Carrie Kendrick to Todd Van Sooy for Incident Ticket INC000010071115
                    atrToAddresses.add(label.ATR_Default_Owner_emailid);
                    String subject='Case assigned to you, Please review';
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
                                'Case is assigned to you, please review.'+
                                '<br><br>'+                
                                    '<table width=100% class="tablewiththreesideborder" cellspacing=0 cellpadding=0>'+
                                   ' <tr> <td height=25 colspan=2 ><br></td></tr>'+                
                                   ' <tr> <td height=25 colspan=2 bgcolor="#eeeeee"><b>Case Details</b></td></tr>'+
                                   ' <tr> <td height=30><b>Case Number</b> </td>'+                                                              
                                  '  <td> <a href='+URL.getSalesforceBaseUrl().toExternalForm()+'/'+objCase.Id+'>'+ObjCase.caseNumber+'</a></td> </tr>'+                                                 
                                 '   </table> '+           
                                '<br><br>'+                
                                'Thank you,<br>Honeywell Flight Support Services'+                
                                '<br><br></td></tr></table>';        
                    body=body+'</table></body></html>';       
                    message.setSubject(subject);
                    message.setHtmlBody(body);                                    
                    if(atrToAddresses.size()>0)
                        message.setToAddresses(atrToAddresses);                
                    message.setBccSender(false);
                    message.setUseSignature(false);
                    message.setOrgWideEmailAddressId(label.Yourresponse_OrgId);
                    message.setSaveAsActivity(false); 
                    bulkEmails.add(message);
                } 
                //Code added for SR# INC000008227994 ATR RMU TOOL End
                
            }            
        } 
        
        if(!(Test.isRunningTest()))
        {
            Messaging.reserveSingleEmailCapacity(trigger.size);
            Messaging.sendEmail(bulkEmails);    
        }    
        
        ////////////////////////// sendEmailForMCOREToolRequest  Trigger After Insert /////////////
        // Case_creatingcaselineitem //         
        list<String> nsn,PN,nsnPN =New list<string>();
        list<String> nsnall =New list<string>();
        list<String> pnall =New list<string>();
        list<String> lisnclt=New list<string>();
        list<String> nsn2=New list<string>();
        list<String> pn2=New list<string>();
        Map<String,Id> Mapofcaseid=New Map<String,Id>();
        list<Case_Line_Item__c> insertlistNSN = New list<Case_Line_Item__c>();
        list<Case> cas,casupdate= New list<case>();
        set<Id> casid=New set<Id>();
            
        for(case cs:listObjCaseNew){
            if(cs.NSN__c!=null&&cs.NSN__c!=''&& cs.Recordtypeid==label.D_S_Clear_House_RecordTypeId_Case){
                nsn=(cs.NSN__c).split(';');
            }else{nsn=null;}

            if(nsn!=null){
                for(string n:nsn){
                    n=n+'\\\\'+cs.id;
                    nsn2.add(n);
                }
            }

            if(cs.Part_Number__c !=null&& cs.Part_Number__c!=''&& cs.Recordtypeid==label.D_S_Clear_House_RecordTypeId_Case){
                PN=(cs.Part_Number__c).split(';');
            }else{PN=null;}

            if(PN!=null){
                for(string p:PN){
                    p=p+'\\\\'+cs.id;
                    PN2.add(p);
                }
            }

            if(nsn2 != null){
                nsnall.addall(nsn2);
                nsnPN.addall(nsn2);
            }

            if(PN2!=null){
                Pnall.addall(PN2);
                nsnPN.addall(PN2);
            }

            for(String nclt:nsnPN){
                Mapofcaseid.put(nclt,cs.id);
            }
            
            nsnPN.clear();
            nsn2.clear();
            PN2.clear();
            casid.add(cs.id);
        }

        if(nsnall!=null)
            for(String nclt:nsnall){
                Case_Line_Item__c clt= new Case_Line_Item__c();
                if(nclt!=''){
                    lisnclt=nclt.split('\\\\',2);
                    clt.NSN__c=lisnclt[0];
                    clt.recordtypeid=label.D_S_Clear_House_RecordTypeId_CaseLineItem;
                    clt.Case_Number__c=Mapofcaseid.get(nclt);
                    insertlistNSN.add(clt);
                    lisnclt.clear();
                }
            }
            
        if(PNall!=null)
            for(String nclt:Pnall){
                Case_Line_Item__c clt= new Case_Line_Item__c();
                if(nclt!=''){
                    lisnclt=nclt.split('\\\\',2);
                    clt.Part_Number__c=lisnclt[0];
                    clt.recordtypeid=label.D_S_Clear_House_RecordTypeId_CaseLineItem;
                    clt.Case_Number__c=Mapofcaseid.get(nclt);
                    insertlistNSN.add(clt);
                    lisnclt.clear();
                }
            }

        //if(insertlistNSN.size()>0)
        //insert insertlistNSN;
        
        // Case_creatingcaselineitem //
        
        /////////////////////////// sendcaseemail ///////////////////////////
        CaseClassForPublicMethods objForSendCaseEmail = new CaseClassForPublicMethods();
        //objForSendCaseEmail.sendCaseEmailMethod(listObjCaseNew,oldMap,'Insert');
        //objForSendCaseEmail.ACSMSendCaseEmailMethod(listObjCaseNew,oldMap,'Insert');
        /////////////////////////// sendcaseemail ///////////////////////////
        
        /////////////////////////// RnOCaseOwnerAssignOnCreation ///////////////////////////         
        if(bolChangesPresent)
        {                
            System.debug('Inside Afterinserthelperclass###'+setList);
            ROAssignOwnerNewCase.updateCaseOwner(setList);                                
        }
        /////////////////////////// RnOCaseOwnerAssignOnCreation ///////////////////////////
        */
    }
    
}