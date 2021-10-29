/*************************Change Log*************************
SR#401936
- Removed the filter for the Technical cases(After selecting any option for hours 4/24/48, displays all the records)
- Flash new version chnages
- 3/27/2014 - Adding blank location('') to mysites to fix production issue INC000005627932.
**************************************************************/
public class AOGRealTimeReport{
List<Case> cases= new List<Case>();
List<Case> cases4= new List<Case>();
List<Case> cases24= new List<Case>();
List<case> cases48 = new List<case>();
List<Case> cases4above72= new List<Case>();
List<Case> cases24above72= new List<Case>();
List<CaseHistory> caseHis= new List<CaseHistory>();
list<AccountTeamMember> actmrole = new list<AccountTeamMember>();
public string acuser {get; set;}
List<Id> RecId = new List<Id>();
List<Id> TechId = new List<Id>();
List<Id> NonTechId = new List<Id>();
List<Id> AllIds = new List<Id>();
public Map<Id,Decimal> flightout{get;set;}

integer count=0,count4=0,count24=0,count48=0,count4above72=0,count24above72=0,count48above72=0,totalcount=0,sla4hrint=0,sla24hrint=0,sla48hrint=0,total72=0,
count4below72=0,count24below72=0,count48below72=0,countclosed=0;
decimal sla4hr,sla24hr,sla48hr;
String currentId;
String serverUrl;
String scroll;
Set<String> MySBUs = new Set<String>{'BGA', 'D&S', 'ATR', 'Intercompany','Unknown'};
String SelectedSBU;
//Added by dhivya starts
Set<String> Substat= new Set<String>{'Business Hold','ACT-ISC Divest/Sprsde/Obsolete','Accelerated Repair','AWB Sent','ACT-ISC Expedite date','ACT-ISC Recovery date','ACT WTY/HAPP/MSP','Credit Hold','Customer Account Setup','Customer Hold','Export Hold','>Hyper Consumption','Initial Provisioning Hold','Integrated Supply Chain Hold','MTO','Order Placed','Order Processed','Pricing Hold','Quality Hold','Repair Expedite','Stockout','Work Out of Repair (WOR)'};
String SelectedSub;
//Added by dhivya Ends
//Added Mysite for SR#448821
Set<string> MySites =  new Set<String> {'','Airworks India Engineering Pvt Ltd','Ametek','Anniston Repair Center','AOA Apparatebau Gauting','Australia (Sydney) Support Center','Avemex','Bournemouth','C/O Danzas Aerospace','Cessna/Kansas','Cessna/Le Bourget','CEVA/Kansas City','Dallas Support Center','Execujet Middle East','Execujet South Africa','France (Toulouse) Support Center','Gables','Greer Repair Center','Jet Avn/Basel','Jet Avn/Geneva','Jet Avn/Zurich','Meridian Jet Center','Minneapolis Support Center','Netjets','Ohio Support Center','Olathe Repair','Olathe Spares','Otto Instruments','Phoenix Deer Valley Dist.Center','Phoenix Deer Valley OEM','Phoenix Sky Harbor Dist.Center','Phoenix Sky Harbor Repair','Prince Edward Island','Raunheim','Redmond','Rocky Mount','Sarasota','Savannah','Renton','Shanghai Repair','Singapore Support Center','South Bend','T.A.M./Brazil','Tempe Repair','Tempe Spares','Teterboro (Meridian)','Toronto','Torrance','Tucson Repair Center','Basingstoke','Hemel Hempstead','Urbana Repair','Wichita Support Center','Penang, Malaysia','Aviall Services','Yeovil Repair','Lufthansa','Ottawa','Toronto Spares','Torrance Spares','Tucson Spares','Tulsa Spares','Urbana Spares','Yeovil Spares','Phoenix Grant St','Phoenix OEM','Phoenix Repair','Jet Aviation/Basel','Clearwater','Albuquerque','Century/Lanseria','CEVA/Paris'};
String SelectedSite;
Set<String> MyRegions = new Set<String>{'Americas', 'Asia/Pacific Rim', 'Europe/MiddleEast/Africa/India'};
String SelectedReg;
String SelectedType;
String QueryString;


DateTime todaysTime=System.now();
integer year = todaysTime.year();
integer month = todaysTime.month();
integer day = todaysTime.day();
Datetime myDate = datetime.newInstance(year, month, day, 6,0, 0);
//DateTime FlightOut;
Boolean ontest;

public Boolean getontest(){
    return ontest;
}

public String getQueryString(){
   return URL.getCurrentRequestUrl().getQuery();
}
public String setvariableasd(String newVar){/* newVar = variable to set or replace*/
   String[] splitVar;
   String temp = URL.getCurrentRequestUrl().getQuery();
   
   splitVar = newVar.split('=',2);
   
   if( !temp.contains(splitVar[0]+'=') ){
       temp += '&'+newVar;
   }
   else{
       temp.replaceFirst('\b'+splitVar[0]+'=\b[a-zA-Z0-9_%]*',newVar);
   }
      
   return temp;
}

public AOGRealTimeReport() {
    for(RecordType r : [select Id from RecordType where SobjectType = 'Case' and (DeveloperName = 'Technical_Issue')]){
        TechId.add(r.Id);
    }
    for(RecordType r : [select Id from RecordType where SobjectType = 'Case' and (DeveloperName = 'AOG' or DeveloperName = 'Exchange')]){//added for AOG/Spex Case Record Type Split
        NonTechId.add(r.Id);
    }
    for(RecordType r : [select Id from RecordType where SobjectType = 'Case' and (DeveloperName = 'Technical_Issue' or DeveloperName = 'AOG' or DeveloperName = 'Exchange')]){//added for AOG/Spex Case Record Type Split
        AllIds.add(r.Id);
    }
    
    ontest = URL.getSalesforceBaseUrl().toExternalForm().contains('qa'); 
    
    currentId = System.currentPageReference().getParameters().get('Id');
     
    scroll = System.currentPageReference().getParameters().get('scroll');
    
    if( SelectedType == null) SelectedType = System.currentPageReference().getParameters().get('type');
    
    if( SelectedType == 'Technical' )RecId = TechId;
    else if( SelectedType == 'NonTechnical' )RecId = NonTechId;
    else RecId = AllIds;
    
    if(SelectedSBU == null) SelectedSBU = System.currentPageReference().getParameters().get('sbu');
    if(SelectedSBU != null && SelectedSBU != 'All'){
        MySBUs.clear();
        MySBUs.add(SelectedSBU);
    }
    //Added bu Dhivya Starts
    if(Selectedsub == null) {
    Selectedsub = System.currentPageReference().getParameters().get('sub');
    }
    system.debug('Subbbbbb'+selectedsub);
    if(Selectedsub != null && Selectedsub != 'All'){
        Substat.clear();
        Substat.add(Selectedsub);
    }
    //Added by Dhivya Ends
    //Code Added  Mysite for SR#448821
    if(SelectedSite == null) SelectedSite = System.currentPageReference().getParameters().get('site');
    if(SelectedSite != null && SelectedSite != 'All'){
        MySites.clear();
        MySites.add(SelectedSite);
    }
    
    if(SelectedReg == null) SelectedReg = System.currentPageReference().getParameters().get('region');
    if(SelectedReg != null && SelectedReg != 'All'){
        MyRegions.clear();
        MyRegions.add(SelectedReg);
    }      
     
}

public PageReference SetFilters(){    
    return null;
}

/*public String getTemp(){
    return Temp;
}*/
/* TYPE */
public String getSelectedType(){
    return SelectedType;
}
public void setSelectedType(String SelType){
    this.SelectedType = SelType;
}
public List<SelectOption> getAllTypes(){
    List<SelectOption> options = new List<SelectOption>();  
    options.add( new SelectOption('All','All Types') );   
    options.add( new SelectOption('Technical','Technical') );    
    options.add( new SelectOption('NonTechnical','Non-Technical') );
    return options;
}
/* TYPE */

/* SBU */
public String getSelectedSBU(){
    return SelectedSBU;
}
public void setSelectedSBU(String SBUs){
    this.SelectedSBU = SBUs;
}
public List<SelectOption> getMySBUs(){
    List<SelectOption> options = new List<SelectOption>();  
    options.add( new SelectOption('All','All SBU') );   
    options.add( new SelectOption('BGA','BGA') );    
    options.add( new SelectOption('D&S','D&S') );
    options.add( new SelectOption('ATR','ATR') );
    options.add( new SelectOption('Intercompany','Intercompany') );
    return options;
}
/* SBU */


//Added by Dhivya Starts
/*      Sub-status      */

public String getSelectedSub(){
    return SelectedSub;
}
public void setSelectedSub(String Subs){
    this.SelectedSub = Subs;
}
public List<SelectOption> getMySubs(){
    List<SelectOption> options = new List<SelectOption>();  
    options.add( new SelectOption('All','All Sub-Status') );   
    options.add( new SelectOption('Accelerated Repair','Accelerated Repair') );    
    options.add( new SelectOption('AWB Sent','AWB Sent') );
    options.add( new SelectOption('ACT-ISC Divest/Sprsde/Obsolete','ACT-ISC Divest/Sprsde/Obsolete') );
    options.add( new SelectOption('ACT-ISC Expedite date','ACT-ISC Expedite date') );
    options.add( new SelectOption('ACT-ISC Recovery date','ACT-ISC Recovery date') );
    options.add( new SelectOption('ACT WTY/HAPP/MSP','ACT WTY/HAPP/MSP') );
    options.add( new SelectOption('Business Hold','Business Hold') );
    options.add( new SelectOption('Credit Hold','Credit Hold') );
    options.add( new SelectOption('Customer Account Setup','Customer Account Setup') );
    options.add( new SelectOption('Customer Hold','Customer Hold') );
    options.add( new SelectOption('Export Hold','Export Hold') );
    options.add( new SelectOption('Hyper Consumption','Hyper Consumption') );
    options.add( new SelectOption('Initial Provisioning Hold','Initial Provisioning Hold') );
    options.add( new SelectOption('Integrated Supply Chain Hold','Integrated Supply Chain Hold') );
    options.add( new SelectOption('MTO','MTO') );
    options.add( new SelectOption('Order Placed','Order Placed') );
    options.add( new SelectOption('Order Processed','Order Processed') );
    options.add( new SelectOption('Pricing Hold','Pricing Hold') );
    options.add( new SelectOption('Quality Hold','Quality Hold') );
    options.add( new SelectOption('Repair Expedite','Repair Expedite') );
    options.add( new SelectOption('Stockout','Stockout') );
    options.add( new SelectOption('Work Out of Repair (WOR)','Work Out of Repair (WOR)') );
    //options.add( new SelectOption('Intercompany','Intercompany') );
    return options;
}
/*      Sub-status      */
//Added by Dhivya Ends


/* REGION */
public String getSelectedReg(){
    return SelectedReg;
}
public void setSelectedReg(String Reg){
    this.SelectedReg = Reg;
}
public List<SelectOption> getMyRegions(){
    List<SelectOption> options = new List<SelectOption>();  
    options.add( new SelectOption('All','All Regions') );   
    options.add( new SelectOption('Americas','Americas') );
    options.add( new SelectOption('Asia/Pacific','Asia/Pacific') );
    options.add( new SelectOption('Europe/MiddleEast/Africa/India','EMEAI') );
    return options;
}
/* REGION */

/* Hardware Ship From Location - SITE for SR#448821 Ends*/
public String getSelectedSite(){
    return SelectedSite;
}
public void setSelectedSite(String Site){
    this.SelectedSite = Site;
}
public List<SelectOption> getMySite(){
    List<SelectOption> options = new List<SelectOption>();  
    options.add( new SelectOption('All','All Site') );   
    options.add( new SelectOption('Airworks India Engineering Pvt Ltd','Airworks India Engineering Pvt Ltd') );
    options.add( new SelectOption('Ametek','Ametek') );
    options.add( new SelectOption('Anniston Repair Center','Anniston Repair Center') );
    options.add( new SelectOption('AOA Apparatebau Gauting','AOA Apparatebau Gauting') );
    options.add( new SelectOption('Australia (Sydney) Support Center','Australia (Sydney) Support Center') );
    options.add( new SelectOption('Avemex','Avemex') );
    options.add( new SelectOption('Bournemouth','Bournemouth') );
    options.add( new SelectOption('C/O Danzas Aerospace','C/O Danzas Aerospace') );
    options.add( new SelectOption('Cessna/Kansas','Cessna/Kansas') );
    options.add( new SelectOption('Cessna/Le Bourget','Cessna/Le Bourget') );
    options.add( new SelectOption('CEVA/Kansas City','CEVA/Kansas City') );
    options.add( new SelectOption('Dallas Support Center','Dallas Support Center') );
    options.add( new SelectOption('Execujet Middle East','Execujet Middle East') );
    options.add( new SelectOption('Execujet South Africa','Execujet South Africa') );
    options.add( new SelectOption('France (Toulouse) Support Center','France (Toulouse) Support Center') );
    options.add( new SelectOption('Gables','Gables') );
    options.add( new SelectOption('Greer Repair Center','Greer Repair Center') );
    options.add( new SelectOption('Jet Avn/Basel','Jet Avn/Basel') );
    options.add( new SelectOption('Jet Avn/Geneva','Jet Avn/Geneva') );
    options.add( new SelectOption('Jet Avn/Zurich','Jet Avn/Zurich') );
    options.add( new SelectOption('Meridian Jet Center','Meridian Jet Center') );
    options.add( new SelectOption('Minneapolis Support Center','Minneapolis Support Center') );
    options.add( new SelectOption('Netjets','Netjets') );
    options.add( new SelectOption('Ohio Support Center','Ohio Support Center') );
    options.add( new SelectOption('Olathe Repair','Olathe Repair') );
    options.add( new SelectOption('Olathe Spares','Olathe Spares') );
    options.add( new SelectOption('Otto Instruments','Otto Instruments') );
    options.add( new SelectOption('Phoenix Deer Valley Dist.Center','Phoenix Deer Valley Dist.Center') );
    options.add( new SelectOption('Phoenix Deer Valley OEM','Phoenix Deer Valley OEM') );
    options.add( new SelectOption('Phoenix Sky Harbor Dist.Center','Phoenix Sky Harbor Dist.Center') );
    options.add( new SelectOption('Phoenix Sky Harbor Repair','Phoenix Sky Harbor Repair') );
    options.add( new SelectOption('Prince Edward Island','Prince Edward Island') );
    options.add( new SelectOption('Raunheim','Raunheim') );
    options.add( new SelectOption('Redmond','Redmond') );
    options.add( new SelectOption('Rocky Mount','Rocky Mount') );
    options.add( new SelectOption('Sarasota','Sarasota') );
    options.add( new SelectOption('Savannah','Savannah') );
    options.add( new SelectOption('Renton','Renton') );
    options.add( new SelectOption('Shanghai Repair','Shanghai Repair') );
    options.add( new SelectOption('Singapore Support Center ','Singapore Support Center ') );
    options.add( new SelectOption('South Bend','South Bend') );
    options.add( new SelectOption('T.A.M./Brazil','T.A.M./Brazil') );
    options.add( new SelectOption('Tempe Repair','Tempe Repair') );
    options.add( new SelectOption('Tempe Spares','Tempe Spares') );
    options.add( new SelectOption('Teterboro (Meridian)','Teterboro (Meridian)') );
    options.add( new SelectOption('Toronto','Toronto') );
    options.add( new SelectOption('Torrance','Torrance') );
    options.add( new SelectOption('Tucson Repair Center','Tucson Repair Center') );    
    options.add( new SelectOption('Basingstoke','Basingstoke') );
    options.add( new SelectOption('Hemel Hempstead','Hemel Hempstead') );
    options.add( new SelectOption('Urbana Repair','Urbana Repair') );
    options.add( new SelectOption('Wichita Support Center','Wichita Support Center') ); 
    options.add( new SelectOption(' Penang,Malaysia','Penang,Malaysia') ); 
    options.add( new SelectOption(' Aviall Services','Aviall Services') ); 
    options.add( new SelectOption(' Yeovil Repair','Yeovil Repair') );
    options.add( new SelectOption(' Lufthansa','Lufthansa') );
    options.add( new SelectOption(' Ottawa','Ottawa') );
    options.add( new SelectOption(' Toronto Spares','Toronto Spares') );
    options.add( new SelectOption(' Torrance Spares','Torrance Spares') );
    options.add( new SelectOption(' Tucson Spares','Tucson Spares') );
    options.add( new SelectOption(' Tulsa Spares','Tulsa Spares') );
    options.add( new SelectOption(' Urbana Spares','Urbana Spares') );
    options.add( new SelectOption(' Yeovil Spares','Yeovil Spares') );
    options.add( new SelectOption(' Phoenix Grant St','Phoenix Grant St') );
    options.add( new SelectOption(' Phoenix OEM','Phoenix OEM') );
    options.add( new SelectOption(' Phoenix Repair','Phoenix Repair') );
    options.add( new SelectOption(' Jet Aviation/Basel','Jet Aviation/Basel') );
    options.add( new SelectOption(' Clearwater','Clearwater') );
    options.add( new SelectOption('Albuquerque','Albuquerque') );
    options.add( new SelectOption('Century/Lanseria','Century/Lanseria') );
    options.add( new SelectOption('CEVA/Paris','CEVA/Paris') );
    return options;
}
/* Hardware Ship From Location - SITE  for SR#448821 Ends*/

public List<Case> getcases(){
//SR#401936 -added condition for Technical cases 
//SR#448821- Added the condition Hardware_Ship_From_Address__c in the query
//CSO Bundle ticket no 16 - Added the Type condition (Type != 'MICAP') in the query.
//Product GBE field is added in Query for the task SCTASK2272727
if(SelectedType == 'Technical'){
    
    cases=[Select Id,AOG_Service_level__c,AOG_Service_Level_Flag__c,X4_Hour_AOG__c,CaseNumber,Account_Name__c,
    Service_Level__c, Sub_Status__c, Age_in_Hours__c, Aircraft_Type__c, Aircraft_Location__c, OwnerName__c,
    lastmodifieddate, Next_Flight_Out_Date__c, AOG_Service_level_Value__c, Aircraft_Type__r.Name,
    Last_Updated_HoursMins__c, Last_Modified_Text__c, Product_Part__c,Product_GBE__c, Hardware_Ship_From_Address__c,
    Product_Description__c, SPEX_Exchange__c, SBU__c,SBU_w2c__c, Case_Record_Type__c, Region__c, AcceleratedRepair__c,Type,
    Classification__c, Subject, Supported_Products__c,Supported_Products__r.name,Owner_Operator_Information__c,CP_CSM__c
    from Case where recordtypeId in :RecId and isClosed=false and status !='Re-Open'
    and AOG__c=True and (SBU_w2c__c IN :MySBUs OR SBU_w2c__c ='') and (sub_status__c IN :SubStat) and (Region__c in :MyRegions) and (Hardware_Ship_From_Address__c in :MySites) and (Type != 'MICAP')
    order by X4_Hour_AOG__c asc, AOG_Service_level_Value__c desc , Age_in_Hours__c desc];
    system.debug('in if----count--->' + cases.size());
}else

if(currentId=='48'){
            cases=[Select Id,AOG_Service_level__c,AOG_Service_Level_Flag__c,X4_Hour_AOG__c,CaseNumber,Account_Name__c,
    Service_Level__c, Sub_Status__c, Age_in_Hours__c, Aircraft_Type__c, Aircraft_Location__c, OwnerName__c,
    lastmodifieddate, Next_Flight_Out_Date__c, AOG_Service_level_Value__c, Aircraft_Type__r.Name,
    Last_Updated_HoursMins__c, Last_Modified_Text__c, Product_Part__c,Product_GBE__c,Hardware_Ship_From_Address__c,
    Product_Description__c, SPEX_Exchange__c, SBU__c,SBU_w2c__c, Case_Record_Type__c, Region__c, AcceleratedRepair__c,Type,
    Classification__c, Subject, Supported_Products__c,Supported_Products__r.name,Owner_Operator_Information__c,CP_CSM__c
    from Case where (recordtypeId in :RecId) and (isClosed=false) and (status !='Re-Open') and 
    (X4_Hour_AOG__c='48-hour') and(SBU_w2c__c IN :MySBUs) and (sub_status__c IN :SubStat) and (Region__c in :MyRegions) and (Hardware_Ship_From_Address__c in :MySites) and (Type != 'MICAP')
    order by X4_Hour_AOG__c asc, AOG_Service_level_Value__c desc , Age_in_Hours__c desc];
}
else
if(currentId=='24'){
    cases=[Select Id,AOG_Service_level__c,AOG_Service_Level_Flag__c,X4_Hour_AOG__c,CaseNumber,Account_Name__c,
    Service_Level__c, Sub_Status__c, Age_in_Hours__c, Aircraft_Type__c, Aircraft_Location__c, OwnerName__c,
    lastmodifieddate, Next_Flight_Out_Date__c, AOG_Service_level_Value__c, Aircraft_Type__r.Name,
    Last_Updated_HoursMins__c, Last_Modified_Text__c, Product_Part__c,Product_GBE__c, Hardware_Ship_From_Address__c,
    Product_Description__c, SPEX_Exchange__c, SBU__c,SBU_w2c__c, Case_Record_Type__c, Region__c,AcceleratedRepair__c,Type,
    Classification__c, Subject, Supported_Products__c,Supported_Products__r.name,Owner_Operator_Information__c,CP_CSM__c
    from Case where (recordtypeId in :RecId) and (isClosed=false) and (status !='Re-Open') and 
    (X4_Hour_AOG__c='24-hour' ) and (SBU_w2c__c IN :MySBUs) and (sub_status__c IN :SubStat) and (sub_status__c != 'Order Processed') and (Region__c in :MyRegions) and (Hardware_Ship_From_Address__c in :MySites) and (Type != 'MICAP')
    order by X4_Hour_AOG__c asc, AOG_Service_level_Value__c desc , Age_in_Hours__c desc];
        
}
else if(currentId=='4'){

system.debug('Line 337'+ cases.size());
system.debug('recordtype: '+RecId);
    cases=[Select Id,AOG_Service_level__c,AOG_Service_Level_Flag__c,X4_Hour_AOG__c,CaseNumber,Account_Name__c,
    Service_Level__c, Sub_Status__c, Age_in_Hours__c, Aircraft_Type__c, Aircraft_Location__c, OwnerName__c,
    lastmodifieddate, Next_Flight_Out_Date__c, AOG_Service_level_Value__c, Aircraft_Type__r.Name,
    Last_Updated_HoursMins__c, Last_Modified_Text__c, Product_Part__c, Product_GBE__c,Hardware_Ship_From_Address__c,
    Product_Description__c, SPEX_Exchange__c, SBU__c,SBU_w2c__c, Case_Record_Type__c, Region__c,AcceleratedRepair__c,Type,
    Classification__c, Subject, Supported_Products__c,Supported_Products__r.name,Owner_Operator_Information__c,CP_CSM__c
    from Case where (recordtypeId in :RecId) and (isClosed=false) and (status !='Re-Open') and     
    (X4_Hour_AOG__c='4-hour') and (SBU_w2c__c IN :MySBUs) and (sub_status__c IN :SubStat) and (sub_status__c != 'Order Processed') and (Region__c in :MyRegions) and (Hardware_Ship_From_Address__c in :MySites) and (Type != 'MICAP')
    order by X4_Hour_AOG__c asc, AOG_Service_level_Value__c desc , Age_in_Hours__c desc];

}
else if(currentId=='0'){
    cases=[Select Id,AOG_Service_level__c,AOG_Service_Level_Flag__c,X4_Hour_AOG__c,CaseNumber,Account_Name__c,
    Service_Level__c, Sub_Status__c, Age_in_Hours__c, Aircraft_Type__c, Aircraft_Location__c, OwnerName__c,
    lastmodifieddate, Next_Flight_Out_Date__c, AOG_Service_level_Value__c, Aircraft_Type__r.Name,
    Last_Updated_HoursMins__c, Last_Modified_Text__c, Product_Part__c,Product_GBE__c, Hardware_Ship_From_Address__c,
    Product_Description__c, SPEX_Exchange__c, SBU__c,SBU_w2c__c, Case_Record_Type__c, Region__c,AcceleratedRepair__c,Type,
    Classification__c, Subject, Supported_Products__c,Supported_Products__r.name,Owner_Operator_Information__c,CP_CSM__c
    from Case where (recordtypeId in :RecId) and (isClosed=false) and (status !='Re-Open') and
    (X4_Hour_AOG__c='4-hour' or X4_Hour_AOG__c='24-hour' or X4_Hour_AOG__c='48-hour' or (recordtypeId in :TechId and AOG__c=True )) and (SBU_w2c__c IN :MySBUs) and (sub_status__c IN :SubStat) and (Region__c in :MyRegions) and (Hardware_Ship_From_Address__c in :MySites) and (Type != 'MICAP')
    order by X4_Hour_AOG__c asc, AOG_Service_level_Value__c desc , Age_in_Hours__c desc];
}
else {
system.debug('Line 356' + cases.size());
    cases=[Select Id,AOG_Service_level__c,AOG_Service_Level_Flag__c,X4_Hour_AOG__c,CaseNumber,Account_Name__c,
    Service_Level__c, Sub_Status__c, Age_in_Hours__c, Aircraft_Type__c, Aircraft_Location__c, OwnerName__c,
    lastmodifieddate, Next_Flight_Out_Date__c, AOG_Service_level_Value__c, Aircraft_Type__r.Name,
    Last_Updated_HoursMins__c, Last_Modified_Text__c, Product_Part__c,Product_GBE__c, Hardware_Ship_From_Address__c,
    Product_Description__c, SPEX_Exchange__c, SBU__c,SBU_w2c__c, Case_Record_Type__c, Region__c,AcceleratedRepair__c,Type,
    Classification__c, Subject, Supported_Products__c,Supported_Products__r.name,Owner_Operator_Information__c,CP_CSM__c
    from Case where (recordtypeId in :RecId) and (isClosed=false) and (status !='Re-Open') and
    (X4_Hour_AOG__c='4-hour' or X4_Hour_AOG__c='24-hour' or X4_Hour_AOG__c='48-hour' or (recordtypeId in :TechId and AOG__c=True )) and (SBU_w2c__c IN :MySBUs) and (sub_status__c IN :SubStat) and (Region__c in :MyRegions) and (Hardware_Ship_From_Address__c in :MySites) and (Type != 'MICAP')
    order by X4_Hour_AOG__c asc, AOG_Service_level_Value__c desc , Age_in_Hours__c desc]; // Added condition to display all records by default
}
system.debug('recordtype: '+RecId);
system.debug('Query : '+cases);
//system.debug('Query value: '+cases[0].Id);
flightout= new map<Id,Integer>();
integer flightdate=0;
try{
    for(integer i=0;i<cases.size();i++){
    flightout.put(cases[i].id,flightdate);
    if(cases[i].Next_Flight_Out_Date__c != null)
    {
    
    flightdate=(Date.today().daysBetween(date.valueof(cases[i].Next_Flight_Out_Date__c)))*24;
    //flightdate=Math.Floor(Decimal.valueOf(system.NOW()-cases[i].Next_Flight_Out_Date__c)/ (1000.0*60.0*60.0);
    flightout.put(cases[i].id,flightdate);
    }
    
        Decimal D = cases[i].Last_Updated_HoursMins__c;
        decimal d1=d/60;
        integer arr0=0;
        if(d1 !=null)
            arr0=d1.intvalue();
        List <string> arr= new List<String>();
        if(arr0 !=null)
            arr.add(string.valueof(arr0));
        else
            arr.add('0');
        Integer remainder2 = math.mod(cases[i].Last_Updated_HoursMins__c.intvalue(), 60);
        if(remainder2 !=null)
            arr.add(string.valueof(remainder2));
        else
            arr.add('0');
        if(arr[0].length()  ==1 )
            arr[0]='0'+arr[0];
        if(arr[1].length()  ==1)
            arr[1]='0'+arr[1];
        cases[i].Last_Modified_Text__c=arr[0]+' : '+arr[1];
    }
}
catch(Exception e){}

count= cases.size();
system.debug('while returning----count--->' + cases.size());

 try{
   count4below72 = [Select count() from Case where recordtypeId in :NonTechId and isClosed=false and
   status !='Re-Open' and AOG_Service_level__c !='Red' and (X4_Hour_AOG__c='4-hour') and (Type != 'MICAP')  and (sub_status__c != 'Order Processed')];
 }
 catch(Exception e){}
  
 try{
   count24below72 = [Select count() from Case where  recordtypeId in :NonTechId and isClosed=false and
   status !='Re-Open' and AOG_Service_level__c !='Red' and (X4_Hour_AOG__c='24-hour') and (Type != 'MICAP') and (sub_status__c != 'Order Processed')];
 } 
 catch(Exception e){}
 
 try{
   count48below72 = [Select count() from Case where  recordtypeId in :NonTechId and isClosed=false and
   status !='Re-Open' and AOG_Service_level__c !='Red' and (X4_Hour_AOG__c='48-hour') and (Type != 'MICAP')];
 } 
 catch(Exception e){} 
 

 try{
   count4above72=[Select count() from Case where  recordtypeId in :NonTechId and isClosed=false and
   status !='Re-Open' and AOG_Service_level__c ='Red' and (X4_Hour_AOG__c='4-hour') and (Type != 'MICAP') and (sub_status__c != 'Order Processed') ];
 }
 catch(Exception e){}
  
 try{
   count24above72=[Select count() from Case where  recordtypeId in :NonTechId and isClosed=false and
   status !='Re-Open' and AOG_Service_level__c  ='Red' and ( X4_Hour_AOG__c='24-hour') and (Type != 'MICAP') and (sub_status__c != 'Order Processed')];
 }
 catch(Exception e){} 
 
 try{
   count48above72=[Select count() from Case where  recordtypeId in :NonTechId and isClosed=false and
   status !='Re-Open' and AOG_Service_level__c  ='Red' and ( X4_Hour_AOG__c='48-hour') and (Type != 'MICAP')];
 }
 catch(Exception e){} 
 
 
 totalcount=count4below72+count4above72+count24below72+count24above72+count48below72+count48above72;
 total72=count4above72+count24above72+count48above72;
 if(count4above72>0){
     integer total4=count4above72+count4below72;
     sla4hr=(count4below72*100);
     sla4hr=sla4hr/total4;
 }
 else
     sla4hr=100;
 
 sla4hrint=sla4hr.intvalue();
 
 if(count24above72>0){
  integer total24=count24above72+count24below72;
  sla24hr=count24below72*100;
  sla24hr=sla24hr/total24;
 }
 else
     sla24hr=100;
 sla24hrint=sla24hr.intvalue();
 
 if(count48above72>0){
  integer total48=count48above72+count48below72;
  sla48hr=count48below72*100;
  sla48hr=sla48hr/total48;
 }
 else
     sla48hr=100;
 sla48hrint=sla48hr.intvalue();

 system.debug('while returning----count--->' + cases.size());
 return cases;
}

public Integer getCount(){
    return count;
}

public String getcurrentId(){
    return currentId;
}

public String getscroll(){
    return scroll;
}

public Integer getcountclosed(){
    countclosed = [Select count() from Case where recordtypeId in :NonTechId and isClosed=true and (Type != 'MICAP') and
    ClosedDate >= :myDate and (( X4_Hour_AOG__c='4-hour' or X4_Hour_AOG__c='24-hour' or X4_Hour_AOG__c='48-hour')) ];

    return countclosed;
}

public Integer getTechnicalCount(){
    return [Select count() from Case where recordtypeId in :TechId and isClosed=false and status !='Re-Open' and AOG__c=True and (Type != 'MICAP')];
}

public Integer getClosedTechnicalCount(){
    return [Select count() from Case where recordtypeId in :TechId and isClosed=true and AOG__c=True and ClosedDate >= :myDate and (Type != 'MICAP')];
}

public Integer getFourCount(){
    count4 = [Select count() from Case where recordtypeId in :NonTechId and isClosed=false and status !='Re-Open' and     
    (X4_Hour_AOG__c='4-hour') and (Type != 'MICAP') and (sub_status__c != 'Order Processed')];
    return count4;
}

public Integer getTwentyFourCount(){
    count24 = [Select count() from Case where recordtypeId in :NonTechId and isClosed=false and status !='Re-Open' and     
    (X4_Hour_AOG__c='24-hour') and (Type != 'MICAP') and (sub_status__c != 'Order Processed')];
    return count24;
}

public Integer getFourtyEightCount(){
    count48 = [Select count() from Case where recordtypeId in :NonTechId and isClosed=false and status !='Re-Open' and     
    (X4_Hour_AOG__c='48-hour') and (Type != 'MICAP')];
    return count48;
}

public Integer getFourCountabove72(){
 return count4above72;
}

public Integer getTwentyFourCountabove72(){
 return count24above72;
}

public Integer getFourtyEightCountabove72(){
 return count48above72;
}
public Integer gettotalcount(){
 return count4+count24+count48;
}

public integer getsla4hr(){
 return sla4hrint;
}

public integer getsla24hr(){
 return sla24hrint;
}

public integer getsla48hr(){
 return sla48hrint;
}


public PageReference getAllCases(){
    scroll=System.currentPageReference().getParameters().get('scroll');
    PageReference pageRef ;
    if(scroll=='true'){
        pageRef = new PageReference('http://honeywellaero.force.com/AOGRealTimeReport?Id=24&scroll=true');
    }
    else{
        pageRef = new PageReference('http://honeywellaero.force.com/AOGRealTimeReport?Id=24');
    }
    return pageRef ;
}

public PageReference getAll48Cases(){
    scroll=System.currentPageReference().getParameters().get('scroll');
    PageReference pageRef4;
    if(scroll=='true'){
        pageRef4 = new PageReference('http://honeywellaero.force.com/AOGRealTimeReport?Id=48&scroll=true');
    }
    else{
        pageRef4 = new PageReference('http://honeywellaero.force.com/AOGRealTimeReport?Id=48');
    }
    return pageRef4 ;
}


public PageReference getAll4Cases(){
        scroll=System.currentPageReference().getParameters().get('scroll');
        PageReference pageRef1;
        if(scroll=='true')
        {
           pageRef1 = new PageReference('http://honeywellaero.force.com/AOGRealTimeReport?scroll=true');
        }
        else{
           pageRef1 = new PageReference('http://honeywellaero.force.com/AOGRealTimeReport');
        }
        return pageRef1 ;
    }

public PageReference scrollOff(){
    PageReference pageRef2;
    if(currentId=='24'){
        pageRef2 = new PageReference('http://honeywellaero.force.com/AOGRealTimeReport?Id=24');
    }
    if(currentId=='48'){
        pageRef2 = new PageReference('http://honeywellaero.force.com/AOGRealTimeReport?Id=48');
    }
    else{
        pageRef2 = new PageReference('http://honeywellaero.force.com/AOGRealTimeReport');
    }
    return pageRef2 ;
}

public PageReference scrollOn(){
    PageReference pageRef3;
    if(currentId=='24'){
        pageRef3 = new PageReference('http://honeywellaero.force.com/AOGRealTimeReport?Id=24&scroll=true');
    }
    if(currentId=='48'){
        pageRef3 = new PageReference('http://honeywellaero.force.com/AOGRealTimeReport?Id=48&scroll=true');
        }
    else{
        pageRef3 = new PageReference('http://honeywellaero.force.com/AOGRealTimeReport?scroll=true');
    }
    return pageRef3 ;
}

public PageReference fwdBB() {
    PageReference pageRef = ApexPages.currentPage();
   
    if( pageRef.getHeaders().get('User-Agent').contains('Profile/MIDP-') || pageRef.getHeaders().get('User-Agent').contains('BlackBerry') ){
        pageRef = new PageReference('http://honeywellaero.force.com/AOGRealTimeReport/AOG_Dashboard_Mobile');
        pageRef.setRedirect(true);
    }
    
    return pageRef;
}
public string getserverUrl()
{
  serverUrl = URL.getSalesforceBaseUrl().toExternalForm() +'/';
  return serverUrl;
}

}