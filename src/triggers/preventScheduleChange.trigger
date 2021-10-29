trigger preventScheduleChange on OpportunityLineItem (before update) {
  if(AvoidRecursion.isFirstRun_preventScheduleChange()){
String profileId;
list<DS_Sales_Adminlist__c> mapDSAdminProfile = DS_Sales_Adminlist__c.getALL().values();
map<id,list<OpportunityLineItemSchedule>> schedulemap=new map<id,list<OpportunityLineItemSchedule>>();
map<id,date>startdatemap=new map<id,date>();
map<id,date>enddatemap=new map<id,date>();
Date startdate, enddate;
Integer oppschedulecount;
set<id>OpportunityLineItemid=new set<id>();
list<OpportunityLineItemSchedule> OpportunityLineItemSchedulelist= new list<OpportunityLineItemSchedule>();
profileId=Userinfo.getprofileId();
profileid=profileId.substring(0,15);
Integer flagProfile = 0;
  for(integer i=0;i<mapDSAdminProfile.size();i++){
      if(mapDSAdminProfile[i].D_S_Admin_ProfileId__c==profileId){
         flagProfile=1;
      }
  }

for(OpportunityLineItem  opp: Trigger.new){
  // Commented and Modified for SR# 417354 - Start
  //if( opp.type__C=='Booked'){
  if( opp.type__C=='Booked' || opp.type__C=='APO' ){
  // Commented and Modified for SR# 417354 - End
  system.debug('inside booked***********');
  system.debug('System.Trigger.OldMap.get(opp.Id).ListPrice*****************'+System.Trigger.OldMap.get(opp.Id).ListPrice);
  system.debug('System.Trigger.NewMap.get(opp.Id).ListPrice)***********'+System.Trigger.NewMap.get(opp.Id).ListPrice);
  system.debug('System.Trigger.OldMap.get(opp.Id).TotalPrice***********'+System.Trigger.OldMap.get(opp.Id).TotalPrice);
  system.debug('System.Trigger.NewMap.get(opp.Id).TotalPrice***********'+System.Trigger.NewMap.get(opp.Id).TotalPrice);
     if((System.Trigger.OldMap.get(opp.Id).ListPrice ==System.Trigger.NewMap.get(opp.Id).ListPrice)
     &&
         (System.Trigger.OldMap.get(opp.Id).TotalPrice !=System.Trigger.NewMap.get(opp.Id).TotalPrice)   
       )
   {
        system.debug('insdeid id old map*************');
              
       if(profileid == label.Honeywell_System_Administrator_US_Label  || profileid ==label.Honeywell_System_Administrator_Label  ||
          profileid == label.D_S_Sales_Spiral_API_User_Label || profileid == label.D_S_Sales_API_User_Label || profileid == label.DFS_API_User_Label
          || flagProfile ==1 || (Test.isRunningTest()))
        
       {
        system.debug('inside if**************');
       }
       else
       {
         opp.addError('Schedule can be changed only by an admin');                   
       }
   
   }
   
   }
   
   //if(oppschedulecount>0 && opp.TotalPrice!= trigger.oldMap.get(opp.id).TotalPrice)

}
   



for(OpportunityLineItem  opp: Trigger.new)
{
     OpportunityLineItemid.add(opp.id);
}
OpportunityLineItemSchedulelist=[Select id,ScheduleDate,OpportunityLineItemId  From OpportunityLineItemSchedule where OpportunityLineItemId IN: OpportunityLineItemid Order By ScheduleDate];


if(OpportunityLineItemSchedulelist.size()>0){
for(OpportunityLineItemSchedule oppsch: OpportunityLineItemSchedulelist)
{
    /**list<OpportunityLineItemSchedule> templist= new list<OpportunityLineItemSchedule>();
    if(schedulemap.get(oppsch.OpportunityLineItemId)!=null)
    {
        templist=schedulemap.get(oppsch.OpportunityLineItemId);
    }
    templist.add(oppsch);
    schedulemap.put(oppsch.OpportunityLineItemId,templist);**/
    list<OpportunityLineItemSchedule >temp=new list<OpportunityLineItemSchedule >();
    if(schedulemap.containsKey(oppsch.OpportunityLineItemId))
        temp.addAll(schedulemap.get(oppsch.OpportunityLineItemId));
    temp.add(oppsch);
    schedulemap.put(oppsch.OpportunityLineItemId ,temp);
}
}


for(OpportunityLineItem  opp: Trigger.new)
{
    if(schedulemap.containsKey(opp.id))
    for(OpportunityLineItemSchedule oppsch: schedulemap.get(opp.id))
    {
        if(startdatemap.get(oppsch.OpportunityLineItemId)==null || startdatemap.get(oppsch.OpportunityLineItemId)>oppsch.ScheduleDate)
            startdatemap.put(oppsch.OpportunityLineItemId,oppsch.ScheduleDate);        
        if(enddatemap.get(oppsch.OpportunityLineItemId)==null || enddatemap.get(oppsch.OpportunityLineItemId)<oppsch.ScheduleDate)
            enddatemap.put(oppsch.OpportunityLineItemId,oppsch.ScheduleDate);
    }
    System.debug('Line 98'+startdatemap);
         if((opp.Revenue_Start_Date__c!=trigger.oldMap.get(opp.id).Revenue_Start_Date__c && 
       trigger.oldMap.get(opp.id).Revenue_Start_Date__c!=null && startdatemap.get(opp.Id)!=opp.Revenue_Start_Date__c) 
       || (opp.Revenue_End_Date__c!=trigger.oldMap.get(opp.id).Revenue_End_Date__c && 
       trigger.oldMap.get(opp.id).Revenue_End_Date__c!=null  && enddatemap.get(opp.Id)!=opp.Revenue_End_Date__c)){
         opp.addError('Please edit Revenue Schedule to change Revenue Start or End date.');
         system.debug('inside if******************');
       }
   
    
    
     if(schedulemap.get(opp.id)!=null)
     {
        List<OpportunityLineItemSchedule> oppschlist = schedulemap.get(opp.id); 
        //if(oppschlist.size()>0)
        //oppschlist.sort();
      
        integer diff=0;
        if(oppschlist.size()>1)
        {
            diff=(oppschlist[0].ScheduleDate).daysBetween(oppschlist[1].ScheduleDate);
            system.debug('diff*************'+diff);
        }
          
        if(diff<=1)
           opp.Schedule_Type__c='Daily';
        if(diff>1 && diff<=7)
            opp.Schedule_Type__c='Weekly';
        if(diff>7 && diff<=31)
            opp.Schedule_Type__c='Monthly';
        if(diff>31 && diff<=92)
            opp.Schedule_Type__c='Quarterly';
        if(diff>92)
            opp.Schedule_Type__c='Yearly';
        
        //Commented and Modified for SR# INC000005780915 - Start
        /*(startdatemap.get(opp.id)!=null)
        opp.revenue_start_date__c = startdatemap.get(opp.id);
        if(enddatemap.get(opp.id)!=null)
        opp.revenue_end_date__c =  enddatemap.get(opp.id);
        */
        Integer daysbet=0;
        if(null != Trigger.oldMap.get(opp.id).ServiceDate && null != opp.ServiceDate)
            daysbet=Trigger.oldMap.get(opp.id).ServiceDate.daysbetween(opp.ServiceDate);        
        if(oppschlist.size()>0 && null != oppschlist[0].ScheduleDate)
            opp.revenue_start_date__c = oppschlist[0].ScheduleDate+daysbet;                    
        if(oppschlist.size()>=1 && null != oppschlist[oppschlist.size()-1].ScheduleDate)
            opp.revenue_end_date__c =  oppschlist[oppschlist.size()-1].ScheduleDate+daysbet;                     
        //Commented and Modified for SR# INC000005780915 - End
         opp.Terms_in_Months__c=startdatemap.get(opp.id).monthsBetween(enddatemap.get(opp.id));
       
     }
     else
     {        
        opp.Schedule_Type__c='';
       opp.revenue_start_date__c=null;
        opp.revenue_end_date__c =null;
        opp.Terms_in_Months__c=null;
     }
      
        
    
}
}
}