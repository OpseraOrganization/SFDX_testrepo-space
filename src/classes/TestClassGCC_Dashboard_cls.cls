@isTest(seealldata = true)
public class TestClassGCC_Dashboard_cls{ 
   static testmethod void  GCC_Dashboard_cls(){



       GCC_Dashboard_cls test = new GCC_Dashboard_cls();
        System.currentPagereference().getParameters().put('Closed', 'True');
        test.getSRs();
        test.getcountclosed();
        test.GetToggleUrl();
        test.GetToggleButton();
         test.currentId='True';
         test.getSRs();
        test.GetToggleUrl();
        test.GetToggleButton();
    }
    public static void generateStringArray(Integer i) {
        List<Service_Request__c> sr1 = new List<Service_Request__c>();

        Service_Request__c ser1 = new Service_Request__c(Subject__c = 'test',SR_Type__c = 'GDC',Priority__c = 'High',Status__c = 'Monitor',Problem_Description__c = 'test',Deliverable__c = 'test',Atr__c = 'value',OEMs_Affected__c = 'test',GCC__c = true,One__c ='Closed',GCC_Date_Closed__c= system.now());
        insert ser1;       
        sr1.add(ser1);
        
        Service_Request__c ser2 = new Service_Request__c(Subject__c = 'test',SR_Type__c = 'GDC',Priority__c = 'High',Status__c = 'Monitor',Problem_Description__c = 'test',Deliverable__c = 'test',Atr__c = 'value',OEMs_Affected__c = 'test12',GCC__c = true,One__c ='Top 25');
        insert ser2; 
        sr1.add(ser2); 
        
        Service_Request__c ser3 = new Service_Request__c(Subject__c = 'test',SR_Type__c = 'GDC',Priority__c = 'High',Status__c = 'Monitor',Problem_Description__c = 'test',Deliverable__c = 'test',Atr__c = 'value',OEMs_Affected__c = 'test',GCC__c = true,One__c ='Closed',GCC_Date_Closed__c= system.now());
        insert ser3; 
        sr1.add(ser3);
         
        Service_Request__c ser4 = new Service_Request__c(Subject__c = 'test',SR_Type__c = 'GDC',Priority__c = 'High',Status__c = 'Monitor',Problem_Description__c = 'test',Deliverable__c = 'test',Atr__c = 'value',OEMs_Affected__c = 'test',GCC__c = true,One__c ='Closed',GCC_Date_Closed__c= system.now());
        insert ser4;
        sr1.add(ser4);  
        
        //insert sr1;
        
        }
}