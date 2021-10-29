trigger Product_Insertdummyclass on Product2 (after insert) {

List<Product2> prdtlst = Trigger.new;
List<ID> idlst = new List<ID>();
Location__c lh;
List<Class__c> clst = new List<Class__c>();
Date d =Date.newInstance(1990,08,12);
for(integer i=0;i<prdtlst.size();i++)
{
if(prdtlst[i].Record_Type_name__c == 'Classroom')
{
idlst.add(prdtlst[i].Id);
}
}
if(idlst.size()>0){
lh = [select name from Location__c where name ='Place Holder'];
}
for(integer i=0;i<idlst.size();i++)
{
Class__c c = new Class__c();
c.Course_Name__c = idlst[i];
c.Start_Date__c = d;
c.Location__c = lh.Id;
c.Class_Name__c='Place Holder';
clst.add(c);
}
if(clst.size()>0)
insert clst;
}