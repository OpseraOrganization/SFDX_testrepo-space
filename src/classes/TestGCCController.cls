@isTest (seeAlldata=true)
public class TestGCCController {
 public static list < Service_Request__c > globaldataexporttovf{get;set;}
 public static list < Service_Request__c > globaldataexporttovf1{get;set;}
 
    static testMethod void exportmethodcontroller1() {
    //list<Service_Request__c > srlist=[select id,Name from Service_Request__c limit 10];
    Service_Request__c obj1=new Service_Request__c ();
        obj1.Subject__c ='test';
        obj1.SR_Type__c='Complex Problem';
        obj1.Priority__c='AOG';
        obj1.Status__c='Closed';
        obj1.SR_SBU__c='Aero Level';
        //obj1.Currency='EUR-Euro';
        obj1.Problem_Description_new__c='test';
        obj1.Deliverable__c='test';
        obj1.Customer_Due_Date__c=System.now();
        //obj1.HON_Commit_Date__c=System.now();
        obj1.Atr__c='Delivery';
        obj1.Complexity_Level__c='Low- One Off Request';
         obj1.Moved_to_Top_25__c=System.now();
      obj1.GCC_Date_Closed__c=System.now();
      obj1.Moved_to_Agenda_Followup__c=system.today();
        obj1.Date_Initiated__c=System.now();
         obj1.One__c='TOP 25';
         obj1.RAIL_Type__c='Electrical';
             obj1.RAIL_Description__c='test';
            obj1.RAIL_Number__c=1111111;
         obj1.Source__c='GCC';
                 obj1.Original_Commit_Date__c=System.now();
                  
                   obj1.Affected_OEMs__c='';
                   obj1.Status_dates__c='';
                   obj1.Region_of_Origin__c='';
                   obj1.Region__c='';
        insert obj1;
    list<Service_Request__c > srlist=new   list<Service_Request__c >();
    srlist.add(obj1);
     list<Service_Request__c> srlist2=GCCController.exportmethodcontroller1(srlist);
    
     
 
    /*
    if(globaldataexporttovf.size() > 0)
    {
    
    servicerequest1__c obj=new servicerequest1__c();
    
     obj.Moved_to_Top_25__c=System.now();
      obj.GCC_Date_Closed__c=System.now();
      obj.Moved_to_Agenda_Followup__c=system.today();
     // obj.Name='1111';
      obj.Date_Initiated__c=System.now();
      //obj.Region__c='Americas'; 
     // obj.Supported_Products__r.Name='test';
       obj.Status_dates__c='test';
        obj.Actual_Completion__c='';
        // obj.Contact_Name__r.Name='Farukh Haider';
          //obj.Created_Date__c='';
           obj.One_list_type__c='TOP 25';
            obj.Type__c='Electrical';
             obj.RAIL_Description__c='test';
              obj.RAIL_Item_Number__c=1111111;
             //  obj.RAIL_Owner__r.Name='Farukh haider';
               // obj.LastModifiedBy.Name='';
               // obj.LastModifiedDate='';
                obj.Problem_Description__c='test';
              
                 obj.Source__c='GCC';
                 obj.Original_Commit_Date__c=System.now();
                  
                   obj.Affected_OEMs__c='';
                   obj.Status_dates__c='';
                   obj.Region_of_Origin__c='';
                    obj.Impacted_Regions__c='';
                   // obj.Estimated_Completion_Date__c=System.now();
                    objList.add(obj);
            }        
        insert objList;
        */
        
     
    
    }
    static testMethod void exportmethodcontroller() {
    //list<Service_Request__c > srlist3=[select id,Name from Service_Request__c limit 10];
   // Service_Request__c obj1=new Service_Request__c ();
    Service_Request__c obj1=new Service_Request__c ();
        obj1.Subject__c ='test';
        obj1.SR_Type__c='Complex Problem';
        obj1.Priority__c='AOG';
        obj1.Status__c='Closed';
        obj1.SR_SBU__c='Aero Level';
        //obj1.Currency='EUR-Euro';
        obj1.Problem_Description_new__c='test';
        obj1.Deliverable__c='test';
        obj1.Customer_Due_Date__c=System.now();
        //obj1.HON_Commit_Date__c=System.now();
        obj1.Atr__c='Delivery';
        obj1.Complexity_Level__c='Low- One Off Request';
         obj1.Moved_to_Top_25__c=System.now();
      obj1.GCC_Date_Closed__c=System.now();
      obj1.Moved_to_Agenda_Followup__c=system.today();
        obj1.Date_Initiated__c=System.now();
       obj1.One__c='TOP 25';
         obj1.RAIL_Type__c='Electrical';
             obj1.RAIL_Description__c='test';
            obj1.RAIL_Number__c=1111111;
         obj1.Source__c='GCC';
                 obj1.Original_Commit_Date__c=System.now();
                  
                   obj1.Affected_OEMs__c='';
                   obj1.Status_dates__c='';
                   obj1.Region_of_Origin__c='';
                   obj1.Region__c='';
        
    list<Service_Request__c > srlist=new   list<Service_Request__c >();
    srlist.add(obj1);
  
     
        
      
    list<Service_Request__c> srlist4=GCCController.exportmethodcontroller(srlist);
   
  

   
  
    }
    
    static testMethod void DetailSearch() {
     String testdata;
     Set<Id> detailid=new Set<Id>();
     list<Service_Request__c> detaildata=[select Moved_to_Top_25__c,GCC_Date_Closed__c,Moved_to_Agenda_Followup__c,Name,Date_Initiated__c,Region__c, 
                                  Supported_Products__r.Name, Status_Update_Date__c, Actual_Completion__c, Contact_Name__r.Name, Created_Date__c, One__c,
                                  RAIL_Type__c, RAIL_Description__c, RAIL_Number__c, New_RAIL_Owner__r.Name, LastModifiedBy.Name,LastModifiedDate, Problem_Description_new__c, 
                                  Deliverable__c, Source__c, Original_Commit_Date__c, OEMs_Affected__c, Affected_OEMs__c, Status_Dates__c, Region_of_Origin__c, 
                                  Estimated_Completion_Date__c from Service_Request__c limit 1 ];
     for(integer i=0; i < detaildata.size();i++)
     {
     testdata=detaildata[i].id;
     }
    Service_Request__c obj=GCCController.DetailSearch(testdata);
   
    }
    
     static testMethod void Generatereporttest1() {
     GCCController Gobj=new GCCController();
    
    Gobj.GenerateReport1();
     Gobj.GenerateReport();
     
    }
    
      static testMethod void Generatereporttest() {
     GCCController Gobj=new GCCController();
    
  //  Gobj.GenerateReport1();
     Gobj.GenerateReport();
     
    }
    
     static testMethod void ServiceSearchtest() {
     string testdata='test';
    GCCController.ServiceSearch(testdata);
     
    }
    
