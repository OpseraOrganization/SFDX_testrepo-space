/**************************************************************************************************
* Company Name          : Honeywell Aero
* Name                  : RnOCaseOwnerAssignOnCreation
* Description           : Trigger is used to assign the case owner mapping to Agents based on agent
*                         to contact mapping
* 
* Modification History  :
* Date             Version No.    Modified by           Brief Description of Modification
* Apr-26-2013      1.0            NTTDATA               SR#387068 Code changes for Assigning Case Ownership
                                                        based on an Incoming email
* June-7-2013                     NTTDATA               GSS Integration
* OCT-2013                        NTTDATA(SR#421342)    Create Rotable core once AOG and Order cases are updated with particular field values)  Lines-374-427
**************************************************************************************************/
trigger RnOCaseOwnerAssignOnCreation on Case(after insert,before insert,after update,before update)
{/*commenting inactive trigger code to improve code coverage-----
    Boolean bolChangesPresent = false;
    List<Agent_Contact_Mapping__c> lstAgent = new List<Agent_Contact_Mapping__c>();
    List<Case> lstCases = new List<Case>();
    
    try{
        if(trigger.isAfter)
        {
            for(Case objCase:Trigger.New)
            { 
                //ID idUserId = userinfo.getuserid();
                if(trigger.isinsert||(trigger.isupdate && Trigger.oldMap.get(objCase.id).RnOSAPCases__c != objCase.RnOSAPCases__c && String.valueof(objCase.ownerid).startswith('00G')))
                {
                    bolChangesPresent = true;    
                }
            } 
            if(bolChangesPresent)
            {
                
                set<Id> csList = Trigger.NewMap.keyset();
                ROAssignOwnerNewCase.updateCaseOwner(csList);
                
                
            }
        }

        if(trigger.isBefore)
        {
            string origin;
            integer strSize;
            Id recrdtypid = label.Repair_Overhaul_RT_ID;
            Id recrdtypid1 = label.Orders_Rec_ID;
            Id recrdtypid2 = label.D_S_Order;
            Id recrdtypid3 = label.OEM_Quotes_Orders_ID;
            Id recrdtypid4 = label.GSS_Quotes_Orders;
            Id recrdtypid5 = label.GSS_Technical_Support;
            List<Id> lstConID = new List<Id>();
            List<string> lstProd = new List<String>();
            List<string> lstProd1 = new List<String>();
            String DSRO = 'D&S R&O';
            //added for ticket :348365. Four new processes/sites added to the condition
            String BournemounthRO = 'R&O Bournemouth';
            String ToulouseRO = 'R&O Toulouse';
            String RaunheimRO = 'R&O Raunheim';
            String BasingstokeRO = 'R&O Basingstoke';
            String RODS;
            //SR#419758
            List<Case_Matrix__c> listCaseMatrix = [select id,Name, OwnerId__c from Case_Matrix__c where Email_Public_Group__c =null];
            system.debug('listCaseMatrix ----->' + listCaseMatrix );
            Map<string,id> mapOwnerIds = new Map<string,id>();
             
            for(Case_Matrix__c cmItem:listCaseMatrix){
                mapOwnerIds.put(cmItem.Name,cmItem.OwnerId__c) ;
            }
            //End SR#419758
            
            for(Case objCase:Trigger.New)
            {
                if(trigger.isinsert||(trigger.isupdate && Trigger.oldMap.get(objCase.id).RnOSAPCases__c != objCase.RnOSAPCases__c))
                //if(trigger.isinsert)
                {
                    String neworigin;
                    bolChangesPresent = true;
                    lstConID.add(objCase.contactid);
                    
                    if(objCase.origin.length()!= null){
                        if(Trigger.isInsert)
                        {
                            strSize=objCase.origin.length();
                        }
                        else
                        {
                            strSize = objCase.Mail_Box_Name__c.length(); 
                        }
                        if(strSize>6)
                        {
                            if(Trigger.isInsert)
                            {
                                neworigin=objCase.origin.substring(6,strSize);
                            }
                            else
                            {
                                neworigin = objCase.Mail_Box_Name__c.substring(6,strSize);
                            }
                            if(neworigin == 'R&O D&S'){
                                neworigin = DSRO;
                            }
                            //modified for ticket :348365. Four new processes/sites added to the condition
                            else if (neworigin == 'habcustomersupport'){
                                neworigin = BournemounthRO;
                            }
                            else if (neworigin == 'FranceSC.customerservice'){
                                neworigin = ToulouseRO;
                            }
                            else if (neworigin == 'RAU-CustomerServices'){
                                neworigin = RaunheimRO;
                            }
                            else if (neworigin == 'customerservices'){
                                neworigin = BasingstokeRO;
                            }
                            else if(neworigin=='AeroAirbus'){
                                neworigin='ATR OEM Airbus';
                            }
                            else if(neworigin=='AeroBoeing'){
                                neworigin='ATR OEM Boeing';
                            }
                            else if(neworigin == 'AeroComponents'){
                             neworigin = 'ATR OEM Components';
                            }
                            else if(neworigin == 'Aero GSE Orders'){
                             neworigin = 'Aero GSE Orders';
                            }
                            else if(neworigin == 'Aero GSE Quotes'){
                             neworigin = 'Aero GSE Quotes';
                            }
                            else if(neworigin == 'Aero GSE Support'){
                             neworigin = 'Aero GSE Support';
                            }
                            else if(neworigin == 'Aero GSE Vendor Support'){
                             neworigin = 'Aero GSE Vendor Support';
                            }     
                            lstProd.add(neworigin);
                        }
                        lstProd1.add(objCase.origin); 
                        
                    }
                }
            }
            if(bolChangesPresent)
            {           
            lstAgent = [select id,CSR__c,CSR__r.IsActive,CSR__r.Signature1__c,Contact__c,Process__c from Agent_Contact_Mapping__c where Agent_Contact_Mapping__c.Contact__c in:lstConID and (Agent_Contact_Mapping__c.Process__c in:lstProd OR Agent_Contact_Mapping__c.Process__c in:lstProd1)];
            
            }
            for(case objCase:Trigger.New)
            {
                if(trigger.isinsert||(trigger.isupdate && Trigger.oldMap.get(objCase.id).RnOSAPCases__c != objCase.RnOSAPCases__c))
                {
                for(Agent_Contact_Mapping__c objACM:lstAgent)
                { 
                    if(Trigger.isInsert)
                    {
                        strSize=objCase.origin.length();
                    }
                    else
                    {
                        strSize = objCase.Mail_Box_Name__c.length(); 
                    }
                    if(strSize > 6)
                    if(Trigger.isInsert)
                    {
                        origin=objCase.origin.substring(6,strSize);
                    }
                    else
                    {
                        origin = objCase.Mail_Box_Name__c.substring(6,strSize);
                    }
                    if(origin == 'R&O D&S'){
                        RODS = origin;
                        Origin = DSRO;
                    }
                    //modified for ticket :348365. Four new processes/sites added to the condition
                    else if (origin == 'habcustomersupport'){
                        origin = BournemounthRO;
                    }
                    else if (origin == 'FranceSC.customerservice'){
                        origin = ToulouseRO;
                    }
                    else if (origin == 'RAU-CustomerServices'){
                        origin = RaunheimRO;
                    }
                    else if (origin == 'customerservices'){
                        origin = BasingstokeRO;
                    }
                    //For SR#370483
                    else if(origin == 'AeroAirbus'){
                         origin = 'ATR OEM Airbus';
                    }
                    
                    else if(origin == 'AeroBoeing'){
                         origin = 'ATR OEM Boeing';
                    }
                    
                    else if(origin == 'AeroComponents'){
                         origin = 'ATR OEM Components';
                         
                    }//End Sr#370483
                    
                    if(strSize > 6)
                    {
                        if(objCase.ContactId==objACM.Contact__c && origin==objACM.Process__c && 
                            (objCase.RecordTypeId == recrdtypid || objCase.RecordTypeId == recrdtypid1 || objCase.RecordTypeId == recrdtypid2 || objCase.RecordTypeId == recrdtypid3  || objCase.RecordTypeId == recrdtypid4 || objCase.RecordTypeId == recrdtypid5))
                        { 
                            objCase.R_O_Case_Origin__c = origin;
                            if(Trigger.Isinsert)
                            {
                            objCase.Government_Compliance_SM_M_Content__c = 'Undetermined';
                            objCase.Export_Compliance_Content_ITAR_EAR__c = 'Undetermined';
                            }

                            if(origin == DSRO){
                                origin = 'R&O D&S';
                            }
                            else if(origin=='D&S R&O Internal')
                            {
                                objCase.Origin='Email';
                                objCase.Classification__c='D&S R&O Internal';
                            }
                            else if(origin=='R&O Canada')
                            {
                              objCase.Origin='Email';
                              objCase.Classification__c='CSO Repair/Overhaul';
                              objCase.Sub_Class__c='Toronto/PEI';
                              objCase.Type='Repair Inquiry';
                            }
                            else if(origin=='BGA R&O Internal')
                            {
                              objCase.Origin='Email';
                              objCase.Classification__c='BGA R&O Internal';
                            }
                            else if(origin=='ATR R&O Internal')
                            {
                              objCase.Origin='Email';
                              objCase.Classification__c='ATR R&O Internal';
                            }         
                            //GSS INtergation
                            else if(origin == 'Aero GSE Orders'){                             
                             objCase.Origin='Email';
                             objCase.Classification__c='GSE Orders';
                             if(objACM.CSR__r.IsActive == true)                             
                                 objCase.OwnerId = objACM.CSR__c;
                             else
                                 objCase.OwnerId = mapOwnerIds.get(objCase.Emailbox_Origin__c);
                            }
                             else if(origin == 'Aero GSE Quotes'){                             
                             objCase.Origin='Email';
                             objCase.Classification__c='GSE Quotes';                             
                             if(objACM.CSR__r.IsActive == true)                             
                                 objCase.OwnerId = objACM.CSR__c;
                             else
                                 objCase.OwnerId = mapOwnerIds.get(objCase.Emailbox_Origin__c);
                            }
                            else if(origin == 'Aero GSE Support'){                             
                             objCase.Origin='Email';
                             objCase.Classification__c='GSE Technical Support';                              
                             if(objACM.CSR__r.IsActive == true)                             
                                 objCase.OwnerId = objACM.CSR__c;
                             else
                                 objCase.OwnerId = mapOwnerIds.get(objCase.Emailbox_Origin__c);
                            }
                            else if(origin == 'Aero GSE Vendor Support'){                             
                             objCase.Origin='Email';
                             objCase.Classification__c='GSE Vendor Support';                             
                             if(objACM.CSR__r.IsActive == true)                             
                                 objCase.OwnerId = objACM.CSR__c;
                             else
                                 objCase.OwnerId = mapOwnerIds.get(objCase.Emailbox_Origin__c);
                            }
                            //end of GSS                   
                            else if(origin=='R&O MechComponents')
                            {
                              objCase.Origin='Email';                              
                              if(Trigger.Isinsert || (Trigger.isupdate&&(objCase.Classification__c==null || objCase.Classification__c=='')))
                              {
                              objCase.Classification__c='CSO Repair/Overhaul';
                              }
                              if(Trigger.Isinsert || (Trigger.isupdate&&(objCase.Sub_Class__c==null || objCase.Sub_Class__c=='')))
                              {
                              objCase.Sub_Class__c='Mech Components';
                              }
                              if(Trigger.Isinsert || (Trigger.isupdate&&(objCase.Type==null || objCase.Type=='')))
                              {
                              objCase.Type='Repair Inquiry';
                              }
                            }
                            else if(origin=='R&O APU')
                            {
                              objCase.Origin='Email';
                              if(Trigger.Isinsert || (Trigger.isupdate&&(objCase.Classification__c==null || objCase.Classification__c=='')))
                              { 
                                objCase.Classification__c='CSO Repair/Overhaul';
                              }
                              if(Trigger.Isinsert || (Trigger.isupdate&&(objCase.Sub_Class__c==null || objCase.Sub_Class__c=='')))
                              {
                                objCase.Sub_Class__c='APU';
                              }
                            }                           
                            else if(origin=='R&O Engines')
                            {
                              objCase.Origin='Email';
                              if(Trigger.Isinsert || (Trigger.isupdate&&(objCase.Classification__c==null || objCase.Classification__c=='')))
                              {
                                objCase.Classification__c='CSO Repair/Overhaul';
                              }
                              if(Trigger.Isinsert || (Trigger.isupdate&&(objCase.Sub_Class__c==null || objCase.Sub_Class__c=='')))
                              {
                                objCase.Sub_Class__c='Engines';
                              }
                              if(Trigger.Isinsert || (Trigger.isupdate&&(objCase.Type==null || objCase.Type=='')))
                              {
                                objCase.Type='Repair Inquiry';
                              }
                            }                           
                            else if(origin=='R&O W&B/Greer')
                            {
                              objCase.Origin='Email';
                              objCase.Classification__c='CSO Repair/Overhaul';
                              objCase.Sub_Class__c='W&B/Greer';
                              objCase.Type='Repair Inquiry';
                            }
                            else if(origin=='R&O Avionics')
                            {
                              objCase.Origin='Email';
                              if(Trigger.Isinsert || (Trigger.isupdate&&(objCase.Classification__c==null || objCase.Classification__c=='')))
                              {
                                objCase.Classification__c='CSO Repair/Overhaul';
                              }
                              if(Trigger.Isinsert || (Trigger.isupdate&&(objCase.Sub_Class__c==null || objCase.Sub_Class__c=='')))
                              {
                              objCase.Sub_Class__c='Avionics';
                              }
                              if(Trigger.Isinsert || (Trigger.isupdate&&(objCase.Type==null || objCase.Type=='')))
                              {
                              objCase.Type='Repair Inquiry';
                              }
                            }
                            else if(origin=='R&O FastShop')
                            {
                              objCase.Origin='Email';
                              objCase.Classification__c='CSO Repair/Overhaul';
                              objCase.Sub_Class__c='FastShop';
                              objCase.Type='Repair Inquiry';
                            }
                            //added for the ticket :321116 for agent contact mapping functioanlity
                            if(origin=='D&Sorders' || origin=='D&Squotes' || origin=='R&O D&S' || origin=='ATR R&O Internal' 
                                || origin=='BGA R&O Internal' || origin=='D&S R&O Internal' || origin=='R&O Canada' || origin=='R&O Engines' 
                                || origin=='R&O FastShop' || origin=='R&O MechComponents' || origin=='R&O W&B/Greer' || origin=='R&O APU' 
                                || origin=='R&O Avionics' || origin=='R&O Bournemouth' || origin=='R&O Toulouse' || origin=='R&O Raunheim' 
                                || origin=='R&O Basingstoke' || origin == 'ATR OEM Airbus' || origin =='ATR OEM Boeing' || origin == 'ATR OEM Components' || origin == 'Aero GSE Orders' || origin == 'Aero GSE Quotes' || origin == 'Aero GSE Support' || origin == 'Aero GSE Vendor Support')
                            {
                               objCase.Agent_Contact_Flag__c = True;
                               objCase.User_Signature__c = objACM.CSR__r.Signature1__c;
                            }                            
                        }
                    }
                }
                }
            }
        }
    }
    catch(exception e) 
    {
        SYSTEM.DEBUG('Exception '+e);
    } 
    
    //Start SR#421342 - Create Rotable core once AOG and Order cases are updated with particular field values
    if(Trigger.isbefore){
        
        for(Case updatingCase : trigger.new){
            if((updatingCase.Case_Record_Type__c == 'AOG' || updatingCase.Case_Record_Type__c == 'Orders') 
            //&& ((updatingCase.Sub_Class__c == 'SPEX/Exchange' && Trigger.OldMap.get(updatingCase.Id).Sub_Class__c != 'SPEX/Exchange') || (updatingCase.Detail_Class__c == 'SPEX/Exchange' && Trigger.OldMap.get(updatingCase.Id).Detail_Class__c != 'SPEX/Exchange') ) 
            && (updatingCase.Sub_Class__c == 'SPEX/Exchange' || updatingCase.Detail_Class__c == 'SPEX/Exchange')
            && (updatingCase.Sales_Order_Number__c != null) ){
                if(updatingCase.SPEX_Exchange__c != true){
                    updatingCase.SPEX_Exchange__c = true;
                    system.debug('----> ' + updatingCase.SPEX_Exchange__c + 'Sales_Order_Number__c -->' + updatingCase.Sales_Order_Number__c );
                }
                
            }
        }
    }
   
    if(Trigger.isafter && Trigger.isupdate){
        
        List<Case> listnewCases = new List<Case>();
        for(Case updatingCase : trigger.new){
            //system.debug( '--->updatingCase.SPEX_Exchange__c' + updatingCase.SPEX_Exchange__c);
            //system.debug( '--->Old updatingCase.SPEX_Exchange__c' + Trigger.OldMap.get(updatingCase.Id).SPEX_Exchange__c);
            if(updatingCase.SPEX_Exchange__c == true &&
            (updatingCase.Case_Record_Type__c == 'AOG' || updatingCase.Case_Record_Type__c == 'Orders')&&
            (updatingCase.Sales_Order_Number__c != null) &&
            (updatingCase.Sub_Class__c == 'SPEX/Exchange' || updatingCase.Detail_Class__c == 'SPEX/Exchange') &&
            (Trigger.OldMap.get(updatingCase.Id).Sales_Order_Number__c == null || (Trigger.OldMap.get(updatingCase.Id).Sub_Class__c != 'SPEX/Exchange' && Trigger.OldMap.get(updatingCase.Id).sub_class__c != 'SPEX/Exchange') || (Trigger.OldMap.get(updatingCase.Id).Detail_Class__c != 'SPEX/Exchange'  && updatingCase.Detail_Class__c == 'SPEX/Exchange'))
            ){
                //Create new case of 'Rotable Core' record type
                Case newRCcase = new Case();
                newRCCase.ParentId = updatingCase.Id;
                newRCcase.SPEX_Exchange__c = true;
                newRCcase.Sales_Order_Number__c = updatingCase.Sales_Order_Number__c;
                newRCcase.AccountId = updatingCase.AccountId;
                newRCCase.contactid = updatingCase.contactId;
                newRCcase.Origin = 'Email-Spex Order';
                newRCCase.OwnerId = Label.SPEX_Core_Recovery_Team_Queue_Id;//get 'Core Recovery Team' id form Label
                newRCCase.RecordTypeId = label.Rotable_Core_RecordType_Id;//get 'Rotable Core' Id from Label
                newRCCase.Classification__c = 'SPEX Core Return';
                newRCCase.Sub_Class__c = 'SPEX/Exchange';
                newRCCase.Detail_Class__c = '';
                newRCCase.Type = updatingCase.Type;
                newRCCase.subject = updatingCase.subject;
                newRCCase.description = updatingCase.description;
                listnewCases.add(newRCCase);
            }
        }
        system.debug('listnewCases--->' + listnewCases.size());
        if(listnewCases.size() > 0 && TriggerInactive.createRotableCase == true){
            insert listnewCases;
            TriggerInactive.createRotableCase = false;
        }
        
    }*/
    
    //End SR#421342
}