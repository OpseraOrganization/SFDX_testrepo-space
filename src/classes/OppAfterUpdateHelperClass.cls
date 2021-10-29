/*******************************************************************************
Name         : OppAfterUpdateHelperClass
Created By   : Anusuya Murugiah
Company Name : NTT Data
Project      : <Phase-II>, <HealthCheck - Sprint3> 
Created Date : 26 Decmber 2013
Usages       : This Class is to consolidate the AfterUpdate functionality of opportunity which
               splited across in different triggers.               
*******************************************************************************/
public class OppAfterUpdateHelperClass
{
    public static boolean bool_trans=True;// Changes for INC000008246504
    //Changes for INC000008246504- added Map<ID,Opportunity> newMap as second parameter
    
     public static void afterupdateMethod(List<Opportunity> listObjOppNew,Map<ID,Opportunity> oldMap,Map<ID,Opportunity> newMap,List<Opportunity> listOppOld){    
        /* Made changes to update Opportunity Product Object's Probability__c field - start */
         if (!StopRecursivecall.hasUpdate_OnBehalfendUserStatus()){
            StopRecursivecall.setUpdate_OnBehalfendUserStatus();
            set<id> oppIds = new set<id>();
            set<id> inActiveOppIds = new set<id>();
            for(Opportunity oppRec:listObjOppNew){
                if(oldMap.get(oppRec.id).Combined_Probability__c != oppRec.Combined_Probability__c){
                    oppIds.add(oppRec.id);
                }
                if(oppRec.StageName=='Closed Cancelled' && !oppRec.Active__c){
                    inActiveOppIds.add(oppRec.id);
                }
            }
            if(oppIds.size()>0){
                list<OpportunityLineItem> oppProdlist = [select id,OpportunityID,Probability__c from 
                                                                OpportunityLineItem where OpportunityID in :oppIds and Type__c != 'Booked'];
                list<OpportunityLineItem> oppProdListForUpdate = new list<OpportunityLineItem>();
                for(OpportunityLineItem oppProdRec:oppProdlist){
                     system.debug('FB value:'+newMap.get(oppProdRec.OpportunityID).Combined_Probability__c);
                     if(newMap.get(oppProdRec.OpportunityID).Combined_Probability__c != oppProdRec.Probability__c){
                        oppProdRec.Probability__c = newMap.get(oppProdRec.OpportunityID).Combined_Probability__c;
                        oppProdListForUpdate.add(oppProdRec);
                    }
                }
                system.debug('oppProdListForUpdate value:'+oppProdListForUpdate);
                if(oppProdListForUpdate.size()>0){
                    update oppProdListForUpdate;
                }
            }
            if(inActiveOppIds.size()>0){
                list<OpportunityLineItem> oppProdlist = [select id,OpportunityID,Probability__c from 
                                                                OpportunityLineItem where OpportunityID in :inActiveOppIds];
                list<OpportunityLineItem> oppProdListForUpdateInactive = new list<OpportunityLineItem>();
                for(OpportunityLineItem oppProdRec:oppProdlist){
                    oppProdRec.Active__c = false;
                    oppProdListForUpdateInactive.add(oppProdRec);
                }
                if(oppProdListForUpdateInactive.size()>0)
                    update oppProdListForUpdateInactive;
            }
        }
        /* Made changes to update Opportunity Product Object's Probability__c field - end */
        
        // UpdateTollgateFields  //
        List<Opportunity_Gate__c> oppGate= new List<Opportunity_Gate__c>();
        set<id> opprodupdateids=new set<id>();
        list<OpportunityLineItem> lstoplt = new list<OpportunityLineItem>();
        // UpdateTollgateFields  //
                
        // Opportunity_UpdateStatus //
        List<ID> li = new List<ID>();
        List<ID> oppsId= new List<ID>();
        Decimal d1,d2 ;
        String nextphase;
        Date nextdate,d;
        Id i1;
        List<Case> lstCaseUpdt = new List<Case>();
        List<Case> caseupdate = new List<Case>();
        List<Opportunity> optyupdate = new List<Opportunity>();
        List<Opportunity> listOppToUpdate = new List<Opportunity>();
        List<Opportunity_gate__c> og = new List<Opportunity_gate__c>();
        List<Opportunity_gate__c> og1 = new List<Opportunity_gate__c>();
        List<Opportunity_gate__c> og2 = new List<Opportunity_gate__c>();
         List<Workflow_details__c>wddata=new list<Workflow_details__c>();
        List<Workflow_details__c>wdlist=new list<Workflow_details__c>();
        List<Opportunity_gate__c> updateOPG = new List<Opportunity_gate__c>();
        List<Opportunity_gate__c> updateTollgate = new List<Opportunity_gate__c>();
        Map<id,opportunity> mapOppFinal = new Map<id,opportunity>([select id,account.name,deal_Phase__c,Information_for_Engg__c,TS_Agreement_License__c,Corp_HIPI_Opportunity_Number__c,ownerid,dealer_account__r.name,RFP_Receipt_Date__c,RFP_Expected_Date__c,next_phase__c,Name,CBT_Tier_2__c,Ownerfullname__c,Region__c,RecordTypeId,AccountId,Opportunity_Owner_formula__c,SBU__c,Appendix_Review_Engineer__r.email,account.owner.email,License_Draft__c,Record_Type_Name__c,License_Review__c,Workbook_Complete__c,WorkbookComplete__c,Engineer_Manager_Review__c,Engineer_Manager_Review_Date__c,Account_manager_review_Date__c,Account_Contact_Name__c,Account_Contact_Name__r.Primary_Email_Address__c,Record_Data_Owner__c,Record_Data_Owner__r.Primary_Email_Address__c,BusinessContact__c,BusinessContact__r.email,HIPI_Accounts__c,
        (select id,Opportunity__c,user__c,user__r.IsPortalEnabled,user__r.Name,Is_User_Active__c,Opportunity_Owner_Id__c from opportunity_sales_teams__r where  Opportunity__c in :listObjOppNew),
        (select Id,stage__c,actual_date__c,serial_no__c,name,completion_date__c,Opportunity__c,Opportunity_Type__c from Opportunity_gates__r order by serial_no__c asc),
        (select id from opportunitylineitems),
        (select id,OpportunityAccessLevel,UserOrGroupId from  Shares where OpportunityId in: listObjOppNew 
            and OpportunityAccessLevel = 'Read'and UserOrGroupId = :label.D_S_Group),       
        (select id,BGA_Dealer_Name__c,Opportunity_Owner__c  from Cases__r where Opportunity__c in:listObjOppNew),(select id,Wokflow_Name__c,Opportunity_Name__c,Opportunity_Number__c,Opportunity_Description__c from Workflow_Details__r),Request_Contract_Number__c,HIPI_CONTRACT_NUMBER__c from opportunity where id in:listObjOppNew]);

        // Opportunity_UpdateStatus //
        //Provide Access
        List<Opportunity_Sales_Team__c> teamlist = new List<Opportunity_Sales_Team__c>();
        List<OpportunityShare> oppshare = new List<OpportunityShare> ();
        List<OpportunityShare> oppshare1 = new List<OpportunityShare> ();
        List<Opportunity_Sales_Team__c> prevmembers = new List<Opportunity_Sales_Team__c>();
        //Provide access
        String opid;
        //SF2SF INTEGRATION STARTS            
        Set<id> setList1 = new Set<id>();
       /* List<Opportunity> draftplafOppToUpdate = new List<Opportunity>();
        Date closeDate = [Select EndDate From Period Where type = 'Quarter' and StartDate = THIS_FISCAL_QUARTER].EndDate;
        decimal draft1;*/
        Messaging.SingleEmailMessage MPMmail = new Messaging.SingleEmailMessage();
        set<id> appendixengid = new set<id>();
        string appendixenggemail = '';
        string accowneremail = '';
        set<id> accownerid = new set<id>();
        List<Opportunity> Opportunitylst = new List<Opportunity>(); 
        Opportunitylst = mapOppFinal.values();      
        //SF2SF INTEGRATION ENDS
        
        for(Opportunity opp: listObjOppNew){
            //updateeGreensheet//
            //Code change for SR INC000005896880 starts          
            /************** provide access *///////
            //oppmap.put(opp.id,opp); 
            if((opp.OwnerId!=null && opp.OwnerId!=oldmap.get(opp.id).OwnerId)||(opp.SBU__c!=null&& opp.SBU__c!=oldmap.get(opp.id).SBU__c)|| (opp.Name!=null&& opp.Name!=oldmap.get(opp.id).Name) ||
            (opp.CBT_Tier_2__c!=null&& opp.CBT_Tier_2__c!=oldmap.get(opp.id).CBT_Tier_2__c) ||( opp.Record_Type_Name__c!=null&& opp.Record_Type_Name__c!=oldmap.get(opp.id).Record_Type_Name__c) || (opp.AccountId!=null && opp.AccountId!=oldmap.get(opp.id).AccountId) || (opp.Region__c!=null && opp.Region__c!=oldmap.get(opp.id).Region__c) )
            {
                wddata=mapOppFinal.get(opp.Id).Workflow_Details__r;
                system.debug('LISTTTTT'+wddata);
                for(Workflow_Details__c wd:wddata)
                {
                    system.debug('AMINNNN1stfor');
                    system.debug('NNNN'+mapOppFinal.get(opp.id).OwnerId);
                    system.debug('WWWWW'+oldmap.get(opp.id).Ownerid);
                    if(mapOppFinal.get(opp.id).OwnerId!=null&& mapOppFinal.get(opp.id).Ownerid!=oldmap.get(opp.id).Ownerid)
                    {
                        system.debug('AMINNNNOWNER');
                        system.debug('CHECKKKK'+ mapOppFinal.get(opp.id).Ownerfullname__c);
                        wd.Opportunity_Lead_Owner__c=mapOppFinal.get(opp.id).Ownerfullname__c;
                    }
                    if(mapOppFinal.get(opp.id).Name!=null&& mapOppFinal.get(opp.id).Name!=oldmap.get(opp.id).Name)
                    {
                        system.debug('NAMEEEEE');
                        wd.Opportunity_Name__c=mapOppFinal.get(opp.id).Name;
                    }
                    if(mapOppFinal.get(opp.id).SBU__c!=null&& mapOppFinal.get(opp.id).SBU__c!=oldmap.get(opp.id).SBU__c && mapOppFinal.get(opp.id).SBU__c=='ATR' )
                    {
                        system.debug('ATRRRRRRRRRRR');
                        wd.ATR__c=True;
                        wd.BG_A__c=False;
                        wd.Defence_Space__c=False;
                        system.debug('ATR'+wd.ATR__c);
                    }
                    else if(mapOppFinal.get(opp.id).SBU__c!=null&& mapOppFinal.get(opp.id).SBU__c!=oldmap.get(opp.id).SBU__c && mapOppFinal.get(opp.id).SBU__c=='BGA' )
                    {
                        system.debug('BGAAAAAAAAAAAA');
                        wd.ATR__c=False;
                        wd.BG_A__c=True;
                        wd.Defence_Space__c=False;
                    }
                    else if(mapOppFinal.get(opp.id).SBU__c!=null&& mapOppFinal.get(opp.id).SBU__c!=oldmap.get(opp.id).SBU__c && mapOppFinal.get(opp.id).SBU__c=='D&S' )
                    {
                        system.debug('D&SSSSSSSSSSS');
                        wd.ATR__c=False;
                        wd.BG_A__c=False;
                        wd.Defence_Space__c=True;
                    }
                    else 
                    {
                        wd.ATR__c=False;
                        wd.BG_A__c=False;
                        wd.Defence_Space__c=False;
                    }
                    if((mapOppFinal.get(opp.id).CBT_Tier_2__c!=null&& mapOppFinal.get(opp.id).CBT_Tier_2__c!=oldmap.get(opp.id).CBT_Tier_2__c && mapOppFinal.get(opp.id).CBT_Tier_2__c=='Airlines') ) 
                    {
                        wd.Airlines__c=True;
                        wd.Airbus__c=False;
                        wd.RACC__c=False;
                        wd.Boeing__c=False;
                        wd.HTSI__c=False;
                    }
                    else if((mapOppFinal.get(opp.id).CBT_Tier_2__c!=null&& mapOppFinal.get(opp.id).CBT_Tier_2__c!=oldmap.get(opp.id).CBT_Tier_2__c && mapOppFinal.get(opp.id).CBT_Tier_2__c=='Airbus') )
                    {
                        wd.Airlines__c=False;
                        wd.Airbus__c=True;
                        wd.RACC__c=False;
                        wd.Boeing__c=False;
                        wd.HTSI__c=False;
                    }
                    else if((mapOppFinal.get(opp.id).CBT_Tier_2__c!=null&& mapOppFinal.get(opp.id).CBT_Tier_2__c!=oldmap.get(opp.id).CBT_Tier_2__c && mapOppFinal.get(opp.id).CBT_Tier_2__c=='Boeing ATR') )
                    {
                        wd.Airlines__c=False;
                        wd.Airbus__c=False;
                        wd.RACC__c=False;
                        wd.Boeing__c=True;
                        wd.HTSI__c=False;
                    }
                    else if((mapOppFinal.get(opp.id).CBT_Tier_2__c!=null&& mapOppFinal.get(opp.id).CBT_Tier_2__c!=oldmap.get(opp.id).CBT_Tier_2__c && mapOppFinal.get(opp.id).CBT_Tier_2__c=='Components Business'))
                    {
                        wd.Airlines__c=False;
                        wd.Airbus__c=False;
                        wd.RACC__c=True;
                        wd.Boeing__c=False;
                        wd.HTSI__c=False;
                    }
                    else if((mapOppFinal.get(opp.id).CBT_Tier_2__c!=null&& mapOppFinal.get(opp.id).CBT_Tier_2__c!=oldmap.get(opp.id).CBT_Tier_2__c && mapOppFinal.get(opp.id).CBT_Tier_2__c=='HTSI') )
                    {
                        wd.Airlines__c=False;
                        wd.Airbus__c=False;
                        wd.RACC__c=False;
                        wd.Boeing__c=False;
                        wd.HTSI__c=True;
                    }
                    else
                    {
                        wd.Airlines__c=False;
                        wd.Airbus__c=False;
                        wd.RACC__c=False;
                        wd.Boeing__c=False;
                        wd.HTSI__c=False;
                    }                 
                    if(mapOppFinal.get(opp.id).RecordTypeId!=null&& mapOppFinal.get(opp.id).RecordTypeId!=oldmap.get(opp.id).RecordTypeId && (mapOppFinal.get(opp.id).RecordTypeId==label.AM_Catalog || mapOppFinal.get(opp.id).RecordTypeId==label.AM_Complex || mapOppFinal.get(opp.id).RecordTypeId==label.AM_Standard))
                    {
                        wd.AM__c=True;
                        wd.OE__c=False;           
                    }
                    else if(mapOppFinal.get(opp.id).RecordTypeId!=null&& mapOppFinal.get(opp.id).RecordTypeId!=oldmap.get(opp.id).RecordTypeId && (mapOppFinal.get(opp.id).RecordTypeId==label.OE_Complex || mapOppFinal.get(opp.id).RecordTypeId==label.OE_Standard))
                    {
                        wd.AM__c=False;
                        wd.OE__c=True;
                    }
                    else
                    {
                        wd.AM__c=False;
                        wd.OE__c=False;
                    }
                    if(mapOppFinal.get(opp.id).AccountId!=null&& mapOppFinal.get(opp.id).AccountId!=oldmap.get(opp.id).AccountId)
                    {
                        wd.Customer_Name__c=mapOppFinal.get(opp.id).AccountId;
                        system.debug('ACOUNTTTTTTTTTTTT'+wd.Customer_Name__c);
                    }
                    if((mapOppFinal.get(opp.id).Region__c!=null&& mapOppFinal.get(opp.id).Region__c!=oldmap.get(opp.id).Region__c && mapOppFinal.get(opp.id).Region__c=='Americas') )
                    {
                        wd.Americas__c=True;
                        wd.APAC__c=False;
                        wd.EMEAI__c=False;
                        wd.Global__c=False;
                    }
                    else if((mapOppFinal.get(opp.id).Region__c!=null&& mapOppFinal.get(opp.id).Region__c!=oldmap.get(opp.id).Region__c && mapOppFinal.get(opp.id).Region__c=='Asia/Pacific Rim') )
                    {
                        wd.Americas__c=False;
                        wd.APAC__c=True;
                        wd.EMEAI__c=False;
                        wd.Global__c=False;
                    }
                    else if((mapOppFinal.get(opp.id).Region__c!=null&& mapOppFinal.get(opp.id).Region__c!=oldmap.get(opp.id).Region__c && mapOppFinal.get(opp.id).Region__c=='Europe/MiddleEast/Africa/India') )
                    {
                        wd.Americas__c=False;
                        wd.APAC__c=False;
                        wd.EMEAI__c=True;
                        wd.Global__c=False;
                    }
                    else
                    {
                        wd.Americas__c=False;
                        wd.APAC__c=False;
                        wd.EMEAI__c=False;
                        wd.Global__c=True;
                    }
                    wdlist.add(wd);
                    system.debug('WDDDD'+wdlist);
                }
            }
            //Code change for SR INC000005896880 ends
             if(
            ((opp.Is_Restricted_Opportunity__c == True && opp.Is_Follow_On_Opportunity__c == True) && (oldmap.get(opp.id).Is_Restricted_Opportunity__c == False || oldmap.get(opp.id).Is_Follow_On_Opportunity__c == False))
            ||
            ((opp.Is_Restricted_Opportunity__c == True && opp.Is_Follow_On_Opportunity__c == false) && (oldmap.get(opp.id).Is_Restricted_Opportunity__c == False || oldmap.get(opp.id).Is_Follow_On_Opportunity__c == true))
            )
            {
                System.debug('inside afterupdate 57');
                oppshare.addAll(mapOppFinal.get(opp.id).shares);
            }
            if(
            ((opp.Is_Restricted_Opportunity__c == false && opp.Is_Follow_On_Opportunity__c == true) && (oldmap.get(opp.id).Is_Restricted_Opportunity__c == true || oldmap.get(opp.id).Is_Follow_On_Opportunity__c == false))
            ||
            ((opp.Is_Restricted_Opportunity__c == false && opp.Is_Follow_On_Opportunity__c == false) && (oldmap.get(opp.id).Is_Restricted_Opportunity__c == true || oldmap.get(opp.id).Is_Follow_On_Opportunity__c == true))
            )
            {
                System.debug('inside afterupdate 66'); 
                OpportunityShare s = new OpportunityShare();
                s.UserOrGroupId = label.D_S_Group;
                s.OpportunityAccessLevel = 'Read' ;
                s.OpportunityId =opp.id;
                oppshare1.add(s);       
            }
            // Removed &&opp.record_type_name__c!= 'BGA OE' && opp.record_type_name__c!= 'BGA AM'  condition from below if.
            if(opp.OwnerId!=oldmap.get(opp.id).OwnerId)
            {   
                //idlist3.add(lstopp[i]);
                System.debug('inside afterupdate 77');
                prevmembers = mapOppFinal.get(opp.id).opportunity_sales_teams__r;
                List<String> str = new List<String>();    
                for(integer i=0;i<prevmembers.size();i++)
                {
                
                    OpportunityShare s1 = new OpportunityShare();
                    if(prevmembers[i].user__c!=null)
                        s1.UserOrGroupId = prevmembers[i].user__c;
                    s1.OpportunityAccessLevel = 'Edit' ;
                    s1.OpportunityId =prevmembers[i].opportunity__c;
                    if(prevmembers[i].user__r.IsPortalEnabled==true)
                    //start added to fix SR 388989
                        //oppmap.get(prevmembers[i].opportunity__c).adderror('Found Portal User in Opportunity team. Please remove '+prevmembers[i].user__r.name+' from Opportunity Team.'); 
                        opp.adderror('Found Portal User in Opportunity team. Please remove '+prevmembers[i].user__r.name+' from Opportunity Team.'); 
                    //end added to fix SR 388989
                    else if(prevmembers[i].is_user_active__c=='True'&& prevmembers[i].user__c != prevmembers[i].Opportunity_Owner_Id__c)
                       oppshare1.add(s1);
                
                string sy = prevmembers[i].Opportunity__c  ;
                string sy1 =prevmembers[i].user__c;
                str.add(sy+sy1);
                }
                integer var = 0;
                Opportunity_Sales_Team__c teamMember=new Opportunity_Sales_Team__c  ();
                teamMember.Opportunity__c=opp.id;
                teamMember.user__c=opp.ownerId;
                string tm1 = teamMember.Opportunity__c  ;
                string tm2 =teamMember.user__c;
                String  str1= tm1+ tm2 ;
                for(integer j=0;j<str.size();j++)
                {
                    if(str1 == str[j]){
                        var = 1;
                        break;
                    }           
                }
                if(var != 1)
                {
                    teamlist.add(teamMember);
                }
            }
                    
            /*********** provide access ***/
            if(opp.sbu__C == 'D&S' && opp.Record_Type_name__c == 'D&S Standard' && opp.RFP_Receipt_Date__c !=null 
            && oldMap.get(opp.id).RFP_Receipt_Date__c!=opp.RFP_Receipt_Date__c 
            ){
                //oppId.add(opp);
                oppGate = mapOppFinal.get(opp.id).Opportunity_gates__r;
                for(Opportunity_Gate__c opg:oppGate){
                    if(opg.name == 'Solicitation Review')
                    {
                        if(mapOppFinal.get(opp.id).RFP_Expected_Date__c!=null){
                            opg.Completion_Date__c = mapOppFinal.get(opp.id).RFP_Expected_Date__c;
                        }else{
                            opg.Completion_Date__c = mapOppFinal.get(opp.id).RFP_Receipt_Date__c;
                        }
                        opg.Actual_Date__c = mapOppFinal.get(opp.id).RFP_Receipt_Date__c;
                         updateOPG.add(opg);
                    }
                }
            }
            // Opportunity_UpdateStatus //            
            if(OldMap.get(opp.id).dealer_account__c != opp.dealer_account__c || OldMap.get(opp.id).ownerid != opp.ownerid )
            {
                caseupdate = mapOppFinal.get(opp.id).cases__r;
                System.debug('caseupdate123'+mapOppFinal.get(opp.id).cases__r);
                for(Integer i=0; i< caseupdate.size(); i++)
                {
                  System.debug('caseupdate456'+caseupdate.size());
                  if(OldMap.get(opp.id).dealer_account__c != opp.dealer_account__c)
                    caseupdate[i].BGA_Dealer_Name__c = mapOppFinal.get(opp.id).dealer_account__r.name;
                  if(OldMap.get(opp.id).ownerid != opp.ownerid)
                    caseupdate[i].Opportunity_Owner__c = mapOppFinal.get(opp.id).ownerid;
                  lstCaseUpdt.add(caseupdate[i]);
                }       
            }         
            if(opp.StageName!=oldmap.get(opp.id).StageName && (opp.Record_Type_Name__c == 'D&S Focus'|| opp.Record_Type_Name__c == 'D&S Key' 
            ||opp.Record_Type_Name__c == 'D&S Standard' || opp.Record_Type_Name__c == 'D&S PrePriced' || opp.Record_Type_Name__c == 'D&S Run Rate' ||opp.Record_Type_Name__c == 'D&S Complex'))
            {
                og = mapOppFinal.get(opp.id).Opportunity_gates__r;
                system.debug('check111---->'+og.size());
                integer firstRec=0;
                for(integer j=0;j<og.size();j++)
                {           
                    if(opp.Id==og[j].Opportunity__C && opp.StageName==og[j].stage__c&& opp.Record_Type_Name__C== og[j].opportunity_type__c && firstRec==0){
                        d1 = og[j].serial_no__C;
                        system.debug('sumiiiiiiiiii'+og[j].name);
                        nextphase = og[j].name;
                        nextdate = og[j].completion_date__c;
                        firstRec=1;
                        
                    }//end of if
                    if(d1>=1 && opp.Id==og[j].Opportunity__C && opp.Record_Type_Name__C== og[j].opportunity_type__c  && og[j].serial_no__c >= d1){
                        og[j].Actual_date__c=null;  
                        og1.add(og[j]);
                    }           
                    if(opp.StageName=='Closed Won'||
                        opp.StageName=='Closed Lost'||opp.StageName=='Closed Cancelled')
                    {        
                        system.debug('check111---->'+og.size());
                        og[j].Is_Opportunity_Closed__c = true;
                        og2.add(og[j]);
                    }          
                }//end of for
                if( !( opp.stagename.contains('Closed Won' )))
                {       
                    if(nextphase!=null)
                    {
                        Opportunity tempopp = mapOppFinal.get(opp.id);
                        tempopp .next_phase__c = nextphase;
                        tempopp .next_phase_date__c= nextdate ;
                        listOppToUpdate.add(tempopp);
                    }
                }               
            }// end if
            
            
            
            
            //opportunityProducts_Date//
            
            // Opportunity_UpdateStatus //
            //SF2SF Integration
            system.debug('opp.StageName'+opp.StageName);
            system.debug('opp.Record_Type_Name__c'+opp.Record_Type_Name__c);
            if(((opp.StageName!=oldmap.get(opp.id).StageName) ||(opp.Deal_Status__c!=oldmap.get(opp.id).Deal_Status__c)||(opp.CloseDate!=oldmap.get(opp.id).CloseDate)||(opp.Total_Value_of_Agmt_K_Text__c!=oldmap.get(opp.id).Total_Value_of_Agmt_K_Text__c)||(opp.Contract_Term_In_Years__c!=oldmap.get(opp.id).Contract_Term_In_Years__c)||(opp.Value_in_Q1_K_Text__c!=oldmap.get(opp.id).Value_in_Q1_K_Text__c)||(opp.Value_in_Q2_K_Text__c!=oldmap.get(opp.id).Value_in_Q2_K_Text__c)||(opp.Value_in_Q3_K_Text__c!=oldmap.get(opp.id).Value_in_Q3_K_Text__c)||(opp.Value_in_Q4_K_Text__c!=oldmap.get(opp.id).Value_in_Q4_K_Text__c)||(opp.Year_2__c!=oldmap.get(opp.id).Year_2__c)||(opp.Year_3__c!=oldmap.get(opp.id).Year_3__c)||(opp.Year_4__c!=oldmap.get(opp.id).Year_4__c)||(opp.Year_5__c!=oldmap.get(opp.id).Year_5__c) ||(opp.HIPI_Accounts__c!=oldmap.get(opp.id).HIPI_Accounts__c) ||(opp.BusinessContact__c!=oldmap.get(opp.id).BusinessContact__c) ||(opp.Value_in_Current_Year_Jan_Dec_K__c!= oldmap.get(opp.id).Value_in_Current_Year_Jan_Dec_K__c))  && (opp.Record_Type_Name__c == 'M&PM SIM Licensing') && (opp.Corp_HIPI_Opportunity_Number__c != null))
            {
                system.debug('inside opp2'); 
                setList1.add(opp.id);               
            }
            if((opp.Submit_to_Licensing__c!=oldmap.get(opp.id).Submit_to_Licensing__c) && (opp.Record_Type_Name__c == 'M&PM SIM Licensing') 
            && (opp.Corp_HIPI_Opportunity_Number__c == null)
            )
            {
                system.debug('inside opp2'); 
                setList1.add(opp.id);               
            }
            
           /* if((opp.CUSTOMER_LICENSE_NEED_DATE__c != null) && (opp.Record_Type_Name__c == 'M&PM SIM Licensing') ) 
            {
                Date closeDate1=opp.CUSTOMER_LICENSE_NEED_DATE__c;
                opp.Current_end_of_fiscal_quarter_date1__c = closedate;
                system.debug('closeDate1----->'+closeDate1);
                integer diff;
                if(closedate1<closedate)
                {
                  system.debug('insideif1----->'+closedate1);
                  system.debug('insideif1----->'+closedate);
                  diff=closedate1.daysbetween(closedate);
                }
                else if(closedate1>closedate)
                {
                  system.debug('insideif2----->'+closedate1);
                  diff=closedate.daysbetween(closedate1);  
                }
                
                if( opp.Current_end_of_fiscal_quarter_date1__c != oldmap.get(opp.id).Current_end_of_fiscal_quarter_date1__c){
                 if(closedate1<closedate)
                {
                  system.debug('insideif1----->'+closedate1);
                  system.debug('insideif1----->'+closedate);
                  diff=closedate1.daysbetween(closedate);
                }
                else if(closedate1>closedate)
                {
                  system.debug('insideif2----->'+closedate1);
                  diff=closedate.daysbetween(closedate1);  
                }
                
                    system.debug('insideif1----->000'+closedate);
                    system.debug('insideif1----->111'+closedate);
                }
                 
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
                
            }*/

           /* if(opp.Value_in_Current_Year_Jan_Dec_K__c!= null && opp.Stagename!= 'Phase 3: Approvals' && (opp.Value_in_Current_Year_Jan_Dec_K__c!= oldmap.get(opp.id).Value_in_Current_Year_Jan_Dec_K__c) && opp.Value_in_Current_Year_Jan_Dec_K__c > '250')
                {
                    opp.stagename= 'Phase 3: Approvals';
                    optyupdate.add(opp); 
                }*/
                update optyupdate;
            /*if((opp.CUSTOMER_LICENSE_NEED_DATE__c == null)&&(opp.CUSTOMER_LICENSE_NEED_DATE__c!=oldmap.get(opp.id).CUSTOMER_LICENSE_NEED_DATE__c) && (opp.Record_Type_Name__c == 'M&PM SIM Licensing')) 
            {
                Opportunity tempopp = new opportunity(id=opp.id);
                draftplafOppToUpdate.add(tempopp);             
            }*/            
            //SF2SF Integration
        }       
        //SF2SF Integration
        string htmlbody1='';
        string htmlbody2='';
        string conid=Label.UFR_Cont_Id;
        Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
        List<Messaging.SingleEmailMessage> msgList = new List<Messaging.SingleEmailMessage>();
        List<Messaging.SingleEmailMessage> bulkEmails = new List<Messaging.SingleEmailMessage>();  
        if(AvoidRecursion.isFirstRun()){
        for(opportunity opp2:Opportunitylst)
        {                           
            System.debug('!@#$opp2.License_Draft__c'+opp2.License_Draft__c);
            
            if(((opp2.License_Draft__c != null && opp2.License_Draft__c == Date.Today())&&(opp2.License_Draft__c!=oldmap.get(opp2.id).License_Draft__c)&&(opp2.Record_Type_Name__c == 'M&PM SIM Licensing'))  || test.isrunningtest())
            {
                system.debug('!@#$licdraft-----'+opp2.License_Draft__c );
                if(opp2.Record_Data_Owner__c != null)
                {                   
                    System.debug('!@#$ inside if appendix engineer');
                    msg.setTargetObjectId(opp2.Record_Data_Owner__c);
                    msg.setTemplateId(label.Sim_License_Appendix_Eng);
                    msg.setWhatId(opp2.id);
                    msg.setOrgWideEmailAddressId(label.AeroNo_Reply_email_ID);               
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[]{ msg });                     
                } 
                else if(opp2.BusinessContact__c != null && (opp2.Engineer_Manager_Review__c  == False))
                {
                    System.debug('!@#$ inside if BC');
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
                                    bulkEmails.add(emailToSend);
                                    system.debug('Email Entry First***:'+bulkEmails.size());
                            }
                        }                                               
                }                                   
            }
            System.debug('!@#$opp2.Engineer_Manager_Review_Date__c '+opp2.Engineer_Manager_Review_Date__c );
            if(((opp2.Engineer_Manager_Review_Date__c != null)&&(opp2.Engineer_Manager_Review_Date__c !=oldmap.get(opp2.id).Engineer_Manager_Review_Date__c)&&(opp2.Record_Type_Name__c == 'M&PM SIM Licensing')) || test.isrunningtest())
            {
                if(opp2.BusinessContact__c != null)
                {
                     System.debug('!@#$ Manger Review Date Block inside if BC');
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
                                    bulkEmails.add(emailToSend);
                                    system.debug('Email Entry*****'+bulkEmails.size());
                            }
                        }                       
                } 
            } 
        }
        if(bulkEmails.size()>0){
          system.debug('Email Final Entry*****'+bulkEmails.size());
            Messaging.sendEmail(bulkEmails);
        }
        if(setList1.size()>0) {
            system.debug('inside if'+setList1.size());
            CallServicetoCreateClass1.classService(setList1);
        }
        }
       /* if(draftplafOppToUpdate.size()>0)
        {
            try
            {
                draftplafOppToUpdate[0].Current_end_of_fiscal_quarter_date1__c=closedate;
                if(string.valueof(draft1) != null)
                {
                draftplafOppToUpdate[0].Draft_Priority_Flag__c=string.valueof(draft1);
                update draftplafOppToUpdate;
                }
                else
                {
                draftplafOppToUpdate[0].Draft_Priority_Flag__c='';
                update draftplafOppToUpdate;
                }
            }
            catch(Exception e)
            {
                System.debug('Exception in updating opportunity in OppAfterUpdateHelperclass'+e);
            }
        } */
        //SF2SF Integration
        if(wdlist.size()>0)
        {
            update wdlist;
        }
        // Opportunity_UpdateStatus //
        if(updateOPG.size()>0)
        {
            updateTollgate.addAll(updateOPG);
        }
        if(og1.size()>0)
        {
            updateTollgate.addAll(og1);
        }
        if(og2.size()>0)
        {
            updateTollgate.addAll(og2);
        }
        if(updateTollgate.size()>0)
        {
            update updateTollgate;
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
        if(lstCaseUpdt.size()>0){
            update lstCaseUpdt;
        }
        // Opportunity_UpdateStatus //
                        
        // EmailAlertOnOpportunityUpdates //
        integer errLoc = 0;
        string recId = '';                
        string debug='';
        // EmailAlertOnOpportunityUpdates //    
        
        if(Trigger.new.size() == 1 )
        {
            for (Opportunity objOpp : listObjOppNew)
            {   
                // EmailAlertOnOpportunityUpdates //
                System.debug('Line 153');
                recId = objOpp.Id;
                try
                {                               
                    if(objOpp.recordtypeid == label.BGA_OE_Opportunity || objOpp.recordtypeid == label.Opportunity_BGA_Recordtype)
                    {
                        //recId = objOpp.Id;
                        errLoc = 10;    
                        /*string serverUrl   =                'https://na1.salesforce.com/'; //https://cs1.salesforce.com/';*/
                        string serverUrl = URL.getSalesforceBaseUrl().toExternalForm() +'/';
                        string htmlHeader  =                '<html><head>'
                                                    +       '<style>.tableborder{   border-bottom:3px solid #e39321;}.fontlabel{    font-family:Arial, Helvetica, sans-serif;   color:#333; font-size:100%;}</style>'
                                                    +       '</head><body class=fontlabel>';
                        errLoc = 20;                            
                        string htmlFotter  =                '</body></html>';
                        
                        string htmlBdy =  'Dear Opportunity Team,<br><br>Following information is updated for Opportunity <a href='+serverUrl+objOpp.Id+'>'+ objOpp.Name +'</a><br><br>';
                        
                        string oldCoOwner = (oldMap.get(objOpp.id).Opportunity_Co_owner_new__c == null?'None' : oldMap.get(objOpp.id).Opportunity_Co_owner_new__c);                
                        string newCoOwner = (objOpp.Opportunity_Co_owner_new__c         == null?'None':objOpp.Opportunity_Co_owner_new__c);
                        
                        errLoc = 30;
                        string oldNotes   = (oldMap.get(objOpp.id).Opportunity_Notes__c == null ? 'None':oldMap.get(objOpp.id).Opportunity_Notes__c);
                        string newNotes   = (objOpp.Opportunity_Notes__c == null ? 'None':objOpp.Opportunity_Notes__c);
                        string oldStage   =  (oldMap.get(objOpp.id).StageName == null ? 'None': oldMap.get(objOpp.id).StageName);                    
                        string newStage = (objOpp.StageName == null ? 'None':objOpp.StageName);                    
                       
                        errLoc = 40;                     
                        if(     oldNotes.compareTo(newNotes)        <> 0 
                            ||  oldStage.compareTo(newStage)        <> 0
                            ||  oldCoOwner.compareTo(newCoOwner)    <> 0
                          )
                        {
                            //debug = debug + 'step 1<br>';
                            errLoc = 50;                        
                            string qryOldValOppCoOwner= oldMap.get(objOpp.id).Opportunity_Co_owner_new__c;                       
                            
                            errLoc = 80;
                            //List<Opportunity_Sales_Team__c> objOppTeamList = [select User__r.Email from Opportunity_Sales_Team__c where Opportunity__r.Id = :objOpp.Id LIMIT 10];          
                            List<Opportunity_Sales_Team__c> objOppTeamList = mapOppFinal.get(objOpp.id).Opportunity_Sales_Teams__r;
                            List<User> objOppOwnerEmail = [select Email, ID, Name from User WHERE Id  = :objOpp.OwnerId OR ID = :newCoOwner OR ID = :oldCoOwner OR ID = :objOpp.Opportunity_Co_owner_new__c OR ID =  :qryOldValOppCoOwner ];
                            string[] emailList = null;                        
                            if(objOppTeamList != null)
                            {
                                errLoc = 90;
                                integer ownerCnt = (objOppOwnerEmail == null ? 0 : objOppOwnerEmail.size());                            
                                emailList = new string[objOppTeamList.size()+ownerCnt] ;                            
                                //debug = debug + 'step 4 - '+(objOppTeamList.size()+ownerCnt+1)+' - '+ emailList.size() +'<br>';                            
                                for (integer j=0 ; j < ownerCnt; j++)
                                {
                                     errLoc = 100;
                                     //debug = debug + 'step 5 - '+ j +  ' -'+objOppOwnerEmail[j].Email+'<br>';
                                     emailList[j] = objOppOwnerEmail[j].Email ;
                                } 
                                for (integer j=0 ; j < objOppTeamList.size(); j++)
                                {
                                    errLoc = 110;
                                    //debug = debug + 'step 6 - '+ (ownerCnt+j) +  ' -'+objOppTeamList[j].User.Email+'<br>';
                                    emailList[ownerCnt+j] = objOppTeamList[j].User__r.Email;
                                } 
                                //emailList[emailList.size()-1]='Sanjib.Chattopadhyay@Honeywell.com';
                                
                            }
                            else
                            {
                                errLoc = 120;
                                integer ownerCnt = (objOppOwnerEmail == null ? 0 : objOppOwnerEmail.size());
                                //debug = debug + 'step 7<br>';
                                emailList = new string[ownerCnt] ;
                                for (integer j=0 ; j < ownerCnt; j++)
                                {
                                    errLoc = 130;
                                     //debug = debug + 'step 8<br>';
                                     emailList[j] = objOppOwnerEmail[j].Email ;
                                }         
                            }                    
                            if(oldCoOwner.compareTo(newCoOwner) <> 0)
                            {
                                List<User> username = new List<User>([Select Id , Name from USer where id =: oldCoOwner OR id =: newCoOwner ]);
                                Map<Id,String> namemap = new Map<Id,String>();
                                for(User U : username){
                                    namemap.put(u.ID,u.Name);
                                }
                                string oldco,newco;
                                if(oldCoOwner!='None')
                                   oldco=  namemap.get(oldCoOwner);
                                else
                                  oldco= 'None';
                                 system.debug('hhh'+oldco);
                                if(newCoOwner!='None')    
                                    newco =  namemap.get(newCoOwner);                            
                                else
                                    newco =  'None';              
                                errLoc = 140;
                                htmlBdy = htmlBdy 
                                            +   '<b>Opportunity Co-Owner :</b>' 
                                            +   oldco
                                            +   ' To <b>' 
                                            +   newco
                                            +   '</b><br><br>'
                                            ;
                            }
                            
                            if(oldStage.compareTo(newStage)<>0)
                            {
                                errLoc = 150;
                                htmlBdy = htmlBdy 
                                                +   '<b>Stage Name :</b>' 
                                            +   oldStage
                                            +   ' To <b>' 
                                            +   newStage
                                            +   '</b><br><br>'
                                            ;
                            }
                            if(oldNotes.compareTo(newNotes) <> 0 )
                            {
                                errLoc = 160;
                                htmlBdy = htmlBdy 
                                                    +   '<b>Opportunity Notes :</b>' 
                                                    +   newNotes;
                            }                        
                            htmlBdy = htmlBdy + '<br><br>Thank you';
                            //debug = debug + 'step 9<br>';                        
                            string[] send_debug = new string[1];
                            // send_debug[0] = 'varun.nirala@honeywell.com';                        
                            errLoc = 170;
                            if(emailList!= null && emailList.size() > 1)
                            {                                    
                                System.debug('Line 280');
                                sendEmail.SendSimpleEmailNotification( emailList,
                                                                    'Opportunity updated: '+ objOpp.Name,
                                                                    htmlHeader + htmlBdy + htmlFotter );
                            }                  
                        
                        }   
                 
                    }// End If
                }catch(Exception e){
                    utilClass.createErrorLog('EmailAlertOnOpportunityUpdates',
                                         'EmailAlertOnOpportunityUpdates',
                                         'errLoc - ' + errLoc + ' - ' + recId + ' - ' + e.getMessage() );
                
                }
                // EmailAlertOnOpportunityUpdates //
                //commented the line of code as per Ed's instruction//
                // Opportunity_On_CloseDate_Update_Adjust_Prod_Dates //
                // If close date is changed
              /*  try
                {
                    if(objOpp.CloseDate <> oldMap.get(objOpp.id).CloseDate && (objOpp.record_type_name__c == 'BGA OE' || objOpp.record_type_name__c == 'BGA AM'))
                    {
                        errLoc = 1-20;
                        // Query all the product under the given opportunity where ServiceDate less than Opportunity CloseDate
                        List<OpportunityLineItem> lisiobjOpp = [select Id from OpportunityLineItem where OpportunityId = :objOpp.Id and ServiceDate < :objOpp.CloseDate ];
                        errLoc = 1-30;
                        if(lisiobjOpp != null)
                        {
                                // Loop count Maximun 20 times, Salesforce limitation to have only 20 DMLs per execution.
                                List<OpportunityLineItem> oliList = new List<OpportunityLineItem>();
                                for(integer i=0;i<lisiobjOpp.size() && lisiobjOpp.size() <=20 ;i++)
                                {
                                    errLoc = 1-40 + i;
                                    // Update opportunity product with the Opportunity close date where opporunity product service date is less than opportunity product date.
                                    OpportunityLineItem oli = new OpportunityLineItem(Id=lisiobjOpp[i].Id);
                                    oli.ServiceDate     = objOpp.CloseDate   ;
                                    //update oli;
                                    oliList.add(oli);
                                }
                                if(oliList.size()>0){
                                    update oliList;
                                }
                                //If more than 20 products are required to be updated then prompt user with message.
                                if(lisiobjOpp.size() > 20)
                                {
                                    errLoc = 1-60;
                                    Trigger.new[0].addError('Dear User, you have '+lisiobjOpp.size()+' products with Date earlier than new Opportunity Close Date ('+objOpp.CloseDate+'). Opportunity product(s) can not have Date earlier than Opportunity Close Date.');
                                }
                        }
                    }  //end if
                }
                catch(Exception e)
                {
                    utilClass.createErrorLog
                         (
                         'Opportunity_On_CloseDate_Update_Adjust_Prod_Dates',
                         'Opportunity_On_CloseDate_Update_Adjust_Prod_Dates',
                         'errLoc - ' + errLoc + ' - ' + recId + ' - ' + e.getMessage()
                         );
                
                }
                // Opportunity_On_CloseDate_Update_Adjust_Prod_Dates //
                        
            }// End For*/
        }
        OppClassForPublicMethods objtemp = new OppClassForPublicMethods();
        List<Opportunity_Sales_Team__c> tempOppList = objtemp.Opportunity_insert_opportunityteam(listObjOppNew,oldMap);
        objtemp.changeRecordTypeMethod(listObjOppNew,oldMap);
        System.debug('tempOppList1:::'+tempOppList.size());
        // Provide Access //
        if(oppshare.size()>0)
        {
                            System.debug('inside afterupdate 435');
            delete oppshare;
        }
        
        if(oppshare1.size()>0)
        {
          try{
                          System.debug('inside afterupdate 442');
            insert oppshare1;
            }
            catch (Exception e) 
            {
                for(OpportunityShare opp: oppshare1)
                  opp.adderror('Opportunity or usergroup is not Valid'+e.getMessage());
                 
            }
        }
        if(teamlist.size()>0)
        {
            system.debug('146945'+teamlist.size());
             system.debug('146945'+teamlist[0]);
            //insert teamlist;
            tempOppList.addAll(teamlist);
        }
        // Provide access //
        if(tempOppList.size()>0)
        {
            System.debug('tempOppList2:::'+tempOppList.size());
            try 
            {                
                System.debug('tempOppList3:::'+tempOppList.size());
                insert tempOppList;
            }catch(Exception ex){        
                System.debug('Exception in inserting opportunity Sales Team in OppAfterInsertHelperclass'+ex);
            }
        }
        
   // Changes start for INC000006213026
   /*// Requested by Ed to comment this temporarily //
    for(Opportunity opp: listObjOppNew){
        if((opp.Tech_Sales_Product_Area__c != oldMap.get(opp.id).Tech_Sales_Product_Area__c) || (opp.AccountId != null && opp.AccountId != oldMap.get(opp.id).AccountId || opp.SBU__c != oldMap.get(opp.id).SBU__c || opp.CBT_Tier_2__c != oldMap.get(opp.id).CBT_Tier_2__c ) ){
            opprodupdateids.add(opp.id);
        }
        if(opp.Parent_Opportunity__c!=null && (opp.Win_Loss_Amount__c != oldMap.get(opp.id).Win_Loss_Amount__c 
        || opp.Win_Loss_Proposal_Amount__c != oldMap.get(opp.id).Win_Loss_Proposal_Amount__c)){
            opid = opp.Parent_Opportunity__c;
            system.debug('oppid+++++++++'+opid);
        }
    }
    if(opid!=null){
        System.debug('Inside opid:-----> '+opid);
        OppUpdate.opportunityfieldupdate(opid);             
    }
    if(opprodupdateids.size()>0){
            Map<id,opportunity> mapOpplineItemUpdate = new Map<id,opportunity>([SELECT Id,(select id,OpportunityAccountChange__c from OpportunityLineItems ) FROM Opportunity WHERE Id =:opprodupdateids]);
        
        for(id oppid : mapOpplineItemUpdate.keyset()){
            for(OpportunityLineItem oplt : mapOpplineItemUpdate.get(oppid).OpportunityLineItems){
                oplt.OpportunityAccountChange__c = true;
                lstoplt.add(oplt);
            }
        }
    }
    if(lstoplt.size()> 0){
         try
         {
             update lstoplt;
         }
         catch(Exception e)
         {
             System.debug('Exception in inserting opportunity in OppAfterInsertHelperclass'+e);
         }
    } 
     // Requested by Ed to comment this temporarily //*/
  // Changes End for INC000006213026
  
  
  //Changes Start for INC000008246504 
   /***********************************************Case creation block on Opportunity status update********************************************************/
     
       //Variable declaration
     set<Id> set_opp=new set<id>();
     map<Id,Id> map_accid=new map<Id,Id>();
     map<Id,Opportunity> map_acc=new map<Id,Opportunity>();
     map<Id,Id> map_accteam=new map<Id,Id>();
     map<id,list<Product2>> map_opportunityProductlist=new map<id,list<Product2>>();
     map<string,string> map_prodOpp=new map<string,string>();
     list<Opportunity> list_opp=new list<Opportunity>();
     list<Case> list_insertcase=new list<Case>();
     list<AccountTeamMember> list_accteam=new list<AccountTeamMember >();
     list<string> list_prdName=new list<string>();
     list<string> list_prodName=new list<string>();
     list<PO_tracker_Case_Creation_Products__c>polist=new list<PO_tracker_Case_Creation_Products__c>();
     boolean bool=False;
     
     
     id recordtypeid = label.RMU_EIS_Record_type;
    
     
     for(Opportunity op:listObjOppNew){
         if(oldmap.get(op.id).StageName!=newmap.get(op.id).StageName && op.StageName=='Closed Won'){
             set_opp.add(op.id);
             map_acc.put(op.Id,op);
             map_accid.put(op.AccountId,op.id);
             system.debug('accmap****************'+op);
             bool=true;
         }
     }
     //query all related opp product
     if(bool==true && bool_trans==True){
     list<OpportunityLineItem> list_oppprd=[Select Id, OpportunityId, PriceBookEntry.Product2Id, PriceBookEntry.Product2.Name from OpportunityLineItem where OpportunityId IN:set_opp];
     
     for(OpportunityLineItem p:list_oppprd){
         system.debug('>>>>>0'+p);
         list_prdName.add(p.PriceBookEntry.Product2.Name);
                
         map_prodOpp.put(p.PriceBookEntry.Product2.Name,p.OpportunityId);
     }
     //refined product list present in custom setting responible for case creation
     polist=[select name,Product_Name_del__c from PO_tracker_Case_Creation_Products__c where Product_Name_del__c in:list_prdName];
     for(PO_tracker_Case_Creation_Products__c p:polist)
     list_prodName.add(p.Product_Name_del__c);
     
     //query all the product record based on refined list
     List<Product2> list_product=[select id,Name from Product2 where Name IN:list_prodName];
     for(Product2 p:list_product){
         list<Product2> list_temp=new list<Product2>();
         if(map_opportunityProductlist.containskey(map_prodOpp.get(p.Name))){ 
             map_opportunityProductlist.get(map_prodOpp.get(p.Name)).add(p);
         }
         else{
             list_temp.add(p);
             map_opportunityProductlist.put(map_prodOpp.get(p.Name),list_temp);
             
         }
     }
     
     //list_opp=[select id,Name,AccountId,dealer_account__c,Aircraft_Ref__c,Make__c,Model__c,Serial_Number__c,Tail__c from Opportunity where id IN:set_opp];
     
     
     list_accteam=[select id,AccountId, UserId from AccountTeamMember where accountid IN: map_accid.keyset() and TeamMemberRole='Customer Service Manager'];
     
     for(AccountTeamMember acc: list_accteam)
       {
           if(map_accid.containskey(acc.accountid))
             map_accteam.put(map_accid.get(acc.accountid),acc.UserId);
       }
     
     for(Opportunity op : listObjOppNew){
         system.debug('>>>>>0'+map_opportunityProductlist.get(op.id));
         if(map_opportunityProductlist.get(op.id)!=null && oldmap.get(op.id).StageName!=newmap.get(op.id).StageName && op.StageName=='Closed Won'){
          for(Product2 p:map_opportunityProductlist.get(op.id)){
          case c= new case();
          c.RecordTypeId=recordtypeid;
          c.AccountId=map_acc.get(op.id).AccountId;
          c.Aircraft_Name__c=map_acc.get(op.id).Aircraft_Ref__c;
          c.Opportunity__c=op.id;
          c.Product__c=p.id;
          //change request INC000009709954 - status changed from Open to Done//
          c.Status='Done';
                  
          system.debug('accmap****************'+op);
          c.Subject=p.Name+' - '+map_acc.get(op.id).Model__c+' - '+map_acc.get(op.id).Serial_Number__c;
           
          c.Make__c=map_acc.get(op.id).Make__c;
          c.Model__c=map_acc.get(op.id).Model__c;
          c.Serial_Number__c=map_acc.get(op.id).Serial_Number__c;
         
          if(map_accteam.containskey(op.id))
             c.OwnerId=map_accteam.get(op.id);
          else
             c.OwnerId=label.Steve_Ferensak_User_Id;
               
                      
           c.BGA_Dealer_Name__c=map_acc.get(op.id).dealer_account__r.Name;
            
           list_insertcase.add(c);
         }
         }
     }
         if(!list_insertcase.isempty()){
         bool_trans=false;
        insert list_insertcase;
        }
    
    }    
    /******************************************************************************************************/
    //Changes End for INC000008246504  
   // }
    
    // code starts ********************************************************************************
     //public static void afterUpdateOpportunityProductsDate(List<Opportunity> listOppNew, List<Opportunity> listOppOld){
     
        //List<Opportunity> Opps=Trigger.new;
        List<Opportunity> Opps=listObjOppNew;
        List<OpportunityLineItem> Opp_prod_lst=new List<OpportunityLineItem>();
        Map<Id,Id> OppProdMap=new Map<Id,Id>();
        Map<Id,Date> OppProdMap_date=new Map<Id,Date>();
        OpportunityLineItem opp_Lineitem_update;
        Map<Id,Integer> diffdays=new map<Id,Integer>();
        Integer daysbet;
        
        for(Integer i=0;i<Opps.size();i++){
            if(listOppOld[i].CloseDate!=listObjOppNew[i].CloseDate && listObjOppNew[i].Push_Product_Date__c){
                daysbet= listOppOld[i].CloseDate.daysbetween(listObjOppNew[i].CloseDate);
                diffdays.put(Opps[i].id,daysbet);
                OppProdMap.put(listObjOppNew[i].Id,listObjOppNew[i].Id);
                OppProdMap_date.put(listObjOppNew[i].Id,listObjOppNew[i].CloseDate);
            }
        }
        System.Debug('diffdays'+diffdays);
        if(OppProdMap.size()>0){
            for(OpportunityLineItem Opp_prod : [Select ServiceDate, OpportunityId, Type__c,Blanket_Forecast__c,Revenue_Start_Date__c from OpportunityLineItem where OpportunityId IN:OppProdMap.keySet()]){
                if(Opp_prod.OpportunityId==OppProdMap.get(Opp_prod.OpportunityId)){ 
                    //Last 2 conditions are added as part of Ticket#220.
                    if(Opp_prod.ServiceDate != NULL && Opp_prod.Type__c == 'Forecast'){
                        opp_Lineitem_update =new OpportunityLineItem(Id=Opp_prod.Id);
                        opp_Lineitem_update.ServiceDate=Opp_prod.ServiceDate+diffdays.get(Opp_Prod.OpportunityId);
                        system.debug('diffdays value:'+diffdays.get(Opp_Prod.OpportunityId));
                        system.debug('Opp_prod.ServiceDat value:'+Opp_prod.ServiceDate);
                        system.debug('ServiceDate value:'+opp_Lineitem_update.ServiceDate);
                        Opp_prod_lst.add(opp_Lineitem_update);
                     }     
                }
            }
            System.debug('the product line date update with ===='+Opp_prod_lst);
        }
        if(Opp_prod_lst.size()>0){
            System.Debug('Opp_prod_lst'+Opp_prod_lst);
            try{
                update Opp_prod_lst;
            }
            catch(Exception e){
                System.Debug('Exception'+e);
            }
        }
    }
    // end *************************************************/
}
}