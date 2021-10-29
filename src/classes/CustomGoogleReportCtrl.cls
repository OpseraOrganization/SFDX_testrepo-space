public with sharing class CustomGoogleReportCtrl{
    // Return a list of data points for a chart
   public ReportFilter__c repfitler{get;set;}
   private static MAP<Integer,Data> dataMap = new MAP<Integer,Data>();   
 
    public CustomGoogleReportCtrl(){
       
        repfitler = new ReportFilter__c ();  
        repfitler.Activity__c='ATS (Cases)';
        repfitler.From_Date__c=date.today().addYears(-1);
        repfitler.To_Date__c =date.today();       
        
        
    }
    
    @RemoteAction
    public static List<Data> caseSearch(String ActivityValue,String OtherCasemetrics,String SBU,String OpenClosedValue,String Enterprise,String Region,String AircraftType,String AccountName,String OEM,String NetSatisfactionScore,String PartNumber,String FromDateValue,String ToDateValue,String TrendValue,String ResolutionTime,String Age,String ageMin,String ageMax,String AgeBuckets,String AgeBucketselected){
    
        system.debug('***in case search');
        List<Data> dataList = new List<Data>();
        boolean showLinechart=false;
        if(ResolutionTime =='Yes' || Age =='Yes'){
            showLinechart=true;            
        }
        
        dataMap.clear();
        String CALENDAR_MNTH_QTR='';
        String searchQuery ='SELECT count(Id) ,';
        
        if(OpenClosedValue =='Closed' && ResolutionTime =='Yes')
            searchQuery =searchQuery +'AVG(Age_Custom_in_Hours__c) ,';
        else if(OpenClosedValue =='Open' && ResolutionTime =='Yes'){
            searchQuery =searchQuery +'AVG(Age_in_Hours__c) ,';
        }
        //else if(OpenClosedValue =='On Hold' && ResolutionTime =='Yes'){
          //  searchQuery =searchQuery +'AVG(Age_in_Hours__c) ,';
        //}
        if(OpenClosedValue =='Open' && Age =='Yes')             
            searchQuery =searchQuery +'AVG(Age_in_Hours__c) ,';
        //else if(OpenClosedValue =='On Hold' && Age =='Yes')          
          //  searchQuery =searchQuery +'AVG(Age_in_Hours__c) ,';
        else if(OpenClosedValue =='Closed' && Age =='Yes')
            searchQuery =searchQuery +'AVG(Age_Custom_in_Hours__c) ,';
            
        if(TrendValue =='By Month' && (OpenClosedValue == 'Open' || OpenClosedValue == 'On Hold')){
            searchQuery=searchQuery+'CALENDAR_YEAR(CreatedDate),CALENDAR_MONTH(CreatedDate)';
            CALENDAR_MNTH_QTR='CALENDAR_YEAR(CreatedDate),CALENDAR_MONTH(CreatedDate)';
        }
        else if(TrendValue =='By Month' && OpenClosedValue == 'Closed'){
            searchQuery=searchQuery+'CALENDAR_YEAR(ClosedDate),CALENDAR_MONTH(ClosedDate)';
            CALENDAR_MNTH_QTR='CALENDAR_YEAR(ClosedDate),CALENDAR_MONTH(ClosedDate)';
        }
         
        else if(TrendValue =='By Quarter' && (OpenClosedValue == 'Open' || OpenClosedValue == 'On Hold')){
            searchQuery= searchQuery+'CALENDAR_YEAR(CreatedDate),CALENDAR_QUARTER(CreatedDate)';
            CALENDAR_MNTH_QTR='CALENDAR_YEAR(CreatedDate),CALENDAR_QUARTER(CreatedDate)';
        }
        else if(TrendValue =='By Quarter' && OpenClosedValue == 'Closed'){
            searchQuery= searchQuery+'CALENDAR_YEAR(ClosedDate),CALENDAR_QUARTER(ClosedDate)';
            CALENDAR_MNTH_QTR='CALENDAR_YEAR(ClosedDate),CALENDAR_QUARTER(ClosedDate)';
        }
        
        
        searchQuery = searchQuery+' FROM Case where RecordTypeId =\'01230000000ZJvU\' and';
        
        
        if(FromDateValue!=null && FromDateValue!='')
        {
            if(OpenClosedValue == 'Open' || OpenClosedValue == 'On Hold')
                searchQuery=searchQuery+' CreatedDate>='+FromDateValue+' and';
            else if(OpenClosedValue == 'Closed')
                searchQuery=searchQuery+' ClosedDate>='+FromDateValue+' and';                
        } 
        if(ToDateValue!=null && ToDateValue!='')
        {
            if(OpenClosedValue == 'Open' || OpenClosedValue == 'On Hold')
                searchQuery=searchQuery+' CreatedDate<='+ToDateValue+' and';
            else if(OpenClosedValue == 'Closed')
                searchQuery=searchQuery+' ClosedDate<='+ToDateValue+' and';                
        }
        
        if(OtherCasemetrics =='First Call Resolution')
        searchQuery =searchQuery +' CSM_Senior_Escalation__c = True and';
        
        
        if(SBU!=null && SBU!='' && SBU!='All')
            searchQuery=searchQuery+' SBU_w2c__c=\''+SBU+'\' and';
        
            
        if(Enterprise!=null && Enterprise!='' && Enterprise !='All')
            searchQuery=searchQuery+' Enterprise__c=\''+Enterprise+'\' and';    
        
        if(Region!=null && Region!='' && Region!='Global'){
            if(Region=='APAC')
                searchQuery=searchQuery+' Region__c = \'Asia/Pacific Rim\' and';
            if(Region=='EMAI')
                searchQuery=searchQuery+' Region__c = \'Europe/MiddleEast/Africa/India\' and';
            if(Region=='Americas')
                searchQuery=searchQuery+' Region__c = \'Americas\' and';
        }
        if(AircraftType!=null && AircraftType!='' && AircraftType!='000000000000000')
            searchQuery=searchQuery+' Aircraft_Type__c=\''+AircraftType+'\' and';
        if(AccountName!=null && AccountName!='' && AccountName!='000000000000000' && AccountName!='null')
            searchQuery=searchQuery+' Account_Name__c=\''+AccountName+'\' and';
        
        if(OEM!=null && OEM!='')
            searchQuery=searchQuery+' Aircraft_Type__r.OEM_Name__r.Name LIKE \'%'+OEM+'%\' and';
        
        if(PartNumber!=null && PartNumber!='')
            searchQuery=searchQuery+' Product_Part_Number__c =\''+PartNumber+'\' and';
        
        if(AgeBuckets!=null && AgeBuckets == 'Yes' && AgeBucketselected!=null && AgeBucketselected != '')
        {           
            dataList = calculateAgeBucket(ActivityValue,searchQuery,OpenClosedValue,AgeBucketselected);
            return dataList;
        }   
        if(ageMin!=null && ageMax!=null && ageMax!='0')
        {
            if(OpenClosedValue == 'Closed')
            {                
                    searchQuery=searchQuery+' Age_Custom_in_Hours__c >= '+ageMin+' and Age_Custom_in_Hours__c <= '+ageMax+' and'; 
            }
            else if(OpenClosedValue == 'Open' || OpenClosedValue == 'On Hold'){             
                searchQuery=searchQuery+' Age_in_Hours__c >= '+ageMin+' and Age_in_Hours__c <= '+ageMax+' and'; 
            }
        }
            
         if(ActivityValue.contains('ATS'))
         searchQuery =searchQuery + ' OwnerId__r.Manager.ATS__c=true';
         if(ActivityValue.contains('DTS'))
         searchQuery =searchQuery + ' OwnerId__r.Manager.DTS__c=true';
         List<String> statusValues;    
        if(OpenClosedValue =='Open'){
            statusValues = new List<String>{'Open','Re-Open','On Hold'};
            searchQuery=searchQuery+' and Status in: statusValues ';
            }
        else if(OpenClosedValue =='Closed'){
            statusValues = new List<String>{'Done','Re-Closed','Tech Issue-SR Assigned','Discard','Cancelled','Propose to Close', 'Close-No Response', 'Closed – approved'};
            searchQuery=searchQuery+' and Status  in: statusValues ';
            }
        //else if(OpenClosedValue =='On Hold'){
            //searchQuery=searchQuery+' and Status  = \'On Hold\' ';
        //}
        
        // searchQuery=searchQuery.substring(0,searchQuery.length()-3); //remove last and
         searchQuery =searchQuery +' GROUP BY ';
         searchQuery =searchQuery +CALENDAR_MNTH_QTR;           
         searchQuery =searchQuery +' ORDER BY ';
         searchQuery =searchQuery +CALENDAR_MNTH_QTR;   
        
        System.debug('**searchQuery*'+searchQuery );    
        //AggregateResult[] groupedResults =Database.query(searchQuery);
        String[] dates;
        dates =FromDateValue.split('T')[0].split('-');
        Date actualFromDate = Date.newInstance(integer.valueof(dates[0]), integer.valueof(dates[1]), integer.valueof(dates[2]));
        dates =ToDateValue.split('T')[0].split('-');
        Date actualToDate = Date.newInstance(integer.valueof(dates[0]), integer.valueof(dates[1]), integer.valueof(dates[2]));
        Date tempFromDate = actualFromDate;
        Date tempToDate =actualFromDate.addMonths(3).toStartofMonth().addDays(-1);
        System.debug('**'+tempFromDate);
        System.debug('**'+tempToDate);

        List<String> searchQuery1 = new List<String>();
        if(tempToDate<actualToDate){
            do{
                String replaceFrom = String.valueOf(tempFromDate)+'T00:00:00Z';
                String replaceTo = String.valueOf(tempToDate)+'T23:59:59Z'; 
                String tempQuery =searchQuery.replace(FromDateValue,replaceFrom); 
                tempQuery =tempQuery.replace(ToDateValue,replaceTo); 
                searchQuery1.add(tempQuery);  
                tempFromDate = tempToDate.addDays(1);
                tempToDate =tempFromDate.addMonths(3).toStartofMonth().addDays(-1);
            }while(tempToDate<actualToDate);
            //last
            String replaceFrom = String.valueOf(tempFromDate)+'T00:00:00Z';
            String replaceTo = String.valueOf(actualToDate)+'T23:59:59Z';
            String tempQuery =searchQuery.replace(FromDateValue,replaceFrom); 
            tempQuery =tempQuery.replace(ToDateValue,replaceTo); 
            searchQuery1.add(tempQuery);  
        }
        else{
            searchQuery1.add(searchQuery);
        }
        List<AggregateResult> groupedResults = new List<AggregateResult>();
       
        for(String q:searchQuery1){
            for(AggregateResult results :Database.query(q)){
                groupedResults.add(results);
            }           
            
            }
            //AggregateResult[] groupedResults =Database.query(searchQuery1[0]);
            System.debug('**groupedResults *'+groupedResults );
            for(AggregateResult groupedResult: groupedResults ){
                String stringMonth='';          
                if(TrendValue=='By Month' && showLinechart)
               stringMonth= getMonth(groupedResult.get('expr2'),groupedResult.get('expr3'),'Month');//year, month
               else if(TrendValue=='By Month' && !showLinechart)
               stringMonth= getMonth(groupedResult.get('expr1'),groupedResult.get('expr2'),'Month');//year, month
               
                if(TrendValue=='By Quarter' && showLinechart)
                 stringMonth= getMonth(groupedResult.get('expr2'),groupedResult.get('expr3'),'Quarter');//year, month
               else if(TrendValue=='By Quarter' && !showLinechart)
               stringMonth= getMonth(groupedResult.get('expr1'),groupedResult.get('expr2'),'Quarter');//year, month
                 
               Integer count = (Integer) groupedResult.get('expr0');
               Decimal lineValue =0.0;
               String year='';
               String month='';
               if(showLinechart)
               {
                    year =string.valueof(groupedResult.get('expr2'));
                    month =string.valueof(groupedResult.get('expr3'));
                    if(month.length()==1)
                    month ='0'+month;
               }
               else
               {
                   year =string.valueof(groupedResult.get('expr1'));
                   month =string.valueof(groupedResult.get('expr2'));
                   if(month.length()==1)
                    month ='0'+month;
               }
               String mapKey =year+month;
               Integer k1 =integer.valueof(mapKey);
               if(showLinechart){
                   lineValue =(Decimal) groupedResult.get('expr1');
                   //dataList.add(new Data(stringMonth,count,lineValue )); 
                    if(dataMap.containsKey(k1)){
                        Data d = dataMap.get(k1);                       
                        dataMap.put(k1,new Data(stringMonth,count+d.barChartValue,lineValue+d.lineChartValue));
                    }
                   else
                    dataMap.put(k1,new Data(stringMonth,count,lineValue));
                   }
               else{
                   //dataList.add(new Data(stringMonth,count,lineValue ));
                   if(dataMap.containsKey(k1)){
                        Data d = dataMap.get(k1);                       
                        dataMap.put(k1,new Data(stringMonth,count+d.barChartValue,lineValue+d.lineChartValue));
                    }
                   else
                    dataMap.put(k1,new Data(stringMonth,count,lineValue));
                   }
               //dataList.add(new Data(stringMonth,count,0));            
            }
        
        System.debug('**'+dataList);
        System.debug('dataMap**'+dataMap);
        //return dataList;
        return dataMap.values();        
    
    }
    //NSS case Data
    @RemoteAction
    public static List<NSSData>caseNSSSearch(String ActivityValue,String OtherCasemetrics,String SBU,String OpenClosedValue,String Enterprise,String Region,String AircraftType,String AccountName,String OEM,String PartNumber,String FromDateValue,String ToDateValue,String TrendValue,String Age,String ageMin,String ageMax){
        system.debug('***in case NSS search');
        List<NSSData> dataList = new List<NSSData>();
       
        dataMap.clear();
        String CALENDAR_MNTH_QTR='';
        String searchQuery ='SELECT Id ';
        
        if(TrendValue =='By Month'){            
            CALENDAR_MNTH_QTR='CALENDAR_YEAR(CreatedDate),CALENDAR_MONTH(CreatedDate)';
        }       
        else if(TrendValue =='By Quarter'){
            CALENDAR_MNTH_QTR='CALENDAR_YEAR(CreatedDate),CALENDAR_QUARTER(CreatedDate)';
        }
        
        searchQuery = searchQuery+' FROM Case where RecordTypeId =\'01230000000ZJvU\' and';
       
       if(FromDateValue!=null && FromDateValue!='')
        {
            if(OpenClosedValue == 'Open' || OpenClosedValue == 'On Hold')
                searchQuery=searchQuery+' CreatedDate>='+FromDateValue+' and';
            else if(OpenClosedValue == 'Closed')
                searchQuery=searchQuery+' ClosedDate>='+FromDateValue+' and';                
        } 
        if(ToDateValue!=null && ToDateValue!='')
        {
            if(OpenClosedValue == 'Open' || OpenClosedValue == 'On Hold')
                searchQuery=searchQuery+' CreatedDate<='+ToDateValue+' and';
            else if(OpenClosedValue == 'Closed')
                searchQuery=searchQuery+' ClosedDate<='+ToDateValue+' and';                
        }
        
        if(OtherCasemetrics =='First Call Resolution')
        searchQuery =searchQuery +' CSM_Senior_Escalation__c = True and';
        
        
        if(SBU!=null && SBU!='' && SBU!='All')
            searchQuery=searchQuery+' SBU_w2c__c=\''+SBU+'\' and';
        
            
        if(Enterprise!=null && Enterprise!='' && Enterprise !='All')
            searchQuery=searchQuery+' Enterprise__c=\''+Enterprise+'\' and';    
        
        if(Region!=null && Region!='' && Region!='Global'){
            if(Region=='APAC')
                searchQuery=searchQuery+' Region__c = \'Asia/Pacific Rim\' and';
            if(Region=='EMAI')
                searchQuery=searchQuery+' Region__c = \'Europe/MiddleEast/Africa/India\' and';
            if(Region=='Americas')
                searchQuery=searchQuery+' Region__c = \'Americas\' and';
        }
        if(AircraftType!=null && AircraftType!='' && AircraftType!='000000000000000')
            searchQuery=searchQuery+' Aircraft_Type__c=\''+AircraftType+'\' and';
        if(AccountName!=null && AccountName!='' && AccountName!='000000000000000')
            searchQuery=searchQuery+' Account_Name__c=\''+AccountName+'\' and';
        
        if(OEM!=null && OEM!='')
            searchQuery=searchQuery+' Aircraft_Type__r.OEM_Name__r.Name LIKE \'%'+OEM+'%\' and';
        
        if(PartNumber!=null && PartNumber!='')
            searchQuery=searchQuery+' Product_Part_Number__c =\''+PartNumber+'\' and';
            
        if(Age=='Yes' && ageMin!=null && ageMin!='' && ageMax!=null && ageMax!='')
        {
            if(OpenClosedValue == 'Closed')
            {                
                    searchQuery=searchQuery+' Age_Custom_in_Hours__c >= '+ageMin+' and Age_Custom_in_Hours__c <= '+ageMax+' and'; 
            }
            else if(OpenClosedValue == 'Open' || OpenClosedValue == 'On Hold'){             
                searchQuery=searchQuery+' Age_in_Hours__c >= '+ageMin+' and Age_in_Hours__c <= '+ageMax+' and'; 
            }
        }
            
         if(ActivityValue.contains('ATS'))
         searchQuery =searchQuery + ' OwnerId__r.Manager.ATS__c=true';
         if(ActivityValue.contains('DTS'))
         searchQuery =searchQuery + ' OwnerId__r.Manager.DTS__c=true';
         List<String> statusValues;    
        if(OpenClosedValue =='Open'){
            statusValues = new List<String>{'Open','Re-Open','On Hold'};
            searchQuery=searchQuery+' and Status in: statusValues ';
            }
        else if(OpenClosedValue =='Closed'){
            statusValues = new List<String>{'Done','Re-Closed','Tech Issue-SR Assigned','Discard','Cancelled','Propose to Close', 'Close-No Response', 'Closed – approved'};
            searchQuery=searchQuery+' and Status  in: statusValues ';
            }
        //else if(OpenClosedValue =='On Hold'){
            //searchQuery=searchQuery+' and Status  = \'On Hold\' ';
        //}
        
        // searchQuery=searchQuery.substring(0,searchQuery.length()-3); //remove last and
         
        
        System.debug('**searchQuery*'+searchQuery );  
        List<Id> caseIds = new List<Id>();      
        for(Case selectedCase : Database.query(searchQuery)){
            caseIds.add(selectedCase.Id);
        }
        System.debug('caseIds**'+caseIds);
        String q ='select count(Id),SUM(OS_Promoter__c),SUM(OS_Detractor__c),SUM(NPS_Promoter_Score__c),SUM(NPS_Detractor_Score__c),'+CALENDAR_MNTH_QTR;
        q = q+' FROM Feedback__c where Case__c in: caseIds ';
        q=q+' GROUP BY '+CALENDAR_MNTH_QTR+' ORDER BY '+CALENDAR_MNTH_QTR;
        
        AggregateResult[] groupedResults =Database.query(q);
            //AggregateResult[] groupedResults =Database.query(searchQuery1[0]);
            System.debug('**groupedResults *'+groupedResults );
            for(AggregateResult groupedResult: groupedResults ){
                String stringMonth='';          
                if(TrendValue=='By Month')
                    stringMonth= getMonth(groupedResult.get('expr5'),groupedResult.get('expr6'),'Month');//year, month
                if(TrendValue=='By Quarter')
                    stringMonth= getMonth(groupedResult.get('expr5'),groupedResult.get('expr6'),'Quarter');//year, month
              
               Integer count = (Integer) groupedResult.get('expr0');
               Decimal barValue1 =0.0;
               Decimal barValue2 =0.0;
               String year='';
               String month='';
               
                    year =string.valueof(groupedResult.get('expr5'));
                    month =string.valueof(groupedResult.get('expr6'));
               
              
                   barValue1 =math.abs(((Decimal) groupedResult.get('expr1')/count)-((Decimal) groupedResult.get('expr2')/count));
                   barValue2 =math.abs(((Decimal) groupedResult.get('expr3')/count)-((Decimal) groupedResult.get('expr4')/count));
                   dataList.add(new NSSData(stringMonth,barValue1*100,barValue2*100,count));            
            }
        
        System.debug('**'+dataList);        
        return dataList;
       
    }
    //SR Data
    @RemoteAction
    public static List<Data> SRSearch(String SBU,String OpenClosedValue,String Enterprise,String Region,String AircraftType,String AccountName,String OEM,String PartNumber,String FromDateValue,String ToDateValue,String TrendValue,String ResolutionTime,String Age,String AgeBuckets,boolean calledFromBoth ) { 
        Set<String> SRIdList = new Set<String>();
        Decimal averageSum =0;
        System.debug('**OEM **'+OEM);
        if(OEM!=null && OEM!='' && OEM!='000000000000000' && OEM!='null'){    
            system.debug('in if **');        
            List<Key_Affected_OEMs_Operators__c> keyList =[SELECT Service_Request__c FROM Key_Affected_OEMs_Operators__c where account_name__c =:OEM and Service_Request__c!=null ];
            System.debug('**keyList '+keyList );
            for(Key_Affected_OEMs_Operators__c key : keyList){
                SRIdList.add(key.Service_Request__c);
            }
        }
        System.debug('**srid'+SRIdList);
        boolean showLinechart=false;
        if(ResolutionTime =='Yes' || Age =='Yes'){
            showLinechart=true;
            
        }
        List<Data> dataList = new List<Data>();
        dataMap.clear();
        
        String CALENDAR_MNTH_QTR='';
        String searchQuery ='SELECT count(Id) ,';
        if(OpenClosedValue =='Closed' && ResolutionTime =='Yes')
        searchQuery =searchQuery +'AVG(SR_age_w_o_Monitor_time__c) ,';
       
        if(Age =='Yes' && OpenClosedValue == 'Closed')
        searchQuery =searchQuery +'AVG(SR_age_w_o_Monitor_time__c) ,';
        if(Age =='Yes' && (OpenClosedValue == 'Open' || OpenClosedValue == 'Monitor'))
        searchQuery =searchQuery +'AVG(Open_SR_Age__c) ,';
        
        if(TrendValue =='By Month' && OpenClosedValue == 'Open'){
            searchQuery=searchQuery+'CALENDAR_YEAR(CreatedDate),CALENDAR_MONTH(CreatedDate)';
            CALENDAR_MNTH_QTR='CALENDAR_YEAR(CreatedDate),CALENDAR_MONTH(CreatedDate)';
        }
        else if(TrendValue =='By Month' && OpenClosedValue == 'Closed'){
            searchQuery=searchQuery+'CALENDAR_YEAR(Date_Closed__c),CALENDAR_MONTH(Date_Closed__c)';
            CALENDAR_MNTH_QTR='CALENDAR_YEAR(Date_Closed__c),CALENDAR_MONTH(Date_Closed__c)';
        }
        else if(TrendValue =='By Month' && OpenClosedValue == 'Monitor'){
            searchQuery=searchQuery+'CALENDAR_YEAR(CreatedDate),CALENDAR_MONTH(CreatedDate)';   
            CALENDAR_MNTH_QTR='CALENDAR_YEAR(CreatedDate),CALENDAR_MONTH(CreatedDate)';
        }   
        else if(TrendValue =='By Quarter' && OpenClosedValue == 'Open'){
            searchQuery= searchQuery+'CALENDAR_YEAR(CreatedDate),CALENDAR_QUARTER(CreatedDate)';
            CALENDAR_MNTH_QTR='CALENDAR_YEAR(CreatedDate),CALENDAR_QUARTER(CreatedDate)';
        }
        else if(TrendValue =='By Quarter' && OpenClosedValue == 'Closed'){
            searchQuery= searchQuery+'CALENDAR_YEAR(Date_Closed__c),CALENDAR_QUARTER(Date_Closed__c)';
            CALENDAR_MNTH_QTR='CALENDAR_YEAR(Date_Closed__c),CALENDAR_QUARTER(Date_Closed__c)';
        }
        else if(TrendValue =='By Quarter' && OpenClosedValue == 'Monitor'){
            searchQuery= searchQuery+'CALENDAR_YEAR(CreatedDate),CALENDAR_QUARTER(CreatedDate)';
            CALENDAR_MNTH_QTR='CALENDAR_YEAR(CreatedDate),CALENDAR_QUARTER(CreatedDate)';   
        }
        if(OpenClosedValue =='Closed' && ResolutionTime =='Yes')
        searchQuery =searchQuery +',SUM(SR_age_w_o_Monitor_time__c) ';
       
        if(Age =='Yes' && OpenClosedValue == 'Closed')
        searchQuery =searchQuery +',SUM(SR_age_w_o_Monitor_time__c) ';
        
        if(Age =='Yes' && (OpenClosedValue == 'Open' || OpenClosedValue == 'Monitor'))
        searchQuery =searchQuery +',SUM(Open_SR_Age__c) ';  
        
        searchQuery = searchQuery+' FROM Service_Request__c where ';
        if(OEM!=null && OEM!='' && OEM!='000000000000000' && OEM!='null'){ 
            searchQuery = searchQuery+' ID in:SRIdList and';
        }
        if(FromDateValue!=null && FromDateValue!='')
        {
            if(OpenClosedValue == 'Open')
                searchQuery=searchQuery+' CreatedDate>='+FromDateValue+' and';
            else if(OpenClosedValue == 'Closed')
                searchQuery=searchQuery+' Date_Closed__c>='+FromDateValue+' and';
            else if(OpenClosedValue == 'Monitor')
                searchQuery=searchQuery+' CreatedDate>='+FromDateValue+' and';     
        } 
        if(ToDateValue!=null && ToDateValue!='')
        {
            if(OpenClosedValue == 'Open')
                searchQuery=searchQuery+' CreatedDate<='+ToDateValue+' and';
            else if(OpenClosedValue == 'Closed')
                searchQuery=searchQuery+' Date_Closed__c<='+ToDateValue+' and';
            else if(OpenClosedValue == 'Monitor')
                searchQuery=searchQuery+' CreatedDate<='+ToDateValue+' and';       
        }   
        searchQuery = searchQuery+'(NOT Complexity_Level__c Like \'%5-IPDS%\') and'; // Added to Exclude complexity Level 5
        if(OpenClosedValue != 'Both')
            searchQuery=searchQuery+' Status__c=\''+OpenClosedValue+'\' and';
        if(SBU!=null && SBU!='' && SBU!='All')
            searchQuery=searchQuery+' SR_SBU__c=\''+SBU+'\' and';
        if(Enterprise!=null && Enterprise!='' && Enterprise!='All')
            searchQuery=searchQuery+' Enterprise__c=\''+Enterprise+'\' and'; 
        if(Region!=null && Region!='' && Region!='Global')
            searchQuery=searchQuery+' Region__c includes (\''+Region+'\') and';  
        if(AircraftType!=null && AircraftType!='' && AircraftType!='000000000000000')
            searchQuery=searchQuery+' Aircraft_Type__c=\''+AircraftType+'\' and';
        if(AccountName!=null && AccountName!='' && AccountName!='000000000000000')
            searchQuery=searchQuery+' Account_Name__c=\''+AccountName+'\' and';
        
        if(PartNumber!=null && PartNumber!='')
            searchQuery=searchQuery+' Product_Number__c=\''+PartNumber+'\' and ';
        if(AgeBuckets!=null && AgeBuckets=='Yes')
        {           
            dataList = calculateAgeBucket('SR',searchQuery,OpenClosedValue,'');
            return dataList;
        }
            
        
            searchQuery =searchQuery + ' OwnerId__r.Manager.EPS__c=true';
        // searchQuery=searchQuery.substring(0,searchQuery.length()-3); //remove last and
         searchQuery =searchQuery +' GROUP BY ';
         searchQuery =searchQuery +CALENDAR_MNTH_QTR;           
         searchQuery =searchQuery +' ORDER BY ';
         searchQuery =searchQuery +CALENDAR_MNTH_QTR;
        
        System.debug('**searchQuery*'+searchQuery );    
        ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.INFO, searchQuery));
        AggregateResult[] groupedResults =Database.query(searchQuery);
        String stringMonth='';
        System.debug('**groupedResults *'+groupedResults );
        averageSum =0;
        for(AggregateResult groupedResult: groupedResults ){
            System.debug('**groupedResult*'+groupedResult);
                if(TrendValue=='By Month' && showLinechart)
               stringMonth= getMonth(groupedResult.get('expr2'),groupedResult.get('expr3'),'Month');//year, month
               else if(TrendValue=='By Month' && !showLinechart)
               stringMonth= getMonth(groupedResult.get('expr1'),groupedResult.get('expr2'),'Month');//year, month
               
                if(TrendValue=='By Quarter' && showLinechart)
                 stringMonth= getMonth(groupedResult.get('expr2'),groupedResult.get('expr3'),'Quarter');//year, month
               else if(TrendValue=='By Quarter' && !showLinechart)
               stringMonth= getMonth(groupedResult.get('expr1'),groupedResult.get('expr2'),'Quarter');//year, month
                 
               Integer count = (Integer) groupedResult.get('expr0');
               Decimal lineValue =0.0;
               String year='';
               String month='';
               if(showLinechart)
               {
                    year =string.valueof(groupedResult.get('expr2'));
                    month =string.valueof(groupedResult.get('expr3'));
                    if(month.length()==1)
                    month ='0'+month;
               }
               else
               {
                   year =string.valueof(groupedResult.get('expr1'));
                   month =string.valueof(groupedResult.get('expr2'));
                   if(month.length()==1)
                    month ='0'+month;
               }
               String mapKey =year+month;
               Integer k1 =integer.valueof(mapKey);
               if(showLinechart){
                   lineValue =(Decimal) groupedResult.get('expr1');
                   dataList.add(new Data(stringMonth,count,lineValue ));
                   dataMap.put(k1,new Data(stringMonth,count,lineValue));
                   if(!calledFromBoth)
                   averageSum = averageSum + (Decimal) groupedResult.get('expr4');
                   }
               else{
                   dataList.add(new Data(stringMonth,count,lineValue ));
                   dataMap.put(k1,new Data(stringMonth,count,lineValue ));
                   }
        }
        System.debug('**'+dataList);
        System.debug('dataMap**'+dataMap);
        if(!calledFromBoth){
            Integer openSRCount =0;
            AggregateResult[] groupedResults1  =Database.query('SELECT count(Id) FROM Service_Request__c where  CreatedDate>'+FromDateValue+' and OwnerId__r.Manager.EPS__c=true');
            if(groupedResults1!=null && groupedResults1.size()==1){
                openSRCount= (Integer)groupedResults1[0].get('expr0');
                System.debug('**'+openSRCount);
            }
            dataList.add(new Data('',openSRCount,0 ));
            dataList.add(new Data('',0,averageSum));
        }
       // dataList.add(new Data('',0,averageSum));
        System.debug('**averageSum '+averageSum ); 
        return dataList;        
        
    }
    //SR Data SRBothSearch
    @RemoteAction
    public static MAP<Integer,DataBoth> SRBothSearch(String SBU,String OpenClosedValue,String Enterprise,String Region,String AircraftType,String AccountName,String OEM,String PartNumber,String FromDateValue,String ToDateValue,String TrendValue,String ResolutionTime,String Age,String AgeBuckets ) { 
        String useList='';
        List<Data> dataList1 = new List<Data>();
        List<Data> dataList2 = new List<Data>();
        Data[] dataList3= new Data[]{};
        MAP<Integer,DataBoth> dataMap3 = new MAP<Integer,DataBoth>();
        //MAP<Integer,DataBoth> dataMap4 = new MAP<Integer,DataBoth>();
        dataList1 = SRSearch(SBU,'Open',Enterprise,Region,AircraftType,AccountName,OEM,PartNumber,FromDateValue,ToDateValue,TrendValue,ResolutionTime,Age,AgeBuckets,true );
        MAP<Integer,Data> dataMap1=new MAP<Integer,Data>(dataMap);
        dataList2 = SRSearch(SBU,'Closed',Enterprise,Region,AircraftType,AccountName,OEM,PartNumber,FromDateValue,ToDateValue,TrendValue,ResolutionTime,Age,AgeBuckets,true );
        MAP<Integer,Data> dataMap2=new MAP<Integer,Data>(dataMap);
        dataMap.clear();
        
        for(Integer k:dataMap1.keySet()){
            if(dataMap2.containsKey(k)){
                Data d1 = dataMap1.get(k);
                Data d2 = dataMap2.get(k);
                DataBoth d3 = new DataBoth(d1.xAxisName,d1.barChartValue,d2.barChartValue,d1.lineChartValue,d2.lineChartValue);
                dataMap3.put(k,d3);
            }
            else{
                Data d1 = dataMap1.get(k);              
                DataBoth d3 = new DataBoth(d1.xAxisName,d1.barChartValue,0,d1.lineChartValue,0);
                dataMap3.put(k,d3);
            }
        
        }
        for(Integer k:dataMap2.keySet()){
            if(!dataMap3.containsKey(k)){
                Data d2 = dataMap2.get(k);              
                DataBoth d3 = new DataBoth(d2.xAxisName,0,d2.barChartValue,0,d2.lineChartValue);
                dataMap3.put(k,d3);
            }
        }
        System.debug('**'+dataList1);
        System.debug('**'+dataList1);
        System.debug('**'+dataMap3);       
       
        return dataMap3;        
        
    }
    @RemoteAction
    public static List<Data> PlannedMeetingSearch(String GTOGroup,String SBU,String OpenClosedValue,String AccountName,String FromDateValue,String ToDateValue,String TrendValue){
         
        System.debug('**'+GTOGroup);
        List<Data> dataList = new List<Data>();
        dataMap.clear();
        String CALENDAR_MNTH_QTR='';
        String searchQuery ='SELECT count(Id) ,';
        if(OpenClosedValue =='Completed')
        searchQuery =searchQuery +'SUM(Hours_Spent__c) ,';
        if(OpenClosedValue =='Expected')
        searchQuery =searchQuery +'SUM(Hours_Spent__c) ,';
        if(TrendValue =='By Month' && OpenClosedValue == 'Expected'){
            searchQuery=searchQuery+'CALENDAR_YEAR(Expected_Date__c),CALENDAR_MONTH(Expected_Date__c)';
            CALENDAR_MNTH_QTR='CALENDAR_YEAR(Expected_Date__c),CALENDAR_MONTH(Expected_Date__c)';
        }
        else if(TrendValue =='By Month' && OpenClosedValue == 'Completed'){
            searchQuery=searchQuery+'CALENDAR_YEAR(Completed_Date__c ),CALENDAR_MONTH(Completed_Date__c )';
            CALENDAR_MNTH_QTR='CALENDAR_YEAR(Completed_Date__c ),CALENDAR_MONTH(Completed_Date__c )';
        }        
        else if(TrendValue =='By Quarter' && OpenClosedValue == 'Expected'){
            searchQuery= searchQuery+'CALENDAR_YEAR(Expected_Date__c),CALENDAR_QUARTER(Expected_Date__c)';
            CALENDAR_MNTH_QTR='CALENDAR_YEAR(Expected_Date__c),CALENDAR_QUARTER(Expected_Date__c)';
        }
        else if(TrendValue =='By Quarter' && OpenClosedValue == 'Completed'){
            searchQuery= searchQuery+'CALENDAR_YEAR(Completed_Date__c ),CALENDAR_QUARTER(Completed_Date__c )';
            CALENDAR_MNTH_QTR='CALENDAR_YEAR(Completed_Date__c ),CALENDAR_QUARTER(Completed_Date__c )';
        }
                   
        searchQuery = searchQuery+' FROM Planned_Meeting__c where RecordTypeId = \'012a0000001ZMoQ\' and Owner_Name__r.Profile.Name like \'%GTO%\' and ';// Owner_Profile__c replaced with Owner_Name__r.Profile.Name
        
        if(OpenClosedValue == 'Expected')
                searchQuery=searchQuery+' Expected_Date__c!=null and';
        else if(OpenClosedValue == 'Completed')
                searchQuery=searchQuery+' Completed_Date__c!=null and';
                
        if(FromDateValue!=null && FromDateValue!='')
        {
            if(OpenClosedValue == 'Expected')
                searchQuery=searchQuery+' Expected_Date__c>='+FromDateValue.split('T')[0]+' and';
            else if(OpenClosedValue == 'Completed')
                searchQuery=searchQuery+' Completed_Date__c>='+FromDateValue.split('T')[0]+' and';
                
        } 
        if(ToDateValue!=null && ToDateValue!='')
        {
            if(OpenClosedValue == 'Expected')
                searchQuery=searchQuery+' Expected_Date__c<='+ToDateValue.split('T')[0]+' and';
            else if(OpenClosedValue == 'Completed')
                searchQuery=searchQuery+' Completed_Date__c<='+ToDateValue.split('T')[0]+' and';
                  
        }   
        //if(OpenClosedValue != 'Both')
        //    searchQuery=searchQuery+' Status__c=\''+OpenClosedValue+'\' and';
        if(SBU!=null && SBU!='' && SBU!='All')
            searchQuery=searchQuery+' AccountSBU__c=\''+SBU+'\' and';
        //if(Enterprise!=null && Enterprise!='' && Enterprise!='All')
         //   searchQuery=searchQuery+' Enterprise__c=\''+Enterprise+'\' and'; 
        
        //if(AircraftType!=null && AircraftType!='' && AircraftType!='000000000000000')
         //   searchQuery=searchQuery+' Aircraft_Type__c=\''+AircraftType+'\' and';
        if(AccountName!=null && AccountName!='' && AccountName!='000000000000000')
            searchQuery=searchQuery+' Account_Name__c=\''+AccountName+'\' and';        
        //if(PartNumber!=null && PartNumber!='')
        //    searchQuery=searchQuery+' Product_Number__c=\''+PartNumber+'\' and ';
        if(GTOGroup=='ATS')
            searchQuery =searchQuery + ' Owner_Name__r.Manager.ATS__c=true';
        if(GTOGroup=='DTS')
            searchQuery =searchQuery + ' Owner_Name__r.Manager.DTS__c=true';
        if(GTOGroup=='EPS')
            searchQuery =searchQuery + ' Owner_Name__r.Manager.EPS__c=true';
        if(GTOGroup=='ALL')    
            searchQuery=searchQuery.substring(0,searchQuery.length()-3); //remove last and
         searchQuery =searchQuery +' GROUP BY ';
         searchQuery =searchQuery +CALENDAR_MNTH_QTR;           
         searchQuery =searchQuery +' ORDER BY ';
         searchQuery =searchQuery +CALENDAR_MNTH_QTR;
        
        System.debug('**searchQuery*'+searchQuery );    
        ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.INFO, searchQuery));
        AggregateResult[] groupedResults =Database.query(searchQuery);
        String stringMonth='';
        System.debug('**groupedResults *'+groupedResults );
        for(AggregateResult groupedResult: groupedResults ){
              Integer count =0;
              Decimal lineValue =0.0;
              String year='';
              String month='';
              if(TrendValue=='By Month')
               stringMonth= getMonth(groupedResult.get('expr2'),groupedResult.get('expr3'),'Month');//year, month
               if(TrendValue=='By Quarter')
               stringMonth= getMonth(groupedResult.get('expr2'),groupedResult.get('expr3'),'Quarter');//year, month
               
                 
               count = (Integer) groupedResult.get('expr0');              
              
               year =string.valueof(groupedResult.get('expr2'));
               month =string.valueof(groupedResult.get('expr3'));
               if(month.length()==1)
                    month ='0'+month;
               String mapKey =year+month;
               Integer k1 =integer.valueof(mapKey);
               
               if(groupedResult.get('expr1')!=null)
               lineValue =(Decimal) groupedResult.get('expr1');
              
               dataList.add(new Data(stringMonth,count,lineValue ));
               dataMap.put(k1,new Data(stringMonth,count,lineValue));
                   
              
            
        }
        System.debug('**'+dataList);        
        
        return dataList;
    }
    
    //PlannedMeeting Data PlannedMeetingBothSrch
    @RemoteAction
    public static MAP<Integer,DataBoth> PlannedMeetingBothSrch(String GTOGroup,String SBU,String OpenClosedValue,String AccNameId,String FromDateValue,String ToDateValue,String TrendValue) { 
        String useList='';
        List<Data> dataList1 = new List<Data>();
        List<Data> dataList2 = new List<Data>();
        Data[] dataList3= new Data[]{};
        MAP<Integer,DataBoth> dataMap3 = new MAP<Integer,DataBoth>();
        dataList1 = PlannedMeetingSearch(GTOGroup,SBU,'Expected',AccNameId,FromDateValue,ToDateValue,TrendValue);
        MAP<Integer,Data> dataMap1=new MAP<Integer,Data>(dataMap);
        dataList2 = PlannedMeetingSearch(GTOGroup,SBU,'Completed',AccNameId,FromDateValue,ToDateValue,TrendValue);
        MAP<Integer,Data> dataMap2=new MAP<Integer,Data>(dataMap);
        dataMap.clear();
        
        for(Integer k:dataMap1.keySet()){
            if(dataMap2.containsKey(k)){
                Data d1 = dataMap1.get(k);
                Data d2 = dataMap2.get(k);
                DataBoth d3 = new DataBoth(d1.xAxisName,d1.barChartValue,d2.barChartValue,d1.lineChartValue,d2.lineChartValue);
                dataMap3.put(k,d3);
            }
            else{
                Data d1 = dataMap1.get(k);              
                DataBoth d3 = new DataBoth(d1.xAxisName,d1.barChartValue,0,d1.lineChartValue,0);
                dataMap3.put(k,d3);
            }
        
        }
        for(Integer k:dataMap2.keySet()){
            if(!dataMap3.containsKey(k)){
                Data d2 = dataMap2.get(k);              
                DataBoth d3 = new DataBoth(d2.xAxisName,0,d2.barChartValue,0,d2.lineChartValue);
                dataMap3.put(k,d3);
            }
        }
        return dataMap3;        
        
    }
    
    
    public static String getMonth(Object exp0,Object exp1,String type){//year,month,trade
        Integer m =(Integer)exp1;
        Integer y =(Integer)exp0;
        String month = string.valueof(m); 
        String year = string.valueof(y);
        String stringMonth='';
        if(type == 'Month'){
            if(month=='1')
                stringMonth ='Jan '+year;
            else if(month=='2')
                stringMonth ='Feb '+year;
            else if(month=='3')
                stringMonth ='Mar '+year;
            else if(month=='4')
                stringMonth ='Apr '+year;
            else if(month=='5')
                stringMonth ='May '+year;
            else if(month=='6')
                stringMonth ='Jun '+year;
            else if(month=='7')
                stringMonth ='Jul '+year;
            else if(month=='8')
                stringMonth ='Aug '+year;
            else if(month=='9')
                stringMonth ='Sep '+year;
            else if(month=='10')
                stringMonth ='Oct '+year;
            else if(month=='11')
                stringMonth ='Nov '+year;
            else if(month=='12')
                stringMonth ='Dec '+year;      
        }
        else if(type == 'Quarter'){
            if(month=='1')
                stringMonth ='Q1 '+year;
            else if(month=='2')
                stringMonth ='Q2 '+year;
            else if(month=='3')
                stringMonth ='Q3 '+year;
            else if(month=='4')
                stringMonth ='Q4 '+year;
        
        }
        
        return stringMonth;   
    }
    
    public static List<Data> calculateAgeBucket(String activity,String searchQuery,String OpenClosedValue,String AgeBucketselected){
    system.debug('**calculateAgeBucket');
    List<String> searchQuery1 = new List<String>();
    List<Data> dataList = new List<Data>();
   
    if(activity =='SR'){
        searchQuery = searchQuery.substring(searchQuery.indexOf('FROM'));
        searchQuery ='SELECT count(Id) '+searchQuery;
        System.debug('---->'+searchQuery );
        searchQuery =searchQuery + ' OwnerId__r.Manager.EPS__c=true and ';
        
        if(OpenClosedValue =='Open' || OpenClosedValue == 'Monitor'){
        
            
            searchQuery1.add(searchQuery+ ' Open_SR_Age__c >= 1 and Open_SR_Age__c <= 30');
            searchQuery1.add(searchQuery+ ' Open_SR_Age__c >= 31 and Open_SR_Age__c <= 60');
            searchQuery1.add(searchQuery+ ' Open_SR_Age__c >= 61 and Open_SR_Age__c <= 90');
            searchQuery1.add(searchQuery+ ' Open_SR_Age__c >= 91 and Open_SR_Age__c <= 120');
            searchQuery1.add(searchQuery+ ' Open_SR_Age__c >= 121 and Open_SR_Age__c <= 365');
            searchQuery1.add(searchQuery+ ' Open_SR_Age__c >365');
            
        }
        if(OpenClosedValue =='Closed'){        
            
            searchQuery1.add(searchQuery+ ' SR_age_w_o_Monitor_time__c  >= 1 and SR_age_w_o_Monitor_time__c  <= 30');
            searchQuery1.add(searchQuery+ ' SR_age_w_o_Monitor_time__c  >= 31 and SR_age_w_o_Monitor_time__c  <= 60');
            searchQuery1.add(searchQuery+ ' SR_age_w_o_Monitor_time__c  >= 61 and SR_age_w_o_Monitor_time__c  <= 90');
            searchQuery1.add(searchQuery+ ' SR_age_w_o_Monitor_time__c  >= 91 and SR_age_w_o_Monitor_time__c  <= 120');
            searchQuery1.add(searchQuery+ ' SR_age_w_o_Monitor_time__c  >= 121 and SR_age_w_o_Monitor_time__c  <= 365');
            searchQuery1.add(searchQuery+ ' SR_age_w_o_Monitor_time__c  >365');
            
        }
    
    System.debug('**'+searchQuery1);
    if(searchQuery1.size()>0){
        
            for(Integer i =0;i<6;i++){
                    AggregateResult[] groupedResults =Database.query(searchQuery1[i]);
                    if(searchQuery1[i].contains('<= 30')){
                        Integer count = (Integer) groupedResults[0].get('expr0');
                        dataList.add(new Data('1-30',count,0.0 )); 
                         
                    }
                    if(searchQuery1[i].contains('<= 60')){
                        Integer count = (Integer) groupedResults[0].get('expr0');
                        dataList.add(new Data('31-60',count,0.0 ));  
                        
                    }
                    if(searchQuery1[i].contains('<= 90')){
                        Integer count = (Integer) groupedResults[0].get('expr0');
                        dataList.add(new Data('61-90',count,0.0 ));  
                        
                    }
                    if(searchQuery1[i].contains('<= 120')){
                        Integer count = (Integer) groupedResults[0].get('expr0');
                        dataList.add(new Data('91-120',count,0.0 ));  
                        
                    }
                    if(searchQuery1[i].contains('<= 365')){
                        Integer count = (Integer) groupedResults[0].get('expr0');
                        dataList.add(new Data('121-365',count,0.0 )); 
                         
                    }
                    if(searchQuery1[i].contains('>365')){
                        Integer count = (Integer) groupedResults[0].get('expr0');
                        dataList.add(new Data('366-more',count,0.0 )); 
                         
                    }
                
                }
        
        
    }
    dataList.add(new Data('',0,0.0 )); 
    system.debug('**dataListageb*'+dataList);
    }
    if(activity.contains('Cases')){
        List<String> statusValues;  
        System.debug(activity+':'+searchQuery+':'+OpenClosedValue+':'+AgeBucketselected);
        searchQuery = searchQuery.substring(searchQuery.indexOf('FROM'));
        searchQuery ='SELECT count(Id) '+searchQuery;
        if(OpenClosedValue =='Open'){
            statusValues = new List<String>{'Open','Re-Open','On Hold'};
            searchQuery=searchQuery+'  Status in: statusValues ';
            }
        else if(OpenClosedValue =='Closed'){
            statusValues = new List<String>{'Done','Re-Closed','Tech Issue-SR Assigned','Discard','Cancelled','Propose to Close', 'Close-No Response', 'Closed – approved'};
            searchQuery=searchQuery+'  Status  in: statusValues ';
            }
        //else if(OpenClosedValue =='On Hold'){
          //  searchQuery=searchQuery+'  Status  = \'On Hold\' ';
        //}
        if(activity.contains('ATS'))
            searchQuery =searchQuery + 'and OwnerId__r.Manager.ATS__c=true and';
        if(activity.contains('DTS'))
            searchQuery =searchQuery + 'and OwnerId__r.Manager.DTS__c=true and';
          
            
        if(OpenClosedValue =='Open' || OpenClosedValue == 'On Hold'){
            if(AgeBucketselected == 'Bucket1'){//<10,<20,<24,<72,<240        
                searchQuery1.add(searchQuery+ ' Age_in_Hours__c  >= 0 and Age_in_Hours__c  <= 10');
                searchQuery1.add(searchQuery+ ' Age_in_Hours__c  >= 0 and Age_in_Hours__c  <= 20');
                searchQuery1.add(searchQuery+ ' Age_in_Hours__c  >= 0 and Age_in_Hours__c  <= 24');
                searchQuery1.add(searchQuery+ ' Age_in_Hours__c  >= 0 and Age_in_Hours__c  <= 72');
                searchQuery1.add(searchQuery+ ' Age_in_Hours__c  >= 0 and Age_in_Hours__c  <= 240');    
            }
            if(AgeBucketselected == 'Bucket2'){//10-72,24-72,24-240,72-240         
                searchQuery1.add(searchQuery+ ' Age_in_Hours__c >= 10 and Age_in_Hours__c <= 72');
                searchQuery1.add(searchQuery+ ' Age_in_Hours__c >= 24 and Age_in_Hours__c <= 72');
                searchQuery1.add(searchQuery+ ' Age_in_Hours__c >= 24 and Age_in_Hours__c <= 240');
                searchQuery1.add(searchQuery+ ' Age_in_Hours__c >= 72 and Age_in_Hours__c <= 240');
            }
            if(AgeBucketselected == 'Bucket3'){//>10,>24,>72,>240       
                searchQuery1.add(searchQuery+ ' Age_in_Hours__c > 10');
                searchQuery1.add(searchQuery+ ' Age_in_Hours__c > 24');
                searchQuery1.add(searchQuery+ ' Age_in_Hours__c > 72');
                searchQuery1.add(searchQuery+ ' Age_in_Hours__c > 240');
            }
            
        }
        if(OpenClosedValue =='Closed'){        
            if(AgeBucketselected == 'Bucket1'){//<10,<20,<24,<72,<240
                searchQuery1.add(searchQuery+ ' Age_Custom_in_Hours__c  >= 0 and Age_Custom_in_Hours__c  <= 10');
                searchQuery1.add(searchQuery+ ' Age_Custom_in_Hours__c  >= 0 and Age_Custom_in_Hours__c  <= 20');
                searchQuery1.add(searchQuery+ ' Age_Custom_in_Hours__c  >= 0 and Age_Custom_in_Hours__c  <= 24');
                searchQuery1.add(searchQuery+ ' Age_Custom_in_Hours__c  >= 0 and Age_Custom_in_Hours__c  <= 72');
                searchQuery1.add(searchQuery+ ' Age_Custom_in_Hours__c  >= 0 and Age_Custom_in_Hours__c  <= 240');              
            }
            if(AgeBucketselected == 'Bucket2'){//10-72,24-72,24-240,72-240            
                searchQuery1.add(searchQuery+ ' Age_Custom_in_Hours__c >= 10 and Age_Custom_in_Hours__c <= 72');
                searchQuery1.add(searchQuery+ ' Age_Custom_in_Hours__c >= 24 and Age_Custom_in_Hours__c <= 72');
                searchQuery1.add(searchQuery+ ' Age_Custom_in_Hours__c >= 24 and Age_Custom_in_Hours__c <= 240');
                searchQuery1.add(searchQuery+ ' Age_Custom_in_Hours__c >= 72 and Age_Custom_in_Hours__c <= 240');
            }
            if(AgeBucketselected == 'Bucket3'){//>10,>24,>72,>240          
                searchQuery1.add(searchQuery+ ' Age_Custom_in_Hours__c > 10');
                searchQuery1.add(searchQuery+ ' Age_Custom_in_Hours__c > 24');
                searchQuery1.add(searchQuery+ ' Age_Custom_in_Hours__c > 72');
                searchQuery1.add(searchQuery+ ' Age_Custom_in_Hours__c > 240');
            }
        } 
        System.debug('**'+searchQuery1);
        if(searchQuery1.size()>0){        
            for(Integer i =0;i<searchQuery1.size();i++){
                AggregateResult[] groupedResults =Database.query(searchQuery1[i]);
                System.debug(groupedResults);
                if(AgeBucketselected == 'Bucket1'){//<10,<20,<24,<72,<240
                    if(searchQuery1[i].contains('>= 0') && searchQuery1[i].contains('<= 10')){
                        Integer count = (Integer) groupedResults[0].get('expr0');
                        dataList.add(new Data('<10',count,0.0 )); 
                       
                    }
                    if(searchQuery1[i].contains('>= 0') && searchQuery1[i].contains('<= 20')){
                        Integer count = (Integer) groupedResults[0].get('expr0');
                        dataList.add(new Data('<20',count,0.0 ));  
                        
                    }
                    if(searchQuery1[i].contains('>= 0') && searchQuery1[i].contains('<= 24') && !searchQuery1[i].contains('<= 240')){
                        Integer count = (Integer) groupedResults[0].get('expr0');
                        dataList.add(new Data('<24',count,0.0 ));  
                       
                    }
                    if(searchQuery1[i].contains('>= 0') && searchQuery1[i].contains('<= 72')){
                        Integer count = (Integer) groupedResults[0].get('expr0');
                        dataList.add(new Data('<72',count,0.0 ));    
                                              
                    }
                    if(searchQuery1[i].contains('>= 0') && searchQuery1[i].contains('<= 240')){
                        Integer count = (Integer) groupedResults[0].get('expr0');
                        dataList.add(new Data('<240',count,0.0 )); 
                                              
                    }
                }
                if(AgeBucketselected == 'Bucket2'){//10-72,24-72,24-240,72-240
                    if(searchQuery1[i].contains('>= 10') && searchQuery1[i].contains('<= 72')){
                        Integer count = (Integer) groupedResults[0].get('expr0');
                        dataList.add(new Data('10-72',count,0.0 )); 
                         
                    }
                    if(searchQuery1[i].contains('>= 24') && searchQuery1[i].contains('<= 72')){
                        Integer count = (Integer) groupedResults[0].get('expr0');
                        dataList.add(new Data('24-72',count,0.0 ));  
                       
                    }
                    if(searchQuery1[i].contains('>= 24') && searchQuery1[i].contains('<= 240')){
                        Integer count = (Integer) groupedResults[0].get('expr0');
                        dataList.add(new Data('24-240',count,0.0 ));  
                        
                    }
                    if(searchQuery1[i].contains('>= 72') && searchQuery1[i].contains('<= 240')){
                        Integer count = (Integer) groupedResults[0].get('expr0');
                        dataList.add(new Data('72-240',count,0.0 ));    
                                             
                    }
                    
                }
                if(AgeBucketselected == 'Bucket3'){//>10,>24,>72,>240 
                    if(searchQuery1[i].contains('> 10') ){
                        Integer count = (Integer) groupedResults[0].get('expr0');
                        dataList.add(new Data('>10',count,0.0 ));
                    }
                    if(searchQuery1[i].contains('> 24') && !searchQuery1[i].contains('> 240')){
                        Integer count = (Integer) groupedResults[0].get('expr0');
                        dataList.add(new Data('>24',count,0.0 ));
                    }
                    if(searchQuery1[i].contains('> 72')){
                        Integer count = (Integer) groupedResults[0].get('expr0');
                        dataList.add(new Data('>72',count,0.0 )); 
                    }
                    
                    if(searchQuery1[i].contains('> 240')){
                        Integer count = (Integer) groupedResults[0].get('expr0');
                        dataList.add(new Data('>240',count,0.0 )); 
                                               
                    }
                    
                    
                }
             }
        }
        system.debug('**dataList*'+dataList);
    }
    return dataList;

    }
    
    public class Data{
        String xAxisName;
        Integer barChartValue;
        Decimal lineChartValue;
        public Data(String name,Integer data1,Decimal data2){
            xAxisName =name;
            barChartValue=data1;
            lineChartValue =data2.setScale(2);
    
        }
    }
   
    
    public class DataBoth{
        String xAxisName;
        Integer openBarValue;
        Integer closedBarValue;
        Decimal openLineChartValue;
        Decimal closeLineChartValue;
        public DataBoth(String name,Integer data1,Integer data2,Decimal data3,Decimal data4){
            xAxisName =name;
            openBarValue=data1;
            closedBarValue=data2;
            openLineChartValue =data3.setScale(2);
            closeLineChartValue=data4.setScale(2);
    
        }
    }
    
    public class NSSData{
        String xAxisName;
        Decimal OSbarChartValue;
        Decimal NSSbarChartValue;
        Integer count;       
        public NSSData(String name,Decimal data1,Decimal data2,Integer data3){
            xAxisName =name;
            OSbarChartValue=data1.setScale(2);
            NSSbarChartValue=data2.setScale(2);
            count =data3;
            
    
        }
    }
   
}