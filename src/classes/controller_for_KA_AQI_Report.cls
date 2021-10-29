/*
    Created by: NTT Data
    Project: CSO Bundle project
*/
public with sharing class controller_for_KA_AQI_Report {
    public controller_for_KA_AQI_Report() {}
   /* public string filterInput;
    public string getFilterInput() {
    return this.filterInput;
    }
    public void setFilterInput(String filterInput) {
    this.filterInput =filterInput;
    }
    public List<kaWrapper> display_list {get; set;} //list for all Article records and a row counter
    public List<String> current_list = new List<String>(); //list for holding many record Ids
    public List<String> next_list = new List<String>(); //list for holding record Ids that are after the current records
    public List<String> previous_list = new List<String>(); //list for holding record Ids that are before the current records
    Integer list_size = 20; //number of records to display on the page
    Integer record_counter = 0;
    
    public List<KAAQIData> d {get; set;}
    
    //initiates the controller and displays some initial data when the page loads
    public controller_for_KA_AQI_Report() {
        record_counter = 0; //counter
        for (Knowledge_Article__kav ka : [SELECT ID,  Title, KCS_Coach__c
            FROM Knowledge_Article__kav WHERE PublishStatus = 'Online' and Language = 'en_US' and KCS_Coach__c != null limit 10000 ]) { //for a bunch of accounts
            
             if ( record_counter < list_size) {//if we have not yet reached our maximum list size
            current_list.add(ka.Id);
            }
            else{
                next_list.add(ka.Id); //add the Id to our next_list
                }
            record_counter++;
        }
    }
    
    public List<kaWrapper> getRecordsToDisplay() {
        Set<String> record_ids = new Set<String>(); //set for holding distinct Ids
        Boolean records_added = record_ids.addAll(current_list); //add all the records from our current_list list
        display_list = new List<kaWrapper>(); //set the display_list object to a new accountWrapper List
        Integer counter = 1; //row counter variable
        map<string, Article_Quality_Index2__c> mAQI = new map<string, Article_Quality_Index2__c>();
        
        for (Article_Quality_Index2__c aqi : [SELECT ID,  Article_Quality__c,KnowledgeArticleId__c 
            FROM Article_Quality_Index2__c limit 10000 ]) { //query for the details of the records you want to display
            mAQI.put(aqi.KnowledgeArticleId__c, aqi); //add the aqi to our list
            
        }
        //system.debug('maqi'+mAQI);
        for (Knowledge_Article__kav ka : [SELECT ID,  Title, Summary, KCS_Coach__c, Createdby.name
            FROM Knowledge_Article__kav WHERE PublishStatus = 'Online' and Language = 'en_US' and KCS_Coach__c != null and id =: record_ids ]) { //query for the details of the records you want to display
            
            
            //system.debug('maqi'+ka.id+' '+mAQI.containsKey(ka.id));
            if(mAQI.containsKey(String.valueOf(ka.Id).substring(0, 15))){
            display_list.add(new kaWrapper(ka, counter,'Yes',mAQI.get(String.valueOf(ka.Id).substring(0, 15)))); //add the article and counter to our list
            counter++; //increment the counter
            }else{
            display_list.add(new kaWrapper(ka, counter, 'No',null)); //add the article and counter to our list
            counter++; //increment the counter
            }
            
        }
        return display_list; //return the list of full records plus their row counter
    }
    
    public class kaWrapper {
        public Knowledge_Article__kav kar {get; set;} //KA object
        public Integer numberOfRow {get; set;} //row counter variable
        public String AQIcheck {get; set;} //row counter variable
        public Article_Quality_Index2__c AQI {get; set;} //row counter variable
        
        public kaWrapper(Knowledge_Article__kav ka, Integer rowCounter,String AQIflag,Article_Quality_Index2__c AQ ) {
            this.kar = ka; //assign article
            this.numberOfRow = rowCounter; //assign row counter
            this.AQIcheck = AQIflag; //assign row counter
            this.AQI = AQ; //assign row counter
            
        }
    }
    
   
    
     public Integer getCurrentSize() {
        return current_list.size(); //number of record in current_list
    }
    
    public Integer getPrevSize() {
        return previous_list.size(); //number of record in previous_list
    }
    
    public Integer getNextSize() {
        return next_list.size(); //number of record in next_list
    }
    
    public Boolean listContains(Object[] source, Object target) {
    return (new Set<Object>(source)).contains(target);
    }
    
    public PageReference next() {
    //current_list.clear();
    list_size += 20;
    filter();
    return null;
    
    }
    public PageReference previous() {
    //current_list.clear();
    list_size += -20;
    filter();
    return null;
    }
    
    public PageReference filter() {
    current_list.clear();
    next_list.clear();
     record_counter = 0; //counter
        for (Knowledge_Article__kav ka : [SELECT ID,  Title, KCS_Coach__c
            FROM Knowledge_Article__kav WHERE PublishStatus = 'Online' and Language = 'en_US' and KCS_Coach__c != null and CreatedBy.KCS_Coach__r.Full_Name__c != '' limit 10000 ]) { //for a bunch of accounts
             
            if(filterInput != null && filterInput != ''){
            list<string> fi = filterInput.tolowercase().split(',');
            list<string> kc = ka.KCS_Coach__c.tolowercase().split(' ');
            system.debug('maqi'+filterInput + ' '+kc+' '+fi);
            string kaid = ka.id;
            for(string kcn: kc){
            if(listcontains(fi,kcn.left(kcn.length()-1)) &&  !listcontains(current_list,kaid)){
            record_counter++;
             if (record_counter > (list_size-20) && record_counter <= list_size) {//if we have not yet reached our maximum list size
            current_list.add(ka.Id);
            
            }
            }
            }
            }else{
            record_counter++;
             if (record_counter > (list_size-20) && record_counter <= list_size) {//if we have not yet reached our maximum list size
            current_list.add(ka.Id);
            }
            }
            
            
            
        }
    Return null;
    }
    
    public class KAAQIData {
    public String Cname { get; set; }
    public  Integer KAcount { get; set; }
    public  Integer AQIcount { get; set; }
    

    public KAAQIData(String namevalue,  Integer kcount, Integer aqcount) {
        Cname = namevalue;
        KAcount = kcount;
        AQIcount = aqcount;
    }
    }

    public List<KAAQIData> getData() {
    d = new List<KAAQIData>();
    map<string, list<Knowledge_Article__kav>> mKA = new map<string, list<Knowledge_Article__kav>>();
    map<string, Article_Quality_Index2__c> mAQI = new map<string, Article_Quality_Index2__c>();
    List<Knowledge_Article__kav> ka =[SELECT ID,KCS_Coach__c FROM Knowledge_Article__kav WHERE PublishStatus = 'Online' and Language = 'en_US'];
    for (Knowledge_Article__kav kav: ka){
    if (!mKA.containsKey(kav.KCS_Coach__c) && kav.KCS_Coach__c != null){
    mKA.put(kav.KCS_Coach__c, new  List <Knowledge_Article__kav> {kav});
    }else if(kav.KCS_Coach__c != null){
    mKA.get(kav.KCS_Coach__c).add(kav);
    }
    }
    
    
    for(Article_Quality_Index2__c aqi: [SELECT ID,  Article_Quality__c,KnowledgeArticleId__c FROM Article_Quality_Index2__c where KnowledgeArticleId__c != null]){
    mAQI.put(aqi.KnowledgeArticleId__c, aqi);
    }
    
    integer aqino =0;
    for (string name : mKA.keySet())
    {
    aqino =0;
    for (Knowledge_Article__kav kaRecord : mKA.get(name))
    {
      if(mAQI.containsKey(String.valueOf(kaRecord.Id).substring(0, 15)))
      {
          aqino +=1;
      }
    }
    d.add(new KAAQIData(name, mKA.get(name).size(), aqino));
    
    }
    
    return d;
    } 

   */
}