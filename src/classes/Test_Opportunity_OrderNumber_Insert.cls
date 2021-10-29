@isTest
private class Test_Opportunity_OrderNumber_Insert{    
    static testMethod void myUnitTest1() {
        Account a1 = New Account(Name= 'sbuaccount', Strategic_Business_Unit__c = 'D&S', CBT__c = 'HTSI');
        insert a1;  
        
        Date d1 =Date.newInstance(2009,08,12); // D&S Complex
        Id rr1 = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('BGA OE').getRecordTypeId();        
        Id rr2 = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('D&S Complex FollowOn').getRecordTypeId();
        Id rr3 = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('BGA AM').getRecordTypeId();        
        Id r1 = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('D&S PrePriced').getRecordTypeId();        
        Id r2 = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('D&S PrePriced FollowOn').getRecordTypeId();  
        Id r3 = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('D&S PrePriced Restricted FollowOn').getRecordTypeId();        
        Id r4 = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('D&S Complex Restricted').getRecordTypeId();
        Id r5 = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('D&S PrePriced Restricted').getRecordTypeId();                
        Id r6 = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('D&S Complex Restricted FollowOn').getRecordTypeId();                
        Id r7 = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('D&S Standard').getRecordTypeId();  
        Id r8 = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('D&S Standard Restricted').getRecordTypeId();
        Id r9 = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('D&S Standard FollowOn').getRecordTypeId();
        Id r10 = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('D&S Standard Restricted FollowOn').getRecordTypeId();
		
		Platform__c plate = new Platform__c(name = 'Dassault Aviation Falcon 8X',Platform_Type__c = 'Helicopter	', Managing_SBU__c = 'D&S',Model__c = 'aircraft2102', Make__c = 'D&S aircraft3044');
		insert plate;
		Fleet_Asset_Detail__c fad = new Fleet_Asset_Detail__c(name = 'Dassault Aviation Falcon 900 LX S=EX283', Platform_Name__c = plate.id  );
		insert fad;
		
        List<Opportunity> O = new List<Opportunity>();  
        Opportunity oo1 = new Opportunity(Name='Complexopp', recordtypeid =rr1,Accountid=a1.Id,StageName='Prospecting',CloseDate=d1,Opportunity_Order_Numbers__c='14535;89678',ATR_Aircraft_Quantity__c=1,Is_Converted__c=true,RFP_Expected_Date__c =d1+23,RDE_Amount__c=232,Certification_Requirements__c='Certification_Requirements__c',Is_Restricted_Opportunity__c = true,Is_Follow_On_Opportunity__c = true);
        O.add(oo1);
        Opportunity op1 = new Opportunity(Name='Complexopp', recordtypeid =rr2,Accountid=a1.Id,StageName='Prospecting',CloseDate=d1,Opportunity_Order_Numbers__c='14535;89678',ATR_Aircraft_Quantity__c=1,Is_Converted__c=true,RFP_Expected_Date__c =d1+23,RDE_Amount__c=232,Certification_Requirements__c='Certification_Requirements__c',Is_Restricted_Opportunity__c = true,Is_Follow_On_Opportunity__c = true);
        O.add(op1);
        Opportunity oq1 = new Opportunity(Name='Complexopp', recordtypeid =rr3,Accountid=a1.Id,StageName='Prospecting',CloseDate=d1,Opportunity_Order_Numbers__c='14535;89678',ATR_Aircraft_Quantity__c=1,Is_Converted__c=true,RFP_Expected_Date__c =d1+23,RDE_Amount__c=232,Certification_Requirements__c='Certification_Requirements__c',Is_Restricted_Opportunity__c = true,Is_Follow_On_Opportunity__c = true);
        O.add(oq1);
        Opportunity o1 = new Opportunity(Name='Complexopp', recordtypeid =r1,Accountid=a1.Id,StageName='Prospecting',CloseDate=d1,Opportunity_Order_Numbers__c='14535;89678',ATR_Aircraft_Quantity__c=1,Is_Converted__c=true,RFP_Expected_Date__c =d1+23,RDE_Amount__c=232,Certification_Requirements__c='Certification_Requirements__c',Is_Restricted_Opportunity__c = true,Is_Follow_On_Opportunity__c = true);
        O.add(o1);
        Opportunity o2 = new Opportunity(Name='Compleqwxopp',recordtypeid =r2,Accountid=a1.Id,StageName='Prospecting',CloseDate=d1+1,Opportunity_Order_Numbers__c='1453393678',ATR_Aircraft_Quantity__c=2,Is_Converted__c=true,RFP_Expected_Date__c =d1+23,RDE_Amount__c=232,Certification_Requirements__c='Certification_Requirements__c',Is_Restricted_Opportunity__c = true ,Is_Follow_On_Opportunity__c =true);
        O.add(o2);
        Opportunity o3 = new Opportunity(Name='Compleqwxopp',recordtypeid =r3,Accountid=a1.Id,StageName='Prospecting',CloseDate=d1+1,Opportunity_Order_Numbers__c='1453393678',ATR_Aircraft_Quantity__c=2,Is_Converted__c=true,RFP_Expected_Date__c =d1+23,RDE_Amount__c=232,Certification_Requirements__c='Certification_Requirements__c',Is_Restricted_Opportunity__c = true ,Is_Follow_On_Opportunity__c =true);
        O.add(o3);
        Opportunity o4 = new Opportunity(Name='Compleqwxopp',recordtypeid =r4,Accountid=a1.Id,StageName='Prospecting',CloseDate=d1+1,Opportunity_Order_Numbers__c='1453393678',ATR_Aircraft_Quantity__c=2,Is_Converted__c=true,RFP_Expected_Date__c =d1+23,RDE_Amount__c=232,Certification_Requirements__c='Certification_Requirements__c',Is_Restricted_Opportunity__c = true ,Is_Follow_On_Opportunity__c =true);
        O.add(o4);
        Opportunity o5 = new Opportunity(Name='Compleqwxopp',recordtypeid =r5,Accountid=a1.Id,StageName='Prospecting',CloseDate=d1+1,Opportunity_Order_Numbers__c='1453393678',ATR_Aircraft_Quantity__c=2,Is_Converted__c=true,RFP_Expected_Date__c =d1+23,RDE_Amount__c=232,Certification_Requirements__c='Certification_Requirements__c',Is_Restricted_Opportunity__c = true ,Is_Follow_On_Opportunity__c =true);
        O.add(o5);
        Opportunity o6 = new Opportunity(Name='Compleqwxopp',recordtypeid =r6,Accountid=a1.Id,StageName='Prospecting',CloseDate=d1+1,Opportunity_Order_Numbers__c='1453393678',ATR_Aircraft_Quantity__c=2,Is_Converted__c=true,RFP_Expected_Date__c =d1+23,RDE_Amount__c=232,Certification_Requirements__c='Certification_Requirements__c',Is_Restricted_Opportunity__c = true,Is_Follow_On_Opportunity__c =true);
        O.add(o6);
        Opportunity o7 = new Opportunity(Name='Compleqwxopp',recordtypeid =r7,Accountid=a1.Id,StageName='Prospecting',CloseDate=d1+1,Opportunity_Order_Numbers__c='1453393678',ATR_Aircraft_Quantity__c=2,Is_Converted__c=true,RFP_Expected_Date__c =d1+23,RDE_Amount__c=232,Certification_Requirements__c='Certification_Requirements__c',Is_Restricted_Opportunity__c = true ,Is_Follow_On_Opportunity__c =true);
        O.add(o7);
        Opportunity o8 = new Opportunity(Name='Compleqwxopp',recordtypeid =r8,Accountid=a1.Id,StageName='Prospecting',CloseDate=d1+1,Opportunity_Order_Numbers__c='1453393678',ATR_Aircraft_Quantity__c=2,Is_Converted__c=true,RFP_Expected_Date__c =d1+23,RDE_Amount__c=232,Certification_Requirements__c='Certification_Requirements__c',Is_Restricted_Opportunity__c = true ,Is_Follow_On_Opportunity__c =true);
        O.add(o8);
        Opportunity o9 = new Opportunity(Name='Compleqwxopp',recordtypeid =r9,Accountid=a1.Id,StageName='Prospecting',CloseDate=d1+1,Opportunity_Order_Numbers__c='1453393678',ATR_Aircraft_Quantity__c=2,Is_Converted__c=true,RFP_Expected_Date__c =d1+23,RDE_Amount__c=232,Certification_Requirements__c='Certification_Requirements__c',Is_Restricted_Opportunity__c = true ,Is_Follow_On_Opportunity__c =true);
        O.add(o9);
        Opportunity o10 = new Opportunity(Name='Compleqwxopp',recordtypeid =r10,Accountid=a1.Id,StageName='Prospecting',CloseDate=d1+1,Opportunity_Order_Numbers__c='1453393678',ATR_Aircraft_Quantity__c=2,Is_Converted__c=true,RFP_Expected_Date__c =d1+23,RDE_Amount__c=232,Certification_Requirements__c='Certification_Requirements__c',Is_Restricted_Opportunity__c = false ,Is_Follow_On_Opportunity__c =true);
        O.add(o10);        
        
        
        insert O;
        system.debug('------v----->'+O);        
        List<Opportunity_Gate__c> opGate = new List<Opportunity_Gate__c>();
        Opportunity_Gate__c og = new Opportunity_Gate__c(Serial_No__c=1, Name='Pre-Screen', Opportunity__c=o1.id, Opportunity_Type__c='D&S Complex', Status__c='Open',Completion_Date__c =d1+20, Actual_Date__c = d1+21);   
        opGate.add(og);
        
        Opportunity_Gate__c og1 = new Opportunity_Gate__c(Serial_No__c=1, Name='Pre-Screen', Opportunity__c=o2.id, Opportunity_Type__c='D&S Complex', Status__c='Open',Completion_Date__c =d1+10, Actual_Date__c = d1+17);
        opGate.add(og1);
        
        insert opGate;  

        try {
            Test.startTest();
            o1.recordtypeid =r2;
            update o1;            
            Test.stopTest();            
        } catch(System.DMLException e){
            System.assert(e.getMessage().contains('Please clean up Duplicate Order Number to Proceed'),e.getMessage());
        }
    }   
    
