@isTest(SeeAllData = true)
Public class Fieldeventreport_classTest{
    Public static testmethod void FieldeventreportMethod(){
       test.startTest();
        Field_Event__c event = new Field_Event__c();
        event.Report_Type__c='Enginees';
        event.Report_Date__c = system.today();
        event.Operational_Symptom__c = 'Air Leak';
        insert event;      
        //List<Parts__c> PartList = new List<Parts__c>(); 
        Parts__c Part = new Parts__c();
        Part.Field_Event__c = event.id;
        Part.Primary_Failed_Part_Number__c ='Test';
        Part.Primary_Failed_S_N__c ='Test';
        Part.Primary_Part__c = true;
        Part.Other_Failed_Part_Number__c ='';
        Part.Other_Failed_S_N__c= '';
        insert Part;
        //Part.Retention_Hold__c = True;
        //Part.Retention_Hold_Reason__c = 'On Hold pending record data owner approval to remove/purge';
       /* PartList.add(Part);
        Parts__c Part1 = new Parts__c();
        Part1.Field_Event__c = event.id;
        Part1.Primary_Failed_Part_Number__c ='';
        Part1.Primary_Failed_S_N__c ='';
        Part1.Other_Failed_Part_Number__c ='Test';
        Part1.Other_Failed_S_N__c= 'Test';
        PartList.add(Part1); 
        insert PartList;        
        Parts__c Parts= [SELECT Id,Name,Field_Event__c,Primary_Failed_Part_Number__c,Other_Failed_Part_Number__c,Other_Failed_S_N__c FROM Parts__c where Other_Failed_Part_Number__c != Null limit 1 ];
        Parts.Other_Failed_Part_Number__c ='';
        Update parts;
        */
        PageReference pageRef = Page.NewFieldEventReportRequest; 
        Test.setCurrentPage(pageRef);
        Fieldeventreport_class Field = new Fieldeventreport_class();
        Field.saveEvent();
        Field.cancelform();
        Field.event=event;
        test.stopTest();
    }
    Public static testmethod void FieldeventreportMethod1(){
        test.startTest();
            case cas=new case();
             cas.subject='test';
             insert cas;
            Field_Event__c event = new Field_Event__c();
            event.Report_Type__c='Enginees';
            event.Report_Date__c = system.today();
            event.Operational_Symptom__c = 'Air Leak';
            event.case_number__c=cas.id;
            event.created_in_salesforce1__c=true;
            insert event;           
        test.stopTest();
    }
    Public static testmethod void FieldeventreportMethod2(){
        test.startTest();
            contact con=new contact();
            con.firstname='test';
            con.lastname='testname';
            con.email='test@gmail.com';
            insert con;
            Field_Event__c event = new Field_Event__c();
            event.Report_Type__c='Enginees';
            event.Report_Date__c = system.today();
            event.Operational_Symptom__c = 'Air Leak';
            event.Contact__c=con.id;
            event.created_in_salesforce1__c=true;
            event.Engine_Model__c='123456';
            insert event;           
        test.stopTest();
    }
}