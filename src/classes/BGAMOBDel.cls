public without sharing class BGAMOBDel {
       public String Country{get;set;}
       public String State{get;set;}
        
        //public Account_Address__c acc{get;set;}
       public list<Account_Address__c> objAccounts {get;set;}
       
       public BGAMOBDel(){
        try{
            objAccounts = new list<Account_Address__c>();  
            objAccounts.addAll([Select Id,BGAMob_Website__c,Mechanical_Sub_Category__c ,Report_Account_name__c,Report_Account_Name_small__c,BGAMob_Geo_Code__Latitude__s, BGAMob_Geo_Code__Longitude__s,BGAMob_Contact_Name__c,Avionics_Support_Level__c,Engine_Authorization__c,BGAMob_Contact_Email__c,Mechanical_Product_Lines__c,BGAMob_Customer_Phone__c,BGAMob_Address_1__c,BGAMob_Address_2__c,BGAMob_Address_3__c,BGAMob_City_Name__c,BGAMob_State_Province__c,BGAMob_Postal_Code__c,BGAMob_Country_Nm__c, Authorized_Avionics_Dealer__c,Authorized_Mechanical_Service_Center__c,Mobile_App_Visibility__c from Account_Address__c where  Mobile_App_Visibility__c=true and BGAMob_Geo_Code__Latitude__s != null ] );
        System.debug('New Testing'+objAccounts);
        }catch(Exception ex){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error:'
                                                        +ex.getMessage()));
        }
    }
   
    //honeywell support
    @RemoteAction
    Static public contact getAccounteam(String strId1)
    {
       system.debug('test 111--->');
       AccountTeamMember Arec1 = [SELECT UserId,user.email FROM AccountTeamMember WHERE AccountId =:strId1 AND TeamMemberRole = 'Customer Service Manager' limit 1];
       system.debug('test 22--->'+Arec1.user.email);
       string useremail=Arec1.user.email;
       
        contact c1=[select id,name,BGAMob_Contact_Alt_Name__c,Mobile_App_Role__c,Phone_5__c,Email from contact where email =: useremail];
        return c1;
         
    }  
    
    public boolean MSGflag{get;set;}
        
    public BGAMOBDel(ApexPages.StandardController controller) {
              // acc= New Account_Address__c();
              lSelectedacc = new list<Account_Address__c>(); 
                 objAccounts = new list<Account_Address__c>();  
                objAccounts.addAll([Select Id,BGAMob_Website__c,Mechanical_Sub_Category__c ,Report_Account_name__c,Report_Account_Name_small__c,BGAMob_Geo_Code__Latitude__s, BGAMob_Geo_Code__Longitude__s,BGAMob_Contact_Name__c,Avionics_Support_Level__c,Engine_Authorization__c,BGAMob_Contact_Email__c,Mechanical_Product_Lines__c,BGAMob_Customer_Phone__c,BGAMob_Address_1__c,BGAMob_Address_2__c,BGAMob_Address_3__c,BGAMob_City_Name__c,BGAMob_State_Province__c,BGAMob_Postal_Code__c,BGAMob_Country_Nm__c, Authorized_Avionics_Dealer__c,Authorized_Mechanical_Service_Center__c,Mobile_App_Visibility__c from Account_Address__c where  Mobile_App_Visibility__c=true and BGAMob_Geo_Code__Latitude__s != null ] );
                   
              
            }

            List<Account_Address__c> lacc= New List<Account_Address__c>();
            public List<Account_Address__c> lSelectedacc{get;set;}
          
         
            public List<SelectOption> getCountries() {
        
                    List<AggregateResult> lAccouts=New List<AggregateResult>();
                    List<String> lfinalAccouts=New List<String>();
                    set<String> sAccouts=New set<String>();
                    List<SelectOption> AccCountries= new List<SelectOption>();
               lAccouts=[Select BGAMob_Country_Nm__c from Account_Address__c where BGAMob_Country_Nm__c != null group by BGAMob_Country_Nm__c order by BGAMob_Country_Nm__c ];
                   
                    //Removing duplicates
                    for(AggregateResult A: lAccouts){
                    
                        sAccouts.add(String.valueof(A.get('BGAMob_Country_Nm__c')));
                    }
                    lfinalAccouts.addall(sAccouts);
                    AccCountries.add(New SelectOption('--None--','--None--'));
                    
                    for(String A: lfinalAccouts){
                    
                    if(A != 'United States' && A != 'USA' && A != 'United States of America' && A!='Canada')
                    {
                     AccCountries.add(new SelectOption(A,A));
                     }
                   
                       
                    }
                   AccCountries.sort();
                  
                   AccCountries.add(1,New SelectOption('United States','USA'));
                   AccCountries.add(2,New SelectOption('Canada','CANADA'));
                   
                return AccCountries;
            } 
    
 
        @RemoteAction 
       public  static List<string> getState1(string country) {
       
             system.debug('<<<<Country----------------------------- >>>>>'+Country );
            
            List<Account_Address__c> lAccouts=New List<Account_Address__c>();
            List<String> lfinalAccouts=New List<String>();
            set<String> sAccouts=New set<String>();
            //AccStatevlues= new List<SelectOption>();
          //  system.debug('<<<<Country----------------------------- >>>>>'+Country );
            lAccouts=[Select BGAMob_State_Province__c from Account_Address__c where BGAMob_Country_Nm__c=:Country ];
            
           // system.debug('<<<<Statevalues>>>>>'+lAccouts);
            //Removing duplicates
            for(Account_Address__c A: lAccouts){
            
                sAccouts.add(String.valueof(A.BGAMob_State_Province__c ));
            }
           
            lfinalAccouts.addall(sAccouts);
           // AccStatevlues.add(New SelectOption('--None--','--None--'));
           // system.debug('<<<<Statevalues>>>>>'+lfinalAccouts);  
            /*for(String A: lfinalAccouts){
                
                
                 AccStatevlues.add(new SelectOption(A,A));
                
               
            }*/
        lfinalAccouts.sort();
            return lfinalAccouts;
        }
  
   @RemoteAction 
       public  static List<string> getCountriesFromAccounts() {
       
                        
            List<Account_Address__c> lAccounts=New List<Account_Address__c>();
            List<String> lfinalAccounts=New List<String>();
            set<String> sAccounts=New set<String>();
            
            lAccounts=[Select BGAMob_Country_Nm__c from Account_Address__c where Mobile_App_Visibility__c=true ];
            
            //Removing duplicates
            for(Account_Address__c A: lAccounts){
            if (String.valueof(A.BGAMob_Country_Nm__c) != 'United States' && String.valueof(A.BGAMob_Country_Nm__c) != 'USA' && String.valueof(A.BGAMob_Country_Nm__c) != 'Canada')
                sAccounts.add(String.valueof(A.BGAMob_Country_Nm__c));
            }
           
            lfinalAccounts.addall(sAccounts);
         
        lfinalAccounts.sort();
            return lfinalAccounts;
        }
  
   @RemoteAction
   Static public List<List<Account_Address__c>> getResultValue(String Country,String State)
   {
      //List<List<Skills2__c>>  lSelectedSkillsnew = new List<List<Skills2__c>>();
      List<List<Account_Address__c>> lAccRec = new List<List<Account_Address__c>>();
    
      List<Account_Address__c> lisAvionics = new List<Account_Address__c>();
      
      List<Account_Address__c> lisMechanical = new List<Account_Address__c>();
      List<Account_Address__c> lisAll = new List<Account_Address__c>();
     system.debug('<<<<Statevalues---------->>>>>'+State);
     if(State != '--None--')
   
   {
    lisAll=[Select Id,Report_Account_name__c,Report_Account_Name_small__c,Engine_Authorization__c,Mobile_Satellite_Teams__c,Avionics_Support_Level__c,BGAMob_Contact_Name__c,BGAMob_Contact_Email__c,Mechanical_Product_Lines__c,BGAMob_Customer_Phone__c,BGAMob_State_Province__c, Authorized_Avionics_Dealer__c,Authorized_Mechanical_Service_Center__c,BGAMob_Country_Nm__c,Mobile_App_Visibility__c from Account_Address__c 
                where BGAMob_Country_Nm__c=:Country and BGAMob_State_Province__c=:State AND Mobile_App_Visibility__c=true order by Report_Account_Name_small__c]; 
                    system.debug('-if--del----'+lisAll);
    lisAvionics =[Select Id,Report_Account_name__c,Report_Account_Name_small__c,Avionics_Support_Level__c,Mobile_Satellite_Teams__c,BGAMob_Contact_Name__c,BGAMob_Contact_Email__c,Mechanical_Product_Lines__c,BGAMob_Customer_Phone__c,BGAMob_State_Province__c, Authorized_Avionics_Dealer__c,Authorized_Mechanical_Service_Center__c,BGAMob_Country_Nm__c,Mobile_App_Visibility__c from Account_Address__c 
                where BGAMob_Country_Nm__c =:Country and BGAMob_State_Province__c =:State AND Mobile_App_Visibility__c=true AND Authorized_Avionics_Dealer__c=true order by Report_Account_Name_small__c];
    lisMechanical=[Select Id,Report_Account_name__c,Report_Account_Name_small__c,Engine_Authorization__c,Mobile_Satellite_Teams__c,Avionics_Support_Level__c,BGAMob_Contact_Name__c,BGAMob_Contact_Email__c,Mechanical_Product_Lines__c,BGAMob_Customer_Phone__c,BGAMob_State_Province__c, Authorized_Avionics_Dealer__c,Authorized_Mechanical_Service_Center__c,BGAMob_Country_Nm__c,Mobile_App_Visibility__c from Account_Address__c 
                where BGAMob_Country_Nm__c =:Country and BGAMob_State_Province__c =:State AND Mobile_App_Visibility__c=true AND Authorized_Mechanical_Service_Center__c=true order by Report_Account_Name_small__c];
          }
       else
       {
         lisAll=[Select Id,Report_Account_name__c,Report_Account_Name_small__c,BGAMob_Contact_Name__c,Mobile_Satellite_Teams__c,Avionics_Support_Level__c,Engine_Authorization__c,BGAMob_Contact_Email__c,Mechanical_Product_Lines__c,BGAMob_Customer_Phone__c,BGAMob_State_Province__c, Authorized_Avionics_Dealer__c,Authorized_Mechanical_Service_Center__c,BGAMob_Country_Nm__c,Mobile_App_Visibility__c from Account_Address__c 
                where BGAMob_Country_Nm__c =:Country AND Mobile_App_Visibility__c=true order by Report_Account_Name_small__c];
        lisAvionics =[Select Id,Report_Account_name__c,Report_Account_Name_small__c,Avionics_Support_Level__c,Mobile_Satellite_Teams__c,BGAMob_Contact_Name__c,BGAMob_Contact_Email__c,Mechanical_Product_Lines__c,BGAMob_Customer_Phone__c,BGAMob_State_Province__c, Authorized_Avionics_Dealer__c,Authorized_Mechanical_Service_Center__c,BGAMob_Country_Nm__c,Mobile_App_Visibility__c from Account_Address__c 
                where BGAMob_Country_Nm__c =:Country AND Mobile_App_Visibility__c=true AND Authorized_Avionics_Dealer__c=true order by Report_Account_Name_small__c];
        lisMechanical=[Select Id,Report_Account_name__c,Report_Account_Name_small__c,Engine_Authorization__c,Mobile_Satellite_Teams__c,Avionics_Support_Level__c,BGAMob_Contact_Name__c,BGAMob_Contact_Email__c,Mechanical_Product_Lines__c,BGAMob_Customer_Phone__c,BGAMob_State_Province__c, Authorized_Avionics_Dealer__c,BGAMob_Country_Nm__c,Authorized_Mechanical_Service_Center__c,Mobile_App_Visibility__c from Account_Address__c 
                where BGAMob_Country_Nm__c =:Country AND Mobile_App_Visibility__c=true AND Authorized_Mechanical_Service_Center__c=true order by Report_Account_Name_small__c];
            system.debug('-del---else--'+lisAvionics );
       }
       
        lAccRec.add(lisAvionics);
        lAccRec.add(lisMechanical);
        lAccRec.add(lisAll);  
          return lAccRec;
        }
        
        public class AccAddresswithBool 
        {    
            public Account_Address__c accAdd;
            public boolean hwsupp;
            
        }
          
          @RemoteAction         
           Static public AccAddresswithBool getContact(String strId)
           {
               boolean hwsupp1= false;
               Account_Address__c Arec1 = [select id,Account_Name__c,Report_Account_name__c,Report_Account_Name_small__c,Avionics_Support_Level__c,Engine_Authorization__c,BGAMob_Contact_Name__c,BGAMob_Contact_Email__c,BGAMob_Address_1__c,BGAMob_Address_2__c,BGAMob_Address_3__c,BGAMob_City_Name__c,BGAMob_State_Province__c,BGAMob_Country_Nm__c,BGAMob_Postal_Code__c,BGAMob_Website__c ,Authorized_Avionics_Dealer__c,Authorized_Mechanical_Service_Center__c,Mechanical_Product_Lines__c,BGAMob_Customer_Phone__c from Account_Address__c where id=:strId];
               
               try
               {
               AccountTeamMember Arec2 = [SELECT UserId,user.email FROM AccountTeamMember WHERE AccountId =:Arec1.Account_Name__c AND TeamMemberRole = 'Customer Service Manager' limit 1];
               contact c1;
               if(Arec2.user.email != null)
               {
                   system.debug('test 22--->'+Arec2.user.email);
                   string useremail=Arec2.user.email;   
                   try
                   {        
                       c1=[select id,name,BGAMob_Contact_Alt_Name__c,Mobile_App_Role__c,Phone_5__c,Email from contact where email =: useremail];
                       if(c1.name != null)
                       {
                       hwsupp1=true;
                       }
                   }
                   catch(Exception e){}
                  
               }
               }
               catch(Exception e){}               
               Account_Address__c Arec = [select id,Account_Name__c,Report_Account_name__c,Report_Account_Name_small__c,Avionics_Support_Level__c,Engine_Authorization__c,Mobile_Satellite_Teams__c,BGAMob_Contact_Name__c,BGAMob_Contact_Email__c,BGAMob_Address_1__c,BGAMob_Address_2__c,BGAMob_Address_3__c,BGAMob_City_Name__c,BGAMob_State_Province__c,BGAMob_Country_Nm__c,BGAMob_Postal_Code__c,BGAMob_Website__c ,Authorized_Avionics_Dealer__c,Authorized_Mechanical_Service_Center__c,Mechanical_Product_Lines__c,BGAMob_Customer_Phone__c from Account_Address__c where id=:strId];            
               system.debug('venkat 1'+Arec);
               AccAddresswithBool acchwsuppbutt= new AccAddresswithBool ();         
               acchwsuppbutt.accAdd  =  Arec;
               system.debug('venkat 2'+acchwsuppbutt.accAdd);                             
               acchwsuppbutt.hwsupp =hwsupp1;
               return acchwsuppbutt;
               
           }  
           
              
           
            @RemoteAction
           Static public List<List<Account_Address__c>> getContactCloseTo(Decimal lat,Decimal lng)
           {
           
           List<List<Account_Address__c>> lAccRec = new List<List<Account_Address__c>>();
    
      List<Account_Address__c> lisAvionics = new List<Account_Address__c>();
      
      List<Account_Address__c> lisMechanical = new List<Account_Address__c>();
      List<Account_Address__c> lisAll = new List<Account_Address__c>();
      String q = 'Select Id,Report_Account_name__c,Report_Account_Name_small__c,Engine_Authorization__c,Avionics_Support_Level__c,BGAMob_Contact_Name__c,BGAMob_Contact_Email__c,';
      q+= 'Mechanical_Product_Lines__c,BGAMob_Customer_Phone__c,BGAMob_State_Province__c,BGAMob_Geo_Code__Latitude__s, BGAMob_Geo_Code__Longitude__s, Authorized_Avionics_Dealer__c,Authorized_Mechanical_Service_Center__c,BGAMob_Country_Nm__c,Mobile_App_Visibility__c ';
      q += ' from Account_Address__c';
      q+= ' where Mobile_App_Visibility__c=true and  BGAMob_Geo_Code__Latitude__s != null and BGAMob_Geo_Code__Longitude__s != null ';
      q += ' order by DISTANCE(BGAMob_Geo_Code__c, GEOLOCATION(';
      q += String.valueOf(lat) + ',' + String.valueOf(lng) + '), \'mi\') ';
      System.debug('q value--->'+q);
     system.debug('venkat lant---->'+lat);
     system.debug('venkat lang---->'+lng);
      lisAll = Database.query(q);
      //System.debug('lisAll 1 value--->'+lisAll[0].BGAMob_Geo_Code__Latitude__s);
       //System.debug('lisAll 2 value--->'+lisAll[1].BGAMob_Geo_Code__Latitude__s);
      String avin = 'Select Id,Report_Account_name__c,Report_Account_Name_small__c,Engine_Authorization__c,BGAMob_Geo_Code__Latitude__s, BGAMob_Geo_Code__Longitude__s,Avionics_Support_Level__c,BGAMob_Contact_Name__c,BGAMob_Contact_Email__c,';
      avin+= 'Mechanical_Product_Lines__c,BGAMob_Customer_Phone__c,BGAMob_State_Province__c, Authorized_Avionics_Dealer__c,Authorized_Mechanical_Service_Center__c,BGAMob_Country_Nm__c,Mobile_App_Visibility__c from Account_Address__c ';
      avin+= 'where Mobile_App_Visibility__c=true and  BGAMob_Geo_Code__Latitude__s != null and BGAMob_Geo_Code__Longitude__s != null AND Authorized_Avionics_Dealer__c=true  ';
      avin += ' order by DISTANCE(BGAMob_Geo_Code__c, GEOLOCATION(';
      avin += String.valueOf(lat) + ',' + String.valueOf(lng) + '), \'mi\') limit 50';
     //System.debug('avin value--->'+avin);
    lisAvionics =Database.query(avin);
       String mech = 'Select Id,Report_Account_name__c,Report_Account_Name_small__c,Engine_Authorization__c,Avionics_Support_Level__c,BGAMob_Contact_Name__c,BGAMob_Contact_Email__c,BGAMob_Geo_Code__Latitude__s, BGAMob_Geo_Code__Longitude__s,';
      mech += 'Mechanical_Product_Lines__c,Mechanical_Sub_Category__c ,BGAMob_Customer_Phone__c,BGAMob_State_Province__c, Authorized_Avionics_Dealer__c,Authorized_Mechanical_Service_Center__c,BGAMob_Country_Nm__c,Mobile_App_Visibility__c from Account_Address__c ';
      mech += 'where Mobile_App_Visibility__c=true and  BGAMob_Geo_Code__Latitude__s != null and BGAMob_Geo_Code__Longitude__s != null AND Authorized_Mechanical_Service_Center__c=true  ';
      mech += ' order by DISTANCE(BGAMob_Geo_Code__c, GEOLOCATION(';
      mech += String.valueOf(lat) + ',' + String.valueOf(lng) + '), \'mi\') limit 50';
       //System.debug('mech  value--->'+mech);
    lisMechanical=Database.query(mech);
            lAccRec.add(lisAvionics);
        lAccRec.add(lisMechanical);
        lAccRec.add(lisAll);  
           return lAccRec;
           }  
           
            @RemoteAction
           Static public List<List<Account_Address__c>> getContactAll()
           {
           
           List<List<Account_Address__c>> lAccRec = new List<List<Account_Address__c>>();
    
      List<Account_Address__c> lisAvionics = new List<Account_Address__c>();
      
      List<Account_Address__c> lisMechanical = new List<Account_Address__c>();
      List<Account_Address__c> lisAll = new List<Account_Address__c>();
      String q = 'Select Id,Report_Account_name__c,Report_Account_Name_small__c,Engine_Authorization__c,Avionics_Support_Level__c,BGAMob_Contact_Name__c,BGAMob_Contact_Email__c,';
      q+= 'Mechanical_Product_Lines__c,BGAMob_Customer_Phone__c,BGAMob_State_Province__c, Authorized_Avionics_Dealer__c,Authorized_Mechanical_Service_Center__c,BGAMob_Country_Nm__c,Mobile_App_Visibility__c from Account_Address__c ';
      q+= 'where Mobile_App_Visibility__c=true ';
      q += ' order by BGAMob_Country_Nm__c,BGAMob_State_Province__c';
      //System.debug('q value--->'+q);
      lisAll = Database.query(q);
          String avin = 'Select Id,Report_Account_name__c,Report_Account_Name_small__c,Engine_Authorization__c,Avionics_Support_Level__c,BGAMob_Contact_Name__c,BGAMob_Contact_Email__c,';
      avin+= 'Mechanical_Product_Lines__c,BGAMob_Customer_Phone__c,BGAMob_State_Province__c, Authorized_Avionics_Dealer__c,Authorized_Mechanical_Service_Center__c,BGAMob_Country_Nm__c,Mobile_App_Visibility__c from Account_Address__c ';
      avin+= 'where Mobile_App_Visibility__c=true AND Authorized_Avionics_Dealer__c=true ';
      avin+= ' order by BGAMob_Country_Nm__c,BGAMob_State_Province__c'; 
     //System.debug('avin value--->'+avin);
    lisAvionics =Database.query(avin);
       String mech = 'Select Id,Report_Account_name__c,Report_Account_Name_small__c,Engine_Authorization__c,Avionics_Support_Level__c,BGAMob_Contact_Name__c,BGAMob_Contact_Email__c,';
      mech += 'Mechanical_Product_Lines__c,Mechanical_Sub_Category__c ,BGAMob_Customer_Phone__c,BGAMob_State_Province__c, Authorized_Avionics_Dealer__c,Authorized_Mechanical_Service_Center__c,BGAMob_Country_Nm__c,Mobile_App_Visibility__c from Account_Address__c ';
      mech += 'where Mobile_App_Visibility__c=true AND Authorized_Mechanical_Service_Center__c=true ';
      mech += ' order by BGAMob_Country_Nm__c,BGAMob_State_Province__c'; 
      // System.debug('mech  value--->'+mech);
    lisMechanical=Database.query(mech);
            lAccRec.add(lisAvionics);
        lAccRec.add(lisMechanical);
        lAccRec.add(lisAll);  
           return lAccRec;
           }
        
         @RemoteAction 
       public  static List<String> getProduct() 
       {
       List<String> lfinalprod=New List<String>();
       
        Map<String, BGAMobile_MechanicalAuthorizations__c> mechprod= BGAMobile_MechanicalAuthorizations__c.getAll();
        
        // Sort them by name
         for(BGAMobile_MechanicalAuthorizations__c mechsett: mechprod.values()) {
           
                lfinalprod.add(mechsett.Product_Line__c);
            
        }
        
        lfinalprod.sort();
      // lfinalprod = [SELECT Mechanical_Product_Lines__c FROM Account_Address__c where Mobile_App_Visibility__c = true and Mechanical_Product_Lines__c  != null group by Mechanical_Product_Lines__c order by Mechanical_Product_Lines__c  ];
     //System.debug(lfinalprod);
      return lfinalprod;
      
      
       }
       
         @RemoteAction
           Static public List<List<Account_Address__c>> getContactByProduct(String strProd)
           {
           
           String str = null;
           
           
       //    strProd = strProd.replace('amp;','');
           List<List<Account_Address__c>> lAccRec = new List<List<Account_Address__c>>();
    
      List<Account_Address__c> lisAvionics = new List<Account_Address__c>();
      
      List<Account_Address__c> lisMechanical = new List<Account_Address__c>();
      List<Account_Address__c> lisAll = new List<Account_Address__c>();
      String q = 'Select Id,Report_Account_name__c,Report_Account_Name_small__c,Engine_Authorization__c,Avionics_Support_Level__c,BGAMob_Contact_Name__c,BGAMob_Contact_Email__c,';
      q+= 'Mechanical_Product_Lines__c,BGAMob_Customer_Phone__c,BGAMob_State_Province__c, Authorized_Avionics_Dealer__c,Authorized_Mechanical_Service_Center__c,BGAMob_Country_Nm__c,Mobile_App_Visibility__c from Account_Address__c ';
      q+= 'where Mobile_App_Visibility__c=true ';
      
               strProd = '%'+ strProd +'%';
                q+= ' and Mechanical_Product_Lines__c like: strProd'; 
              
  q+= ' and Mechanical_Product_Lines__c like: strProd'; 
      q += ' order by BGAMob_Country_Nm__c,BGAMob_State_Province__c';
      //System.debug('q value--->'+q);
      lisAll = Database.query(q);
          String avin = 'Select Id,Report_Account_name__c,Report_Account_Name_small__c,Engine_Authorization__c,Avionics_Support_Level__c,BGAMob_Contact_Name__c,BGAMob_Contact_Email__c,';
      avin+= 'Mechanical_Product_Lines__c,BGAMob_Customer_Phone__c,BGAMob_State_Province__c, Authorized_Avionics_Dealer__c,Authorized_Mechanical_Service_Center__c,BGAMob_Country_Nm__c,Mobile_App_Visibility__c from Account_Address__c ';
      avin+= 'where Mobile_App_Visibility__c=true AND Authorized_Avionics_Dealer__c=true ';
     
               strProd = '%'+ strProd +'%';
                avin+= ' and Mechanical_Product_Lines__c like: strProd'; 
              
      
      avin+= ' order by BGAMob_Country_Nm__c,BGAMob_State_Province__c'; 
     //System.debug('avin value--->'+avin);
    lisAvionics =Database.query(avin);
       String mech = 'Select Id,Report_Account_name__c,Report_Account_Name_small__c,Engine_Authorization__c,Avionics_Support_Level__c,BGAMob_Contact_Name__c,BGAMob_Contact_Email__c,';
      mech += 'Mechanical_Product_Lines__c,BGAMob_Customer_Phone__c,BGAMob_State_Province__c, Authorized_Avionics_Dealer__c,Authorized_Mechanical_Service_Center__c,BGAMob_Country_Nm__c,Mobile_App_Visibility__c from Account_Address__c ';
      mech += 'where Mobile_App_Visibility__c=true AND Authorized_Mechanical_Service_Center__c=true';
      
     
               strProd = '%'+ strProd +'%';
                mech+= ' and Mechanical_Product_Lines__c like: strProd'; 
              
      mech += ' order by BGAMob_Country_Nm__c,BGAMob_State_Province__c'; 
       //System.debug('mech  value--->'+mech);
    lisMechanical=Database.query(mech);
            lAccRec.add(lisAvionics);
        lAccRec.add(lisMechanical);
        lAccRec.add(lisAll);  
           return lAccRec;
           }
        
        
         @RemoteAction
           Static public List<List<Account_Address__c>> getContactByProductUsingGPS(String strProd,Decimal lat,Decimal lng)
           {
           
          String str = null;
           
           
           
          
           List<List<Account_Address__c>> lAccRec = new List<List<Account_Address__c>>();
    
      List<Account_Address__c> lisAvionics = new List<Account_Address__c>();
      
      List<Account_Address__c> lisMechanical = new List<Account_Address__c>();
      List<Account_Address__c> lisAll = new List<Account_Address__c>();
      String q = 'Select Id,Report_Account_name__c,Report_Account_Name_small__c,Engine_Authorization__c,Avionics_Support_Level__c,BGAMob_Contact_Name__c,BGAMob_Contact_Email__c,';
      q+= 'Mechanical_Product_Lines__c,BGAMob_Customer_Phone__c,BGAMob_State_Province__c, Authorized_Avionics_Dealer__c,Authorized_Mechanical_Service_Center__c,BGAMob_Country_Nm__c,Mobile_App_Visibility__c from Account_Address__c ';
      q+= 'where Mobile_App_Visibility__c=true ';
    
               
               strProd = '%'+ strProd +'%';
      q+= ' and Mechanical_Product_Lines__c like: strProd';               
      q += ' and  BGAMob_Geo_Code__Latitude__s != null and BGAMob_Geo_Code__Longitude__s != null ';
      q += ' order by DISTANCE(BGAMob_Geo_Code__c, GEOLOCATION(';
      q += String.valueOf(lat) + ',' + String.valueOf(lng) + '), \'mi\')';

        lisAll = Database.query(q);
          String avin = 'Select Id,Report_Account_name__c,Report_Account_Name_small__c,Engine_Authorization__c,Avionics_Support_Level__c,BGAMob_Contact_Name__c,BGAMob_Contact_Email__c,';
      avin+= 'Mechanical_Product_Lines__c,BGAMob_Customer_Phone__c,BGAMob_State_Province__c, Authorized_Avionics_Dealer__c,Authorized_Mechanical_Service_Center__c,BGAMob_Country_Nm__c,Mobile_App_Visibility__c from Account_Address__c ';
      avin+= 'where Mobile_App_Visibility__c=true AND Authorized_Avionics_Dealer__c=true ';
     
               strProd = '%'+ strProd +'%';
                avin+= ' and Mechanical_Product_Lines__c like: strProd'; 
              
      
      avin += ' and  BGAMob_Geo_Code__Latitude__s != null and BGAMob_Geo_Code__Longitude__s != null ';
      avin += ' order by DISTANCE(BGAMob_Geo_Code__c, GEOLOCATION(';
      avin += String.valueOf(lat) + ',' + String.valueOf(lng) + '), \'mi\')';
    
    lisAvionics =Database.query(avin);
      String mech = 'Select Id,Report_Account_name__c,Report_Account_Name_small__c,Engine_Authorization__c,Avionics_Support_Level__c,BGAMob_Contact_Name__c,BGAMob_Contact_Email__c,';
      mech += 'Mechanical_Product_Lines__c,BGAMob_Customer_Phone__c,BGAMob_State_Province__c, Authorized_Avionics_Dealer__c,Authorized_Mechanical_Service_Center__c,BGAMob_Country_Nm__c,Mobile_App_Visibility__c from Account_Address__c ';
      mech += 'where Mobile_App_Visibility__c=true AND Authorized_Mechanical_Service_Center__c=true';
      
     
               strProd = '%'+ strProd +'%';
                mech+= ' and Mechanical_Product_Lines__c like: strProd'; 
             
      mech += ' and  BGAMob_Geo_Code__Latitude__s != null and BGAMob_Geo_Code__Longitude__s != null ';
      mech += ' order by DISTANCE(BGAMob_Geo_Code__c, GEOLOCATION(';
      mech += String.valueOf(lat) + ',' + String.valueOf(lng) + '), \'mi\')';
      
    lisMechanical=Database.query(mech);
            lAccRec.add(lisAvionics);
        lAccRec.add(lisMechanical);
        lAccRec.add(lisAll);  
           return lAccRec;
           }
           
     @RemoteAction      
     Static public List<Account_Address__c> getfilterResult(string c1,string c2,string c3,string sc1,string sc2,string sc3,string sc4,string sc5,string c4,string c5){
     
     List<Account_Address__c> filterresult = new List<Account_Address__c>();
     
     string query = 'Select Id,BGAMob_Website__c,Mechanical_Sub_Category__c ,Report_Account_name__c,Report_Account_Name_small__c,BGAMob_Geo_Code__Latitude__s, BGAMob_Geo_Code__Longitude__s,BGAMob_Contact_Name__c,Avionics_Support_Level__c,Engine_Authorization__c,BGAMob_Contact_Email__c,Mechanical_Product_Lines__c,BGAMob_Customer_Phone__c,BGAMob_Address_1__c,BGAMob_Address_2__c,BGAMob_Address_3__c,BGAMob_City_Name__c,BGAMob_State_Province__c,BGAMob_Postal_Code__c,BGAMob_Country_Nm__c, Authorized_Avionics_Dealer__c,Authorized_Mechanical_Service_Center__c,Mobile_App_Visibility__c from Account_Address__c where  Mobile_App_Visibility__c=true and BGAMob_Geo_Code__Latitude__s != null';
     if(c1 == 'Avionics Dealers')
     query += ' and Channel_Partner_Type__c includes (\''+'Avionics Dealers'+'\')';
     if(c2 == 'Mechanical Components Repair Center')
     query += ' and  Channel_Partner_Type__c includes (\''+'Mechanical Components Repair Center'+'\') ';
     if(c3 == 'Mechanical Service Center')
     query += ' and  Channel_Partner_Type__c includes (\''+'Mechanical Service Center'+'\')';
     if(sc1 == 'TFE')
     query += ' and  Mechanical_Sub_Category__c includes (\''+'TFE'+'\')';
     if(sc2 == 'APU')
     query += ' and  Mechanical_Sub_Category__c includes (\''+'APU'+'\')';
     if(sc3 == 'TPE')
     query += ' and  Mechanical_Sub_Category__c includes (\''+'TPE'+'\')';
     if(sc4 == 'HTF')
     query += ' and  Mechanical_Sub_Category__c includes (\''+'HTF'+'\')';
     if(sc5 == 'CFE')
     query += ' and Mechanical_Sub_Category__c includes (\''+'CFE'+'\')';
     if(c4 == 'Pilatus Ltd Service Provider')
     query += ' and  Channel_Partner_Type__c includes (\''+'Pilatus Ltd Service Provider'+'\')';
     if(c5 == 'Satcom/Connectivity')
     query += ' and  Channel_Partner_Type__c includes (\''+'Satcom/Connectivity'+'\')';
     
     system.debug('test'+query);
     filterresult =Database.query(query);

     return filterresult;
     
     }       
}