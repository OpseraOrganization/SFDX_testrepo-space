/*******************************************************************************
Name         : OppBeforeUpdateHelperClass
Created By   : Anusuya Murugiah 310
Company Name : NTT Data
Project      : <Phase-II>, <HealthCheck - Sprint3> 
Created Date : 26 December 2013
Usages       : This Class is to consolidate the BeforeUpdate functionality of 
opportunity which splited across in different triggers.  
Version      :  6 April 2016 - TCS Run Team - INC000009918063 - Add the picklist value to Solution type field  
Version      :  28th March 2017 - HoneyWell Aero team - Commenting out the code related to ATR_Probability__c field update and validation  
Version      :  Aug 28th 2017 - Added code to populate Lead Creator EID & Country fields for INC000012235981
*******************************************************************************/
public class OppBeforeUpdateHelperClass
{
    public static void beforeupdateMethod(List<Opportunity> listObjOppNew,Map<ID,Opportunity> oldMap)
    {
        /* Added for fixing the Salechanel, SubchannelUpdate issue*/
        
        set<id> accountIdSet = new set<id>();
        for(Opportunity opp:listObjOppNew){
            if(opp.StageName == 'Closed Cancelled'){
                opp.Active__c = false;
            }
            accountIdSet.add(opp.AccountId);
        }
        Map<id,Account> accountMap = new Map<id,Account>([select id,Sales_Channel__c,Sc1__c,Sc2__c from Account where id in :accountIdSet]);
         
        system.debug('^^^^^^^^^^^^^^'+oldMap);
        
        /*********************OpportunityRequiredFields Trigger Before update ***********/
        String profileId;
        profileId=Userinfo.getprofileId();
        /*********************Opportunity_CheckStatus Trigger Before update ***********/
        List<Opportunity> oppList=new List <Opportunity>();
        /*********************Opportunity_SendAccountOpener_Discretionary Trigger Before update ***********/
        list<String> OpportunitiesId=new List<String>();
        Discretionary_Line_Item_Approval_History__c aprec;
        List<Discretionary_Line_Item_Approval_History__c> ApproveobjRec=new List<Discretionary_Line_Item_Approval_History__c>();
        Integer j=0;
        /*********************Opportunity_PlannedMeeting Trigger Before Insert ***********/
        Map<Id,Opportunity> oppMap = new Map<Id,Opportunity>(); 
        Map<Id,Opportunity> oppMap1 = new Map<Id,Opportunity>(); 
        
        /*********************Opportunity_Validation Trigger Before update ***********/
        set<id> oppid1=new set<id>();
        date startdate=null;
        map<id,Date> stardatemap= new map<id,Date>();
        map<id,date> enddatemap=new map<id,Date>();
        map<id,opportunitylineitem> longduration= new map<id,opportunitylineitem>();
        date enddate=null;
        list<opportunitylineitem> oppline=new list<opportunitylineitem>();       
        set<id> parentid=new set<id>();
        set<id> parentid1=new set<id>();
        Decimal licensetotal=0,RMUtotal=0,Servicestotal=0,Engtotal=0,ROtotal=0,Retrototal=0,SAMtotal=0,OEMtotal=0,totalpricenet=0,sumEstimatedValue=0,totalpricenet1=0;
        Decimal licensetotal1=0,othertotal=0,bfetotal=0,directtotal=0,Equipmenttotal=0,repairtotal=0,RMUtotal1=0,spareslrutotal=0,sparesrepairtotal=0;
        set<id> oppid=new set<id>();
        List<Opportunity> OppList1 = new List<Opportunity>();
        OppList1 = [select id,IsWon,StageName,Win_Loss_Proposal_Amount__c,Win_Loss_Amount__c,Parent_Opportunity__c,Total_Win_Loss_Proposal_Amount__c,Total_Win_Loss_Amount__c from Opportunity where Parent_Opportunity__c IN:listObjOppNew];
        
        Boolean blnDSprofilechk = false;
        if(profileId != label.D_S_Sales_Spiral_API_User_Label && profileId != label.D_S_Sales_API_User_Profile && profileId != label.D_S_Sales_API_Discretionary_User_Profile)
        {
            blnDSprofilechk = true;
        }
        
        List<Contact> con = new List<Contact>();
        Id UID = userinfo.getUserid();
        Id PID = userinfo.getProfileid();
        List<User> usr=new List<User>();
        if (Trigger.Isupdate && PID == Label.D_S_Partner_ProfileId) { 
            usr = [Select id,name,ContactId,contact.accountid,contact.account.name from User where id =:UID and contactId != null limit 1];
            /*if(usr.contactId != null) {
con = [select id,accountid,account.Name from contact where id =:usr.ContactId];
}*/
        }
        
        
        //SF2SF changes
        
        List<Opportunity> draftplafOppToUpdate = new List<Opportunity>();
        Date closeDate = [Select EndDate From Period Where type = 'Quarter' and StartDate = THIS_FISCAL_QUARTER].EndDate;
        decimal draft1;
        
        //SF2SF changes ends
        for(Opportunity opp: listObjOppNew)
        {
            //SF2SF changes added for draft priority flag starts - INC000010387803 
            if((opp.CUSTOMER_LICENSE_NEED_DATE__c != null) && (opp.Record_Type_Name__c == 'M&PM SIM Licensing') ) 
            {
                system.debug('lastmodifieddate:'+opp.lastmodifieddate);
                system.debug('Customer Last Modified Date:'+oldmap.get(opp.id).Customer_Last_Modified_Date__c);
                if(opp.Customer_Last_Modified_Date__c != opp.lastmodifieddate)
                {
                    opp.Customer_Last_Modified_Date__c = opp.lastmodifieddate;
                }
                system.debug('Customer Last Modified Date1:'+opp.Customer_Last_Modified_Date__c);
                Date closeDate1=opp.CUSTOMER_LICENSE_NEED_DATE__c;
                opp.Current_end_of_fiscal_quarter_date1__c=closedate;
                system.debug('closeDate1----->'+ closeDate1);
                integer diff;
                Datetime lastmodified = oldmap.get(opp.id).LastModifiedDate;
                system.debug('LastModifiedDate----->'+ lastmodified);
                system.debug('Oldmap+LastModifiedDate----->'+ oldmap.get(opp.id).LastModifiedDate);
                if(closedate1<closedate && (opp.CUSTOMER_LICENSE_NEED_DATE__c != oldmap.get(opp.id).CUSTOMER_LICENSE_NEED_DATE__c || opp.LastModifiedDate != oldmap.get(opp.id).Customer_Last_Modified_Date__c))
                {
                    diff=closedate1.daysbetween(closedate);
                }
                else if(closedate1>closedate && (opp.CUSTOMER_LICENSE_NEED_DATE__c != oldmap.get(opp.id).CUSTOMER_LICENSE_NEED_DATE__c ||  opp.LastModifiedDate != oldmap.get(opp.id).Customer_Last_Modified_Date__c))
                {
                    system.debug('insideif2----->'+closedate1);
                    diff=closedate.daysbetween(closedate1);  
                }
                system.debug('diff----->'+diff);                
                decimal draft;
                if(diff!=null){
                    draft=((90-(diff))/30);
                    system.debug('draft-----'+draft);
                }
                if(draft!=null)
                    draft1=(draft+3).setScale(2);
                system.debug('draft1-----'+draft1);
                Opportunity tempopp = new opportunity(id=opp.id);
                draftplafOppToUpdate.add(tempopp);  
            }
            // Added for INC000012235981 to update Lead Creator EID & Country fields
            /*system.debug('======>outside IF: '+opp.Lead_Creator__c);
            if(null!=opp.Lead_Creator__c){
                system.debug('======>Inside IF');
                system.debug('======>Inside IF 1: '+opp.Lead_Creator__r.EmployeeNumber);
                if(null!=opp.Lead_Creator__r.EmployeeNumber){
                    system.debug('======>Inside IF 2: '+opp.Lead_Creator__r.EmployeeNumber);
                    opp.Lead_Creator_EID__c = opp.Lead_Creator__r.EmployeeNumber;
                }
                else
                    opp.Lead_Creator_EID__c = '';
                system.debug('======>Inside IF 3: '+opp.Lead_Creator__r.Country__c);
                if(null!=opp.Lead_Creator__r.Country__c){
                    system.debug('======>Inside IF 4: '+opp.Lead_Creator__r.Country__c);
                    opp.Lead_Creator_Country__c = opp.Lead_Creator__r.Country__c;
                }
                else
                    opp.Lead_Creator_Country__c = '';
            }else{
                system.debug('======>Inside else');
                opp.Lead_Creator_EID__c = '';
                opp.Lead_Creator_Country__c = '';
            }*/
            // End for INC000012235981 to update Lead Creator EID & Country fields
            //Added by: Chiranjeevi, M&PM Sim Licensing Phase 2 
            if(opp.Record_Type_Name__c == 'M&PM SIM Licensing'){
                if(opp.HIPI_CONTRACT_NUMBER__c != null){
                    opp.Request_Contract_Number__c = false;
                }
                /*
                if(oldMap.get(opp.id).LicenseDraft__c != opp.LicenseDraft__c && opp.LicenseDraft__c == True)
                {               
                    if(opp.Record_Data_Owner__c == Null)
                    {
                        opp.Engineer_Manager_Review__c = True;
                        opp.Engineer_Manager_Review_Date__c =  date.valueof(system.today());                                                               
                    }
                }
                */                
                if(opp.Record_Data_Owner__c == Null){
                    opp.Appendix_Review_Engineer_Name__c='';
                }
                if(opp.LicenseDraft__c == False){
                    opp.License_Draft__c = Null;
                }
                if(opp.Final_Review__c == False){
                    opp.License_Review__c = Null;
                }
                if(opp.Engineer_Manager_Review__c == False){
                    opp.Engineer_Manager_Review_Date__c = Null;
                }
                if(opp.WorkbookComplete__c == False){
                    opp.Workbook_Complete__c = Null;
                }
                if(opp.Account_manager_review__c == False){
                    opp.Account_manager_review_Date__c = Null;
                }
                if(opp.Revenue_Recognized__c == False){
                    opp.Revenue_Recognized_Date__c = Null;                  
                }
                if(opp.InvoiceRequested__c == False ){
                    opp.Invoice_Requested_date__c=Null;
                }  
                /*if(opp.Workstop_Issue_Cleared__c == False ){
                    opp.Workstop_Issue_Cleared_date__c=Null;
                }   
                    
                if(opp.InvoiceRequested__c==true){
                    if(opp.Revenue_Recognition_Expected__c != null){
                        if(opp.Revenue_Recognized__c == False){
                            opp.Process_Step1__c = '20 - Revenue Recognition Hold';
                        }else if(((opp.Deal_Phase__c == 'Closed/Won')||(opp.Deal_Phase__c == 'Closed Won')) && (opp.Revenue_Recognized__c == true)){
                            opp.Process_Step1__c = '12 - DONE';
                        }
                    } 
                }   */  
            }             
            
            //SF2SF changes added for draft priority flag ends - INC000010387803 
            /********** M&PM Sim Licensing Phase2 Process step Formula Starts **************/
            /* Added By: Chiranjeevi Gogulakonda,NTT DATA, M&PM phase2 Changes*/
            /*if(opp.Record_Type_Name__c == 'M&PM SIM Licensing'){ 
                    if(opp.Workstop_Issue__c != null && opp.Workstop_Issue_Cleared__c==false){
                        opp.Process_Step1__c = '0 - HOLD';
                    }else if(((opp.Deal_Phase__c == 'Closed/Won')||(opp.Deal_Phase__c == 'Closed Won')||(opp.Deal_Phase__c == 'Closed Lost')) && opp.InvoiceRequested__c==false){
                        opp.Process_Step1__c='10 - Ship / Invoice';
                    }else if(((opp.Deal_Phase__c == 'Closed/Won')||(opp.Deal_Phase__c == 'Closed Won')||(opp.Deal_Phase__c == 'Closed Lost')) && (opp.Revenue_Recognized__c == true)){
                        opp.Process_Step1__c='12 - DONE';
                    }else if(opp.Revenue_Recognition_Expected__c != null && opp.Revenue_Recognized__c==false && opp.InvoiceRequested__c==true){
                        opp.Process_Step1__c='20 - Revenue Recognition Hold';
                    }else if((opp.Process_Step1__c =='20 - Revenue Recognition Hold') && ((opp.Deal_Phase__c == 'Closed/Won')||(opp.Deal_Phase__c == 'Closed Won')) && (opp.Revenue_Recognized__c == true)){
                        opp.Process_Step1__c='12 - DONE';
                    }else if(opp.Data_Shipped_ECM__c != null){
                        opp.Process_Step1__c = '11 - Request Invoice';
                    }else if(opp.License_Signed_Lic_CoE__c != null){
                        opp.Process_Step1__c = '10 - Ship / Invoice';
                    }else if(opp.License_Back_From_Customer__c != null){
                        opp.Process_Step1__c = '09 - Lic CoE Signature';
                    }else if(opp.License_to_Customer__c != null){
                        opp.Process_Step1__c = '08 - Customer';
                    }else if(opp.Final_Review__c == true){
                        opp.Process_Step1__c = '07 - Send to Customer';
                    }else if(opp.License_Review_Issue__c != null){
                        opp.Process_Step1__c = '06.5 - Review Issue';
                    }else if(opp.Account_manager_review__c == true){
                        opp.Process_Step1__c = '06 - Final Review';
                    }else if(opp.Engineer_Manager_Review__c == true){
                        opp.Process_Step1__c = '05 - Acct manager license review';
                    }else if(opp.LicenseDraft__c == true && opp.Record_Data_Owner__c !=null){
                        opp.Process_Step1__c = '04 - Appendix Review';
                    }else if(opp.LicenseDraft__c == true && opp.Account_Contact_Name__c !=null){
                        opp.Process_Step1__c = '05 - Acct manager license review';
                    }else if(opp.WorkbookComplete__c == true){
                        opp.Process_Step1__c = '03 - Draft License';
                    }else if(opp.PO_Received__c !=null){
                        opp.Process_Step1__c = '02 - Acct manager workbook';
                    }else{
                        opp.Process_Step1__c = '01 - Acct manager negotiating';
                    }
            }*/
            
            /********** M&PM Sim Licensing Phase2 Process step Formula Ends ****************/
            
            /*********************OpportunityRequiredFields Trigger Before update ***********/
            if (TriggerInactive.TestOppRequiredFields == true && blnDSprofilechk==true)
            {
                if (opp.StageName == oldMap.get(opp.id).StageName && (opp.Record_Type_Name__C == 'D&S Complex' || opp.Record_Type_Name__C == 'Focus' || opp.Record_Type_Name__C == 'Key' || opp.Record_Type_Name__C == 'D&S Standard'))
                {
                    system.debug('opp.StageName :'+opp.StageName);   
                    if(opp.StageName == 'Cultivate' || opp.StageName == 'Propose')
                    {
                        
                        if(opp.Certification_Requirements__c=='FAR 15 Tina')
                        {
                            if(opp.RFP_Expected_Date__c ==null){             
                                opp.RFP_Expected_Date__c.addError('You must enter a value');                                                                                
                            }if(opp.Proposal_Complexity_Description__c==null && opp.Proposal_Complexity__c != null){             
                                opp.Proposal_Complexity_Description__c.addError('You must enter a value');                                                                                 
                            }
                        }
                        else
                        { 
                            if(opp.RFP_Expected_Date__c ==null){             
                                opp.RFP_Expected_Date__c.addError('You must enter a value');                                                                                  
                            }if(opp.Proposal_Complexity_Description__c==null && opp.Proposal_Complexity__c != null){             
                                opp.Proposal_Complexity_Description__c.addError('You must enter a value');
                            }if(opp.Certification_Requirements__c== null){
                                opp.Certification_Requirements__c.addError('You must enter a value');
                            }
                        }
                    }                   
                    if(opp.StageName == 'Offer/Negotiate/Close')
                    {
                        if(opp.Certification_Requirements__c=='FAR 15 Tina')
                        {                           
                            if(opp.RFP_Expected_Date__c ==null){             
                                opp.RFP_Expected_Date__c.addError('You must enter a value');                                                                                                                                                                                                                    
                            }if(opp.Proposal_Complexity_Description__c==null && opp.Proposal_Complexity__c != null){             
                                opp.Proposal_Complexity_Description__c.addError('You must enter a value');                                                                                 
                            }                                                                                 
                            
                        }
                        else
                        {
                            if(opp.RFP_Expected_Date__c ==null){             
                                opp.RFP_Expected_Date__c.addError('You must enter a value');                                                                                                                                                                 
                            }if(opp.Proposal_Complexity_Description__c==null && opp.Proposal_Complexity__c != null){             
                                opp.Proposal_Complexity_Description__c.addError('You must enter a value');
                            }if(opp.Certification_Requirements__c== null){
                                opp.Certification_Requirements__c.addError('You must enter a value');
                            }                                                                                 
                            
                        }
                    }  
                }
                /****************************Added for D&S Partner Validation Starts************************/
                if(PID == Label.D_S_Partner_ProfileId) 
                {
                    system.debug('%%%%%%%%%%%Entered PID%%%%%%%%%%%%');
                    if(opp.AccountId != null && usr[0].contactid != null && Opp.AccountId != usr[0].contact.AccountId) 
                    {
                        system.debug('%%%%%%%%%%%Entered Loop 2%%%%%%%%%%%%');
                        opp.AccountId.addError('You Cannot choose an Account other than'+ usr[0].contact.Account.Name);
                    }
                    if(Opp.SBU__c != 'D&S') 
                    {
                        system.debug('%%%%%%%%%%%Entered Loop 3%%%%%%%%%%%%');
                        opp.SBU__c.addError('SBU needs to be D&S');
                    }
                }
                /****************************Added for D&S Partner Validation Starts************************/               
            }
            /*********************Opportunity_CheckStatus Trigger Before update ***********/
            if(opp.StageName !=oldMap.get(opp.id).StageName && (opp.Record_Type_Name__c == 'Focus'|| opp.Record_Type_Name__c == 'Key' ||opp.Record_Type_Name__c == 'D&S Standard' || opp.Record_Type_Name__c == 'D&S PrePriced' || opp.Record_Type_Name__c == 'D&S Run Rate' || opp.Record_Type_Name__c == 'D&S Complex'))
            {
                oppList.add(opp);
            }
            /*********************Opportunity_SendAccountOpener_Discretionary Trigger Before update ***********/
            //for(Opportunity opp1: OldOpps)
            //{
            if (oldMap.get(opp.id).RFP_Request_Date__c ==null && opp.RFP_Request_Date__c!=null)
            {
                OpportunitiesId.add(opp.Id);
            }
            j++;                
            /*********************Opportunity_UpdateRecordType_SBU Trigger Before update ***********/
            if(opp.Record_Type_Name__c != oldMap.get(opp.id).Record_Type_Name__c)
            {
                opp.Opportunity_Type__c = opp.Record_Type_Name__c;
            }
            //}
            
            // Added code for INC000006769488
            if(opp.Tech_Sales__c == 'AT' && opp.SBUFormulae__c == 'D&S' || Test.isRunningTest()){
                
                opp.CBT_Tier_2__c = opp.Account_CBT__c;
                opp.CBT_Team_Tier_3__c = opp.Account_CBT_Team__c;
                opp.CBT_Directorate__c = opp.Account_CBT_Directorate__c;
                if(accountMap.get(opp.AccountId) != null){
                    Account acctRec = accountMap.get(opp.AccountId);
                    opp.Sales_Channel__c = acctRec.Sales_Channel__c;
                    opp.SC1__c = acctRec.SC1__c;
                    opp.SC2__c = acctRec.SC2__c;
                }
            }
            // End code for INC000006769488
            
            /*********************Opportunity_Validation Trigger Before update ***********/
            parentid.add(opp.id); 
            
            if(opp.ATR_Probability__c!=oldMap.get(opp.id).ATR_Probability__c)
            {
                parentid1.add(opp.id); 
            }
            if(opp.Revenue_Type__c!=oldMap.get(opp.id).Revenue_Type__c || opp.Solution_Type__c!= oldMap.get(opp.id).Solution_Type__c)
            {
                oppid.add(opp.id);
            }
            if( opp.Revenue_End_Date__c!=null && opp.Revenue_Start_Date__c!=null && opp.SBU__c != 'D&S' || Test.isRunningTest()) 
            {
                oppid1.add(opp.id);
            } 
            
            /*********************Opportunity_PlannedMeeting Trigger Before Insert ***********/
            if(opp.Planned_Meeting__C !=null) 
            {
                if (oppMap1.containsKey(opp.Planned_Meeting__c)) 
                {
                    opp.Planned_Meeting__c.addError('Please select another Planned meeting');
                } 
                else 
                {
                    oppMap.put(opp.Planned_Meeting__c,opp);
                }
            } 
            /*********************Opportunity_PlannedMeeting Trigger Before Insert ***********/                        
        }   
        
        //SF2SF changes added for draft priority flag starts
        if(draftplafOppToUpdate.size()>0)
        {
            try
            {
                draftplafOppToUpdate[0].Current_end_of_fiscal_quarter_date1__c=closedate;
                if(string.valueof(draft1) != null)
                {
                    draftplafOppToUpdate[0].Draft_Priority_Flag__c=string.valueof(draft1);
                    system.debug('draftflag----->111'+draftplafOppToUpdate[0].Draft_Priority_Flag__c);               
                }
                else
                {
                    draftplafOppToUpdate[0].Draft_Priority_Flag__c='';
                }
            }
            catch(Exception e)
            {
                System.debug('Exception in updating opportunity in OppAfterUpdateHelperclass'+e);
            }
        } 
        //SF2SF changes added for draft priority flag ends
        
        /********************* Opportunity_Provideaccess - Start ***/        
        List<Opportunity> lstopp = listObjOppNew;
        //String opid = lstopp[0].Parent_Opportunity__c;
        //List<String> opid = new List<String>();
        List<Account> resacc = new List<Account> ();
        List<String> accidlist = new List<String>();
        List<Opptype__c> rtype=Opptype__c.getall().values();//get the values from RecordType in custom settings
        for(integer i =0;i< lstopp.size();i++)
        {
            System.debug('inside beforeupdate 193');
            System.debug('inside beforeupdate 194'+lstopp[i].Is_Restricted_Opportunity__c);
            System.debug('inside beforeupdate 195'+oldMap.get(lstopp[i].id).Is_Restricted_Opportunity__c );
            if( ((lstopp[i].Is_Restricted_Opportunity__c == false && lstopp[i].Is_Follow_On_Opportunity__c == true) && ( oldMap.get(lstopp[i].id).Is_Restricted_Opportunity__c == true || oldMap.get(lstopp[i].id).Is_Follow_On_Opportunity__c == false)) 
               || ((lstopp[i].Is_Restricted_Opportunity__c == false && lstopp[i].Is_Follow_On_Opportunity__c == false) && ( oldMap.get(lstopp[i].id).Is_Restricted_Opportunity__c == true ||  oldMap.get(lstopp[i].id).Is_Follow_On_Opportunity__c == true)) )
            {
                System.debug('inside beforeupdate 197');
                accidlist.add(lstopp[i].Restricted_Customer_Name__c);
                accidlist.add(lstopp[i].Restricted_End_User__c);      
            }
            
            // Changes start for INC000005600879
            Decimal Temp = 0; Decimal Temp1 = 0;
            Decimal Tem = 0; Decimal Tem1 = 0;
            if(OppList1 !=null  && OppList1.size()>0){
                for(Opportunity o1:OppList1){
                    if(o1.StageName !='Closed Lost' && o1.StageName !='Closed Cancelled' && o1.StageName !='Closed Channel Partner'){
                        if(o1.Win_Loss_Amount__c !=null)
                            Temp = Temp + o1.Win_Loss_Amount__c;
                        if(o1.Win_Loss_Proposal_Amount__c !=null)
                            Temp1 = Temp1 + o1.Win_Loss_Proposal_Amount__c;
                    }
                    // Added code for INC000005992958
                    if(o1.IsWon == true){
                        if(o1.Win_Loss_Amount__c !=null)
                            Tem = Tem + o1.Win_Loss_Amount__c;
                        if(o1.Win_Loss_Proposal_Amount__c !=null)
                            Tem1 = Tem1 + o1.Win_Loss_Proposal_Amount__c;
                    }
                    // End code for INC000005992958
                }
            }
            if(lstopp[i].StageName !='Closed Lost' && lstopp[i].StageName !='Closed Cancelled' && lstopp[i].StageName !='Closed Channel Partner'){
                if(lstopp[i].Win_Loss_Amount__c !=null){
                    lstopp[i].Total_Win_Loss_Amount__c = Temp + lstopp[i].Win_Loss_Amount__c;                   
                }
                else{
                    lstopp[i].Total_Win_Loss_Amount__c = Temp;
                }
                if(lstopp[i].Win_Loss_Proposal_Amount__c !=null)
                    lstopp[i].Total_Win_Loss_Proposal_Amount__c = Temp1 + lstopp[i].Win_Loss_Proposal_Amount__c;
                else
                    lstopp[i].Total_Win_Loss_Proposal_Amount__c = Temp1;
            }
            else
            {
                lstopp[i].Total_Win_Loss_Amount__c = Temp;
                lstopp[i].Total_Win_Loss_Proposal_Amount__c = Temp1;
            }
            // changes end for INC000005600879
            
            // Added code for INC000005992958
            if(lstopp[i].IsWon == true){
                if(lstopp[i].Win_Loss_Amount__c !=null){
                    lstopp[i].Total_Win_Amount__c = Tem + lstopp[i].Win_Loss_Amount__c;                   
                }
                else{
                    lstopp[i].Total_Win_Amount__c = Tem;
                }
                if(lstopp[i].Win_Loss_Proposal_Amount__c !=null)
                    lstopp[i].Total_Win_Proposal_Amount__c = Tem1 + lstopp[i].Win_Loss_Proposal_Amount__c;
                else
                    lstopp[i].Total_Win_Proposal_Amount__c = Tem1;
            }
            else
            {
                lstopp[i].Total_Win_Amount__c = Tem;
                lstopp[i].Total_Win_Proposal_Amount__c = Tem1;
            }
            
            /*if(lstopp[i].Opp_Update__c){
lstopp[i].Opp_Update__c = false;
}else{
opid.add(lstopp[0].Parent_Opportunity__c);
}*/
            
            // End code for INC000005992958
        }
        
        // Changes start for INC000005600879
        /* if(opid!=null){
OppUpdate.opportunityfieldupdate(opid);
}*/
        // changes end for INC000005600879
        
        if(accidlist.size()>0)
        {
            System.debug('inside beforeupdate 1204'+accidlist);
            resacc = [select name, Id from ACcount where name in :accidlist]; 
        }
        
        for(integer i =0;i< lstopp.size();i++)
        {
            /////////////////////////////////////oppmap.put(lstopp[i].id,lstopp[i]);
            //boolean strin = oldMap.get(lstopp[i].id).Is_Restricted_Opportunity__c;

            if((lstopp[i].Is_Restricted_Opportunity__c == true && lstopp[i].Is_Follow_On_Opportunity__c == true) && (oldMap.get(lstopp[i].id).Is_Restricted_Opportunity__c == false || oldMap.get(lstopp[i].id).Is_Follow_On_Opportunity__c == false))
            {
                /////////////////////////////////idlist.add(lstopp[i].Id);
                //resopp1.add(lstopp[i]);
                System.debug('inside beforeupdate 216');
                if(lstopp[i].Restricted_Opportunity_Name__c == null || Test.isRunningTest())
                {
                    System.debug('inside beforeupdate 219');
                    lstopp[i].Restricted_Opportunity_Name__c = lstopp[i].Name;
                    lstopp[i].Restricted_Customer_Name__c=lstopp[i].Account_Name_formula__c;
                    lstopp[i].Restricted_Program_Name__c=lstopp[i].Program__c;
                    String stg = lstopp[i].Description;
                    if(stg!=null)
                    {
                        if(stg.length()<175)
                        {
                            lstopp[i].Restricted_Comments_Description__c=lstopp[i].Description;
                        }
                        else
                        {
                            stg = stg.substring(0,175);
                            lstopp[i].Restricted_Comments_Description__c=stg;
                        }
                    }
                    lstopp[i].Restricted_End_User__c =lstopp[i].End_User_Formula__c;
                }
                lstopp[i].Name = 'Restricted';
                lstopp[i].AccountID = rtype[0].RestrictedAccount__c;
                lstopp[i].Program__c = 'Restricted';
                lstopp[i].Description = 'Restricted';
                lstopp[i].End_User__c = rtype[0].RestrictedAccount__c;
                if(lstopp[i].RecordTypeId == rtype[0].Catalog__c || lstopp[i].RecordTypeId == rtype[0].Restricted_Catalog__c || lstopp[i].RecordTypeId == rtype[0].D_S_Catalog_FollowOn__c )
                {
                    lstopp[i].RecordTypeId = rtype[0].D_S_Catalog_Restricted_FollowOn__c;
                }
                if(lstopp[i].RecordTypeId == rtype[0].Complex__c || lstopp[i].RecordTypeId == rtype[0].Restricted_Complex__c || lstopp[i].RecordTypeId == rtype[0].D_S_Competitive_FollowOn__c)
                {
                    lstopp[i].RecordTypeId = rtype[0].D_S_Competitive_Restricted_FollowOn__c;
                }
                if(lstopp[i].RecordTypeId == rtype[0].Standard__c || lstopp[i].RecordTypeId == rtype[0].Restricted_Standard__c || lstopp[i].RecordTypeId == rtype[0].D_S_Non_Competitive_FollowOn__c)
                {
                    lstopp[i].RecordTypeId = rtype[0].D_S_Non_Competitive_Restricted_FollowOn__c;
                }
            }
            if((lstopp[i].Is_Restricted_Opportunity__c == true && lstopp[i].Is_Follow_On_Opportunity__c == false) && (oldMap.get(lstopp[i].id).Is_Restricted_Opportunity__c == false || oldMap.get(lstopp[i].id).Is_Follow_On_Opportunity__c == true))
            {
                /////////////////////////////////idlist.add(lstopp[i].Id);
                ///resopp3.add(lstopp[i]);
                System.debug('inside beforeupdate 260');
                if(lstopp[i].Restricted_Opportunity_Name__c == null || Test.isRunningTest())
                {
                    lstopp[i].Restricted_Opportunity_Name__c = lstopp[i].Name;
                    lstopp[i].Restricted_Customer_Name__c=lstopp[i].Account_Name_formula__c;
                    lstopp[i].Restricted_Program_Name__c=lstopp[i].Program__c;
                    String stg = lstopp[i].Description;
                    if(stg!=null)
                    {
                        if(stg.length()<175)
                        {
                            lstopp[i].Restricted_Comments_Description__c=lstopp[i].Description;
                        }
                        else
                        {
                            stg = stg.substring(0,175);
                            lstopp[i].Restricted_Comments_Description__c=stg;
                        }
                    }
                    lstopp[i].Restricted_End_User__c =lstopp[i].End_User_Formula__c;
                }
                lstopp[i].Name = 'Restricted';
                lstopp[i].AccountID = rtype[0].RestrictedAccount__c;
                lstopp[i].Program__c = 'Restricted';
                lstopp[i].Description = 'Restricted';
                lstopp[i].End_User__c = rtype[0].RestrictedAccount__c;
                if(lstopp[i].RecordTypeId == rtype[0].Catalog__c || lstopp[i].RecordTypeId == rtype[0].D_S_Catalog_Restricted_FollowOn__c || lstopp[i].RecordTypeId == rtype[0].D_S_Catalog_FollowOn__c )
                {
                    lstopp[i].RecordTypeId = rtype[0].Restricted_Catalog__c;
                }
                if(lstopp[i].RecordTypeId == rtype[0].Complex__c || lstopp[i].RecordTypeId == rtype[0].D_S_Competitive_Restricted_FollowOn__c || lstopp[i].RecordTypeId == rtype[0].D_S_Competitive_FollowOn__c)
                {
                    lstopp[i].RecordTypeId = rtype[0].Restricted_Complex__c;
                }
                if(lstopp[i].RecordTypeId == rtype[0].Standard__c || lstopp[i].RecordTypeId == rtype[0].D_S_Non_Competitive_Restricted_FollowOn__c || lstopp[i].RecordTypeId == rtype[0].D_S_Non_Competitive_FollowOn__c)
                {
                    lstopp[i].RecordTypeId = rtype[0].Restricted_Standard__c;
                }
            }
            if((lstopp[i].Is_Restricted_Opportunity__c == false && lstopp[i].Is_Follow_On_Opportunity__c == true) && (oldMap.get(lstopp[i].id).Is_Restricted_Opportunity__c == true || oldMap.get(lstopp[i].id).Is_Follow_On_Opportunity__c == false))
            {
                ////////////////////////////////idlist1.add(lstopp[i].Id);
                //resopp2.add(lstopp[i]);
                System.debug('inside beforeupdate 303');
                for(integer k=0;k<resacc.size();k++)
                {
                    System.debug('Line 332'+lstopp[i].Restricted_Customer_Name__c);
                    System.debug('Line 333'+lstopp[i].Restricted_End_User__c);
                    if(resacc[k].name == lstopp[i].Restricted_Customer_Name__c)
                    {
                        System.debug('Line 336');
                        lstopp[i].Account_Id__c = resacc[k].Id;
                    }
                    if(resacc[k].name == lstopp[i].Restricted_End_User__c)
                    {
                        System.debug('Line 341');
                        lstopp[i].End_user_Id__c = resacc[k].Id;
                    }
                }
                if(lstopp[i].Restricted_Opportunity_Name__c!=null)
                {
                    System.debug('inside beforeupdate 306');
                    lstopp[i].Name = lstopp[i].Restricted_Opportunity_Name__c;
                    lstopp[i].accountid=lstopp[i].Account_Id__c;
                    lstopp[i].Program__c=lstopp[i].Restricted_Program_Name__c;
                    lstopp[i].Description=lstopp[i].Restricted_Comments_Description__c;
                    lstopp[i].End_User__c =lstopp[i].End_user_Id__c;
                    lstopp[i].Restricted_Opportunity_Name__c='';
                    lstopp[i].Restricted_Customer_Name__c='';
                    lstopp[i].Restricted_Program_Name__c='';
                    lstopp[i].Restricted_Comments_Description__c='';
                    lstopp[i].Restricted_End_user__c='';
                }
                if(lstopp[i].RecordTypeId == rtype[0].Catalog__c || lstopp[i].RecordTypeId == rtype[0].D_S_Catalog_Restricted_FollowOn__c || lstopp[i].RecordTypeId == rtype[0].Restricted_Catalog__c )
                {
                    lstopp[i].RecordTypeId = rtype[0].D_S_Catalog_FollowOn__c;
                }
                if(lstopp[i].RecordTypeId == rtype[0].Complex__c || lstopp[i].RecordTypeId == rtype[0].D_S_Competitive_Restricted_FollowOn__c || lstopp[i].RecordTypeId == rtype[0].Restricted_Complex__c)
                {
                    lstopp[i].RecordTypeId = rtype[0].D_S_Competitive_FollowOn__c;
                }
                if(lstopp[i].RecordTypeId == rtype[0].Standard__c || lstopp[i].RecordTypeId == rtype[0].D_S_Non_Competitive_Restricted_FollowOn__c || lstopp[i].RecordTypeId == rtype[0].Restricted_Standard__c)
                {
                    lstopp[i].RecordTypeId = rtype[0].D_S_Non_Competitive_FollowOn__c;
                }
                
            }
            if((lstopp[i].Is_Restricted_Opportunity__c == false && lstopp[i].Is_Follow_On_Opportunity__c == false) && (oldMap.get(lstopp[i].id).Is_Restricted_Opportunity__c == true || oldMap.get(lstopp[i].id).Is_Follow_On_Opportunity__c == true))
            {
                ////////////////////////////////idlist1.add(lstopp[i].Id);
                //resopp4.add(lstopp[i]);
                System.debug('inside beforeupdate 346');
                for(integer k=0;k<resacc.size();k++)
                {
                    if(resacc[k].name == lstopp[i].Restricted_Customer_Name__c)
                    {
                        lstopp[i].Account_Id__c = resacc[k].Id;
                    }
                    if(resacc[k].name == lstopp[i].Restricted_End_User__c)
                    {
                        lstopp[i].End_user_Id__c = resacc[k].Id;
                    }
                }
                if(lstopp[i].Restricted_Opportunity_Name__c!=null)
                {
                    System.debug('inside beforeupdate 349');
                    lstopp[i].Name = lstopp[i].Restricted_Opportunity_Name__c;
                    lstopp[i].accountid=lstopp[i].Account_Id__c;
                    lstopp[i].Program__c=lstopp[i].Restricted_Program_Name__c;
                    lstopp[i].Description=lstopp[i].Restricted_Comments_Description__c;
                    lstopp[i].End_User__c =lstopp[i].End_user_Id__c;
                    lstopp[i].Restricted_Opportunity_Name__c='';
                    lstopp[i].Restricted_Customer_Name__c='';
                    lstopp[i].Restricted_Program_Name__c='';
                    lstopp[i].Restricted_Comments_Description__c='';
                    lstopp[i].Restricted_End_user__c='';
                }
                if(lstopp[i].RecordTypeId == rtype[0].D_S_Catalog_FollowOn__c || lstopp[i].RecordTypeId == rtype[0].D_S_Catalog_Restricted_FollowOn__c || lstopp[i].RecordTypeId == rtype[0].Restricted_Catalog__c )
                {
                    lstopp[i].RecordTypeId = rtype[0].Catalog__c;
                }
                if(lstopp[i].RecordTypeId == rtype[0].D_S_Competitive_FollowOn__c|| lstopp[i].RecordTypeId == rtype[0].D_S_Competitive_Restricted_FollowOn__c || lstopp[i].RecordTypeId == rtype[0].Restricted_Complex__c)
                {
                    lstopp[i].RecordTypeId = rtype[0].Complex__c ;
                }
                if(lstopp[i].RecordTypeId == rtype[0].D_S_Non_Competitive_FollowOn__c || lstopp[i].RecordTypeId == rtype[0].D_S_Non_Competitive_Restricted_FollowOn__c || lstopp[i].RecordTypeId == rtype[0].Restricted_Standard__c)
                {
                    lstopp[i].RecordTypeId = rtype[0].Standard__c;
                }
                
            }
            /*if(lstopp[i].OwnerId!=oldMap.get(lstopp[i].id).OwnerId &&lstopp[i].record_type_name__c!= 'BGA OE' && lstopp[i].record_type_name__c!= 'BGA AM' )
{   
idlist3.add(lstopp[i]);
}
*/
        }   
        
        /*************** Opportunity_Provideaccess - end **/       
        /*********************Opportunity_CheckStatus Trigger Before update ***********/
        if(oppList.size()>0)
        {
            List<Opportunity_Gate__c> g1= [select Flag__c,id,Serial_No__c,stage__c,opportunity__c,actual_date__c from Opportunity_Gate__c where  opportunity__c in :oppList order by serial_no__c  ];
            for(Opportunity opp:listObjOppNew)
            {
                integer flagNew=0;integer flagOld=0;
                Opportunity_Gate__c gateNew=new Opportunity_Gate__c();
                Opportunity_Gate__c gateOld=new Opportunity_Gate__c();
                
                if(opp.StageName !=oldMap.get(opp.id).StageName)
                {
                    for(integer i=0;i< g1.size();i++)
                    {
                        if(opp.StageName==g1[i].stage__c  && flagNew==0)
                        {
                            flagNew=1;
                            gateNew=g1[i];
                        }
                        if(oldMap.get(opp.id).StageName==g1[i].stage__c  && flagOld==0)
                        {
                            flagOld=1;
                            gateold=g1[i];
                        }       
                    } 
                    if(gateNew != null && gateold != null)
                    {
                        if(gateNew.serial_no__c ==2 && gateold.serial_no__c <gateNew.serial_no__c && gateNew.Flag__c == False && opp.record_type_name__c == oldMap.get(opp.id).record_type_name__c)
                        {
                            if(opp.roll_up__c == 0.0 && gateold.actual_date__c == null)
                                opp.stagename.addError('1111Please choose the opportunity stage value as per tollgate');
                        }
                        else
                        { 
                            system.debug('gateNew.serial_no__c :'+gateNew.serial_no__c);
                            system.debug('opp.roll_up__c :'+opp.roll_up__c);
                            if(gateNew.serial_no__c  != opp.roll_up__c  + 2 && gateold.serial_no__c <gateNew.serial_no__c && opp.record_type_name__c == oldMap.get(opp.id).record_type_name__c)
                            {
                                opp.stagename.addError('Please choose the opportunity stage value as per tollgate');
                            }
                        } 
                    }
                }
                if((opp.StageName !='Closed Won' && opp.StageName !='Closed Lost' && opp.StageName !='Closed Cancelled' ) && 
                   (oldMap.get(opp.id).StageName == 'Closed Won'|| oldMap.get(opp.id).StageName == 'Closed Lost' || oldMap.get(opp.id).StageName == 'Closed Cancelled')) 
                {   
                    opp.stagename = opp.Previous_StageName__c;
                    opp.Next_Phase__c =opp.Previos_Tollgate__c;
                    opp.Next_Phase_Date__c =opp.Previos_Tollgate_Date__c;
                }
                if((opp.StageName =='Closed Won'|| opp.StageName =='Closed Lost' || opp.StageName =='Closed Cancelled' ) &&
                   (oldMap.get(opp.id).StageName != 'Closed Won'&& oldMap.get(opp.id).StageName!= 'Closed Lost' && oldMap.get(opp.id).StageName != 'Closed Cancelled'))
                {    
                    opp.Previous_StageName__c = oldMap.get(opp.id).StageName;
                    opp.Previos_Tollgate__c =oldMap.get(opp.id).Next_Phase__c;
                    opp.Previos_Tollgate_Date__c =oldMap.get(opp.id).Next_Phase_Date__c;
                }  
            }  
        }
        /*********************Opportunity_SendAccountOpener_Discretionary Trigger Before update ***********/
        if (OpportunitiesId.size()>0)
        {     
            for ( Discretionary_Line_Item__c DLI :[Select id, AccountOpener__c, d.Discretionary_Request__r.Opportunity__c, d.Discretionary_Request__c From Discretionary_Line_Item__c d where d.Discretionary_Request__r.Opportunity__c in :OpportunitiesId])
            {
                aprec=new Discretionary_Line_Item_Approval_History__c();
                aprec.Approval_Status__c = 'Pending Close';
                aprec.Discretionary_Line_Item__c = DLI.Id ;
                aprec.AccountOpenerEmail__c= DLI.AccountOpener__c;
                ApproveobjRec.add(aprec);
            }  
            if (ApproveobjRec.size()>0)
            {
                insert ApproveobjRec;
            }
        } 
        /*********************Opportunity_Validation Trigger Before update ***********/
        
        if(oppid1.size()>0)
        {
            oppline=[select id,Revenue_Start_Date__c,Schedule_Type__c,Terms_in_Months__c,Revenue_End_Date__c,OpportunityId from opportunitylineitem where opportunityid IN:oppid1 order by Terms_in_Months__c desc limit 50000 ];
            if(oppline.size()>0)
            {
                for(opportunitylineitem oppl:oppline)
                {           
                    if((!(longduration.containsKey(oppl.OpportunityId)) && oppl.Terms_in_Months__c!=null))
                    {
                        longduration.put(oppl.OpportunityId,oppl);
                        stardatemap.put(oppl.opportunityId,oppl.Revenue_Start_Date__c);
                        enddatemap.put(oppl.opportunityId,oppl.Revenue_End_Date__c);
                    }
                    else if(oppl.Terms_in_Months__c!=null && longduration.get(oppl.OpportunityId).Terms_in_Months__c < oppl.Terms_in_Months__c)
                    {
                        longduration.put(oppl.OpportunityId,oppl);
                        stardatemap.put(oppl.opportunityId,oppl.Revenue_Start_Date__c);
                        enddatemap.put(oppl.opportunityId,oppl.Revenue_End_Date__c);
                    }           
                }               
                for(Opportunity opp:listObjOppNew)
                {               
                    if(stardatemap.get(opp.Id)!=null && enddatemap.get(opp.Id)!=null)
                    {
                        integer intt=0;
                        integer year=0;
                        if(longduration.get(opp.id)!=null && longduration.get(opp.id).Schedule_Type__c!='Yearly')
                            intt = stardatemap.get(opp.Id).daysBetween(enddatemap.get(opp.Id));
                        else if(longduration.get(opp.id)!=null && longduration.get(opp.id).Schedule_Type__c=='Yearly')
                            year=enddatemap.get(opp.Id).year()-stardatemap.get(opp.Id).year();
                        Decimal t = intt/365.0;
                        double d = t.setScale(0,System.RoundingMode.CEILING);
                        integer k = d.intvalue();
                        if(year!=0)
                            k=year;
                        if(opp.Program_Terms__c!= string.valueof(k) && opp.Program_Terms__c ==oldmap.get(opp.id).Program_Terms__c && k != 0 )
                        {
                            opp.Program_Terms__c = string.valueof(k);
                        }
                        else if (k == 0)
                        {
                            opp.Program_Terms__c = '1';
                        }
                        
                        else if(opp.Program_Terms__c!= string.valueof(k) && opp.Program_Terms__c !=oldmap.get(opp.id).Program_Terms__c && 
                                oldmap.get(opp.id).Program_Terms__c!=null)
                            opp.adderror('You can not change Program Term. Program Term will be auto populated based on Revenue Schedule.');
                    }
                    
                }
                
            } 
        }
        
        if(oppid.size()>0)
        {   
            opportunity opp = listObjOppNew[0];
            //INC000009918063 - Add the picklist value to Solution type field(Services)- Starts
            List<OpportunityLineItem> soloppline=[SELECT TotalPrice,Solution_Type__c FROM OpportunityLineItem WHERE (Solution_Type__c = 'Other' or Solution_Type__c = 'BFE / SSFE' or Solution_Type__c = 'Direct Sales' or Solution_Type__c = 'OE - Original Equipment' or Solution_Type__c = 'Repair and Overhaul' or Solution_Type__c = 'RMU' or Solution_Type__c = 'Spares - LRU and APU' or Solution_Type__c = 'Spares - Repair Details' or Solution_Type__c = 'Services') and  OpportunityId =: parentid];
                       
            if(soloppline.size()>0 && (opp.RecordTypeId == label.AM_Catalog || opp.RecordTypeId == label.AM_Complex || opp.RecordTypeId == label.AM_Standard || opp.RecordTypeId == label.OE_Complex || opp.RecordTypeId == label.OE_Standard))
            {
                for(OpportunityLineItem opplineitem1:soloppline)
                {
                    if(opplineitem1.Solution_Type__c == 'Other')            
                    {
                        othertotal=othertotal+opplineitem1.TotalPrice;  
                    }
                    else if(opplineitem1.Solution_Type__c == 'BFE / SSFE')            
                    {
                        bfetotal=bfetotal+opplineitem1.TotalPrice;  
                    }
                    else if(opplineitem1.Solution_Type__c == 'Direct Sales')            
                    {
                        directtotal=directtotal+opplineitem1.TotalPrice; 
                    }
                    else if(opplineitem1.Solution_Type__c == 'OE - Original Equipment')           
                    {
                        Equipmenttotal=Equipmenttotal+opplineitem1.TotalPrice;
                    }
                    else if(opplineitem1.Solution_Type__c == 'Repair and Overhaul')         
                    {
                        repairtotal=repairtotal+opplineitem1.TotalPrice;
                    }
                    else if(opplineitem1.Solution_Type__c == 'RMU')         
                    {
                        RMUtotal1=RMUtotal1+opplineitem1.TotalPrice;
                    }
                    else if(opplineitem1.Solution_Type__c == 'Spares - LRU and APU')            
                    {
                        spareslrutotal=spareslrutotal+opplineitem1.TotalPrice;
                    }
                    else if(opplineitem1.Solution_Type__c == 'Spares - Repair Details')           
                    {
                        sparesrepairtotal=sparesrepairtotal+opplineitem1.TotalPrice;
                    }
                    else if(opplineitem1.Solution_Type__c == 'Services')            
                    {
                        Servicestotal=Servicestotal+opplineitem1.TotalPrice;  
                    }
                }
                //finding max value
                decimal result4=math.max(math.max(directtotal,Equipmenttotal),math.max(othertotal,bfetotal));
                decimal result5=math.max(math.max(repairtotal,RMUtotal1),math.max(spareslrutotal,sparesrepairtotal));
                decimal result6=math.max(result4,math.max(result5,Servicestotal));
                string solutiontype;
                
                if(result6 != null)
                {
                    if(result6==directtotal)
                    {
                        solutiontype='Direct Sales';
                    }
                    else if(result6==Equipmenttotal)
                    {
                        solutiontype='OE - Original Equipment';
                    }
                    else if(result6==othertotal)
                    {
                        solutiontype='Other';
                    }
                    else if(result6==bfetotal)
                    {
                        solutiontype='BFE / SSFE';
                    }
                    else if(result6==repairtotal)
                    {
                        solutiontype='Repair and Overhaul';
                    }
                    else if(result6==RMUtotal1)
                    {
                        solutiontype='RMU';
                    }
                    else if(result6==spareslrutotal)
                    {
                        solutiontype='Spares - LRU and APU';
                    }
                    else if(result6==sparesrepairtotal)
                    {
                        solutiontype='Spares - Repair Details';
                    }
                    else if(result6==Servicestotal)
                    {
                        solutiontype='Services';
                    }
                    if(opp.Solution_Type__c != oldMap.get(opp.id).Solution_Type__c && opp.Solution_Type__c != solutiontype)
                    {                                                                   
                        opp.adderror('You cannot change Solution Type.Solution Type will be auto populated based on opportunity product Total Price value.');
                    }
                }
            }        
        }   
        //INC000009918063 - Add the picklist value to Solution type field(Services)- Ends
        //Health Check chnages starts 
        if(parentid1.size()>0)
        {                                        
            Map<Id,Opportunity> mapOppLI = new Map<id,opportunity>([select id,(SELECT TotalPrice,UnitPrice,OpportunityId,Amount_Net__c,Revenue_Type__c,Solution_Type__c 
                                                                               FROM OpportunityLineItems where Amount_Net__c != null) from opportunity where id in :parentid1]);
            for (Opportunity  oppprod : listObjOppNew) 
            {                  
                List<OpportunityLineItem> oppline23 = new List<OpportunityLineItem>();
                if(null!=mapOppLI && mapOppLI.size()>0)
                    oppline23 = mapOppLI.get(oppprod.id).OpportunityLineItems;                                  
                map<id,decimal>tempmap= new map<id,decimal>();
                map<id,decimal>totalunitprice1map= new map<id,decimal>();
                decimal temp=0.0;
                decimal totalunitprice=0.0;
                for(OpportunityLineItem opplineitem45:oppline23)
                {
                    if(tempmap.containsKey(opplineitem45.OpportunityId)){
                        temp=tempmap.get(opplineitem45.OpportunityId);
                    }
                    if(opplineitem45.Amount_Net__c!=null){
                        temp=temp+opplineitem45.Amount_Net__c;
                    }                        
                    totalunitprice=totalunitprice+opplineitem45.TotalPrice;                         
                }                      
                tempmap.put(oppprod.id,temp);
                totalunitprice1map.put(oppprod.id,totalunitprice);                                
                /*if(tempmap.get(oppprod.id)!=null)
{
totalpricenet=tempmap.get(oppprod.id);
totalpricenet1=totalunitprice1map.get(oppprod.id);

if(oppprod.Amount!=null && oppprod.Amount!=0.0){                    
if(totalpricenet1!=0)
{                                       
sumEstimatedValue= ((totalpricenet/totalpricenet1)*100).setScale(0);
}
}
}                   
if(oppprod.Amount != oldMap.get(oppprod.id).Amount)
{                       
oppprod.ATR_Probability__c=sumEstimatedValue;                       
}
if(oppline23.size()>0)
{
if(oppprod.ATR_Probability__c!=sumEstimatedValue && oppprod.ATR_Probability__c != oldMap.get(oppprod.id).ATR_Probability__c)
{                                                            
oppprod.adderror('You cannot change Estimated Win Probability. Estimated Win Probability will be auto populated based on opportunity product Total Price value');
}
}*/ 
            }
        } 
        /*********************Opportunity_PlannedMeeting Trigger Before Insert ***********/
        if(oppMap.size()>0)
        {
            for (Opportunity opp : [SELECT Is_Restricted_Opportunity__c,Planned_Meeting__c,Name FROM Opportunity WHERE Planned_Meeting__c IN :oppMap.KeySet() ]) 
            {
                Opportunity newopp=oppMap.get(opp.Planned_Meeting__c);
                if(newopp != null)
                {
                    if(newopp.Is_Restricted_Opportunity__c != opp.Is_Restricted_Opportunity__c )
                    {
                        newopp.Planned_Meeting__c.addError('Please select another Planned meeting');
                    }
                }
            }
        }       
        OppClassForPublicMethods objtemp = new OppClassForPublicMethods();
        objtemp.changeRecordTypeMethod(listObjOppNew,oldMap);         
        objtemp.OppProvideAccessMethod(listObjOppNew,oldMap);   
        /*********************Opportunity_PlannedMeeting Trigger Before Insert ***********/   
        
        if(!listObjOppNew.isEmpty())
        {
            Set<Id> IdSet = new Set<Id>();
            for(Opportunity opp : listobjOppNew)
            {
                if(opp.Parent_Opportunity__c != null ){
                    IdSet.add(opp.Parent_Opportunity__c);
                }
            }
            System.debug('@@listobjOppNew'+listobjOppNew);
            Map<String,Opportunity> oppParentMap = new Map<String,Opportunity>();
            for(Opportunity opp :[select id,Sales_Channel__c,SBU__c,Parent_Opportunity__c from opportunity where Id In:IdSet])
            {
                oppParentMap.put(opp.id, opp);                
            }
            System.debug('@@oppParentMap'+oppParentMap);
            for(Opportunity opp : listobjOppNew) 
            {
                system.debug('parent opp'+opp.parent_opportunity__c);
                system.debug('parent opp'+opp.parent_opportunity__c != null);
                system.debug('parent opp'+opp.parent_opportunity__c == '');
                if(opp.Parent_Opportunity__c != null)
                {
                    opp.Parent_Opportunity_SBU__c =oppParentMap.get(opp.Parent_Opportunity__c).SBU__c;
                    opp.Parent_Opportunity_Sales_Channel__c =oppParentMap.get(opp.Parent_Opportunity__c).Sales_Channel__c ;                   
                }
               
               
            }                  
        } 
        
        Set<Id> IdSet = new Set<Id>();
        for(Opportunity opp : listobjOppNew){  
        if ( opp.StageName =='Closed Lost' || opp.StageName =='Closed Cancelled' || opp.StageName == 'Closed Channel Partner') 
                {                     
               opp.ATR_Probability__c = 0;
               opp.Program_Go_Probability__c = 0;  
                }
              else if (opp.StageName =='Closed Won')
                    {
                     opp.ATR_Probability__c = 100;
                     opp.Program_Go_Probability__c = 100;
                    }       
        
          }
        }
     }