public with sharing class GTOConsoleHighlightsPanelExtension {
 
public id cid;
public boolean rendergreen{get;set;}
public boolean renderyellow{get;set;}
public boolean renderred{get;set;}
public boolean rendergray{get;set;}
public List<Case> cc{get;set;}

 public GTOConsoleHighlightsPanelExtension(ApexPages.StandardController controller){
 cid = ApexPages.currentPage().getParameters().get('id');
 cc = new list<case>();
 if(cid!= null){
 	cc=[select id,AccountId, contactid, createddate,isclosed from Case where Id=:cid];  
}
if(cc.size()>0){
	integer b = integer.valueOf((system.now().getTime()  -cc[0].createddate.getTime()) /(1000));
	
	list <casehistory> ch = [select createddate, newvalue from casehistory where caseid =:cc[0].id and field='Status' order by createddate asc];
	integer c=0;
	list <casehistory> ch1 = new list<casehistory>();
	for(casehistory cahi:ch){
		if(cahi.newvalue == 'Propose to Close'){
			ch1.add(cahi);
		}
	}
	if(ch1.size()>0){
		c=integer.valueOf((ch1[0].createddate.getTime()  -cc[0].createddate.getTime()) /(1000));
	}
	if((b>0 && b<43200 && !cc[0].isclosed)||(cc[0].isclosed && c>0 && c<43200)){
		rendergreen = true;
	}
	if((b>=43200 && b<72000 && !cc[0].isclosed) || (cc[0].isclosed && c>=43200 && c<72000)){
		renderyellow = true;
	}
	if((b>=72000 && b<86400 && !cc[0].isclosed) || (cc[0].isclosed && c>=72000 && c<86400)){
		renderred = true;
	}
	if( b>86400 && !cc[0].isclosed || (cc[0].isclosed && c>86400)){
		rendergray = true;
	}
	}
 }
    
    //contact cases count
public integer acc { 
    set;
    get {
    if(cid !=Null && cc[0].contactid!=null){
   AggregateResult CaseCount1 = [select  COUNT(ID) cnt1 from case where isclosed != true and contactid =:cc[0].contactId and recordtype.name ='Technical Issue'];
    
        if (CaseCount1 != null){
         acc = Integer.valueOf(CaseCount1.get('cnt1'));
         }else{
         acc=0;
         }
         }else{
         acc=0;
         }
        return acc;
    }
  }
  // last contacted based on previous case creation
  public string acc1 { 
    set;
    get {
    if(cid !=Null){
    list<case> CaseCount2 = [select  createddate from case where id !=: cc[0].id and contactid =:cc[0].contactId and recordtype.name ='Technical Issue' and createddate <=: cc[0].createddate order by createddate desc limit 1];
          
          if (CaseCount2.size() >0) {
          acc1= CaseCount2[0].createddate.month()+'/'+CaseCount2[0].createddate.day()+'/'+CaseCount2[0].createddate.year();
          }else{
          acc1=cc[0].createddate.month()+'/'+cc[0].createddate.day()+'/'+cc[0].createddate.year();
          }
          }
          else{
          acc1='None';}
        return acc1;
    }
  }
  // avg nss score
  public decimal acc2 { 
    set;
    get {
    if(cid !=Null){
    AggregateResult CaseCount3 = [select  AVG(Overall_Satisfaction__c) cnt2 from Feedback__c  where contact__c =:cc[0].contactId and recordtype.name ='NSS'];
          
          if (CaseCount3 != null ) {
          acc2= (Decimal)CaseCount3.get('cnt2');
          if(acc2>0){
          acc2 = acc2.setScale(2);
          }
          else{
          	acc2=0;
          }
          }else{
          acc2=0;
          }
          }
          else{
          acc2=0;}
        return acc2;
    }
  }
  // recent nss score
   public integer acc3 { 
    set;
    get {
    if(cid !=Null){
    list<Feedback__c> CaseCount4 = [select  Overall_Satisfaction__c from Feedback__c  where contact__c =:cc[0].contactId and recordtype.name ='NSS' order by createddate desc limit 1];
          
          if (CaseCount4.size() > 0) {
          acc3= Integer.valueOf(CaseCount4[0].Overall_Satisfaction__c);
          }else{
          acc3=0;
          }
          }
          else{
          acc3=0;}
        return acc3;
    }
  }
  
    // response time
   public string acc4 { 
    set;
    get {
    if(cid !=Null){
    list <casehistory> ch = [select createddate, newvalue from casehistory where caseid =:cc[0].id and field='Status' order by createddate asc];
	integer a = integer.valueOf((system.now().getTime()  -cc[0].createddate.getTime()) /(1000));
	integer c=0;
	list <casehistory> ch1 = new list<casehistory>();
	for(casehistory cahi:ch){
		if(cahi.newvalue == 'Propose to Close'){
			ch1.add(cahi);
		}
	}
	if(ch1.size()>0){
		c=integer.valueOf((ch1[0].createddate.getTime()  -cc[0].createddate.getTime()) /(1000));
	}
	Integer sec=0,min=0,hrs=0;
	string s='00',m='00',h='23';
	if(a<86400 && !cc[0].isclosed){
	if (a>60){
	sec = math.mod(a, 60);
	
	if(a<3600){
	min = (a-sec)/60;
	}
	if(a>3600){
		min = math.mod((a-sec)/60, 60);
		hrs = (a-min*60-sec)/(60*60);
	}
	if((23-hrs)<10){
		h='0'+(23-hrs).format();
	}else{
		h=(23-hrs).format();
	}
	if((60-min)<10){
		m='0'+(60-min).format();
    }else{
        m=(60-min).format();
    }  
	if((60-sec)<10){
		s='0'+(60-sec).format();
	}else{
		s=(60-sec).format();
	}
	acc4 = h+':'+m+':'+s;
	}else {
		acc4='23:59:'+(60-a);
	}
	}else if(c<86400){
		if (c>60){
	sec = math.mod(c, 60);
	
	if(c<3600){
	min = (c-sec)/60;
	}
	if(c>3600){
		min = math.mod((c-sec)/60, 60);
		hrs = (c-min*60-sec)/(60*60);
	}
	if((23-hrs)<10){
		h='0'+(23-hrs).format();
	}else{
		h=(23-hrs).format();
	}
	if((60-min)<10){
		m='0'+(60-min).format();
    }else{
        m=(60-min).format();
    }  
	if((60-sec)<10){
		s='0'+(60-sec).format();
	}else{
		s=(60-sec).format();
	}
	acc4 = h+':'+m+':'+s;
	}else {
		acc4='23:59:'+(60-c);
	}
	}
    }
          
        return acc4;
    }
  }
  public PageReference DoNothing() { return null; }
}