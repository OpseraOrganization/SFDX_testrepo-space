public class AOGRealTimeSLAReport{
List<Case> cases= new List<Case>();
List<Case> cases4= new List<Case>();
List<Case> cases24= new List<Case>();
List<Case> cases4above72= new List<Case>();
List<Case> cases24above72= new List<Case>();
List<CaseHistory> caseHis= new List<CaseHistory>();
String serverUrl;
//added by Sneha for Spex
List<String> recordtypes=new List<String>{'AOG','Exchange'};
Map<String,Id> recIdMap=new Map<String,Id>();

//Id RecId = [select Id from RecordType where SobjectType = 'Case' and (DeveloperName = 'AOG')].Id;//FOUNDSNEHA ASK 

integer count=0,count4=0,count24=0,count4above72=0,count24above72=0,totalcount=0,sla4hrint=0,sla24hrint=0,total72=0,
count4below72=0,count24below72=0;
decimal sla4hr,sla24hr;
String currentId;
public AOGRealTimeSLAReport() {
//system.debug('@@@@@@@@@@@@@@@@@@@'+RecId);
for(Schema.RecordTypeInfo recInfo: Schema.SObjectType.Case.getRecordTypeInfosByName().values()){
   if(recordtypes.contains(recInfo.getName())){
		recIdMap.put(recInfo.getName(),recInfo.getRecordtypeId());
   }
}
currentId=System.currentPageReference().getParameters().get('Id');
if(currentId=='4'){
cases=[Select Id,AOG_Service_level__c,AOG_Service_Level_Flag__c,X4_Hour_AOG__c,CaseNumber,Account_Name__c,
 Service_Level__c,
Sub_Status__c, Age_in_Hours__c,
Aircraft_Type__c,Aircraft_Location__c,OwnerName__c,lastmodifieddate,
Next_Flight_Out_Date__c,AOG_Service_level_Value__c,Aircraft_Type__r.Name,
Last_Updated_HoursMins__c,Last_Modified_Text__c
from Case where   recordtypeId IN :recIdMap.values() and isClosed=false and 
status !='Re-Open' and 

(X4_Hour_AOG__c='4-hour' )
///(X4_Hour_AOG__c='4-hour'  or X4_Hour_AOG__c='24-hour' )  
order by X4_Hour_AOG__c asc, AOG_Service_level_Value__c desc , Age_in_Hours__c desc  ];
}
else{
cases=[Select Id,AOG_Service_level__c,AOG_Service_Level_Flag__c,X4_Hour_AOG__c,CaseNumber,Account_Name__c,
 Service_Level__c,
Sub_Status__c, Age_in_Hours__c,
Aircraft_Type__c,Aircraft_Location__c,OwnerName__c,lastmodifieddate,
Next_Flight_Out_Date__c,AOG_Service_level_Value__c,Aircraft_Type__r.Name,
Last_Updated_HoursMins__c,Last_Modified_Text__c
from Case where   recordtypeId IN :recIdMap.values() and isClosed=false and 
status !='Re-Open' and 
(X4_Hour_AOG__c='4-hour'  or X4_Hour_AOG__c='24-hour' )  
order by X4_Hour_AOG__c asc, AOG_Service_level_Value__c desc , Age_in_Hours__c desc  ];

}





try{
for(integer i=0;i<cases.size();i++){
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


count=cases.size();

try{
cases4=[Select Id,AOG_Service_level__c,AOG_Service_Level_Flag__c,X4_Hour_AOG__c,CaseNumber,Account_Name__c,
Service_Level__c,
 Sub_Status__c,  Age_in_Hours__c,
Aircraft_Type__c,Aircraft_Location__c,OwnerName__c,lastmodifieddate,
Next_Flight_Out_Date__c,AOG_Service_level_Value__c,Aircraft_Type__r.Name,
Last_Updated_HoursMins__c,Last_Modified_Text__c
 from Case where  recordtypeId IN :recIdMap.values() and isClosed=false and
 status !='Re-Open' and 

 (X4_Hour_AOG__c='4-hour'  ) order by AOG_Service_level_Value__c desc];
 count4=cases4.size();
}
catch(Exception e){}
 
try{
cases24=[Select Id,AOG_Service_level__c,AOG_Service_Level_Flag__c,X4_Hour_AOG__c,CaseNumber,Account_Name__c,
Service_Level__c,
 Sub_Status__c,  Age_in_Hours__c,
Aircraft_Type__c,Aircraft_Location__c,OwnerName__c,lastmodifieddate,
Next_Flight_Out_Date__c,AOG_Service_level_Value__c,Aircraft_Type__r.Name,Last_Updated_HoursMins__c,Last_Modified_Text__c
 from Case where  recordtypeId IN :recIdMap.values() and isClosed=false and
 status !='Re-Open' and 

 ( X4_Hour_AOG__c='24-hour' ) order by AOG_Service_level_Value__c desc];
 count24=cases24.size();
 }
 catch(Exception e){}
 
 try{
   count4below72=[Select count() from Case where  recordtypeId IN :recIdMap.values() and isClosed=false and
   status !='Re-Open' and 

   ///Age_in_Hours__c <=72 
   AOG_Service_level__c  !='Red'
   and 
   (X4_Hour_AOG__c='4-hour'  ) ];
 }
 catch(Exception e){}
 
 
 try{
   count24below72=[Select count() from Case where  recordtypeId IN :recIdMap.values() and isClosed=false and
   status !='Re-Open' and 

  // Age_in_Hours__c >=72
     AOG_Service_level__c  !='Red'
    and 
   ( X4_Hour_AOG__c='24-hour' ) ];
   }
 catch(Exception e){} 
 
 
 
 
 
 try{
   count4above72=[Select count() from Case where  recordtypeId IN :recIdMap.values() and isClosed=false 
   and
   status !='Re-Open' and 

  // Age_in_Hours__c >72
      AOG_Service_level__c  ='Red'
    and 
   (X4_Hour_AOG__c='4-hour'  ) ];
 }
 catch(Exception e){}
 
 
 try{
  count24above72=[Select count() from Case where  recordtypeId IN :recIdMap.values() and isClosed=false
 

   and
   status !='Re-Open' and 

     AOG_Service_level__c  ='Red'
  //Age_in_Hours__c >72 
  and 
  ( X4_Hour_AOG__c='24-hour' ) ];
  }
 catch(Exception e){}
 
 
 totalcount=count4below72+count4above72+count24below72+count24above72;
 total72=count4above72+count24above72;
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
}





public List<Case> getcases(){
if(currentId=='4'){
cases=[Select Id,AOG_Service_level__c,AOG_Service_Level_Flag__c,X4_Hour_AOG__c,CaseNumber,Account_Name__c,
 Service_Level__c,
Sub_Status__c, Age_in_Hours__c,
Aircraft_Type__c,Aircraft_Location__c,OwnerName__c,lastmodifieddate,
Next_Flight_Out_Date__c,AOG_Service_level_Value__c,Aircraft_Type__r.Name,
Last_Updated_HoursMins__c,Last_Modified_Text__c
from Case where   recordtypeId IN :recIdMap.values() and isClosed=false and 
status !='Re-Open' and 

(X4_Hour_AOG__c='4-hour' )
///(X4_Hour_AOG__c='4-hour'  or X4_Hour_AOG__c='24-hour' )  
order by X4_Hour_AOG__c asc, AOG_Service_level_Value__c desc , Age_in_Hours__c desc  ];
}
else{
cases=[Select Id,AOG_Service_level__c,AOG_Service_Level_Flag__c,X4_Hour_AOG__c,CaseNumber,Account_Name__c,
 Service_Level__c,
Sub_Status__c, Age_in_Hours__c,
Aircraft_Type__c,Aircraft_Location__c,OwnerName__c,lastmodifieddate,
Next_Flight_Out_Date__c,AOG_Service_level_Value__c,Aircraft_Type__r.Name,
Last_Updated_HoursMins__c,Last_Modified_Text__c
from Case where   recordtypeId IN :recIdMap.values() and isClosed=false and 
status !='Re-Open' and 
(X4_Hour_AOG__c='4-hour'  or X4_Hour_AOG__c='24-hour' )  
order by X4_Hour_AOG__c asc, AOG_Service_level_Value__c desc , Age_in_Hours__c desc  ];

}

try{
for(integer i=0;i<cases.size();i++){
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


return cases;
}

public Integer getCount(){
cases=[Select Id,AOG_Service_level__c,AOG_Service_Level_Flag__c,X4_Hour_AOG__c,CaseNumber,Account_Name__c,
Service_Level__c,
 Sub_Status__c,  Age_in_Hours__c,
Aircraft_Type__c,Aircraft_Location__c,OwnerName__c,lastmodifieddate,
Next_Flight_Out_Date__c,AOG_Service_level_Value__c,Aircraft_Type__r.Name,
Last_Updated_HoursMins__c,Last_Modified_Text__c
 from Case where  recordtypeId IN :recIdMap.values() and isClosed=false and
 status !='Re-Open' and 

 (X4_Hour_AOG__c='4-hour' )
 //(X4_Hour_AOG__c='4-hour'  or X4_Hour_AOG__c='24-hour' )
  order by X4_Hour_AOG__c asc, AOG_Service_level_Value__c desc ,Age_in_Hours__c desc];
 count=cases.size();
 

try{
for(integer i=0;i<cases.size();i++){
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
 return count;
}

public String getcurrentId(){
 return currentId;
}



public Integer getFourCount(){
 return count4;
}

public Integer getTwentyFourCount(){
 return count24;
}



public Integer getFourCountabove72(){
 return count4above72;
}

public Integer getTwentyFourCountabove72(){
 return count24above72;
}


public Integer gettotalcount(){
 return totalcount;
}


public integer getsla4hr(){
 return sla4hrint;
}

public integer getsla24hr(){
 return sla24hrint;
}

public PageReference getAllCases(){
PageReference pageRef = new PageReference('http://honeywellaero.force.com/AOGRealTimeReport/AOGRealTimeSLAReport?Id=24');
return pageRef ;
}


public PageReference getAll4Cases(){
PageReference pageRef1 = new PageReference('http://honeywellaero.force.com/AOGRealTimeReport/AOGRealTimeSLAReport?Id=4');
return pageRef1 ;
}
public String getserverUrl()
 {
   serverUrl = URL.getSalesforceBaseUrl().toExternalForm() +'/';
   return serverUrl;
 }

}