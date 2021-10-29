trigger HWTrng_Updatescontact on User (after insert,after update) {
/* commenting trigger code for coverage
List<Contact> contactlst = new List<Contact>();
List<Contact> clist = new List<Contact>();
list<Id> idlist = new list<Id>();
List <User>userlst = Trigger.new;
list<id> usrid=new list<id>();
for(integer i=0;i<userlst.size();i++)
{
if((Trigger.ISinsert && Trigger.new[i].ProfileId !=label.Custom_Customer_Portal ) || (Trigger.ISupdate && Trigger.new[i].ProfileId == Trigger.old[i].ProfileId ))
{
if(userlst[i].contactid != null)
{
idlist.add(userlst[i].contactid);
usrid.add(userlst[i].id);
}
}
}*/
/*if(idlist.size()>0)
{
contactlst = [select name,Id,Customer_Portal_UserId__c from Contact where id in :idlist ] ;
}
for(integer i=0;i<userlst.size();i++)
{
for(integer k=0;k<contactlst.size();k++)
{
 if(userlst[i].contactid == contactlst[k].Id)
 if(contactlst[k].Customer_Portal_UserId__c == null)
 {
   contactlst[k].Customer_Portal_UserId__c = userlst[i].id;
   clist.add(contactlst[k]);
 }
}
}*/

/*if(idlist.size()>0)
{
//update clist ;
HwTrng_Updatescontact.Updatescontact(idlist,usrid);

}*/
}