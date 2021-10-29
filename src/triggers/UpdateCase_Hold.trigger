/***********************************************************************************************************
* Company Name          : Honeywell Aero
* Name                  : UpdateCase_Hold 
* Description           : Trigger to update Hold time values
* 
* Modification History  :
* Date             Version No.    Modified by           Brief Description of Modification
* 12-02-2013       1.0            NTTDATA               Initial Version created
* 26-08-2014       1.1            NTTData               INC000006283200 (Shrivaths)- Sending alerts to the customers
* 25-09-2014       1.2            NTTData               INC000006701791(Shrivaths) -  Added condition so that email should not be fired on closure of the Case (67,73) 
* 12-Feb-2015      1.3            NTTDATA               INC000008286465 - ATR RMU Opportunity Creation from CLI
***********************************************************************************************************/
trigger UpdateCase_Hold on Case_Line_Item__c (after insert,after update) {
    set<id> cliid=new set<id>();
    set<id> caseid=new set<id>();
    set<Id> listIds = new set<Id>();
    boolean flag1=false;
    list<case>caslistt=new list<case>(); 
    list<case> Caselis=new list<case>();  
    list<Case_Line_Item__c> caslinelist=new list <Case_Line_Item__c>();
    list<case> cslist=new list<case>(); 
    list<case>updatelist=new list<case>();
    list<Case_Line_Item__c> linelist=new list <Case_Line_Item__c>();
    map<Id,Case_Line_Item__c> caselinemap= new map<Id,Case_Line_Item__c>();
    //Code added for SR# INC000008227994- New Change ATR RMU TOOL Start
    Opportunity objOpp = new Opportunity(); 
    List<Opportunity> lstOpp = new List<Opportunity>();   
    //Code added for SR# INC000008227994- New Change ATR RMU TOOL End
    set<id> idCasesForAlerts = new set<id>();
    system.debug('Before For loop');
    for (Case_Line_Item__c cl:trigger.new)
    {
        system.debug('inside for');
        if(
            /*commented for INC000009169188 (cl.recordtypeID==label.AverageTimeHold_RecID && ((cl.BusinessHold_Endtime__c!= null && (trigger.isupdate && cl.BusinessHold_Endtime__c!=trigger.oldmap.get(cl.id).BusinessHold_Endtime__c)) ||
(cl.Credithold_Endtime__c!=null && (trigger.isupdate && cl.Credithold_Endtime__c!=trigger.oldmap.get(cl.id).Credithold_Endtime__c))
|| (cl.Engineeringhold_Endtime__c!=null && (trigger.isupdate && cl.Engineeringhold_Endtime__c!=trigger.oldmap.get(cl.id).Engineeringhold_Endtime__c))
|| (cl.Exporthold_Endtime__c!=null && (trigger.isupdate && cl.Exporthold_Endtime__c!=trigger.oldmap.get(cl.id).Exporthold_Endtime__c))
|| (cl.Import_Hold_Endtime__c!=null && (trigger.isupdate && cl.Import_Hold_Endtime__c!=trigger.oldmap.get(cl.id).Import_Hold_Endtime__c))
||(cl.MTO_Endtime__c!=null && (trigger.isupdate && cl.MTO_Endtime__c!=trigger.oldmap.get(cl.id).MTO_Endtime__c))
||(cl.MTOCustomer_Endtime__c!=null && (trigger.isupdate && cl.MTOCustomer_Endtime__c!=trigger.oldmap.get(cl.id).MTOCustomer_Endtime__c))
||(cl.SupplyChainHold_Endtime__c!=null && (trigger.isupdate && cl.SupplyChainHold_Endtime__c!=trigger.oldmap.get(cl.id).SupplyChainHold_Endtime__c))
||(cl.PricingHold_Endtime__c!=null && (trigger.isupdate && cl.PricingHold_Endtime__c!=trigger.oldmap.get(cl.id).PricingHold_Endtime__c))
||(cl.QualityHold_Endtime__c!=null && (trigger.isupdate && cl.QualityHold_Endtime__c!=trigger.oldmap.get(cl.id).QualityHold_Endtime__c))))
//||(trigger.isinsert && Userinfo.getUserId()=='005a0000008FL7PAAW' && cl.Recordtypeid=='01213000001ZT3a'))
|| ||commented for INC000009169188 */
            (trigger.isinsert && Userinfo.getUserId()==label.ATR_API_User_id && cl.Recordtypeid==label.ATR_CaseLineItem_RT))
        {
            system.debug('Inside if');
            caseid.add(cl.Case_Number__c);
            cliid.add(cl.id);
            caselinemap.put(cl.Case_Number__c,cl);
        } 
        //INC000006283200 - send alerts to customers
        if(cl.Lineitemstatus__c == true && trigger.oldMap.get(cl.id).Lineitemstatus__c == false){
            idCasesForAlerts.add(cl.Case_Number__c);
        }
        //INC000006283200 - send alerts to customers
        
    } 
    
    cslist=[select id,Account.name,Account.owner.name,Contact.name from case where id IN:caseid];
    //Business_Hold_Time__c,Credit_Hold_Time__c,Engineering_Hold_Time__c,Export_Hold_Time__c,Import_Hold_time__c,
    //MTO_Hold_Time__c,MTO_Customer_Hold_Time__c,Pricing_Hold_Time__c,Quality_Hold_Time__c,Integrated_Supply_Chain_Hold_Time__c 
    
    for(case c:cslist)
    {
        Case_Line_Item__c cl=caselinemap.get(c.id);
        system.debug('CaseLineItem'+cl);
        /*commented for INC000009169188 
if(cl.recordtypeID==label.AverageTimeHold_RecID && ((cl.BusinessHold_Endtime__c!= null && (trigger.isupdate && cl.BusinessHold_Endtime__c!=trigger.oldmap.get(cl.id).BusinessHold_Endtime__c)) ||
(cl.Credithold_Endtime__c!=null && (trigger.isupdate && cl.Credithold_Endtime__c!=trigger.oldmap.get(cl.id).Credithold_Endtime__c))
|| (cl.Engineeringhold_Endtime__c!=null && (trigger.isupdate && cl.Engineeringhold_Endtime__c!=trigger.oldmap.get(cl.id).Engineeringhold_Endtime__c))
|| (cl.Exporthold_Endtime__c!=null && (trigger.isupdate && cl.Exporthold_Endtime__c!=trigger.oldmap.get(cl.id).Exporthold_Endtime__c))
|| (cl.Import_Hold_Endtime__c!=null && (trigger.isupdate && cl.Import_Hold_Endtime__c!=trigger.oldmap.get(cl.id).Import_Hold_Endtime__c))
||(cl.MTO_Endtime__c!=null && (trigger.isupdate && cl.MTO_Endtime__c!=trigger.oldmap.get(cl.id).MTO_Endtime__c))
||(cl.MTOCustomer_Endtime__c!=null && (trigger.isupdate && cl.MTOCustomer_Endtime__c!=trigger.oldmap.get(cl.id).MTOCustomer_Endtime__c))
||(cl.SupplyChainHold_Endtime__c!=null && (trigger.isupdate && cl.SupplyChainHold_Endtime__c!=trigger.oldmap.get(cl.id).SupplyChainHold_Endtime__c))
||(cl.PricingHold_Endtime__c!=null && (trigger.isupdate && cl.PricingHold_Endtime__c!=trigger.oldmap.get(cl.id).PricingHold_Endtime__c))
||(cl.QualityHold_Endtime__c!=null && (trigger.isupdate && cl.QualityHold_Endtime__c!=trigger.oldmap.get(cl.id).QualityHold_Endtime__c))))
{
c.Business_Hold_Time__c=caselinemap.get(c.id).BusinessHold_Endtime__c;
c.Credit_Hold_Time__c=caselinemap.get(c.id).Credithold_Endtime__c;
c.Engineering_Hold_Time__c=caselinemap.get(c.id).Engineeringhold_Endtime__c;
c.Export_Hold_Time__c=caselinemap.get(c.id).Exporthold_Endtime__c;
c.Import_Hold_time__c=caselinemap.get(c.id).Import_Hold_Endtime__c;
c.MTO_Hold_Time__c=caselinemap.get(c.id).MTO_Endtime__c;
c.MTO_Customer_Hold_Time__c=caselinemap.get(c.id).MTOCustomer_Endtime__c;
c.Pricing_Hold_Time__c=caselinemap.get(c.id).Pricinghold_Endtime__c;
c.Quality_Hold_Time__c=caselinemap.get(c.id).Qualityhold_Endtime__c;
c.Integrated_Supply_Chain_Hold_Time__c=caselinemap.get(c.id).Supplychainhold_Endtime__c;
updatelist.add(c);
}
commented for INC000009169188 */
        //Code added for SR# INC000008227994- New Change ATR RMU TOOL Start
        //else if( trigger.isinsert && Userinfo.getUserId()=='005a0000008FL7PAAW' && cl.Recordtypeid=='01213000001ZT3a')
        if( trigger.isinsert && Userinfo.getUserId()==label.ATR_API_User_id && cl.Recordtypeid==label.ATR_CaseLineItem_RT)
        {            
            objOpp = new Opportunity();
            objOpp.recordtypeid=label.AM_Complex;
            objOpp.name=c.Account.name+' – RMU web request from '+c.Contact.name;
            objOpp.SBU__c='ATR';
            objOpp.CBT_Tier_2__c='Airlines';
            if(c.Account.ownerid!=null && !(c.Account.owner.name.contains('API')))
                objOpp.ownerid=c.account.ownerid;
            else
                objOpp.ownerid=label.ATR_Default_Owner;    
            objOpp.Revenue_Type__c='Retrofit';
            objOpp.Solution_Type__c='RMU';
            objOpp.CloseDate=System.Today().addDays(90);
            objOpp.Amount=0;
            objOpp.ATR_Base__c=0;
            objOpp.ATR_Review_Org__c='Avionics LRU';
            objOpp.Accountid=c.accountid;
            objOpp.ATR_Probability__c=50;
            objOpp.Campaignid=label.ATR_Default_Campaign;
            objOpp.StageName='Cultivate';                
            objOpp.Description=c.Contact.name+' web  request pricing and  sales contact  regarding '+' '+cl.Service_Bulletins__c+' for '+ cl.Type_of_Platform__c;
            objOpp.Status_Next_Steps__c='Contact customer within 24 hours in response to their web request, reassign Opportunity if needed, correct Amount and Campaign.';
            objOpp.Type_of_Opportunity__c='RMU – Level 2';
            objOpp.ATR_Proposal_Type__c='PROP';
            objOpp.ATR_Aircraft_Quantity__c=cl.Number_of_Aircraft__c;
            objOpp.EPAC__c=cl.Additional_Line_information__c;
            lstOpp.add(objOpp);
        }
        
        //Code added for SR# INC000008227994-New Change ATR RMU TOOL End   
        
    }
    // update updatelist; commented for INC000009169188 
    
    //INC000006283200 - send alerts to customers
    if(Trigger.isupdate){
        List<Case> caseDetails = [select id, contact.Email,isClosed, contactid,contact.Name from Case where id in: idCasesForAlerts];
        
        
        List<Messaging.SingleEMailMessage> mails = new List<Messaging.SingleEMailMessage>();
        if(caseDetails.size() > 0){
            for(Case quoteCase: caseDetails){
                if(quoteCase.contactid != null && quoteCase.isClosed == false){
                    Messaging.SingleEMailMessage mail = new Messaging.SingleEMailMessage();
                    
                    mail.setTemplateID(Label.Case_Line_Item_Completion);              
                    //mail.setWhatId(quoteCase.Id);
                    mail.setWhatId(Trigger.New[0].Id);
                    mail.setTargetObjectId(quoteCase.contactid);
                    
                    mail.setOrgWideEmailAddressId(Label.AeroNo_Reply_email_ID);
                    mail.setSaveAsActivity(false);
                    mails.add(mail);
                }
            }
        }
        
        system.debug('mails--->' + mails);
        if(mails != null){
            Messaging.sendEmail(mails);
        }
    }
    if(Trigger.isinsert){
        system.debug('List of opps'+lstOpp);
        if(lstOpp.size()>0)
        {
            insert lstOpp;
        }
    }
    //INC000006283200 - send alerts to customers
    //Added by Dhivya for SR INC000009360624 starts
    for (Case_Line_Item__c CaseLin : Trigger.new) {
        //if(CaseLin.Price_Status__c=='No Bid')
        //{
        listIds.add(CaseLin.Case_Number__c);
        system.debug('ListIds'+ListIds);
        //}
        
    }
    
    Caselis = [SELECT id, Quote_No_Bid__c,(select id,Price_Status__c from Case_Line_Items__r)FROM Case WHERE ID IN :listIds];
    system.debug('Caselis'+Caselis);
    for (Case updatecas: Caselis){
        for(Case_Line_Item__c linitem : updatecas.Case_Line_Items__r)
        {
            if(linitem.Price_Status__c=='No Bid')
                flag1=true;
            else
                flag1=false;
            
            system.debug('inside UpdateCaseHold');
        }
        if(flag1==true)  
            updatecas.Quote_No_Bid__c = True;
        
        else
            updatecas.Quote_No_Bid__c = False;
        
        caslistt.add(updatecas);
    }  
    if(caslistt!=null)
        update caslistt;
    
    //Added by Dhivya for SR INC000009360624 ends
    
}