public with sharing class AutoComplete_Controller{

    //Constructors
    
    public AutoComplete_Controller() {}
    
    public AutoComplete_Controller(ApexPages.StandardController controller) {}

    //Attributes
    
    public List<String> resultsname = new List<String>();
    public Boolean hasparams = false;
    public Boolean hasnoresults = false;
    public String stext{get;set;}
    public Integer iLimit{get;set;}
    public String sobjectname {get;set;}
        
    //Getters and Setters
    
    public Boolean getHasparams(){

        return hasparams;
        
    }
    
    public void clearValues(){
        
        hasparams = false;
        
    }
    
    public Boolean getHasnoresults(){
    
        return hasnoresults;    
    }

    public void avoidRefresh(){
        
    }
    
     public PageReference searchSuggestions() {
     
         String scondTextValue = System.currentPageReference().getParameters().get('CondFieldValue');

        //Initalize variables, hasparams just indicates that a search has started
        resultsname.clear();   
        hasparams = true;
        hasnoresults = false;

        //Obtain current parameters
        sobjectname = System.currentPageReference().getParameters().get('objectname');
        stext = '%'+String.escapeSingleQuotes(System.currentPageReference().getParameters().get('aname').trim())+'%';
        
        //Limit Suggestions to 20 Results
         iLimit = 20;
        
     //Validate if theres an input and get results
     
     if(stext.length() > 2){

        try{
           
           // if(sobjectname == 'Account'){
            
                String sql = 'select Id,Name from ' + sobjectname + ' where Name LIKE \''+stext+'\'  ' + 'limit '+ iLimit;
                                              
                for(sobject x : Database.query(sql)){
                    String s  = String.escapeSingleQuotes(((String)(x.get('Name'))));
                
                   resultsname.add(s); 
                  
                    } 
            
            /**}else{
                    
            String sql = 'select name from Repcode__c where name like \''+stext+'\'ORDER BY name ASC limit '+ iLimit ;
                    for(sobject x : Database.query(sql)){
                        
                        String s  = String.escapeSingleQuotes(((String)(x.get('name'))));
                        resultsname.add(s); 
                    }
        
           }**/
        }catch(Exception e){
            
            resultsname.add('Unexpected Error, please contact support');    
        }


     }
       return null;
  }
  
      
      
     public List<String> getResultsname(){
          //Make sure to clear past values
          clearValues();
          if(resultsname.isEmpty()){
            hasnoresults = true;
            resultsname.add('No Results');
          }
          return resultsname;
      }
 


}