      static testMethod void ServiceSearchtest1() {
          
           
          
          
     string testdata1='test';
     string testdata2='test';
     string testdata3='test';
     string testdata4='test';
     string testdata5='test';
     string testdata6='test';
     string testdata7='test';
     string testdata8='test';
     string testdata9='test';
     string testdata10='test';
     string testdata11='test';
     string testdata12='test';
     string testdata13='test';
     string testdata14='test';
     string testdata15='test';
     string testdata16='test';
     string testdata17='test';
     string testdata18='test';
     string testdata19='test';
     string testdata20='test';
      string testdata21='test';
     string testdata22='test';
     string testdata23='test';
     string testdata24='test';
     string testdata25='test';
     string testdata26='test';
     string testdata27='test';
     string testdata28='test';
     string testdata29='test';
     string testdata30='test';
     string testdata31='test';
     string testdata32='test';
     /*
      Service_Request__c obj=new Service_Request__c();
      obj.Moved_to_Top_25__c=System.now();
      obj.GCC_Date_Closed__c=System.now();
      obj.Moved_to_Agenda_Followup__c=system.today();
      //obj.Name='1111';
      obj.Date_Initiated__c=System.now();
      //obj.Region__c='Americas'; 
      obj.Supported_Products__r.Name='test';
     // obj.Contact_Name__r.Name='test';
       obj.Status_dates__c='test';
        obj.Actual_Completion__c='';
        // obj.Contact_Name__r.Name='Farukh Haider';
          //obj.Created_Date__c='';
           obj.One__c='TOP 25';
            obj.RAIL_Type__c='Electrical';
             obj.RAIL_Description__c='test';
              obj.RAIL_Number__c=1111111;
             // obj.RAIL_Owner__r.Name='Farukh haider';
               // obj.LastModifiedBy.Name='';
               // obj.LastModifiedDate='';
                obj.Problem_Description__c='test';
              
                 obj.Source__c='GCC';
                 obj.Original_Commit_Date__c=System.now();
                  
                   obj.Affected_OEMs__c='';
                   obj.Status_dates__c='';
                   obj.Region_of_Origin__c='';
                    obj.Region__c='';
                    insert obj;
                   // obj.Estimated_Completion_Date__c=System.now();
     */
    GCCController.ServiceSearch1(testdata1,testdata2,testdata3,testdata4,testdata5,testdata6,testdata7,testdata8,testdata9,testdata10,testdata11,testdata12,testdata13,testdata14,testdata15,testdata16,testdata17,testdata18,testdata19,testdata20,testdata21,testdata22,testdata23,testdata24,testdata25,testdata26,testdata27,testdata28,testdata29,testdata30,testdata31,testdata32);
          
         
     list<Service_Request__c> searchedfilterdata; 
    string finalquery='select GCC_Date_Closed__c,Moved_to_Agenda_Followup__c,Moved_to_Top_25__c,Name,Date_Initiated__c,Region__c,Supported_Products__r.Name, Status_Update_Date__c, Actual_Completion__c, Contact_Name__r.Name, Created_Date__c, One__c, RAIL_Type__c,RAIL_Description__c, RAIL_Number__c, New_RAIL_Owner__r.Name, LastModifiedBy.Name, Problem_Description_new__c, Deliverable__c, Source__c, Original_Commit_Date__c, OEMs_Affected__c, Affected_OEMs__c, Status_Dates__c, Region_of_Origin__c, Estimated_Completion_Date__c from Service_Request__c where GCC__c=true ORDER BY Date_Initiated__c DESC ';
    searchedfilterdata = database.query(finalquery);
     
     
    }
    
    
   
     static testMethod void ServiceSearchtest2() {
     string testdata1='';
     string testdata2='test';
     string testdata3='';
     string testdata4='';
     string testdata5='';
     string testdata6='';
     string testdata7='';
     string testdata8='';
     string testdata9='';
     string testdata10='';
     string testdata11='';
     string testdata12='';
     string testdata13='';
     string testdata14='';
     string testdata15='';
     string testdata16='';
     string testdata17='';
     string testdata18='';
     string testdata19='';
     string testdata20='';
      string testdata21='';
     string testdata22='';
     string testdata23='';
     string testdata24='';
     string testdata25='';
     string testdata26='';
     string testdata27='';
     string testdata28='';
     string testdata29='';
     string testdata30='';
     string testdata31='';
     string testdata32='';
     
   
    GCCController.ServiceSearch1(testdata1,testdata2,testdata3,testdata4,testdata5,testdata6,testdata7,testdata8,testdata9,testdata10,testdata11,testdata12,testdata13,testdata14,testdata15,testdata16,testdata17,testdata18,testdata19,testdata20,testdata21,testdata22,testdata23,testdata24,testdata25,testdata26,testdata27,testdata28,testdata29,testdata30,testdata31,testdata32);
    
     
     
    }
    
    
  static testMethod void ServiceSearchtest3() {
     string testdata1='';
     string testdata2='';
     string testdata3='test';
     string testdata4='';
     string testdata5='';
     string testdata6='';
     string testdata7='';
     string testdata8='';
     string testdata9='';
     string testdata10='';
     string testdata11='';
     string testdata12='';
     string testdata13='';
     string testdata14='';
     string testdata15='';
     string testdata16='';
     string testdata17='';
     string testdata18='';
     string testdata19='';
     string testdata20='';
      string testdata21='';
     string testdata22='';
     string testdata23='';
     string testdata24='';
     string testdata25='';
     string testdata26='';
     string testdata27='';
     string testdata28='';
     string testdata29='';
     string testdata30='';
     string testdata31='';
     string testdata32='';
     
   
    GCCController.ServiceSearch1(testdata1,testdata2,testdata3,testdata4,testdata5,testdata6,testdata7,testdata8,testdata9,testdata10,testdata11,testdata12,testdata13,testdata14,testdata15,testdata16,testdata17,testdata18,testdata19,testdata20,testdata21,testdata22,testdata23,testdata24,testdata25,testdata26,testdata27,testdata28,testdata29,testdata30,testdata31,testdata32);
    
     
     
    }  
    
    static testMethod void ServiceSearchtest4() {
     string testdata1='';
     string testdata2='';
     string testdata3='';
     string testdata4='test';
     string testdata5='';
     string testdata6='';
     string testdata7='';
     string testdata8='';
     string testdata9='';
     string testdata10='';
     string testdata11='';
     string testdata12='';
     string testdata13='';
     string testdata14='';
     string testdata15='';
     string testdata16='';
     string testdata17='';
     string testdata18='';
     string testdata19='';
     string testdata20='';
      string testdata21='';
     string testdata22='';
     string testdata23='';
     string testdata24='';
     string testdata25='';
     string testdata26='';
     string testdata27='';
     string testdata28='';
     string testdata29='';
     string testdata30='';
     string testdata31='';
     string testdata32='';
     
   
    GCCController.ServiceSearch1(testdata1,testdata2,testdata3,testdata4,testdata5,testdata6,testdata7,testdata8,testdata9,testdata10,testdata11,testdata12,testdata13,testdata14,testdata15,testdata16,testdata17,testdata18,testdata19,testdata20,testdata21,testdata22,testdata23,testdata24,testdata25,testdata26,testdata27,testdata28,testdata29,testdata30,testdata31,testdata32);
    
     
     
    }  
    
