public class MyAerospacePortalSurvey {
	public Feedback__c feeedback{get;set;}
    public Boolean isError{get;set;}
    public Boolean isSubmitted{get;set;}
    private String orderNumber;
    private String email;
    private Id devRecordTypeId = Schema.SObjectType.Feedback__c.getRecordTypeInfosByName().get('Survey Order').getRecordTypeId();
    public MyAerospacePortalSurvey(){
		feeedback = new Feedback__c();
        feeedback.recordTypeId = devRecordTypeId;
        isError = false;
        isSubmitted = false;
        orderNumber = ApexPages.currentPage().getParameters().get(Label.sonumber);
        email = ApexPages.currentPage().getParameters().get(Label.email);
        
        if(String.isNotBlank(orderNumber)){                
            feeedback.Order_Number__c = orderNumber;
            if(String.isNotBlank(email)){
                feeedback.ContactEmailAddress__c = email.length()<55?email:email.substring(0, 53);
                List<User> portalUsers = [SELECT id, Name, Email FROM User WHERE contact.Primary_Email_Address__c=:email AND isActive = true];
                if (Test.isRunningTest()){
                    portalUsers =  [Select Id ,IsPortalEnabled  from User where Id =: UserInfo.getUserId() ];
                }
                if(!portalUsers.isEmpty()){
                    feeedback.Interviewer_Name__c= portalUsers[0].id;                    
                    List<Feedback__c> feedbackList = [SELECT id, Interviewer_Name__c FROM Feedback__c WHERE Order_Number__c =:orderNumber AND Interviewer_Name__c=:portalUsers[0].id];
                    if(!feedbackList.isEmpty()){
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.errorMsg);
                        ApexPages.addMessage(myMsg);
                        isError = true;
                        return;
                    }
                }
            }
            
        }else{
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Order number not found.');
            ApexPages.addMessage(myMsg);
            isError = true;
            return;
        }
    }
    
    public void submitFeedback(){
        try{
            insert feeedback;
            isSubmitted = true;
        }catch(Exception ex){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Somethig went worng.');
            ApexPages.addMessage(myMsg);
            isError = true; 
        }
    }
}