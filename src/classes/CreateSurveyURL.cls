/***********************************************************************************************************
* Company Name          : Honeywell Aero
* Name                  : CreateSurveyURL 
* Description           : Trigger to Send survey 
* 
* Modification History  :
* Date             Version No.    Modified by           Brief Description of Modification
* FEB-13-2013      1.1            NTTData               SR# 357371 - Code changes to send survey to GDC related record typesan R&O
* MAR-04-2013      1.2            NTTData               SR# 375781 - Code changes to send survey to EBIZ Web Support
* SEP-16-2013      1.3            NTTData               SR# 413455 & SR# 406298 - Code changes to send survey to NavDb accnts & MSP Contract
* JAN-22-2013      1.4            NTTData               SR# 438738 -Code changes to send survey for HAPP MPP Contracts
* Oct-29-2014     1.5             NTTDATA               INC000006793729 # Code changes to update Click Tool URL.
* July-10-2017     1.6             NTTDATA            PRJ11585 # Code changes to update Click Tool URL added new recordtypes
***********************************************************************************************************/
// Clicktools 2nd September 2010

public with sharing class CreateSurveyURL {

    // use this static to prevent recursion. We set it to true before the 
    // update call and it is checked by the trigger code. this will only stay
    // true for the context of the current apex transaction
    public static boolean updateFromFutureCall = false;

    // use this static to enable testing where criteria is unsettable due to 
    // readonly fields e.g. Case.Service_Level__c
    public static boolean testing = false;

    //Clicktools survey urls
    static String rest_url = 'https://app.clicktools.com/app/rest/addnewresponse?instance_id='+label.clicktoolIdOrders; 
    //static String common_NSS_SurveyURL = 'https://app.clicktools.com/app/rest/addnewresponse?instance_id='+label.Clicktool_NSS_Survey2; 
    static String ManualSurveyURL= 'https://app.clicktools.com/app/rest/addnewresponse?instance_id='+label.Clicktool_ManualSurvey;
    static String ManualSurveyURL_genral = 'https://app.clicktools.com/app/rest/addnewresponse?instance_id='+label.Clicktool_ManualSurvey_general;
    static String ManualSurvey_WebSupport = 'https://app.clicktools.com/app/rest/addnewresponse?instance_id='+label.Clicktool_ManualSurvey_WebSupport;
    static String ManualSurvey_CPFeedback = 'https://app.clicktools.com/app/rest/addnewresponse?instance_id='+label.CP_feedback_Survey_Instance_Id;

    //below 5 are new surveys
    static String Customer_Support = 'https://app.clicktools.com/app/rest/addnewresponse?instance_id='+label.Clicktool_Customer_Support;
    static String Services_Support = 'https://app.clicktools.com/app/rest/addnewresponse?instance_id='+label.Clicktool_Services_Support;
    static String BendixKing = 'https://app.clicktools.com/app/rest/addnewresponse?instance_id='+label.Clicktool_BendixKing;
    static String Engine_Rentals = 'https://app.clicktools.com/app/rest/addnewresponse?instance_id='+label.Clicktool_Engine_Rentals;
    static String GoDirect = 'https://app.clicktools.com/app/rest/addnewresponse?instance_id='+label.Clicktool_GoDirect;
    
    //added survey url for SCTASK2276811
    static String FalconConnect= 'https://app.clicktools.com/app/rest/addnewresponse?instance_id='+label.Clicktool_Falcon_Support;   
    static String BKRT = 'https://app.clicktools.com/app/rest/addnewresponse?instance_id='+label.ClicktoolIdBKSurvey; 
    static String GDC_rest_url = 'https://app.clicktools.com/app/rest/addnewresponse?instance_id='+label.clicktoolIdGDC;
    static String Web_Support_rest_url = 'https://app.clicktools.com/app/rest/addnewresponse?instance_id='+label.clicktoolIdWebSupport;  
    //INC0000370606 start
    static String PhoneRT = 'https://app.clicktools.com/app/rest/addnewresponse?instance_id='+label.clicktoolIdPhone; 
    static String OrderChangeOrderRT = 'https://app.clicktools.com/app/rest/addnewresponse?instance_id='+label.clicktoolIdOrderChange;
    //INC0000370606 end
    static String TCM_rest_url = label.TCM_Resturl;
    
     static string NewURL  = 'https://app.clicktools.com/app/rest/addnewresponse?instance_id='+label.clicktoolId;
     static string ERURL  = 'https://app.clicktools.com/app/rest/addnewresponse?instance_id='+label.ERSurveyId;
  @future (callout=true)
    public static void createSurvey(String caseId, String strSurveyType, Map<String,String> params) {
        System.debug('createSurvey Start');
        System.debug('=vkt==createSurvey entry');
        String clicktools_url;
        System.debug('clicktools_url initially'+clicktools_url);
        
        //below code is commented for SCTASK2015022 and 1 common NSS Survey is created
        /*if('GDC' == strSurveyType)
        {
            clicktools_url = GDC_rest_url;
        }
        else if(strSurveyType == 'BK'){
            clicktools_url = BKRT;
        }
        else if('Web_Support' == strSurveyType)
        {
            clicktools_url = Web_Support_rest_url;
        }else if('NewURL_PI' == strSurveyType)
        {
            clicktools_url =  NewURL;
        }else if('TCM' == strSurveyType)
        {
            clicktools_url =  TCM_rest_url;
        } else if('ER' == strSurveyType)
        {
            clicktools_url =  ERURL;
        }
        //INC0000370606
        else if(strSurveyType == 'PhoneOQGRRT'){
            System.debug('=vkt==PhoneOQGRRT');
            clicktools_url = PhoneRT;
        }
        else if(strSurveyType == 'RGQO'){
            System.debug('RGQO');
            clicktools_url = ManualSurveyURL;
             System.debug('RGQO: clicktools_url' +clicktools_url);
        }
        
        else if(strSurveyType == 'Manual_General'){
            System.debug('Manual_General');
            clicktools_url = ManualSurveyURL_genral;
             System.debug('Manual_General: clicktools_url' +clicktools_url);
        }
        
        else if(strSurveyType == 'Manual_WebSupport'){
            System.debug('Enter Manual_WebSupport');
            clicktools_url = ManualSurvey_WebSupport;
             System.debug('Manual_WebSupport: clicktools_url' +clicktools_url);
        }
        
        else if(strSurveyType == 'OrderChangeORT'){
            System.debug('=vkt==OrderChangeORT');
            clicktools_url = OrderChangeOrderRT;
        }
        //INC0000370606 end
        */
        
        if(strSurveyType == 'RGQO'){
            System.debug('RGQO');
            clicktools_url = ManualSurveyURL;
             System.debug('RGQO: clicktools_url' +clicktools_url);
        }
        
        else if(strSurveyType == 'Manual_General'){
            System.debug('Manual_General');
            clicktools_url = ManualSurveyURL_genral;
             System.debug('Manual_General: clicktools_url' +clicktools_url);
        }
        
        else if(strSurveyType == 'Manual_WebSupport'){
            System.debug('Enter Manual_WebSupport');
            clicktools_url = ManualSurvey_WebSupport;
             System.debug('Manual_WebSupport: clicktools_url' +clicktools_url);
        }
        
        else if(strSurveyType == 'Manual_CpFeedback'){
            System.debug('Enter Manual_CpFeedback');
            clicktools_url = ManualSurvey_CPFeedback;
             System.debug('Manual_CpFeedback: clicktools_url' +clicktools_url);
        }
        
        //below If condition added for SCTASK2015022
        /*else if(strSurveyType == 'GDC' || strSurveyType == 'BK' || strSurveyType == 'Web_Support' || strSurveyType == 'NewURL_PI' ||
        strSurveyType == 'TCM' || strSurveyType == 'ER'|| strSurveyType == 'PhoneOQGRRT' || strSurveyType == 'OrderChangeORT')
        {
            System.debug('Inside common IF condition to set the clicktool URL');
            clicktools_url = common_NSS_SurveyURL;
        }*/
        
        else if(strSurveyType == 'Customer_Support' ) {
            System.debug('Inside common IF condition to set the clicktool URL');
            clicktools_url = Customer_Support;
        }
        
        else if(strSurveyType == 'Services_Support' ) {
            System.debug('Inside common IF condition to set the clicktool URL');
            clicktools_url = Services_Support;
        }
        
        else if(strSurveyType == 'GoDirect' ) {
            System.debug('Inside common IF condition to set the clicktool URL');
            clicktools_url = GoDirect;
        }
        
        else if(strSurveyType == 'BendixKing' ) {
            System.debug('Inside common IF condition to set the clicktool URL');
            clicktools_url = BendixKing;
        }
        
        else if(strSurveyType == 'Engine_Rentals' ) {
            System.debug('Inside common IF condition to set the clicktool URL');
            clicktools_url = Engine_Rentals;
        }
            //start of changes made for SCTASK2276811
           else if(strSurveyType == 'Falcon_Connect' ) {
            System.debug('Inside common IF condition to set the clicktool URL');
            clicktools_url = FalconConnect;
        }
        //end of changes made for SCTASK2276811
        else    
        {       
            clicktools_url = rest_url;
            System.debug('CreateSurvey'+clicktools_url);
        }
        
        System.debug('Final url CreateSurvey'+clicktools_url);
        for(String key : params.keySet()) {
            clicktools_url += '&'+key+'='+urlStr(params.get(key));  
        }    
        System.debug('=vkt==Final url CreateSurvey with parameters'+clicktools_url);
        HttpRequest req = new HttpRequest();
        req.setEndpoint(clicktools_url);
        req.setMethod('GET');    

        Http http = new Http();
        HTTPResponse res;
        IF(!TEST.isRunningTest())
        {
        res = http.send(req);
        }
        if(res!=null && res.getStatusCode() == 200) {
            String uniqueURL = res.getBody();
            system.debug('===vkt=====uniqueURL'+uniqueURL);
            if('TCM'==strSurveyType){
            Planned_Meeting__c  pm = new Planned_Meeting__c (Id = caseId, TCM_Survey_Link__c = uniqueURL);
            system.debug('TCM debug1');
            // set variable to prevent recursion
            updateFromFutureCall = true;      
            update pm; 
            }
           
            else{
            
            system.debug('Survey debug 130 ');
            
            Case c = [select id,NSS_Survey_Link__c,Survey_Sent__c from case where id =: caseId];
            
            if(strSurveyType == 'RGQO' || strSurveyType == 'Manual_General' || strSurveyType == 'Manual_WebSupport' || strSurveyType == 'Manual_CpFeedback' ){
            
                c = new Case(Id = caseId, NSS_Survey_Link__c = uniqueURL, Survey_Sent__c = 0, Survey_Type__c =strSurveyType);
            
                system.debug('Survey debug2.2 '+c.Survey_Type__c);
            
                system.debug('Survey debug3.2 '+c.NSS_Survey_Link__c);
    
                // set variable to prevent recursion
                updateFromFutureCall = true;      
                update c;
                
            }
            
            else if((c.Survey_Sent__c == 0 || c.Survey_Sent__c == null) && c.NSS_Survey_Link__c == null ){
                c = new Case(Id = caseId, NSS_Survey_Link__c = uniqueURL, Survey_Sent__c = 0, Survey_Type__c =strSurveyType);
            
                system.debug('Survey debug2'+c.Survey_Type__c);
            
                system.debug('Survey debug3'+c.NSS_Survey_Link__c);
    
                // set variable to prevent recursion
                updateFromFutureCall = true;      
                update c;
            }
            system.debug('Survey debug4'+c.Id);
            
            }    
        }      
    } 
    static String urlStr(String s) {
        String r = '';
        if(s != null) {
            r = EncodingUtil.urlEncode(s, 'UTF-8');
        }
        return r;
    }
}