     static testMethod void ServiceSearchtest5() {
     string testdata1='';
     string testdata2='';
     string testdata3='';
     string testdata4='';
     string testdata5='test';
     string testdata6='';
     string testdata7='';
     string testdata8='';
     string testdata9='';
     string testdata10='';
     string testdata11='';
     string testdata12='';
     string testdata13='';
     string testdata14='';
     string testdata15='';
     string testdata16='';
     string testdata17='';
     string testdata18='';
     string testdata19='';
     string testdata20='';
      string testdata21='';
     string testdata22='';
     string testdata23='';
     string testdata24='';
     string testdata25='';
     string testdata26='';
     string testdata27='';
     string testdata28='';
     string testdata29='';
     string testdata30='';
     string testdata31='';
     string testdata32='';
     
   
    GCCController.ServiceSearch1(testdata1,testdata2,testdata3,testdata4,testdata5,testdata6,testdata7,testdata8,testdata9,testdata10,testdata11,testdata12,testdata13,testdata14,testdata15,testdata16,testdata17,testdata18,testdata19,testdata20,testdata21,testdata22,testdata23,testdata24,testdata25,testdata26,testdata27,testdata28,testdata29,testdata30,testdata31,testdata32);
    
     
     
    }  
     static testMethod void ServiceSearchtest6() {
     string testdata1='';
     string testdata2='';
     string testdata3='';
     string testdata4='';
     string testdata5='';
     string testdata6='test';
     string testdata7='';
     string testdata8='';
     string testdata9='';
     string testdata10='';
     string testdata11='';
     string testdata12='';
     string testdata13='';
     string testdata14='';
     string testdata15='';
     string testdata16='';
     string testdata17='';
     string testdata18='';
     string testdata19='';
     string testdata20='';
      string testdata21='';
     string testdata22='';
     string testdata23='';
     string testdata24='';
     string testdata25='';
     string testdata26='';
     string testdata27='';
     string testdata28='';
     string testdata29='';
     string testdata30='';
     string testdata31='';
     string testdata32='';
     
   
    GCCController.ServiceSearch1(testdata1,testdata2,testdata3,testdata4,testdata5,testdata6,testdata7,testdata8,testdata9,testdata10,testdata11,testdata12,testdata13,testdata14,testdata15,testdata16,testdata17,testdata18,testdata19,testdata20,testdata21,testdata22,testdata23,testdata24,testdata25,testdata26,testdata27,testdata28,testdata29,testdata30,testdata31,testdata32);
    
     
     
    }  
     static testMethod void ServiceSearchtest7() {
     string testdata1='';
     string testdata2='';
     string testdata3='';
     string testdata4='';
     string testdata5='';
     string testdata6='';
     string testdata7='test';
     string testdata8='';
     string testdata9='';
     string testdata10='';
     string testdata11='';
     string testdata12='';
     string testdata13='';
     string testdata14='';
     string testdata15='';
     string testdata16='';
     string testdata17='';
     string testdata18='';
     string testdata19='';
     string testdata20='';
      string testdata21='';
     string testdata22='';
     string testdata23='';
     string testdata24='';
     string testdata25='';
     string testdata26='';
     string testdata27='';
     string testdata28='';
     string testdata29='';
     string testdata30='';
     string testdata31='';
     string testdata32='';
     
   
    GCCController.ServiceSearch1(testdata1,testdata2,testdata3,testdata4,testdata5,testdata6,testdata7,testdata8,testdata9,testdata10,testdata11,testdata12,testdata13,testdata14,testdata15,testdata16,testdata17,testdata18,testdata19,testdata20,testdata21,testdata22,testdata23,testdata24,testdata25,testdata26,testdata27,testdata28,testdata29,testdata30,testdata31,testdata32);
    
     
     
    }  
    
    static testMethod void ServiceSearchtest8() {
     string testdata1='';
     string testdata2='';
     string testdata3='';
     string testdata4='';
     string testdata5='';
     string testdata6='';
     string testdata7='';
     string testdata8='test';
     string testdata9='';
     string testdata10='';
     string testdata11='';
     string testdata12='';
     string testdata13='';
     string testdata14='';
     string testdata15='';
     string testdata16='';
     string testdata17='';
     string testdata18='';
     string testdata19='';
     string testdata20='';
      string testdata21='';
     string testdata22='';
     string testdata23='';
     string testdata24='';
     string testdata25='';
     string testdata26='';
     string testdata27='';
     string testdata28='';
     string testdata29='';
     string testdata30='';
     string testdata31='';
     string testdata32='';
     
   
    GCCController.ServiceSearch1(testdata1,testdata2,testdata3,testdata4,testdata5,testdata6,testdata7,testdata8,testdata9,testdata10,testdata11,testdata12,testdata13,testdata14,testdata15,testdata16,testdata17,testdata18,testdata19,testdata20,testdata21,testdata22,testdata23,testdata24,testdata25,testdata26,testdata27,testdata28,testdata29,testdata30,testdata31,testdata32);
    
     
     
    }  
    static testMethod void ServiceSearchtest10() {
     string testdata1='';
     string testdata2='';
     string testdata3='';
     string testdata4='';
     string testdata5='';
     string testdata6='';
     string testdata7='';
     string testdata8='';
     string testdata9='';
     string testdata10='test';
     string testdata11='';
     string testdata12='';
     string testdata13='';
     string testdata14='';
     string testdata15='';
     string testdata16='';
     string testdata17='';
     string testdata18='';
     string testdata19='';
     string testdata20='';
      string testdata21='';
     string testdata22='';
     string testdata23='';
     string testdata24='';
     string testdata25='';
     string testdata26='';
     string testdata27='';
     string testdata28='';
     string testdata29='';
     string testdata30='';
     string testdata31='';
     string testdata32='';
     
   
    GCCController.ServiceSearch1(testdata1,testdata2,testdata3,testdata4,testdata5,testdata6,testdata7,testdata8,testdata9,testdata10,testdata11,testdata12,testdata13,testdata14,testdata15,testdata16,testdata17,testdata18,testdata19,testdata20,testdata21,testdata22,testdata23,testdata24,testdata25,testdata26,testdata27,testdata28,testdata29,testdata30,testdata31,testdata32);
    
     
     
    }  
     static testMethod void ServiceSearchtest12() {
     string testdata1='';
     string testdata2='';
     string testdata3='';
     string testdata4='';
     string testdata5='';
     string testdata6='';
     string testdata7='';
     string testdata8='';
     string testdata9='';
     string testdata10='';
     string testdata11='';
     string testdata12='test';
     string testdata13='';
     string testdata14='';
     string testdata15='';
     string testdata16='';
     string testdata17='';
     string testdata18='';
     string testdata19='';
     string testdata20='';
      string testdata21='';
     string testdata22='';
     string testdata23='';
     string testdata24='';
     string testdata25='';
     string testdata26='';
     string testdata27='';
     string testdata28='';
     string testdata29='';
     string testdata30='';
     string testdata31='';
     string testdata32='';
     
   
    GCCController.ServiceSearch1(testdata1,testdata2,testdata3,testdata4,testdata5,testdata6,testdata7,testdata8,testdata9,testdata10,testdata11,testdata12,testdata13,testdata14,testdata15,testdata16,testdata17,testdata18,testdata19,testdata20,testdata21,testdata22,testdata23,testdata24,testdata25,testdata26,testdata27,testdata28,testdata29,testdata30,testdata31,testdata32);
    
     
     
    }  
    
