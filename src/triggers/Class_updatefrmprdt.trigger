trigger Class_updatefrmprdt on Class__c (before insert,before update) {
List<Class__c> cllist = Trigger.new;
List<ID> pid = new List<ID>();
List <product2> plist = new List <product2> ();
if(Trigger.ISinsert)
{
for(integer i=0;i<cllist.size();i++)
{
pid.add(cllist[i].Course_name__c);
}
}
if(Trigger.ISupdate)
{
for(integer i=0;i<cllist.size();i++)
{
if(Trigger.old[i].Course_name__c != cllist[i].Course_name__c)
pid.add(cllist[i].Course_name__c);
}
}
if(pid.size()>0)
{
plist = [select isActive,Record_type_name__c from Product2 where id in :pid and Record_Type_name__c = 'Classroom'];
for(integer i=0;i<cllist.size();i++)
{
for(integer k=0;k<plist.size();k++)
{
if(cllist[i].Course_name__c == plist[k].Id)
{
cllist[i].Product_Isactive__c = plist[k].Isactive;

}
}
}
}
}