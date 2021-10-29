global class oppschedule implements Schedulable 
{
integer yr ;
global oppschedule(integer y)
{
yr = y;
}
global void execute(SchedulableContext ctx) 
{
system.debug('*************Inside execute method of the oppschedule class');
system.debug('*************parameter check' + yr);
integer count=0;
integer k;
String str = String.valueof(yr);
List<AOP_For_Sales_Manger__c> processlist = new List<AOP_For_Sales_Manger__c> ();
List<AOP_For_Sales_Manger__c> aopsmlist = [select name,id,Flag__c from AOP_For_Sales_Manger__c where AOP_Year__c = :str order by name ];
system.debug('*************aopsmlist.size'+aopsmlist.size());
if(aopsmlist.size() > 12)
k=aopsmlist.size()/12;
else
k=0;
for(integer i=0;i<aopsmlist.size();i++)
{
if(aopsmlist[i].Flag__c!='Processed' && count<=k && count<5)
{
processlist.add(aopsmlist[i]);
count = count+1;
}
}
system.debug('*************processlist.size'+processlist.size());


for(integer i=0;i<processlist.size();i++)
{
calculateAOP cp = new calculateAOP(processlist[i].id,yr);
cp.calculate();
}
}
}