public class SalesCompetencyRatingsGridSort {
    Map<id,Account> updateAccounts;
    //Map<String,Sales_Competency_Rating__c> updateSalesCompRating;
    List<Sales_Competency_Rating__c> updateSalesCompRating;
    List<accWrapper> accounts;
    List<accWrapper> SalesCompetencies;
    public String saveId{get;set;}
    public String strSCId{get;set;}
    public Boolean refreshPage {get; set;}
    public Boolean savecalled= false;
    //public Boolean refreshPage {get; set;}
    //public id OpportunityId{get; set;}
    
    public Sales_Competency__c SC;
     public Sales_Competency_Rating__c a { get; set; }
   
    private ApexPages.StandardController controller;
    
    Public SalesCompetencyRatingsGridSort(ApexPages.StandardController Controller)
    {
        this.controller = controller; 
        SC = (Sales_Competency__c)controller.getRecord();
        //OpportunityId=opp.id;
        refreshPage=false;
    }
    public SalesCompetencyRatingsGridSort (){
    a = new Sales_Competency_Rating__c ();
    SalesCompetencies = new  List<accWrapper>();
    }
    public List<accWrapper> getSalesCompetencies() {
        if(SalesCompetencies == null || savecalled==true)
        {   
            List<accWrapper> SalesCompetenciesSort = new List<accWrapper>();
            SalesCompetencies = new List<accWrapper>();
            updateSalesCompRating = [select id,name,Competency__c,Proficiency_Expectation_for_Role_Target__c,Self_Assessment_Proficiency__c,Employee_Proficiency_Rating__c,Proficiency_Delta__c,Delta_Flag__c,SubCompetency_Needs_Development__c from Sales_Competency_Rating__c Where Sales_Competency_Assessment__c =: SC.Id order by Name DESC];
            system.debug('H>>>>>>>>>>>>>>>'+updateSalesCompRating.size());    
            updateSalesCompRating.sort();      
            for(Sales_Competency_Rating__c a : updateSalesCompRating)
            {   
                accWrapper test = new accWrapper(a);
                //test.id = a.id;
                //test.Name = a.Name;  
                SalesCompetencies.add(test);
            }
            savecalled= false;
        }
        system.debug('B>>>>>>>>>>>>>>>'+SalesCompetencies.size());
        return SalesCompetencies;
    }
        
    public class accWrapper {
        public string id{get;set;}
        public string Name{get;set;}
        public Sales_Competency_Rating__c SCR{get;set;}
                
        accWrapper(Sales_Competency_Rating__c SCR)
        {
            this.id=id;
            this.SCR=SCR;            
       }
    }
}