/* 
CreatedBy:NTTDATA
JIRA : RAPD-1334
*/
global class ControllerLightning {    

    
    public string myURL{get;set;}
    private final Case acct;
    
    
    private final static String urlFieldName = 'Conductor__c';
    private String partnerServerUrl;
    private ApexPages.StandardSetController controller;
    private List<String> serviceRequestIds = new List<Id>();
   
    public String CMUrl {get;set;}

    
  
    public ControllerLightning(ApexPages.StandardSetController controller) {
     this.controller = controller;
    // this.acct = (Case)controller.getRecord();
     myURL= '/lightning/o/Case/list?filterName=Recent'; 
    }
    
        public PageReference prepareCMUrl() {
        String finaljoinedIds;
        if(serviceRequestIds.size()>0){
           String separator = ', ';
          finaljoinedIds = String.join(serviceRequestIds, separator);
          System.debug('finaljoinedIds????'+finaljoinedIds);
          
        }
       // CMUrl = 'https://composer.congamerge.com'+'?SessionId='+UserInfo.getSessionID()+'&ServerUrl='+partnerServerUrl+'&Id='+ UserInfo.getUserId() +'&ReportId=00O300000067CXi?pv1='+finaljoinedIds+'&TemplateId=a0w1300000lC1xJ&DS7=3&OCNR=1&SCHP=1';
        CMUrl = 'https://login.salesforce.com';
        return null;
    }

    
    @AuraEnabled
    Public static List <Case_Line_Item__c> exportCLI(Id iid) {
     List <Case_Line_Item__c> returnConList = new List < Case_Line_Item__c > ();
        
      for(Case_Line_Item__c con: [SELECT Name, Product_Name__c,Product_Description1__c,Part_Number__c, Product_Number__c, CDA_Cage_Code1__c,Site1__c,D_S_Last_Sale_Entered1__c,SAP_Platform1__c,Product_Line_Family1__c,Product_Line_PAC1__c   From Case_Line_Item__c where Case_Number__c =: iid LIMIT 1000]) {
             returnConList.add(con);
          }
       
         return returnConList;
        
    }
    //Changed the below method as part of enhancement-Shwetha
     @AuraEnabled
    Public static boolean discardCase(Id iid) { //added return type-Shwetha
     boolean flag1 = false;//Added by Shwetha
        boolean flag=false;  //Added by Shwetha 
    Case c = new Case(); 
    c=[Select Id,Status, Export_Compliance_Content_ITAR_EAR__c, Government_Compliance_SM_M_Content__c, Supported_Products__c, ContactId ,Customer_PO_RO_WONumber__c, Type, Classification__c from Case where id =: iid];
        if(c!=null){//Added by Shwetha
            c.Status = 'Discard';
    if(c.Export_Compliance_Content_ITAR_EAR__c == 'Undetermined') { 
      c.Export_Compliance_Content_ITAR_EAR__c='NO'; 
    } 
  
    if(c.Government_Compliance_SM_M_Content__c == 'Undetermined') { 
      c.Government_Compliance_SM_M_Content__c='NO'; 
    } 
    if(c.Supported_Products__c == null) { 
      Supported_Products__c sprod = [Select Id,Name from Supported_Products__c where Name = 'Dummy' limit 1]; 
      if(null!=sprod  ){ 
   
        c.Supported_Products__c=sprod.Id; 
      } 
    } 

    
    
    if(c.Type == 'Invoice Disputes' && c.Customer_PO_RO_WONumber__c == '' ||c.Customer_PO_RO_WONumber__c == null) { 
        c.Customer_PO_RO_WONumber__c='12345'; 
    } 
    
    if(c.Classification__c == null) { 
        c.Classification__c='Hand-Off NON-AERO'; 
    }
        update c;
            flag=true;//Added by Shwetha
		flag1 = flag; //Added by Shwetha
        }//Added by Shwetha
       return flag1; //Added by Shwetha
    }
   
    
    @AuraEnabled
    Public static boolean closeTasks(Id iid) {
            List<Task> taskList = new List<Task>();
          boolean flag1 = false;
        boolean flag=false;
            List<Task> tasks = [SELECT id,status FROM Task WHERE whatid =: iid and status != 'Completed' and status != 'Cancelled'];
            if(tasks.size() > 0){
              for(task t:tasks){
                 t.status = 'Completed';
                 taskList.add(t);
              }
              update taskList;
              flag=true;
               flag1=flag; 
              
            }
            
       return flag1;  
      
    }
    
    
     @AuraEnabled
    Public static string myAeroSpaceViewOrder(Id iid) {
            Case c = new case();
          string sonumber;
            c = [SELECT id,Sales_Order_Number__c FROM Case WHERE id =: iid];
            if(c.Sales_Order_Number__c == null || c.Sales_Order_Number__c ==''){
               
            }
        else if( c.Sales_Order_Number__c != null){
              sonumber = c.Sales_Order_Number__c; 
               }
       return sonumber;  
      
    }
     @AuraEnabled
    Public static string notificationNumber(Id iid) {
            Case c = new case();
          string sonumber;
            c = [SELECT id,Repair_Notification_Number__c FROM Case WHERE id =: iid];
            if(c.Repair_Notification_Number__c == null || c.Repair_Notification_Number__c ==''){
               
            }
        else if( c.Repair_Notification_Number__c != null){
            
              sonumber = c.Repair_Notification_Number__c; 
               }
       return sonumber;  
      
    }
      @AuraEnabled
    Public static string quoteNumber(Id iid) {
            Case c = new case();
          string sonumber;
            c = [SELECT id,Quote_Number__c FROM Case WHERE id =: iid];
            if(c.Quote_Number__c == null || c.Quote_Number__c ==''){
               
            }
        else if( c.Quote_Number__c != null){
              sonumber = c.Quote_Number__c; 
               }
       return sonumber;  
      
    }
     @AuraEnabled
    Public static string salesOrderNumber(Id iid) {
            Case c = new case();
          string sonumber;
            c = [SELECT id,Sales_Order_Number__c  FROM Case WHERE id =: iid];
            if(c.Sales_Order_Number__c  == null || c.Sales_Order_Number__c  ==''){
               
            }
        else if( c.Sales_Order_Number__c  != null){
              sonumber = c.Sales_Order_Number__c ; 
               }
       return sonumber;  
      
    }
     @AuraEnabled
    Public static boolean assigntome(Id iid) {
       Case c = new Case(); 
         boolean flag1 = false;
        boolean flag=false;
        c=[Select id,OwnerId from Case where id =: iid];
        if(c != null){
        c.OwnerId = UserInfo.getUserId();
        Update c;
             flag=true;
               flag1=flag;
        }
       return  flag1;
    }
    
     @AuraEnabled
    Public static boolean newAircraftDelivery() {
       return true;
        
    }
    
}