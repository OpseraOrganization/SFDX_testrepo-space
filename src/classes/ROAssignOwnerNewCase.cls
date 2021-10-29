/******************************Log****************************************
419758 - Checking the user for active or inactive before it assigned from A2C
421342 - Updaing the recordtype Rotable Core for A2C mapping

Modification History  :
Date            Version No.     Modified by     Brief Description of Modification
23-Jan-2015     1.1             NTTDATA         INC000008227994 ATR RMU TOOL owner assignment 
22-Jul-2015     1.2             NTTDATA         INC000008676964 Updating SBU Impacted Field from Account SBU
*******Test Class*******
RnOCaseOwnerUpdateTestClass
**************************************************************************/
global class ROAssignOwnerNewCase 
{
    @future
    public static void updateCaseOwner(Set<Id> setCase) 
    {    
        String casowid;
        List<case> lstCase = [select accountid,Description,Origin,Case_OwnerId_After_Close__c,contactid,recordtypeid,Emailbox_Origin__c,id,R_O_Case_Origin__c,ownerid,SBU__c,SBU_w2c__c,Type,Status from case where id in :setCase];
        if(lstCase.size()>0)
        casowid = lstCase[0].Case_OwnerId_After_Close__c;
        List<Case> updateCase = new List<Case>();
        List<Id> lstConID = new List<Id>();        
        List<string> lstProd = new List<String>(); 
        //SR#419758
        List<Case_Matrix__c> listCaseMatrix = [select id,Name, OwnerId__c from Case_Matrix__c where Email_Public_Group__c =null];
        system.debug('listCaseMatrix ----->' + listCaseMatrix );
        Map<string,id> mapOwnerIds = new Map<string,id>();
        
        for(Case_Matrix__c cmItem:listCaseMatrix){
            mapOwnerIds.put(cmItem.Name,cmItem.OwnerId__c) ;
        }
        system.debug('mapOwnerIds ----->' + mapOwnerIds.size() );
        //End
        Id recordtypeid = label.Repair_Overhaul_RT_ID;
        Id recordtypeid1 = label.Orders_Rec_ID;
        id RecordTypeid2 = label.D_S_Order;
        Id RecordTypeid3 = label.OEM_Quotes_Orders_ID;
        Id RecordTypeid4 = label.GSS_Quotes_Orders;
        Id RecordTypeid5 = label.GSS_Technical_Support;
        id RecordTypeid6 =label.Rotable_Core_RecordType_Id;//SR#421342 
        //Code added for SR# INC000008227994 ATR RMU TOOL Start
        List<Id> lstAccID = new List<Id>();
        List<AccountTeamMember> lstAccTM = new List<AccountTeamMember>();
        //Code added for SR# INC000008227994 ATR RMU TOOL End
        for(Case objCase:lstCase)
        {
            lstConID.add(objCase.contactid);
            lstProd.add(objCase.R_O_Case_Origin__c);
            //Code added for SR# INC000008227994 ATR RMU TOOL Start
             /*if( Userinfo.getUserId()==label.ATR_API_User_id){
             //if( Userinfo.getUserId()=='005a0000008FL7PAAW'){
                 system.debug('objCase.accountid --->' + objCase.accountid);
                 lstAccID.add(objCase.accountid); 
                 }
                 }*/
            //Code added for SR# INC000008227994 ATR RMU TOOL End
        }
        system.debug('lstConID --->' + lstConID);
        system.debug('lstProd --->' + lstProd);
        system.debug('lstProd --->' + lstAccID);
        //Code added for SR# INC000008227994 ATR RMU TOOL Start
        MaP<Id,Account> mapacctteam = new  MaP<Id,Account>([select id,(SELECT UserId FROM AccountTeamMembers 
            where TeamMemberRole='Customer Business Manager (CBM)' ) from account where id in :lstAccID]);        
        //Code added for SR# INC000008227994 ATR RMU TOOL End
        
        //SR#419758 added IsActive field in query       
        List<Agent_Contact_Mapping__c> lstAgent =
         [select id,CSR__c,CSR__r.Signature1__c,CSR__r.IsActive,Contact__c,Process__c from Agent_Contact_Mapping__c where
          Agent_Contact_Mapping__c.Contact__c in:lstConID and Agent_Contact_Mapping__c.Process__c in:lstProd];
        system.debug('lstAgent --->' + lstAgent );  
        List<Agent_Contact_Mapping__c> lstUpdateAgent = new List<Agent_Contact_Mapping__c>();

        for(case objCase:lstCase)
        {
            if(lstAgent.size()>0){
                for(Agent_Contact_Mapping__c objACM:lstAgent)
                {
                    if(objCase.ContactId == objACM.Contact__c && objCase.R_O_Case_Origin__c == objACM.Process__c && 
                    (objCase.recordtypeid == recordtypeid || objCase.recordtypeid == recordtypeid1
                     || objCase.recordtypeid == RecordTypeid2 || objCase.recordtypeid == RecordTypeid3
                     || objCase.recordtypeid == RecordTypeid4 || objCase.recordtypeid == RecordTypeid5 || objCase.recordtypeid == RecordTypeid6))//SR#421342 -Entry in if condition
                    {                   
                        //SR#419758
                        system.debug('objACM.CSR__r.IsActive----->' + objACM.CSR__r.IsActive);
                        if(objACM.CSR__r.IsActive == true){
                           objCase.OwnerId = objACM.CSR__c;
                           system.debug('objACM.CSR__c ---->' + objACM.CSR__c );
                        }
                        else{
                           if(mapOwnerIds.size() > 0){
                               objCase.OwnerId = mapOwnerIds.get(objCase.Emailbox_Origin__c);
                            }
                        }//End SR#419758
                        objCase.Agent_Contact_Flag__C = True;
                        updateCase.add(objCase);
                    }
                }
            }
            /*else if(objCase.Emailbox_Origin__c == 'Email-R&O Avionics' || objCase.Emailbox_Origin__c == 'Email-R&O MechComponents'){
                if(null!=casowid)
                    objCase.OwnerId = casowid;
                updateCase.add(objCase);
            }*/
            //Code added for SR# INC000008227994 ATR RMU TOOL Start
            else if( Userinfo.getUserId()==label.ATR_API_User_id){
                objCase.ownerid=label.ATR_Default_Owner;
                updateCase.add(objCase);  
            }
            /*else {                        
                if(objCase.accountid!=null && mapacctteam.get(objCase.accountid)!=null){
                    lstAccTM = mapacctteam.get(objCase.accountid).AccountTeamMembers;  
                }
                if(lstAccTM.size()>0){                    
                    objCase.ownerid=lstAccTM[0].userid;                            
                } 
                else
                {
                    objCase.ownerid=label.ATR_Default_Owner;
                }
                updateCase.add(objCase);                
            }*/
            //Code added for SR# INC000008227994 ATR RMU TOOL End
            // Added code for INC000008676964
            if(objCase.Recordtypeid == Label.Case_AOG_RecordType && null!=objCase.AccountId && null!=objCase.SBU__c){
                objCase.SBU_w2c__c = objCase.SBU__c;
                updateCase.add(objCase); 
            }
            // End code for INC000008676964
           // else if((null!=objCase.Recordtypeid && objCase.Recordtypeid == Label.TechnicalIssue_RecordTypeID) && (objCase.Description.contains('Sent from Honeywell\'s Direct Access')) && (objCase.Emailbox_Origin__c=='Email-Aerotechsupport') && (objCase.Origin=='Email') && null!=objCase.Origin && null!=objCase.Emailbox_Origin__c && null!=objCase.Description){
                else if((null!=objCase.Recordtypeid && objCase.Recordtypeid == Label.TechnicalIssue_RecordTypeID) && (null!=objCase.Description && objCase.Description.contains('Sent from Honeywell\'s Direct Access')) && (null!=objCase.Emailbox_Origin__c && objCase.Emailbox_Origin__c=='Email-Aerotechsupport') && (null!=objCase.Origin && objCase.Origin=='Email')){

                objCase.Origin='BGAMobileApp';
                updateCase.add(objCase); 
                system.debug('direct access'+objCase);
                system.debug('Recordtype--->' + objCase.Recordtypeid );

            }
        }
        if(updateCase.size() > 0){
            try{
                update updateCase;
            }Catch(Exception e1){}
        }
    }
}