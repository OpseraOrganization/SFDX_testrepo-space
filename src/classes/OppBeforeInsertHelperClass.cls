/*******************************************************************************
Name         : OppBeforeInsertHelperClass
Created By   : Anusuya Murugiah
Company Name : NTT Data
Project      : <Phase-II>,<HealthCheck - Sprint3> 
Created Date : 26 December 2013
Usages       : This Class is to consolidate the BeforeInsert functionality of 
               opportunity which splited across in different triggers.               
*******************************************************************************/
public class OppBeforeInsertHelperClass
{
    public static void beforeInsertMethod(List<Opportunity> listObjOppNew,Map<ID,Opportunity> oldMap)
    {               
        List <Opportunity> lstopp = new List <Opportunity>();
        /*********************Opportunity_UpdateRecordType_SBU Trigger Before Insert ***********/
        list<Opptype__c> rtype=Opptype__c.getall().values();       
        map<String,ATR_Opportunity_Record_Types__c> ATR_rtype=ATR_Opportunity_Record_Types__c.getall();
        List <Opportunity> lstopp1 = listObjOppNew;
        /*********************Opportunity_UpdateStage Trigger Before Insert ***********/  
        List<D_S_Profile__c> plist=D_S_Profile__c.getall().values();
        /*********************Opportunity_PlannedMeeting Trigger Before Insert ***********/
        Map<Id,Opportunity> oppMap = new Map<Id,Opportunity>(); 
        Map<Id,Opportunity> oppMap1 = new Map<Id,Opportunity>(); 
/****************Added for D&S Partner Insert validation Starts*******************/
        Id UID = userinfo.getUserid();
        Id PID = userinfo.getProfileid();
        String MatchId;
        List<User> usr = new List<User>();
        List<Opportunity> UpdateOpplist = new List<Opportunity>();
        if (PID == Label.D_S_Partner_ProfileId) { 
            usr = [Select id,name,ContactId,contact.accountid,contact.account.name, contact.account.Strategic_Business_Unit__c,contact.account.CBT__c,contact.account.CBT_Team__c,contact.account.CBT_Directorate__c from User where id =:UID and contactId != null limit 1];
            matchid = string.valueOf(PID).substring(0,15);
            system.debug('$$$$$$$$$$$$$$$'+matchid);
        }
        /****************Added for D&S Partner Insert validation Ends*******************/
        for(Opportunity opp:listObjOppNew)
        {                                   
            /***** Opportunity_Provideaccess - Start ********/
             if(opp.Is_Restricted_Opportunity__c == True || Test.isRunningTest())
             {
                opp.Restricted_Opportunity_Name__c = opp.Name;
                opp.Restricted_Customer_Name__c=opp.Account_Name_formula__c;
                opp.Restricted_Program_Name__c=opp.Program__c;
                String stng = opp.Description;
                if(stng!=null)
                {
                    if(stng.length()<175)
                    {
                        opp.Restricted_Comments_Description__c=opp.Description;
                    }
                    else
                    {
                        stng = stng.substring(0,175);
                        opp.Restricted_Comments_Description__c=stng;
                    }
                }
                ///////////////opp.Restricted_Comments_Description__c=opp.Description;
                opp.Restricted_End_User__c =opp.End_User_Formula__c;
                opp.Name = 'Restricted';
                opp.AccountID = rtype[0].RestrictedAccount__c;
                opp.Program__c = 'Restricted';
                opp.Description = 'Restricted';
                opp.End_User__c = rtype[0].RestrictedAccount__c;
             }
             /******* Opportunity_Provideaccess - End  *****/
            /*********************Opportunity_UpdateStage Trigger Before Insert ***********/     
            if(Trigger.Isinsert && (UserInfo.getProfileId()!= plist[0].Profile__c || Test.isRunningTest()))
            {
                    
                    if(opp.Opportunity_Type__c == 'D&S PrePriced'||opp.Opportunity_Type__c == 'D&S PrePriced Restricted') 
                    {  
                        opp.StageName='Prospecting';
                    }
                    if(opp.Opportunity_Type__c == 'D&S Run Rate')
                    {
                        opp.StageName='Prospecting';
                    }
                    if(opp.Opportunity_Type__c == 'D&S Standard'|| opp.Opportunity_Type__c == 'D&S Standard Restricted')
                    {   
                        opp.StageName='Prospecting';
                    }
                    if(opp.Opportunity_Type__c == 'D&S Complex'|| opp.Opportunity_Type__c == 'D&S Complex Restricted')
                    {  
                        opp.StageName='Prospecting';
                    }
                    
            /*************added the remaining record types as per the Ed instruction*************************************/
           
                     if(opp.Opportunity_Type__c == 'D&S Complex FollowOn'|| opp.Opportunity_Type__c == 'D&S Complex Restricted FollowOn')
                    
                    {  
                  
                        opp.StageName='Prospecting';
                    }
                      if(opp.Opportunity_Type__c == 'D&S PrePriced FollowOn'|| opp.Opportunity_Type__c == 'D&S PrePriced Restricted FollowOn') 
                    {  
                        opp.StageName='Prospecting';
                    }
                     if(opp.Opportunity_Type__c == 'D&S Standard FollowOn'|| opp.Opportunity_Type__c == 'D&S Standard Restricted FollowOn')
                    {   
                        opp.StageName='Prospecting';
                    }
                     if(opp.Opportunity_Type__c == 'BGA AM'|| opp.Opportunity_Type__c == 'BGA OE')
                    {   
                        opp.StageName='Prospecting';
                    }
                    if(opp.ATR_Opportunity_Type_Convert__c == 'AM Catalog')
                    { 
                       opp.StageName='Prospecting';
                    }
                    if(opp.ATR_Opportunity_Type_Convert__c == 'AM Standard' )
                    { 
                       opp.StageName='Prospecting';
                    }
                    if(opp.ATR_Opportunity_Type_Convert__c == 'AM Complex' )
                    {                        
                       opp.StageName='Prospecting';
                    }
                    if(opp.ATR_Opportunity_Type_Convert__c == 'OE Complex')
                    { 
                       opp.StageName='Prospecting';
                    }
                    if(opp.ATR_Opportunity_Type_Convert__c == 'OE Standard')
                    { 
                       opp.StageName='Prospecting';
                    }
            }
            /*********************Opportunity_Validation Trigger Before Insert ***********/
            if (opp.Accountid!=null && opp.Lead_Number__c!=null && opp.SBU__c == 'D&S')
            {              
                opp.CBT_Team_Tier_3__c=opp.Account_CBT_Team__c;
            }
            /*********************Opportunity_UpdateRecordType_SBU Trigger Before Insert ***********/ 
            
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
                            
            /*********************Added for D&S Partner Insert validation Starts***************************/
            if(PID == Label.D_S_Partner_ProfileId)
            {
                if(Trigger.Isinsert && opp.AccountId != null && Opp.AccountId != usr[0].contact.accountid) 
                {
                    opp.AccountId.addError('You Cannot choose an Account other than'+usr[0].contact.account.name);
                }
                
                if(Trigger.Isinsert && PID == Label.D_S_Partner_ProfileId) 
                
                {
                    system.debug('%%%%%%%%%%%%%%%%%%%%%%%%%'+usr[0].contact.account.Strategic_Business_Unit__c);
                    opp.SBU__c = usr[0].contact.account.Strategic_Business_Unit__c;
                    opp.CBT_Tier_2__c = usr[0].contact.account.CBT__c;
                    opp.CBT_Team_Tier_3__c = usr[0].contact.account.CBT_Team__c;
                    opp.CBT_Directorate__c = usr[0].contact.account.CBT_Directorate__c;
                    UpdateOpplist.add(opp);   
                }
            }
           
             /*********************Added for D&S Partner Insert validation Ends***************************/                 
            if (opp.SBU__c==null && opp.AccountId!=null && opp.record_type_name__c!= 'BGA OE' && opp.record_type_name__c!= 'BGA AM')
                {
                    opp.SBU__c =opp.SBUFormulae__c;
                }       
                if (opp.CBT_Tier_2__c==null && opp.AccountId!=null && opp.record_type_name__c!= 'BGA OE' && opp.record_type_name__c!= 'BGA AM')
                {        
                     opp.CBT_Tier_2__c=opp.CBTTier2Formulae__c;
                }
                if(opp.Opportunity_Type__c == 'Focus' && opp.Is_Restricted_Opportunity__c == false)
                {                   
                    opp.recordtypeid = rtype[0].Focus__c ;
                }
                if(opp.Opportunity_Type__c == 'D&S PrePriced' && opp.Is_Restricted_Opportunity__c == false)
                {               
                    opp.recordtypeid = rtype[0].Catalog__c ;
                }
              /* if(opp.Opportunity_Type__c == 'D&S Run Rate' && opp.Is_Restricted_Opportunity__c == false)
                {               
                    opp.recordtypeid = rtype[0].Catalog__c ;
                }*/
                if(opp.Opportunity_Type__c == 'D&S Standard'&& opp.Is_Restricted_Opportunity__c == false)
                {                   
                     opp.recordtypeid = rtype[0].Standard__c ;
                }
                if(opp.Opportunity_Type__c == 'D&S Complex'&& opp.Is_Restricted_Opportunity__c == false)
                {                   
                     opp.recordtypeid = rtype[0].Complex__c ;
                }
                if(opp.Opportunity_Type__c == 'Key'&& opp.Is_Restricted_Opportunity__c == false)
                {              
                   opp.recordtypeid = rtype[0].Key__c ;
                }
                if(opp.ATR_Opportunity_Type_Convert__c == 'AM Catalog')
                { 
                   opp.recordtypeid = ATR_rtype.get('AM Catalog').Record_Type_Id__c;//[1].Record_Type_Id__c ;
                }
                if(opp.ATR_Opportunity_Type_Convert__c == 'AM Standard' )
                { 
                   opp.recordtypeid = ATR_rtype.get('AM Standard').Record_Type_Id__c;//ATR_rtype[3].Record_Type_Id__c ;
                }
                if(opp.ATR_Opportunity_Type_Convert__c == 'AM Complex')
                { 
                   opp.recordtypeid = ATR_rtype.get('AM Complex').Record_Type_Id__c;//ATR_rtype[2].Record_Type_Id__c ;
                }
                if(opp.ATR_Opportunity_Type_Convert__c == 'OE Complex')
                { 
                    opp.recordtypeid =ATR_rtype.get('OE Complex').Record_Type_Id__c;// ATR_rtype[0].Record_Type_Id__c ;
                }
        } 
       
        /*********************Opportunity_PlannedMeeting Trigger Before Insert ***********/
        /********** M&PM Sim Licensing Phase2 Process step Formula Starts **************/
        /* Added By: Chiranjeevi Gogulakonda,NTT DATA, M&PM phase2 Changes*/
         /*
        for(Opportunity opp:listObjOppNew){
            if(opp.Record_Type_Name__c == 'M&PM SIM Licensing'){
            system.debug('Inside for loop*******');
                if(opp.Revenue_Recognition_Expected__c != null){
                    opp.Process_Step1__c = 'Rev Recog Hold';
                }else if(opp.Workstop_Issue__c != null && opp.Workstop_Issue_Cleared__c==false){
                    opp.Process_Step1__c = '0 - HOLD';
                }else if(((opp.Deal_Phase__c == 'Closed/Won')||(opp.Deal_Phase__c == 'Closed Won')||(opp.Deal_Phase__c == 'Closed Lost')) && opp.InvoiceRequested__c==false){
                    opp.Process_Step1__c='10 - Ship / Invoice';
                }else if((opp.Deal_Phase__c == 'Closed/Won')||(opp.Deal_Phase__c == 'Closed Won')||(opp.Deal_Phase__c == 'Closed Lost')){
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
            }
        }
            */
        /********** M&PM Sim Licensing Phase2 Process step Formula Ends ****************/
    
         if(oppMap.size()>0)
        {
            for (Opportunity opp : [SELECT Is_Restricted_Opportunity__c,Planned_Meeting__c,Name FROM Opportunity WHERE Planned_Meeting__c IN :oppMap.KeySet() ]) 
            {
                Opportunity newopp=oppMap.get(opp.Planned_Meeting__c);
                if(newopp != null)
                {
                    if(newopp.Is_Restricted_Opportunity__c != opp.Is_Restricted_Opportunity__c)
                    {
                        newopp.Planned_Meeting__c.addError('Please select another Planned meeting');
                    }
                }
            }
        } 
        try {
            insert UpdateOpplist;
        }
        catch (exception e) {
            system.debug('An unexpected error has occured '+e);
        } 
        OppClassForPublicMethods objtemp = new OppClassForPublicMethods();        
        objtemp.OppProvideAccessMethod(listObjOppNew,oldMap);                                         
    
            // Added code for custom convert lead.
    if(listObjOppNew.size()==1){
            Opportunity oppNew = listObjOppNew.get(0);
            if(oppNew.Lead_ID__c != null && oppNew.Lead_ID__c !=''){
                Lead leadInfo = [select id,Lead_Number__c,FSE_Initiator_Name__c,Lead_Creation_Date__c,ATR_Estimated_Value__c,Lead_Description__c from lead where id=:oppNew.Lead_ID__c];
                oppNew.FSEintiator_name_Leadmapped__c = leadInfo.FSE_Initiator_Name__c;
                oppNew.Lead_Number__c = leadInfo.Lead_Number__c;
                oppNew.Lead_Creation_Date__c = leadInfo.Lead_Creation_Date__c;
                oppNew.Lead_Description__c = leadInfo.Lead_Description__c;
                oppNew.Lead_Amount__c = leadInfo.ATR_Estimated_Value__c;
          }
        } 
       
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
                if(opp.Parent_Opportunity__c != null )
                {
                    opp.Parent_Opportunity_SBU__c =oppParentMap.get(opp.Parent_Opportunity__c).SBU__c;
                    opp.Parent_Opportunity_Sales_Channel__c =oppParentMap.get(opp.Parent_Opportunity__c).Sales_Channel__c ;                   
                }
            }
            
        }
        
       
    }
}