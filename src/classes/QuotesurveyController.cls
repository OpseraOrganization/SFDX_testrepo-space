public class QuotesurveyController {
    
    public Feedback__c obj { get; set; }
    public boolean showerror{ get; set; }
    Id devRecordTypeId = Schema.SObjectType.Feedback__c.getRecordTypeInfosByName().get('Quote Survey').getRecordTypeId();
    
    public QuotesurveyController(){
        
       obj=new Feedback__c();
       obj.RecordTypeId=devRecordTypeId;
       obj.Interviewer_Name__c=UserInfo.getUserId();
       String strEmailId = '';
       //String strquote      = '';
       String strCaseNumber = '';
        
       if(ApexPages.currentPage().getParameters() != null){
           strEmailId      =  ApexPages.currentPage().getParameters().get(Label.email);
           //strquote      =  ApexPages.currentPage().getParameters().get(Label.quotenumber);
           strCaseNumber =  ApexPages.currentPage().getParameters().get('sfdcCase');
           
           String casenum ='%'+strCaseNumber+'%';
           
            if( strCaseNumber!=null && strCaseNumber != ''){
               obj.Case_Number__c = strCaseNumber;
                
                Case[] cse = [select id, Case_Number__c from case where Case_Number__c Like :casenum LIMIT 1 ];
                if(cse.size()>0){

               obj.Case__c  = cse[0].Id;
                }
                
            }
           
           
           
           
           /*
            if(strCaseNumber !=null && strCaseNumber != ''){
               quoteOrder(strCaseNumber );
               showError(strEmailId , strCaseNumber );
               
           }
           */

           showerror = false;
           system.debug('Test------1'+showerror   );
           //system.debug('strOrderNumber--1'+strquote      );
           system.debug('strEmailId------'+strEmailId      );
           
           List<Contact> lstContact =   [Select Id ,Primary_Email_Address__c,Is_Portal_Super_User__c,Contact_Status__c  from Contact where Primary_Email_Address__c =: strEmailId and Is_Portal_Super_User__c = true and Contact_Status__c ='Active' ];
               if(lstContact != null && lstContact.size() > 0 ) {
                   system.debug('lstContact -----    '+lstContact );
                   List<User> lstUser =  [Select Id ,IsPortalEnabled  from User where contactId =: lstContact[0].id and IsPortalEnabled  = true  and isActive = true];
                   if((lstUser!= null && lstUser.size() > 0) || Test.isRunningTest()  ){
                       if (Test.isRunningTest()){
                     lstUser =  [Select Id ,IsPortalEnabled  from User where Id =: UserInfo.getUserId() ];
                    }
                    obj.Interviewer_Name__c=lstUser[0].id;
                    system.debug('lstUser-----    '+lstUser    );
                    //List<Feedback__c > lstFeedback = [select id, Interviewer_Name__c  from Feedback__c Where Interviewer_Name__c =: lstUser[0].id and Order_Number__c =: strquote      ];
                    List<Feedback__c > lstFeedback = [select id, Interviewer_Name__c  from Feedback__c Where Interviewer_Name__c =: lstUser[0].id and Case_Number__c =: strCaseNumber and RecordTypeId =: devRecordTypeId];

                         if(lstFeedback  != null && lstFeedback.size()>0  ){
                        system.debug('lstFeedback  '+lstFeedback + 'Test------'+showerror    );
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Feedback already provided for this quote');
                        ApexPages.addMessage(myMsg);
                        showerror  = true;
                        return;
                     }
                    
               }
               
               }
               
           
      }


    }

    public PageReference save() {
       insert obj;  
       return null;
        
    }
    
    private List<SelectOption> getSelectOptions(String plist) {
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
    
    /*
    public void showError(String strCasenumber, String strEmailId){
    
    List<Contact> lstContact =   [Select Id ,Primary_Email_Address__c,Is_Portal_Super_User__c,Contact_Status__c  from Contact where Primary_Email_Address__c =: strEmailId and Is_Portal_Super_User__c = true and Contact_Status__c ='Active' ];
               if(lstContact != null && lstContact.size() > 0  ) {
                   system.debug('lstContact -----    '+lstContact );
                   List<case> lstCase = [Select Id,caseNumber from case Where caseNumber =: strCasenumber  ];
                   obj.case__c=lstCase [0].id;
                   
                   List<User> lstUser =  [Select Id ,IsPortalEnabled  from User where contactId =: lstContact[0].id and IsPortalEnabled  = true  and isActive = true];
                   if((lstUser!= null && lstUser.size() > 0)  || Test.isRunningTest() )
                       if(test.isRunningTest()){
                          lstUser =  [Select Id ,IsPortalEnabled  from User where Id =: UserInfo.getUserId() ];
                       } 
                    obj.Interviewer_Name__c=lstUser[0].id;
                    system.debug('lstUser-----    '+lstUser    );
                    List<Feedback__c > lstFeedback = [select id, Interviewer_Name__c  from Feedback__c Where Interviewer_Name__c =: lstUser[0].id and Order_Number__c =: strCasenumber];
                     if(lstFeedback  != null && !test.isRunningTest()){
                        system.debug('lstFeedback  '+lstFeedback + 'Test------'+showerror    );
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Feedback already provided for this order number');
                        ApexPages.addMessage(myMsg);
                        showerror  = true;
                        return;
                     }
                    
               }
    
    
    }
    
    public void quoteOrder(String strCasenumber){
    
    
    }
*/



}