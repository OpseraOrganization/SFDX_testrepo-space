@isTest
private class TestCreateTaskForFAAMSPEngine{
    static testMethod void testMethodRun(){
           Case cas = new Case();
            cas.Origin = 'web';
            cas.Status = 'Open';  
            cas.OwnerId = Label.Task_Owner;
            //cas.ContactId = objContact.Id;
            cas.RecordtypeId = label.Repair_Overhaul_RT_ID;
            cas.Classification__c = 'CSO Repair Order';
            //cas.Sub_Class__c = 'Quotes COE - Customer Response';
        
            cas.Export_Compliance_Content_ITAR_EAR__c = 'No';
            cas.Government_Compliance_SM_M_Content__c = 'No';
            cas.Sales_Order_Number__c = '12345678';
            //cas.Order_Entered_By__c = 'Harikishore';
            cas.CaseOwnerChanged__c = 'sofiya.peermohamed@nttdata.com';
            cas.Description = 'Test cases';
            cas.subject='test case';
            insert cas;
            
            Platform__c p = new Platform__c();
            p.Platform__c ='Test platform please ignore';
            p.APU_Maker__c = 'Honeywell';
            p.APU_Engine_OEM_Warranty_Period__c = '12';
            insert p;
            
            Fleet_Asset_Detail__c fad = new Fleet_Asset_Detail__c();
            fad.Case_Associated__c = cas.Id;
            fad.New_Alert_Identification__c = true;
            fad.Platform_Name__c =p.id;
            fad.Serial_Number__c = 'test 123';
            fad.Aircraft_Delivery_Date__c = system.today().addDays(180).addMonths(-12);
            insert fad;
            fad = [select Platform_Name__r.APU_Maker__c
,APU_Engine_OEM_Warranty_Period__c,Aircraft_Delivery_Date__c,Platform_Name__r.APU_Engine_OEM_Warranty_Period__c from Fleet_Asset_Detail__c where id=:fad.id];
                system.debug('Fleet_Asset_Detail__c  value:'+fad.APU_Engine_OEM_Warranty_Period__c+' Aircraft_Delivery_Date__c value:'+fad.Aircraft_Delivery_Date__c+' Platform_Name__r.APU_Engine_OEM_Warranty_Period__c value:'+fad.Platform_Name__r.APU_Engine_OEM_Warranty_Period__c+' Platform_Name__r.APU_Maker__c value:'+fad.Platform_Name__r.APU_Maker__c);
            Database.executeBatch(new CreateTaskForFAAMSPEngine()); 
            
       CreateTaskForFAAMSPEngineScheduler pt = new CreateTaskForFAAMSPEngineScheduler(); //Schedule apex class name
       String sch = '0 0 * * * ?'; //schedule interval time
       system.schedule('One Time Pro', sch, pt); //system method to schedule apex class*/
  
            
    }
    static testMethod void testEngineMakerRun(){
           Case cas = new Case();
            cas.Origin = 'web';
            cas.Status = 'Open';  
            cas.OwnerId = Label.Task_Owner;
            //cas.ContactId = objContact.Id;
            cas.RecordtypeId = label.Repair_Overhaul_RT_ID;
            cas.Classification__c = 'CSO Repair Order';
            //cas.Sub_Class__c = 'Quotes COE - Customer Response';
        
            cas.Export_Compliance_Content_ITAR_EAR__c = 'No';
            cas.Government_Compliance_SM_M_Content__c = 'No';
            cas.Sales_Order_Number__c = '12345678';
            //cas.Order_Entered_By__c = 'Harikishore';
            cas.CaseOwnerChanged__c = 'sofiya.peermohamed@nttdata.com';
            cas.Description = 'Test cases';
            cas.subject='test case';
            insert cas;
            
            Platform__c p = new Platform__c();
            p.Platform__c ='Test platform please ignore';
            p.Engine_Maker__c = 'Honeywell';
            p.APU_Engine_OEM_Warranty_Period__c = '12';
            insert p;
            
            Fleet_Asset_Detail__c fad = new Fleet_Asset_Detail__c();
            fad.Case_Associated__c = cas.Id;
            fad.New_Alert_Identification__c = true;
            fad.Platform_Name__c =p.id;
            fad.Serial_Number__c = 'test 123';
            fad.Aircraft_Delivery_Date__c = system.today().addDays(180).addMonths(-12);
            insert fad;
            fad = [select Platform_Name__r.APU_Maker__c
,APU_Engine_OEM_Warranty_Period__c,Aircraft_Delivery_Date__c,Platform_Name__r.APU_Engine_OEM_Warranty_Period__c from Fleet_Asset_Detail__c where id=:fad.id];
                system.debug('Fleet_Asset_Detail__c  value:'+fad.APU_Engine_OEM_Warranty_Period__c+' Aircraft_Delivery_Date__c value:'+fad.Aircraft_Delivery_Date__c+' Platform_Name__r.APU_Engine_OEM_Warranty_Period__c value:'+fad.Platform_Name__r.APU_Engine_OEM_Warranty_Period__c+' Platform_Name__r.APU_Maker__c value:'+fad.Platform_Name__r.APU_Maker__c);
            Database.executeBatch(new CreateTaskForFAAMSPEngine()); 
            
       CreateTaskForFAAMSPEngineScheduler pt = new CreateTaskForFAAMSPEngineScheduler(); //Schedule apex class name
       String sch = '0 0 * * * ?'; //schedule interval time
       system.schedule('One Time Pro', sch, pt); //system method to schedule apex class*/
  
            
    }
   }