    static testMethod void myUnitTest2() {
        Account a1 = New Account(Name= 'sbuaccount', Strategic_Business_Unit__c = 'D&S', CBT__c = 'HTSI');
        insert a1;  
        
        Date d1 =Date.newInstance(2009,08,12); //D&S PrePriced
        Id rr1 = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('BGA AM').getRecordTypeId();        
        Id rr2 = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('D&S Complex FollowOn').getRecordTypeId();
        Id rr3 = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('D&S Complex').getRecordTypeId();    
        Id r1 = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('BGA OE').getRecordTypeId();        
        Id r2 = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('D&S PrePriced FollowOn').getRecordTypeId();  
        Id r3 = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('D&S PrePriced Restricted FollowOn').getRecordTypeId();        
        Id r4 = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('D&S Complex Restricted').getRecordTypeId();
        Id r5 = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('D&S PrePriced Restricted').getRecordTypeId();                
        Id r6 = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('D&S Complex Restricted FollowOn').getRecordTypeId();                
        Id r7 = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('D&S Standard').getRecordTypeId();  
        Id r8 = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('D&S Standard Restricted').getRecordTypeId();
        Id r9 = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('D&S Standard FollowOn').getRecordTypeId();
        Id r10 = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('D&S Standard Restricted FollowOn').getRecordTypeId();
        
        List<Opportunity> O = new List<Opportunity>();
        Opportunity o1r2 = new Opportunity(Name='Complexopp',recordtypeid =rr1,Accountid=a1.Id,StageName='Prospecting',CloseDate=d1,Opportunity_Order_Numbers__c='14535;89678',ATR_Aircraft_Quantity__c=1,Is_Converted__c=true,RFP_Expected_Date__c =d1+23,RDE_Amount__c=232,Certification_Requirements__c='Certification_Requirements__c',Is_Restricted_Opportunity__c = false,Is_Follow_On_Opportunity__c = true);
        O.add(o1r2);
        Opportunity o12r = new Opportunity(Name='Complexopp',recordtypeid =rr2,Accountid=a1.Id,StageName='Prospecting',CloseDate=d1,Opportunity_Order_Numbers__c='14535;89678',ATR_Aircraft_Quantity__c=1,Is_Converted__c=true,RFP_Expected_Date__c =d1+23,RDE_Amount__c=232,Certification_Requirements__c='Certification_Requirements__c',Is_Restricted_Opportunity__c = false,Is_Follow_On_Opportunity__c = true);
        O.add(o12r);
        Opportunity ro12 = new Opportunity(Name='Complexopp',recordtypeid =rr3,Accountid=a1.Id,StageName='Prospecting',CloseDate=d1,Opportunity_Order_Numbers__c='14535;89678',ATR_Aircraft_Quantity__c=1,Is_Converted__c=true,RFP_Expected_Date__c =d1+23,RDE_Amount__c=232,Certification_Requirements__c='Certification_Requirements__c',Is_Restricted_Opportunity__c = false,Is_Follow_On_Opportunity__c = true);
        O.add(ro12);
        
        Opportunity o12 = new Opportunity(Name='Complexopp',recordtypeid =r1,Accountid=a1.Id,StageName='Prospecting',CloseDate=d1,Opportunity_Order_Numbers__c='14535;89678',ATR_Aircraft_Quantity__c=1,Is_Converted__c=true,RFP_Expected_Date__c =d1+23,RDE_Amount__c=232,Certification_Requirements__c='Certification_Requirements__c',Is_Restricted_Opportunity__c = false,Is_Follow_On_Opportunity__c = true);
        O.add(o12);
        Opportunity o22 = new Opportunity(Name='Compleqwxopp',recordtypeid =r2,Accountid=a1.Id,StageName='Prospecting',CloseDate=d1+1,Opportunity_Order_Numbers__c='1453393678',ATR_Aircraft_Quantity__c=2,Is_Converted__c=true,RFP_Expected_Date__c =d1+23,RDE_Amount__c=232,Certification_Requirements__c='Certification_Requirements__c',Is_Restricted_Opportunity__c = false ,Is_Follow_On_Opportunity__c =true);
        O.add(o22);
        Opportunity o32 = new Opportunity(Name='Compleqwxopp',recordtypeid =r3,Accountid=a1.Id,StageName='Prospecting',CloseDate=d1+1,Opportunity_Order_Numbers__c='1453393678',ATR_Aircraft_Quantity__c=2,Is_Converted__c=true,RFP_Expected_Date__c =d1+23,RDE_Amount__c=232,Certification_Requirements__c='Certification_Requirements__c',Is_Restricted_Opportunity__c = false ,Is_Follow_On_Opportunity__c =true);
        O.add(o32);
        Opportunity o42 = new Opportunity(Name='Compleqwxopp',recordtypeid =r4,Accountid=a1.Id,StageName='Prospecting',CloseDate=d1+1,Opportunity_Order_Numbers__c='1453393678',ATR_Aircraft_Quantity__c=2,Is_Converted__c=true,RFP_Expected_Date__c =d1+23,RDE_Amount__c=232,Certification_Requirements__c='Certification_Requirements__c',Is_Restricted_Opportunity__c = false ,Is_Follow_On_Opportunity__c =true);
        O.add(o42);
        Opportunity o52 = new Opportunity(Name='Compleqwxopp',recordtypeid =r5,Accountid=a1.Id,StageName='Prospecting',CloseDate=d1+1,Opportunity_Order_Numbers__c='1453393678',ATR_Aircraft_Quantity__c=2,Is_Converted__c=true,RFP_Expected_Date__c =d1+23,RDE_Amount__c=232,Certification_Requirements__c='Certification_Requirements__c',Is_Restricted_Opportunity__c = false ,Is_Follow_On_Opportunity__c =true);
        O.add(o52);
        Opportunity o62 = new Opportunity(Name='Compleqwxopp',recordtypeid =r6,Accountid=a1.Id,StageName='Prospecting',CloseDate=d1+1,Opportunity_Order_Numbers__c='1453393678',ATR_Aircraft_Quantity__c=2,Is_Converted__c=true,RFP_Expected_Date__c =d1+23,RDE_Amount__c=232,Certification_Requirements__c='Certification_Requirements__c',Is_Restricted_Opportunity__c = false,Is_Follow_On_Opportunity__c =true);
        O.add(o62);
        Opportunity o72 = new Opportunity(Name='Compleqwxopp',recordtypeid =r7,Accountid=a1.Id,StageName='Prospecting',CloseDate=d1+1,Opportunity_Order_Numbers__c='1453393678',ATR_Aircraft_Quantity__c=2,Is_Converted__c=true,RFP_Expected_Date__c =d1+23,RDE_Amount__c=232,Certification_Requirements__c='Certification_Requirements__c',Is_Restricted_Opportunity__c = false ,Is_Follow_On_Opportunity__c =true);
        O.add(o72);
        Opportunity o82 = new Opportunity(Name='Compleqwxopp',recordtypeid =r8,Accountid=a1.Id,StageName='Prospecting',CloseDate=d1+1,Opportunity_Order_Numbers__c='1453393678',ATR_Aircraft_Quantity__c=2,Is_Converted__c=true,RFP_Expected_Date__c =d1+23,RDE_Amount__c=232,Certification_Requirements__c='Certification_Requirements__c',Is_Restricted_Opportunity__c = false ,Is_Follow_On_Opportunity__c =true);
        O.add(o82);
        Opportunity o92 = new Opportunity(Name='Compleqwxopp',recordtypeid =r9,Accountid=a1.Id,StageName='Prospecting',CloseDate=d1+1,Opportunity_Order_Numbers__c='1453393678',ATR_Aircraft_Quantity__c=2,Is_Converted__c=true,RFP_Expected_Date__c =d1+23,RDE_Amount__c=232,Certification_Requirements__c='Certification_Requirements__c',Is_Restricted_Opportunity__c = false ,Is_Follow_On_Opportunity__c =true);
        O.add(o92);
        Opportunity o102 = new Opportunity(Name='Compleqwxopp',recordtypeid =r10,Accountid=a1.Id,StageName='Prospecting',CloseDate=d1+1,Opportunity_Order_Numbers__c='1453393678',ATR_Aircraft_Quantity__c=2,Is_Converted__c=true,RFP_Expected_Date__c =d1+23,RDE_Amount__c=232,Certification_Requirements__c='Certification_Requirements__c',Is_Restricted_Opportunity__c = false ,Is_Follow_On_Opportunity__c =true);
        O.add(o102);
        insert O;       
        List<Opportunity_Gate__c> opGate = new List<Opportunity_Gate__c>();
        Opportunity_Gate__c og = new Opportunity_Gate__c(Serial_No__c=1, Name='Pre-Screen', Opportunity__c=o12.id, Opportunity_Type__c='D&S Complex', Status__c='Open',Completion_Date__c =d1+20, Actual_Date__c = d1+21);  
        opGate.add(og);     
        Opportunity_Gate__c og1 = new Opportunity_Gate__c(Serial_No__c=1, Name='Pre-Screen', Opportunity__c=o22.id, Opportunity_Type__c='D&S Complex', Status__c='Open',Completion_Date__c =d1+10, Actual_Date__c = d1+17);
        opGate.add(og1);
        
        
        insert opGate;
        OppClassForPublicMethods oppclass = new OppClassForPublicMethods();
        try {
            Test.startTest();
            o12.recordtypeid =r2;
            update o12;            
            Test.stopTest();            
        } catch(System.DMLException e){
            System.assert(e.getMessage().contains('Please clean up Duplicate Order Number to Proceed'),e.getMessage());
        }
    }
    
