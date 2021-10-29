public without sharing class BGATechserre {

    public Contact con{get;set;}
    public List<Contact> lcon{get;set;}
    Public Boolean tableflag{get;set;}
    Public Boolean MSGflag{get;set;}
    public PageReference p;
    public Contact cn{get;set;}

    
    
    public String TollFree1_IntlNo{get;set;}
    public String TollFree1_USNo{get;set;}
    public String TollFree2_IntlNo{get;set;}
    public String TollFree2_USNo{get;set;}
    
    // AOG
    public String EmailAog{get;set;}
    public String AOG_USNo{get;set;}
    public String AOG_IntlNo{get;set;}
    
    //DirectAccess AOG
    public String DA_EmailAog{get;set;}
    public String DA_AOG_USNo{get;set;}
    public String DA_AOG_IntlNo{get;set;}
    
    
    // Technical Support - TOC
    public String EmailTOC{get;set;}
    public String Tech_TOC_USNo{get;set;}
    public String Tech_TOC_IntlNo{get;set;}
    
    // Technical Support - INDS
    public String Tech_INDS_Email{get;set;}
    public String Tech_INDS_Web{get;set;}
    public String Tech_INDS_USNo{get;set;}
    public String Tech_INDS_IntlNo{get;set;}
    
    // Tech Support Contact Email
    public String DA_TS_Email_Contact{get;set;}
    
    // Business & Sales Support - DB
    public String BS_DB_Email{get;set;}
    public String BS_DB_Web{get;set;}
    public String BS_DB_USNo{get;set;}
    public String BS_DB_IntlNo{get;set;}

    // Business & Sales Support - INDS
    public String BS_INDS_Email{get;set;}
    public String BS_INDS_Web{get;set;}
    public String BS_INDS_USNo{get;set;}
    public String BS_INDS_IntlNo{get;set;}

    // Pilot Support
    public String Pilot_Email{get;set;}
    public String Pilot_USNo{get;set;}
    public String Pilot_IntlNo{get;set;}
    
    //Direct Access Pilot Support
    public String DA_Pilot_Email{get;set;}
    public String DA_Pilot_USNo{get;set;}
    public String DA_Pilot_IntlNo{get;set;}

    // Pilot Support - GDC
    public String Pilot_GDC_Email{get;set;}
    public String Pilot_GDC_Web{get;set;}
    public String Pilot_GDC_USNo{get;set;}
    public String Pilot_GDC_IntlNo{get;set;}
    
    // Pilot Support - GDC Flight
    public String Pilot_GDCFlight_Email{get;set;}
    public String Pilot_GDCFlight_USNo{get;set;}
    public String Pilot_GDCFlight_IntlNo{get;set;}
    
    
    // Parts Support
    public String Parts_Email{get;set;}
    public String Parts_USNo{get;set;}
    public String Parts_IntlNo{get;set;}
    public String Parts_Web{get;set;}
    
    //Quick Links & Apps
    public String My_Aerospace{get;set;}
    public String My_Service_Services{get;set;}
    public String Technical_Publics{get;set;}
    public String Business_Avition_Apps{get;set;}
    public String Global_Customer_Committee{get;set;}
    public String Pilotgatway{get;set;}
    public String Tsscommunity{get;set;}
    
    // Direct Access Go Direct
    
    public String DA_GDS_Email{get;set;}
    public String DA_GDS_USNo{get;set;}
    public String DA_GDS_IntlNo{get;set;}
    
    public String DA_TS_Email {get;set;}
    public String DA_TS_USNo {get;set;}          
    public String DA_TS_IntlNo {get;set;}
    public String DA_TS_Country {set;get;}
    public String DA_TS_State {get;set;}
     
    public BGATechserre(ApexPages.StandardController controller) {
        con= New Contact();
        tableflag=false;
        MSGflag=false;
        system.debug('testhema'+DA_TS_Country);
          Map<String,BGAMobile__c> CustomSettingphone = BGAMobile__c.getall();
          Map<string,DirectAccessInformation__c> DirectAccessCustomSetting =DirectAccessInformation__c.getall();
          
          // Toll free Numbers
          TollFree1_IntlNo=CustomSettingphone.get('BGA_TollFree1').PhoneNo__c;
          TollFree1_USNo=CustomSettingphone.get('BGA_TollFree1').PrimaryNoUSA__c;
          TollFree2_IntlNo=CustomSettingphone.get('BGA_TollFree2').PhoneNo__c;
          TollFree2_USNo=CustomSettingphone.get('BGA_TollFree2').PrimaryNoUSA__c;
          
          // AOG Page
          EmailAog=CustomSettingphone.get('BGA_AOG').BGAMEmail__c;
          AOG_USNo=CustomSettingphone.get('BGA_AOG').PrimaryNoUSA__c;
          AOG_IntlNo=CustomSettingphone.get('BGA_AOG').PhoneNo__c;
          
          //Technical Support - TOC Page
          EmailTOC=CustomSettingphone.get('BGA_Tech_TOC').BGAMEmail__c;
          Tech_TOC_USNo=CustomSettingphone.get('BGA_Tech_TOC').PrimaryNoUSA__c;
          Tech_TOC_IntlNo=CustomSettingphone.get('BGA_Tech_TOC').PhoneNo__c;
          
          //Technical Support - INDS Page
          Tech_INDS_Email=CustomSettingphone.get('BGA_Tech_INDS').BGAMEmail__c;
          Tech_INDS_Web=CustomSettingphone.get('BGA_Tech_INDS').BGAMweb__c;          
          Tech_INDS_USNo=CustomSettingphone.get('BGA_Tech_INDS').PrimaryNoUSA__c;
          Tech_INDS_IntlNo=CustomSettingphone.get('BGA_Tech_INDS').PhoneNo__c;

          // Business Sales - DB Page
          BS_DB_Email=CustomSettingphone.get('BGA_BS_DB').BGAMEmail__c;
          BS_DB_Web=CustomSettingphone.get('BGA_BS_DB').BGAMweb__c;          
          BS_DB_USNo=CustomSettingphone.get('BGA_BS_DB').PrimaryNoUSA__c;
          BS_DB_IntlNo=CustomSettingphone.get('BGA_BS_DB').PhoneNo__c;
          
          // Business Sales - INDS Page
          BS_INDS_Email=CustomSettingphone.get('BGA_BS_INDS').BGAMEmail__c;
          BS_INDS_Web=CustomSettingphone.get('BGA_BS_INDS').BGAMweb__c;          
          BS_INDS_USNo=CustomSettingphone.get('BGA_BS_INDS').PrimaryNoUSA__c;
          BS_INDS_IntlNo=CustomSettingphone.get('BGA_BS_INDS').PhoneNo__c;
          
          // Pilot Support - Home Page
          Pilot_Email=CustomSettingphone.get('BGA_Pilot_Home').BGAMEmail__c;
          Pilot_USNo=CustomSettingphone.get('BGA_Pilot_Home').PrimaryNoUSA__c;
          Pilot_IntlNo=CustomSettingphone.get('BGA_Pilot_Home').PhoneNo__c;
          
          // Pilot Support - GDC Page
          Pilot_GDC_Email=CustomSettingphone.get('BGA_Pilot_GDC').BGAMEmail__c;
          Pilot_GDC_Web=CustomSettingphone.get('BGA_Pilot_GDC').BGAMweb__c;          
          Pilot_GDC_USNo=CustomSettingphone.get('BGA_Pilot_GDC').PrimaryNoUSA__c;
          Pilot_GDC_IntlNo=CustomSettingphone.get('BGA_Pilot_GDC').PhoneNo__c;
          
          // Pilot Support - GDC Flight Page
          Pilot_GDCFlight_Email=CustomSettingphone.get('BGA_Pilot_GDCFlight').BGAMEmail__c;
          Pilot_GDCFlight_USNo=CustomSettingphone.get('BGA_Pilot_GDCFlight').PrimaryNoUSA__c;
          Pilot_GDCFlight_IntlNo=CustomSettingphone.get('BGA_Pilot_GDCFlight').PhoneNo__c;
          
          
          // Parts Support Page
          Parts_Email=CustomSettingphone.get('BGA_PartsSupport').BGAMEmail__c;
          Parts_Web=CustomSettingphone.get('BGA_PartsSupport').BGAMweb__c;
          Parts_USNo=CustomSettingphone.get('BGA_PartsSupport').PrimaryNoUSA__c;
          
          
          Parts_IntlNo=CustomSettingphone.get('BGA_PartsSupport').PhoneNo__c;
          
           //Quick Links & Apps
          My_Aerospace = CustomSettingphone.get('Quick_MyAerospace').BGAMweb__c;
          My_Service_Services = CustomSettingphone.get('Quick_MyAerospaceServices').BGAMweb__c;
          Technical_Publics = CustomSettingphone.get('Quick_TechnicalPublications').BGAMweb__c;
          Business_Avition_Apps = CustomSettingphone.get('Quick_BusinessAviationApps').BGAMweb__c;
          Global_Customer_Committee =CustomSettingphone.get('Quick_GlobalCustomerCommittee').BGAMweb__c;
          Pilotgatway =CustomSettingphone.get('Quick_Pilotgatway').BGAMweb__c;
          Tsscommunity =CustomSettingphone.get('Quick_Tsscommunity').BGAMweb__c;
          
          // Direct Access AOG
          
          DA_EmailAog=DirectAccessCustomSetting.get('DirectAccess_AOG').Email__c;
          DA_AOG_USNo=DirectAccessCustomSetting.get('DirectAccess_AOG').PrimaryNoUSA__c;
          DA_AOG_IntlNo=DirectAccessCustomSetting.get('DirectAccess_AOG').PhoneNo__c;
          
          // Direct Access Pilot Support
          
          DA_Pilot_Email=DirectAccessCustomSetting.get('DirectAccess_PilotSupport').Email__c;
          DA_Pilot_USNo=DirectAccessCustomSetting.get('DirectAccess_PilotSupport').PrimaryNoUSA__c;
          DA_Pilot_IntlNo=DirectAccessCustomSetting.get('DirectAccess_PilotSupport').PhoneNo__c;
          
          // Direct Access Go Direct Service
          DA_GDS_Email = DirectAccessCustomSetting.get('DirectAccess_GoDirect').Email__c;
          DA_GDS_USNo = DirectAccessCustomSetting.get('DirectAccess_GoDirect').PrimaryNoUSA__c;
          DA_GDS_IntlNo = DirectAccessCustomSetting.get('DirectAccess_GoDirect').PhoneNo__c;
          
          // Direct Access Technical expert
          DA_TS_Email = DirectAccessCustomSetting.get('DirectAccess_TechnicalExpert').Email__c;
       /*   DA_TS_USNo = DirectAccessCustomSetting.get('DirectAccess_TechnicalExpert').PrimaryNoUSA__c;
          DA_TS_IntlNo = DirectAccessCustomSetting.get('DirectAccess_TechnicalExpert').PhoneNo__c;*///10Jan2020:Commented for Regional Support Number
         
       
    }    
    //10Jan2020:added below for Regional Support Number - start
    @RemoteAction
   Static public String getPhoneValue(String Country,String State)
   {
    	Map<string,DirectAccessInformation__c> phcodemap = DirectAccessInformation__c.getAll();
		//System.debug('ISO Code: '+phcode.get(Type).PhoneNo__c);
		String phphoneno = phcodemap.get(Country).PhoneNo__c;
      return phphoneno;
   }  
    //10Jan2020:added below for Regional Support Number - end
    public void getContact() {
         
        String Country='%'+con.Country_Name__c+'%';
        String State='%'+con.State_Code__c+'%';
         
        lcon=[Select Name,Phone,Country_Name__c,State_Code__c from Contact where Country_Name__c like : Country OR State_Code__c like : State];
     
        if(lcon.size()>0) {
             tableflag=true;
             MSGflag=false;
        }
        else {
           MSGflag=true;
           tableflag=false;
        }
    }      
}