public with sharing class Fieldeventreport_class {
    public Field_Event__c event{get;set;}  
    public Parts__c part{get;set;} 
    Public string OtherFailed{get;set;}
    Public string OtherFailedSN{get;set;}
    Public List<Parts__c > PartList;
    public Fieldeventreport_class() {
     event = new Field_Event__c ();
     part = new Parts__c();
     PartList = new List<Parts__c>(); 
    }
    public PageReference saveEvent(){
        try{
        event.Report_Type__c = 'Engines';
        insert event;    
        if(Part.Primary_Failed_Part_Number__c != Null|| Part.Primary_Failed_S_N__c != Null){       
        Parts__c part1 = new Parts__c();
        part1.Field_Event__c = event.id; Part1.Primary_Part__c = true; Part1.Primary_Failed_Part_Number__c = Part.Primary_Failed_Part_Number__c; Part1.Primary_Failed_S_N__c = Part.Primary_Failed_S_N__c;            
        PartList.add(Part1);   
        }
        if(Part.Other_Failed_Part_Number__c != Null || Part.Other_Failed_S_N__c != Null){
        Parts__c part2 = new Parts__c();
        part2.Field_Event__c = event.id; Part2.Other_Failed_Part_Number__c = Part.Other_Failed_Part_Number__c; Part2.Other_Failed_S_N__c = Part.Other_Failed_S_N__c;
        PartList.add(Part2);
        }
        if(OtherFailed != ''|| OtherFailedSN != ''){
        Parts__c part3 = new Parts__c();
        part3.Field_Event__c = event.id; 
        Part3.Other_Failed_Part_Number__c = OtherFailed ;
        Part3.Other_Failed_S_N__c = OtherFailedSN ;       
        PartList.add(Part3);       
        }
        insert PartList;
        
        Field_Event__c EventName = [SELECT id,name from Field_Event__c where id =: event.id ];
        PageReference pageRef = new PageReference('/apex/NewFieldEventReportRequestDetailPage?FerRecordId='+EventName.name);
        pageRef.setRedirect(true);
        return pageRef;
        }catch(DMLException e){ 
        ApexPages.addMessages(e);
         return null;
        }
    }
      
    public pagereference cancelform(){
        PageReference pageRef = new PageReference('/apex/NewFieldEventReportRequest');
        pageRef.setRedirect(true);
        return pageRef;
    }
   /* public void customerDetails() {  
    try{
    contact con = [SELECT Id,Name,Email,Phone,AccountId from Contact where Email =: event.Customer_email_address__c ];
    if(event.Customer_email_address__c != Null){
        event.Account_Name__c= con.AccountId ;
        event.Contact__c = con.Id;
        event.Customer_Contact_Phone__c= con.Phone;  
    }
    else{
         ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Please enter valid Email OR Email id is not exist'));
    }
    }
    Catch(Exception e){
    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Please enter valid Email OR Email id is not exist'));
    }
         
      }*/
}