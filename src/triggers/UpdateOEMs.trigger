trigger UpdateOEMs on Key_Affected_OEMs_Operators__c (after delete, after insert, after update) {
List<Key_Affected_OEMs_Operators__c> OEMOPlist = new List<Key_Affected_OEMs_Operators__c>();
List<ID> SRIDlist =new List<ID>();
List<Service_Request__c> SRlist = new List<Service_Request__c>();
List<Service_Request__c> newSRlist = new List<Service_Request__c>();
String OEMstr ='',Operatorstr='',trimOEMs,trimOperator;
MAP<ID,string> OEMsmap = new MAP<ID,string>();
MAP<ID,string> Operatormap = new MAP<ID,string>();

if(Trigger.isDelete)
{
OEMOPlist = Trigger.old;
}
else
{
OEMOPlist = Trigger.new;
}

//Getting the Planned Meeting IDs to a list
for(integer i=0;i<OEMOPlist.size();i++)
{
    if(OEMOPlist[i].Service_Request__c!=null)
      {
        SRIDlist.add(OEMOPlist[i].Service_Request__c);
      }  
}
//Querying related SR
if(SRIDlist.size()>0)
{
SRlist=[select id, name from Service_Request__c where id in :SRIDlist];
}
//Querying all the OEMs/ Operators related to the SR
for(Key_Affected_OEMs_Operators__c[] attslist :[select Id, OEM_Operator__c,Service_Request__c, Account_Name__c, Account_Name__r.name  from Key_Affected_OEMs_Operators__c where Service_Request__c in :SRIDlist and Service_Request__c!=null])
{
for(Service_Request__c pms : SRlist)
{
for(Key_Affected_OEMs_Operators__c atts : attslist)
{
if(pms.Id==atts.Service_Request__c)
{
//Constructing the string to update the fields "OEMS Affected" and “Operators Affected"  based on user and contact.Internal contacts should be updated in the field "Employees"
if(atts.OEM_Operator__c == 'OEM')
 {
    OEMstr  = OEMstr  + atts.Account_Name__r.name ; 
   
   OEMstr  = OEMstr  +', ';
 }
   else
 {
   Operatorstr = Operatorstr +atts.Account_Name__r.name ; 
   Operatorstr = Operatorstr +', ';
 }
  
}
}
OEMsmap.put(pms.Id,OEMstr );
Operatormap.put(pms.Id,Operatorstr);
OEMstr ='';
Operatorstr='';
}
}
for(integer i=0;i<SRlist.size();i++)
{
  trimOEMs = OEMsmap.get(SRlist[i].ID);
  if(trimOEMs != null && trimOEMs.length()>0)
      {
         //Removing the comma at the end of the string
          trimOEMs=trimOEMs.substring(0,trimOEMs.length()-2); 
      }
  trimOperator = Operatormap.get(SRlist[i].ID);
  if(trimOperator!= null && trimOperator.length()>0)
      {   
          //Removing the comma at the end of the string
          trimOperator=trimOperator.substring(0,trimOperator.length()-1);
      } 
  //Updating the fields    
  SRlist[i].OEMs_Affected__c = trimOEMs;
  SRlist[i].Operators_Affected__c = trimOperator;
  newSRlist.add(SRlist[i]);           
}
if(newSRlist.size()>0)
{

try
{
update newSRlist;
}
catch(System.DmlException  e)
{
for (Key_Affected_OEMs_Operators__c a : Trigger.new) {
    a.addError(newSRlist[0].name +'  Does not meet all validation rules, Please update the Service Request first');

}

}

}



}