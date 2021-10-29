public class EntitlementRecurrencecls1 {
    public Entitlement__c En;
    public Entitlement__c Ent{get;set;}
    public string contrid ;
    public string entid ;
    public string Recurencetype{get;set;} 
    public date datename{get;set;}
    public date datename1{get;set;} 
    public Integer Noc{get;set;} 
    public integer ty;
    public integer tm;
    public integer td;
    public integer Noy;
    public integer Nom;
    public Date enddate;
    public Date enddate1;
    public integer Noq;
    public integer Noq1;
    public integer Noq2;
    public integer tm1;
    list<Entitlement__c> Entlst = new list<Entitlement__c >();

        public EntitlementRecurrencecls1(ApexPages.StandardController controller) {
        
         Recurencetype = 'Monthly';
         contrid = Apexpages.currentPage().getParameters().get('Contract');
         entid= Apexpages.currentPage().getParameters().get('Entitlement');
         En = [select id,Entitlement_Name__c,Entitlement_Type__c,Entitlement_Start_Date__c,Status__c,Contract_Number__c,Legacy_Entitlement_Number__c,SBL_S_DOC_AGREE_ROW_ID__c,Comments__c,End_Date__c,Course__c,Reference__c,Product_Serial_Number__c,Serv_HON_Product_Name__c,Fleet_Asset_Aircraft__c,Serv_Aircraft_Serial_No__c,Serv_Aircraft_Platform_and_Model__c,Platform__c,Serv_Model_Number_and_Serial_Number__c,Serv_Engine_APU_Model_and_Serial_Number__c,Serv_Data_Supplier__c,Serv_Delivery_Type__c,Serv_Format__c,Serv_Media_Type__c,Serv_Nav_Database_Descr__c,Serv_NavDB_Ident__c,Serv_Price_Plan__c,Serv_Prod_Descr__c,Serv_Subscription_Type__c,Data_Load_Date__c,Source_Created_Date__c,Source_Modified_Date__c from Entitlement__c where id=:entid];
         
        }
    
        public pagereference save1(){
          
          if(datename1 == null){
           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Start date must be entered to schedule entitlement.')); 
            return null;
          }
          if(datename == null && (Noc == null || Noc<=0) ){
           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'End date or occurences must be entered to schedule entitlement.')); 
            return null;
          }
          if(datename<datename1){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'End date must be on or after start date.')); 
            return null;
          }
          if(datename1<En.Entitlement_Start_Date__c){
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'start date must be after Entitlement Start Date.')); 
            return null;
          }
               ty = datename1.year(); 
               tm = datename1.Month();
               td = datename1.Day(); 
               system.debug('11111'+ty);
          
               Date startdate = date.newinstance(ty, En.Entitlement_Start_Date__c.month(), En.Entitlement_Start_Date__c.day());
               Date startdate1 = date.newinstance(ty, tm, td);
               if(En.End_Date__c!=null)
               {
               integer y= ty+(En.End_Date__c.Year()-En.Entitlement_Start_Date__c.Year());
               //integer m = tm+(En.End_Date__c.Month()-En.Entitlement_Start_Date__c.Month());
               date dd =  En.Entitlement_Start_Date__c;
               integer m = dd.monthsBetween(En.End_Date__c);
               enddate = date.newinstance(y, En.End_Date__c.month(), En.End_Date__c.day());
               //enddate1 = date.newinstance(y, m, 10);
                  enddate1 = datename1.addMonths(m);
               
               system.debug('11111'+enddate1);
               }
              Integer[] myList = new Integer[]{31,28,31,30,31,30,31,31,30,31,30,31};
             if(Recurencetype=='Yearly'){
                
                if(Noc!= null){
            
                    for(integer i=0;i<Noc;i++){
                      Entitlement__c Entit = new Entitlement__c ();
                        Entit.Contract_Number__c=En.Contract_Number__c;
                        Entit.Entitlement_Name__c = En.Entitlement_Name__c; 
                        Entit.Status__c = En.Status__c;
                        Entit.Legacy_Entitlement_Number__c = En.Legacy_Entitlement_Number__c ;
                        Entit.Entitlement_Type__c = En.Entitlement_Type__c;
                        Entit.SBL_S_DOC_AGREE_ROW_ID__c = En.SBL_S_DOC_AGREE_ROW_ID__c;
                      //Entit.Entitlement_Start_Date__c = En.Entitlement_Start_Date__c;
                        Entit.Comments__c = En.Comments__c;
                        if(En.End_Date__c!=null)
                        Entit.End_Date__c = enddate.addYears(i); 
                        Entit.Course__c = En.Course__c;
                        Entit.Reference__c = En.Reference__c ;
                        Entit.Product_Serial_Number__c = En.Product_Serial_Number__c;
                        Entit.Serv_HON_Product_Name__c = En.Serv_HON_Product_Name__c;
                        Entit.Fleet_Asset_Aircraft__c = En.Fleet_Asset_Aircraft__c ;
                        Entit.Serv_Aircraft_Serial_No__c = En.Serv_Aircraft_Serial_No__c;
                        Entit.Serv_Aircraft_Platform_and_Model__c = En.Serv_Aircraft_Platform_and_Model__c;
                        Entit.Platform__c = En.Platform__c;
                        Entit.Serv_Model_Number_and_Serial_Number__c = En.Serv_Model_Number_and_Serial_Number__c;
                        Entit.Serv_Engine_APU_Model_and_Serial_Number__c = En.Serv_Engine_APU_Model_and_Serial_Number__c; 
                        Entit.Serv_Data_Supplier__c = En.Serv_Data_Supplier__c;
                        Entit.Serv_Delivery_Type__c = En.Serv_Delivery_Type__c;
                        Entit.Serv_Format__c = En.Serv_Format__c;
                        Entit.Serv_Media_Type__c = En.Serv_Media_Type__c;
                        Entit.Serv_Nav_Database_Descr__c = En.Serv_Nav_Database_Descr__c;
                        Entit.Serv_NavDB_Ident__c = En.Serv_NavDB_Ident__c;
                        Entit.Serv_Price_Plan__c = En.Serv_Price_Plan__c ;
                        Entit.Serv_Prod_Descr__c = En.Serv_Prod_Descr__c;
                        Entit.Serv_Subscription_Type__c = En.Serv_Subscription_Type__c;
                        Entit.Data_Load_Date__c = En.Data_Load_Date__c;
                        Entit.Source_Created_Date__c = En.Source_Created_Date__c;
                        Entit.Source_Modified_Date__c = En.Source_Modified_Date__c; 
                        Entit.Entitlement_Start_Date__c = startdate.addYears(i);
                        Entlst.add(Entit); 
                    }
                }
                    
               if(datename!=null){
                 Noy= datename.year()- datename1.year();
                    for(integer i=0;i<=Noy;i++){
                     Entitlement__c Entit = new Entitlement__c ();
                        Entit.Contract_Number__c=En.Contract_Number__c;
                        Entit.Entitlement_Name__c = En.Entitlement_Name__c; 
                        Entit.Status__c = En.Status__c;
                        Entit.Legacy_Entitlement_Number__c = En.Legacy_Entitlement_Number__c ;
                        Entit.Entitlement_Type__c = En.Entitlement_Type__c;
                        Entit.SBL_S_DOC_AGREE_ROW_ID__c = En.SBL_S_DOC_AGREE_ROW_ID__c;
                        //Entit.Entitlement_Start_Date__c = En.Entitlement_Start_Date__c;
                        Entit.Comments__c = En.Comments__c;
                        if(En.End_Date__c!=null)
                        Entit.End_Date__c = enddate.addYears(i);
                        Entit.Course__c = En.Course__c;
                        Entit.Reference__c = En.Reference__c ;
                        Entit.Product_Serial_Number__c = En.Product_Serial_Number__c;
                        Entit.Serv_HON_Product_Name__c = En.Serv_HON_Product_Name__c;
                        Entit.Fleet_Asset_Aircraft__c = En.Fleet_Asset_Aircraft__c ;
                        Entit.Serv_Aircraft_Serial_No__c = En.Serv_Aircraft_Serial_No__c;
                        Entit.Serv_Aircraft_Platform_and_Model__c = En.Serv_Aircraft_Platform_and_Model__c;
                        Entit.Platform__c = En.Platform__c;
                        Entit.Serv_Model_Number_and_Serial_Number__c = En.Serv_Model_Number_and_Serial_Number__c;
                        Entit.Serv_Engine_APU_Model_and_Serial_Number__c = En.Serv_Engine_APU_Model_and_Serial_Number__c; 
                        Entit.Serv_Data_Supplier__c = En.Serv_Data_Supplier__c;
                        Entit.Serv_Delivery_Type__c = En.Serv_Delivery_Type__c;
                        Entit.Serv_Format__c = En.Serv_Format__c;
                        Entit.Serv_Media_Type__c = En.Serv_Media_Type__c;
                        Entit.Serv_Nav_Database_Descr__c = En.Serv_Nav_Database_Descr__c;
                        Entit.Serv_NavDB_Ident__c = En.Serv_NavDB_Ident__c;
                        Entit.Serv_Price_Plan__c = En.Serv_Price_Plan__c ;
                        Entit.Serv_Prod_Descr__c = En.Serv_Prod_Descr__c;
                        Entit.Serv_Subscription_Type__c = En.Serv_Subscription_Type__c;
                        Entit.Data_Load_Date__c = En.Data_Load_Date__c;
                        Entit.Source_Created_Date__c = En.Source_Created_Date__c;
                        Entit.Source_Modified_Date__c = En.Source_Modified_Date__c; 
                        Entit.Entitlement_Start_Date__c = startdate.addYears(i);
                        Entlst.add(Entit); 
                    }
        
                 system.debug('33333'+Entlst);
                 system.debug('11111'+Recurencetype );
                 system.debug('22222'+datename1);
                 system.debug('33333'+Noc);
                }
            }
            if(Recurencetype=='Monthly'){
            
              if(Noc!= null){
                    for(integer i=0;i<Noc;i++){
                      Entitlement__c Entit = new Entitlement__c ();
                     
                        Entit.Contract_Number__c=En.Contract_Number__c;
                        Entit.Entitlement_Name__c = En.Entitlement_Name__c; 
                        Entit.Status__c = En.Status__c;
                        Entit.Legacy_Entitlement_Number__c = En.Legacy_Entitlement_Number__c ;
                        Entit.Entitlement_Type__c = En.Entitlement_Type__c;
                        Entit.SBL_S_DOC_AGREE_ROW_ID__c = En.SBL_S_DOC_AGREE_ROW_ID__c;
                      //Entit.Entitlement_Start_Date__c = En.Entitlement_Start_Date__c;
                        Entit.Comments__c = En.Comments__c;
                        if(En.End_Date__c!=null){
                        
                       
                         date d2 = enddate1.addMonths(i);
                          if(En.End_Date__c.day()==31){
                          
                          
                          Entit.End_Date__c = date.newinstance( d2.year(), d2.month(), myList[d2.month()-1]);
                        }
                        else if(d2.month()==2 && (En.End_Date__c.day()==31 || En.End_Date__c.day()==30 || En.End_Date__c.day()==29) ){
                         Entit.End_Date__c = date.newinstance( d2.year(), d2.month(), myList[d2.month()-1]);
                        }
                        else{
                         Entit.End_Date__c =date.newinstance( d2.year(), d2.month(),En.End_Date__c.day());
                        }
                         }
                        //Entit.End_Date__c = enddate1.addMonths(i); 
                        Entit.Course__c = En.Course__c;
                        Entit.Reference__c = En.Reference__c ;
                        Entit.Product_Serial_Number__c = En.Product_Serial_Number__c;
                        Entit.Serv_HON_Product_Name__c = En.Serv_HON_Product_Name__c;
                        Entit.Fleet_Asset_Aircraft__c = En.Fleet_Asset_Aircraft__c ;
                        Entit.Serv_Aircraft_Serial_No__c = En.Serv_Aircraft_Serial_No__c;
                        Entit.Serv_Aircraft_Platform_and_Model__c = En.Serv_Aircraft_Platform_and_Model__c;
                        Entit.Platform__c = En.Platform__c;
                        Entit.Serv_Model_Number_and_Serial_Number__c = En.Serv_Model_Number_and_Serial_Number__c;
                        Entit.Serv_Engine_APU_Model_and_Serial_Number__c = En.Serv_Engine_APU_Model_and_Serial_Number__c; 
                        Entit.Serv_Data_Supplier__c = En.Serv_Data_Supplier__c;
                        Entit.Serv_Delivery_Type__c = En.Serv_Delivery_Type__c;
                        Entit.Serv_Format__c = En.Serv_Format__c;
                        Entit.Serv_Media_Type__c = En.Serv_Media_Type__c;
                        Entit.Serv_Nav_Database_Descr__c = En.Serv_Nav_Database_Descr__c;
                        Entit.Serv_NavDB_Ident__c = En.Serv_NavDB_Ident__c;
                        Entit.Serv_Price_Plan__c = En.Serv_Price_Plan__c ;
                        Entit.Serv_Prod_Descr__c = En.Serv_Prod_Descr__c;
                        Entit.Serv_Subscription_Type__c = En.Serv_Subscription_Type__c;
                        Entit.Data_Load_Date__c = En.Data_Load_Date__c;
                        Entit.Source_Created_Date__c = En.Source_Created_Date__c;
                        Entit.Source_Modified_Date__c = En.Source_Modified_Date__c; 
                        
                       // List<Integer> myList = new List<Integer>({"31","28",31,30,31,30,31,31,30,31,30,31});
                        date d1=startdate1.addMonths(i);
                        if(En.Entitlement_Start_Date__c.day()==31 && d1.month()!=2){
                        
                        Entit.Entitlement_Start_Date__c = date.newinstance( d1.year(), d1.month(), myList[d1.month()-1]);
                        }
                        else if(d1.month()==2 && (En.Entitlement_Start_Date__c.day()==31 || En.Entitlement_Start_Date__c.day()==30 || En.Entitlement_Start_Date__c.day()==29) ){
                        Entit.Entitlement_Start_Date__c = date.newinstance( d1.year(), d1.month(), myList[d1.month()-1]);
                        }
                        else{
                         Entit.Entitlement_Start_Date__c =date.newinstance( d1.year(), d1.month(),En.Entitlement_Start_Date__c.day());
                        }
                        
                        Entlst.add(Entit); 
                    }
                }
                
                if(datename!=null){
                  
                  Nom = ((datename.year()- datename1.year())*12)+(datename.Month()- datename1.Month())+1;
                    for(integer i=0;i<Nom;i++){
                      Entitlement__c Entit = new Entitlement__c ();
                     
                        Entit.Contract_Number__c=En.Contract_Number__c;
                        Entit.Entitlement_Name__c = En.Entitlement_Name__c; 
                        Entit.Status__c = En.Status__c;
                        Entit.Legacy_Entitlement_Number__c = En.Legacy_Entitlement_Number__c ;
                        Entit.Entitlement_Type__c = En.Entitlement_Type__c;
                        Entit.SBL_S_DOC_AGREE_ROW_ID__c = En.SBL_S_DOC_AGREE_ROW_ID__c;
                      //Entit.Entitlement_Start_Date__c = En.Entitlement_Start_Date__c;
                        Entit.Comments__c = En.Comments__c;
                        if(En.End_Date__c!=null){
                        
                       
                         date d2 = enddate1.addMonths(i);
                          if(En.End_Date__c.day()==31){
                          
                          
                          Entit.End_Date__c = date.newinstance( d2.year(), d2.month(), myList[d2.month()-1]);
                        }
                        else if(d2.month()==2 && (En.End_Date__c.day()==31 || En.End_Date__c.day()==30 || En.End_Date__c.day()==29) ){
                         Entit.End_Date__c = date.newinstance( d2.year(), d2.month(), myList[d2.month()-1]);
                        }
                        else{
                         Entit.End_Date__c =date.newinstance( d2.year(), d2.month(),En.End_Date__c.day());
                        }
                         }
                        //Entit.End_Date__c = enddate1.addMonths(i); 
                        Entit.Course__c = En.Course__c;
                        Entit.Reference__c = En.Reference__c ;
                        Entit.Product_Serial_Number__c = En.Product_Serial_Number__c;
                        Entit.Serv_HON_Product_Name__c = En.Serv_HON_Product_Name__c;
                        Entit.Fleet_Asset_Aircraft__c = En.Fleet_Asset_Aircraft__c ;
                        Entit.Serv_Aircraft_Serial_No__c = En.Serv_Aircraft_Serial_No__c;
                        Entit.Serv_Aircraft_Platform_and_Model__c = En.Serv_Aircraft_Platform_and_Model__c;
                        Entit.Platform__c = En.Platform__c;
                        Entit.Serv_Model_Number_and_Serial_Number__c = En.Serv_Model_Number_and_Serial_Number__c;
                        Entit.Serv_Engine_APU_Model_and_Serial_Number__c = En.Serv_Engine_APU_Model_and_Serial_Number__c; 
                        Entit.Serv_Data_Supplier__c = En.Serv_Data_Supplier__c;
                        Entit.Serv_Delivery_Type__c = En.Serv_Delivery_Type__c;
                        Entit.Serv_Format__c = En.Serv_Format__c;
                        Entit.Serv_Media_Type__c = En.Serv_Media_Type__c;
                        Entit.Serv_Nav_Database_Descr__c = En.Serv_Nav_Database_Descr__c;
                        Entit.Serv_NavDB_Ident__c = En.Serv_NavDB_Ident__c;
                        Entit.Serv_Price_Plan__c = En.Serv_Price_Plan__c ;
                        Entit.Serv_Prod_Descr__c = En.Serv_Prod_Descr__c;
                        Entit.Serv_Subscription_Type__c = En.Serv_Subscription_Type__c;
                        Entit.Data_Load_Date__c = En.Data_Load_Date__c;
                        Entit.Source_Created_Date__c = En.Source_Created_Date__c;
                        Entit.Source_Modified_Date__c = En.Source_Modified_Date__c; 
                        
                       // List<Integer> myList = new List<Integer>({"31","28",31,30,31,30,31,31,30,31,30,31});
                        date d1=startdate1.addMonths(i);
                        if(En.Entitlement_Start_Date__c.day()==31 && d1.month()!=2){
                        
                        Entit.Entitlement_Start_Date__c = date.newinstance( d1.year(), d1.month(), myList[d1.month()-1]);
                        }
                        else if(d1.month()==2 && (En.Entitlement_Start_Date__c.day()==31 || En.Entitlement_Start_Date__c.day()==30 || En.Entitlement_Start_Date__c.day()==29) ){
                        Entit.Entitlement_Start_Date__c = date.newinstance( d1.year(), d1.month(), myList[d1.month()-1]);
                        }
                        else{
                         Entit.Entitlement_Start_Date__c =date.newinstance( d1.year(), d1.month(),En.Entitlement_Start_Date__c.day());
                        }
                        
                        Entlst.add(Entit); 
                    }
                
                
                }
                
                
            }
        
            if(Recurencetype=='Quarterly'){
             
             integer j;
            
             if(((tm==1||tm==2||tm==3)&& (En.Entitlement_Start_Date__c.month()==1 ||En.Entitlement_Start_Date__c.month()==2 ||En.Entitlement_Start_Date__c.month()==3))||
                 ((tm==4||tm==5||tm==6)&& (En.Entitlement_Start_Date__c.month()==4||En.Entitlement_Start_Date__c.month()==5 ||En.Entitlement_Start_Date__c.month()==6))||
                 ((tm==7||tm==8||tm==9)&& (En.Entitlement_Start_Date__c.month()==7 ||En.Entitlement_Start_Date__c.month()==8 ||En.Entitlement_Start_Date__c.month()==9))||
                 ((tm==10||tm==11||tm==12)&& (En.Entitlement_Start_Date__c.month()==10 ||En.Entitlement_Start_Date__c.month()==11 ||En.Entitlement_Start_Date__c.month()==12)))
              j=0;
              
              
               if(((tm==4||tm==5||tm==6)&& (En.Entitlement_Start_Date__c.month()==1 ||En.Entitlement_Start_Date__c.month()==2 ||En.Entitlement_Start_Date__c.month()==3))||
                 ((tm==7||tm==8||tm==9)&& (En.Entitlement_Start_Date__c.month()==4||En.Entitlement_Start_Date__c.month()==5 ||En.Entitlement_Start_Date__c.month()==6))||
                 ((tm==10||tm==11||tm==12)&& (En.Entitlement_Start_Date__c.month()==7 ||En.Entitlement_Start_Date__c.month()==8 ||En.Entitlement_Start_Date__c.month()==9))||
                 ((tm==1||tm==2||tm==3)&& (En.Entitlement_Start_Date__c.month()==10 ||En.Entitlement_Start_Date__c.month()==11 ||En.Entitlement_Start_Date__c.month()==12)))
              j=3;
              
                if(((tm==7||tm==8||tm==9)&& (En.Entitlement_Start_Date__c.month()==1 ||En.Entitlement_Start_Date__c.month()==2 ||En.Entitlement_Start_Date__c.month()==3))||
                 ((tm==10||tm==11||tm==12)&& (En.Entitlement_Start_Date__c.month()==4||En.Entitlement_Start_Date__c.month()==5 ||En.Entitlement_Start_Date__c.month()==6))||
                 ((tm==1||tm==2||tm==3)&& (En.Entitlement_Start_Date__c.month()==7 ||En.Entitlement_Start_Date__c.month()==8 ||En.Entitlement_Start_Date__c.month()==9))||
                 ((tm==4||tm==5||tm==6)&& (En.Entitlement_Start_Date__c.month()==10 ||En.Entitlement_Start_Date__c.month()==11 ||En.Entitlement_Start_Date__c.month()==12)))
              j=6;
                if(((tm==10||tm==11||tm==12)&& (En.Entitlement_Start_Date__c.month()==1 ||En.Entitlement_Start_Date__c.month()==2 ||En.Entitlement_Start_Date__c.month()==3))||
                 ((tm==1||tm==2||tm==3)&& (En.Entitlement_Start_Date__c.month()==4||En.Entitlement_Start_Date__c.month()==5 ||En.Entitlement_Start_Date__c.month()==6))||
                 ((tm==4||tm==5||tm==6)&& (En.Entitlement_Start_Date__c.month()==7 ||En.Entitlement_Start_Date__c.month()==8 ||En.Entitlement_Start_Date__c.month()==9))||
                 ((tm==7||tm==8||tm==9)&& (En.Entitlement_Start_Date__c.month()==10 ||En.Entitlement_Start_Date__c.month()==11 ||En.Entitlement_Start_Date__c.month()==12)))
              j=9;
              
              if(En.End_Date__c==null || ( En.End_Date__c!=null &&
                  (
                  ((En.Entitlement_Start_Date__c.Month()==1||En.Entitlement_Start_Date__c.Month()==2||En.Entitlement_Start_Date__c.Month()==3) &&(En.End_Date__c.Month()==1|| En.End_Date__c.Month()==2||En.End_Date__c.Month()==3)) ||
                  ((En.Entitlement_Start_Date__c.Month()==4||En.Entitlement_Start_Date__c.Month()==5||En.Entitlement_Start_Date__c.Month()==6) &&(En.End_Date__c.Month()==4|| En.End_Date__c.Month()==5||En.End_Date__c.Month()==6)) ||
                  ((En.Entitlement_Start_Date__c.Month()==7||En.Entitlement_Start_Date__c.Month()==8||En.Entitlement_Start_Date__c.Month()==9) &&(En.End_Date__c.Month()==7|| En.End_Date__c.Month()==8||En.End_Date__c.Month()==9)) ||
                  ((En.Entitlement_Start_Date__c.Month()==10||En.Entitlement_Start_Date__c.Month()==11||En.Entitlement_Start_Date__c.Month()==12) &&(En.End_Date__c.Month()==10|| En.End_Date__c.Month()==11||En.End_Date__c.Month()==12))) && 
                  (En.Entitlement_Start_Date__c.Year()== En.End_Date__c.Year()))
                   
                   )
                  {
             
                    if(Noc!= null){
                
                  
                         for(integer i=1;i<=Noc;i++){
                          Entitlement__c Entit = new Entitlement__c ();
                            Entit.Contract_Number__c=En.Contract_Number__c;
                            Entit.Entitlement_Name__c = En.Entitlement_Name__c; 
                            Entit.Status__c = En.Status__c;
                            Entit.Legacy_Entitlement_Number__c = En.Legacy_Entitlement_Number__c ;
                            Entit.Entitlement_Type__c = En.Entitlement_Type__c;
                            Entit.SBL_S_DOC_AGREE_ROW_ID__c = En.SBL_S_DOC_AGREE_ROW_ID__c;
                          //Entit.Entitlement_Start_Date__c = En.Entitlement_Start_Date__c;
                          
                            Entit.Comments__c = En.Comments__c;
                            if(En.End_Date__c!=null){
                             
                             Date d6 = date.newinstance(ty, En.End_Date__c.month(), En.End_Date__c.day());
                             date d2 = d6.addMonths(j);
                             
                              if(En.End_Date__c.day()==31){
                              
                              
                              Entit.End_Date__c = date.newinstance( d2.year(), d2.month(), myList[d2.month()-1]);
                            }
                            else if(d2.month()==2 && (En.End_Date__c.day()==31 || En.End_Date__c.day()==30 || En.End_Date__c.day()==29) ){
                             Entit.End_Date__c = date.newinstance( d2.year(), d2.month(), myList[d2.month()-1]);
                            }
                            else{
                             Entit.End_Date__c =date.newinstance( d2.year(), d2.month(),En.End_Date__c.day());
                            }
                           }
                           
                            Entit.Course__c = En.Course__c;
                            Entit.Reference__c = En.Reference__c ;
                            Entit.Product_Serial_Number__c = En.Product_Serial_Number__c;
                            Entit.Serv_HON_Product_Name__c = En.Serv_HON_Product_Name__c;
                            Entit.Fleet_Asset_Aircraft__c = En.Fleet_Asset_Aircraft__c ;
                            Entit.Serv_Aircraft_Serial_No__c = En.Serv_Aircraft_Serial_No__c;
                            Entit.Serv_Aircraft_Platform_and_Model__c = En.Serv_Aircraft_Platform_and_Model__c;
                            Entit.Platform__c = En.Platform__c;
                            Entit.Serv_Model_Number_and_Serial_Number__c = En.Serv_Model_Number_and_Serial_Number__c;
                            Entit.Serv_Engine_APU_Model_and_Serial_Number__c = En.Serv_Engine_APU_Model_and_Serial_Number__c; 
                            Entit.Serv_Data_Supplier__c = En.Serv_Data_Supplier__c;
                            Entit.Serv_Delivery_Type__c = En.Serv_Delivery_Type__c;
                            Entit.Serv_Format__c = En.Serv_Format__c;
                            Entit.Serv_Media_Type__c = En.Serv_Media_Type__c;
                            Entit.Serv_Nav_Database_Descr__c = En.Serv_Nav_Database_Descr__c;
                            Entit.Serv_NavDB_Ident__c = En.Serv_NavDB_Ident__c;
                            Entit.Serv_Price_Plan__c = En.Serv_Price_Plan__c ;
                            Entit.Serv_Prod_Descr__c = En.Serv_Prod_Descr__c;
                            Entit.Serv_Subscription_Type__c = En.Serv_Subscription_Type__c;
                            Entit.Data_Load_Date__c = En.Data_Load_Date__c;
                            Entit.Source_Created_Date__c = En.Source_Created_Date__c;
                            Entit.Source_Modified_Date__c = En.Source_Modified_Date__c; 
                           
                            
                            
                              Date d5 = date.newinstance(ty, En.Entitlement_Start_Date__c.month(), En.Entitlement_Start_Date__c.day());
                              date d1= d5.addMonths(j);

                           if(En.Entitlement_Start_Date__c.day()==31 && d1.month()!=2){
                            
                            Entit.Entitlement_Start_Date__c = date.newinstance( d1.year(), d1.month(), myList[d1.month()-1]);
                            }
                            else if(d1.month()==2 && (En.Entitlement_Start_Date__c.day()==31 || En.Entitlement_Start_Date__c.day()==30 || En.Entitlement_Start_Date__c.day()==29) ){
                            Entit.Entitlement_Start_Date__c = date.newinstance( d1.year(), d1.month(), myList[d1.month()-1]);
                            }
                            else{
                             Entit.Entitlement_Start_Date__c =date.newinstance( d1.year(), d1.month(),En.Entitlement_Start_Date__c.day());
                            }
                            Entlst.add(Entit); 
                            j=j+3;
                        }
                    
                    
                    
                    
                    }
                    
                if(datename!=null){
                
                    tm1 = datename.Month();
                    if(tm==1||tm==2||tm==3)
                    Noq=1;
                    if(tm==4||tm==5||tm==6)
                     Noq=2;
                    if(tm==7||tm==8||tm==9)
                     Noq=3;
                    if(tm==10||tm==11||tm==12)
                     Noq=4;
                     
                     if(tm1==1||tm1==2||tm1==3)
                    Noq1=1;
                    if(tm1==4||tm1==5||tm1==6)
                     Noq1=2;
                    if(tm1==7||tm1==8||tm1==9)
                     Noq1=3;
                    if(tm1==10||tm1==11||tm1==12)
                     Noq1=4;
                     Noq2= (((datename.year()- datename1.year())*4)+(Noq1-Noq))+1;
                   
                   for(integer i=1;i<=Noq2;i++){
                      Entitlement__c Entit = new Entitlement__c ();
                        Entit.Contract_Number__c=En.Contract_Number__c;
                        Entit.Entitlement_Name__c = En.Entitlement_Name__c; 
                        Entit.Status__c = En.Status__c;
                        Entit.Legacy_Entitlement_Number__c = En.Legacy_Entitlement_Number__c ;
                        Entit.Entitlement_Type__c = En.Entitlement_Type__c;
                        Entit.SBL_S_DOC_AGREE_ROW_ID__c = En.SBL_S_DOC_AGREE_ROW_ID__c;
                      //Entit.Entitlement_Start_Date__c = En.Entitlement_Start_Date__c;
                      
                        Entit.Comments__c = En.Comments__c;
                        if(En.End_Date__c!=null){
                        
                        Date d6 = date.newinstance(ty, En.End_Date__c.month(), En.End_Date__c.day());
                         date d2 = d6.addMonths(j);
                          if(En.End_Date__c.day()==31){
                          
                          
                          Entit.End_Date__c = date.newinstance( d2.year(), d2.month(), myList[d2.month()-1]);
                        }
                        else if(d2.month()==2 && (En.End_Date__c.day()==31 || En.End_Date__c.day()==30 || En.End_Date__c.day()==29) ){
                         Entit.End_Date__c = date.newinstance( d2.year(), d2.month(), myList[d2.month()-1]);
                        }
                        else{
                         Entit.End_Date__c =date.newinstance( d2.year(), d2.month(),En.End_Date__c.day());
                        }
                       }
                       
                        Entit.Course__c = En.Course__c;
                        Entit.Reference__c = En.Reference__c ;
                        Entit.Product_Serial_Number__c = En.Product_Serial_Number__c;
                        Entit.Serv_HON_Product_Name__c = En.Serv_HON_Product_Name__c;
                        Entit.Fleet_Asset_Aircraft__c = En.Fleet_Asset_Aircraft__c ;
                        Entit.Serv_Aircraft_Serial_No__c = En.Serv_Aircraft_Serial_No__c;
                        Entit.Serv_Aircraft_Platform_and_Model__c = En.Serv_Aircraft_Platform_and_Model__c;
                        Entit.Platform__c = En.Platform__c;
                        Entit.Serv_Model_Number_and_Serial_Number__c = En.Serv_Model_Number_and_Serial_Number__c;
                        Entit.Serv_Engine_APU_Model_and_Serial_Number__c = En.Serv_Engine_APU_Model_and_Serial_Number__c; 
                        Entit.Serv_Data_Supplier__c = En.Serv_Data_Supplier__c;
                        Entit.Serv_Delivery_Type__c = En.Serv_Delivery_Type__c;
                        Entit.Serv_Format__c = En.Serv_Format__c;
                        Entit.Serv_Media_Type__c = En.Serv_Media_Type__c;
                        Entit.Serv_Nav_Database_Descr__c = En.Serv_Nav_Database_Descr__c;
                        Entit.Serv_NavDB_Ident__c = En.Serv_NavDB_Ident__c;
                        Entit.Serv_Price_Plan__c = En.Serv_Price_Plan__c ;
                        Entit.Serv_Prod_Descr__c = En.Serv_Prod_Descr__c;
                        Entit.Serv_Subscription_Type__c = En.Serv_Subscription_Type__c;
                        Entit.Data_Load_Date__c = En.Data_Load_Date__c;
                        Entit.Source_Created_Date__c = En.Source_Created_Date__c;
                        Entit.Source_Modified_Date__c = En.Source_Modified_Date__c; 
                        Date d5 = date.newinstance(ty, En.Entitlement_Start_Date__c.month(), En.Entitlement_Start_Date__c.day());
                        date d1= d5.addMonths(j);
                        if(En.Entitlement_Start_Date__c.day()==31 && d1.month()!=2){
                        
                        Entit.Entitlement_Start_Date__c = date.newinstance( d1.year(), d1.month(), myList[d1.month()-1]);
                        }
                        else if(d1.month()==2 && (En.Entitlement_Start_Date__c.day()==31 || En.Entitlement_Start_Date__c.day()==30 || En.Entitlement_Start_Date__c.day()==29) ){
                        Entit.Entitlement_Start_Date__c = date.newinstance( d1.year(), d1.month(), myList[d1.month()-1]);
                        }
                        else{
                         Entit.Entitlement_Start_Date__c =date.newinstance( d1.year(), d1.month(),En.Entitlement_Start_Date__c.day());
                        }
                        Entlst.add(Entit); 
                        j=j+3;
                    }
                 
                  }
                }
                else{
                       ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'You cannot schedule Quarterly for this entitlement.')); 
                       return null;
                       
                    }
                
                
                
            }
        
        if(Entlst.size()>0)
        insert Entlst;
        PageReference pageRef = new PageReference('/'+contrid);
        return pageRef ;
    }
   
    public void edit(){
        Ent= New Entitlement__c();
        
        Ent.Contract_Number__c=En.Contract_Number__c;
        Ent.Entitlement_Name__c = En.Entitlement_Name__c; 
        Ent.Status__c = En.Status__c;
        Ent.Legacy_Entitlement_Number__c = En.Legacy_Entitlement_Number__c ;
        Ent.Entitlement_Type__c = En.Entitlement_Type__c;
        Ent.SBL_S_DOC_AGREE_ROW_ID__c = En.SBL_S_DOC_AGREE_ROW_ID__c;
        Ent.Entitlement_Start_Date__c = En.Entitlement_Start_Date__c;
        Ent.Comments__c = En.Comments__c;
        Ent.End_Date__c = En.End_Date__c ;
        Ent.Course__c = En.Course__c;
        Ent.Reference__c = En.Reference__c ;
        Ent.Product_Serial_Number__c = En.Product_Serial_Number__c;
        Ent.Serv_HON_Product_Name__c = En.Serv_HON_Product_Name__c;
        Ent.Fleet_Asset_Aircraft__c = En.Fleet_Asset_Aircraft__c ;
        Ent.Serv_Aircraft_Serial_No__c = En.Serv_Aircraft_Serial_No__c;
        Ent.Serv_Aircraft_Platform_and_Model__c = En.Serv_Aircraft_Platform_and_Model__c;
        Ent.Platform__c = En.Platform__c;
        Ent.Serv_Model_Number_and_Serial_Number__c = En.Serv_Model_Number_and_Serial_Number__c;
        Ent.Serv_Engine_APU_Model_and_Serial_Number__c = En.Serv_Engine_APU_Model_and_Serial_Number__c; 
        Ent.Serv_Data_Supplier__c = En.Serv_Data_Supplier__c;
        Ent.Serv_Delivery_Type__c = En.Serv_Delivery_Type__c;
        Ent.Serv_Format__c = En.Serv_Format__c;
        Ent.Serv_Media_Type__c = En.Serv_Media_Type__c;
        Ent.Serv_Nav_Database_Descr__c = En.Serv_Nav_Database_Descr__c;
        Ent.Serv_NavDB_Ident__c = En.Serv_NavDB_Ident__c;
        Ent.Serv_Price_Plan__c = En.Serv_Price_Plan__c ;
        Ent.Serv_Prod_Descr__c = En.Serv_Prod_Descr__c;
        Ent.Serv_Subscription_Type__c = En.Serv_Subscription_Type__c;
        Ent.Data_Load_Date__c = En.Data_Load_Date__c;
        Ent.Source_Created_Date__c = En.Source_Created_Date__c;
        Ent.Source_Modified_Date__c = En.Source_Modified_Date__c; 
   
    }
    public pagereference cancel(){
    
    PageReference pageRef = new PageReference('/'+entid);
      return pageRef ;
    }
    
 }