     static testMethod void ServiceSearchtest13() {
     string testdata1='';
     string testdata2='';
     string testdata3='';
     string testdata4='';
     string testdata5='';
     string testdata6='';
     string testdata7='';
     string testdata8='';
     string testdata9='';
     string testdata10='';
     string testdata11='';
     string testdata12='';
     string testdata13='test';
     string testdata14='';
     string testdata15='';
     string testdata16='';
     string testdata17='';
     string testdata18='';
     string testdata19='';
     string testdata20='';
      string testdata21='';
     string testdata22='';
     string testdata23='';
     string testdata24='';
     string testdata25='';
     string testdata26='';
     string testdata27='';
     string testdata28='';
     string testdata29='';
     string testdata30='';
     string testdata31='';
     string testdata32='';
     
   
    GCCController.ServiceSearch1(testdata1,testdata2,testdata3,testdata4,testdata5,testdata6,testdata7,testdata8,testdata9,testdata10,testdata11,testdata12,testdata13,testdata14,testdata15,testdata16,testdata17,testdata18,testdata19,testdata20,testdata21,testdata22,testdata23,testdata24,testdata25,testdata26,testdata27,testdata28,testdata29,testdata30,testdata31,testdata32);
    
     
     
    }  
     static testMethod void ServiceSearchtest14() {
     string testdata1='';
     string testdata2='';
     string testdata3='';
     string testdata4='';
     string testdata5='';
     string testdata6='';
     string testdata7='';
     string testdata8='';
     string testdata9='';
     string testdata10='';
     string testdata11='';
     string testdata12='';
     string testdata13='';
     string testdata14='test';
     string testdata15='';
     string testdata16='';
     string testdata17='';
     string testdata18='';
     string testdata19='';
     string testdata20='';
      string testdata21='';
     string testdata22='';
     string testdata23='';
     string testdata24='';
     string testdata25='';
     string testdata26='';
     string testdata27='';
     string testdata28='';
     string testdata29='';
     string testdata30='';
     string testdata31='';
     string testdata32='';
     
   
    GCCController.ServiceSearch1(testdata1,testdata2,testdata3,testdata4,testdata5,testdata6,testdata7,testdata8,testdata9,testdata10,testdata11,testdata12,testdata13,testdata14,testdata15,testdata16,testdata17,testdata18,testdata19,testdata20,testdata21,testdata22,testdata23,testdata24,testdata25,testdata26,testdata27,testdata28,testdata29,testdata30,testdata31,testdata32);
    
     
     
    } 
     static testMethod void ServiceSearchtest15() {
     string testdata1='';
     string testdata2='';
     string testdata3='';
     string testdata4='';
     string testdata5='';
     string testdata6='';
     string testdata7='';
     string testdata8='';
     string testdata9='';
     string testdata10='';
     string testdata11='';
     string testdata12='';
     string testdata13='';
     string testdata14='';
     string testdata15='test';
     string testdata16='';
     string testdata17='';
     string testdata18='';
     string testdata19='';
     string testdata20='';
      string testdata21='';
     string testdata22='';
     string testdata23='';
     string testdata24='';
     string testdata25='';
     string testdata26='';
     string testdata27='';
     string testdata28='';
     string testdata29='';
     string testdata30='';
     string testdata31='';
     string testdata32='';
     
   
    GCCController.ServiceSearch1(testdata1,testdata2,testdata3,testdata4,testdata5,testdata6,testdata7,testdata8,testdata9,testdata10,testdata11,testdata12,testdata13,testdata14,testdata15,testdata16,testdata17,testdata18,testdata19,testdata20,testdata21,testdata22,testdata23,testdata24,testdata25,testdata26,testdata27,testdata28,testdata29,testdata30,testdata31,testdata32);
    
     
     
    }   
     static testMethod void ServiceSearchtest16() {
     string testdata1='';
     string testdata2='';
     string testdata3='';
     string testdata4='';
     string testdata5='';
     string testdata6='';
     string testdata7='';
     string testdata8='';
     string testdata9='';
     string testdata10='';
     string testdata11='';
     string testdata12='';
     string testdata13='';
     string testdata14='';
     string testdata15='';
     string testdata16='test';
     string testdata17='';
     string testdata18='';
     string testdata19='';
     string testdata20='';
      string testdata21='';
     string testdata22='';
     string testdata23='';
     string testdata24='';
     string testdata25='';
     string testdata26='';
     string testdata27='';
     string testdata28='';
     string testdata29='';
     string testdata30='';
     string testdata31='';
     string testdata32='';
     
   
    GCCController.ServiceSearch1(testdata1,testdata2,testdata3,testdata4,testdata5,testdata6,testdata7,testdata8,testdata9,testdata10,testdata11,testdata12,testdata13,testdata14,testdata15,testdata16,testdata17,testdata18,testdata19,testdata20,testdata21,testdata22,testdata23,testdata24,testdata25,testdata26,testdata27,testdata28,testdata29,testdata30,testdata31,testdata32);
    
     
     
    }   
    static testMethod void ServiceSearchtest17() {
     string testdata1='';
     string testdata2='';
     string testdata3='';
     string testdata4='';
     string testdata5='';
     string testdata6='';
     string testdata7='';
     string testdata8='';
     string testdata9='';
     string testdata10='';
     string testdata11='';
     string testdata12='';
     string testdata13='';
     string testdata14='';
     string testdata15='';
     string testdata16='';
     string testdata17='test';
     string testdata18='';
     string testdata19='';
     string testdata20='';
      string testdata21='';
     string testdata22='';
     string testdata23='';
     string testdata24='';
     string testdata25='';
     string testdata26='';
     string testdata27='';
     string testdata28='';
     string testdata29='';
     string testdata30='';
     string testdata31='';
     string testdata32='';
     
   
    GCCController.ServiceSearch1(testdata1,testdata2,testdata3,testdata4,testdata5,testdata6,testdata7,testdata8,testdata9,testdata10,testdata11,testdata12,testdata13,testdata14,testdata15,testdata16,testdata17,testdata18,testdata19,testdata20,testdata21,testdata22,testdata23,testdata24,testdata25,testdata26,testdata27,testdata28,testdata29,testdata30,testdata31,testdata32);
    
     
     
    }   
    static testMethod void ServiceSearchtest18() {
     string testdata1='';
     string testdata2='';
     string testdata3='';
     string testdata4='';
     string testdata5='';
     string testdata6='';
     string testdata7='';
     string testdata8='';
     string testdata9='';
     string testdata10='';
     string testdata11='';
     string testdata12='';
     string testdata13='';
     string testdata14='';
     string testdata15='';
     string testdata16='';
     string testdata17='';
     string testdata18='test';
     string testdata19='';
     string testdata20='';
      string testdata21='';
     string testdata22='';
     string testdata23='';
     string testdata24='';
     string testdata25='';
     string testdata26='';
     string testdata27='';
     string testdata28='';
     string testdata29='';
     string testdata30='';
     string testdata31='';
     string testdata32='';
     
   
    GCCController.ServiceSearch1(testdata1,testdata2,testdata3,testdata4,testdata5,testdata6,testdata7,testdata8,testdata9,testdata10,testdata11,testdata12,testdata13,testdata14,testdata15,testdata16,testdata17,testdata18,testdata19,testdata20,testdata21,testdata22,testdata23,testdata24,testdata25,testdata26,testdata27,testdata28,testdata29,testdata30,testdata31,testdata32);
    
     
     
    }   
    static testMethod void ServiceSearchtest19() {
     string testdata1='';
     string testdata2='';
     string testdata3='';
     string testdata4='';
     string testdata5='';
     string testdata6='';
     string testdata7='';
     string testdata8='';
     string testdata9='';
     string testdata10='';
     string testdata11='';
     string testdata12='';
     string testdata13='';
     string testdata14='';
     string testdata15='';
     string testdata16='';
     string testdata17='';
     string testdata18='';
     string testdata19='test';
     string testdata20='';
      string testdata21='';
     string testdata22='';
     string testdata23='';
     string testdata24='';
     string testdata25='';
     string testdata26='';
     string testdata27='';
     string testdata28='';
     string testdata29='';
     string testdata30='';
     string testdata31='';
     string testdata32='';
     
   
    GCCController.ServiceSearch1(testdata1,testdata2,testdata3,testdata4,testdata5,testdata6,testdata7,testdata8,testdata9,testdata10,testdata11,testdata12,testdata13,testdata14,testdata15,testdata16,testdata17,testdata18,testdata19,testdata20,testdata21,testdata22,testdata23,testdata24,testdata25,testdata26,testdata27,testdata28,testdata29,testdata30,testdata31,testdata32);
    
     
     
    }   
    static testMethod void ServiceSearchtest20() {
     string testdata1='';
     string testdata2='';
     string testdata3='';
     string testdata4='';
     string testdata5='';
     string testdata6='';
     string testdata7='';
     string testdata8='';
     string testdata9='';
     string testdata10='';
     string testdata11='';
     string testdata12='';
     string testdata13='';
     string testdata14='';
     string testdata15='';
     string testdata16='';
     string testdata17='';
     string testdata18='';
     string testdata19='';
     string testdata20='test';
      string testdata21='';
     string testdata22='';
     string testdata23='';
     string testdata24='';
     string testdata25='';
     string testdata26='';
     string testdata27='';
     string testdata28='';
     string testdata29='';
     string testdata30='';
     string testdata31='';
     string testdata32='';
     
   
    GCCController.ServiceSearch1(testdata1,testdata2,testdata3,testdata4,testdata5,testdata6,testdata7,testdata8,testdata9,testdata10,testdata11,testdata12,testdata13,testdata14,testdata15,testdata16,testdata17,testdata18,testdata19,testdata20,testdata21,testdata22,testdata23,testdata24,testdata25,testdata26,testdata27,testdata28,testdata29,testdata30,testdata31,testdata32);
    
     
     
    }   
     static testMethod void ServiceSearchtest21() {
     string testdata1='';
     string testdata2='';
     string testdata3='';
     string testdata4='';
     string testdata5='';
     string testdata6='';
     string testdata7='';
     string testdata8='';
     string testdata9='';
     string testdata10='';
     string testdata11='';
     string testdata12='';
     string testdata13='';
     string testdata14='';
     string testdata15='';
     string testdata16='';
     string testdata17='';
     string testdata18='';
     string testdata19='';
     string testdata20='';
      string testdata21='test';
     string testdata22='';
     string testdata23='';
     string testdata24='';
     string testdata25='';
     string testdata26='';
     string testdata27='';
     string testdata28='';
     string testdata29='';
     string testdata30='';
     string testdata31='';
     string testdata32='';
     
   
    GCCController.ServiceSearch1(testdata1,testdata2,testdata3,testdata4,testdata5,testdata6,testdata7,testdata8,testdata9,testdata10,testdata11,testdata12,testdata13,testdata14,testdata15,testdata16,testdata17,testdata18,testdata19,testdata20,testdata21,testdata22,testdata23,testdata24,testdata25,testdata26,testdata27,testdata28,testdata29,testdata30,testdata31,testdata32);
    
     
     
    }   
     static testMethod void ServiceSearchtest22() {
     string testdata1='';
     string testdata2='';
     string testdata3='';
     string testdata4='';
     string testdata5='';
     string testdata6='';
     string testdata7='';
     string testdata8='';
     string testdata9='';
     string testdata10='';
     string testdata11='';
     string testdata12='';
     string testdata13='';
     string testdata14='';
     string testdata15='';
     string testdata16='';
     string testdata17='';
     string testdata18='';
     string testdata19='';
     string testdata20='';
      string testdata21='';
     string testdata22='test';
     string testdata23='';
     string testdata24='';
     string testdata25='';
     string testdata26='';
     string testdata27='';
     string testdata28='';
     string testdata29='';
     string testdata30='';
     string testdata31='';
     string testdata32='';
     
   
    GCCController.ServiceSearch1(testdata1,testdata2,testdata3,testdata4,testdata5,testdata6,testdata7,testdata8,testdata9,testdata10,testdata11,testdata12,testdata13,testdata14,testdata15,testdata16,testdata17,testdata18,testdata19,testdata20,testdata21,testdata22,testdata23,testdata24,testdata25,testdata26,testdata27,testdata28,testdata29,testdata30,testdata31,testdata32);
    
     
     
    }  
    static testMethod void ServiceSearchtest23() {
     string testdata1='';
     string testdata2='';
     string testdata3='';
     string testdata4='';
     string testdata5='';
     string testdata6='';
     string testdata7='';
     string testdata8='';
     string testdata9='';
     string testdata10='';
     string testdata11='';
     string testdata12='';
     string testdata13='';
     string testdata14='';
     string testdata15='';
     string testdata16='';
     string testdata17='';
     string testdata18='';
     string testdata19='';
     string testdata20='';
      string testdata21='';
     string testdata22='';
     string testdata23='test';
     string testdata24='';
     string testdata25='';
     string testdata26='';
     string testdata27='';
     string testdata28='';
     string testdata29='';
     string testdata30='';
     string testdata31='';
     string testdata32='';
     
   
    GCCController.ServiceSearch1(testdata1,testdata2,testdata3,testdata4,testdata5,testdata6,testdata7,testdata8,testdata9,testdata10,testdata11,testdata12,testdata13,testdata14,testdata15,testdata16,testdata17,testdata18,testdata19,testdata20,testdata21,testdata22,testdata23,testdata24,testdata25,testdata26,testdata27,testdata28,testdata29,testdata30,testdata31,testdata32);
    
     
     
    }  
    static testMethod void ServiceSearchtest24() {
     string testdata1='';
     string testdata2='';
     string testdata3='';
     string testdata4='';
     string testdata5='';
     string testdata6='';
     string testdata7='';
     string testdata8='';
     string testdata9='';
     string testdata10='';
     string testdata11='';
     string testdata12='';
     string testdata13='';
     string testdata14='';
     string testdata15='';
     string testdata16='';
     string testdata17='';
     string testdata18='';
     string testdata19='';
     string testdata20='';
      string testdata21='';
     string testdata22='';
     string testdata23='';
     string testdata24='test';
     string testdata25='';
     string testdata26='';
     string testdata27='';
     string testdata28='';
     string testdata29='';
     string testdata30='';
     string testdata31='';
     string testdata32='';
     
   
    GCCController.ServiceSearch1(testdata1,testdata2,testdata3,testdata4,testdata5,testdata6,testdata7,testdata8,testdata9,testdata10,testdata11,testdata12,testdata13,testdata14,testdata15,testdata16,testdata17,testdata18,testdata19,testdata20,testdata21,testdata22,testdata23,testdata24,testdata25,testdata26,testdata27,testdata28,testdata29,testdata30,testdata31,testdata32);
    
     
     
    } 
     static testMethod void ServiceSearchtest25() {
     string testdata1='';
     string testdata2='';
     string testdata3='';
     string testdata4='';
     string testdata5='';
     string testdata6='';
     string testdata7='';
     string testdata8='';
     string testdata9='';
     string testdata10='';
     string testdata11='';
     string testdata12='';
     string testdata13='';
     string testdata14='';
     string testdata15='';
     string testdata16='';
     string testdata17='';
     string testdata18='';
     string testdata19='';
     string testdata20='';
      string testdata21='';
     string testdata22='';
     string testdata23='';
     string testdata24='';
     string testdata25='test';
     string testdata26='';
     string testdata27='';
     string testdata28='';
     string testdata29='';
     string testdata30='';
     string testdata31='';
     string testdata32='';
     
   
    GCCController.ServiceSearch1(testdata1,testdata2,testdata3,testdata4,testdata5,testdata6,testdata7,testdata8,testdata9,testdata10,testdata11,testdata12,testdata13,testdata14,testdata15,testdata16,testdata17,testdata18,testdata19,testdata20,testdata21,testdata22,testdata23,testdata24,testdata25,testdata26,testdata27,testdata28,testdata29,testdata30,testdata31,testdata32);
    
     
     
    } 
     static testMethod void ServiceSearchtest26() {
     string testdata1='';
     string testdata2='';
     string testdata3='';
     string testdata4='';
     string testdata5='';
     string testdata6='';
     string testdata7='';
     string testdata8='';
     string testdata9='';
     string testdata10='';
     string testdata11='';
     string testdata12='';
     string testdata13='';
     string testdata14='';
     string testdata15='';
     string testdata16='';
     string testdata17='';
     string testdata18='';
     string testdata19='';
     string testdata20='';
      string testdata21='';
     string testdata22='';
     string testdata23='';
     string testdata24='';
     string testdata25='';
     string testdata26='test';
     string testdata27='';
     string testdata28='';
     string testdata29='';
     string testdata30='';
     string testdata31='';
     string testdata32='';
     
   
    GCCController.ServiceSearch1(testdata1,testdata2,testdata3,testdata4,testdata5,testdata6,testdata7,testdata8,testdata9,testdata10,testdata11,testdata12,testdata13,testdata14,testdata15,testdata16,testdata17,testdata18,testdata19,testdata20,testdata21,testdata22,testdata23,testdata24,testdata25,testdata26,testdata27,testdata28,testdata29,testdata30,testdata31,testdata32);
    
     
     
    } 
      static testMethod void ServiceSearchtest27() {
     string testdata1='';
     string testdata2='';
     string testdata3='';
     string testdata4='';
     string testdata5='';
     string testdata6='';
     string testdata7='';
     string testdata8='';
     string testdata9='';
     string testdata10='';
     string testdata11='';
     string testdata12='';
     string testdata13='';
     string testdata14='';
     string testdata15='';
     string testdata16='';
     string testdata17='';
     string testdata18='';
     string testdata19='';
     string testdata20='';
      string testdata21='';
     string testdata22='';
     string testdata23='';
     string testdata24='';
     string testdata25='';
     string testdata26='';
     string testdata27='test';
     string testdata28='';
     string testdata29='';
     string testdata30='';
     string testdata31='';
     string testdata32='';
     
   
    GCCController.ServiceSearch1(testdata1,testdata2,testdata3,testdata4,testdata5,testdata6,testdata7,testdata8,testdata9,testdata10,testdata11,testdata12,testdata13,testdata14,testdata15,testdata16,testdata17,testdata18,testdata19,testdata20,testdata21,testdata22,testdata23,testdata24,testdata25,testdata26,testdata27,testdata28,testdata29,testdata30,testdata31,testdata32);
    
     
     
    } 
     static testMethod void ServiceSearchtest28() {
     string testdata1='';
     string testdata2='';
     string testdata3='';
     string testdata4='';
     string testdata5='';
     string testdata6='';
     string testdata7='';
     string testdata8='';
     string testdata9='';
     string testdata10='';
     string testdata11='';
     string testdata12='';
     string testdata13='';
     string testdata14='';
     string testdata15='';
     string testdata16='';
     string testdata17='';
     string testdata18='';
     string testdata19='';
     string testdata20='';
      string testdata21='';
     string testdata22='';
     string testdata23='';
     string testdata24='';
     string testdata25='';
     string testdata26='';
     string testdata27='';
     string testdata28='test';
     string testdata29='';
     string testdata30='';
     string testdata31='';
     string testdata32='';
     
   
    GCCController.ServiceSearch1(testdata1,testdata2,testdata3,testdata4,testdata5,testdata6,testdata7,testdata8,testdata9,testdata10,testdata11,testdata12,testdata13,testdata14,testdata15,testdata16,testdata17,testdata18,testdata19,testdata20,testdata21,testdata22,testdata23,testdata24,testdata25,testdata26,testdata27,testdata28,testdata29,testdata30,testdata31,testdata32);
    
     
     
    } 
     static testMethod void ServiceSearchtest29() {
     string testdata1='';
     string testdata2='';
     string testdata3='';
     string testdata4='';
     string testdata5='';
     string testdata6='';
     string testdata7='';
     string testdata8='';
     string testdata9='';
     string testdata10='';
     string testdata11='';
     string testdata12='';
     string testdata13='';
     string testdata14='';
     string testdata15='';
     string testdata16='';
     string testdata17='';
     string testdata18='';
     string testdata19='';
     string testdata20='';
      string testdata21='';
     string testdata22='';
     string testdata23='';
     string testdata24='';
     string testdata25='';
     string testdata26='';
     string testdata27='';
     string testdata28='';
     string testdata29='test';
     string testdata30='';
     string testdata31='';
     string testdata32='';
     
   
    GCCController.ServiceSearch1(testdata1,testdata2,testdata3,testdata4,testdata5,testdata6,testdata7,testdata8,testdata9,testdata10,testdata11,testdata12,testdata13,testdata14,testdata15,testdata16,testdata17,testdata18,testdata19,testdata20,testdata21,testdata22,testdata23,testdata24,testdata25,testdata26,testdata27,testdata28,testdata29,testdata30,testdata31,testdata32);
    
     
     
    } 
    static testMethod void ServiceSearchtest30() {
     string testdata1='';
     string testdata2='';
     string testdata3='';
     string testdata4='';
     string testdata5='';
     string testdata6='';
     string testdata7='';
     string testdata8='';
     string testdata9='';
     string testdata10='';
     string testdata11='';
     string testdata12='';
     string testdata13='';
     string testdata14='';
     string testdata15='';
     string testdata16='';
     string testdata17='';
     string testdata18='';
     string testdata19='';
     string testdata20='';
      string testdata21='';
     string testdata22='';
     string testdata23='';
     string testdata24='';
     string testdata25='';
     string testdata26='';
     string testdata27='';
     string testdata28='';
     string testdata29='';
     string testdata30='test';
     string testdata31='';
     string testdata32='';
     
   
    GCCController.ServiceSearch1(testdata1,testdata2,testdata3,testdata4,testdata5,testdata6,testdata7,testdata8,testdata9,testdata10,testdata11,testdata12,testdata13,testdata14,testdata15,testdata16,testdata17,testdata18,testdata19,testdata20,testdata21,testdata22,testdata23,testdata24,testdata25,testdata26,testdata27,testdata28,testdata29,testdata30,testdata31,testdata32);
    
     
     
    } 
    
