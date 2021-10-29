public class GCC_Dashboard_cls{

public List<Service_Request__c> SRs= new List<Service_Request__c>();
public Map<Integer, List<String>> OEMsMap {get; set;}

//List<Key_Affected_OEMs_Operators__c> OEMs = new List<Key_Affected_OEMs_Operators__c>();
public List<String> oems;
public List<String> oem; 
integer countclosed=0;
public String currentId;

String ToggleUrl;
String ToggleButton;


public GCC_Dashboard_cls() {

    currentId=System.currentPageReference().getParameters().get('Closed');
    OEMsMap = new Map<Integer, List<String>>();
}

public List<Service_Request__c> getSRs(){   

    if(currentId == 'True'){
        SRs = [Select Id,RAIL_Number__c,RAIL_Type__c,Escalated_RAIL__c,LastModifiedDate,RAIL_Description__c, Dashboard_Status__c,Actual_Completion__c,OEMs_Affected__c,Status__c, GCC_Date_Closed__c,One__c,Working_Team_chk__c,Previous_Status_Update__c  from Service_Request__c where  GCC__c = True and (One__c ='Closed' OR One__c ='Agenda Follow Up') AND GCC_Date_Closed__c= THIS_Year ORDER BY RAIL_Number__c ASC ];
    }
    else{
        SRs = [Select Id,RAIL_Number__c,RAIL_Type__c,Escalated_RAIL__c,LastModifiedDate,RAIL_Description__c, Dashboard_Status__c,Actual_Completion__c,OEMs_Affected__c,Status__c, GCC_Date_Closed__c,One__c,Working_Team_chk__c,Previous_Status_Update__c   from Service_Request__c where  GCC__c = True and One__c ='Top 25' ORDER BY RAIL_Number__c ASC ];
    }
    for(integer i=0; i<SRs.size(); i++) {
    
        //String temp;
        if( SRs[i].OEMs_Affected__c != null ){
            
            SRs[i].OEMs_Affected__c = SRs[i].OEMs_Affected__c.replaceAll(', ',',');
            //SRs[i].OEMs_Affected__c = SRs[i].OEMs_Affected__c.replaceAll(',',', ');
            SRs[i].OEMs_Affected__c = SRs[i].OEMs_Affected__c.toLowerCase();
            
            oems = SRs[i].OEMs_Affected__c.split(',');
            oem = new List<String>();
            
            if( oems.size() > 0){
                for(integer j=0;j<oems.size();j++) {
                    //temp = temp + oems[j].split(' ',0)[0]+'/';
                    oem.add( oems[j].split(' ',0)[0] );
                }
                OEMsMap.put( integer.valueOf(SRs[i].RAIL_Number__c) ,oem);
            }            
        }
        else {
            OEMsMap.put( integer.valueOf(SRs[i].RAIL_Number__c) , new List<String>());
        }
        
    }
    return SRs;
}

public Integer getcountclosed(){

countclosed=[Select count() FROM Service_Request__c WHERE  GCC__c = True AND (One__c ='Closed' OR One__c ='Agenda Follow Up') AND GCC_Date_Closed__c= THIS_Year ];

return countclosed;
}


public string GetToggleUrl(){

if(currentId=='True'){
 ToggleUrl = '?Closed=False';
 }
else {
ToggleUrl='?Closed=True';
}
return  ToggleUrl;
}

public string GetToggleButton(){

if(currentId=='True'){
 ToggleButton = 'View Open Rails';
 }
else {
ToggleButton='View Closed Rails';
}
return  ToggleButton;
}




}