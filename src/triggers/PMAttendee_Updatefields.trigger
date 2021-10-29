/** * File Name: PMAttendee_Updatefields
* Description Trigger to update the Planned Meeting Attendee fields from Planned Meeting.
* Copyright : Wipro Technologies Limited Copyright (c) 2010
* * @author : wipro
* Modification Log =============================================================== 
Ver Date Author Modification --- ---- ------ -------------
* */ 

trigger PMAttendee_Updatefields on Planned_Meeting_Attendee__c (before insert) {

//Variable declaration
List<Planned_Meeting_Attendee__c> pmattlist = Trigger.new;
List<ID> pmids = new List<ID>();
Set<ID> pmaContact = new Set<ID>();
List<ID> eveids = new List<ID>();
List<Planned_Meeting__c> pms = new List <Planned_Meeting__c>();
List<Event__c> elist = new List<Event__c> ();
MAP<ID,String> m1 = new MAP<ID,String>();

for(integer i=0;i<pmattlist.size();i++)
{
pmids.add(pmattlist[i].Planned_Meeting__c);
pmaContact.add(pmattlist[i].contact__c);
}
Map<id,Contact> mapContact = new Map<id,Contact>();
if(pmaContact.size()>0){
                mapContact = new Map<id,Contact>([select id,Contact_Function__c 
                from Contact where Id in :pmaContact]);                 
}
//Querying the Planned Meeting associated to the Planned Meeting Attendee
if(pmids.size()>0)
{
pms = [select Id,Event__c,Meeting_Purpose__c,Location__c,Start__c,End__c,Contact_Name__r.Contact_Function__c,Planned_Meeting_Type__c,send_email_notification__c from Planned_Meeting__c where id in :pmids];
}

//Event is a lookup.Hence direct copying of field gives SFDC Id. Hence query to fetch the Event name
for(integer i=0;i<pms.size();i++)
{
eveids.add(pms[i].Event__c);
}
if(eveids.size()>0)
{
elist = [select name from Event__C where id in :eveids];
}
for(integer i=0;i<pms.size();i++)
{
for(integer k=0;k<elist.size();k++)
{
    if(pms[i].Event__c == elist[k].Id)
      m1.put(pms[i].id,elist[k].name);
}
}
//Updating fields in Planned Meeting Attendee
for(integer i=0;i<pmattlist.size();i++)
{
  for(integer j=0;j<pms.size();j++)
    {
       if(pmattlist[i].Planned_Meeting__c==pms[j].Id)
        {
        pmattlist[i].Event_del__c = m1.get(pmids[j]);
        pmattlist[i].Meeting_Purpose__c =pms[j].Meeting_Purpose__c;
         system.debug('TTTT'+pmattlist[i].Meeting_Purpose__c);
        pmattlist[i].Location__c = pms[j].Location__c;
        pmattlist[i].Start__c = pms[j].Start__c;
        pmattlist[i].End__c = pms[j].End__c;
        pmattlist[i].Planned_Meeting_RecordType__c=pms[j].Planned_Meeting_Type__c;
        pmattlist[i].send_email_notification__c=pms[j].send_email_notification__c;
        if(pmattlist[i].Relationship_Status__c==null)
        pmattlist[i].Relationship_Status__c=pmattlist[i].Contact_Relationship_Status__c;
        //if(pmattlist[i].Influencer__c==null)
        //pmattlist[i].Influencer__c=pmattlist[i].Contact_Influencer__c;
if(null!=mapContact && mapContact .size()>0){

        system.debug('Contact Function'+mapContact.get(pmattlist[i].Contact__c).Contact_Function__c);
        pmattlist[i].Influencer__c=mapContact.get(pmattlist[i].Contact__c).Contact_Function__c;

        }
    }
    
}    
}
}