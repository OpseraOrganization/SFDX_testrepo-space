public class showrelatedlist
{
 public Boolean show{get; set;}
 static Id caseId;
 List<emailmessage> attach=new List<emailmessage>();  
 List<STring> st =new LIst<String>();
public showrelatedlist(ApexPages.StandardController controller) {
show=false;
caseId = System.currentPageReference().getParameters().get('Id');
System.debug('^^^^^^^^^^^^^^^^^^^^^'+caseid) ;
try{
attach=[Select Id,createdbyId,parentId,status,subject,INCOMING,hasattachment,toaddress,createddate from emailmessage
 where parentId=:caseId order by createddate desc];
 if(attach.size()>0)
 show=true;
 }
 catch(Exception e){}
}
public ID getcaseid(){ 
System.debug('%%%%%%%%%%%%%%%%'+caseid) ;
return caseid;
}
public List<emailmessage> getdata(){  
return attach;
}
public List<String> getallmodels(){ 

for(integer i=0;i<attach.size();i++)
{
if(attach[i].status == '1')
st.add('Read');
if(attach[i].status == '3')
st.add('Sent');
if(attach[i].status == '2')
st.add('Replied');
if(attach[i].status == '0')
st.add('New');
}
return st;
}
}