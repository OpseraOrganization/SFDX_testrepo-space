public class HwTrng_FrqQues_cls {

Set<String> strlist = new SEt<String>();

List<Solution> sollist = new List<Solution> ();


public Set<String> getallsol()
{
/* sollist = [select  id,faq__c,SolutionNotes__c from solution
where Record_Type_Name__c='Solution Training'  ];
for(integer i=0;i<sollist.size();i++)
{
strlist.add(sollist[i].faq__c);
}*/
return strlist; 
}


public List<Solution> getSol(){
sollist = [select  id,faq__c,SolutionNotes__c,IsPublishedInPublicKb,Status from solution
where Record_Type_Name__c='Solution Training' and IsPublishedInPublicKb = True and Status = 'Approved' ];
return sollist;
}
}