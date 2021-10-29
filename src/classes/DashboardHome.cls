Global with sharing class DashboardHome{
    
    /* Misc */
    public Date AOG_Date { get; set; }
    
    /* AOG */
    public Map<Boolean,Integer> AOG_Count24Hrs { get; set; }
    public Map<Boolean,Integer> AOG_Count4Hrs { get; set; }
    public Map<Boolean,Integer> AOG_Count48Hrs { get; set; }
    public string colour{get;set;}
    /* SRD */
    //List<AggregateResult> SRs = new List<AggregateResult>();
    
    /* SPEX */
    public SPEX_DB_Home_cls spexObj = new SPEX_DB_Home_cls();
    String SelectedSBU;
    String strsbu = '';
    String scroll = 'true';
    //public List<Feedback__c> overall;
    public Id FeedID{get;set;}
    public integer RedcountATR=0;
    public integer YellowcountATR=0;
    public integer GreencountATR=0;
    public integer RedcountBGA=0;
    public integer YellowcountBGA=0;
    public integer GreencountBGA=0;
    public integer RedcountDS=0;
    public integer YellowcountDS=0;
    public integer GreencountDS=0;
    public Decimal Totalpercentage=0;
    public Decimal TotalpercentageATR=0;
    public Decimal TotalpercentageBGA=0;
    public Decimal TotalpercentageDS=0; 
    public Decimal TotalpercentageALL=0; 
    public boolean displayPopup {get; set;}   
    public transient List<feedback__c> Recorddetails=new List<feedback__c>();    
    public string TopSRAcc{get;set;}
    public string ATRVOCAcc{get;set;}
    public string Atrvocname{get;set;}
    public string var;
    public integer totalSR=0;
    public integer PastdueSR=0;
    public integer totalSRATR=0;
    public integer PastdueSRATR=0;
    public integer totalSRBGA=0;
    public integer PastdueSRBGA=0;
    public integer totalSRDS=0;
    public integer PastdueSRDS=0;
    public integer SRDSsize=0;
    public ID serRecTypeid; 
  
    public Map<String,list<Feedback__c>> mfeed=new Map<String,List<Feedback__c>>();    
    public Map<String,list<Feedback__c>> mfeedATR=new Map<String,List<Feedback__c>>();
    public Map<String,list<Feedback__c>> mfeedBGA=new Map<String,List<Feedback__c>>();
    public Map<String,list<Feedback__c>> mfeedDS=new Map<String,List<Feedback__c>>();
    public Map<String,boolean> VOCmapATR=new Map<String,boolean>();
    public map<string,integer> AccountSRCount=new map<string,integer>();
    public map<string,integer> SRMaxDaysCount=new map<string,integer>();
    public transient List<Feedback__c> feed1;
    public transient List<Feedback__c> VOCRectype;
    public transient List<Service_Request__c> Listofrequests;
    public static set<id> fid = new set<id>();
    public String filter3 {get;set;}
    //public String  scrollcomment{get;set;}
    public transient List<Feedback__c> scrollcom;
    public transient List<string> scrollcomment= new List<string>();
    public transient List<string> scrollcommentATR= new List<string>();
    public transient List<string> scrollcommentBGA= new List<string>();
    public transient List<string> scrollcommentDS= new List<string>();
    public Map<Id,boolean> feebackMap{get;set;} 
    Decimal eachRanking= 0;
    public Map<String,string> logoimgmap=new Map<String,string>();   
   
    public DashboardHome(){
     
    feebackMap = new Map<Id,boolean>();
    //public Integer prodCatgry;

              
                map<string,map<string,integer>> accMap=new map<string,map<string,integer>>();
                
        scroll = System.currentPageReference().getParameters().get('scroll');
        
        Schema.DescribeSObjectResult FeedObj = Schema.SObjectType.Feedback__c;
        Map<String,Schema.RecordTypeInfo> feedrtMapByName = FeedObj.getRecordTypeInfosByName();
        Schema.RecordTypeInfo feedrtByName =  feedrtMapByName.get('Customer Rating');
        ID feedRecTypeid =  feedrtByName.getRecordTypeId();
        
        scrollcom=[SELECT Lastmodifieddate ,Additional_Comments__c,Account_SBU__c  FROM Feedback__c  where  FeedbackRecordType__c in ('ATR_VOC', 'Customer_Rating') Order By Lastmodifieddate DESC ];
        if(scrollcom.size()>0)
        {
            for(Feedback__c f:scrollcom)
            {
                if((f.Account_SBU__c == 'ATR') ||  (f.Account_SBU__c == 'BGA') || (f.Account_SBU__c == 'D&S'))
                {
                    
                    scrollcomment.add(f.Additional_Comments__c);
                }
                if(f.Account_SBU__c == 'ATR')
                {
                    scrollcommentATR.add(f.Additional_Comments__c);
                }
                if(f.Account_SBU__c == 'BGA')
                {
                    scrollcommentBGA.add(f.Additional_Comments__c);
                }
                if(f.Account_SBU__c == 'D&S')
                {
                    scrollcommentDS.add(f.Additional_Comments__c);
                }
            }
        }
        List<Feedback__c> feed=[SELECT id,COSM_Score__c,Account__r.id,Field_for_Weighting__c,Aggregate_Scoring__c,Name,Platform__r.Name,Site__c,Responsiveness_Customers_Rating__c,Development_Root_Cause_Context__c,Development_Program_Customer_Rating__c,Additional_Comments__c ,Reliability_Root_Cause_Context__c,Delivery_Customer_Rating_CRD__c,Delivery_Customer_Rating_color_CRD__c,Delivery_Customer_Rating_Indicator_CRD__c,Delivery_Root_Cause_Context__c,AOG_Customer_Rating_Feedback__c,Service_Support_Rating_Color_Indicator__c,Ranking__c,AOG_Customer_Rating__c,AOG_Customer_Rating_Color_Indicator__c,AOG_Customer_Rating_Color__c,Repairs_Perf_Rating_Color_Indicator__c,Spares_Perf_Rating_Color_Indicator__c,Reliability_Rating_Color_Indicator__c,Quality_Rating_Color_Indicator__c,Ease_of_Doing_Business_Rating_Color__c,Cost_Rating_Color_Indicator__c,Documentation_Rating_Color__c,Development_Program_Rating_Color__c,Cost_Rating_Color__c,Communication_Rating_Color__c,Quality_Rating_Color__c,Comments__c,Quarter__c,Year__c,Overall_Rating__c,Overall_Rating_Color__c,Warranty_Customer_Rating__c,Warranty_Rating_Color__c,Spares_Perf_Rating_Color__c,Service_Support_Rating_Color__c,Responsiveness_Rating_Color__c,Repairs_Perf_Rating_Color__c,Product_Category__c,Compliance_Rating_Color__c,Reliability_Rating_Color__c,Include_on_Customer_Rating_Dashboard__c,Account_SBU__c,Account_Name__c,Account__c FROM Feedback__c where recordtypeid=:feedRecTypeid ];
        
           
   list<StaticResource> sr1=[SELECT Name FROM StaticResource WHERE Name LIKE 'Acc%'];
   set<string> logonames= new set<string>();
   if(sr1.size()>0)
   {
       for(staticResource s:sr1)
       {
       logonames.add(s.name);
       }
   }
   for(Feedback__c f:feed)
   {
   string Accid=f.Account__r.id;
   System.debug('ACCID:'+Accid);
   if(Accid!=null)
   {
   string Accid15='Acc'+Accid.substring(0, 15);
   System.debug('ACCID:'+Accid15);
   if(logonames.contains(Accid15))  
   logoimgmap.put(f.Account_Name__c,Accid15);
   else
   logoimgmap.put(f.Account_Name__c,'stop');
   }
   }

        
        
        
        
        for(Feedback__c f:feed)
        {
            if(f.Include_on_Customer_Rating_Dashboard__c==true)
            {
                if(((f.Account_SBU__c == 'ATR') ||  (f.Account_SBU__c == 'BGA') || (f.Account_SBU__c == 'D&S') )&& f.Aggregate_Scoring__c == true )
                {
                    Totalpercentage= (Totalpercentage + f.COSM_Score__c) ;
                    
                }
                if(f.Account_SBU__c == 'ATR' && f.Aggregate_Scoring__c == true )
                {
                    TotalpercentageATR= (TotalpercentageATR + f.COSM_Score__c) ;
                    
                }
                
                if (f.Account_SBU__c == 'BGA' && f.Aggregate_Scoring__c == true )
                {
                    TotalpercentageBGA= (TotalpercentageBGA + f.COSM_Score__c);
                    
                }
                if (f.Account_SBU__c == 'D&S' && f.Aggregate_Scoring__c == true)
                {
                    TotalpercentageDS= (TotalpercentageDS+ f.COSM_Score__c);
                    
                } 
            }        
        }
        for(Feedback__c f:feed)
        {
            if(f.Include_on_Customer_Rating_Dashboard__c==true)
            {
                if(f.Account_SBU__c == 'ATR')
                {
                    if(f.Overall_Rating_Color__c == 'Red')
                    {
                        RedcountATR=RedcountATR+1 ;
                    }
                    if(f.Overall_Rating_Color__c == 'Yellow')
                    {
                        YellowcountATR=YellowcountATR+1 ;
                    }
                    if(f.Overall_Rating_Color__c == 'Green')
                    {
                        GreencountATR=GreencountATR+1;
                    }                  
                }
                else if(f.Account_SBU__c == 'BGA')
                {
                    if(f.Overall_Rating_Color__c == 'Red')
                    {
                        RedcountBGA=RedcountBGA+1 ;
                    }
                    if(f.Overall_Rating_Color__c == 'Yellow')
                    {
                        YellowcountBGA=YellowcountBGA+1 ;
                    }
                    if(f.Overall_Rating_Color__c == 'Green')
                    {
                        GreencountBGA=GreencountBGA+1;
                    }
                }
                else if(f.Account_SBU__c == 'D&S')
                {
                    if(f.Overall_Rating_Color__c == 'Red')
                    {
                        RedcountDS=RedcountDS+1 ;
                    }
                    if(f.Overall_Rating_Color__c == 'Yellow')
                    {
                        YellowcountDS=YellowcountDS+1 ;
                    }
                    if(f.Overall_Rating_Color__c == 'Green')
                    {
                        GreencountDS=GreencountDS+1;
                    }
                }
            }
        }
        
        
        
        if(feed.size()>0)
        {
            for(Feedback__c f:feed)
            {
                if(f.Include_on_Customer_Rating_Dashboard__c==true && ((f.Account_SBU__c=='ATR')|| (f.Account_SBU__c=='BGA') || (f.Account_SBU__c=='D&S') ))
                {
                    if(!mfeed.containsKey(f.Account_Name__c))
                        mfeed.put(f.Account_Name__c,new List<Feedback__c>{f});
                    else
                        mfeed.get(f.Account_Name__c).add(f);//add(f)=> adds one more record, without inserting duplicate
                }
            }
        }
        
        
        if(feed.size()>0)
        {
            for(Feedback__c f:feed)
            {
                if(f.Include_on_Customer_Rating_Dashboard__c==true && f.Account_SBU__c=='ATR' )
                {
                    if(!mfeedATR.containsKey(f.Account_Name__c))
                        mfeedATR.put(f.Account_Name__c,new List<Feedback__c>{f});
                    else
                        mfeedATR.get(f.Account_Name__c).add(f);//add(f)=> adds one more record, without inserting duplicate
                }
            }
            
        }
        
       
        
        if(feed.size()>0)
        {
            for(Feedback__c f:feed)
            {
                system.debug('### Feed back values'+f.Account_SBU__c); 
                if(f.Include_on_Customer_Rating_Dashboard__c==true && f.Account_SBU__c=='BGA' )
                {
                    if(!mfeedBGA.containsKey(f.Account_Name__c))
                        mfeedBGA.put(f.Account_Name__c,new List<Feedback__c>{f});
                    else
                        mfeedBGA.get(f.Account_Name__c).add(f);//add(f)=> adds one more record, without inserting duplicate
                }
                
            }
        }
        
        if(feed.size()>0)
        {
            for(Feedback__c f:feed)
            {
                if(f.Include_on_Customer_Rating_Dashboard__c==true && f.Account_SBU__c=='D&S' )
                {
                    if(!mfeedDS.containsKey(f.Account_Name__c))
                        mfeedDS.put(f.Account_Name__c,new List<Feedback__c>{f});
                    else
                        mfeedDS.get(f.Account_Name__c).add(f);//add(f)=> adds one more record, without inserting duplicate
                }
                
            }
        } 
        
        /* Schema.DescribeSObjectResult SerreqObj = Schema.SObjectType.Service_Request__c;

Map<String,Schema.RecordTypeInfo> serrtMapByName = SerreqObj.getRecordTypeInfosByName();

Schema.RecordTypeInfo serrtByName =  serrtMapByName.get('SR Lean');
ID serRecTypeid =  serrtByName.getRecordTypeId(); */
        List<Service_Request__c> SRD=[SELECT id,Name,Atr__c,SBU__c,Account_Name__r.Name,Account_Name__c,Subject__c,Status__c,Status_Resolution__c,Top_Technical_Issue__c,Show_on_Dashboard__c,VOC_Card_Numb__r.Survey_Origin__c,Days_Past_Due__c,SR_is_Past_Due__c,VOC_Card_Numb__r.Account_Name__c FROM Service_Request__c where  (Show_on_Dashboard__c=true AND Status__c='Open')];
        
        
        if(SRD.size()>0)
        {
            for(Service_Request__c f:SRD)
            {
                if((f.SBU__c=='ATR') || (f.SBU__c=='BGA') || (f.SBU__c=='D&S'))
                {
                    totalSR=totalSR+1;
                    if(f.SR_is_Past_Due__c==1 )
                        PastdueSR=PastdueSR+1;
                }
                if(f.SBU__c=='ATR')
                {
                    totalSRATR=totalSRATR+1;
                    if(f.SR_is_Past_Due__c==1 )
                        PastdueSRATR=PastdueSRATR+1;
                }
                if(f.SBU__c=='BGA') 
                {
                    totalSRBGA=totalSRBGA+1; 
                    if(f.SR_is_Past_Due__c==1 )
                        PastdueSRBGA=PastdueSRBGA+1;
                    
                }
                if(f.SBU__c=='D&S') 
                {
                    totalSRDS=totalSRDS+1;  
                    if(f.SR_is_Past_Due__c==1 )
                        PastdueSRDS=PastdueSRDS+1;
                }
            }
            
        }   
        
        if(SRD.size()>0)
        {
            
            for(Service_Request__c SR:SRD)
            {
                
                if(SR.SR_is_Past_Due__c==1)
                {
                    if(!AccountSRCount.containsKey(SR.Account_Name__r.Name))
                        AccountSRCount.put(SR.Account_Name__r.Name,1);
                    else
                        //AccountServiceReqCount.get(SR.VOC_Card_Numb__r.Account_Name__c).add(new AccountServiceReqCount.get(SR.VOC_Card_Numb__r.Account_Name__c)+1);
                        AccountSRCount.put(SR.Account_Name__r.Name,AccountSRCount.get(SR.Account_Name__r.Name)+1);
                }
            }
        }
        
        
        if(SRD.size()>0)
        {
            
            for(Service_Request__c SR:SRD)
            {
                
                if(SR.SR_is_Past_Due__c==1)
                {
                    if(!SRMaxDaysCount.containsKey(SR.Account_Name__r.Name))
                        SRMaxDaysCount.put(SR.Account_Name__r.Name,integer.valueof(SR.Days_Past_Due__c));
                    else
                        //AccountServiceReqCount.get(SR.VOC_Card_Numb__r.Account_Name__c).add(new AccountServiceReqCount.get(SR.VOC_Card_Numb__r.Account_Name__c)+1);
                        SRMaxDaysCount.put(SR.Account_Name__r.Name,SRMaxDaysCount.get(SR.Account_Name__r.Name)+integer.valueof(SR.Days_Past_Due__c));
                }
            }
        }
        
        
        
        Schema.DescribeSObjectResult VOCFeedObj = Schema.SObjectType.Feedback__c;
        Map<String,Schema.RecordTypeInfo> VOCfeedrtMapByName = VOCFeedObj.getRecordTypeInfosByName();
        Schema.RecordTypeInfo VOCfeedrtByName =  VOCfeedrtMapByName.get('ATR VOC');
        ID VOCRecTypeid =  VOCfeedrtByName.getRecordTypeId();
        VOCRectype= [SELECT id,ATR_Survey_Group__c,Account__c,Account__r.Name,Account_Name__c from Feedback__c where recordtypeid=:VOCRecTypeid ];           
        
        if(VOCRectype.size()>0)
        {
            for(Feedback__c f:VOCRectype)
            {
                
                if(mfeedATR.containsKey(f.Account_Name__c))
                {
                    if(!VOCmapATR.containsKey(f.Account_Name__c))
                        VOCmapATR.put(f.Account_Name__c,true);
                    
                }
            } 
        }
        
        
        
        
        
        /* AOG */
        AOG_Date = System.today();
        AOG_Count24Hrs = ServiceLevelCount('24');
        AOG_Count4Hrs = ServiceLevelCount('4');
        AOG_Count48Hrs = ServiceLevelCount('48');
        decimal percentage=0.0;
        integer totalcount = [Select count() from Removals__c];
        system.debug('&&&&'+totalcount);
        decimal countgreen = [Select count() from Removals__c where Removals_Service_Level__c ='Green'];
        system.debug('&&&&'+countgreen); 
        if(totalcount >0 && countgreen >0)
            percentage=(countgreen/totalcount)*100;
        system.debug('&&&&'+percentage);
        if(percentage>84)
            colour='green';
        else if(percentage>70 && percentage<=84)
            colour='yellow';
        else
            colour='red';
    }
    
    public Integer getcountgreen1(){
        integer countgreen1=[Select count() from Removals__c where Removals_Service_Level__c='Green' and Root_Cause_Status__c!='Closed'];
        return countgreen1;
    }
    public Integer getcountred(){
        integer countred=[Select count() from Removals__c where Removals_Service_Level__c='Red' and Root_Cause_Status__c!='Closed'];
        return countred;
    }
    public Integer getcountyellow(){
        integer countyellow=[Select count() from Removals__c where Removals_Service_Level__c='Yellow'and Root_Cause_Status__c!='Closed'];
        return countyellow;
    }
    
    public String getOverallAOGStatus(){
        
        List<Case> AOGstatus = new List<Case>();
        
        AOGstatus = [Select AOG_Service_level__c from Case 
                     where (recordtypeId =:label.Case_AOG_RecordType /*or recordtypeId =: label.Case_Technical_Issue_RecordType*/)
                     /*and status !='Re-Open'*/ and X4_Hour_AOG__c= '4-hour'
                     and isClosed = false
                     order by CreatedDate DESC LIMIT 1];
        
        if (AOGstatus.size() > 0) {
            return string.valueof(AOGstatus[0].get('AOG_Service_level__c')).toLowerCase();
        }
        else
            return 'green';    
    }
    
    public Map<Boolean,Integer> ServiceLevelCount( String hours ){
        
        Map<Boolean,Integer> AOGrecords = new Map<Boolean,Integer>();
        
        AggregateResult[] serviceMap = [Select count(Id) Total, isClosed from Case 
                                        where (recordtypeId = :label.Case_AOG_RecordType /*or recordtypeId =: label.Case_Technical_Issue_RecordType*/)
                                        /*and status !='Re-Open'*/ and X4_Hour_AOG__c= :hours+'-hour'
                                        and (isClosed = false or ClosedDate >= :AOG_Date)
                                        Group By isClosed];
        
        for (AggregateResult ar : serviceMap) {                
            AOGrecords.put( !boolean.valueOf(ar.get('isClosed')), integer.valueOf(ar.get('Total')) );
        }
        
        if( AOGrecords.isEmpty() ){
            AOGrecords.put( True, 0 );
            AOGrecords.put( False, 0 );
        }
        else{
            if( !AOGrecords.containsKey(True) )AOGrecords.put( True, 0 );
            if( !AOGrecords.containsKey(False) )AOGrecords.put( False, 0 );
        }        
        
        return AOGrecords;
    }
    
    /*public List<AggregateResult> getSRsCountBySBU(){

SRs = [SELECT Count(Id) Total, SR_SBU__c SBU
FROM Service_Request__c 
WHERE (Risk_Tag__c = 'Red' or Risk_Tag__c = 'Yellow') AND Status__c <> 'Closed'
GROUP BY SR_SBU__c
ORDER BY Count(Id) DESC];

return SRs;
}

public List<AggregateResult> getSRsCountByProduct(){

SRs = [SELECT Count(Id) Total, Product_Family__c Product
FROM Service_Request__c 
WHERE (Risk_Tag__c = 'Red' or Risk_Tag__c = 'Yellow') AND Status__c <> 'Closed' AND SBU__c <> '' AND Product_Family__c != null
GROUP BY Product_Family__c
ORDER BY Count(Id) DESC
LIMIT 1];

return SRs;
}*/
    
    /**
* SPEX Methods
*/
    public List<string> getPlatformsAtRisk() { 
        return spexObj.lstStrPlatform;
    }    
    public Map<string,String> getmpStatus() {
        return spexObj.mpStatus;
    }
    
    public Map<String,list<wrapAccFeedback>> getSBUValues()
    {
        
        return CheckTrendStatus(mfeed);
    }
    public Map<String,list<wrapAccFeedback>> getATRValues()
    {
        
        return CheckTrendStatus(mfeedATR);
    }
    public Map<String,list<wrapAccFeedback>> getBGAValues()
    {
        return CheckTrendStatus(mfeedBGA);
    }
    
    public Map<String,list<wrapAccFeedback>> getDSValues()
    {
        return CheckTrendStatus(mfeedDS);
    }
    
    
    public PageReference Feedredirect()  
    {
        
        String fullRecordURL = label.Servernameurl+ '/' + FeedID;
        PageReference pageRef = new PageReference(fullRecordURL );
        pageRef.setRedirect(true);
        return pageRef; 
    }
    
    public PageReference TopSRDSRedirect() 
    {
        
        Account SRAccSbu=[Select id,Strategic_Business_Unit__c from Account where Name=:TopSRAcc and (Strategic_Business_Unit__c ='ATR' or Strategic_Business_Unit__c='BGA' or Strategic_Business_Unit__c='D&S') limit 1];
        
        if(SRAccSbu.Strategic_Business_Unit__c=='D&S')
        {
            strsbu ='DandS';
        }
        else
        {
            strsbu = SRAccSbu.Strategic_Business_Unit__c;
        }
        
        PageReference pageRef = new PageReference( '/apex/Customer_top10_issues?accid='+SRAccSbu.id+'&strsbu='+strsbu+'&scroll=true' );
        // PageReference pageRef = new PageReference( strURL);
        // pageRef.setRedirect(true);
        return pageRef; 
    } 
    
    
    public PageReference ATRVOC() 
    {
        PageReference pageRef = new PageReference( '/apex/ATR_VOC_Survey?Accountname='+Atrvocname);
        return pageRef; 
    }             
    public void closePopup() {        
        displayPopup = false;    
    } 
    
    public void showPopup() {        
        displayPopup = true;
        
    }
    
    
    public List<feedback__c> getRecorddetails(){
     system.debug('&&&Feed back values'+FeedId);
        feed1=[SELECT Name,Platform__r.Name,Site__c,Responsiveness_Customers_Rating__c,AOG_Customer_Rating_Feedback__c,AOG_Customer_Rating_Color__c,AOG_Customer_Rating_Color_Indicator__c,AOG_Customer_Rating__c,Development_Program_Rating_Color__c,Reliability_Customer_Rating__c ,Cost_Customer_Feedback__c,Delivery_Root_Cause_Context__c ,Delivery_Customer_Rating_color_CRD__c ,Delivery_Customer_Rating_CRD__c ,Additional_Comments__c ,Warranty_Customer_Feedback__c,Responsiveness_Root_Cause_Context__c,Spares_Performance_Customer_Feedback__c,Service_Support_Root_Cause_Context__c,Reliability_Root_Cause_Context__c,Repair_Performance_Customer_Feedback__c,Quality_Root_Cause_Context__c,Ease_of_Doing_Business_Feedback__c,Documentation_Customer_Feedback__c,Cost_Rating_Color_Indicator__c,Development_Root_Cause_Context__c,Compliance_Customer_Feedback__c,Communication_Customer_Feedback__c,Ease_of_Doing_Business_Customer_Rating__c,Ease_of_Doing_Business_Rating_Color__c,Documentation_Customer_Rating__c,Documentation_Rating_Color__c,Development_Program_Customer_Rating__c,Cost_Customer_Rating__c,Cost_Rating_Color__c,Compliance_Customer_Rating__c,Compliance_Rating_Color__c,Communication_Rating_Color__c,Communication_Customer_Rating__c,Quality_Rating_Color__c,Quarter__c,Year__c,Comments__c,Quality_Customers_Rating__c ,Overall_Rating__c,Overall_Rating_Color__c,Warranty_Customer_Rating__c,Warranty_Rating_Color__c,Spares_Perf_Customer_Rating__c,Spares_Perf_Rating_Color__c,Service_Support_Rating_Color__c,Service_Support_Customer_Rating__c,Responsiveness_Customer_Rating__c,Responsiveness_Rating_Color__c,Repairs_Perf_Rating_Color__c,Repairs_Perf_Customer_Rating__c,Reliability_Customers_Rating__c,Product_Category__c,Reliability_Rating_Color__c,Include_on_Customer_Rating_Dashboard__c,VOC_SBU__c,Quality_Rating_Color_Indicator__c,Reliability_Rating_Color_Indicator__c,Repairs_Perf_Rating_Color_Indicator__c,Spares_Perf_Rating_Color_Indicator__c,Account_Name__c,Account__c FROM Feedback__c where id=:FeedId];
        system.debug('&&&Feed back values'+feed1);
        
        if(feed1.size()>0) {}
        return feed1;
        
    }
    
    public integer getTotalSR()
    {
        return totalSR;
    }
    
    public integer getPastDueSR()
    {
        return PastdueSR;
        
    }
    public integer getTotalSRATR()
    {
        return totalSRATR;
    }
    
    public integer getPastDueSRATR()
    {
        return PastdueSRATR;
        
    }
    public integer getTotalSRBGA()
    {
        return totalSRBGA;
    }
    
    public integer getPastDueSRBGA()
    {
        return PastdueSRBGA;
        
    }
    public integer getTotalSRDS()
    {
        return totalSRDS;
    }
    
    public integer getPastDueSRDS()
    {
        return PastdueSRDS;
        
    }
    
    
    public Map<String,integer> getSRValues()
    {
        for(string s:mfeedATR.keyset()){
            if(AccountSRCount.get(s)==null)
                AccountSRCount.put(s,0);
        } 
        for(string s:mfeedBGA.keyset()){
            if(AccountSRCount.get(s)==null)
                AccountSRCount.put(s,0);
        }  
        for(string s:mfeedDS.keyset()){
            if(AccountSRCount.get(s)==null)
                AccountSRCount.put(s,0);
        }       
        return AccountSRCount;
    }
    
    public Map<String,integer> getSRDaysValues()
    {
        for(string s:mfeedATR.keyset()){
            if(SRMaxDaysCount.get(s)==null)
                SRMaxDaysCount.put(s,0);
        }
        for(string s:mfeedBGA.keyset()){
            if(SRMaxDaysCount.get(s)==null)
                SRMaxDaysCount.put(s,0);
        }
        for(string s:mfeedDS.keyset()){
            if(SRMaxDaysCount.get(s)==null)
                SRMaxDaysCount.put(s,0);
        }
        return SRMaxDaysCount;
        
    }
    public Map<String,boolean> getVOCfeedrecords()
    {
        for(string s:mfeed.keyset()){
            if(VOCmapATR.get(s)==null)
                VOCmapATR.put(s,false);
        }
        return VOCmapATR;
    }  
    public Map<String,boolean> getVOCfeedrecordsATR()
    {
        for(string s:mfeedATR.keyset()){
            if(VOCmapATR.get(s)==null)
                VOCmapATR.put(s,false);
        }
        return VOCmapATR;
    }  
    
    public Decimal getTotalpercentage()
    {
        TotalpercentageALL=Math.ceil(Totalpercentage/3 );
        return TotalpercentageALL;
    }
    public decimal getTotalpercentageATR()
    {
        return Math.ceil(TotalpercentageATR );
    }
    public Decimal getTotalpercentageBGA()
    {
        return Math.ceil(TotalpercentageBGA );
    }
    public Decimal getTotalpercentageDS()
    {
        return Math.ceil(TotalpercentageDS  );
    }
    
    public integer getRedcountATR()
    {
        return RedcountATR;
    }
    public integer getRedcountBGA()
    {
        return RedcountBGA;
    }
    public integer getRedcountDS()
    {
        return RedcountDS;
    }
    
    public integer getYellowcountATR()
    {
        return YellowcountATR;
    }
    public integer getYellowcountBGA()
    {
        return YellowcountBGA;
    }
    public integer getYellowcountDS()
    {
        return YellowcountDS;
    }
    public integer getGreencountATR()
    {
        return GreencountATR;
    }
    public integer getGreencountBGA()
    {
        return GreencountBGA;
    }
    public integer getGreencountDS()
    {
        return GreencountDS;
    }
    
    public String getTotalpercentageColor()
    {
        if(Math.ceil(TotalpercentageALL)>=90)
        {
            return 'redPercent_box green clearfix';
        }
        else if((Math.ceil(TotalpercentageALL)>=80) && (Math.ceil(TotalpercentageALL)<=89))
        {
            return 'redPercent_box yellow clearfix';
        }
        else
            return 'redPercent_box clearfix';
    }
    
    public String getTotalpercentageColorATR()
    {
        if(Math.ceil(TotalpercentageATR)>=90)
        {
            return 'redPercent_box green clearfix';
        }
        else if((Math.ceil(TotalpercentageATR)>=80) && (Math.ceil(TotalpercentageATR)<=89))
        {
            return 'redPercent_box yellow clearfix';
        }
        else
            return 'redPercent_box clearfix';
    }
    
    public String getTotalpercentageColorBGA()
    {
        if(Math.ceil(TotalpercentageBGA)>=90)
        {
            return 'redPercent_box green clearfix';
        }
        else if((Math.ceil(TotalpercentageBGA)>=80) && (Math.ceil(TotalpercentageBGA)<=89))
        {
            return 'redPercent_box yellow clearfix';
        }
        else
            return 'redPercent_box clearfix';
    }
    
    public String getTotalpercentageColorDS()
    {
        if(Math.ceil(TotalpercentageDS)>=90)
        {
            return 'redPercent_box green clearfix';
        }
        else if((Math.ceil(TotalpercentageDS)>=80) && (Math.ceil(TotalpercentageDS)<=89))
        {
            return 'redPercent_box yellow clearfix';
        }
        else
            return 'redPercent_box clearfix';
    }   
    
    public String getGreencountColorATR()
    {
        if(GreencountATR==0)
        {
            return 'width:0%;';
        }
        else if((GreencountATR>=RedcountATR) && (GreencountATR>=YellowcountATR))
        {
            return 'width:75%;';
        }
        else if((GreencountATR>=RedcountATR) || (GreencountATR>=YellowcountATR))
            
        {
            return 'width:50%;';
        }
        
        else
            
            return 'width:25%;';
        
    }
    
    public String getYellowcountColorATR()
    {
        if(YellowcountATR==0)
        {
            return 'width:0%;';
        }
        else if((YellowcountATR>=RedcountATR) && (YellowcountATR>=GreencountATR))
        {
            return 'width:75%;';
        }
        else if((YellowcountATR>=RedcountATR) || (YellowcountATR>=GreencountATR))
            
        {
            return 'width:50%;';
        }          
        else
            return 'width:25%;';
        
    }
    
    public String getRedcountColorATR()
    {
        if(RedcountATR==0)
        {
            return 'width:0%;';
        }
        else if((RedcountATR>=GreencountATR) && (RedcountATR>=YellowcountATR))
        {
            return 'width:75%;';
        }
        else if((RedcountATR>=GreencountATR) && (RedcountATR>=YellowcountATR))
            
        {
            return 'width:50%;';
        }
        else 
            return 'width:25%;';
        
    }
    public String getGreencountColorBGA()
    {
        if(GreencountBGA==0)
        {
            return 'width:0%;';
        }
        else if((GreencountBGA>=RedcountBGA) && (GreencountBGA>=YellowcountBGA))
        {
            return 'width:75%;';
        }
        else if((GreencountBGA>=RedcountBGA) || (GreencountBGA>=YellowcountBGA))
            
        {
            return 'width:50%;';
        }                
        else
            return 'width:25%;';
        
    }
    
    public String getYellowcountColorBGA()
    {
        if(YellowcountBGA==0)
        {
            return 'width:0%;';
        }
        else if((YellowcountBGA>=RedcountBGA)&& (YellowcountBGA>=GreencountBGA))
        {
            return 'width:75%;';
        }
        else if((YellowcountBGA>=RedcountBGA) || (YellowcountBGA>=GreencountBGA))
            
        {
            return 'width:50%;';
        }
        else
            return 'width:25%;';
    }
    
    public String getRedcountColorBGA()
    {
        if(RedcountBGA==0)
        {
            return 'width:0%;';
        }
        else if((RedcountBGA>=GreencountBGA) && (RedcountBGA>=YellowcountBGA))
        {
            return 'width:75%;';
        }
        else if((RedcountBGA>=GreencountBGA) && (RedcountBGA>=YellowcountBGA))
        {
            return 'width:50%;';
        }
        else
            return 'width:25%;';
    }
    
    public String getGreencountColorDS()
    {
        if(GreencountDS==0)
        {
            return 'width:0%;';
        }
        else if((GreencountDS>=RedcountDS) && (GreencountDS>=YellowcountDS))
        {
            return 'width:75%;';
        }
        else if((GreencountDS>=RedcountDS) || (GreencountDS>=YellowcountDS))
            
        {
            return 'width:50%;';
        }
        else
            return 'width:25%;';
    }
    
    public String getYellowcountColorDS()
    {
        if(YellowcountDS==0)
        {
            return 'width:0%;';
        }
        else if((YellowcountDS>=RedcountDS)&& (YellowcountDS>=GreencountDS))
        {
            return 'width:75%;';
        }
        else if((YellowcountDS>=RedcountDS) || (YellowcountDS>=GreencountDS))
            
        {
            return 'width:50%;';
        }
        else
            return 'width:25%;';
    }
    
    public String getRedcountColorDS()
    {
        if(RedcountDS==0)
        {
            return 'width:0%;';
        }
        if((RedcountDS>=GreencountDS) && (RedcountDS>=YellowcountDS))
        {
            return 'width:75%;';
        }
        else if((RedcountDS>=GreencountDS) || (RedcountDS>=YellowcountDS))
            
        {
            return 'width:50%;';
        }
        else
            return 'width:25%;';
        
    } 
    public String getscroll(){
        return scroll;
    }
    
    //public string getscrollcomment(){
    public List<string> getscrollcomment(){
        return scrollcomment;
    }
    public List<string>  getscrollcommentATR(){
        
        return scrollcommentATR;
    }
    public List<string> getscrollcommentBGA(){
        
        return scrollcommentBGA;
    }
    public List<string> getscrollcommentDS(){
        
        return scrollcommentDS;
    }
    
     /* public Integer getprodCatgry()
    {
        if(accMap.values()==1)
        {
            return 'green_up_arr:before clearfix';
        }
        else 
        {
            return 'red_down_arr:before clearfix';
        }
       }*/
    @remoteaction
    Global static list<Feedback__c> RemFeedback(string filter3)
    {
        Schema.DescribeSObjectResult FeedObj = Schema.SObjectType.Feedback__c;
        
        Map<String,Schema.RecordTypeInfo> feedrtMapByName = FeedObj.getRecordTypeInfosByName();
        
        Schema.RecordTypeInfo feedrtByName =  feedrtMapByName.get('Customer Rating');
        
        ID feedRecTypeid =  feedrtByName.getRecordTypeId();
        
        list<string> producttype= new list<string>{'Avionics','APU','Mechanical'};
            List<Feedback__c> fed=new list<Feedback__c>();
        
        string query='';
        
        
        if( filter3== 'ALL' && query==''){
            query='select id,Overall_Rating_Color__c,ATR_Survey_Group__c,VOC_SBU__c,Account__c,Account__r.Name,Account_Name__c,Product_Category__c,Year__c,Name,Metric_for_Reliability__c,Metric_for_Quality__c,Warranty__c,Repair_Performance__c,Spares_Performance__c,Recommend_HON__c,Metric_for_Value__c,Cost__c,Overall_Perception__c,Communication__c,Documentation__c,Metric_for_Service_Support__c,Global_Technical_Ops_Support__c,Flexibility__c,Customer_Overall_Satisfaction_Metric__c,Consolidated_score__c from Feedback__c where  (recordtypeid=:feedRecTypeid and Product_Category__c in:producttype)';           
            //return Database.query(query);
            fed=Database.query(query);
            return fed;
            
        }
        else{
            // fed=[select id,ATR_Survey_Group__c,Account__c,Account__r.Name,Account_Name__c,Product_Category__c,Year__c,Name,Metric_for_Reliability__c,Metric_for_Quality__c,Warranty__c,Repair_Performance__c,Spares_Performance__c,Recommend_HON__c,Metric_for_Value__c,Cost__c,Overall_Perception__c,Communication__c,Documentation__c,Metric_for_Service_Support__c,Global_Technical_Ops_Support__c,Flexibility__c,Customer_Overall_Satisfaction_Metric__c,Consolidated_score__c from Feedback__c where (recordtypeid=:feedRecTypeid and Product_Category__c=:filter3)];
            query='select id,Overall_Rating_Color__c,ATR_Survey_Group__c,VOC_SBU__c,Account__c,Account__r.Name,Account_Name__c,Product_Category__c,Year__c,Name,Metric_for_Reliability__c,Metric_for_Quality__c,Warranty__c,Repair_Performance__c,Spares_Performance__c,Recommend_HON__c,Metric_for_Value__c,Cost__c,Overall_Perception__c,Communication__c,Documentation__c,Metric_for_Service_Support__c,Global_Technical_Ops_Support__c,Flexibility__c,Customer_Overall_Satisfaction_Metric__c,Consolidated_score__c from Feedback__c where (recordtypeid=:feedRecTypeid and Product_Category__c=:filter3)';
            //return Database.query(query);
            fed=Database.query(query);
            return fed;
        }
        
        
    }
    public map<string,list<wrapAccFeedback>> CheckTrendStatus(map<string,list<feedback__c>> feed1)
    {
    map<string,list<wrapAccFeedback>> mfeedATR_Trend= new map<string,list<wrapAccFeedback>>();      
      if(feed1.size()>0)
        {   
           
            for(List<Feedback__c> ranklist : feed1.values())
            {
               system.debug('### feedback records count'+ranklist.size()+' #### account name'+ranklist[0].Account_Name__c);
                map<string,Decimal> mapCurrentYearRanking=new map<string,Decimal>();
                map<string,Decimal> mapPreviousYearRanking=new map<string,Decimal>();
                map<string,Integer> mapCurrentYearCount=new map<string,Integer>();
                map<string,Integer> mapPreviousYearCount=new map<string,Integer>();
                map<string,integer> finalRankingStatus=new map<string,integer>();
                map<string,Decimal> mapCurrentYearOverallrating=new map<string,Decimal>();
                map<string,Decimal> mapPreviousYearOverallrating=new map<string,Decimal>();
                map<string,Integer> mapCurrentYearOverallCount=new map<string,Integer>();
                map<string,Integer> mapPreviousYearOverallCount=new map<string,Integer>();
                map<string,decimal> finaloverallratingStatus=new map<string,decimal>();
                for(Feedback__c rank :ranklist)
                {
                    if(rank .Ranking__c!=null && rank .Ranking__c.contains('/')&&rank.Product_Category__c!= null)
                    {
                    Decimal eachRanking = Decimal.valueOf(rank.Ranking__c.substringBefore('/'))/Decimal.valueOf(rank.Ranking__c.substringAfter('/'));
                    if(rank.Year__c==String.valueof(System.Today().year()))
                    {
                        if (mapCurrentYearRanking.containsKey(rank.Product_Category__c))
                        {
                            mapCurrentYearRanking.put(rank.Product_Category__c,mapCurrentYearRanking.get(rank.Product_Category__c)+eachRanking);
                            mapCurrentYearCount.put(rank.Product_Category__c,mapCurrentYearCount.get(rank.Product_Category__c)+1);
                        }
                        else
                        {
                            mapCurrentYearRanking.put(rank.Product_Category__c,eachRanking);
                            mapCurrentYearCount.put(rank.Product_Category__c,1);
                        }
                    }
                    if(rank.Year__c==String.valueof(System.Today().year()-1))
                    {
                        if (mapPreviousYearRanking.containsKey(rank.Product_Category__c))
                                        {
                                            mapPreviousYearRanking.put(rank.Product_Category__c,mapPreviousYearRanking.get(rank.Product_Category__c)+eachRanking);
                                            mapPreviousYearCount.put(rank.Product_Category__c,mapPreviousYearCount.get(rank.Product_Category__c)+1);
                                        }
                        else
                                        {
                                            mapPreviousYearRanking.put(rank.Product_Category__c,eachRanking);
                                            mapPreviousYearCount.put(rank.Product_Category__c,1);
                                        }
                    }
                   }
                    // Starting of overall rating trend
                   if(rank.Overall_Rating__c!=null && rank.Year__c==String.valueof(System.Today().year()) && rank.Product_Category__c!= null)
                    {
                     system.debug('Overall_Rating__c'+rank.Overall_Rating__c);
                     if (mapCurrentYearOverallrating.containsKey(rank.Product_Category__c))
                     {
                        mapCurrentYearOverallrating.put(rank.Product_Category__c,mapCurrentYearOverallrating.get(rank.Product_Category__c)+rank.Overall_Rating__c);
                         mapCurrentYearOverallCount.put(rank.Product_Category__c,mapCurrentYearOverallCount.get(rank.Product_Category__c)+1);
                     }
                     
                     else
                     {
                        mapCurrentYearOverallrating.put(rank.Product_Category__c,rank.Overall_Rating__c);
                        mapCurrentYearOverallCount.put(rank.Product_Category__c,1);
                     }
                      system.debug('ccccccccccccccccccccccccccc'+mapCurrentYearOverallrating.get(rank.Product_Category__c));
                     }
                     
                      if(rank.Overall_Rating__c!=null && rank.Year__c==String.valueof(System.Today().year()-1) && rank.Product_Category__c!= null)
                    {
                     if (mapPreviousYearOverallrating.containsKey(rank.Product_Category__c))
                     {
                        mapPreviousYearOverallrating.put(rank.Product_Category__c,mapPreviousYearOverallrating.get(rank.Product_Category__c)+rank.Overall_Rating__c);
                        mapPreviousYearOverallCount.put(rank.Product_Category__c,mapPreviousYearOverallCount.get(rank.Product_Category__c)+1);
                     }
                     else
                     {
                        mapPreviousYearOverallrating.put(rank.Product_Category__c,rank.Overall_Rating__c);
                        mapPreviousYearOverallCount.put(rank.Product_Category__c,1);
                     }
                     }
                           
                  }
                   system.debug('#### current year Ranking'+mapCurrentYearRanking.keyset());
                   system.debug('#### previous yearYearRanking'+mapPreviousYearRanking.keyset());
                   system.debug('#### current year count'+mapCurrentYearCount.keyset());
                   system.debug('#### previous year count'+mapPreviousYearCount.keyset());
                
                for(string prodCatgry:mapCurrentYearRanking.keyset())
                {
                    system.debug('#### product category'+prodCatgry);
                    system.debug('#### product mapCurrentYearRanking'+mapCurrentYearRanking.get(prodCatgry));
                    system.debug('#### product mapCurrentYearCount'+mapCurrentYearCount.get(prodCatgry));
                    system.debug('#### product mapPreviousYearRanking'+mapPreviousYearRanking.get(prodCatgry));
                    system.debug('#### product mapPreviousYearCount'+mapPreviousYearCount.get(prodCatgry));
                    if(mapCurrentYearCount.containskey(prodCatgry) && mapPreviousYearRanking.containskey(prodCatgry) && mapPreviousYearCount.containskey(prodCatgry))
                    {
                        system.debug('Inside the checking loop');
                        Decimal currentYearValue=mapCurrentYearRanking.get(prodCatgry)/mapCurrentYearCount.get(prodCatgry);
                        Decimal previousYearValue= mapPreviousYearRanking.get(prodCatgry)/mapPreviousYearCount.get(prodCatgry);
                        system.debug('Inside the checking loop-currentYearValue1'+currentYearValue);
                        system.debug('Inside the checking loop-previousYearValue1'+previousYearValue);
                        if(currentYearValue>previousYearValue)
                            finalRankingStatus.put(prodCatgry,1);
                        else
                             finalRankingStatus.put(prodCatgry,0);
                     system.debug('### final ranking status'+finalRankingStatus.get(prodCatgry));
                    }
                    
                }
                // Adding for overall rating trend
                for(string prodCatgry:mapCurrentYearOverallrating.keyset())
                {
                    system.debug('#### product category'+prodCatgry);
                    system.debug('#### product mapCurrentYearRanking'+mapCurrentYearOverallrating.get(prodCatgry));
                    system.debug('#### product mapCurrentYearCount'+mapCurrentYearOverallCount.get(prodCatgry));
                    system.debug('#### product mapPreviousYearRanking'+mapPreviousYearOverallrating.get(prodCatgry));
                    system.debug('#### product mapPreviousYearCount'+mapPreviousYearOverallCount.get(prodCatgry));
                    if(mapCurrentYearOverallCount.containskey(prodCatgry) && mapPreviousYearOverallrating.containskey(prodCatgry) && mapPreviousYearOverallCount.containskey(prodCatgry))
                    {
                        
                        Decimal currentYearValue1=mapCurrentYearOverallrating.get(prodCatgry)/mapCurrentYearOverallCount.get(prodCatgry);
                        Decimal previousYearValue1= mapPreviousYearOverallrating.get(prodCatgry)/mapPreviousYearOverallCount.get(prodCatgry);
                         system.debug('Inside the checking loop-currentYearValue1'+currentYearValue1);
                        system.debug('Inside the checking loop-previousYearValue1'+previousYearValue1);
                        if(currentYearValue1>previousYearValue1)
                            finaloverallratingStatus.put(prodCatgry,1);
                        else
                             finaloverallratingStatus.put(prodCatgry,0);
                              system.debug('### final ranking status'+finaloverallratingStatus.get(prodCatgry));
                    }
                    
                }
                list<wrapAccFeedback> lstWrapAccFeedback=new list<wrapAccFeedback>();
                for(Feedback__c rank :ranklist)
                {
                    wrapAccFeedback wrap;
                    if((rank.Year__c==String.valueof(System.Today().year()) && finalRankingStatus.containskey(rank.Product_Category__c)&&rank.Product_Category__c!=null && rank.Ranking__c!=null ) )
                    {
                        wrap = new wrapAccFeedback(rank,finalRankingStatus.get(rank.Product_Category__c),2);
                        //lstWrapAccFeedback.add(new wrapAccFeedback(rank,finalRankingStatus.get(rank.Product_Category__c)),2);
                       
                        }
                    else 
                        wrap = new wrapAccFeedback(rank,2,2);
                        
                  if((rank.Year__c==String.valueof(System.Today().year()) && finaloverallratingStatus.containskey(rank.Product_Category__c)&&rank.Product_Category__c!=null && rank.Overall_Rating__c!=null))
                    
                     wrap.overalltrend = finaloverallratingStatus.get(rank.Product_Category__c);
                  else
                    
                    wrap.overalltrend = 2;
                         
                        lstWrapAccFeedback.add(wrap);
                 }
                mfeedATR_Trend.put(ranklist[0].Account_Name__c,lstWrapAccFeedback);
                for(wrapAccFeedback obj:mfeedATR_Trend.get(ranklist[0].Account_Name__c))
                {
                    system.debug('Account name ###'+ranklist[0].Account_Name__c+' ##### Feedback record'+obj.feed.name+' ### Feedback year'+obj.feed.year__c+' #### Trend Status'+obj.trendStatus);
                }
          
            }
           
             
        }
    return mfeedATR_Trend;
    }
    public class wrapAccFeedback{
    
    public Feedback__c feed{get;set;}
    public integer trendStatus{get;set;}
    public decimal overalltrend {get;set;}
     
       public wrapAccFeedback(Feedback__c feedRec,Integer status, decimal overall){
     
         feed=feedRec;
         trendStatus=status;
         overalltrend = overall;
       }
  }
  
  public map<string,string> getlogoimg()
         {
        
         return logoimgmap;
         }
}