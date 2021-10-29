public with sharing class IdeaExchPostcls {

    public IdeaExchPostcls(ApexPages.IdeaStandardController controller) {

    }
   @RemoteAction
    Static public List<string> getProductorgLists(){
        List<string> options = new List<string>();
        Schema.DescribeFieldResult fieldResult =idea.Product_Line_Family__c.getDescribe();   
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple) {
           options.add(f.getValue());
        } 
        system.debug('options ====> ' +options);
        return options;
    }
    @RemoteAction
    Static public List<string> getstatusLists(){
        List<string> options = new List<string>();
        Schema.DescribeFieldResult fieldResult =idea.Status.getDescribe();   
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple) {
           options.add(f.getValue());
        } 
        system.debug('options2222 ====> ' +options);
        return options;
    }
    @RemoteAction
    Static public List<string> getCatergoriesLists(){
        List<string> options = new List<string>();
        Schema.DescribeFieldResult fieldResult =idea.Categories.getDescribe();   
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple) {
           options.add(f.getValue());
        } 
        system.debug('options3333 ====> ' +options);
        return options;
    }
    @RemoteAction
    Static public idea insertpost(string catogery,string title, string description, string prod){
        system.debug('calling insert method');
        idea id=new idea();
        id.title=title;
        id.status = 'Submitted';
        id.Categories=catogery;
        //id.CommunityId ='09a3000000052pq';
        id.CommunityId = Label.Ideas_Zone; //'09ac00000004CqM'
        id.Body = description;
        id.Product__c = prod;
        insert id;
        return id;
        return null;
    }
}