    static testMethod void myUnitTest3() {
        Account a1 = New Account(Name= 'sbuaccount', Strategic_Business_Unit__c = 'D&S', CBT__c = 'HTSI');
        insert a1;  
        
        Date d1 =Date.newInstance(2009,08,12);
        Id rr1 = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('BGA AM').getRecordTypeId();        
        Id rr2 = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('D&S Complex FollowOn').getRecordTypeId();
        Id rr3 = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('D&S Complex').getRecordTypeId();      
        Id r1 = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('D&S PrePriced').getRecordTypeId();        
        Id r2 = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('D&S PrePriced FollowOn').getRecordTypeId();  
        Id r3 = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('D&S PrePriced Restricted FollowOn').getRecordTypeId();        
        Id r4 = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('D&S Complex Restricted').getRecordTypeId();
        Id r5 = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('D&S PrePriced Restricted').getRecordTypeId();                
        Id r6 = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('D&S Complex Restricted FollowOn').getRecordTypeId();                
        Id r7 = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('D&S Standard').getRecordTypeId();  
        Id r8 = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('D&S Standard Restricted').getRecordTypeId();
        Id r9 = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('D&S Standard FollowOn').getRecordTypeId();
        Id r10 = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('D&S Standard Restricted FollowOn').getRecordTypeId();
        
        List<Opportunity> O = new List<Opportunity>();
        
        Opportunity ro11 = new Opportunity(Name='Complexopp',recordtypeid =rr1,Accountid=a1.Id,StageName='Prospecting',CloseDate=d1,Opportunity_Order_Numbers__c='14535;89678',ATR_Aircraft_Quantity__c=1,Is_Converted__c=true,RFP_Expected_Date__c =d1+23,RDE_Amount__c=232,Certification_Requirements__c='Certification_Requirements__c',Is_Restricted_Opportunity__c = true,Is_Follow_On_Opportunity__c = false);
        O.add(ro11);
        Opportunity o1r1 = new Opportunity(Name='Complexopp',recordtypeid =rr2,Accountid=a1.Id,StageName='Prospecting',CloseDate=d1,Opportunity_Order_Numbers__c='14535;89678',ATR_Aircraft_Quantity__c=1,Is_Converted__c=true,RFP_Expected_Date__c =d1+23,RDE_Amount__c=232,Certification_Requirements__c='Certification_Requirements__c',Is_Restricted_Opportunity__c = true,Is_Follow_On_Opportunity__c = false);
        O.add(o1r1);
        Opportunity o11r = new Opportunity(Name='Complexopp',recordtypeid =rr3,Accountid=a1.Id,StageName='Prospecting',CloseDate=d1,Opportunity_Order_Numbers__c='14535;89678',ATR_Aircraft_Quantity__c=1,Is_Converted__c=true,RFP_Expected_Date__c =d1+23,RDE_Amount__c=232,Certification_Requirements__c='Certification_Requirements__c',Is_Restricted_Opportunity__c = true,Is_Follow_On_Opportunity__c = false);
        O.add(o11r);
        Opportunity o11 = new Opportunity(Name='Complexopp',recordtypeid =r1,Accountid=a1.Id,StageName='Prospecting',CloseDate=d1,Opportunity_Order_Numbers__c='14535;89678',ATR_Aircraft_Quantity__c=1,Is_Converted__c=true,RFP_Expected_Date__c =d1+23,RDE_Amount__c=232,Certification_Requirements__c='Certification_Requirements__c',Is_Restricted_Opportunity__c = true,Is_Follow_On_Opportunity__c = false);
        O.add(o11);
        Opportunity o21 = new Opportunity(Name='Compleqwxopp',recordtypeid =r2,Accountid=a1.Id,StageName='Prospecting',CloseDate=d1+1,Opportunity_Order_Numbers__c='1453393678',ATR_Aircraft_Quantity__c=2,Is_Converted__c=true,RFP_Expected_Date__c =d1+23,RDE_Amount__c=232,Certification_Requirements__c='Certification_Requirements__c',Is_Restricted_Opportunity__c = true ,Is_Follow_On_Opportunity__c =false);
        O.add(o21);
        Opportunity o31 = new Opportunity(Name='Compleqwxopp',recordtypeid =r3,Accountid=a1.Id,StageName='Prospecting',CloseDate=d1+1,Opportunity_Order_Numbers__c='1453393678',ATR_Aircraft_Quantity__c=2,Is_Converted__c=true,RFP_Expected_Date__c =d1+23,RDE_Amount__c=232,Certification_Requirements__c='Certification_Requirements__c',Is_Restricted_Opportunity__c = true ,Is_Follow_On_Opportunity__c =false);
        O.add(o31);
        Opportunity o41 = new Opportunity(Name='Compleqwxopp',recordtypeid =r4,Accountid=a1.Id,StageName='Prospecting',CloseDate=d1+1,Opportunity_Order_Numbers__c='1453393678',ATR_Aircraft_Quantity__c=2,Is_Converted__c=true,RFP_Expected_Date__c =d1+23,RDE_Amount__c=232,Certification_Requirements__c='Certification_Requirements__c',Is_Restricted_Opportunity__c = true ,Is_Follow_On_Opportunity__c =false);
        O.add(o41);
        Opportunity o51 = new Opportunity(Name='Compleqwxopp',recordtypeid =r5,Accountid=a1.Id,StageName='Prospecting',CloseDate=d1+1,Opportunity_Order_Numbers__c='1453393678',ATR_Aircraft_Quantity__c=2,Is_Converted__c=true,RFP_Expected_Date__c =d1+23,RDE_Amount__c=232,Certification_Requirements__c='Certification_Requirements__c',Is_Restricted_Opportunity__c = true ,Is_Follow_On_Opportunity__c =false);
        O.add(o51);
        Opportunity o61 = new Opportunity(Name='Compleqwxopp',recordtypeid =r6,Accountid=a1.Id,StageName='Prospecting',CloseDate=d1+1,Opportunity_Order_Numbers__c='1453393678',ATR_Aircraft_Quantity__c=2,Is_Converted__c=true,RFP_Expected_Date__c =d1+23,RDE_Amount__c=232,Certification_Requirements__c='Certification_Requirements__c',Is_Restricted_Opportunity__c = true,Is_Follow_On_Opportunity__c =false);
        O.add(o61);
        Opportunity o71 = new Opportunity(Name='Compleqwxopp',recordtypeid =r7,Accountid=a1.Id,StageName='Prospecting',CloseDate=d1+1,Opportunity_Order_Numbers__c='1453393678',ATR_Aircraft_Quantity__c=2,Is_Converted__c=true,RFP_Expected_Date__c =d1+23,RDE_Amount__c=232,Certification_Requirements__c='Certification_Requirements__c',Is_Restricted_Opportunity__c = true ,Is_Follow_On_Opportunity__c =false);
        O.add(o71);
        Opportunity o81 = new Opportunity(Name='Compleqwxopp',recordtypeid =r8,Accountid=a1.Id,StageName='Prospecting',CloseDate=d1+1,Opportunity_Order_Numbers__c='1453393678',ATR_Aircraft_Quantity__c=2,Is_Converted__c=true,RFP_Expected_Date__c =d1+23,RDE_Amount__c=232,Certification_Requirements__c='Certification_Requirements__c',Is_Restricted_Opportunity__c = true ,Is_Follow_On_Opportunity__c =false);
        O.add(o81);
        Opportunity o91 = new Opportunity(Name='Compleqwxopp',recordtypeid =r9,Accountid=a1.Id,StageName='Prospecting',CloseDate=d1+1,Opportunity_Order_Numbers__c='1453393678',ATR_Aircraft_Quantity__c=2,Is_Converted__c=true,RFP_Expected_Date__c =d1+23,RDE_Amount__c=232,Certification_Requirements__c='Certification_Requirements__c',Is_Restricted_Opportunity__c = true ,Is_Follow_On_Opportunity__c =false);
        O.add(o91);
        Opportunity o101 = new Opportunity(Name='Compleqwxopp',recordtypeid =r10,Accountid=a1.Id,StageName='Prospecting',CloseDate=d1+1,Opportunity_Order_Numbers__c='1453393678',ATR_Aircraft_Quantity__c=2,Is_Converted__c=true,RFP_Expected_Date__c =d1+23,RDE_Amount__c=232,Certification_Requirements__c='Certification_Requirements__c',Is_Restricted_Opportunity__c = true ,Is_Follow_On_Opportunity__c =false);
        O.add(o101);
        
        
        insert O;       
        List<Opportunity_Gate__c> opGate = new List<Opportunity_Gate__c>();
        Opportunity_Gate__c og = new Opportunity_Gate__c(Serial_No__c=1, Name='Pre-Screen', Opportunity__c=o11.id, Opportunity_Type__c='D&S Complex', Status__c='Open',Completion_Date__c =d1+20, Actual_Date__c = d1+21);  
        opGate.add(og);     
        Opportunity_Gate__c og1 = new Opportunity_Gate__c(Serial_No__c=1, Name='Pre-Screen', Opportunity__c=o21.id, Opportunity_Type__c='D&S Complex', Status__c='Open',Completion_Date__c =d1+10, Actual_Date__c = d1+17);
        opGate.add(og1);
        
        List<Opportunity> updatelist = new List<Opportunity>();
        
        o11.recordtypeid = r2; 
        updatelist.add(o11);
        o21.recordtypeid = r3; 
        updatelist.add(o21);
        o31.recordtypeid = r4; 
        updatelist.add(o31);
        o41.recordtypeid = r5; 
        updatelist.add(o41);
        o51.recordtypeid = r6; 
        updatelist.add(o51);
        o61.recordtypeid = r7; 
        updatelist.add(o61);
        o71.recordtypeid = r8; 
        updatelist.add(o71);
        o81.recordtypeid = r9; 
        updatelist.add(o81);
        o91.recordtypeid = r10; 
        updatelist.add(o91);
        
        
        insert opGate;
        OppClassForPublicMethods oppclass = new OppClassForPublicMethods();
        try {
            Test.startTest();            
            update updatelist;            
            Test.stopTest();            
        } catch(System.DMLException e){
            System.assert(e.getMessage().contains('Please clean up Duplicate Order Number to Proceed'),e.getMessage());
        }
    }
    static testMethod void myUnitTest() {      
        
        Id r1 = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('BGA AM').getRecordTypeId();        
        Id r2 = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('D&S Complex FollowOn').getRecordTypeId();        
        id bgaAmOpportunity = r1;
        id bgaOEOpportunity = r1;
        
        Account a1 = New Account(Name= 'sbuaccount', Strategic_Business_Unit__c = 'D&S', CBT__c = 'HTSI');
        insert a1;
        
        contact ca =new contact();
        ca.LastName = 'testlastname';
        ca.FirstName = 'testfirstname12';
        insert ca;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'satem', Email='standarduser@testorg.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', UserName='standardsystemuser@testorg.com');
        insert u;
        
