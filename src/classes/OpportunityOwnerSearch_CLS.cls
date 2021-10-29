public class OpportunityOwnerSearch_CLS {
    public String values { get; set; }
    Public String value { get;set;}
    public String Operator{get;set;}
    public String selectedfield{get;set;}
    public ApexPages.StandardSetController query{
        get {
            if(query== null){
                 query= new ApexPages.StandardSetController(Database.getQueryLocator([SELECT id,StageName,Opportunity_Owner_First_Name__c,CloseDate,Opportunity_Owner_Last_Name__c,Opportunity_Number__c,Opportunity_Owner_formula__c,Accountid,Amount,Opportunity_Link__c,Opportunity_Edit_Link__c FROM Opportunity where Opportunity_Owner_formula__c LIKE : values ORDER BY CreatedDate DESC LIMIT 1000]));
            }
            return query;
        }set;
    }
     Public List<Opportunity> oppList{
    get{
        if(query!= null)
            return (List<Opportunity>)query.getRecords();
        else
            return null ;
        }set;}
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('Like','Includes'));
            options.add(new SelectOption('Starts with','Starts with'));
            return options;
    }
    public List<SelectOption> getfieldValues() {
        List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('Opportunity_Owner_formula__c','Owner FullName'));
            return options;
    }
    public Boolean hasNext {
        get {
            return query.getHasNext();
        }set;
    }
    public Boolean hasPrevious {
        get {
            return query.getHasPrevious();
        }set;
    }
    public Integer pageNumber {
        get{
           return query.getPageNumber();
        }set;
    }
    public Integer recordSize {
        get{
           return query.getResultSize();
        }set;
    }
    public OpportunityOwnerSearch_CLS(){
        oppList=new  List<Opportunity>();
        query= new ApexPages.StandardSetController(Database.getQueryLocator([SELECT id,StageName,Opportunity_Owner_First_Name__c,CloseDate,Opportunity_Owner_Last_Name__c,Opportunity_Number__c,Opportunity_Owner_formula__c,Accountid,Amount,Opportunity_Link__c,Opportunity_Edit_Link__c FROM Opportunity LIMIT 1000]));
         query.setPageSize(50);
         oppList=query.getRecords();
        // oppList.sort();
       
    }
    public void doSearch(){
        try{
            if(operator == 'Starts with') {
                if(values != 'null'){
                    values=value+'%';
                    query= new ApexPages.StandardSetController(Database.getQueryLocator([SELECT id,StageName,Opportunity_Owner_First_Name__c,CloseDate,Opportunity_Owner_Last_Name__c,Opportunity_Number__c,Opportunity_Owner_formula__c,Accountid,Amount,Opportunity_Link__c,Opportunity_Edit_Link__c FROM Opportunity where Opportunity_Owner_formula__c LIKE : values ORDER BY CreatedDate DESC LIMIT 1000]));
                    query.setPageSize(50);
                 }
            }  
            if(operator == 'LIKE'){
                if(values != 'null'){
                    values='%'+value+'%';
                    query= new ApexPages.StandardSetController(Database.getQueryLocator([SELECT id,StageName,Opportunity_Owner_First_Name__c,CloseDate,Opportunity_Owner_Last_Name__c,Opportunity_Number__c,Opportunity_Owner_formula__c,Accountid,Amount,Opportunity_Link__c,Opportunity_Edit_Link__c FROM Opportunity where Opportunity_Owner_formula__c LIKE : values ORDER BY CreatedDate DESC LIMIT 1000]));
                    query.setPageSize(50);
                } 
            }   
            
        }catch(Exception e){}
    }
    public void first() {
        query.first();
    }
    public void last() {
        query.last();
    }
    public void previous() {
        query.previous();
    }
    public void next() {
        query.next();
    }
}