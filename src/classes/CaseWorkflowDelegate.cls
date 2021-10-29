/*******************************************************************************
Name         : ObjCaseHelper
Created By   : Anusuya Murugiah
Company Name : NTT Data
Project      : <Phase-II>, <HealthCheck> 
Created Date : 19 September 2013
Usages       : This Class is to replace the set of Workflows which has common 
               fields rule criteria or fields in Field Update action.
Modification History  :
Date          Version No.     Modified by     Brief Description of Modification
15 Oct 2013   1.1             NTTDATA         HAN-0263 Healtcheck Sprint 2 
15 Nov 2013   1.2             NTTDATA         HAN-0263 Healtcheck Sprint 2 Fix  
15 Apr 2015   1.3             NTTDATA         INC000008568306 - Classification population to CSO Spares for Portal cases 
31 Aug 2016   1.4             TCS Run Team    INC000010638835– Change Technical Case Classification default for  Case Origin "Web
*******************************************************************************/
public class CaseWorkflowDelegate{
// Criteria Fields -> Cage_Code__c Product_Type__c Detail_Type__c Order_Type__c
// Fields to Update -> ownerid Classification__c Sub_Class__c  Detail_Class__c

public static void caseWFDelegate(List<Case> listObjCase ){  
    // HealthCheck Sprint 2 Changes - Start
    Set<String> setCountryName = new Set<String>();
    Set<String> setCountryName1 = new Set<String>();
    List<String> listCountryName = new List<String>();
    // HealthCheck Sprint 2 Changes - End 
    Map<String,QueueTeam__c> mapQueueID = QueueTeam__c.getALL();
    Map<String,ClassificationList__c> mapClassification = ClassificationList__c.getALL();
    Map<String,SubClassList__c> mapSubClass = SubClassList__c.getALL(); 
    Case exceptionCase;    
    Schema.DescribeSObjectResult CaseDesc = Schema.SObjectType.Case;
    Map<ID,Schema.RecordTypeInfo> CasertMapByName = CaseDesc.getRecordTypeInfosById();
    Schema.RecordTypeInfo CaseRTByName;
    
    
    try{    
    for (Case objCase : listObjCase)  
    {       exceptionCase = objCase;                                
            CaseRTByName = CasertMapByName.get(objCase.recordtypeid);
            if(null!=objCase.Origin && objCase.Origin.equals(ConstantsForCaseWFDelegate.ORIGIN_WEB))
            {                      
                system.debug('Userinfo.getUserId'+Userinfo.getUserID());
                // WF - Web Route Disputes Team
                if((ConstantsForCaseWFDelegate.TYPE_INVOICE_DISPUTES).equals(objCase.type))
                {
                    objCase.Ownerid = mapQueueID.get(ConstantsForCaseWFDelegate.Q_INVOICE_DISPUTES_TEAM).queueid__c ;
                    objCase.Classification__c = mapClassification .get(ConstantsForCaseWFDelegate.CLSFN_CSO_SPECIAL_PRGM).classification__c;
                    objCase.Sub_Class__c = mapSubClass.get(ConstantsForCaseWFDelegate.SUBCLS_INVOICE_DISPUTES ).subclass__c;
                }
                // WF - Web Route to Pubs team
                // WF - WebCase TechPubs
                system.debug('objCase.type'+objCase.type);
                system.debug('ConstantsForCaseWFDelegate.TYPE_TECH_PUBS'+ConstantsForCaseWFDelegate.TYPE_TECH_PUBS);
                if((ConstantsForCaseWFDelegate.TYPE_TECH_PUBS).equals(objCase.type))
                {         
                   system.debug('objCase.type111'+objCase.type);
                   objCase.Ownerid = mapQueueID.get(ConstantsForCaseWFDelegate.Q_PUBS_TEAM).queueid__c ;
                   //SR#439445 - code change start
                   //objCase.Classification__c = mapClassification .get(ConstantsForCaseWFDelegate.CLSFN_CSO_SPECIAL_PRGM).classification__c;
                   objCase.Classification__c = mapClassification .get(ConstantsForCaseWFDelegate.CLSFN_TECH_PUBS).classification__c;
                   //SR#439445 - code change Ends
                   objCase.Sub_Class__c = mapSubClass.get(ConstantsForCaseWFDelegate.SUBCLS_PUBLICATIONS ).subclass__c;                   
                }
                // WF - Web Route to Returns Team  
                // code modified for INC#INC000006857732 and added RecordType COndition
                if((ConstantsForCaseWFDelegate.TYPE_RETURNS).equals(objCase.type) && objCase.RecordTypeid!=label.Internal_Escalations )
                {
                    objCase.Ownerid = mapQueueID.get(ConstantsForCaseWFDelegate.Q_RETURNS_TEAM).queueid__c ;
                    objCase.Classification__c = mapClassification .get(ConstantsForCaseWFDelegate.CLSFN_CSO_SPARES ).classification__c;                    
                }
                // WF - Web Route to Warranty Team
                if((ConstantsForCaseWFDelegate.TYPE_WARRANTY).equals(objCase.type))
                {
                if(objCase.Subject!=label.Warranty_Case_Subject){
                    objCase.Ownerid = mapQueueID.get(ConstantsForCaseWFDelegate.Q_WARRANTY_TEAM ).queueid__c ;
                  }
                    objCase.Classification__c = mapClassification.get(ConstantsForCaseWFDelegate.CLSFN_CSO_WARRANTY ).classification__c; 
                }
                // WF - WebCase Technical Issue 
                if((ConstantsForCaseWFDelegate.TYPE_TECHNICAL_ISSUE).equals(objCase.type) )
                {  
                    /* 24 July added below line of code to set case owner based on Case type */
                    if(objCase.DESCRIPTION!=null){
                    system.debug('++++1 '+objCase.DESCRIPTION);
                    if(objCase.DESCRIPTION.contains('Type of Product: Bendix King')){
                        system.debug('Bendix King');
                        system.debug('++++2 '+objCase.DESCRIPTION);
                        system.debug('Label.ATS_BK_Team '+Label.ATS_BK_Team);
                        objCase.OwnerId = Label.ATS_BK_Team;
                       
                    }else if(objCase.DESCRIPTION.contains('Type of Product: Electrical') || objCase.DESCRIPTION.contains('Type of Product: Lighting')){
                        objCase.OwnerId = Label.ATS_Elect_Team;
                        
                    }else if(objCase.DESCRIPTION.contains('Type of Product: Mechanical') || objCase.DESCRIPTION.contains('Type of Product: Wheels & Brakes')){
                        objCase.OwnerId = Label.ATS_Mech_Team;
                        
                    }else if(objCase.DESCRIPTION.contains('Type of Product: Not Listed') || objCase.DESCRIPTION.contains('Type of Product: Services') || objCase.DESCRIPTION.contains('Type of Product: Unnamed')){
                        objCase.OwnerId = Label.ATS_Team;
                    }
                    else{
                    
                    objCase.Ownerid = mapQueueID.get(ConstantsForCaseWFDelegate.Q_TOC_TEAM ).queueid__c ;
                    
                    }
                }
                /*code completed - added line of code to set case owner based on Case type */
                
                
                    //objCase.Ownerid = mapQueueID.get(ConstantsForCaseWFDelegate.Q_TOC_TEAM ).queueid__c ;
                    /* Only above line is commented for not to populate ownerid = ATS Team always. Populate based on product type --  20 July 2018*/
                    //INC000010638835 -Starts
                   // objCase.Classification__c = mapClassification .get(ConstantsForCaseWFDelegate.CLSFN_GTO_TECH_OPER_CENTER ).classification__c; 
                   //INC000010638835 - Ends
                }
                // WF -  WebCase D&S Quotes Orders             
                if((ConstantsForCaseWFDelegate.RT_DS_QUOTES_ORDERS).equals(CaseRTByName.getName()))
                {
                    if((ConstantsForCaseWFDelegate.TYPE_PLACE_ORDER).equals(objCase.type) || (ConstantsForCaseWFDelegate.TYPE_ORDER_CHANGES).equals(objCase.type) 
                    || (ConstantsForCaseWFDelegate.TYPE_ORDER_STATUS).equals(objCase.type) )
                    {
                        objCase.Ownerid = mapQueueID.get(ConstantsForCaseWFDelegate.Q_DS_ORDERS_TEAM ).queueid__c ;
                        objCase.Classification__c = mapClassification.get(ConstantsForCaseWFDelegate.CLSFN_CSO_DS_INTERNAL ).classification__c;
                    }
                }
                // WF - Web Route to Quotes Team
                // WF - WebCase Quotes/Availability CageCode Except 55284, 97896, 22373, 55939
                if((ConstantsForCaseWFDelegate.TYPE_QUOTES_AVAILABILITY).equals(objCase.type) && (objCase.RecordTypeId!=null && objCase.RecordtypeId!=Label.Internal_Escalations))
                {
                    objCase.Ownerid = mapQueueID.get(ConstantsForCaseWFDelegate.Q_QUOTES_TEAM ).queueid__c ;
                    objCase.Classification__c = mapClassification.get(ConstantsForCaseWFDelegate.CLSFN_CSO_SPARES ).classification__c;                        
                    // WF - WebCase Quotes/Availability CageCode55284
                    if((ConstantsForCaseWFDelegate.PLANTCODE_55284).equals(objCase.Cage_Code__c) )
                    {                        
                        objCase.Sub_Class__c = mapSubClass.get(ConstantsForCaseWFDelegate.SUBCLS_WHEELS_BRAKES ).subclass__c;                                           
                    }
                    // WF - WebCase Quotes/Availability CageCode97896
                    else if((ConstantsForCaseWFDelegate.PLANTCODE_97896).equals(objCase.Cage_Code__c)  )
                    {                        
                        objCase.Sub_Class__c = mapSubClass.get(ConstantsForCaseWFDelegate.SUBCLS_REDMOND ).subclass__c;                                           
                    }
                    // WF - WebCase Quotes/Availability CageCode55939
                    else if((ConstantsForCaseWFDelegate.PLANTCODE_55939).equals(objCase.Cage_Code__c)  )
                    {                        
                        objCase.Sub_Class__c = mapSubClass.get(ConstantsForCaseWFDelegate.SUBCLS_NEW_SPARES).subclass__c;
                        objCase.Detail_class__c = ConstantsForCaseWFDelegate.DETAILCLS_AVIONICS ;                                           
                    }
                    // WF - WebCase Quotes/Availability CageCode22373
                    else if((ConstantsForCaseWFDelegate.PLANTCODE_22373).equals(objCase.Cage_Code__c) )
                    {                        
                        objCase.Sub_Class__c = mapSubClass.get(ConstantsForCaseWFDelegate.SUBCLS_BENDIX_SLASH_KING ).subclass__c;                                                                 
                    }                                       
                }
                // WF - WebCaseOrder Status Services
                if(!((ConstantsForCaseWFDelegate.PLANTCODE_55284).equals(objCase.Cage_Code__c)  || (ConstantsForCaseWFDelegate.PLANTCODE_97896).equals(objCase.Cage_Code__c)
                        || (ConstantsForCaseWFDelegate.PLANTCODE_22373).equals(objCase.Cage_Code__c)  || (ConstantsForCaseWFDelegate.PLANTCODE_55939).equals(objCase.Cage_Code__c))  
                        && (ConstantsForCaseWFDelegate.TYPE_ORDER_STATUS).equals(objCase.type) && (ConstantsForCaseWFDelegate.ORDERTYPE_SERVICES).equals(objCase.Order_Type__c)
                        && null == objCase.Product_Type__c && null==objCase.Detail_Type__c)
                {                                                
                    objCase.Ownerid = mapQueueID.get(ConstantsForCaseWFDelegate.Q_ORDER_STATUS_TEAM ).queueid__c ;
                    objCase.Classification__c = mapClassification .get(ConstantsForCaseWFDelegate.CLSFN_CSO_SPARES ).classification__c;                        
                }
                //Code for INC000006051352 starts 
                if(((Userinfo.getUserID()==label.myaerospace_webform) || (Userinfo.getUserID()==label.API_User_My_Aerospace_Portal))
                    && (ConstantsForCaseWFDelegate.RT_QUOTES).equals(CaseRTByName.getName())  
                    && ((ConstantsForCaseWFDelegate.TYPE_QUOTES_AVAILABLITY).equals(objCase.type) || (ConstantsForCaseWFDelegate.TYPE_QUOTES_AVAILABILITY).equals(objCase.type))                    
                    && (objCase.Subject !=null && objCase.Subject.contains('Repair Quote - Quote Number'))                            
                    && (null != objCase.Order_Type__c && (ConstantsForCaseWFDelegate.ORDERTYPE_REPAIR).equals(objCase.Order_Type__c)))
                       {
                          objCase.RecordtypeId = label.Repair_Overhaul_RT_ID;
                          objCase.Ownerid = mapQueueID.get(ConstantsForCaseWFDelegate.Q_RO_ORDER_QUTOES_TEAM).queueid__c ;
                          objCase.Classification__c = mapClassification.get(ConstantsForCaseWFDelegate.CLSFN_RO_QUOTE).classification__c;                             
                          objCase.Type = ConstantsForCaseWFDelegate.TYPE_QUOTES_APPROVAL;
                          objCase.Sub_Class__c = 'Quotes COE – Customer Response';
                          objCase.Detail_class__c = '';
                          objCase.Priority = 'Normal';
                       } 
                //Code for INC000006051352 Ends

                // HealthCheck Sprint 2 Changes - Start
                // WebCaseOrderStatus-CSO Spares
                 if(!((ConstantsForCaseWFDelegate.PLANTCODE_55284).equals(objCase.Cage_Code__c)  || (ConstantsForCaseWFDelegate.PLANTCODE_97896).equals(objCase.Cage_Code__c)
                        || (ConstantsForCaseWFDelegate.PLANTCODE_22373).equals(objCase.Cage_Code__c)  || (ConstantsForCaseWFDelegate.PLANTCODE_55939).equals(objCase.Cage_Code__c))  
                        && (ConstantsForCaseWFDelegate.TYPE_ORDER_STATUS).equals(objCase.type) && (ConstantsForCaseWFDelegate.ORDERTYPE_SPARES).equals(objCase.Order_Type__c)
                        && null == objCase.Product_Type__c && null==objCase.Detail_Type__c)
                {
                    objCase.Classification__c = mapClassification .get(ConstantsForCaseWFDelegate.CLSFN_CSO_SPARES ).classification__c;                        
                    objCase.Sub_Class__c = null;
                }
                // HealthCheck  Sprint 2 Changes - End
                if((ConstantsForCaseWFDelegate.RT_ORDERS).equals(CaseRTByName.getName()) )
                { 
                    if(!((ConstantsForCaseWFDelegate.PLANTCODE_55284).equals(objCase.Cage_Code__c)  || (ConstantsForCaseWFDelegate.PLANTCODE_97896).equals(objCase.Cage_Code__c)
                        || (ConstantsForCaseWFDelegate.PLANTCODE_22373).equals(objCase.Cage_Code__c)  || (ConstantsForCaseWFDelegate.PLANTCODE_55939).equals(objCase.Cage_Code__c))  )
                    {            
                        if((ConstantsForCaseWFDelegate.TYPE_ORDER_STATUS).equals(objCase.type)) 
                        {
                            // WF - WebCase Order Status Spares
                            if((ConstantsForCaseWFDelegate.ORDERTYPE_SPARES).equals(objCase.Order_Type__c))
                            {
                                objCase.Ownerid = mapQueueID.get(ConstantsForCaseWFDelegate.Q_ORDER_STATUS_TEAM ).queueid__c ;
                                objCase.Classification__c = mapClassification .get(ConstantsForCaseWFDelegate.CLSFN_CSO_SPARES ).classification__c;                        
                            }
                            //Code for INC000005735440  Starts 
                           else if((Userinfo.getUserID()==label.myaerospace_webform)                              
                            && (objCase.Subject !=null && objCase.Subject.contains(ConstantsForCaseWFDelegate.subject) )                            
                            && (null != objCase.Order_Type__c && objCase.Order_Type__c.equals(ConstantsForCaseWFDelegate.ORDERTYPE_REPAIR_OVERHAUL)))
                               {
                                objCase.Ownerid = mapQueueID.get(ConstantsForCaseWFDelegate.Q_CSO_RO_TEAM).queueid__c ;
                                objCase.Classification__c = mapClassification .get(ConstantsForCaseWFDelegate.CLSFN_RO_ISSUES).classification__c;
                                objCase.RecordtypeId = label.Repair_Overhaul_RT_ID;
                                objCase.Type = 'Repair Inquiry';
                                objCase.Sub_Class__c = '';
                                objCase.Detail_class__c = '';
                                objCase.Priority = 'Normal';
                                system.debug('Testing ROCAP');
                               } 
                            //Code for INC000005735440  Ends  
                            // WF - WebCaseOrderStatus-CSO R&O
                            else if((ConstantsForCaseWFDelegate.ORDERTYPE_REPAIR_OVERHAUL).equals(objCase.Order_Type__c) && null == objCase.Product_Type__c
                                && null == objCase.Detail_Type__c )
                            {
                                objCase.Ownerid = mapQueueID.get(ConstantsForCaseWFDelegate.Q_CSO_RO_TEAM).queueid__c ;
                                objCase.Classification__c = mapClassification .get(ConstantsForCaseWFDelegate.CLSFN_CSO_REPAIR_OVERHAUL ).classification__c;
                                objCase.Sub_Class__c = null;
                            }                                                 
                        }                        
                        else if((ConstantsForCaseWFDelegate.TYPE_ORDER_CHANGES).equals(objCase.type))
                        {
                            if((ConstantsForCaseWFDelegate.ORDERTYPE_REPAIR_OVERHAUL).equals(objCase.Order_Type__c) && null == objCase.Detail_Type__c)
                            {
                                if((ConstantsForCaseWFDelegate.PRODTYPE_MECHANICAL).equals(objCase.Product_Type__c)  || (ConstantsForCaseWFDelegate.PRODTYPE_WHEELS_BRAKES).equals(objCase.Product_Type__c) 
                                    || (ConstantsForCaseWFDelegate.PRODTYPE_LIGHTING).equals(objCase.Product_Type__c)  || (ConstantsForCaseWFDelegate.PRODTYPE_ELECTRICAL).equals(objCase.Product_Type__c) )
                                {
                                    objCase.Ownerid = mapQueueID.get(ConstantsForCaseWFDelegate.Q_CSO_RO_TEAM).queueid__c ;
                                    objCase.Classification__c = mapClassification .get(ConstantsForCaseWFDelegate.CLSFN_CSO_REPAIR_OVERHAUL ).classification__c;                        
                                }
                                // WF - WebCase-Order Changes-CSO R&O
                                if((ConstantsForCaseWFDelegate.PRODTYPE_LIGHTING).equals(objCase.Product_Type__c) )
                                {                                    
                                    objCase.Sub_Class__c = null;
                                }
                                // WF - WebCase-Order Changes-CSO R&Oelectrical
                                else if((ConstantsForCaseWFDelegate.PRODTYPE_ELECTRICAL).equals(objCase.Product_Type__c) )
                                {                                    
                                    objCase.Sub_Class__c = mapSubClass.get(ConstantsForCaseWFDelegate.SUBCLS_ELECTRICAL_RO ).subclass__c;
                                }
                                // WF - WebCase-Order Changes-CSO R&Omechanical
                                // WF - WebCase-Order Changes-CSO R&OWheels&Brakes
                                else if((ConstantsForCaseWFDelegate.PRODTYPE_MECHANICAL).equals(objCase.Product_Type__c)  
                                    || (ConstantsForCaseWFDelegate.PRODTYPE_WHEELS_BRAKES).equals(objCase.Product_Type__c) )
                                {                                    
                                    objCase.Sub_Class__c = mapSubClass.get(ConstantsForCaseWFDelegate.SUBCLS_MECHANICAL_RO ).subclass__c;
                                }                                
                            }
                            if((ConstantsForCaseWFDelegate.ORDERTYPE_SPARES).equals(objCase.Order_Type__c) || (ConstantsForCaseWFDelegate.ORDERTYPE_SERVICES).equals(objCase.Order_Type__c))                                 
                            {
                                // WF - WebCase-Order Changes-CSOSpares
                                if(((ConstantsForCaseWFDelegate.PRODTYPE_LIGHTING).equals(objCase.Product_Type__c) || (ConstantsForCaseWFDelegate.PRODTYPE_ELECTRICAL).equals(objCase.Product_Type__c)  
                                || (ConstantsForCaseWFDelegate.PRODTYPE_MECHANICAL).equals(objCase.Product_Type__c)) 
                                && null == objCase.Detail_Type__c)
                                {
                                    objCase.Ownerid = mapQueueID.get(ConstantsForCaseWFDelegate.Q_ORDER_CHANGES_TEAM ).queueid__c ;
                                    objCase.Classification__c = mapClassification .get(ConstantsForCaseWFDelegate.CLSFN_CSO_SPARES ).classification__c;
                                }
                                // WF - WebCase-Order Changes-CSOSparesWheels
                                // WF - WebCase-Order Changes-MechanicalSparesServices
                                if((ConstantsForCaseWFDelegate.PRODTYPE_WHEELS_BRAKES).equals(objCase.Product_Type__c)  
                                    || (ConstantsForCaseWFDelegate.PRODTYPE_MECHANICAL).equals(objCase.Product_Type__c) )
                                {
                                    objCase.Ownerid = mapQueueID.get(ConstantsForCaseWFDelegate.Q_ORDER_CHANGES_TEAM).queueid__c ;
                                    objCase.Classification__c = mapClassification .get(ConstantsForCaseWFDelegate.CLSFN_CSO_SPARES).classification__c;
                                    objCase.Sub_Class__c = mapSubClass.get(ConstantsForCaseWFDelegate.SUBCLS_WHEELS_BRAKES ).subclass__c;                                    
                                }
                            }
                            // WF - WebCase-Order Changes-CSOSparesBendix/King 
                            if(((ConstantsForCaseWFDelegate.ORDERTYPE_SPARES).equals(objCase.Order_Type__c) || (ConstantsForCaseWFDelegate.ORDERTYPE_SERVICES).equals(objCase.Order_Type__c)
                                || (ConstantsForCaseWFDelegate.ORDERTYPE_REPAIR_OVERHAUL).equals(objCase.Order_Type__c)) 
                                && (ConstantsForCaseWFDelegate.PRODTYPE_BENDIX_HYPHEN_KING).equals(objCase.Product_Type__c) && null == objCase.Detail_Type__c )
                            {
                                    objCase.Ownerid = mapQueueID.get(ConstantsForCaseWFDelegate.Q_ORDER_CHANGES_TEAM ).queueid__c ;
                                    objCase.Classification__c = mapClassification .get(ConstantsForCaseWFDelegate.CLSFN_CSO_SPARES ).classification__c;
                                    objCase.Sub_Class__c = mapSubClass.get(ConstantsForCaseWFDelegate.SUBCLS_BENDIX_HYPHEN_KING ).subclass__c;   
                            }                           
                        }                        
                        //else if((ConstantsForCaseWFDelegate.TYPE_PLACE_ORDER).equals(objCase.type) && (ConstantsForCaseWFDelegate.ORDERTYPE_SPARES).equals(objCase.Order_Type__c) 
                        //    && (ConstantsForCaseWFDelegate.PRODTYPE_ELECTRICAL).equals(objCase.Product_Type__c)  && (ConstantsForCaseWFDelegate.DETAILTYPE_SOFTWARE).equals(objCase.Detail_Type__c) )
                        else if((ConstantsForCaseWFDelegate.TYPE_PLACE_ORDER).equals(objCase.type))
                        {
                            if((ConstantsForCaseWFDelegate.ORDERTYPE_SPARES).equals(objCase.Order_Type__c)) 
                            {
                                if((ConstantsForCaseWFDelegate.PRODTYPE_ELECTRICAL).equals(objCase.Product_Type__c))
                                {
                                    // WF - WebCase Place Order Avionics Spares Software
                                    if( (ConstantsForCaseWFDelegate.DETAILTYPE_SOFTWARE).equals(objCase.Detail_Type__c))
                                    {
                                        objCase.Ownerid = mapQueueID.get(ConstantsForCaseWFDelegate.Q_ORDERS_TEAM ).queueid__c ;
                                        objCase.Classification__c = mapClassification .get(ConstantsForCaseWFDelegate.CLSFN_CSO_SPARES ).classification__c;
                                        objCase.Sub_Class__c = mapSubClass.get(ConstantsForCaseWFDelegate.SUBCLS_SOFTWARE).subclass__c;
                                    }
                                    // WF - WebCasePlace Order    Avionics    Spares   DetailPart
                                    if( (ConstantsForCaseWFDelegate.DETAILTYPE_DETAIL_PART).equals(objCase.Detail_Type__c))
                                    {
                                        objCase.Ownerid = mapQueueID.get(ConstantsForCaseWFDelegate.Q_ORDERS_TEAM ).queueid__c ;
                                        objCase.Classification__c = mapClassification .get(ConstantsForCaseWFDelegate.CLSFN_CSO_SPARES ).classification__c; // Modified for INC000008568306                                                                          
                                        listCountryName = (label.Case_Country_Values).split(';');        
                                        setCountryName.addAll(listCountryName);
                                        // WebCasePlace Order Avionics Spares Detail Part APAC
                                        if(setCountryName.contains(objCase.Country__c))
                                        {
                                            objCase.Ownerid = mapQueueID.get(ConstantsForCaseWFDelegate.Q_ORDERS_TEAM ).queueid__c ;
                                            objCase.Classification__c = mapClassification .get(ConstantsForCaseWFDelegate.CLSFN_CSO_SPARES ).classification__c;                                        
                                            objCase.Sub_Class__c = mapSubClass.get(ConstantsForCaseWFDelegate.SUBCLS_HON_INTERNATIONAL_SARL).subclass__c;
                                        }                          
                                        
                                        //setCountryName.clear(); // Clear the above set of Country Name
                                        listCountryName = (label.Case_Country_Values_Set1).split(';');        
                                        setCountryName1.addAll(listCountryName); // Add the above fresh Country From Set1
                                        listCountryName = (label.Case_Country_Values_Set2).split(';');
                                        setCountryName1.addAll(listCountryName); // Add the above fresh Country From Set2 along with Set1
                                        
                                        // WebCasePlace Order Avionics Spares Detail Part EMEA
                                        if(setCountryName1.contains(objCase.Country__c) )
                                        {
                                            objCase.Ownerid = mapQueueID.get(ConstantsForCaseWFDelegate.Q_ORDERS_TEAM ).queueid__c ;
                                            objCase.Classification__c = mapClassification .get(ConstantsForCaseWFDelegate.CLSFN_CSO_SPARES ).classification__c;                                        
                                            objCase.Sub_Class__c = mapSubClass.get(ConstantsForCaseWFDelegate.SUBCLS_GLB_MATERIAL_SERV).subclass__c;
                                        }
                                    }
                                    // WF - WebCasePlace Order Avionics Spares LRU
                                    if( (ConstantsForCaseWFDelegate.DETAILTYPE_LRU).equals(objCase.Detail_Type__c))
                                    {
                                        objCase.Ownerid = mapQueueID.get(ConstantsForCaseWFDelegate.Q_ORDERS_TEAM ).queueid__c ;
                                        objCase.Classification__c = mapClassification .get(ConstantsForCaseWFDelegate.CLSFN_CSO_SPARES ).classification__c;                                        
                                        objCase.Sub_Class__c = mapSubClass.get(ConstantsForCaseWFDelegate.SUBCLS_NEW_SPARES).subclass__c;
                                        objCase.Detail_Class__c = ConstantsForCaseWFDelegate.DETAILCLS_AVIONICS ;
                                    }
                                    // WF - WebCasePlace Order Avionics Spares Spex/Exchange
                                    if( (ConstantsForCaseWFDelegate.DETAILTYPE_SPEX_SLASH_EXCHANGE).equals(objCase.Detail_Type__c))
                                    {
                                        objCase.Ownerid = mapQueueID.get(ConstantsForCaseWFDelegate.Q_ORDERS_TEAM ).queueid__c ;
                                        objCase.Classification__c = mapClassification .get(ConstantsForCaseWFDelegate.CLSFN_CSO_SPARES ).classification__c;
                                        objCase.Sub_Class__c = mapSubClass.get(ConstantsForCaseWFDelegate.SUBCLS_SPEX_SLASH_EXCHANGE).subclass__c;
                                    }
                                }
                                // WF - WebCasePlace Order    Lighting    Spares    Detail part
                                // WF - WebCasePlace Order    Lighting    Spares    LRU
                                // WF - WebCasePlace Order    Lighting  Spares Software
                                // WF - WebCasePlace Order Lighting Spares Spex/Exchange
                                // WF - WebCasePlace Order Lighting Spares SPEX Exchange
                                // WF - WebCasePlace Order    Mechanical    Spares    Detail Part
                                // WF - WebCasePlace Order    Mechanical    Spares    LRU
                                // WF - WebCasePlace Order    Mechanical    Spares    Software
                                // WF - WebCasePlace Order    Mechanical    Spares    Spex/Exchange
                                if((ConstantsForCaseWFDelegate.PRODTYPE_LIGHTING).equals(objCase.Product_Type__c) 
                                 || (ConstantsForCaseWFDelegate.PRODTYPE_MECHANICAL).equals(objCase.Product_Type__c))
                                {
                                   if((ConstantsForCaseWFDelegate.DETAILTYPE_DETAIL_PART).equals(objCase.Detail_Type__c) 
                                       || (ConstantsForCaseWFDelegate.DETAILTYPE_LRU).equals(objCase.Detail_Type__c) 
                                       || (ConstantsForCaseWFDelegate.DETAILTYPE_SPEX_SLASH_EXCHANGE).equals(objCase.Detail_Type__c) 
                                       || (ConstantsForCaseWFDelegate.DETAILTYPE_SOFTWARE).equals(objCase.Detail_Type__c)
                                       || (ConstantsForCaseWFDelegate.DETAILTYPE_SPEX_EXCHANGE).equals(objCase.Detail_Type__c) )
                                   {
                                        objCase.Ownerid = mapQueueID.get(ConstantsForCaseWFDelegate.Q_ORDERS_TEAM ).queueid__c ;
                                        objCase.Classification__c = mapClassification .get(ConstantsForCaseWFDelegate.CLSFN_CSO_SPARES ).classification__c;
                                        objCase.Sub_Class__c = null;
                                   } 
                                   if((ConstantsForCaseWFDelegate.PRODTYPE_MECHANICAL).equals(objCase.Product_Type__c) 
                                       && (ConstantsForCaseWFDelegate.DETAILTYPE_SOFTWARE).equals(objCase.Detail_Type__c))
                                   {
                                       objCase.Sub_Class__c = mapSubClass.get(ConstantsForCaseWFDelegate.SUBCLS_SOFTWARE).subclass__c;
                                   }
                                }
                                if((ConstantsForCaseWFDelegate.PRODTYPE_BENDIX_HYPHEN_KING).equals(objCase.Product_Type__c))
                                {
                                   // WF - WebCasePlace Order    Bendix/King    Spares    LRU
                                   // WF - WebCasePlace Order    Bendix/King    Spares    Software
                                   // WF - WebCasePlace Order    Bendix/King    Spares    Spex/Exchange
                                   if( (ConstantsForCaseWFDelegate.DETAILTYPE_LRU).equals(objCase.Detail_Type__c) || (ConstantsForCaseWFDelegate.DETAILTYPE_SPEX_SLASH_EXCHANGE).equals(objCase.Detail_Type__c) 
                                      || (ConstantsForCaseWFDelegate.DETAILTYPE_SOFTWARE).equals(objCase.Detail_Type__c) )
                                   {
                                        objCase.Ownerid = mapQueueID.get(ConstantsForCaseWFDelegate.Q_ORDERS_TEAM ).queueid__c ;
                                        objCase.Classification__c = mapClassification .get(ConstantsForCaseWFDelegate.CLSFN_CSO_SPARES ).classification__c;
                                        objCase.Sub_Class__c = mapSubClass.get(ConstantsForCaseWFDelegate.SUBCLS_BENDIX_HYPHEN_KING).subclass__c;
                                   }
                                   // WF - WebCasePlace Order    Bendix/King    Spares    Detail Part
                                   else if((ConstantsForCaseWFDelegate.DETAILTYPE_DETAIL_PART).equals(objCase.Detail_Type__c))                                       
                                   {
                                        objCase.Ownerid = mapQueueID.get(ConstantsForCaseWFDelegate.Q_ORDERS_TEAM ).queueid__c ;
                                        objCase.Classification__c = mapClassification .get(ConstantsForCaseWFDelegate.CLSFN_CSO_SPARES ).classification__c;
                                        objCase.Sub_Class__c = mapSubClass.get(ConstantsForCaseWFDelegate.SUBCLS_BENDIX_SLASH_KING).subclass__c;
                                   }
                                }
                                // WF - WebCasePlace Order    Wheels and Brakes    Spares    Spex/Exchange
                                // WF - WebCasePlace Order    Wheels and Brakes Spares LRU
                                // WF - WebCasePlace Order  Wheels and Brakes  Spares  Detail Part
                                
                                if((ConstantsForCaseWFDelegate.PRODTYPE_WHEELS_BRAKES).equals(objCase.Product_Type__c)
                                    && ((ConstantsForCaseWFDelegate.DETAILTYPE_LRU).equals(objCase.Detail_Type__c) 
                                    || (ConstantsForCaseWFDelegate.DETAILTYPE_DETAIL_PART).equals(objCase.Detail_Type__c)
                                    || (ConstantsForCaseWFDelegate.DETAILTYPE_SPEX_SLASH_EXCHANGE).equals(objCase.Detail_Type__c) )  )
                                {
                                    objCase.Ownerid = mapQueueID.get(ConstantsForCaseWFDelegate.Q_ORDERS_TEAM ).queueid__c ;
                                    objCase.Classification__c = mapClassification .get(ConstantsForCaseWFDelegate.CLSFN_CSO_SPARES ).classification__c;
                                    objCase.Sub_Class__c = mapSubClass.get(ConstantsForCaseWFDelegate.SUBCLS_WHEELS_BRAKES).subclass__c;
                                }
                            }
                            if((ConstantsForCaseWFDelegate.ORDERTYPE_SERVICES).equals(objCase.Order_Type__c))    
                            {
                                // WF - WebCasePlace Order Lighting Services
                                if((ConstantsForCaseWFDelegate.PRODTYPE_LIGHTING).equals(objCase.Product_Type__c)
                                   && null != objCase.Detail_Type__c ) 
                                {
                                    objCase.Ownerid = mapQueueID.get(ConstantsForCaseWFDelegate.Q_ORDERS_TEAM ).queueid__c ;
                                    objCase.Classification__c = mapClassification .get(ConstantsForCaseWFDelegate.CLSFN_CSO_SPARES ).classification__c;
                                    objCase.Sub_Class__c = null;
                                }
                                // WF - WebCasePlace Order Bendix/King Services
                                if((ConstantsForCaseWFDelegate.PRODTYPE_BENDIX_HYPHEN_KING).equals(objCase.Product_Type__c)
                                   && null != objCase.Detail_Type__c ) 
                                {
                                    objCase.Ownerid = mapQueueID.get(ConstantsForCaseWFDelegate.Q_ORDERS_TEAM ).queueid__c ;
                                    objCase.Classification__c = mapClassification .get(ConstantsForCaseWFDelegate.CLSFN_CSO_SPARES ).classification__c;
                                    objCase.Sub_Class__c = mapSubClass.get(ConstantsForCaseWFDelegate.SUBCLS_BENDIX_SLASH_KING).subclass__c;
                                }
                                // WF - WebCasePlace Order Wheels and Brakes Services
                                if((ConstantsForCaseWFDelegate.PRODTYPE_WHEELS_BRAKES).equals(objCase.Product_Type__c)
                                   && null != objCase.Detail_Type__c ) 
                                {
                                    objCase.Ownerid = mapQueueID.get(ConstantsForCaseWFDelegate.Q_ORDERS_TEAM ).queueid__c ;
                                    objCase.Classification__c = mapClassification .get(ConstantsForCaseWFDelegate.CLSFN_CSO_SPARES ).classification__c;
                                    objCase.Sub_Class__c = mapSubClass.get(ConstantsForCaseWFDelegate.SUBCLS_WHEELS_BRAKES).subclass__c;
                                }
                                // WF - WebCasePlace Order Mechanical Services
                                // WF - WebCasePlace Order  Avionics  Services
                                if(((ConstantsForCaseWFDelegate.PRODTYPE_ELECTRICAL ).equals(objCase.Product_Type__c) || (ConstantsForCaseWFDelegate.PRODTYPE_MECHANICAL).equals(objCase.Product_Type__c))
                                   && null != objCase.Detail_Type__c ) 
                                {
                                    objCase.Ownerid = mapQueueID.get(ConstantsForCaseWFDelegate.Q_ORDERS_TEAM ).queueid__c ;
                                    objCase.Classification__c = mapClassification .get(ConstantsForCaseWFDelegate.CLSFN_CSO_SPARES ).classification__c;                                     
                                }
                            }
                            if((ConstantsForCaseWFDelegate.ORDERTYPE_REPAIR_OVERHAUL).equals(objCase.Order_Type__c) && null != objCase.Detail_Type__c)    
                            {
                                // WF - WebCasePlace Order Wheels and Brakes R&O
                                if((ConstantsForCaseWFDelegate.PRODTYPE_WHEELS_BRAKES).equals(objCase.Product_Type__c))
                                {
                                    objCase.Ownerid = mapQueueID.get(ConstantsForCaseWFDelegate.Q_CSO_RO_TEAM ).queueid__c ;
                                    objCase.Classification__c = mapClassification .get(ConstantsForCaseWFDelegate.CLSFN_CSO_REPAIR_OVERHAUL ).classification__c;
                                    objCase.Sub_Class__c = mapSubClass.get(ConstantsForCaseWFDelegate.SUBCLS_MECHANICAL_RO).subclass__c;
                                }
                                // WF - WebCasePlace Order    Lighting    R&O
                                if((ConstantsForCaseWFDelegate.PRODTYPE_LIGHTING).equals(objCase.Product_Type__c))
                                {    
                                    objCase.Ownerid = mapQueueID.get(ConstantsForCaseWFDelegate.Q_CSO_RO_TEAM ).queueid__c ;
                                    objCase.Classification__c = mapClassification .get(ConstantsForCaseWFDelegate.CLSFN_CSO_REPAIR_OVERHAUL ).classification__c;                                    
                                }
                                // WF - WebCasePlace Order    Bendix/King    R&O
                                if((ConstantsForCaseWFDelegate.PRODTYPE_BENDIX_HYPHEN_KING).equals(objCase.Product_Type__c))
                                {
                                    objCase.Ownerid = mapQueueID.get(ConstantsForCaseWFDelegate.Q_CSO_RO_TEAM ).queueid__c ;
                                    objCase.Classification__c = mapClassification .get(ConstantsForCaseWFDelegate.CLSFN_CSO_SPARES).classification__c;
                                    objCase.Sub_Class__c = mapSubClass.get(ConstantsForCaseWFDelegate.SUBCLS_BENDIX_HYPHEN_KING).subclass__c;
                                }
                                // WF - WebCasePlace Order    Avionics    R&O
                                /*if((ConstantsForCaseWFDelegate.PRODTYPE_ELECTRICAL).equals(objCase.Product_Type__c))
                                {
                                    objCase.Ownerid = mapQueueID.get(ConstantsForCaseWFDelegate.Q_CSO_RO_TEAM ).queueid__c ;
                                    objCase.Classification__c = mapClassification .get(ConstantsForCaseWFDelegate.CLSFN_CSO_REPAIR_OVERHAUL).classification__c;
                                    objCase.Sub_Class__c = mapSubClass.get(ConstantsForCaseWFDelegate.SUBCLS_ELECTRICAL_RO).subclass__c;
                                }*/
                            }
                        }
                    }
                    else if((ConstantsForCaseWFDelegate.PLANTCODE_55284).equals(objCase.Cage_Code__c)|| (ConstantsForCaseWFDelegate.PLANTCODE_97896).equals(objCase.Cage_Code__c) 
                        || (ConstantsForCaseWFDelegate.PLANTCODE_22373).equals(objCase.Cage_Code__c)|| (ConstantsForCaseWFDelegate.PLANTCODE_55939).equals(objCase.Cage_Code__c) )
                    {
                        // WF - WebToCaseR&O:55939
                        // WF - WebCase Place Order R&O 55939
                        if(((ConstantsForCaseWFDelegate.TYPE_ORDER_STATUS).equals(objCase.type) || (ConstantsForCaseWFDelegate.TYPE_PLACE_ORDER ).equals(objCase.type))
                            && (ConstantsForCaseWFDelegate.PLANTCODE_55939).equals(objCase.Cage_Code__c) && (ConstantsForCaseWFDelegate.ORDERTYPE_REPAIR_OVERHAUL).equals(objCase.Order_Type__c) )
                        {
                            objCase.Ownerid = mapQueueID.get(ConstantsForCaseWFDelegate.Q_CSO_RO_TEAM).queueid__c ;
                            objCase.Classification__c = mapClassification .get(ConstantsForCaseWFDelegate.CLSFN_CSO_REPAIR_OVERHAUL ).classification__c;
                            objCase.Sub_Class__c = mapSubClass.get(ConstantsForCaseWFDelegate.SUBCLS_ELECTRICAL_RO).subclass__c;
                        }
                        // HealthCheck  Sprint 2 Changes - Start
                        // WebCasePlace Order  Spares55939
                        if(((ConstantsForCaseWFDelegate.TYPE_PLACE_ORDER ).equals(objCase.type))&& (ConstantsForCaseWFDelegate.PLANTCODE_55939).equals(objCase.Cage_Code__c) 
                            && (ConstantsForCaseWFDelegate.ORDERTYPE_SPARES).equals(objCase.Order_Type__c) )
                        {
                            objCase.Ownerid = mapQueueID.get(ConstantsForCaseWFDelegate.Q_ORDERS_TEAM).queueid__c ;
                            objCase.Classification__c = mapClassification .get(ConstantsForCaseWFDelegate.CLSFN_CSO_SPARES ).classification__c;
                            objCase.Sub_Class__c = mapSubClass.get(ConstantsForCaseWFDelegate.SUBCLS_NEW_SPARES).subclass__c;
                            objCase.Detail_Class__c = ConstantsForCaseWFDelegate.DETAILCLS_AVIONICS ;
                            
                        }
                        // HealthCheck  Sprint 2 Changes - End
                        if((ConstantsForCaseWFDelegate.TYPE_ORDER_CHANGES).equals(objCase.type))
                        {
                            if((ConstantsForCaseWFDelegate.ORDERTYPE_REPAIR_OVERHAUL).equals(objCase.Order_Type__c))
                            {
                                objCase.Ownerid = mapQueueID.get(ConstantsForCaseWFDelegate.Q_CSO_RO_TEAM).queueid__c ;
                                objCase.Classification__c = mapClassification .get(ConstantsForCaseWFDelegate.CLSFN_CSO_REPAIR_OVERHAUL ).classification__c;
                                // WF - WebCase Order Changes R&O97896
                                // WF - WebCase Order Changes R&O 55939
                                if((ConstantsForCaseWFDelegate.PLANTCODE_97896).equals(objCase.Cage_Code__c) || (ConstantsForCaseWFDelegate.PLANTCODE_55939).equals(objCase.Cage_Code__c))
                                {                                    
                                    objCase.Sub_Class__c = mapSubClass.get(ConstantsForCaseWFDelegate.SUBCLS_ELECTRICAL_RO ).subclass__c; 
                                }
                                // WF - WebCase Order Changes R&O22373
                                if((ConstantsForCaseWFDelegate.PLANTCODE_22373).equals(objCase.Cage_Code__c))
                                {
                                    objCase.Sub_Class__c = mapSubClass.get(ConstantsForCaseWFDelegate.SUBCLS_BENDIX_SLASH_KING ).subclass__c; 
                                }
                                // WF - WebCase Order Changes R&O55284
                                if((ConstantsForCaseWFDelegate.PLANTCODE_55284).equals(objCase.Cage_Code__c))
                                {
                                    objCase.Sub_Class__c = mapSubClass.get(ConstantsForCaseWFDelegate.SUBCLS_MECHANICAL_RO ).subclass__c; 
                                }
                            }
                            if((ConstantsForCaseWFDelegate.ORDERTYPE_SPARES).equals(objCase.Order_Type__c) )
                            {
                                objCase.Ownerid = mapQueueID.get(ConstantsForCaseWFDelegate.Q_ORDER_CHANGES_TEAM ).queueid__c ;
                                objCase.Classification__c = mapClassification .get(ConstantsForCaseWFDelegate.CLSFN_CSO_SPARES ).classification__c;
                                // WF - WebCase Order Changes Spares97896
                                if((ConstantsForCaseWFDelegate.PLANTCODE_97896).equals(objCase.Cage_Code__c))
                                {                                    
                                    objCase.Sub_Class__c = mapSubClass.get(ConstantsForCaseWFDelegate.SUBCLS_REDMOND ).subclass__c; 
                                }
                                // WF - WebCase Order Changes Spares22373
                                if((ConstantsForCaseWFDelegate.PLANTCODE_22373).equals(objCase.Cage_Code__c))
                                {
                                   objCase.Sub_Class__c = mapSubClass.get(ConstantsForCaseWFDelegate.SUBCLS_BENDIX_SLASH_KING ).subclass__c; 
                                }
                                // WF - WebCase Order Changes Spares55284
                                if((ConstantsForCaseWFDelegate.PLANTCODE_55284).equals(objCase.Cage_Code__c))
                                {
                                   objCase.Sub_Class__c = mapSubClass.get(ConstantsForCaseWFDelegate.SUBCLS_WHEELS_BRAKES).subclass__c; 
                                }
                                // WF - WebCase Order Changes Spares55939
                                if((ConstantsForCaseWFDelegate.PLANTCODE_55939).equals(objCase.Cage_Code__c))
                                {
                                   objCase.Sub_Class__c = mapSubClass.get(ConstantsForCaseWFDelegate.SUBCLS_NEW_SPARES ).subclass__c; 
                                   objCase.Detail_Class__c = ConstantsForCaseWFDelegate.DETAILCLS_AVIONICS ;
                                }
                            }
                        }
                    }
                }   
            }            
        } 
        }catch(Exception e)
        { 
            MainCaseTriggerUtility.handleException(e);      
        }
        TriggerInactive.blnCaseWFDelegate =false;  
    }
    // HealthCheck Sprint 2 Changes - Start
    public static void caseWFDelegateUpdate(List<Case> listObjCase ){
        
        Set<String> setCountryName = new Set<String>();
        List<String> listCountryName = new List<String>();
        
        Map<String,QueueTeam__c> mapQueueID = QueueTeam__c.getALL();
        Map<String,ClassificationList__c> mapClassification = ClassificationList__c.getALL();
        Map<String,SubClassList__c> mapSubClass = SubClassList__c.getALL(); 
        Case exceptionCase;
        Schema.DescribeSObjectResult CaseDesc = Schema.SObjectType.Case;
        Map<ID,Schema.RecordTypeInfo> CasertMapByName = CaseDesc.getRecordTypeInfosById();
        Schema.RecordTypeInfo CaseRTByName;
        
        listCountryName = (label.Case_Country_Values_Set1).split(';');        
        setCountryName.addAll(listCountryName); // Add the above fresh Country From Set1
        listCountryName = (label.Case_Country_Values_Set2).split(';');
        setCountryName.addAll(listCountryName); // Add the above fresh Country From Set2 along with Set1
        try{    
            for (Case objCase : listObjCase)  
            { 
                exceptionCase = objCase;                                
                CaseRTByName = CasertMapByName.get(objCase.recordtypeid);
                  
                // SR446546 Starts -- Hari  
                    if((Userinfo.getUserID()==ConstantsForCaseWFDelegate.API_User && objCase.CreatedById == label.API_User_My_Aerospace_Portal) && (objCase.Subject !=null && objCase.Subject.contains(ConstantsForCaseWFDelegate.subject))&& (objCase.SBU__c!=null && objCase.SBU__c.equals(ConstantsForCaseWFDelegate.sbu))&& (objCase.Origin !=null && objCase.Origin.equals(ConstantsForCaseWFDelegate.ORIGIN_WEB))){
                    objCase.Classification__c = mapClassification .get(ConstantsForCaseWFDelegate.CLSFN_CSO_DS_INTERNAL).classification__c;
                    objCase.Sub_Class__c = mapSubClass.get(ConstantsForCaseWFDelegate.SUBCLS_DEF_OL_ORDER).subclass__c;
                    //objCase.RecordtypeId = label.D_S_Quotes_Orders_RT_ID;//Commented for SR INC000008805191
                    objCase.RecordtypeId = label.Orders_Rec_ID;//Modified for SR INC000008805191
                    objCase.Type = 'Place Order';
                }
                // SR446546 Ends -- Hari
                
                // SR INC000011250567--Start                
                    if(Userinfo.getUserID()==ConstantsForCaseWFDelegate.API_User && objCase.CreatedById == label.API_User_My_Aerospace_Portal && objCase.RecordtypeId == Label.FSS_Billing_Record_Type_Id && objCase.Origin.equals(ConstantsForCaseWFDelegate.ORIGIN_WEB)){                   
                        objCase.Ownerid = Label.FSS_Accounts;                        
                    }
               // SR INC000011250567--End   
                
                 // SR INC000006038997--Start
                    if(Userinfo.getUserID()==ConstantsForCaseWFDelegate.API_User && objCase.CreatedById == label.API_User_My_Aerospace_Portal && objCase.RecordtypeId == label.TechPubs_RecordType_ID){
                        objCase.Classification__c = '';
                        objCase.Sub_Class__c = '';
                    }
                // SR INC000006038997--End
                
                if(null!=objCase.Origin && objCase.Origin.equals(ConstantsForCaseWFDelegate.ORIGIN_WEB)
                 && !((ConstantsForCaseWFDelegate.SFDC_ADMIN).equals(objCase.LastModifiedById))  )
                { 
                    if(!((ConstantsForCaseWFDelegate.PLANTCODE_55284).equals(objCase.Cage_Code__c)  || (ConstantsForCaseWFDelegate.PLANTCODE_97896).equals(objCase.Cage_Code__c)
                        || (ConstantsForCaseWFDelegate.PLANTCODE_22373).equals(objCase.Cage_Code__c)  || (ConstantsForCaseWFDelegate.PLANTCODE_55939).equals(objCase.Cage_Code__c))
                        && (ConstantsForCaseWFDelegate.RT_ORDERS).equals(CaseRTByName.getName())&& (ConstantsForCaseWFDelegate.TYPE_PLACE_ORDER).equals(objCase.type)  
                        && (ConstantsForCaseWFDelegate.PRODTYPE_ELECTRICAL ).equals(objCase.Product_Type__c))
                    { 
                        // WebCasePlace Order Avionics Spares Detail Part EMEA
                        if((ConstantsForCaseWFDelegate.ORDERTYPE_SPARES).equals(objCase.Order_Type__c)
                             && (ConstantsForCaseWFDelegate.DETAILTYPE_DETAIL_PART).equals(objCase.Detail_Type__c)
                             && setCountryName.contains(objCase.Country__c) )
                        {
                            objCase.Ownerid = mapQueueID.get(ConstantsForCaseWFDelegate.Q_ORDERS_TEAM ).queueid__c ;
                            objCase.Classification__c = mapClassification .get(ConstantsForCaseWFDelegate.CLSFN_CSO_SPARES ).classification__c;                                        
                            objCase.Sub_Class__c = mapSubClass.get(ConstantsForCaseWFDelegate.SUBCLS_GLB_MATERIAL_SERV).subclass__c;
                        }
                       // WF - WebCasePlace Order    Avionics    R&O
                      /* if((ConstantsForCaseWFDelegate.ORDERTYPE_REPAIR_OVERHAUL).equals(objCase.Order_Type__c)
                             && null != objCase.Detail_Type__c )
                        {
                            objCase.Ownerid = mapQueueID.get(ConstantsForCaseWFDelegate.Q_CSO_RO_TEAM ).queueid__c ;
                            objCase.Classification__c = mapClassification .get(ConstantsForCaseWFDelegate.CLSFN_CSO_REPAIR_OVERHAUL ).classification__c;                                                                   
                            objCase.Sub_Class__c = mapSubClass.get(ConstantsForCaseWFDelegate.SUBCLS_ELECTRICAL_RO).subclass__c;                            
                        }*/
                    }
                }
            }
        }catch(Exception e)
        { 
            MainCaseTriggerUtility.handleException(e);      
        }
        TriggerInactive.blnCaseWFDelegateUpdate =false;
    }
    // HealthCheck Sprint 2 Changes - End 
}