      static testMethod void ServiceSearchtest31() {
     string testdata1='';
     string testdata2='';
     string testdata3='';
     string testdata4='';
     string testdata5='';
     string testdata6='';
     string testdata7='';
     string testdata8='';
     string testdata9='';
     string testdata10='';
     string testdata11='';
     string testdata12='';
     string testdata13='';
     string testdata14='';
     string testdata15='';
     string testdata16='';
     string testdata17='';
     string testdata18='';
     string testdata19='';
     string testdata20='';
      string testdata21='';
     string testdata22='';
     string testdata23='';
     string testdata24='';
     string testdata25='';
     string testdata26='';
     string testdata27='';
     string testdata28='';
     string testdata29='';
     string testdata30='';
     string testdata31='test';
     string testdata32='';
     
   
    GCCController.ServiceSearch1(testdata1,testdata2,testdata3,testdata4,testdata5,testdata6,testdata7,testdata8,testdata9,testdata10,testdata11,testdata12,testdata13,testdata14,testdata15,testdata16,testdata17,testdata18,testdata19,testdata20,testdata21,testdata22,testdata23,testdata24,testdata25,testdata26,testdata27,testdata28,testdata29,testdata30,testdata31,testdata32);
    
     
     
    }
    static testMethod void ServiceSearchtest32() {
     string testdata1='';
     string testdata2='';
     string testdata3='';
     string testdata4='';
     string testdata5='';
     string testdata6='';
     string testdata7='';
     string testdata8='';
     string testdata9='';
     string testdata10='';
     string testdata11='';
     string testdata12='';
     string testdata13='';
     string testdata14='';
     string testdata15='';
     string testdata16='';
     string testdata17='';
     string testdata18='';
     string testdata19='';
     string testdata20='';
      string testdata21='';
     string testdata22='';
     string testdata23='';
     string testdata24='';
     string testdata25='';
     string testdata26='';
     string testdata27='';
     string testdata28='';
     string testdata29='';
     string testdata30='';
     string testdata31='';
     string testdata32='test';
     
   
    GCCController.ServiceSearch1(testdata1,testdata2,testdata3,testdata4,testdata5,testdata6,testdata7,testdata8,testdata9,testdata10,testdata11,testdata12,testdata13,testdata14,testdata15,testdata16,testdata17,testdata18,testdata19,testdata20,testdata21,testdata22,testdata23,testdata24,testdata25,testdata26,testdata27,testdata28,testdata29,testdata30,testdata31,testdata32);
    
     
     
    }
    static testMethod void ServiceSearchtest33() {
     string testdata1='';
     string testdata2='';
     string testdata3='';
     string testdata4='';
     string testdata5='';
     string testdata6='';
     string testdata7='';
     string testdata8='';
     string testdata9='test';
     string testdata10='';
     string testdata11='';
     string testdata12='';
     string testdata13='';
     string testdata14='';
     string testdata15='';
     string testdata16='';
     string testdata17='';
     string testdata18='';
     string testdata19='';
     string testdata20='';
      string testdata21='';
     string testdata22='';
     string testdata23='';
     string testdata24='';
     string testdata25='';
     string testdata26='';
     string testdata27='';
     string testdata28='';
     string testdata29='';
     string testdata30='';
     string testdata31='';
     string testdata32='';
     
   
    GCCController.ServiceSearch1(testdata1,testdata2,testdata3,testdata4,testdata5,testdata6,testdata7,testdata8,testdata9,testdata10,testdata11,testdata12,testdata13,testdata14,testdata15,testdata16,testdata17,testdata18,testdata19,testdata20,testdata21,testdata22,testdata23,testdata24,testdata25,testdata26,testdata27,testdata28,testdata29,testdata30,testdata31,testdata32);
    
     
     
    }
    static testMethod void ServiceSearchtest34() {
     string testdata1='';
     string testdata2='';
     string testdata3='';
     string testdata4='';
     string testdata5='';
     string testdata6='';
     string testdata7='';
     string testdata8='';
     string testdata9='';
     string testdata10='';
     string testdata11='test';
     string testdata12='';
     string testdata13='';
     string testdata14='';
     string testdata15='';
     string testdata16='';
     string testdata17='';
     string testdata18='';
     string testdata19='';
     string testdata20='';
      string testdata21='';
     string testdata22='';
     string testdata23='';
     string testdata24='';
     string testdata25='';
     string testdata26='';
     string testdata27='';
     string testdata28='';
     string testdata29='';
     string testdata30='';
     string testdata31='';
     string testdata32='';
     
   
    GCCController.ServiceSearch1(testdata1,testdata2,testdata3,testdata4,testdata5,testdata6,testdata7,testdata8,testdata9,testdata10,testdata11,testdata12,testdata13,testdata14,testdata15,testdata16,testdata17,testdata18,testdata19,testdata20,testdata21,testdata22,testdata23,testdata24,testdata25,testdata26,testdata27,testdata28,testdata29,testdata30,testdata31,testdata32);
    
     
     
    }
     static testMethod void ServiceSearchtest35() {
     string testdata1='test';
     string testdata2='';
     string testdata3='test-con';
     string testdata4='';
     string testdata5='';
     string testdata6='';
     string testdata7='';
     string testdata8='';
     string testdata9='';
     string testdata10='';
     string testdata11='';
     string testdata12='';
     string testdata13='';
     string testdata14='';
     string testdata15='';
     string testdata16='';
     string testdata17='';
     string testdata18='';
     string testdata19='';
     string testdata20='';
      string testdata21='';
     string testdata22='';
     string testdata23='';
     string testdata24='';
     string testdata25='';
     string testdata26='';
     string testdata27='';
     string testdata28='';
     string testdata29='';
     string testdata30='';
     string testdata31='';
     string testdata32='';
     
   
    GCCController.ServiceSearch1(testdata1,testdata2,testdata3,testdata4,testdata5,testdata6,testdata7,testdata8,testdata9,testdata10,testdata11,testdata12,testdata13,testdata14,testdata15,testdata16,testdata17,testdata18,testdata19,testdata20,testdata21,testdata22,testdata23,testdata24,testdata25,testdata26,testdata27,testdata28,testdata29,testdata30,testdata31,testdata32);
    
     
      
    }
    
