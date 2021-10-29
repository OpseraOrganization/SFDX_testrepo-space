public with sharing class NewSolution {
   
    public NewSolution(ApexPages.StandardController controller) {
    }

    public String  selval{get;set;}
    
 public List<SelectOption> getvalues() {
        List<SelectOption> options = new List<SelectOption>();
/*        Schema.DescribeSObjectResult R = Solution.SObjectType.getDescribe();
        List<Schema.RecordTypeInfo> RT = R.getRecordTypeInfos();*/
        List<RecordType> RT = new List<RecordType>([select Name from RecordType where Name = 'Solution GTO Technical' OR Name = 'Solution CSO Non-Technical']);
        for(RecordType S : RT)
        options.add(new SelectOption(S.name,S.name));
        return options;
     }
     

     
     public PageReference docontin(){
         if(selval == 'Solution GTO Technical'){
            Id id1 = [select Id from RecordType where Name = 'Solution GTO Technical'].ID;
             //Pagereference p = new Pagereference('/apex/Solution_Page_edit?rec=\'' + id1 + '\'');
              Pagereference p = new Pagereference('/apex/Solution_Page?rec=' + id1);
             p.setredirect(true);
             return p;
         }else{
             Pagereference p = new Pagereference('/501/e?retURL=%2F501%2Fo&RecordType=01230000000T0tB&ent=Solution&nooverride=1');
             p.setredirect(true);
             return p;
         }
       } 
     public PageReference docancel(){
             Pagereference p = new Pagereference('/501/o');
             p.setredirect(true);
             return p;
         }
  
}