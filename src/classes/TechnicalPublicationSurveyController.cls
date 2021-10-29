/***********************************************************************************************************
* Company Name          : Tata Consultancy Services
* Name                  : TechnicalPublicationSurveyController
* Description           : Controller for the TechPubSurvey
* Deploy Date           : Aug 24 2018
***********************************************************************************************************/
public class TechnicalPublicationSurveyController {

    public Feedback__c obj { get; set; }
    public boolean showerror{ get; set; }
    public String mysearchtext {get; set;}
    Id devRecordTypeId = Schema.SObjectType.Feedback__c.getRecordTypeInfosByName().get('Technical Publication Survey').getRecordTypeId();
    
    public TechnicalPublicationSurveyController(){
        
       obj=new Feedback__c();
       obj.RecordTypeId=devRecordTypeId;
       obj.Interviewer_Name__c=UserInfo.getUserId();
       String strEmailId = '';
       String strquote      = '';
       String strTech  = '';
        
       if(ApexPages.currentPage().getParameters() != null){
           strEmailId      =  ApexPages.currentPage().getParameters().get(Label.email);
           strTech         =  ApexPages.currentPage().getParameters().get('Techpubid');
           //strquote      =  ApexPages.currentPage().getParameters().get(Label.quotenumber);
           
           
           /*
            if(strquote !=null && strquote != ''){
               obj.Quote_Number__c = strquote; 
            }
           
          
           if(strEmailId !=null && strEmailId !=''){
               
               obj.User_Email__c = strEmailId;
           }
*/  
            system.debug('obj is: '+obj);
            system.debug('mysearchtext-----    '+mysearchtext );
           if(strTech !=null){
               
               obj.Tech_Pub_Id__c = strTech;
               
           }
           
        
              
           
           
          
           
           showerror = false;
           system.debug('Test------1'+showerror   );
           system.debug('strOrderNumber--1'+strquote      );
           system.debug('strEmailId------'+strEmailId      );
           
           List<Contact> lstContact =   [Select Id ,Primary_Email_Address__c,Is_Portal_Super_User__c,Contact_Status__c  from Contact where Primary_Email_Address__c =: strEmailId  and Contact_Status__c ='Active' ];
               if(lstContact != null && lstContact.size() > 0 ) {
                   system.debug('lstContact -----    '+lstContact );
                   List<User> lstUser =  [Select Id ,IsPortalEnabled  from User where contactId IN: lstContact and IsPortalEnabled  = true  and isActive = true];
                   if((lstUser!= null && lstUser.size() > 0) || Test.isRunningTest()  ){
                       if (Test.isRunningTest()){
                           lstUser =  [Select Id ,IsPortalEnabled  from User where Id =: UserInfo.getUserId() ];
                        }   
                    obj.Interviewer_Name__c=lstUser[0].id;
                    system.debug('lstUser-----    '+lstUser    );
                   
                   
                   //List<Feedback__c > lstFeedback = [select id, Interviewer_Name__c, User_Email__c  from Feedback__c Where Interviewer_Name__c =: lstUser[0].id and User_Email__c =: strEmailId];
                   List<Feedback__c > lstFeedback = [select id, Interviewer_Name__c,Tech_Pub_Id__c from Feedback__c Where Tech_Pub_Id__c =:strTech and RecordTypeId = :devRecordTypeId];

                         if(lstFeedback  != null && lstFeedback.size() > 0 ){
                        system.debug('lstFeedback  '+lstFeedback + 'Test------'+showerror    );
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Feedback already provided for this user');
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
       
       system.debug('mysearchtext1-----    '+mysearchtext );
       insert obj;  
       return null;
        
    }
    
/*    private List<SelectOption> getSelectOptions(String plist) {
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
    } */
    

}