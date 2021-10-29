public class GoGreen {
 public Go_Green_Plan__c ggp{get;set;}
 public string recordId{get;set;} 
 public Id FeedID; 
 
    public GoGreen(ApexPages.StandardController controller) {
       // ggp=[select recordTypeid from Go_Green_Plan__c ];
        FeedID = Apexpages.currentPage().getParameters().get('feedid');
    }
    public void setrecordId(){
        this.recordId = recordId;
    }
    public list<SelectOption> getrecordTypes(){
        list<SelectOption> options = new list<SelectOption>();
        for (list<RecordType> rts : [SELECT ID, name FROM RecordType WHERE SObjectType = 'Go_Green_Plan__c' ORDER BY name]) {
            for (RecordType rt : rts) {
                options.add(new SelectOption(rt.ID, rt.Name));
            }
        }
        return options;
    }
    public PageReference redirect(){
        PageReference nextPage = new PageReference('/apex/GoGreenPlan?feedid='+FeedID+'&recordTypeId='+recordId);
        nextPage.setredirect(true);
        return nextPage;
    }
}