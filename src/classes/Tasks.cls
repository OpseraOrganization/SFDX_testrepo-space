//Controller to achieve My tasks List View in VF
public class Tasks{
//variable declarations
private string sortDirection = 'ASC'; 
private string sortExp = 'subject';
String listSel ;
String currentUser;
List<Task> tasks=new List<Task>(); 
List<Task> tasks1=new List<Task>();

Date startDate = System.Date.today().toStartOfMonth(); 
Date endDate = startDate.addMonths(1).addDays(-1);

public String sortExpression { 

get { 
return sortExp; 
} 

set { 
//if the column is clicked on then switch between Ascending and Descending modes 
if (value == sortExp) 
sortDirection = (sortDirection == 'ASC')? 'DESC' : 'ASC'; 
else 
sortDirection = 'ASC'; 
sortExp = value; 
} 
} 

public String getSortDirection() { 
//if not column is selected 
if (sortExpression == null || sortExpression == '') 
return 'ASC'; 
else 
return sortDirection; 
} 

public void setSortDirection(String value) { 
sortDirection = value; 
}

//constructor
public Tasks(ApexPages.StandardController controller) {
//getting the logged in user
String sortFullExp = sortExpression + ' ' + sortDirection;
currentUser=UserInfo.getUserId(); 
currentUser=currentUser.substring(0,15);
//getting the default task view which is Today
if(sortFullExp =='subject ASC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,Description,WhatId,Type,Activity_Number__c from Task where OwnerId=:currentUser and activityDate=:System.Today() ORDER BY subject ASC];
else if(sortFullExp =='subject DESC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,Description,WhatId,Type,Activity_Number__c from Task where OwnerId=:currentUser and activityDate=:System.Today() ORDER BY subject DESC];
else if(sortFullExp =='Priority ASC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,Description,WhatId,Type,Activity_Number__c from Task where OwnerId=:currentUser and activityDate=:System.Today() ORDER BY Priority ASC];
else if(sortFullExp =='Priority DESC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,Description,WhatId,Type,Activity_Number__c from Task where OwnerId=:currentUser and activityDate=:System.Today() ORDER BY Priority DESC];
else if(sortFullExp =='Status ASC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,Description,WhatId,Type,Activity_Number__c from Task where OwnerId=:currentUser and activityDate=:System.Today() ORDER BY Status ASC];
else if(sortFullExp =='Status DESC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,Description,WhatId,Type,Activity_Number__c from Task where OwnerId=:currentUser and activityDate=:System.Today() ORDER BY Status DESC];
else if(sortFullExp =='WhatId ASC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,Description,WhatId,Type,Activity_Number__c from Task where OwnerId=:currentUser and activityDate=:System.Today() ORDER BY WhatId ASC];
else if(sortFullExp =='WhatId DESC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,Description,WhatId,Type,Activity_Number__c from Task where OwnerId=:currentUser and activityDate=:System.Today() ORDER BY WhatId DESC];
else if(sortFullExp =='Type ASC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,Description,WhatId,Type,Activity_Number__c from Task where OwnerId=:currentUser and activityDate=:System.Today() ORDER BY Type ASC];
else if(sortFullExp =='Type DESC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,Description,WhatId,Type,Activity_Number__c from Task where OwnerId=:currentUser and activityDate=:System.Today() ORDER BY Type DESC];
else if(sortFullExp =='ActivityDate ASC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,Description,WhatId,Type,Activity_Number__c from Task where OwnerId=:currentUser and activityDate=:System.Today() ORDER BY ActivityDate ASC];
else if(sortFullExp =='ActivityDate DESC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,Description,WhatId,Type,Activity_Number__c from Task where OwnerId=:currentUser and activityDate=:System.Today() ORDER BY ActivityDate DESC];
else if(sortFullExp =='Activity_Number__c ASC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,Description,WhatId,Type,Activity_Number__c from Task where OwnerId=:currentUser and activityDate=:System.Today() ORDER BY Activity_Number__c ASC];
else if(sortFullExp =='Activity_Number__c DESC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,Description,WhatId,Type,Activity_Number__c from Task where OwnerId=:currentUser and activityDate=:System.Today() ORDER BY Activity_Number__c DESC];


}
//Getting the Selected List View 
public String getlistSel(){
return listSel;
} 
public void setlistSel(String listSel) {
this.listSel=listSel; 
}
//Refresh Method when Lists are selected
public void RefreshData(){
String sortFullExp = sortExpression + ' ' + sortDirection;
currentUser=UserInfo.getUserId(); 
currentUser=currentUser.substring(0,15);
//getting the data for different list views
if(listSel=='Today')
if(sortFullExp =='subject ASC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and activityDate=:System.Today() ORDER BY subject ASC];
else if(sortFullExp =='subject DESC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and activityDate=:System.Today() ORDER BY subject DESC];
else if(sortFullExp =='Priority ASC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and activityDate=:System.Today() ORDER BY Priority ASC];
else if(sortFullExp =='Priority DESC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and activityDate=:System.Today() ORDER BY Priority DESC];
else if(sortFullExp =='Status ASC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and activityDate=:System.Today() ORDER BY Status ASC];
else if(sortFullExp =='Status DESC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and activityDate=:System.Today() ORDER BY Status DESC]; 
else if(sortFullExp =='WhatId ASC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and activityDate=:System.Today() ORDER BY WhatId ASC];
else if(sortFullExp =='WhatId DESC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and activityDate=:System.Today() ORDER BY WhatId DESC];
else if(sortFullExp =='Type ASC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and activityDate=:System.Today() ORDER BY Type ASC];
else if(sortFullExp =='Type DESC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and activityDate=:System.Today() ORDER BY Type DESC];
else if(sortFullExp =='ActivityDate ASC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and activityDate=:System.Today() ORDER BY ActivityDate ASC];
else if(sortFullExp =='ActivityDate DESC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and activityDate=:System.Today() ORDER BY ActivityDate DESC];
else if(sortFullExp =='Activity_Number__c ASC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and activityDate=:System.Today() ORDER BY Activity_Number__c ASC];
else if(sortFullExp =='Activity_Number__c DESC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and activityDate=:System.Today() ORDER BY Activity_Number__c DESC];





if(listSel=='Tomorrow')
if(sortFullExp =='subject ASC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and activityDate=:System.Today()+1 ORDER BY subject ASC];
else if(sortFullExp =='subject DESC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and activityDate=:System.Today()+1 ORDER BY subject DESC];
else if(sortFullExp =='Priority ASC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and activityDate=:System.Today()+1 ORDER BY Priority ASC];
else if(sortFullExp =='Priority DESC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and activityDate=:System.Today()+1 ORDER BY Priority DESC];
else if(sortFullExp =='Status ASC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and activityDate=:System.Today()+1 ORDER BY Status ASC];
else if(sortFullExp =='Status DESC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and activityDate=:System.Today()+1 ORDER BY Status DESC];
else if(sortFullExp =='WhatId ASC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and activityDate=:System.Today()+1 ORDER BY WhatId ASC];
else if(sortFullExp =='WhatId DESC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and activityDate=:System.Today()+1 ORDER BY WhatId DESC];
else if(sortFullExp =='Type ASC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and activityDate=:System.Today()+1 ORDER BY Type ASC];
else if(sortFullExp =='Type DESC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and activityDate=:System.Today()+1 ORDER BY Type DESC];
else if(sortFullExp =='ActivityDate ASC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and activityDate=:System.Today()+1 ORDER BY ActivityDate ASC];
else if(sortFullExp =='ActivityDate DESC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and activityDate=:System.Today()+1 ORDER BY ActivityDate DESC];
else if(sortFullExp =='Activity_Number__c ASC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and activityDate=:System.Today()+1 ORDER BY Activity_Number__c ASC];
else if(sortFullExp =='Activity_Number__c DESC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and activityDate=:System.Today()+1 ORDER BY Activity_Number__c DESC];


if(listSel=='All Open')
if(sortFullExp =='subject ASC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and IsClosed!=true ORDER BY subject ASC];
else if(sortFullExp =='subject DESC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and IsClosed!=true ORDER BY subject DESC];
else if(sortFullExp =='Priority ASC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and IsClosed!=true ORDER BY Priority ASC];
else if(sortFullExp =='Priority DESC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and IsClosed!=true ORDER BY Priority DESC];
else if(sortFullExp =='Status ASC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and IsClosed!=true ORDER BY Status ASC];
else if(sortFullExp =='Status DESC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and IsClosed!=true ORDER BY Status DESC];
else if(sortFullExp =='WhatId ASC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and IsClosed!=true ORDER BY WhatId ASC];
else if(sortFullExp =='WhatId DESC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and IsClosed!=true ORDER BY WhatId DESC];
else if(sortFullExp =='Type DESC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and IsClosed!=true ORDER BY Type ASC];
else if(sortFullExp =='Type DESC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and IsClosed!=true ORDER BY Type DESC];
else if(sortFullExp =='ActivityDate ASC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and IsClosed!=true ORDER BY ActivityDate ASC];
else if(sortFullExp =='ActivityDate DESC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and IsClosed!=true ORDER BY ActivityDate DESC];
else if(sortFullExp =='Activity_Number__c ASC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and IsClosed!=true ORDER BY Activity_Number__c ASC];
else if(sortFullExp =='Activity_Number__c DESC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and IsClosed!=true ORDER BY Activity_Number__c DESC];



if(listSel=='Next 7 days')
if(sortFullExp =='subject ASC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and (activityDate>=:System.Today() and activityDate<=:System.Today()+7) ORDER BY subject ASC];
else if(sortFullExp =='subject DESC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and (activityDate>=:System.Today() and activityDate<=:System.Today()+7) ORDER BY subject DESC];
else if(sortFullExp =='Priority ASC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and (activityDate>=:System.Today() and activityDate<=:System.Today()+7) ORDER BY Priority ASC];
else if(sortFullExp =='Priority DESC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and (activityDate>=:System.Today() and activityDate<=:System.Today()+7) ORDER BY Priority DESC];
else if(sortFullExp =='Status ASC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and (activityDate>=:System.Today() and activityDate<=:System.Today()+7) ORDER BY Status ASC];
else if(sortFullExp =='Status DESC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and (activityDate>=:System.Today() and activityDate<=:System.Today()+7) ORDER BY Status DESC];
else if(sortFullExp =='WhatId ASC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and (activityDate>=:System.Today() and activityDate<=:System.Today()+7) ORDER BY WhatId ASC];
else if(sortFullExp =='WhatId DESC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and (activityDate>=:System.Today() and activityDate<=:System.Today()+7) ORDER BY WhatId DESC];
else if(sortFullExp =='Type ASC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and (activityDate>=:System.Today() and activityDate<=:System.Today()+7) ORDER BY Type ASC];
else if(sortFullExp =='Type DESC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and (activityDate>=:System.Today() and activityDate<=:System.Today()+7) ORDER BY Type DESC];
else if(sortFullExp =='ActivityDate ASC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and (activityDate>=:System.Today() and activityDate<=:System.Today()+7) ORDER BY ActivityDate ASC];
else if(sortFullExp =='ActivityDate DESC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and (activityDate>=:System.Today() and activityDate<=:System.Today()+7) ORDER BY ActivityDate DESC];
else if(sortFullExp =='Activity_Number__c ASC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and (activityDate>=:System.Today() and activityDate<=:System.Today()+7) ORDER BY Activity_Number__c ASC];
else if(sortFullExp =='Activity_Number__c DESC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and (activityDate>=:System.Today() and activityDate<=:System.Today()+7) ORDER BY Activity_Number__c DESC];





if(listSel=='This Month')
if(sortFullExp =='subject ASC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and (ActivityDate >=: startDate and ActivityDate <= :enddate) ORDER BY subject ASC];
else if(sortFullExp =='subject DESC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and (ActivityDate >=: startDate and ActivityDate <= :enddate) ORDER BY subject DESC];
else if(sortFullExp =='Priority ASC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and (ActivityDate >=: startDate and ActivityDate <= :enddate) ORDER BY Priority ASC];
else if(sortFullExp =='Priority DESC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and (ActivityDate >=: startDate and ActivityDate <= :enddate) ORDER BY Priority DESC];
else if(sortFullExp =='Status ASC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and (ActivityDate >=: startDate and ActivityDate <= :enddate) ORDER BY Status ASC];
else if(sortFullExp =='Status DESC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and (ActivityDate >=: startDate and ActivityDate <= :enddate) ORDER BY Status DESC];
else if(sortFullExp =='WhatId ASC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and (ActivityDate >=: startDate and ActivityDate <= :enddate) ORDER BY WhatId ASC];
else if(sortFullExp =='WhatId DESC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and (ActivityDate >=: startDate and ActivityDate <= :enddate) ORDER BY WhatId DESC];
else if(sortFullExp =='Type ASC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and (ActivityDate >=: startDate and ActivityDate <= :enddate) ORDER BY Type ASC];
else if(sortFullExp =='Type DESC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and (ActivityDate >=: startDate and ActivityDate <= :enddate) ORDER BY Type DESC];
else if(sortFullExp =='ActivityDate ASC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and (ActivityDate >=: startDate and ActivityDate <= :enddate) ORDER BY ActivityDate ASC];
else if(sortFullExp =='ActivityDate DESC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and (ActivityDate >=: startDate and ActivityDate <= :enddate) ORDER BY ActivityDate DESC];
else if(sortFullExp =='Activity_Number__c ASC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and (ActivityDate >=: startDate and ActivityDate <= :enddate) ORDER BY Activity_Number__c ASC];
else if(sortFullExp =='Activity_Number__c DESC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and (ActivityDate >=: startDate and ActivityDate <= :enddate) ORDER BY Activity_Number__c DESC];



if(listSel=='OverDue')
if(sortFullExp =='subject ASC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and activityDate< :System.Today()
and IsClosed!=true ORDER BY subject ASC ];
else if(sortFullExp =='subject DESC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and activityDate< :System.Today()
and IsClosed!=true ORDER BY subject DESC ];
else if(sortFullExp =='Priority ASC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and activityDate< :System.Today()
and IsClosed!=true ORDER BY Priority ASC ];
else if(sortFullExp =='Priority DESC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and activityDate< :System.Today()
and IsClosed!=true ORDER BY Priority DESC ];
else if(sortFullExp =='Status ASC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and activityDate< :System.Today()
and IsClosed!=true ORDER BY Status ASC];
else if(sortFullExp =='Status DESC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and activityDate< :System.Today()
and IsClosed!=true ORDER BY Status DESC];
else if(sortFullExp =='WhatId ASC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and activityDate< :System.Today()
and IsClosed!=true ORDER BY WhatId ASC];
else if(sortFullExp =='WhatId DESC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and activityDate< :System.Today()
and IsClosed!=true ORDER BY WhatId DESC];
else if(sortFullExp =='Type ASC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and activityDate< :System.Today()
and IsClosed!=true ORDER BY Type ASC];
else if(sortFullExp =='Type DESC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and activityDate< :System.Today()
and IsClosed!=true ORDER BY Type DESC];
else if(sortFullExp =='ActivityDate ASC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and activityDate< :System.Today()
and IsClosed!=true ORDER BY ActivityDate ASC];
else if(sortFullExp =='ActivityDate DESC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and activityDate< :System.Today()
and IsClosed!=true ORDER BY ActivityDate DESC];
else if(sortFullExp =='Activity_Number__c ASC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and activityDate< :System.Today()
and IsClosed!=true ORDER BY Activity_Number__c ASC];
else if(sortFullExp =='Activity_Number__c DESC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and activityDate< :System.Today()
and IsClosed!=true ORDER BY Activity_Number__c DESC];




if(listSel=='Today+OverDue')
if(sortFullExp =='subject ASC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and activityDate<= :System.Today()
and IsClosed!=true ORDER BY subject ASC];
else if(sortFullExp =='subject DESC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and activityDate<= :System.Today()
and IsClosed!=true ORDER BY subject DESC];
else if(sortFullExp =='Priority ASC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and activityDate<= :System.Today()
and IsClosed!=true ORDER BY Priority ASC];
else if(sortFullExp =='Priority DESC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and activityDate<= :System.Today()
and IsClosed!=true ORDER BY Priority DESC];
else if(sortFullExp =='Status ASC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and activityDate<= :System.Today()
and IsClosed!=true ORDER BY Priority ASC];
else if(sortFullExp =='Status DESC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and activityDate<= :System.Today()
and IsClosed!=true ORDER BY Priority DESC];
else if(sortFullExp =='WhatId ASC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and activityDate<= :System.Today()
and IsClosed!=true ORDER BY WhatId ASC];
else if(sortFullExp =='WhatId DESC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and activityDate<= :System.Today()
and IsClosed!=true ORDER BY WhatId DESC];
else if(sortFullExp =='Type ASC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and activityDate<= :System.Today()
and IsClosed!=true ORDER BY Type ASC];
else if(sortFullExp =='Type DESC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and activityDate<= :System.Today()
and IsClosed!=true ORDER BY Type DESC];
else if(sortFullExp =='ActivityDate ASC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and activityDate<= :System.Today()
and IsClosed!=true ORDER BY ActivityDate ASC];
else if(sortFullExp =='ActivityDate DESC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and activityDate<= :System.Today()
and IsClosed!=true ORDER BY ActivityDate DESC];
else if(sortFullExp =='Activity_Number__c ASC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and activityDate<= :System.Today()
and IsClosed!=true ORDER BY Activity_Number__c ASC];
else if(sortFullExp =='Activity_Number__c DESC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and activityDate<= :System.Today()
and IsClosed!=true ORDER BY Activity_Number__c DESC];




if(listSel=='Next 7 days+OverDue')
if(sortFullExp =='subject ASC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and (activityDate< :System.Today() or (activityDate>=:System.Today() and activityDate<=:System.Today()+7))
and IsClosed!=true ORDER BY subject ASC];// end of method
else if(sortFullExp =='subject DESC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and (activityDate< :System.Today() or (activityDate>=:System.Today() and activityDate<=:System.Today()+7))
and IsClosed!=true ORDER BY subject DESC];// end of method
else if(sortFullExp =='Priority ASC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and (activityDate< :System.Today() or (activityDate>=:System.Today() and activityDate<=:System.Today()+7))
and IsClosed!=true ORDER BY Priority ASC];// end of method
else if(sortFullExp =='Priority DESC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and (activityDate< :System.Today() or (activityDate>=:System.Today() and activityDate<=:System.Today()+7))
and IsClosed!=true ORDER BY Priority DESC];// end of method
else if(sortFullExp =='Status ASC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and (activityDate< :System.Today() or (activityDate>=:System.Today() and activityDate<=:System.Today()+7))
and IsClosed!=true ORDER BY Status ASC];// end of method
else if(sortFullExp =='Status DESC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and (activityDate< :System.Today() or (activityDate>=:System.Today() and activityDate<=:System.Today()+7))
and IsClosed!=true ORDER BY Status DESC];// end of method
else if(sortFullExp =='WhatId ASC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and (activityDate< :System.Today() or (activityDate>=:System.Today() and activityDate<=:System.Today()+7))
and IsClosed!=true ORDER BY WhatId ASC];// end of method
else if(sortFullExp =='WhatId DESC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and (activityDate< :System.Today() or (activityDate>=:System.Today() and activityDate<=:System.Today()+7))
and IsClosed!=true ORDER BY WhatId DESC];// end of method
else if(sortFullExp =='Type ASC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and (activityDate< :System.Today() or (activityDate>=:System.Today() and activityDate<=:System.Today()+7))
and IsClosed!=true ORDER BY Type ASC];// end of method
else if(sortFullExp =='Type DESC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and (activityDate< :System.Today() or (activityDate>=:System.Today() and activityDate<=:System.Today()+7))
and IsClosed!=true ORDER BY Type DESC];// end of method
else if(sortFullExp =='ActivityDate ASC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and (activityDate< :System.Today() or (activityDate>=:System.Today() and activityDate<=:System.Today()+7))
and IsClosed!=true ORDER BY ActivityDate ASC];// end of method
else if(sortFullExp =='ActivityDate DESC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and (activityDate< :System.Today() or (activityDate>=:System.Today() and activityDate<=:System.Today()+7))
and IsClosed!=true ORDER BY ActivityDate DESC];// end of method
else if(sortFullExp =='Activity_Number__c ASC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and (activityDate< :System.Today() or (activityDate>=:System.Today() and activityDate<=:System.Today()+7))
and IsClosed!=true ORDER BY Activity_Number__c ASC];// end of method
else if(sortFullExp =='Activity_Number__c DESC')
tasks=[Select Id, ActivityDate,subject,Priority,Status,WhatId,Description,Type,Activity_Number__c from Task where OwnerId=:currentUser and (activityDate< :System.Today() or (activityDate>=:System.Today() and activityDate<=:System.Today()+7))
and IsClosed!=true ORDER BY Activity_Number__c DESC];// end of method


}
//End of method

// getting the list of tasks
public List<Task> getTasks(){
return tasks;
}
}// end of class