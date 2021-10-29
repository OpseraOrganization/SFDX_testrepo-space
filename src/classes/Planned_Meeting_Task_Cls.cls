public class Planned_Meeting_Task_Cls {

    public Planned_Meeting_Task_Cls() {

    }
    task TaskRec=new task();  
 task TaskRec1=new task();  
   {
id Tskid=Apexpages.currentPage().getParameters().get('id');
//id Tskid='00TT000000GiBnd';
System.debug('&&&&&&&&&&&&&'+Tskid);
TaskRec=[select id,Description,Priority,Resolution__c,ActivityDate,Completed_Date__c,Completed_Date_Time__c,Status,Type,Claimed_Amount__c,Paid_Amount__c,Initial_ISC_Contact__c,
Sub_Type__c,Reason_for_Escalation__c,Group_Requesting_Escalation__c,Action_Results__c,Subject,CreatedBy.name,What.name from task where id=:Tskid];
TaskRec1=[select id,Description,Priority,Resolution__c,ActivityDate,Completed_Date__c,Status,Type,Subject,CreatedBy.name,What.name,
Claimed_Amount__c,Paid_Amount__c,Initial_ISC_Contact__c,Sub_Type__c,Reason_for_Escalation__c,
Group_Requesting_Escalation__c,Action_Results__c from task where id=:Tskid];
}
Public task getTaskRec()    
  {         
     return TaskRec;    
  }
Public void setTaskRec()    
  {          
     this.TaskRec=TaskRec;    
  } 
   
//Description   
string textData=TaskRec.Description;

public string getTextData()
{
  return textData;
}

public void setTextData(string textData)
{
   this.textData=textData;
}

//Created by 
string CretdBy=TaskRec.CreatedBy.name;

public string getCretdBy()
{
  return CretdBy;
}

public void setCretdBy(string CretdBy)
{
   this.CretdBy=CretdBy;
}

//Related to
string RelatTo=TaskRec.what.name;

public string getRelatTo()
{
  return RelatTo;
}

public void setRelatTo(string RelatTo)
{
   this.RelatTo=RelatTo;
}

//Subject picklist value
String SubjctPickval=TaskRec.Subject;
public string getSubjctPickval()
{
  
  return SubjctPickval;
}
public void setSubjctPickval(string SubjctPickval)
{
  
  this.SubjctPickval=SubjctPickval;
} 
public List<SelectOption> SubjectOptions {get;set;}

public list<SelectOption> getSubjectpiclstval()
{
List<SelectOption> Subjtoptions = new List<SelectOption>();    
        Subjtoptions .add(new SelectOption('--None--','--None--'));


 Schema.DescribeFieldResult status= task.subject.getDescribe();

        // For each picklist value, create a new select option
             Schema.DescribeFieldResult F = task.subject.getDescribe();
    List<Schema.PicklistEntry> peList = F.getPicklistValues();

for(Integer i=0;i<peList.size();i++){
            String temp = peList[i].getValue();
            Subjtoptions .add(new SelectOption(temp,temp));       
        
        }



return Subjtoptions;
} 
   
   
//Resolution

string ActionRst=TaskRec.Action_Results__c;

public string getActionRst()
{
  return ActionRst;
}

public void setActionRst(string ActionRst)
{
   this.ActionRst=ActionRst;
}
//claimed amount
decimal ClaimdAmnt=TaskRec.Claimed_Amount__c;

public decimal getClaimdAmnt()
{
  return ClaimdAmnt;
}

public void setClaimdAmnt(decimal ClaimdAmnt)
{
   this.ClaimdAmnt=ClaimdAmnt;
}

//Due date
date DueDte=TaskRec.ActivityDate;

public date getDueDte()
{
  return DueDte;
}

//completed date
date CmpltDte=TaskRec.Completed_Date__c;

public date getCmpltDte()
{
  return CmpltDte;
}
//completed date time
datetime CmpltDteTme=TaskRec.Completed_Date_Time__c;

public datetime getCmpltDteTme()
{
  return CmpltDteTme;
}

/*public void setDueDte(date DueDte)
{
   this.DueDte=DueDte;
}*/
 
 
 
 date Compltddate=TaskRec.Completed_Date__c;

public date getCompltddate()
{
  return Compltddate;
}
//Paid Amount
decimal PaidAmnt=TaskRec.Paid_Amount__c;

public decimal getPaidAmnt()
{
  return PaidAmnt;
}

public void setPaidAmnt(decimal PaidAmnt)
{
   this.PaidAmnt=PaidAmnt;
} 
      
//status picklist values
String statusPickval=TaskRec.Status;
public string getStatuspiclst()
{
  
  return statusPickval;
}
public void setStatuspiclst(string statusPickval)
{
  
  this.statusPickval=statusPickval;
} 
public List<SelectOption> statusOptions {get;set;}

public list<SelectOption> getStatuspiclstval()
{
List<SelectOption> options = new List<SelectOption>();    
        options.add(new SelectOption('--None--','--None--'));

List<SelectOption> ListStatusVal= new List<SelectOption>();
ListStatusVal.add(new SelectOption('Optional','Optional'));
 Schema.DescribeFieldResult status= task.Status.getDescribe();

        // For each picklist value, create a new select option
             Schema.DescribeFieldResult F = task.status.getDescribe();
    List<Schema.PicklistEntry> peList = F.getPicklistValues();

for(Integer i=0;i<peList.size();i++){
            String temp = peList[i].getValue();
            options.add(new SelectOption(temp,temp));       
        
        }



return options;
} 
   
//Priortiy picklist
String PriortyPickval=TaskRec.Priority;
public string getPriortyPickval()
{
  
  return PriortyPickval;
}
public void setPriortyPickval(string PriortyPickval)
{
  
  this.PriortyPickval=PriortyPickval;
} 

public list<SelectOption> getPriortiypiclstval()
{
List<SelectOption> options1 = new List<SelectOption>();    
        options1.add(new SelectOption('--None--','--None--'));

             Schema.DescribeFieldResult F = task.Priority.getDescribe();
    List<Schema.PicklistEntry> peList = F.getPicklistValues();

for(Integer i=0;i<peList.size();i++){
            String temp = peList[i].getValue();
            options1.add(new SelectOption(temp,temp));       
        
        }
return options1;
}

//Type piclist

String TypePickval=TaskRec.Type;
public string getTypePickval()
{
  
  return TypePickval;
}
public void setTypePickval(string TypePickval)
{
  
  this.TypePickval=TypePickval;
} 

public list<SelectOption> getTypepiclstval()
{
List<SelectOption> options2 = new List<SelectOption>();    
        options2.add(new SelectOption('--None--','--None--'));

             Schema.DescribeFieldResult F = task.type.getDescribe();
    List<Schema.PicklistEntry> peList = F.getPicklistValues();

for(Integer i=0;i<peList.size();i++){
            String temp = peList[i].getValue();
            options2.add(new SelectOption(temp,temp));       
        
        }
return options2;
}
//Update Method     
public pagereference Save() 
  {

//   task TaskNewRec=new task();
system.debug('*********'+textData);
String cnam = Apexpages.currentPage().getParameters().get('duedte');
 system.debug('111KKKKKKKKKK'+cnam) ;
TaskRec1.Status=statusPickval;
TaskRec1.Priority=PriortyPickval;
TaskRec1.Type=TypePickval;
TaskRec1.Description__c=textData;
TaskRec1.Action_Results__c=ActionRst;
TaskRec1.Claimed_Amount__c=ClaimdAmnt;
TaskRec1.Paid_Amount__c=PaidAmnt;
TaskRec1.ActivityDate=DueDte;
TaskRec1.Subject=SubjctPickval;

/*TaskRec1.Status=TaskRec.Status;
TaskRec1.Type=TaskRec.Type;
TaskRec1.Claimed_Amount__c=TaskRec.Claimed_Amount__c;
TaskRec1.Paid_Amount__c=TaskRec.Paid_Amount__c;
TaskRec1.Initial_ISC_Contact__c=TaskRec.Initial_ISC_Contact__c;
TaskRec1.Sub_Type__c=TaskRec.Sub_Type__c;
TaskRec1.Reason_for_Escalation__c=TaskRec.Reason_for_Escalation__c;
TaskRec1.Group_Requesting_Escalation__c=TaskRec.Group_Requesting_Escalation__c;*/
 update TaskRec1;

Pagereference p = new pagereference('http://honeywellaero.force.com/PlannedMeetingTask/ThankYouPage');    
   // Pagereference p = new pagereference('/'+CaseNewRec.id); 
     return p;


  }     
}