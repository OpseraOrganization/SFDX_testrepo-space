@isTest
public class TestClass_GoGreen{ 
    static testmethod void GoGreentest(){
        List<Contact> conlist = new  List<Contact>();
        Account acc= new Account(name='Test Account');
        insert acc;
        Contact c1=new Contact(lastname='TestGoGreen',email='test@g.com',AccountId = acc.id);
        //insert c1;
        conlist.add(c1);
        Contact c2=new Contact(lastname='TestGoGreen1',email='tes1t@g.com',AccountId = acc.id);
        //insert c2;
         conlist.add(c2);
        insert conlist;
        
        List<Feedback__c> fblist = new List<Feedback__c>();
        Feedback__c FB= new Feedback__c(Comments__c='test',account__c=acc.Id,Prod_LN_Prgm_Product_LIne__c='APU');
        try{
            insert FB;
        }catch(DMLException e1){}
        Feedback__c FB1= new Feedback__c(Comments__c='test1',account__c=acc.Id,Prod_LN_Prgm_Product_LIne__c='AGENCY');
        try{
            insert FB1;
        }catch(DMLException e2){}
        Feedback__c FB2= new Feedback__c(Comments__c='test2',account__c=acc.Id,Prod_LN_Prgm_Product_LIne__c='AFSB',Competitor_Products__c='test');
        try{
            insert FB2;
        }catch(DMLException e3){}
        Feedback__c FB3 = new Feedback__c(Comments__c='testing3',account__c=acc.Id,Prod_LN_Prgm_Product_LIne__c='APU',Type__c='Energy',Comments_Topic__c='Website',Year__c='2014');
        try{
            insert FB3;
        }catch(DMLException e4){}
        
        
        Go_Green_Plan__c GP= new Go_Green_Plan__c(Go_Green_Status__c='TestP',account__c=acc.Id,Prod_LN_Prgm_Product_LIne__c='APU');
        insert GP;
        Go_Green_Plan__c GP1= new Go_Green_Plan__c(Go_Green_Status__c='TestP1',account__c=acc.Id);
        insert GP1;
        Associated_VOC_Card_Number__c AVC= new Associated_VOC_Card_Number__c(Go_Green_Plan__c=gp.Id,Feedback_Number__c=fb.Id);
        insert AVC;
        
        test.starttest();    
        Associated_VOC_Card_Number__c AVC3= new Associated_VOC_Card_Number__c(Go_Green_Plan__c=gp1.Id,Feedback_Number__c=fb2.Id);
        try{        
            insert AVC3;      
        }catch(Exception e){      
            //System.Assert(e.getMessage().contains('The Feedback account and Product Line should be same as Go Green Plan!'));
        }
        try{   
            Associated_VOC_Card_Number__c AVC2= new Associated_VOC_Card_Number__c(Go_Green_Plan__c=gp.Id,Feedback_Number__c=fb3.Id);
            insert AVC2;           
        }
        catch(Exception e){      
            //System.Assert(e.getMessage().contains('Go Green Plan already exists for the Feedback'));
        }
        //inserting Team members
        Team_Members__c TM= new  Team_Members__c (Team_Members__c=c1.Id,Go_Green_Plan__c=gp.Id);
        insert TM;
        Team_Members__c TM2= new  Team_Members__c (Team_Members__c=c2.Id,Go_Green_Plan__c=gp.Id);
        insert TM2;  
        try{   
            Team_Members__c TM1= new  Team_Members__c (Team_Members__c=c1.Id,Go_Green_Plan__c=gp.Id);
            insert TM1;           
        }
        catch(Exception e){      
            //System.Assert(e.getMessage().contains('Go Green Plan already exists for the team member selected!'));
        }   
        try{   
            TM.Team_Members__c=c2.Id;
            update TM;           
        }
        catch(Exception e){      
            //System.Assert(e.getMessage().contains('Go Green Plan already exists for the team member selected!'));
        } 

        // for deliverable item triggers
		List<Service_Request__c> srlist = new List<Service_Request__c>();
        List<Deliverable_Item__c> drlist = new List<Deliverable_Item__c>();
        
        Service_Request__c SR=new  Service_Request__c (Status__c='New',Contact_Name__c = c1.id);  
        //insert SR;
        srlist.add(sr);
        Service_Request__c SR1=new  Service_Request__c (Status__c='New1', Contact_Name__c = c2.id);  
        //insert SR1;
        srlist.add(sr1);
        insert srlist;
        Deliverable_Item__c DI= new Deliverable_Item__c(SR_Number__c=SR.Id,Go_Green_Plan__c=gp.Id);
        //insert DI;
        drlist.add(DI);
        Deliverable_Item__c DI2= new Deliverable_Item__c(SR_Number__c=SR1.Id,Go_Green_Plan__c=gp.Id);
        //insert DI2;
        drlist.add(DI2);
        insert drlist;
        try{ 
            Deliverable_Item__c DI1= new Deliverable_Item__c(SR_Number__c=SR.Id,Go_Green_Plan__c=gp.Id);
            insert DI1;  
        }
        catch(Exception e){      
            //System.Assert(e.getMessage().contains('Go Green Plan already exists for the Service Request !'));
        } 

        try{ 
            DI.SR_Number__c=SR1.Id;
            update DI;  
        }
        catch(Exception e){      
            //System.Assert(e.getMessage().contains('Go Green Plan already exists for the Service Request !'));
        } 
        test.stoptest();
    }
}