     static testMethod void ServiceSearchtest36() {
     string testdata1='';
     string testdata2='';
     string testdata3='test-con';
     string testdata4='';
     string testdata5='';
     string testdata6='';
     string testdata7='';
     string testdata8='';
     string testdata9='';
     string testdata10='';
     string testdata11='';
     string testdata12='';
     string testdata13='';
     string testdata14='';
     string testdata15='';
     string testdata16='';
     string testdata17='';
     string testdata18='';
     string testdata19='';
     string testdata20='';
      string testdata21='';
     string testdata22='';
     string testdata23='';
     string testdata24='';
     string testdata25='';
     string testdata26='';
     string testdata27='';
     string testdata28='';
     string testdata29='';
     string testdata30='';
     string testdata31='';
     string testdata32='';
     
   
    GCCController.ServiceSearch1(testdata1,testdata2,testdata3,testdata4,testdata5,testdata6,testdata7,testdata8,testdata9,testdata10,testdata11,testdata12,testdata13,testdata14,testdata15,testdata16,testdata17,testdata18,testdata19,testdata20,testdata21,testdata22,testdata23,testdata24,testdata25,testdata26,testdata27,testdata28,testdata29,testdata30,testdata31,testdata32);
    
     
      }
      
      static testMethod void ServiceSearchtest37() {
     string testdata1='';
     string testdata2='';
     string testdata3='test-con';
     string testdata4='';
     string testdata5='';
     string testdata6='';
     string testdata7='';
     string testdata8='';
     string testdata9='';
     string testdata10='';
     string testdata11='';
     string testdata12='';
     string testdata13='';
     string testdata14='';
     string testdata15='';
     string testdata16='';
     string testdata17='';
     string testdata18='';
     string testdata19='';
     string testdata20='';
      string testdata21='';
     string testdata22='';
     string testdata23='';
     string testdata24='';
     string testdata25='';
     string testdata26='';
     string testdata27='';
     string testdata28='';
     string testdata29='';
     string testdata30='';
     string testdata31='test';
     string testdata32='sortby';
     
   
    GCCController.ServiceSearch1(testdata1,testdata2,testdata3,testdata4,testdata5,testdata6,testdata7,testdata8,testdata9,testdata10,testdata11,testdata12,testdata13,testdata14,testdata15,testdata16,testdata17,testdata18,testdata19,testdata20,testdata21,testdata22,testdata23,testdata24,testdata25,testdata26,testdata27,testdata28,testdata29,testdata30,testdata31,testdata32);
      }
    
