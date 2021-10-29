public with sharing class SeeDetailPageCtrlExcelExport1 {

public List<Case> atsCases{get;set;}
public List<Service_Request__c> sr{get;set;}
public List<Planned_Meeting__c> plmtng{get;set;}
public String param;
public String[] paramString;
public String ActivityValue{get;set;}
public String OEM;
public String OpenClosedValue;
public String FromDateValue;
public String ToDateValue;
public String SBU;
public String Enterprise;
public String Region;
public String AircraftType;
public String AccountName;
public String GTOGroup;
public String CaseOEM ; 
public String NSS ; 
public String PartNumber;
public String ageMin;
public String ageMax;
public String OtherCasemetrics;
public Set<String> SRIdList;
public String Detail{get;set;}

public SeeDetailPageCtrlExcelExport1(){
    
  //  try{    
       Detail='Detail Report';
       param= String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('param1'));
       if (param != null && param != '')
            paramString=param.split('\\_');
        
        if( paramString.size() > 0)
            ActivityValue    = paramString[0];    //activity
        
        if(ActivityValue!=null &&  ActivityValue=='SR')  {
        
            if(paramString != null && paramString.size() == 11){
                SBU              = paramString[1];    //SBU
                OpenClosedValue  = paramString[2];   //status  
                Enterprise       = paramString[3];    //Enterprise
                Region           = paramString[4];    //Region
                AircraftType     = paramString[5];     //AircraftType
                AccountName      = paramString[6];   //Account Name
                PartNumber       = paramString[7];   //PartNumber   
                FromDateValue    = paramString[8];   //from date
                ToDateValue      = paramString[9];    //to date 
                OEM              = paramString[10];   //OEM
                if(OpenClosedValue!='Both')
                createQueryForServiceRequest();
                if(OpenClosedValue=='Both'){
                    OpenClosedValue  = 'Open';
                    createQueryForServiceRequest();
                    List<Service_Request__c> sr1 = new List<Service_Request__c>(sr);
                    sr.clear();
                    OpenClosedValue  = 'Closed';
                    createQueryForServiceRequest();
                    sr.addAll(sr1); 
                }
            }
           
                
                System.debug('**method calling sr*');
        }
        else if(ActivityValue =='PM')
        {
            if( paramString.size() == 7){
                SBU              = paramString[1];    //SBU 
                GTOGroup         = paramString[2];     //GTO (owner manager for ATS,DTS,EPS)  
                OpenClosedValue  = paramString[3];   //status 
                AccountName      = paramString[4];   //Account Name
                FromDateValue    = paramString[5];   //from date
                ToDateValue      = paramString[6];    //to date
                createQueryForPlannedMeeting();           
            }  
            
          System.debug('**method calling planned meeting*');
        }        
        else
        {          
            if(ActivityValue!=null &&  ((ActivityValue=='ACS') ||  (ActivityValue=='DCS'))){   
            system.debug('**'+paramString.size());
            system.debug('**'+paramString);             
                if( paramString.size() == 14){
                    SBU              = paramString[1];    //SBU 
                    OpenClosedValue  = paramString[2];   //status 
                    AccountName      = paramString[3];   //Account Name
                    FromDateValue    = paramString[4];   //from date
                    ToDateValue      = paramString[5];    //to date 
                    OtherCasemetrics = paramString[6];
                    Enterprise       = paramString[7];    //Enterprise
                    Region           = paramString[8];    //Region
                    AircraftType     = paramString[9];     //AircraftType
                    OEM              = paramString[10];
                    PartNumber       = paramString[11];   //PartNumber
                    ageMin       = paramString[12];   //PartNumber
                    ageMax       = paramString[13];   //PartNumber
                    createQueryForCase();
               }
                  
              
            }
        }
    /*}
    catch(exception e){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,e.getMessage()));
    }*/
    }
        
  public void createQueryForServiceRequest(){
   // try{
        Detail ='Service Request '+Detail;
        String searchQuery ='SELECT Id,name,Subject__c ,Status__c,Account_Name__c,Atr__c,ATR_checkbox__c,BGA__c,Complexity_Level__c,Created_Date__c,Customer_Due_Date__c,Date_Closed__c,Date_Monitor__c,Delay_Reason__c,D_S__c,Enterprise__c,OEMs_Affected__c,Open_SR_Age__c,OwnerName__c,Owner_Manager__c,SR_age_w_o_Monitor_time__c,SR_SBU__c,Supported_Products__c FROM Service_Request__c where '; 
        SRIdList = new Set<String>();        
        if(OEM!=null && OEM!='' && OEM!='000000000000000' && OEM!='null'){
            List<Key_Affected_OEMs_Operators__c> keyList =[SELECT Service_Request__c FROM Key_Affected_OEMs_Operators__c where account_name__c =:OEM and Service_Request__c!=null ];
            for(Key_Affected_OEMs_Operators__c key : keyList){
                SRIdList.add(key.Service_Request__c);
            }
             searchQuery = searchQuery+' ID in:SRIdList and';
        }
        if(FromDateValue!=null && FromDateValue!=''){        
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
        if(Region!=null && Region!='' && Region!='Global'){
              String RegionField=' ';
              if(Region=='am'){
                RegionField='americas';              
              }
              if(Region=='em'){
                RegionField='EMAI';             
              }
              if(Region=='ap'){
                RegionField='APAC';              
              }
              searchQuery=searchQuery+' Region__c includes (\''+RegionField+'\') and';
        }             
        if(AircraftType!=null && AircraftType!='' && AircraftType!='000000000000000')
            searchQuery=searchQuery+' Aircraft_Type__c=\''+AircraftType+'\' and';
        if(AccountName!=null && AccountName!='' && AccountName!='000000000000000')
            searchQuery=searchQuery+' Account_Name__c=\''+AccountName+'\' and';        
        if(PartNumber!=null && PartNumber!='')
            searchQuery=searchQuery+' Product_Number__c=\''+PartNumber+'\' and ';
            searchQuery =searchQuery + ' OwnerId__r.Manager.EPS__c=true';            
            sr =Database.query(searchQuery);            
    /*}catch(exception e){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,e.getMessage()));
    } */  
    }
    
    public void createQueryForPlannedMeeting(){
     //   try{
         Detail ='Planned Meeting '+Detail;
        String searchQuery = 'SELECT AccountSBU__c,Account_Name__c,Attendees__c,Completed_Date__c,Expected_Date__c,Hours_Spent__c,Name,Owner_Name__c,Planned_Meeting_Type__c,RecordTypeId FROM Planned_Meeting__c where RecordTypeId = \'012a0000001ZMoQ\' and Owner_Name__r.Profile.Name like \'%GTO%\' and '; //  Replaced Owner_Profile__c like \'%GTO%\' 
        if(SBU!=null && SBU!='' && SBU!='All')
            searchQuery=searchQuery+' AccountSBU__c=\''+SBU+'\' and';        
        if(OpenClosedValue == 'Expected' || OpenClosedValue == 'Both')
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
         
        if(AccountName!=null && AccountName!='' && AccountName!='000000000000000')
            searchQuery=searchQuery+' Account_Name__c=\''+AccountName+'\' and';        
        
        if(GTOGroup=='ATS')
            searchQuery =searchQuery + ' Owner_Name__r.Manager.ATS__c=true';
        if(GTOGroup=='DTS')
            searchQuery =searchQuery + ' Owner_Name__r.Manager.DTS__c=true';
        if(GTOGroup=='EPS')
            searchQuery =searchQuery + ' Owner_Name__r.Manager.EPS__c=true';
        if(GTOGroup=='ALL')    
        searchQuery=searchQuery.substring(0,searchQuery.length()-3); //remove last and
    
        plmtng=Database.query(searchQuery);
   /* }catch(exception e){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,e.getMessage()));
    }*/ 
   
}

  public void createQueryForCase(){
   // try{    
        Detail ='Case '+Detail;
        System.debug('**createQueryForCase*');
        String searchQuery = 'SELECT CaseNumber,Subject,Case_Subject__c,Description,OwnerName__c ,Account_Name__c,Account_Type__c,Age_Custom_in_Hours__c,Age_in_Hours__c,Age__c,Resolution_Tool__c,Resolution__c,Platform__c,CreatedDate,ClosedDate,First_Call_Resolution__c,Origin,Part_Number__c,Sub_Class__c,Supported_Products__c,Owner_Manager__c,Detail_Class__c,User_VN_Name__c FROM Case where RecordTypeId =\'01230000000ZJvU\' and';
        if(AccountName!=null && AccountName!='' && AccountName!='000000000000000')
            searchQuery=searchQuery+' Account_Name__c=\''+AccountName+'\' and';
        System.debug('**searchQuery *'+searchQuery);
        
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
        if(OtherCasemetrics =='FCR')
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
        if(OEM!=null && OEM!='')
            searchQuery=searchQuery+' Aircraft_Type__r.OEM_Name__r.Name LIKE \'%'+OEM+'%\' and';        
        if(PartNumber!=null && PartNumber!='')
            searchQuery=searchQuery+' Product_Part_Number__c =\''+PartNumber+'\' and';
        
        if(ageMin!=null && ageMax!=null && ageMax!='0' && ageMax!='undefined' && ageMin!='undefined')
        {
            if(OpenClosedValue == 'Closed')
            {                
                    searchQuery=searchQuery+' Age_Custom_in_Hours__c >= '+ageMin+' and Age_Custom_in_Hours__c <= '+ageMax+' and'; 
            }
            else if(OpenClosedValue == 'Open' || OpenClosedValue == 'On Hold'){             
                searchQuery=searchQuery+' Age_in_Hours__c >= '+ageMin+' and Age_in_Hours__c <= '+ageMax+' and'; 
            }
        }
            
         if(ActivityValue.contains('ACS'))
         searchQuery =searchQuery + ' OwnerId__r.Manager.ATS__c=true';
         if(ActivityValue.contains('DCS'))
         searchQuery =searchQuery + ' OwnerId__r.Manager.DTS__c=true';
         List<String> statusValues;    
        if(OpenClosedValue =='Open'){
            statusValues = new List<String>{'Open','Re-Open'};
            searchQuery=searchQuery+' and Status in: statusValues ';
            }
        else if(OpenClosedValue =='Closed'){
            statusValues = new List<String>{'Done','Re-Closed','Tech Issue-SR Assigned','Discard','Cancelled'};
            searchQuery=searchQuery+' and Status  in: statusValues ';
            }
        else if(OpenClosedValue =='On Hold'){
            searchQuery=searchQuery+' and Status  = \'On Hold\' ';
        }


        
        System.debug('**searchQuery *'+searchQuery);
        atsCases=Database.query(searchQuery);
     /*   }catch(exception e){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,e.getMessage()));
    } */
  }

}