        system.debug('---------------------------------------------------------------');
        Product2 prod = new Product2(Name = 'RMU-855',Family = '1065APO_PPTR_STD',BGA_IsActive__c = true,RMU__c = true,BGA_Product_Name__c = 'RMU-855',CanUseRevenueSchedule = true,SBU__c = 'BGA');
        insert prod;
        Id pricebookId = Test.getStandardPricebookId();
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id,UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        
        Pricebook2 customPB = new Pricebook2(Name='BGA AM 2015', isActive=true);
        insert customPB;
        
        PricebookEntry customPrice = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = prod.Id,UnitPrice = 12000, IsActive = true);
        insert customPrice;
        system.debug('------------------------------------------------------');
        //OpportunityLineItem.
        
		/*Platform__c plate = new Platform__c(name = 'Dassault Aviation Falcon 8X',Platform_Type__c = 'Helicopter	', Managing_SBU__c = 'D&S',Model__c = 'aircraft2102', Make__c = 'D&S aircraft3044');
		insert plate;
		Fleet_Asset_Detail__c fad = new Fleet_Asset_Detail__c(name = 'Dassault Aviation Falcon 900 LX S=EX283', Platform_Name__c = plate.id  );
		insert fad; */
		
        Date d1 =Date.newInstance(2009,08,12);      
        List<Opportunity> updateopp = new List<Opportunity>();
        List<Opportunity> O = new List<Opportunity>();      
        Opportunity o1 = new Opportunity(Name='Complexopp1', recordtypeid =r1,Add_reference_material__c = true,Accountid=a1.Id,StageName='Prospecting',Advanced_Funding__c =false, CloseDate=d1,ATR_Aircraft_Quantity__c=1,Is_Converted__c=true,RFP_Expected_Date__c =d1+23,RDE_Amount__c=232,Certification_Requirements__c='FAR 15 Competitive',Is_Restricted_Opportunity__c = false,Is_Follow_On_Opportunity__c = true, Opportunity_Order_Numbers__c='APO194689;o9499;o9999',sbu__c ='D&S',CBT_Tier_2__c = 'DBL', Tech_Sales__c='Aerospace Services');
        O.add(o1);
        Opportunity o2 = new Opportunity(Name='Compleqwxopp2',recordtypeid =r2,Accountid=a1.Id,StageName='Prospecting',Advanced_Funding__c =false, CloseDate=d1,ATR_Aircraft_Quantity__c=2,Is_Converted__c=true,RFP_Expected_Date__c =d1+25,RDE_Amount__c=232,Certification_Requirements__c='FAR 15 TINA',Is_Restricted_Opportunity__c = false,Is_Follow_On_Opportunity__c = true, Opportunity_Order_Numbers__c='APO27811;27899',sbu__c ='ATR',CBT_Tier_2__c = 'Airbus',Type_of_Opportunity__c = 'Services', Tech_Sales__c='Aerospace Services');
        O.add(o2);
        
         Opportunity o3 = new Opportunity(Name='Compleqwxopp3',recordtypeid =r2,Accountid=a1.Id,StageName='Prospecting',Advanced_Funding__c =false, CloseDate=d1,ATR_Aircraft_Quantity__c=2,Is_Converted__c=true,RFP_Expected_Date__c =d1+25,RDE_Amount__c=232,Certification_Requirements__c='FAR 12 Commercial',Is_Restricted_Opportunity__c = false,Is_Follow_On_Opportunity__c = true, Opportunity_Order_Numbers__c='APO27811;27899',sbu__c ='BGA',CBT_Tier_2__c = 'BGA Aftermarket',Type_of_Opportunity__c = 'Services', Tech_Sales__c='Aerospace Services');
        O.add(o3);
        insert O;       
                
        // OpportunityId=o1.Id
        List<OpportunityLineItem> optlineitem = new List<OpportunityLineItem>();
        OpportunityLineItem OPplineitem2 = new OpportunityLineItem (Quantity=2,UnitPrice=41524,PriceBookEntryId=customPrice.Id,OpportunityId = o1.id);
        optlineitem.add(OPplineitem2);
        OpportunityLineItem OPplineitem1 = new OpportunityLineItem (Quantity=2,UnitPrice=41524,PriceBookEntryId=customPrice.Id,OpportunityId = o3.id);
        optlineitem.add(OPplineitem1);
        insert optlineitem;
        //OpportunityLineItem end. 
        
        system.debug('------v----->'+O);        
        DR_Approvers_List__c drap = new DR_Approvers_List__c(APPROVER__C =u.id, Pricing__c = u.id,Proposal_Manager__c =u.id,Growth_Leader__c = u.id,PMOS_Leader__c = ca.id,Finance__c = u.id,ISC__c = ca.id,C_PS__c = ca.id,Engineering__c = ca.id,M_PM__c = ca.id,Contracts__c = ca.id,SBU__c = 'ATR',CBT__c = 'Airbus');
        insert drap;
        List<Opportunity_Order__c> ood = new List<Opportunity_Order__c>();
        Opportunity_Order__c order = new Opportunity_Order__c(Opportunity__c=o1.id, Order_number__c='APO194689');
        ood.add(order);
        Opportunity_Order__c order2 = new Opportunity_Order__c(Opportunity__c=o1.id, Order_number__c='APOo9499');
        ood.add(order2);
        Opportunity_Order__c order3 = new Opportunity_Order__c(Opportunity__c=o2.id, Order_number__c='APO194682');
        ood.add(order3);
        insert ood;
        
        List<Opportunity_Gate__c> opGate = new List<Opportunity_Gate__c>();
        Opportunity_Gate__c og = new Opportunity_Gate__c(Serial_No__c=1, Name='Pre-Screen', Opportunity__c=o1.id, Opportunity_Type__c='D&S Complex', Status__c='Open',Completion_Date__c =d1+20, Actual_Date__c = d1+21);   
        opGate.add(og);
        
        Opportunity_Gate__c og1 = new Opportunity_Gate__c(Serial_No__c=1, Name='Pre-Screen', Opportunity__c=o1.id, Opportunity_Type__c='D&S Complex', Status__c='Open',Completion_Date__c =d1+10, Actual_Date__c = d1+17);
        opGate.add(og1);        
        insert opGate;
        
        o1.recordtypeid =r2;
        updateopp.add(o1);
        o2.sbu__c ='D&S';
        o2.CBT_Tier_2__c = 'DAP';
        o2.recordtypeid =r1;
        updateopp.add(o2);
        o3.recordtypeid = r1;
        updateopp.add(o3);      
         Test.startTest();              
        try {           
            update updateopp;           
        } catch(System.DMLException e){
            System.assert(e.getMessage().contains('Please clean up Duplicate Order Number to Proceed'),e.getMessage());
        }
        
       List<Related_Customer_Stories__c>  Listrcs = new List<Related_Customer_Stories__c>();
        Related_Customer_Stories__c rcs = new Related_Customer_Stories__c(Name ='SVS provides IBM pilots with enhanced situation awareness for improved safety',Product__c = prod.id,Opportunity__c = o1.id);
        Listrcs.add(rcs);
        Related_Customer_Stories__c rcs2 = new Related_Customer_Stories__c(Name ='SVS provides IBM pilots with enhanced situation awareness for improved safety',Product__c = prod.id,Opportunity__c = o2.id);
        Listrcs.add(rcs2);
        Related_Customer_Stories__c rcs3 = new Related_Customer_Stories__c(Name ='SVS provides IBM pilots with enhanced situation awareness for improved safety',Product__c = prod.id,Opportunity__c = o3.id);
        Listrcs.add(rcs3);
        //insert Listrcs; 
        test.stopTest();
     }        
 }