          static testMethod void ServiceSearchtest38() {
     string testdata1='';
     string testdata2='';
     string testdata3='test-con';
     string testdata4='';
     string testdata5='';
     string testdata6='';
     string testdata7='';
     string testdata8='';
     string testdata9='';
     string testdata10='';
     string testdata11='';
     string testdata12='';
     string testdata13='';
     string testdata14='';
     string testdata15='';
     string testdata16='';
     string testdata17='';
     string testdata18='';
     string testdata19='';
     string testdata20='';
      string testdata21='';
     string testdata22='';
     string testdata23='';
     string testdata24='';
     string testdata25='';
     string testdata26='';
     string testdata27='';
     string testdata28='';
     string testdata29='';
     string testdata30='';
     string testdata31='test';
     string testdata32='sortbyreverse';
     
   
    GCCController.ServiceSearch1(testdata1,testdata2,testdata3,testdata4,testdata5,testdata6,testdata7,testdata8,testdata9,testdata10,testdata11,testdata12,testdata13,testdata14,testdata15,testdata16,testdata17,testdata18,testdata19,testdata20,testdata21,testdata22,testdata23,testdata24,testdata25,testdata26,testdata27,testdata28,testdata29,testdata30,testdata31,testdata32);
    
     
      }
    static testMethod void ServiceSearchtest39() {
     string testdata1='';
     string testdata2='';
     string testdata3='test-con';
     string testdata4='';
     string testdata5='';
     string testdata6='';
     string testdata7='';
     string testdata8='';
     string testdata9='';
     string testdata10='';
     string testdata11='';
     string testdata12='';
     string testdata13='';
     string testdata14='';
     string testdata15='';
     string testdata16='';
     string testdata17='';
     string testdata18='';
     string testdata19='';
     string testdata20='';
      string testdata21='';
     string testdata22='';
     string testdata23='';
     string testdata24='';
     string testdata25='';
     string testdata26='';
     string testdata27='';
     string testdata28='';
     string testdata29='';
     string testdata30='';
     string testdata31='test';
     string testdata32='closedsortby';
     
   
    GCCController.ServiceSearch1(testdata1,testdata2,testdata3,testdata4,testdata5,testdata6,testdata7,testdata8,testdata9,testdata10,testdata11,testdata12,testdata13,testdata14,testdata15,testdata16,testdata17,testdata18,testdata19,testdata20,testdata21,testdata22,testdata23,testdata24,testdata25,testdata26,testdata27,testdata28,testdata29,testdata30,testdata31,testdata32);
    
     
      }
    static testMethod void ServiceSearchtest40() {
     string testdata1='';
     string testdata2='';
     string testdata3='test-con';
     string testdata4='';
     string testdata5='';
     string testdata6='';
     string testdata7='';
     string testdata8='';
     string testdata9='';
     string testdata10='';
     string testdata11='';
     string testdata12='';
     string testdata13='';
     string testdata14='';
     string testdata15='';
     string testdata16='';
     string testdata17='';
     string testdata18='';
     string testdata19='';
     string testdata20='';
      string testdata21='';
     string testdata22='';
     string testdata23='';
     string testdata24='';
     string testdata25='';
     string testdata26='';
     string testdata27='';
     string testdata28='';
     string testdata29='';
     string testdata30='';
     string testdata31='test';
     string testdata32='closedsortbyreverse';
     
   
    GCCController.ServiceSearch1(testdata1,testdata2,testdata3,testdata4,testdata5,testdata6,testdata7,testdata8,testdata9,testdata10,testdata11,testdata12,testdata13,testdata14,testdata15,testdata16,testdata17,testdata18,testdata19,testdata20,testdata21,testdata22,testdata23,testdata24,testdata25,testdata26,testdata27,testdata28,testdata29,testdata30,testdata31,testdata32);
    
     
      }
    static testMethod void ServiceSearchtest41() {
     string testdata1='';
     string testdata2='';
     string testdata3='test-con';
     string testdata4='';
     string testdata5='';
     string testdata6='';
     string testdata7='';
     string testdata8='';
     string testdata9='';
     string testdata10='';
     string testdata11='';
     string testdata12='';
     string testdata13='';
     string testdata14='';
     string testdata15='';
     string testdata16='';
     string testdata17='';
     string testdata18='';
     string testdata19='';
     string testdata20='';
      string testdata21='';
     string testdata22='';
     string testdata23='';
     string testdata24='';
     string testdata25='';
     string testdata26='';
     string testdata27='';
     string testdata28='';
     string testdata29='';
     string testdata30='';
     string testdata31='test';
     string testdata32='';
     
   
    GCCController.ServiceSearch1(testdata1,testdata2,testdata3,testdata4,testdata5,testdata6,testdata7,testdata8,testdata9,testdata10,testdata11,testdata12,testdata13,testdata14,testdata15,testdata16,testdata17,testdata18,testdata19,testdata20,testdata21,testdata22,testdata23,testdata24,testdata25,testdata26,testdata27,testdata28,testdata29,testdata30,testdata31,testdata32);
    
     
      }
    }