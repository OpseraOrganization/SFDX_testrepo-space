/*******************************************************************************
Name         : Constants
Created By   : Anusuya Murugiah
Company Name : NTT Data
Project      : Phase-II, HealthCheck
Created Date : 19 September 2013
Usages       : This Class a generic Constant/String declaration which is used in 
               ObjCaseHelper class.    
Modification History  :
Date          Version No.     Modified by     Brief Description of Modification
15 Oct 2010   1.1             NTTDATA         HAN-0263 Healtcheck Sprint 2 
08 Jan 2013   1.2             NTTDATA         SR439445 Included a clasification "Tech Pubs"
*******************************************************************************/
global class ConstantsForCaseWFDelegate
{  
    // String Constants
    global static final String ORIGIN_WEB = 'Web'; 
    global static final String SFDC_ADMIN = '005300000041m9d';
    global static final String API_User = label.API_User_My_Aerospace_Portal;
    global static final String subject = 'Webform';
    global static final String sbu = 'D&S';
    
    // Case's Record Type Name Strings
    global static final String RT_INVOICE_DISPUTES = 'Invoice/Disputes';
    global static final String RT_SERIVICE_RECOVERY = 'Service Recovery Report';
    global static final String RT_RETURNS = 'Returns';
    global static final String RT_WARRANTY = 'Warranty';
    global static final String RT_TECHNICAL_ISSUE = 'Technical Issue'; 
    global static final String RT_DS_QUOTES_ORDERS = 'D&S Quotes Orders';
    global static final String RT_QUOTES = 'Quotes';
    global static final String RT_ORDERS = 'Orders';
   
    // Case's Type picklist values
    global static final String TYPE_INVOICE_DISPUTES = 'Invoice/Disputes';
    global static final String TYPE_TECH_PUBS = 'Tech Pubs';
    global static final String TYPE_RETURNS = 'Returns';
    global static final String TYPE_WARRANTY = 'Warranty';
    global static final String TYPE_TECHNICAL_ISSUE = 'Technical Issue';
    global static final String TYPE_QUOTES_AVAILABILITY = 'Quotes/Availability';
    global static final String TYPE_QUOTES_AVAILABLITY = 'Quotes/Availablity';
    global static final String TYPE_ORDER_CHANGES = 'Order Changes';
    global static final String TYPE_ORDER_STATUS = 'Order Status';
    global static final String TYPE_PLACE_ORDER = 'Place Order'; 
    global static final String TYPE_QUOTES_APPROVAL ='Quotes Approval';
  
      // Case's Cage Code  
    global static final String PLANTCODE_55284 = '55284';
    global static final String PLANTCODE_97896 = '97896';
    global static final String PLANTCODE_55939 = '55939';
    global static final String PLANTCODE_22373 = '22373';

    // Case's Order Type picklist values   
    global static final String ORDERTYPE_REPAIR_OVERHAUL = 'Repair/Overhaul';
    global static final String ORDERTYPE_SPARES = 'Spares';
    global static final String ORDERTYPE_SERVICES = 'Services';
    global static final String ORDERTYPE_REPAIR = 'REPAIRS';

    // Case's Product Type     
    global static final String PRODTYPE_ELECTRICAL = 'Electrical';
    global static final String PRODTYPE_MECHANICAL = 'Mechanical';
    global static final String PRODTYPE_WHEELS_BRAKES = 'Wheels & Brakes';
    global static final String PRODTYPE_LIGHTING = 'Lighting';
    global static final String PRODTYPE_BENDIX_HYPHEN_KING = 'Bendix-King';   

    // Case's Detail Type
    global static final String DETAILTYPE_SOFTWARE = 'Software';
    // HealthCheck  Sprint 2 Changes - Start
    global static final String DETAILTYPE_DETAIL_PART = 'Detail part';
    global static final String DETAILTYPE_LRU = 'LRU';
    global static final String DETAILTYPE_SPEX_SLASH_EXCHANGE= 'SPEX/Exchange';
    global static final String DETAILTYPE_SPEX_EXCHANGE= 'SPEX Exchange';
    // HealthCheck  Sprint 2 Changes - End      
    // Case's Queue Team
    global static final String Q_INVOICE_DISPUTES_TEAM = 'Invoice/Disputes Team';
    global static final String Q_PUBS_TEAM= 'Pubs Team';
    global static final String Q_RETURNS_TEAM = 'Returns Team';
    global static final String Q_WARRANTY_TEAM = 'Warranty Team';
    global static final String Q_TOC_TEAM = 'TOC Team';
    global static final String Q_DS_ORDERS_TEAM = 'D&S Orders Team';
    global static final String Q_QUOTES_TEAM = 'Quotes Team';  
    global static final String Q_ORDER_STATUS_TEAM = 'Order Status Team';
    global static final String Q_CSO_RO_TEAM= 'CSO R&O Team';
    global static final String Q_ORDERS_TEAM = 'Orders Team';
    global static final String Q_ORDER_CHANGES_TEAM = 'Order Changes Team';
    global static final String Q_RO_ORDER_QUTOES_TEAM = 'R&O Quotes Team';

    // Case's Classification
    global static final String CLSFN_CSO_SPECIAL_PRGM = 'CSO Special Programs';
    global static final String CLSFN_CSO_SPARES = 'CSO Spares';
    global static final String CLSFN_CSO_WARRANTY = 'CSO Warranty';
    global static final String CLSFN_GTO_TECH_OPER_CENTER = 'GTO Tech Operations Center'; 
    global static final String CLSFN_CSO_DS_INTERNAL = 'CSO D&S Internal';
    global static final String CLSFN_CSO_REPAIR_OVERHAUL = 'CSO Repair/Overhaul'; 
    global static final String CLSFN_GTO_DS_TECH_ISSUE = 'GTO D&S Technical Issue';
    global static final String CLSFN_TECH_PUBS = 'Tech Pubs';
    global static final String CLSFN_RO_ISSUES = 'R&O Issue';
    global static final String CLSFN_RO_QUOTE = 'R&O Quote';
    
    // Case's Sub Class
    global static final String SUBCLS_INVOICE_DISPUTES = 'Invoice/Disputes';
    global static final String SUBCLS_PUBLICATIONS = 'Publications';
    global static final String SUBCLS_WHEELS_BRAKES = 'Wheels & Brakes';
    global static final String SUBCLS_REDMOND = 'Redmond';
    global static final String SUBCLS_NEW_SPARES = 'New Spare';
    global static final String SUBCLS_BENDIX_SLASH_KING = 'Bendix/King';
    global static final String SUBCLS_ELECTRICAL_RO = 'Electrical (R&O)';
    global static final String SUBCLS_MECHANICAL_RO = 'Mechanical (R&O)';
    global static final String SUBCLS_BENDIX_HYPHEN_KING = 'Bendix-King';
    global static final String SUBCLS_SOFTWARE = 'Software';
    // HealthCheck  Sprint 2 Changes - Start
    global static final String SUBCLS_SPEX_SLASH_EXCHANGE = 'SPEX/Exchange';
    global static final String SUBCLS_GLB_MATERIAL_SERV = 'Global Material Services (GMS)';
    global static final String SUBCLS_HON_INTERNATIONAL_SARL = 'HON International SARL (HIS)';
    // HealthCheck  Sprint 2 Changes - End
    // SR446546 Starts
    global static final String SUBCLS_DEF_OL_ORDER = 'Deferred Online Order';
    // SR446546 Ends
    // Case's Detail Class
    global static final String DETAILCLS_AVIONICS = 'Avionics LRU';
  
    // Trigger Delegate - Start
    global static final String MCORE = 'MCORE';
    global static final String MCORE_MAINTENANCE_COST_REDUCTION = 'MCORE (Maintenance Cost Reduction)';
    global static final String OWNER_NM_SALECUSTMAST = 'Salesforce Customer Master';
    global static final String STR_BUSIN_UNT_ATR = 'ATR';
    global static final String CBT_AIRLINES = 'Airlines';
    global static final String CBT_TEAM_AMERICAS = 'Americas';
    global static final String CBT_EMEAI_ATR = 'EMEAI ATR';
    global static final String CBT_APAC_ATR = 'Asia Pacific ATR';
    global static final String TEAMROLE_CBM = 'Customer Business Manager (CBM)';
    global static final String TEAMROLE_CBD = 'Customer Business Director';
    global static final String RT_WEB_PORTAL_REG = 'WEB Portal Registration';
    
    // Trigger Delegate - End
    global ConstantsForCaseWFDelegate()
    {
       //inside constructor
       system.debug('Inside ConstantsForCaseWFDelegate constructor');
    }
}