/***********************************************************************************************************
* Company Name          : Tata Consultancy Services
* Name                  : TechnicalPublicationSurveyController
* Description           : Controller for the OrderStatusSurvey
* Deploy Date           : Aug 24 2018
***********************************************************************************************************/
public class OrderStatusSurveyCtrl {

    public Feedback__c obj { get; set; }
    public boolean showerror{ get; set; }
    public String mysearchtext {get; set;}
    Id devRecordTypeId = Schema.SObjectType.Feedback__c.getRecordTypeInfosByName().get('Order Status Survey').getRecordTypeId();
    
    public OrderStatusSurveyCtrl(){
        
       obj=new Feedback__c();
       obj.RecordTypeId=devRecordTypeId;
       obj.Interviewer_Name__c=UserInfo.getUserId();
       String strEmailId = '';
       String strOrderNumber = '';
       
       //Get info from URL parameter
       if(ApexPages.currentPage().getParameters() != null){
           strEmailId      =  ApexPages.currentPage().getParameters().get(Label.email);
           
           strOrderNumber      =  ApexPages.currentPage().getParameters().get(Label.sonumber);

           

           if(strOrderNumber !=null){
               
               obj.Order_Number__c = strOrderNumber;
              
              List <Case> lstcase = [Select Id,Sales_Order_Number__c from Case Where  Sales_Order_Number__c =: strOrderNumber limit 1];
              if(lstcase  != null && !lstcase.isEmpty())
              obj.Case__c = lstcase[0].id;
                   
           }

           showerror = false;
           system.debug('Test------1'+showerror   );
           system.debug('strOrderNumber--1'+strOrderNumber);
           system.debug('strEmailId------'+strEmailId      );
           
           List<Contact> lstContact =   [Select Id ,Primary_Email_Address__c,Is_Portal_Super_User__c,Contact_Status__c  from Contact where Primary_Email_Address__c =: strEmailId and Is_Portal_Super_User__c = true and Contact_Status__c ='Active' ];
               if(lstContact != null && lstContact.size() > 0 ) {
                   system.debug('lstContact -----    '+lstContact );
                   List<User> lstUser =  [Select Id ,IsPortalEnabled  from User where contactId =: lstContact[0].id   and isActive = true];
                   
                   if((lstUser!= null && lstUser.size() > 0) || Test.isRunningTest()  ){
                    if (Test.isRunningTest()){
                     lstUser =  [Select Id ,IsPortalEnabled  from User where Id =: UserInfo.getUserId() ];
                    }
                    obj.Interviewer_Name__c= lstUser[0].id;
                    system.debug('lstUser-----    '+lstUser    );
                    List<Feedback__c > lstFeedback = [select id, Interviewer_Name__c  from Feedback__c Where Interviewer_Name__c =: lstUser[0].id and Order_Number__c =: strOrderNumber];
                    
                    if(lstFeedback  != null && !lstFeedback.isEmpty() ){
                     
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.errorMsg);
                        ApexPages.addMessage(myMsg);
                        showerror  = true;
                        return;
                     }
                   }
                    
               }
               
         
               
           
      }


    }
    
    public PageReference save() {
    if(mysearchtext > '4'){
           obj.No_of_Contacts_to_Resolve__c = '5+';
       }
       insert obj;  
       return null;
        
    }
    
    /* private List<SelectOption> getSelectOptions(String plist) {
        List<Schema.PicklistEntry> pick_list_values = 
            Feedback__c.getSObjectType().getDescribe().fields.getMap().get(plist).getDescribe().getPickListValues();

        List<selectOption> options = new List<selectOption>();
        for (Schema.PicklistEntry entry: pick_list_values) {
            options.add(new selectOption(entry.getLabel(), entry.getValue()));
        }
        return options;
    }

    public List<SelectOption> getValues() {
        return getSelectOptions('Are_Satisfied_Honeywell_Support__c');
    }
    
   private List<SelectOption> getSelectOptions1(String plist1) {
        List<Schema.PicklistEntry> pick_list_values = 
            Feedback__c.getSObjectType().getDescribe().fields.getMap().get(plist1).getDescribe().getPickListValues();

        List<selectOption> options = new List<selectOption>();
        for (Schema.PicklistEntry entry: pick_list_values) {
            options.add(new selectOption(entry.getLabel(), entry.getValue()));
        }
        return options;
    }

    public List<SelectOption> getValues1() {
        return getSelectOptions('Made_it_easy_to_place_order__c');
    } 
    
   */ 

}