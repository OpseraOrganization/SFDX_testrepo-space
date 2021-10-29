Global with sharing class SRDController{

 public transient List<Service_Request__c> SRs=new List<Service_Request__c>();
 public integer totalRec{get;set;}
 public transient List<Service_Request__c> SRCSB=new List<Service_Request__c>();
 //public string SRId {get;set;}
 public static list<Service_Request__c> SRpop{get;set;}
    
 public string filterSRInfo{get;set;}
       
 public string filterspl{get;set;}
       
 public string filterSrchData{get;set;}
       
 public transient List<User> usr=new List<User>();
 public transient List<Platform__c> pform=new List<Platform__c>();
 
       
 public SRDController()
    {
        
        totalRec=0;   
   
       
        SRs=[SELECT id,CSB_Gate__c,SRD_OverallStatus__c,Customer_Impact__c,Created_Date__c,Due_DateSRD__c,Product_Family__c,SRD_Platform_Name__c,Near_Term_Alternate_Fix__c,Product_Description__c,Product_Code__c,CreatedDate,Estimated_Gate_1_Date__c,Gate_0_Completion_Date__c,SR_Site__c,Gate_3_Completed__c,Gate_3_Planned__c,Gate_4_Completed__c,Gate_4_Planned__c,Gate_5_Completed__c,Gate_5_Planned__c,Gate_2_Planned__c,Gate_2_Completed__c,Gate_1_Completion_Date__c,Performance__c,Gate_Phase__c,Service_Request_Manager__c,PSPM__c,Owner_Manager__c,CSB_Number__c,ownerid ,SOF__c,Aircraft_Type__r.name,Last_Technical_Update__c,Complexity_Sub_Level__c,Name,Atr__c,Subject__c,Status__c,SBU__c,Account_Name__r.Name,Account_Name__c,Top_Technical_Issue__c,Problem_Description__c,Status_Resolution__c,Escalation_Tier__c,Complexity_Level__c,Customer_Due_Date__c,VOC_Card_Numb__r.Survey_Origin__c,Days_Past_Due__c,Function_Responsible__c,SR_is_Past_Due__c,VOC_Card_Numb__r.Account_Name__c,VOC_Card_Numb__r.Account__c FROM Service_Request__c where Top_Technical_Issue__c=true ];
        if(SRs.size()>0)
        {
            for(Service_Request__c f:SRs)
            {
                 totalRec=totalRec+1;
                 if(f.CSB_Number__c!=null)
                 {
                    SRCSB.add(f);
                    
                 }
            }
            
        }
    
    }
    
    
 public List<String> getCBTpickVal()
     {      
        List<String> opt = new List<String>();
        Schema.DescribeFieldResult CatResult = Account.CBT__c.getDescribe();
        List<Schema.PicklistEntry> CatEntries = CatResult.getPicklistValues();
        for(Schema.PicklistEntry entryCat : CatEntries)
            {
                opt.add(entryCat.getValue());        
            }
            
            return opt;           
     }
 public List<String> getPdtFamily()
     {
        List<String> opt = new List<String>();
        Schema.DescribeFieldResult CatResult = Supported_Products__c.Catalog_Product_Group__c.getDescribe();
        List<Schema.PicklistEntry> CatEntries = CatResult.getPicklistValues();
        for(Schema.PicklistEntry entryCat : CatEntries)
            {
                opt.add(entryCat.getValue());        
            }
            
            return opt;         
     }
    
    
    
 public void FiltersVal()
    {
    
        SRCSB=new List<Service_Request__c> ();   
        List<Service_Request__c> ServReq = new list<Service_Request__c>();
        string query='SELECT id,CSB_Gate__c,Product_Family__c,Created_Date__c,Due_DateSRD__c,Customer_Impact__c,SRD_Platform_Name__c,Product_Description__c,Near_Term_Alternate_Fix__c,Product_Code__c,CreatedDate,SRD_OverallStatus__c,Estimated_Gate_1_Date__c,SR_Site__c,Gate_0_Completion_Date__c,Gate_3_Completed__c,Gate_3_Planned__c,Gate_4_Completed__c,Gate_4_Planned__c,Gate_5_Completed__c,Gate_5_Planned__c,Gate_2_Planned__c,Gate_2_Completed__c,Gate_1_Completion_Date__c,Performance__c,Gate_Phase__c,Service_Request_Manager__c,PSPM__c,Owner_Manager__c,CSB_Number__c,ownerid ,SOF__c,Aircraft_Type__r.name,Last_Technical_Update__c,Complexity_Sub_Level__c,Name,Atr__c,Subject__c,Status__c,SBU__c,Account_Name__r.Name,Account_Name__c,Top_Technical_Issue__c,Problem_Description__c,Status_Resolution__c,Escalation_Tier__c,Complexity_Level__c,Customer_Due_Date__c,VOC_Card_Numb__r.Survey_Origin__c,Days_Past_Due__c,Function_Responsible__c,SR_is_Past_Due__c,VOC_Card_Numb__r.Account_Name__c,VOC_Card_Numb__r.Account__c FROM Service_Request__c where Top_Technical_Issue__c=true';
        system.debug('## Resultant records size:'+ filterSRInfo);
        List<String> filtervalues=new List<String>();
        if(filterSRInfo!= null)
        filtervalues = filterSRInfo.split(':');
        system.debug('filtered values'+filtervalues);
        map<integer ,String> fmap=new map<integer ,String>{1 => 'SBU__c' , 2 => 'CBT__c',3 => 'Owner_Manager__c',4 => 'ownerid',5 => 'PSPM__c',6 => 'Service_Request_Manager__c',7 => 'Product_Types__c',8 => 'Escalation_Tier__c',9 =>'Catalog_Product_Groups__c',12 => 'Status__c',13 => 'Performance__c',14 => 'Complexity_Level__c',15 => 'Status__c',16 => 'Top_Technical_Issue__c',17 => 'SOF__c'};
        for(string s:filtervalues )
            {
                integer w=Integer.valueOf(s.substringBefore('>'));
                string val=s.substringAfter('>');
                if(val!='ALL')
                    {
                        query=query+' AND '+fmap.get(w)+'='+val;
                    }
        
           }
           
         ServReq =Database.Query(query);
         SRCSB.clear();
         SRCSB.addall(ServReq);
         totalRec=SRCSB.size();
    }
    
 public void FiltersSplIdVal()
    {
        
        SRCSB=new List<Service_Request__c> ();
        List<Service_Request__c> ServReq = new list<Service_Request__c>();
        string query='SELECT id,CSB_Gate__c,Product_Family__c,Created_Date__c,Due_DateSRD__c,SRD_Platform_Name__c,Customer_Impact__c,Product_Description__c,Near_Term_Alternate_Fix__c,Product_Code__c,CreatedDate,SRD_OverallStatus__c,Estimated_Gate_1_Date__c,SR_Site__c,Gate_0_Completion_Date__c,Gate_3_Completed__c,Gate_3_Planned__c,Gate_4_Completed__c,Gate_4_Planned__c,Gate_5_Completed__c,Gate_5_Planned__c,Gate_2_Planned__c,Gate_2_Completed__c,Gate_1_Completion_Date__c,Performance__c,Gate_Phase__c,Service_Request_Manager__c,PSPM__c,Owner_Manager__c,CSB_Number__c,ownerid ,SOF__c,Aircraft_Type__r.name,Last_Technical_Update__c,Complexity_Sub_Level__c,Name,Atr__c,Subject__c,Status__c,SBU__c,Account_Name__r.Name,Account_Name__c,Top_Technical_Issue__c,Problem_Description__c,Status_Resolution__c,Escalation_Tier__c,Complexity_Level__c,Customer_Due_Date__c,VOC_Card_Numb__r.Survey_Origin__c,Days_Past_Due__c,Function_Responsible__c,SR_is_Past_Due__c,VOC_Card_Numb__r.Account_Name__c,VOC_Card_Numb__r.Account__c FROM Service_Request__c where Top_Technical_Issue__c=true';
        //string filterspl=Apexpages.currentPage().getParameters().get('splfilter');
        
        List<String> filtervalues=new List<String>();
        if(filterspl != null)
        filtervalues = filterspl.split(':');
        map<integer ,String> fmap=new map<integer ,String>{1 => 'true' , 2 => 'true' };
        for(string s:filtervalues )        
            {                  
                 integer w=Integer.valueOf(s.substringBefore('>'));
                 string val=s.substringAfter('>');
                  if(w!=3)
                 {
                 query=query+' AND '+val+'='+fmap.get(w);
                 }
                 else
                 query=query+' AND '+val;
                 
            }         
            
        ServReq =Database.Query(query);
        SRCSB.clear();
        SRCSB.addall(ServReq);
        totalRec=SRCSB.size();
    }
    
    
    
    
 public void FilterSrchData()
    {
         SRCSB=new List<Service_Request__c> ();
         List<Service_Request__c> ServReq = new list<Service_Request__c>();
         string query='SELECT id,CSB_Gate__c,Product_Family__c,Created_Date__c,Due_DateSRD__c,SRD_Platform_Name__c,Customer_Impact__c,Product_Description__c,Product_Code__c,Near_Term_Alternate_Fix__c,SRD_OverallStatus__c,CreatedDate,Estimated_Gate_1_Date__c,SR_Site__c,Gate_0_Completion_Date__c,Gate_3_Completed__c,Gate_3_Planned__c,Gate_4_Completed__c,Gate_4_Planned__c,Gate_5_Completed__c,Gate_5_Planned__c,Gate_2_Planned__c,Gate_2_Completed__c,Gate_1_Completion_Date__c,Performance__c,Gate_Phase__c,Service_Request_Manager__c,PSPM__c,Owner_Manager__c,CSB_Number__c,ownerid ,SOF__c,Aircraft_Type__r.name,Last_Technical_Update__c,Complexity_Sub_Level__c,Name,Atr__c,Subject__c,Status__c,SBU__c,Account_Name__r.Name,Account_Name__c,Top_Technical_Issue__c,Problem_Description__c,Status_Resolution__c,Escalation_Tier__c,Complexity_Level__c,Customer_Due_Date__c,VOC_Card_Numb__r.Survey_Origin__c,Days_Past_Due__c,Function_Responsible__c,SR_is_Past_Due__c,VOC_Card_Numb__r.Account_Name__c,VOC_Card_Numb__r.Account__c FROM Service_Request__c where Top_Technical_Issue__c=true';
         
         List<String> filtervalues=new List<String>();
         if(filterSrchData!= null)
         filtervalues = filterSrchData.split(':');
         map<integer ,String> fmap=new map<integer ,String>{1 => 'Name' , 2 => 'CSB_Number__c',3 => 'Key_Code__c',4 => 'Account_Name__r.Name',5 => 'Aircraft_Type__r.Name',6 => 'SBU__c'};
         for(string s:filtervalues )
             {               
                  integer w=Integer.valueOf(s.substringBefore('>'));
                  string val=s.substringAfter('>');
                  if(val.contains('-'))
                  {
                  if(val.substringAfter('-')!='')
                      {
                          query=query+' AND '+fmap.get(w)+'=\''+val+'\'';
                      }
                  }
                  
                  else
                  {
                  if(val!='')
                  {
                   query=query+' AND '+fmap.get(w)+'=\''+val+'\'';
                  } 
                  }   
             }
         
        ServReq =Database.Query(query);
        SRCSB.clear();
        SRCSB.addall(ServReq);
        totalRec=SRCSB.size();
    }
    public integer getTotalSR()
    {
     
     return totalRec;
    }
    public List<Service_Request__c> getCSBSRs()
    {
    return SRCSB;
    }
    public list<User> getUsersname()
    {
    usr=[SELECT id, name,Profile.name FROM User where Profile.name like 'GTO%' OR Profile.name like 'C&PS%' order by name ASC]; 
       
    return usr;
    }
    public list<Platform__c> getPlatform()
    {
    Pform=[SELECT id,name FROM Platform__c order by name ASC limit 10];    
    return Pform;
    }
    /*public id SRId{
    get{
    SRId= ApexPages.currentPage().getParameters().get('SRId'); 
    return SRId;
    }
    set;
    }*/
   
    
    /*public List<Service_Request__c> getSRpop()
    {
     system.debug('#### result id'+SRId);
     SRpop=new list<Service_Request__c>();
     SRpop=[SELECT id,CSB_Gate__c,CSB_Number__c,SOF__c,Aircraft_Type__c,Last_Technical_Update__c,Complexity_Sub_Level__c,Name,Atr__c,Subject__c,Status__c,SBU__c,Account_Name__r.Name,Account_Name__c,Top_Technical_Issue__c,Problem_Description__c,Status_Resolution__c,Escalation_Tier__c,Complexity_Level__c,Customer_Due_Date__c,VOC_Card_Numb__r.Survey_Origin__c,Days_Past_Due__c,Function_Responsible__c,SR_is_Past_Due__c,VOC_Card_Numb__r.Account_Name__c,VOC_Card_Numb__r.Account__c FROM Service_Request__c where id =: SRId ];
     system.debug('#### result'+SRpop);
    
    return SRpop;
     }*/
     
     
     
     @RemoteAction
    Global static List<Service_Request__c> getSRpopup(String SRId) 
    {
        SRpop=new list<Service_Request__c>();
        SRpop=[SELECT id,CSB_Gate__c,CSB_Number__c,SOF__c,Created_Date__c,Due_DateSRD__c,Customer_Impact__c,Product_Family__c,SRD_Platform_Name__c,Product_Description__c,Near_Term_Alternate_Fix__c,Aircraft_Type__r.Name,Product_Code__c,CreatedDate,Aircraft_Type__c,SR_Site__c,Last_Technical_Update__c,Complexity_Sub_Level__c,Name,Atr__c,Subject__c,Status__c,SBU__c,Account_Name__r.Name,Account_Name__c,Top_Technical_Issue__c,Problem_Description__c,Status_Resolution__c,Escalation_Tier__c,Complexity_Level__c,Customer_Due_Date__c,VOC_Card_Numb__r.Survey_Origin__c,Days_Past_Due__c,Function_Responsible__c,SR_is_Past_Due__c,VOC_Card_Numb__r.Account_Name__c,VOC_Card_Numb__r.Account__c FROM Service_Request__c where id =: SRId];
        return SRpop;
    }
   

}