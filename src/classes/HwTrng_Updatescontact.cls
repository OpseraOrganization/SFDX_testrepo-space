public class HwTrng_Updatescontact {
  @future
  public static void Updatescontact(list<id> idlist,list<id> usrid)
  {
  List<Contact> contactlst = new List<Contact>();
  List <User> userlst = new list<user>() ;
  List<Contact> clist = new List<Contact>();
  if(idlist.size()>0)
{
contactlst = [select name,Id,Customer_Portal_UserId__c from Contact where id in :idlist ] ;
userlst = [select id,contactid from user where id in : usrid];
}
for(integer i=0;i<userlst.size();i++)
{
for(integer k=0;k<contactlst.size();k++)
{
 if(userlst[i].contactid== contactlst[k].Id)
 if(contactlst[k].Customer_Portal_UserId__c == null)
 {
    contactlst[k].Customer_Portal_UserId__c = userlst[i].id;
   clist.add(contactlst[k]);
 }
}
}
update clist;  
  }
  
  }