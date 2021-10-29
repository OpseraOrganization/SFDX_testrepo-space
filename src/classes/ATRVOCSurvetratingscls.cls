public with sharing class ATRVOCSurvetratingscls {

    private final Go_Green_Plan__c ggp;
    public Go_Green_Plan__c  ggp1=new Go_Green_Plan__c();
    public Feedback__c fed{get;set;}
    public String posId;
    public boolean showContent1{get;set;}
    public boolean showContent2{get;set;}
    public boolean showContent3{get;set;}
    public boolean showContent4{get;set;}
    public boolean showContent5{get;set;}
    public boolean showContent6{get;set;}
    public boolean showContent7{get;set;}
    public boolean showContent8{get;set;}
    public boolean showContent9{get;set;}
    public boolean showContent10{get;set;}
    public boolean showContent11{get;set;}
    public boolean showContent12{get;set;}
    public boolean showContent13{get;set;}
    public boolean showContent14{get;set;}
    public boolean showContent15{get;set;}
    public boolean showContent16{get;set;}
    public ATRVOCSurvetratingscls(ApexPages.StandardController controller) {
       
        this.ggp= (Go_Green_Plan__c)controller.getRecord();
        posId= this.ggp.Id; 
        //posId= 'a3d180000002SWJ'; 
        Go_Green_Plan__c  ggp1=[select id,name,Feedback_Record_Number__c from Go_Green_Plan__c where id=:posId];
        showContent1=false;
        showContent2=false;
        showContent3=false;
        showContent4=false;
        showContent5=false;
        showContent6=false;
        showContent7=false;
        showContent8=false;
        showContent9=false;
        showContent10=false;
        showContent11=false;
        showContent12=false;
        showContent13=false;
        showContent14=false;
        showContent15=false;
        showContent16=false;
        if(ggp1.Feedback_Record_Number__c != null)
        {
           fed=[select id,name,Metric_for_Value__c,Value_Metric_IND__c,Value_Root_Cause_Context__c,Metric_for_Quality__c,Quality_Metric_IND__c,
           Quality_Root_Cause_Context__c,Metric_for_Reliability__c,Reliability_Metric_IND__c,Reliability_Root_Cause_Context__c,Metric_for_Service_Support__c,
           Service_Support_Metric_IND__c,Service_Support_Root_Cause_Context__c,Warranty__c,Warranty_IND__c,Warranty_Customer_Feedback__c,Repair_Performance__c,
           Repair_Performance_IND__c,Repair_Performance_Customer_Feedback__c,Spares_Performance__c,Spares_Performance_IND__c,Spares_Performance_Customer_Feedback__c,
           Recommend_HON__c,Recommend_HON_IND__c,Recommend_HON_Customer_Feedback__c,Cost__c,Cost_IND__c,Cost_Customer_Feedback__c,Overall_Perception__c,
           Overall_Perception_IND__c,Overall_Perception_Customer_Feedback__c,Communication__c,Communication_IND__c,Communication_Customer_Feedback__c,Documentation__c,
           Documentation_IND__c,Documentation_Customer_Feedback__c,Global_Technical_Ops_Support__c,Global_Technical_Ops_Support_IND__c,GlobalTechnicalOpsSupportCustomerFeedbac__c,
           Flexibility__c,Flexibility_IND__c,Flexibility_Customer_Feedback__c,Metric_for_Delivery__c,Customer_Rating_For_Delivery__c,Delivery_Root_Cause_Context__c,
           Metric_for_Responsiveness__c ,Customer_Rating_For_Responsiveness__c,Responsiveness_Root_Cause_Context__c from Feedback__c  where name =: ggp1.Feedback_Record_Number__c limit 1];
           system.debug('value metric----->'+fed.Value_Metric_IND__c);
           if(fed.Value_Metric_IND__c != null && (fed.Value_Metric_IND__c.contains('Red') || fed.Value_Metric_IND__c.contains('Yellow')))
           {
               system.debug('inside value metric');
               showContent1=true;
           }
           if(fed.Metric_for_Quality__c != null && (fed.Metric_for_Quality__c.contains('Red') || fed.Metric_for_Quality__c.contains('Yellow')))
           {
               showContent2=true;
           }
           if(fed.Reliability_Metric_IND__c != null && (fed.Reliability_Metric_IND__c.contains('Red') || fed.Reliability_Metric_IND__c.contains('Yellow')))
           {
               showContent3=true;
           }
           if(fed.Service_Support_Metric_IND__c != null && (fed.Service_Support_Metric_IND__c.contains('Red') || fed.Service_Support_Metric_IND__c.contains('Yellow')))
           {
               showContent4=true;
           }
           if(fed.Warranty_IND__c != null && (fed.Warranty_IND__c.contains('Red') || fed.Warranty_IND__c.contains('Yellow')))
           {
               showContent5=true;
           }
           if(fed.Repair_Performance_IND__c != null && (fed.Repair_Performance_IND__c.contains('Red') || fed.Repair_Performance_IND__c.contains('Yellow')))
           {
               system.debug('inside repair');
               showContent6=true;
           }
           if(fed.Spares_Performance_IND__c != null && (fed.Spares_Performance_IND__c.contains('Red') || fed.Spares_Performance_IND__c.contains('Yellow')))
           {
               showContent7=true;
           }
           if(fed.Recommend_HON_IND__c != null && (fed.Recommend_HON_IND__c.contains('Red') || fed.Recommend_HON_IND__c.contains('Yellow')))
           {
               showContent8=true;
           }
           if(fed.Cost_IND__c != null && (fed.Cost_IND__c.contains('Red') || fed.Cost_IND__c.contains('Yellow')))
           {
               showContent9=true;
           }
           if(fed.Overall_Perception_IND__c!= null && (fed.Overall_Perception_IND__c.contains('Red') || fed.Overall_Perception_IND__c.contains('Yellow')))
           {
               showContent10=true;
           }
           if(fed.Communication_IND__c != null && (fed.Communication_IND__c.contains('Red') || fed.Communication_IND__c.contains('Yellow')))
           {
               showContent11=true;
           }
           if(fed.Documentation_IND__c != null && (fed.Documentation_IND__c.contains('Red') || fed.Documentation_IND__c.contains('Yellow')))
           {
               showContent12=true;
           }
           if(fed.Global_Technical_Ops_Support_IND__c != null && (fed.Global_Technical_Ops_Support_IND__c.contains('Red') || fed.Global_Technical_Ops_Support_IND__c.contains('Yellow')))
           {
               showContent13=true;
           }
           if(fed.Flexibility_IND__c!= null && (fed.Flexibility_IND__c.contains('Red') || fed.Flexibility_IND__c.contains('Yellow')))
           {
               showContent14=true;
           }
           if(fed.Customer_Rating_For_Delivery__c!= null && (fed.Customer_Rating_For_Delivery__c.contains('Red') || fed.Customer_Rating_For_Delivery__c.contains('RED')  
                                                       || fed.Customer_Rating_For_Delivery__c.contains('Yellow') || fed.Customer_Rating_For_Delivery__c.contains('YELLOW')))
           {
               showContent15=true;
           }
           if(fed.Customer_Rating_For_Responsiveness__c != null && (fed.Customer_Rating_For_Responsiveness__c .contains('Red') || fed.Customer_Rating_For_Responsiveness__c .contains('RED')  
                                                       || fed.Customer_Rating_For_Responsiveness__c .contains('Yellow') || fed.Customer_Rating_For_Responsiveness__c .contains('YELLOW')))
           {
               showContent16=true;
           }
        }
        system.debug('showContent1----->'+showContent1);
        system.debug('showContent6----->'+showContent6);
        
    }
     public Feedback__c getfedlst()
    {
       return fed;
    }
}