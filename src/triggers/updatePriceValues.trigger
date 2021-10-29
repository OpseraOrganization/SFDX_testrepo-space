/*******************************************************************************
Name         : CaseOnHoldPublicMethods
Created By   : Siva Nannapaneni
Company Name : NTT Data
Modification History  :
Date          Version No.     Modified by     Brief Description of Modification 
20/09/2017       2            Prasath Subramaniyan     -For Request # INC000012188926 ,Contract Extension process.
12/4/2013        1                                     -Initial version
********************************************************************************/
trigger updatePriceValues on Contract (before update,before insert,after insert ,after update) {
    
    if(trigger.isUpdate && trigger.isBefore)
    {
        
        List<Price_Book__c> pblist = new List<Price_Book__c>();
        pblist = [SELECT Aircraft__c,APU_Gold_NLS_Price__c,APU_Gold_Price__c,APU_Model__c,APU_Price__c,APU_Transfer_Fee_Price__c,Between_Price__c,
                  Engine__c,Id,Location_ID__c,Location__c,MSP_Gold__c,NRL_Gold__c,OEM__c,OverHrs__c,OverPrice__c,Product_Type__c,Transfer_Fee__c,
                  UnderHrs__c,Under_Price__c,Years__c,Renewal_Start_Date__c FROM Price_Book__c where Renewal_Start_date__c != null ];
        if(pblist.size()>0 && pblist.size()!=null){
            for(Contract c:trigger.new){
                for(Price_Book__c pb:pblist){
                    if( c.Renewal_Start_date__c != null){
                        if( c.Renewal_Start_date__c.year()== pb.Renewal_Start_Date__c.year() && (c.Type__c == 'MSP' 
                                                                                                 && pb.Product_Type__c == 'MSP') && (c.MSP_Engine_ModelPL__c == pb.Engine__c && pb.Renewal_Start_Date__c != null) 
                           && (c.Location__c == pb.Location__c)){
                               c.Engine_MSP_Price_ONA__c = pb.OverPrice__c;
                               c.Engine_MSP_PriceNA__c = pb.Under_Price__c;
                               c.Engine_MSP_Price_Between__c = pb.Between_Price__c;
                               c.EngineOverHrs__c = pb.OverHrs__c;
                               c.EngineUnderHrs__c = pb.UnderHrs__c;
                               c.Engine_Gold_Price__c = pb.MSP_Gold__c;
                               c.Engine_Gold_NRL_Price__c = pb.NRL_Gold__c;
                               c.Engine_Transfer_Fee_Price__c = pb.Transfer_Fee__c;
                               c.Years__c = pb.Years__c;
                               /*}else if( (c.Type__c == 'MSP' && pb.Product_Type__c == 'MSP') && (c.MSP_Engine_ModelPL__c == pb.Engine__c && 
pb.Renewal_Start_Date__c == null) && (c.Location__c == pb.Location__c)){
c.Engine_MSP_Price_ONA__c = pb.OverPrice__c;
c.Engine_MSP_PriceNA__c = pb.Under_Price__c;
c.Engine_MSP_Price_Between__c = pb.Between_Price__c;
c.EngineOverHrs__c = pb.OverHrs__c;
c.EngineUnderHrs__c = pb.UnderHrs__c;
c.Engine_Gold_Price__c = pb.MSP_Gold__c;
c.Engine_Gold_NRL_Price__c = pb.NRL_Gold__c;
c.Engine_Transfer_Fee_Price__c = pb.Transfer_Fee__c;
c.Years__c = pb.Years__c;*/
                           }else if(c.MSP_Engine_ModelPL__c == null){
                               c.Engine_MSP_Price_ONA__c = '';
                               c.Engine_MSP_PriceNA__c = '';
                               c.Engine_MSP_Price_Between__c = '';
                               c.EngineOverHrs__c = null;
                               c.EngineUnderHrs__c = null;
                               c.Engine_Gold_Price__c = '';
                               c.Engine_Gold_NRL_Price__c = '';
                               c.Engine_Transfer_Fee_Price__c = '';
                           }
                        if(c.Renewal_Start_date__c.year() == pb.Renewal_Start_Date__c.year() && (c.APU_Model__c == pb.APU_Model__c) 
                           && (c.Type__c == 'MSP' && pb.Product_Type__c == 'MSP')){
                               c.APU_MSP_Price__c = pb.APU_Price__c;
                               c.APU_Gold_Price__c = pb.APU_Gold_Price__c;
                               c.APU_Gold_NLS_Price__c = pb.APU_Gold_NLS_Price__c;
                               c.APU_Transfer_Fee_Price__c = pb.APU_Transfer_Fee_Price__c;
                               c.Years__c = pb.Years__c;
                               /* }else if(c.Renewal_Start_Date__c ==null && (c.APU_Model__c == pb.APU_Model__c) && (c.Type__c == 'MSP' && pb.Product_Type__c == 'MSP')){
c.APU_MSP_Price__c = pb.APU_Price__c;
c.APU_Gold_Price__c = pb.APU_Gold_Price__c;
c.APU_Gold_NLS_Price__c = pb.APU_Gold_NLS_Price__c;
c.APU_Transfer_Fee_Price__c = pb.APU_Transfer_Fee_Price__c;*/
                           }else if(c.APU_Model__c == null){
                               c.APU_MSP_Price__c = '';
                               c.APU_Gold_Price__c = '';
                               c.APU_Gold_NLS_Price__c = '';
                               c.APU_Transfer_Fee_Price__c = '';
                           }
                    }
                }
            }
        }
        
    }
   if(Trigger.isUpdate && Trigger.isBefore)
    {
        Set<Id> acctSet = new Set<Id>();
        List<Contract> conList = new List<Contract>();
        for(Contract con:trigger.new)
        {
            if(con.AccountId !=Trigger.oldMap.get(con.Id).AccountId || con.isSubmitForApproval__c)
            {
                acctSet.add(con.AccountId);
                conList.add(con);
            }
            
        }
        if(!conList.isEmpty())
        {
           ContractExtensionProcessHandler.updatemail(conList,acctSet);
        }
        ContractExtensionProcessHandler.updatGroupEmail(trigger.new,trigger.oldMap);
    }
    if(trigger.isInsert && Trigger.isBefore)
    {
        Set<Id> acctSet = new Set<Id>();
        List<Contract> conList = new List<Contract>();
        for(Contract con:trigger.new)
        {
            if(con.endDate != null && con.AccountId !=null)
            {
                acctSet.add(con.AccountId);
                conList.add(con);
            }            
        }
        if(!conList.isEmpty())
        {
            ContractExtensionProcessHandler.updatemail(conList,acctSet);
        }
        //ContractExtensionProcessHandler.updatGroupEmail(trigger.new,trigger.oldMap);
        
    } 
}