public with sharing class CustomerTop10IssuesClass {
//dev1 modified change
 public boolean Toggle=false;
 String scroll = 'true';
 public transient List<Service_Request__c> TOPSrs=new List<Service_Request__c>();
 public transient List<Service_Request__c> TOPSrsAll=new List<Service_Request__c>();
 public transient List<Service_Request__c> SBUSrs=new List<Service_Request__c>();
  public transient List<Service_Request__c> SBUSrsAll=new List<Service_Request__c>();

 public transient List<Service_Request__c> SBUATRSrs=new List<Service_Request__c>();
  public transient List<Service_Request__c> SBUATRSrsAll=new List<Service_Request__c>();

 public transient List<Service_Request__c> SBUBGASrs=new List<Service_Request__c>();
  public transient List<Service_Request__c> SBUBGASrsAll=new List<Service_Request__c>();

 public transient List<Service_Request__c> SBUDSSrs=new List<Service_Request__c>();
  public transient List<Service_Request__c> SBUDSSrsAll=new List<Service_Request__c>();

 public Id s;
 public Id SRID {get;set;}
 public string  Strname{get; set;} 
//dev2 modified change
    public CustomerTop10IssuesClass(ApexPages.StandardController controller) {

     scroll = System.currentPageReference().getParameters().get('scroll');

    Schema.DescribeSObjectResult SerreqObj = Schema.SObjectType.Service_Request__c;

    Map<String,Schema.RecordTypeInfo> serrtMapByName = SerreqObj.getRecordTypeInfosByName();

    Schema.RecordTypeInfo serrtByName =  serrtMapByName.get('SR Lean');
    ID serRecTypeid =  serrtByName.getRecordTypeId(); 
     s= ApexPages.CurrentPage().getParameters().get('accid');
     Strname= ApexPages.CurrentPage().getParameters().get('strsbu');
     Strname =Strname + '_First_Drill_Down';
     //s='001180000095OM3';

     //TOPSrs=[SELECT id,Name,Atr__c,Subject__c,Status__c,SBU__c,Account_Name__r.Name,Account_Name__c,Top_Technical_Issue__c,Problem_Description__c,Status_Resolution__c,Escalation_Tier__c,Complexity_Level__c,Customer_Due_Date__c,VOC_Card_Numb__r.Survey_Origin__c,Days_Past_Due__c,Function_Responsible__c,SR_is_Past_Due__c,VOC_Card_Numb__r.Account_Name__c,VOC_Card_Numb__r.Account__c FROM Service_Request__c where (Account_Name__c=:s AND (Status__c='Open' AND Top_Technical_Issue__c=true))];
      //system.debug('hi1'+TOPSrs);
      TOPSrsAll=[SELECT id,Owner.name,Days_Past_Due_Date_0_7__c,Name,Atr__c,Subject__c,Status__c,SBU__c,Show_on_Dashboard__c,Account_Name__r.Name,Account_Name__c,Top_Technical_Issue__c,Problem_Description__c,Status_Resolution__c,Escalation_Tier__c,Complexity_Level__c,Customer_Due_Date__c,VOC_Card_Numb__r.Survey_Origin__c,Days_Past_Due__c,Function_Responsible__c,SR_is_Past_Due__c,VOC_Card_Numb__r.Account_Name__c,VOC_Card_Numb__r.Account__c FROM Service_Request__c where ( Account_Name__c=:s AND (Status__c='Open' OR Status__c='Monitor')) ];
    
    if(TOPSrsAll.size()>0)
         {
          for(Service_Request__c f:TOPSrsAll)
          {
          if(f.Show_on_Dashboard__c==True)
          {
            TOPSrs.add(f);
            system.debug('hi1'+TOPSrs);
            }
            }
            }
   // SBUSrs=[SELECT id,Name,Atr__c,Subject__c,Status__c,SBU__c,Account_Name__r.Name,Account_Name__c,Top_Technical_Issue__c,Problem_Description__c,Status_Resolution__c,Escalation_Tier__c,Complexity_Level__c,Customer_Due_Date__c,VOC_Card_Numb__r.Survey_Origin__c,Days_Past_Due__c,Function_Responsible__c,SR_is_Past_Due__c,VOC_Card_Numb__r.Account_SBU__c,VOC_Card_Numb__r.Account_Name__c,VOC_Card_Numb__r.Account__c FROM Service_Request__c where (Status__c='Open' AND Top_Technical_Issue__c=true)];
    SBUSrsAll=[SELECT id,Owner.name,Days_Past_Due_Date_0_7__c,Name,Atr__c,Subject__c,Status__c,SBU__c,Show_on_Dashboard__c,Account_Name__r.Name,Account_Name__c,Top_Technical_Issue__c,Problem_Description__c,Status_Resolution__c,Escalation_Tier__c,Complexity_Level__c,Customer_Due_Date__c,VOC_Card_Numb__r.Survey_Origin__c,Days_Past_Due__c,Function_Responsible__c,SR_is_Past_Due__c,VOC_Card_Numb__r.Account_SBU__c,VOC_Card_Numb__r.Account_Name__c,VOC_Card_Numb__r.Account__c FROM Service_Request__c where (Status__c='Open' OR Status__c='Monitor')];

     if(SBUSrsAll.size()>0)
     {
         for(Service_Request__c f: SBUSrsAll)
         {
             if(f.SBU__c=='ATR' && f.Show_on_Dashboard__c==True)
             {
             SBUATRSrs.add(f);
             }
             if(f.SBU__c=='BGA' && f.Show_on_Dashboard__c==True)
             { 
             SBUBGASrs.add(f);
                          
             }
             if(f.SBU__c=='D&S' && f.Show_on_Dashboard__c==True)
             { 
             SBUDSSrs.add(f);
                        
             }
         }
      }
        if(SBUSrsAll.size()>0)
     {
         for(Service_Request__c f:SBUSrsAll)
         {
             if(f.SBU__c=='ATR')
             {
             SBUATRSrsAll.add(f);
             }
             if(f.SBU__c=='BGA')
             { 
             SBUBGASrsAll.add(f);
             }
             if(f.SBU__c=='D&S')
             { 
             SBUDSSrsAll.add(f);
             }
         }
      }
         
     
    }

 public List<Service_Request__c> getSRRecords()
 {
system.debug('hi2'+TOPSrs);
 return  TOPSrs;
 }
  public List<Service_Request__c> getSRRecordsAll()
 {
system.debug('hi3'+TOPSrsAll);
 return  TOPSrsAll;
 }
 
 public List<Service_Request__c> getATRSRRecords()
 {
   return SBUATRSrs;
 }
  public List<Service_Request__c> getATRSRRecordsAll()
 {
   return SBUATRSrsAll;
 }
  public List<Service_Request__c> getBGASRRecords()
  {
   return SBUBGASrs;
  }
  public List<Service_Request__c> getBGASRRecordsAll()
  {
   return SBUBGASrsAll;
  }
  public List<Service_Request__c> getDSSRRecords()
  {
   return SBUDSSrs;
  }
  public List<Service_Request__c> getDSSRRecordsAll()
  {
   return SBUDSSrsAll;
  }
  public String getscroll()
  {
   return scroll;
  }
   
 public PageReference SRredirect()  
    {
        String fullRecordURL =  label.servernameurl + '/' + SRID;
        //String fullRecordURL = ApexPages.currentPage().getParameters().get('id');
        system.debug('fullRecordURL' +fullRecordURL);
        PageReference pageRef = new PageReference(fullRecordURL );
                system.debug('fullRecordURL' +fullRecordURL);
                pageRef.setRedirect(true);
        return pageRef; 
    }
}