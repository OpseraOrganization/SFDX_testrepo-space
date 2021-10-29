/***********************************************************************************************************
* Company Name          : Honeywell Aero
* Name                  : CaseValUpdtBasOnOwner
* Description           : Trigger to update the Case Recordtype, Type, Classification, 
*                         SubClass, Detailed Class based on the Case owner value
* 
* Modification History  :
* Date             Version No.    Modified by           Brief Description of Modification
* Sep-06-2012      1.0            NTTData               Initial Version created
* Sep-15-2012      1.1            NTTData               SR# 358711 - Code changes for case owner change to
                                                        CSO BGA Spares.
* Nov-22-2012      1.2            NTTData               SR#362869  - Code changes for case Owner change to
                                                        CSO BGA OEM team.
* 10-Dec-2012      1.3            NTTData               SR#:349250 Code changes for case owner change to
                                                        R&O Quotes Team & R&O Quotes Team Escalation.
* 07-Jan-2013      1.4            NTTDAta               SR#:370843  Code changes for case Owner change to
                                                        ATR OEM Components,ATR OEM Boeing,ATR OEM Airbus.
* 23-Jan-2013      1.5            NTTDATA               SR#:374873  Code changes for case owner change to
                                                        Secan Spares & Secan R&O
* 25-Mar-2013      1.6            NTTDATA               SR#:378618 Code changes for case owner change to
                                                        R&O Quotes - EMEA,R&O EMEAI Mechanical,R&O EMEAI Avionics.
* 26-Apr-2013      1.7            NTTDATA               SR#:387068 Code changes for Assignind Classification and 
                                                        SubClass values based on an Incoming email                               
* 09-May-2013      1.8            NTTDATA               GSS Integration--- Code changes for Assignind Classification 
                                                        values based on owner Change
* 30-May-2013      1.9            NTTDATA               SR#:397671 Code changes for case owner change to
                                                        R&O EMEA Order Entry Avionics,R&O EMEA Shipping/Invoicing Avionics,R&O EMEA Shipping/Invoicing Mechanical
* 19-Jul-2013      2.0            NTTDATA               SR#:398488 code changes for case owner change to Singapore R&O Mechanical, Singapore R&O Avionics, 
                                                        Xiamen R&O Mechanical,Shanghai R&O Avionics,Shanghai R&O W&B,Shanghai R&O Quote,Shanghai R&O OE
* 18-Oct-2013      2.1            NTTDATA               Code Changes for Igloo ticket for case owner R&O D&S
***********************************************************************************************************/
trigger CaseValUpdtBasOnOwner on Case (after insert, after update) 
{/*commenting inactive trigger code to improve code coverage-----
    List<Case> caseList = new List<Case>();
    Map<ID,Case> caseToUpdate = new Map<ID,Case>();
    //get the values from R&O Case Reassignment Queue in custom settings
    List<Case> casee = new List<Case>();
    List<R_O_Case_Reassignment_Queue__c> qtype = R_O_Case_Reassignment_Queue__c.getall().values(); 
    for(Case objNewCase : trigger.new)
    {
        if(Trigger.isupdate)
        { 
           if((System.Trigger.OldMap.get(objNewCase.Id).OwnerId != System.Trigger.NewMap.get(objNewCase.Id).OwnerId)&& (Trigger.oldMap.get(objNewCase.id).RnOSAPCases__c == objNewCase.RnOSAPCases__c))//Modified for SR#387068
           {           
                String strOwnerName = getOwnerName(System.Trigger.NewMap.get(objNewCase.Id).OwnerId, qtype); 
                if(strOwnerName.equals('R&O APU_Queue'))
                {
                    Case objCase = new Case(id = objNewCase.id);
                    setROCaseDetails(objCase);
                    objCase.Sub_Class__c = 'APU';
                    caseList.add(objCase);
                }
                if(strOwnerName.equals('R&O Avionics_Queue'))
                {               
                    Case objCase = new Case(id = objNewCase.id);
                    setROCaseDetails(objCase);
                    objCase.Sub_Class__c = 'Avionics';
                    caseList.add(objCase);
                }
                if(strOwnerName.equals('R&O Engines_Queue'))
                {
                    Case objCase = new Case(id = objNewCase.id);
                    setROCaseDetails(objCase);
                    objCase.Sub_Class__c = 'Engines';
                    caseList.add(objCase);
                }
                if(strOwnerName.equals('R&O FastShop_Queue'))
                {
                    Case objCase = new Case(id = objNewCase.id);
                    setROCaseDetails(objCase);
                    objCase.Sub_Class__c = 'FastShop';
                    caseList.add(objCase);
                }
                if(strOwnerName.equals('R&O Mech Components_Queue'))
                {
                    Case objCase = new Case(id = objNewCase.id);
                    setROCaseDetails(objCase);
                    objCase.Sub_Class__c = 'Mech Components';
                    caseList.add(objCase);
                }
                // Added code for ticket #349250
                if(strOwnerName.equals('R&O Quotes Team_Queue'))
                {
                    Case objCase = new Case(id = objNewCase.id);
                    objCase.Type = 'Quotes/Availability';
                    objCase.Classification__c = 'CSO Repair/Overhaul';
                    objCase.Sub_Class__c = 'Quotes COE - Customer Response';
                    objCase.Repair_Location__c = '';
                    caseList.add(objCase);
                }
                if(strOwnerName.equals('R&O Quotes Team Escalation_Queue'))
                {
                    Case objCase = new Case(id = objNewCase.id);
                    objCase.Type = 'Quotes/Availability';
                    objCase.Classification__c = 'CSO Repair/Overhaul';
                    objCase.Sub_Class__c = 'Quotes COE - Escalation';
                    objCase.Repair_Location__c = '';
                    caseList.add(objCase);
                }
                // End of the code for ticket #349250
                if(strOwnerName.equals('R&O Wheels and Brakes/Greer_Queue'))
                {
                    Case objCase = new Case(id = objNewCase.id);
                    setROCaseDetails(objCase);
                    objCase.Sub_Class__c = 'W&B/Greer';
                    caseList.add(objCase);
                }
                // Added code for SR#: 374873
                if(strOwnerName.equals('Secan R&O_Queue'))
                {
                    Case objCase = new Case(id = objNewCase.id);
                    objCase.RecordTypeid = label.Repair_Overhaul_RT_ID;
                    objCase.Classification__c = 'CSO Repair/Overhaul';
                    objCase.Sub_Class__c = '';
                    objCase.Detail_Class__c = '';
                    objCase.Repair_Location__c = 'Secan';
                    objCase.Type = '';
                    casee.add(objCase);
                }if(strOwnerName.equals('Secan Spares_Queue'))
                {
                    Case objCase = new Case(id = objNewCase.id);
                    objCase.RecordTypeid = label.Orders_Rec_ID;
                    objCase.Classification__c = 'CSO Spares';
                    objCase.Sub_Class__c = 'Secan';
                    objCase.Detail_Class__c = '';
                    objCase.Repair_Location__c = 'Gennevilliers';
                    objCase.Type = 'Place Order';
                    casee.add(objCase);
                }
                // End of SR#: 374873
                // Added code for SR#:378618
                if(strOwnerName.equals('R&O EMEA Quotes Team_Queue'))
                {
                    Case objCase = new Case(id = objNewCase.id);
                    objCase.RecordTypeid = label.Repair_Overhaul_RT_ID;
                    objCase.Classification__c = 'CSO Repair/Overhaul';
                    objCase.Sub_Class__c = 'Quotes COE - Customer Response';
                    objCase.Detail_Class__c = 'COE';
                    objCase.Repair_Location__c = '';
                    objCase.Type = 'Quotes/Availability';
                    casee.add(objCase);
                }
                if(strOwnerName.equals('R&O EMEAI Mechanical_Queue'))
                {
                    Case objCase = new Case(id = objNewCase.id);
                    objCase.RecordTypeid = label.Repair_Overhaul_RT_ID;
                    objCase.Classification__c = 'CSO Repair/Overhaul';
                    objCase.Sub_Class__c = '';
                    objCase.Detail_Class__c = '';
                    objCase.Repair_Location__c = '';
                    objCase.Type = 'Other';
                    casee.add(objCase);
                }
                if(strOwnerName.equals('R&O EMEAI Avionics_Queue'))
                {
                    Case objCase = new Case(id = objNewCase.id);
                    objCase.RecordTypeid = label.Repair_Overhaul_RT_ID;
                    objCase.Classification__c = 'CSO Repair/Overhaul';
                    objCase.Sub_Class__c = '';
                    objCase.Detail_Class__c = '';
                    objCase.Repair_Location__c = '';
                    objCase.Type = 'Other';
                    casee.add(objCase);
                }
                // End of SR#: 378618
                // Added code for SR#:397671
                if(strOwnerName.equals('R&O EMEA Order Entry Avionics_Queue'))
                {
                    Case objCase = new Case(id = objNewCase.id);
                    objCase.RecordTypeid = label.Repair_Overhaul_RT_ID;
                    objCase.Classification__c = 'CSO Repair/Overhaul';
                    objCase.Sub_Class__c = '';
                    objCase.Repair_Location__c = 'EMEAI Avionics';
                    objCase.Type = 'Place Order';
                    casee.add(objCase);
                }
                if(strOwnerName.equals('ROEMEAShipping/InvoicingAvionics_Queue'))
                {
                    Case objCase = new Case(id = objNewCase.id);
                    objCase.RecordTypeid = label.Repair_Overhaul_RT_ID;
                    objCase.Classification__c = 'CSO Repair/Overhaul';
                    objCase.Sub_Class__c = '';
                    objCase.Repair_Location__c = 'EMEAI Avionics';
                    objCase.Type = 'Shipping/Invoicing';
                    casee.add(objCase);
                }
                if(strOwnerName.equals('ROEMEAShipping/InvoicingMech_Queue'))
                {
                    Case objCase = new Case(id = objNewCase.id);
                    objCase.RecordTypeid = label.Repair_Overhaul_RT_ID;
                    objCase.Classification__c = 'CSO Repair/Overhaul';
                    objCase.Sub_Class__c = '';
                    objCase.Repair_Location__c = 'EMEAI Mechanical';
                    objCase.Type = 'Shipping/Invoicing';
                    casee.add(objCase);
                }
                // End of SR#: 397671
                // Added code for SR#:398488
                //Commented for INC000006577271
                /* if(strOwnerName.equals('Singapore R&O Mechanical_Queue'))
                {
                    Case objCase = new Case(id = objNewCase.id);
                    objCase.RecordTypeid = label.Repair_Overhaul_RT_ID;
                    objCase.Classification__c = 'CSO Repair/Overhaul';
                    objCase.Sub_Class__c = '';
                    objCase.Repair_Location__c = 'Singapore Mech';
                    objCase.Type = '';
                    casee.add(objCase);
                }
                if(strOwnerName.equals('Singapore R&O Avionics_Queue'))
                {
                    Case objCase = new Case(id = objNewCase.id);
                    objCase.RecordTypeid = label.Repair_Overhaul_RT_ID;
                    objCase.Classification__c = 'CSO Repair/Overhaul';
                    objCase.Sub_Class__c = '';
                    objCase.Repair_Location__c = 'Singapore AvEi';
                    objCase.Type = 'Other';
                    casee.add(objCase);
                }
                if(strOwnerName.equals('Xiamen R&O Mechanical_Queue'))
                {
                    Case objCase = new Case(id = objNewCase.id);
                    objCase.RecordTypeid = label.Repair_Overhaul_RT_ID;
                    objCase.Classification__c = 'CSO Repair/Overhaul';
                    objCase.Sub_Class__c = '';
                    objCase.Repair_Location__c = 'XiaMen';
                    objCase.Type = '';
                    casee.add(objCase);
                }
                if(strOwnerName.equals('Shanghai R&O Avionics_Queue'))
                {
                    Case objCase = new Case(id = objNewCase.id);
                    objCase.RecordTypeid = label.Repair_Overhaul_RT_ID;
                    objCase.Classification__c = 'CSO Repair/Overhaul';
                    objCase.Sub_Class__c = '';
                    objCase.Repair_Location__c = 'Shanghai AvEi';
                    objCase.Type = '';
                    casee.add(objCase);
                }
                if(strOwnerName.equals('Shanghai R&O W&B_Queue'))
                {
                    Case objCase = new Case(id = objNewCase.id);
                    objCase.RecordTypeid = label.Repair_Overhaul_RT_ID;
                    objCase.Classification__c = 'CSO Repair/Overhaul';
                    objCase.Sub_Class__c = '';
                    objCase.Repair_Location__c = 'Shanghai W&B (CEASA)';
                    objCase.Type = '';
                    casee.add(objCase);
                }
                if(strOwnerName.equals('Shanghai R&O Quote_Queue'))
                {
                    Case objCase = new Case(id = objNewCase.id);
                    objCase.RecordTypeid = label.Repair_Overhaul_RT_ID;
                    objCase.Classification__c = 'CSO Repair/Overhaul';
                    objCase.Sub_Class__c = '';
                    objCase.Repair_Location__c = 'Shanghai Quote/OE';
                    objCase.Type = 'Quotes/Availability';
                    casee.add(objCase);
                }
                if(strOwnerName.equals('Shanghai R&O OE_Queue'))
                {
                    Case objCase = new Case(id = objNewCase.id);
                    objCase.RecordTypeid = label.Repair_Overhaul_RT_ID;
                    objCase.Classification__c = 'CSO Repair/Overhaul';
                    objCase.Sub_Class__c = '';
                    objCase.Repair_Location__c = 'Shanghai Quote/OE';
                    objCase.Type = 'Place Order';
                    casee.add(objCase);
                }
                // End of SR#: 398488
                // Added code for Igloo ticket
                if(strOwnerName.equals('R&O D&S_Queue'))
                {
                    Case objCase = new Case(id = objNewCase.id);
                    objCase.RecordTypeid = label.Repair_Overhaul_RT_ID;
                    objCase.Classification__c = 'CSO Repair/Overhaul';
                    objCase.Sub_Class__c = 'D&S R&O';
                    casee.add(objCase);
                }
                // End code for Igloo ticket
                if(strOwnerName.equals('D&S PR Orders Team_Queue'))
                {
                    Case objCase = new Case(id = objNewCase.id);
                    setDSCaseDetails(objCase);
                    objCase.Type = 'Place Order';
                    objCase.Sub_Class__c = '';
                    caseList.add(objCase);
                }
                if(strOwnerName.equals('D&S PR Quotes Team_Queue'))
                {
                    Case objCase = new Case(id = objNewCase.id);
                    setDSCaseDetails(objCase);
                    objCase.Type = 'Quotes/Availability';
                    objCase.Sub_Class__c = '';
                    caseList.add(objCase);
                }
                //SR# 358711 Changes - Start
                if(System.Trigger.NewMap.get(objNewCase.Id).OwnerId == label.CSO_BGA_Spares_Team_ID)
                {
                    Case objCase = new Case(id = objNewCase.id);
                    objCase.Classification__c = 'CSO BGA Spares';
                    caseList.add(objCase);                   
                }
                //SR# 358711 Changes End  
                //SR# 362869 Changes - Start
                if(System.Trigger.NewMap.get(objNewCase.Id).OwnerId == label.CSO_BGA_OEM_Team_label)
                {
                    Case objCase = new Case(id = objNewCase.id);
                    objCase.RecordtypeId = label.OEM_Quotes_Orders_ID;
                    objCase.Classification__c = 'CSO OEM – BGA';
                    objCase.Sub_Class__c = '';
                    objCase.Type = '';
                    objCase.Detail_Class__c = '';
                    caseToUpdate.put(objCase.id,objCase);
                    //caseList.add(objCase);                   
                }//SR# 362869 Changes - End 
                //SR# 370843 - Start
                if(strOwnerName.equals('ATR OEM Components_Queue'))
                {
                    Case objCase = new Case(id = objNewCase.id);
                    objCase.RecordtypeId = label.OEM_Quotes_Orders_ID;
                    objCase.Classification__c = 'CSO OEM – ATR';
                    objCase.Sub_Class__c = 'Components';
                    objCase.Type = '';
                    objCase.Detail_Class__c = '';
                    caseList.add(objCase);  
                }
                if(strOwnerName.equals('ATR OEM Boeing_Queue'))
                {
                    Case objCase = new Case(id = objNewCase.id);
                    objCase.RecordtypeId = label.OEM_Quotes_Orders_ID;
                    objCase.Classification__c = 'CSO OEM – ATR';
                    objCase.Sub_Class__c = 'Boeing';
                    objCase.Type = '';
                    objCase.Detail_Class__c = '';
                    caseList.add(objCase);
                }
                if(strOwnerName.equals('ATR OEM Airbus_Queue'))
                {
                    Case objCase = new Case(id = objNewCase.id);
                    objCase.RecordtypeId = label.OEM_Quotes_Orders_ID;
                    objCase.Classification__c = 'CSO OEM – ATR';
                    objCase.Sub_Class__c = 'Airbus';
                    objCase.Type = '';
                    objCase.Detail_Class__c = '';
                    caseList.add(objCase);
                }//SR#370843                

                //GSS Integration Modifications
                if(strOwnerName.equals('GSS Quotes Team_Queue'))
                {
                    Case objCase = new Case(id = objNewCase.id);
                    objCase.RecordtypeId = label.GSS_Quotes_Orders;
                    objCase.Classification__c = 'GSE Quotes';
                    objCase.Sub_Class__c = '';
                    objCase.Type = '';
                    objCase.Detail_Class__c = '';
                    caseList.add(objCase);
                }
                if(strOwnerName.equals('GSS_Orders_Team_Queue'))
                {
                    Case objCase = new Case(id = objNewCase.id);
                    objCase.RecordtypeId = label.GSS_Quotes_Orders;
                    objCase.Classification__c = 'GSE Orders';
                    objCase.Sub_Class__c = '';
                    objCase.Type = '';
                    objCase.Detail_Class__c = '';
                    caseList.add(objCase);
                }
                if(strOwnerName.equals('GSS_Support_Team_Queue'))
                {
                    Case objCase = new Case(id = objNewCase.id);
                    objCase.RecordtypeId = label.GSS_Technical_Support;
                    objCase.Classification__c = 'GSE Technical Support';
                    objCase.Sub_Class__c = '';
                    objCase.Type = '';
                    objCase.Detail_Class__c = '';
                    caseList.add(objCase);
                }
                if(strOwnerName.equals('GSS_Vendor_Support_Team_Queue'))
                {
                    Case objCase = new Case(id = objNewCase.id);
                    objCase.RecordtypeId = label.GSS_Quotes_Orders;
                    objCase.Classification__c = 'GSE Vendor Support';
                    objCase.Sub_Class__c = '';
                    objCase.Type = '';
                    objCase.Detail_Class__c = '';
                    caseList.add(objCase);
                }
                //end of GSS Integration Modifications
            }
            //SR# 362869 Changes - Start
           /* if(System.Trigger.OldMap.get(objNewCase.Id).SBU__c != System.Trigger.NewMap.get(objNewCase.Id).SBU__c){
                if(objNewCase.SBU__c == 'D&S' && objNewCase.RecordtypeId == label.OEM_Quotes_Orders_ID){
                    Case objCase = new Case(id = objNewCase.id);
                    objCase.Classification__c = 'CSO OEM – D&S';
                    caseList.add(objCase);
                }
                if(objNewCase.SBU__c == 'ATR' && objNewCase.RecordtypeId == label.OEM_Quotes_Orders_ID){
                    Case objCase = new Case(id = objNewCase.id);
                    objCase.Classification__c = 'CSO OEM – ATR';
                    caseList.add(objCase);
                }
                if(objNewCase.SBU__c == 'BGA' && objNewCase.RecordtypeId == label.OEM_Quotes_Orders_ID){
                    Case objCase = new Case(id = objNewCase.id);
                    objCase.Classification__c = '';
                    caseList.add(objCase);
                }   
            }
            //SR# 362869 Changes End
        }
        if(Trigger.isinsert)
        {
            String strOwnerName = getOwnerName(System.Trigger.NewMap.get(objNewCase.Id).OwnerId, qtype);  
            if(strOwnerName.equals('R&O APU_Queue'))
            {
                Case objCase = new Case(id = objNewCase.id);
                setROCaseDetails(objCase);
                objCase.Sub_Class__c = 'APU';
                caseList.add(objCase);
            }
            if(strOwnerName.equals('R&O Avionics_Queue'))
            {               
                Case objCase = new Case(id = objNewCase.id);
                setROCaseDetails(objCase);
                objCase.Sub_Class__c = 'Avionics';
                caseList.add(objCase);
            }
            if(strOwnerName.equals('R&O Engines_Queue'))
            {
                Case objCase = new Case(id = objNewCase.id);
                setROCaseDetails(objCase);
                objCase.Sub_Class__c = 'Engines';
                caseList.add(objCase);
            }
            if(strOwnerName.equals('R&O FastShop_Queue'))
            {          
                Case objCase = new Case(id = objNewCase.id);
                setROCaseDetails(objCase);
                objCase.Sub_Class__c = 'FastShop';
                caseList.add(objCase);
            }
            if(strOwnerName.equals('R&O Mech Components_Queue'))
            {
                Case objCase = new Case(id = objNewCase.id);
                setROCaseDetails(objCase);
                objCase.Sub_Class__c = 'Mech Components';
                caseList.add(objCase);
            }
            // Added code for ticket #349250
            if(strOwnerName.equals('R&O Quotes Team_Queue'))
            {
                Case objCase = new Case(id = objNewCase.id);
                objCase.Type = 'Quotes/Availability';
                objCase.Classification__c = 'CSO Repair/Overhaul';
                objCase.Sub_Class__c = 'Quotes COE - Customer Response';
                objCase.Repair_Location__c = '';
                caseList.add(objCase);
            }
            if(strOwnerName.equals('R&O Quotes Team Escalation_Queue'))
            {
                Case objCase = new Case(id = objNewCase.id);
                objCase.Type = 'Quotes/Availability';
                objCase.Classification__c = 'CSO Repair/Overhaul';
                objCase.Sub_Class__c = 'Quotes COE - Escalation';
                objCase.Repair_Location__c = '';
                caseList.add(objCase);
            }
            // End of the code for ticket #349250
            if(strOwnerName.equals('R&O Wheels and Brakes/Greer_Queue'))
            {
                Case objCase = new Case(id = objNewCase.id);
                setROCaseDetails(objCase);
                objCase.Sub_Class__c = 'W&B/Greer';
                caseList.add(objCase);
            }
            // Added code for SR#: 374873
            if(strOwnerName.equals('Secan R&O_Queue'))
            {
                Case objCase = new Case(id = objNewCase.id);
                objCase.RecordTypeid = label.Repair_Overhaul_RT_ID;
                objCase.Classification__c = 'CSO Repair/Overhaul';
                objCase.Sub_Class__c = '';
                objCase.Detail_Class__c = '';
                objCase.Repair_Location__c = 'Secan';
                objCase.Type = '';
                casee.add(objCase);
            }if(strOwnerName.equals('Secan Spares_Queue'))
            {
                Case objCase = new Case(id = objNewCase.id);
                objCase.RecordTypeid = label.Orders_Rec_ID;
                objCase.Classification__c = 'CSO Spares';
                objCase.Sub_Class__c = 'Secan';
                objCase.Detail_Class__c = '';
                objCase.Repair_Location__c = 'Gennevilliers';
                objCase.Type = '';
                casee.add(objCase);
            }
            // End of SR#: 374873
            // Added code for SR#:378618
            if(strOwnerName.equals('R&O EMEA Quotes Team_Queue'))
            {
                Case objCase = new Case(id = objNewCase.id);
                objCase.RecordTypeid = label.Repair_Overhaul_RT_ID;
                objCase.Classification__c = 'CSO Repair/Overhaul';
                objCase.Sub_Class__c = 'Quotes COE - Customer Response';
                objCase.Detail_Class__c = 'COE';
                objCase.Repair_Location__c = '';
                objCase.Type = 'Quotes/Availability';
                casee.add(objCase);
            }
            if(strOwnerName.equals('R&O EMEAI Mechanical_Queue'))
            {
                Case objCase = new Case(id = objNewCase.id);
                objCase.RecordTypeid = label.Repair_Overhaul_RT_ID;
                objCase.Classification__c = 'CSO Repair/Overhaul';
                objCase.Sub_Class__c = '';
                objCase.Detail_Class__c = '';
                objCase.Repair_Location__c = '';
                objCase.Type = 'Other';
                casee.add(objCase);
            }
            if(strOwnerName.equals('R&O EMEAI Avionics_Queue'))
            {
                Case objCase = new Case(id = objNewCase.id);
                objCase.RecordTypeid = label.Repair_Overhaul_RT_ID;
                objCase.Classification__c = 'CSO Repair/Overhaul';
                objCase.Sub_Class__c = '';
                objCase.Detail_Class__c = '';
                objCase.Repair_Location__c = '';
                objCase.Type = 'Other';
                casee.add(objCase);
            }
            // End of SR#: 378618
            // Added code for SR#:397671
            if(strOwnerName.equals('R&O EMEA Order Entry Avionics_Queue'))
            {
                Case objCase = new Case(id = objNewCase.id);
                objCase.RecordTypeid = label.Repair_Overhaul_RT_ID;
                objCase.Classification__c = 'CSO Repair/Overhaul';
                objCase.Sub_Class__c = '';
                objCase.Repair_Location__c = 'EMEAI Avionics';
                objCase.Type = 'Place Order';
                casee.add(objCase);
            }
            if(strOwnerName.equals('ROEMEAShipping/InvoicingAvionics_Queue'))
            {
                Case objCase = new Case(id = objNewCase.id);
                objCase.RecordTypeid = label.Repair_Overhaul_RT_ID;
                objCase.Classification__c = 'CSO Repair/Overhaul';
                objCase.Sub_Class__c = '';
                objCase.Repair_Location__c = 'EMEAI Avionics';
                objCase.Type = 'Shipping/Invoicing';
                casee.add(objCase);
            }
            if(strOwnerName.equals('ROEMEAShipping/InvoicingMech_Queue'))
            {
                Case objCase = new Case(id = objNewCase.id);
                objCase.RecordTypeid = label.Repair_Overhaul_RT_ID;
                objCase.Classification__c = 'CSO Repair/Overhaul';
                objCase.Sub_Class__c = '';
                objCase.Repair_Location__c = 'EMEAI Mechanical';
                objCase.Type = 'Shipping/Invoicing';
                casee.add(objCase);
            }
            // End of SR#: 397671
            // Added code for SR#:398488
            //Commented for SR INC000006577271
            /*if(strOwnerName.equals('Singapore R&O Mechanical_Queue'))
            {
                Case objCase = new Case(id = objNewCase.id);
                objCase.RecordTypeid = label.Repair_Overhaul_RT_ID;
                objCase.Classification__c = 'CSO Repair/Overhaul';
                objCase.Sub_Class__c = '';
                objCase.Repair_Location__c = 'Singapore Mech';
                objCase.Type = '';
                casee.add(objCase);
            }
            if(strOwnerName.equals('Singapore R&O Avionics_Queue'))
            {
                Case objCase = new Case(id = objNewCase.id);
                objCase.RecordTypeid = label.Repair_Overhaul_RT_ID;
                objCase.Classification__c = 'CSO Repair/Overhaul';
                objCase.Sub_Class__c = '';
                objCase.Repair_Location__c = 'Singapore AvEi';
                objCase.Type = 'Other';
                casee.add(objCase);
            }
            if(strOwnerName.equals('Xiamen R&O Mechanical_Queue'))
            {
                Case objCase = new Case(id = objNewCase.id);
                objCase.RecordTypeid = label.Repair_Overhaul_RT_ID;
                objCase.Classification__c = 'CSO Repair/Overhaul';
                objCase.Sub_Class__c = '';
                objCase.Repair_Location__c = 'XiaMen';
                objCase.Type = '';
                casee.add(objCase);
            }
            if(strOwnerName.equals('Shanghai R&O Avionics_Queue'))
            {
                Case objCase = new Case(id = objNewCase.id);
                objCase.RecordTypeid = label.Repair_Overhaul_RT_ID;
                objCase.Classification__c = 'CSO Repair/Overhaul';
                objCase.Sub_Class__c = '';
                objCase.Repair_Location__c = 'Shanghai AvEi';
                objCase.Type = '';
                casee.add(objCase);
            }
            if(strOwnerName.equals('Shanghai R&O W&B_Queue'))
            {
                Case objCase = new Case(id = objNewCase.id);
                objCase.RecordTypeid = label.Repair_Overhaul_RT_ID;
                objCase.Classification__c = 'CSO Repair/Overhaul';
                objCase.Sub_Class__c = '';
                objCase.Repair_Location__c = 'Shanghai W&B (CEASA)';
                objCase.Type = '';
                casee.add(objCase);
            }
            if(strOwnerName.equals('Shanghai R&O Quote_Queue'))
            {
                Case objCase = new Case(id = objNewCase.id);
                objCase.RecordTypeid = label.Repair_Overhaul_RT_ID;
                objCase.Classification__c = 'CSO Repair/Overhaul';
                objCase.Sub_Class__c = '';
                objCase.Repair_Location__c = 'Shanghai Quote/OE';
                objCase.Type = 'Quotes/Availability';
                casee.add(objCase);
            }
            if(strOwnerName.equals('Shanghai R&O OE_Queue'))
            {
                Case objCase = new Case(id = objNewCase.id);
                objCase.RecordTypeid = label.Repair_Overhaul_RT_ID;
                objCase.Classification__c = 'CSO Repair/Overhaul';
                objCase.Sub_Class__c = '';
                objCase.Repair_Location__c = 'Shanghai Quote/OE';
                objCase.Type = 'Place Order';
                casee.add(objCase);
            }
            // End of SR#: 398488
            // Added code for Igloo ticket
            if(strOwnerName.equals('R&O D&S_Queue'))
            {
                Case objCase = new Case(id = objNewCase.id);
                objCase.RecordTypeid = label.Repair_Overhaul_RT_ID;
                objCase.Classification__c = 'CSO Repair/Overhaul';
                objCase.Sub_Class__c = 'D&S R&O';
                casee.add(objCase);
            }
            // End code for Igloo ticket
            if(strOwnerName.equals('D&S PR Orders Team_Queue'))
            {
                Case objCase = new Case(id = objNewCase.id);
                setDSCaseDetails(objCase);
                objCase.Type = 'Place Order';
                objCase.Sub_Class__c = '';
                caseList.add(objCase);
            }
            if(strOwnerName.equals('D&S PR Quotes Team_Queue'))
            {
                Case objCase = new Case(id = objNewCase.id);
                setDSCaseDetails(objCase);
                objCase.Type = 'Quotes/Availability';
                objCase.Sub_Class__c = '';
                caseList.add(objCase);
            }
            //SR# 358711 Changes - Start
            if(System.Trigger.NewMap.get(objNewCase.Id).OwnerId == label.CSO_BGA_Spares_Team_ID)
            {
                Case objCase = new Case(id = objNewCase.id);
                objCase.Classification__c = 'CSO BGA Spares';
                caseList.add(objCase);                   
            }
            //SR# 358711 Changes End             
            //SR# 362869 Changes - Start
            if(objNewCase.RecordtypeId == label.OEM_Quotes_Orders_ID &&
                 System.Trigger.NewMap.get(objNewCase.Id).OwnerId == label.CSO_BGA_OEM_Team_label)
            {
                Case objCase = new Case(id = objNewCase.id);
                objCase.Classification__c = 'CSO OEM – BGA';
                objCase.Sub_Class__c = '';
                objCase.Type = '';
                objCase.Detail_Class__c = '';
                //caseList.add(objCase);  
                caseToUpdate.put(objCase.id,objCase);
            }      
            /*if(objNewCase.SBU__c == 'D&S' && objNewCase.RecordtypeId == label.OEM_Quotes_Orders_ID && objNewCase.Origin.Contains('Email')){
                Case objCase = new Case(id = objNewCase.id);
                objCase.Classification__c = 'CSO OEM – D&S';
                caseList.add(objCase);
            }
            if(objNewCase.SBU__c == 'ATR' && objNewCase.RecordtypeId == label.OEM_Quotes_Orders_ID && objNewCase.Origin.Contains('Email')){
                Case objCase = new Case(id = objNewCase.id);
                objCase.Classification__c = 'CSO OEM – ATR';
                caseList.add(objCase);
            }
            if(objNewCase.SBU__c == 'BGA' && objNewCase.RecordtypeId == label.OEM_Quotes_Orders_ID && objNewCase.Origin.Contains('Email')){
                Case objCase = new Case(id = objNewCase.id);
                objCase.Classification__c = 'CSO OEM – BGA';
                caseList.add(objCase);
            }
            //SR# 362869 Changes End
            //SR#370843  changes start
            if(objNewCase.RecordtypeId == label.OEM_Quotes_Orders_ID && strOwnerName.equals('ATR OEM Components_Queue'))
            {
                Case objCase = new Case(id = objNewCase.id);
                objCase.Classification__c = 'CSO OEM – ATR';
                objCase.Sub_Class__c = '';
                objCase.Type = '';
                objCase.Detail_Class__c = '';
                caseList.add(objCase);  
            }
            if(objNewCase.RecordtypeId == label.OEM_Quotes_Orders_ID && strOwnerName.equals('ATR OEM Airbus_Queue'))
            {
                Case objCase = new Case(id = objNewCase.id);
                objCase.Classification__c = 'CSO OEM – ATR';
                objCase.Sub_Class__c = '';
                objCase.Type = '';
                objCase.Detail_Class__c = '';
                caseList.add(objCase);  
            }  
            if(objNewCase.RecordtypeId == label.OEM_Quotes_Orders_ID && strOwnerName.equals('ATR OEM Boeing_Queue'))
            {
                Case objCase = new Case(id = objNewCase.id);
                objCase.Classification__c = 'CSO OEM – ATR';
                objCase.Sub_Class__c = '';
                objCase.Type = '';
                objCase.Detail_Class__c = '';
                caseList.add(objCase);  
            } //SR#370843 end
         }
    }
    if(caseToUpdate.size()> 0){
        Update caseToUpdate.Values();
    }
    if(caseList.size() > 0){
        update caseList;
    }
    if(casee.size()>0){
        update casee;
    }
    private Case setROCaseDetails(Case objCase)
    {
        objCase.RecordtypeId = label.Repair_Overhaul_RT_ID;
        objCase.Type = 'Repair Inquiry';
        objCase.Classification__c = 'CSO Repair/Overhaul';
        objCase.Detail_Class__c = '';
        return objCase;
    }
    private Case setDSCaseDetails(Case objCase)
    {
        objCase.RecordtypeId = label.D_S_Quotes_Orders_RT_ID;
        objCase.Classification__c = 'CSO D&S Internal';
        objCase.Detail_Class__c = '';
        return objCase;
    } 
    private String getOwnerName(String strOwnerId, List<R_O_Case_Reassignment_Queue__c> lstRoObj)
    {
        Integer intQtypeSize = lstRoObj.size();        
        for(Integer i=0; i<intQtypeSize; i++)
        {                    
            if(lstRoObj[i].QueueId__c.equals(strOwnerId))
            {
                return lstRoObj[i].name;
            }
        }        
        System.debug('Failure Case - Returning blank value');
        return '';
    }*/
}