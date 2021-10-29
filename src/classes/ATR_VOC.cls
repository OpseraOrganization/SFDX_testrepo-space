public with sharing class ATR_VOC{
 
 public static boolean SelectedSurveyType {get; set;}
 public String selectedAccout{get;set;}
  public static set<id> fid = new set<id>();
    
    public ATR_VOC(){
        SelectedSurveyType = false;
    }
        
    @remoteaction
    public static list<Feedback__c> RemFeedback(List<string> Stype1)
    {
        list<string> surveytype= new list<string>{'Airbus','Boeing','GE','NSS','HOS'};
        list<string> producttype= new list<string>{'Avionics','APU','Mechanical'};
        list<string> Year = new list<string>{'2010','2011','2012','2013','2014','2015','2016','2017','2018','2019','2020'};
       
        id recId=label.ATR_VOC_Record_Type;
        list<Feedback__c> fed=new list<Feedback__c>();
        string query='';
        
        string Stype = stype1.get(0) ;
        string Stype12 = stype1.get(1) ;
        string Stype13 = stype1.get(2);        
        string Stype14 = stype1.get(3);
        system.debug('yyyyyyyyyyyyyyyyy'+Stype14);

        if( Stype == 'ALL' && query==''){
            SelectedSurveyType = False;
           query='select id,ATR_Survey_Group__c,Account__c,Account__r.Name,Account_Name__c,Product_Category__c,Year__c,Name,Metric_for_Reliability__c,Metric_for_Quality__c,Warranty__c,Repair_Performance__c,Spares_Performance__c,Recommend_HON__c,Metric_for_Value__c,Cost__c,Overall_Perception__c,Communication__c,Documentation__c,Metric_for_Service_Support__c,Global_Technical_Ops_Support__c,Flexibility__c,Customer_Overall_Satisfaction_Metric__c,Consolidated_score__c from Feedback__c where  recordtypeid=:recId and ATR_Survey_Group__c in: surveytype';           
        }
        else{
            SelectedSurveyType = True;
            query='select id,ATR_Survey_Group__c,Account__c,Account__r.Name,Account_Name__c,Product_Category__c,Year__c,Name,Metric_for_Reliability__c,Metric_for_Quality__c,Warranty__c,Repair_Performance__c,Spares_Performance__c,Recommend_HON__c,Metric_for_Value__c,Cost__c,Overall_Perception__c,Communication__c,Documentation__c,Metric_for_Service_Support__c,Global_Technical_Ops_Support__c,Flexibility__c,Customer_Overall_Satisfaction_Metric__c,Consolidated_score__c from Feedback__c where recordtypeid=:recId and ATR_Survey_Group__c=:Stype';
        }
        System.Debug(':::::::SelectedSurveyType::::::'+SelectedSurveyType);
        if(Stype13 == 'ALL' || Stype13 =='' ){
        query = query + ' and Product_Category__c in:producttype ';
        System.debug(query );
        }
        else
        {
        query = query + ' and Product_Category__c=:Stype13 ';
        System.debug(query );
        }
        if(Stype12 == 'ALL' || Stype12 == '')
        {
        query = query + ' and Year__c in:Year';
        }
        else
        {
        query = query + ' and Year__c =:Stype12 ';
        }
        /*String str='';
        str = ApexPages.CurrentPage().getParameters().get('accname');
        system.debug(str);
        if (str !=''){
            Stype14 = str;}
        */
        if( Stype14 != '' )
        {
        query = query + ' and Account_Name__c =:Stype14 ';
        }
        query = query + ' order by createddate desc ';
        System.debug('TTTTTTTTTTTTTTTTTTTTT'+query );    
        fed=Database.Query(query);
        for(feedback__c fi:fed)
        {
        fid.add(fi.account__c);
        }
        
        System.debug('fed.size()'+fed.size());
        return fed;
       
        

    }
    
    public void setInputvalue(){
    System.debug(selectedAccout);
}

    public list<Feedback__c> getAccountList(){
    return [select Account_Name__c from Feedback__c limit 900];
    //return [select Account__r.Name from Feedback__c];
}


   // Fetching Account list
    @RemoteAction
    public static List<Account> searchAccount(String searchTerm) {
       System.debug('ANUSUYA'+searchTerm);
         List<Account> Accounts = Database.query('Select Id, Name from Account where name LIKE  \'%' + String.escapeSingleQuotes(searchTerm) + '%\' ORDER BY Name ASC limit 1000 ');
         //List<Account> Accounts = Database.query('Select Id, Name from Account  ORDER BY Name ASC ');
     System.debug('ANUSUYA'+Accounts.size());
        return Accounts ;
    }       
    
    
    
   
}