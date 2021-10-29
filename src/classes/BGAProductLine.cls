public without sharing class BGAProductLine 
{

   public BGAProductLine (ApexPages.StandardController controller) {
              // acc= New Account_Address__c();
                lSelectedacc= New List<Account_Address__c>();
                 try{
        String prodn = ApexPages.currentPage().getParameters().get('prod');
        System.debug('UAT Testing'+prodn );

            objAccounts = new list<Account_Address__c>(); 
            if(prodn!='AvionicSalesandInstallation' && prodn!='AvionicSalesInstallationandRepair'){ 
            prodn  = '%' + prodn +'%';
          objAccounts.addAll([Select Id,Report_Account_name__c,Report_Account_Name_small__c,BGAMob_Website__c,BGAMob_Geo_Code__Latitude__s, BGAMob_Geo_Code__Longitude__s,BGAMob_Contact_Name__c,Avionics_Support_Level__c,Engine_Authorization__c,BGAMob_Contact_Email__c,Mechanical_Product_Lines__c,BGAMob_Customer_Phone__c,BGAMob_Address_1__c,BGAMob_Address_2__c,BGAMob_Address_3__c,BGAMob_City_Name__c,BGAMob_State_Province__c,BGAMob_Postal_Code__c,BGAMob_Country_Nm__c, Authorized_Avionics_Dealer__c,Authorized_Mechanical_Service_Center__c,Mobile_App_Visibility__c from Account_Address__c where  Mobile_App_Visibility__c=true and Mechanical_Product_Lines__c like :prodn   and BGAMob_Geo_Code__Latitude__s != null] );
             //  objAccounts.addAll([Select Id,Report_Account_name__c,Report_Account_Name_small__c,BGAMob_Website__c,BGAMob_Geo_Code__Latitude__s, BGAMob_Geo_Code__Longitude__s,BGAMob_Contact_Name__c,Avionics_Support_Level__c,Engine_Authorization__c,BGAMob_Contact_Email__c,Mechanical_Product_Lines__c,BGAMob_Customer_Phone__c,BGAMob_Address_1__c,BGAMob_Address_2__c,BGAMob_Address_3__c,BGAMob_City_Name__c,BGAMob_State_Province__c,BGAMob_Postal_Code__c,BGAMob_Country_Nm__c, Authorized_Avionics_Dealer__c,Authorized_Mechanical_Service_Center__c,Mobile_App_Visibility__c from Account_Address__c where  Mobile_App_Visibility__c=true and BGAMob_Geo_Code__Latitude__s != null] );         
            }
            else
            {
            if(prodn=='AvionicSalesandInstallation')
             prodn='Avionic Sales and Installation';
             if(prodn=='AvionicSalesInstallationandRepair')
             prodn='Avionic Sales, Installation and Repair';
             
             prodn  = '%' + prodn +'%';
            objAccounts.addAll([Select Id,Report_Account_name__c,Report_Account_Name_small__c,BGAMob_Website__c,BGAMob_Geo_Code__Latitude__s, BGAMob_Geo_Code__Longitude__s,BGAMob_Contact_Name__c,Avionics_Support_Level__c,Engine_Authorization__c,BGAMob_Contact_Email__c,Mechanical_Product_Lines__c,BGAMob_Customer_Phone__c,BGAMob_Address_1__c,BGAMob_Address_2__c,BGAMob_Address_3__c,BGAMob_City_Name__c,BGAMob_State_Province__c,BGAMob_Postal_Code__c,BGAMob_Country_Nm__c, Authorized_Avionics_Dealer__c,Authorized_Mechanical_Service_Center__c,Mobile_App_Visibility__c from Account_Address__c where  Mobile_App_Visibility__c=true and Avionics_Support_Level__c like :prodn   and BGAMob_Geo_Code__Latitude__s != null] );
               // objAccounts.addAll([Select Id,Report_Account_name__c,Report_Account_Name_small__c,BGAMob_Website__c,BGAMob_Geo_Code__Latitude__s, BGAMob_Geo_Code__Longitude__s,BGAMob_Contact_Name__c,Avionics_Support_Level__c,Engine_Authorization__c,BGAMob_Contact_Email__c,Mechanical_Product_Lines__c,BGAMob_Customer_Phone__c,BGAMob_Address_1__c,BGAMob_Address_2__c,BGAMob_Address_3__c,BGAMob_City_Name__c,BGAMob_State_Province__c,BGAMob_Postal_Code__c,BGAMob_Country_Nm__c, Authorized_Avionics_Dealer__c,Authorized_Mechanical_Service_Center__c,Mobile_App_Visibility__c from Account_Address__c where  Mobile_App_Visibility__c=true and BGAMob_Geo_Code__Latitude__s != null] );
            }
        System.debug(objAccounts);
        }catch(Exception ex){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error:'
                                                        +ex.getMessage()));
        }   
            }

            List<Account_Address__c> lSelectedacc= New List<Account_Address__c>();
            public list<Account_Address__c> objAccounts {get;set;}
            
            
            @RemoteAction 
       public  static List<Account_Address__c> getProductLineDealers(String strProd) 
       {
            list<Account_Address__c> objAccountDeal = new list<Account_Address__c>(); 
            if(strProd !='AvionicSalesandInstallation' && strProd !='AvionicSalesInstallationandRepair'){ 
            strProd = '%' + strProd+'%';
            objAccountDeal.addAll([Select Id,Report_Account_name__c,Report_Account_Name_small__c,BGAMob_Website__c,BGAMob_Geo_Code__Latitude__s, BGAMob_Geo_Code__Longitude__s,BGAMob_Contact_Name__c,Avionics_Support_Level__c,Engine_Authorization__c,BGAMob_Contact_Email__c,Mechanical_Product_Lines__c,BGAMob_Customer_Phone__c,BGAMob_Address_1__c,BGAMob_Address_2__c,BGAMob_Address_3__c,BGAMob_City_Name__c,BGAMob_State_Province__c,BGAMob_Postal_Code__c,BGAMob_Country_Nm__c, Authorized_Avionics_Dealer__c,Authorized_Mechanical_Service_Center__c,Mobile_App_Visibility__c from Account_Address__c where  Mobile_App_Visibility__c=true and Mechanical_Product_Lines__c like :strProd and BGAMob_Geo_Code__Latitude__s != null] );
            }
            else
            {
            if(strProd =='AvionicSalesandInstallation')
             strProd ='Avionic Sales and Installation';
             if(strProd=='AvionicSalesInstallationandRepair')
             strProd='Avionic Sales, Installation and Repair';
             
             strProd = '%' + strProd +'%';
            objAccountDeal.addAll([Select Id,Report_Account_name__c,Report_Account_Name_small__c,BGAMob_Website__c,BGAMob_Geo_Code__Latitude__s, BGAMob_Geo_Code__Longitude__s,BGAMob_Contact_Name__c,Avionics_Support_Level__c,Engine_Authorization__c,BGAMob_Contact_Email__c,Mechanical_Product_Lines__c,BGAMob_Customer_Phone__c,BGAMob_Address_1__c,BGAMob_Address_2__c,BGAMob_Address_3__c,BGAMob_City_Name__c,BGAMob_State_Province__c,BGAMob_Postal_Code__c,BGAMob_Country_Nm__c, Authorized_Avionics_Dealer__c,Authorized_Mechanical_Service_Center__c,Mobile_App_Visibility__c from Account_Address__c where  Mobile_App_Visibility__c=true and Avionics_Support_Level__c like :strProd and BGAMob_Geo_Code__Latitude__s != null] );
            }
        System.debug(objAccountDeal);
            
        
        
       
      // lfinalprod = [SELECT Mechanical_Product_Lines__c FROM Account_Address__c where Mobile_App_Visibility__c = true and Mechanical_Product_Lines__c  != null group by Mechanical_Product_Lines__c order by Mechanical_Product_Lines__c  ];
     //System.debug(lfinalprod);
      return objAccountDeal;
      
      
       }
 @RemoteAction 
       public  static List<BGAMobile_MechanicalAuthorizations__c> getProduct() 
       {
       List<BGAMobile_MechanicalAuthorizations__c> lfinalprod=New List<BGAMobile_MechanicalAuthorizations__c>();
       
        Map<String, BGAMobile_MechanicalAuthorizations__c> mechprod= BGAMobile_MechanicalAuthorizations__c.getAll();
        
        // Sort them by name
         for(BGAMobile_MechanicalAuthorizations__c mechsett: mechprod.values()) {
           
                lfinalprod.add(mechsett);
            
        }
        
        lfinalprod.sort();
      // lfinalprod = [SELECT Mechanical_Product_Lines__c FROM Account_Address__c where Mobile_App_Visibility__c = true and Mechanical_Product_Lines__c  != null group by Mechanical_Product_Lines__c order by Mechanical_Product_Lines__c  ];
     //System.debug(lfinalprod);
      return lfinalprod;
      
      
       }
       @RemoteAction
           Static public Account_Address__c getContact(String strId)
           {
           Account_Address__c Arec = [select id,Report_Account_name__c,Report_Account_Name_small__c,Avionics_Support_Level__c,Engine_Authorization__c,BGAMob_Contact_Name__c,BGAMob_Contact_Email__c,BGAMob_Address_1__c,BGAMob_Address_2__c,BGAMob_Address_3__c,BGAMob_City_Name__c,BGAMob_State_Province__c,BGAMob_Country_Nm__c,BGAMob_Postal_Code__c,BGAMob_Website__c ,Authorized_Avionics_Dealer__c,Authorized_Mechanical_Service_Center__c,Mechanical_Product_Lines__c,BGAMob_Customer_Phone__c from Account_Address__c where id=:strId];
           
           return Arec;
           }   
         @RemoteAction
           public  static List<List<Account_Address__c>> getContactByProduct(String strProd)
           {
                 //  String strProd = ApexPages.currentPage().getParameters().get('prod');
           String str = null;
           
            //String strProd = getProdln();
       //    strProd = strProd.replace('amp;','');
           List<List<Account_Address__c>> lAccRec = new List<List<Account_Address__c>>();
    
      List<Account_Address__c> lisAvionics = new List<Account_Address__c>();
      
      List<Account_Address__c> lisMechanical = new List<Account_Address__c>();
      List<Account_Address__c> lisAll = new List<Account_Address__c>();
      
      if(strProd!='AvionicSalesandInstallation' && strProd!='AvionicSalesInstallationandRepair'){ 
             String q = 'Select Id,Report_Account_name__c,Report_Account_Name_small__c,Engine_Authorization__c,BGAMob_Contact_Name__c,BGAMob_Contact_Email__c,';
      q+= 'Mechanical_Product_Lines__c,Avionics_Support_Level__c,BGAMob_Customer_Phone__c,BGAMob_State_Province__c, Authorized_Avionics_Dealer__c,Authorized_Mechanical_Service_Center__c,BGAMob_Country_Nm__c,Mobile_App_Visibility__c from Account_Address__c ';
      q+= 'where Mobile_App_Visibility__c=true ';
        str = '%'+ strProd +'%';
               q+= ' and Mechanical_Product_Lines__c like: str'; 
      
 
      q += ' order by BGAMob_Country_Nm__c,BGAMob_State_Province__c';
      //System.debug('q value--->'+q);
      lisAll = Database.query(q);
            }
            else
            {
            if(strProd=='AvionicSalesandInstallation')
             str ='Avionic Sales and Installation';
             if(strProd=='AvionicSalesInstallationandRepair')
             str ='Avionic Sales, Installation and Repair';
             
            String q = 'Select Id,Report_Account_name__c,Report_Account_Name_small__c,Engine_Authorization__c,BGAMob_Contact_Name__c,BGAMob_Contact_Email__c,';
      q+= 'Mechanical_Product_Lines__c,Avionics_Support_Level__c,BGAMob_Customer_Phone__c,BGAMob_State_Province__c, Authorized_Avionics_Dealer__c,Authorized_Mechanical_Service_Center__c,BGAMob_Country_Nm__c,Mobile_App_Visibility__c from Account_Address__c ';
      q+= 'where Mobile_App_Visibility__c=true ';
        str = '%'+ str +'%';
               q+= ' and Avionics_Support_Level__c  like: str'; 
      
 
      q += ' order by BGAMob_Country_Nm__c,BGAMob_State_Province__c';
      //System.debug('q value--->'+q);
      lisAll = Database.query(q);
            }
            System.debug('strProd value'+strProd);
          if(strProd!='AvionicSalesandInstallation' && strProd!='AvionicSalesInstallationandRepair'){ 
             String avin = 'Select Id,Report_Account_name__c,Report_Account_Name_small__c,Engine_Authorization__c,BGAMob_Contact_Name__c,BGAMob_Contact_Email__c,';
      avin+= 'Mechanical_Product_Lines__c,Avionics_Support_Level__c,BGAMob_Customer_Phone__c,BGAMob_State_Province__c, Authorized_Avionics_Dealer__c,Authorized_Mechanical_Service_Center__c,BGAMob_Country_Nm__c,Mobile_App_Visibility__c from Account_Address__c ';
      avin+= 'where Mobile_App_Visibility__c=true AND Authorized_Avionics_Dealer__c=true ';
      str = '%'+ strProd +'%';
               avin+= ' and Mechanical_Product_Lines__c like: str'; 
      avin+= ' order by BGAMob_Country_Nm__c,BGAMob_State_Province__c'; 
     System.debug('avin value--->'+avin);
    lisAvionics =Database.query(avin);
            }
            else
            {
            System.debug('strProd value else condition of line 121 '+strProd);
            if(strProd=='AvionicSalesandInstallation')
             str ='Avionic Sales and Installation';
             if(strProd=='AvionicSalesInstallationandRepair')
             str ='Avionic Sales, Installation and Repair';
             
            String avin = 'Select Id,Report_Account_name__c,Report_Account_Name_small__c,Engine_Authorization__c,BGAMob_Contact_Name__c,BGAMob_Contact_Email__c,';
      avin+= 'Mechanical_Product_Lines__c,Avionics_Support_Level__c,BGAMob_Customer_Phone__c,BGAMob_State_Province__c, Authorized_Avionics_Dealer__c,Authorized_Mechanical_Service_Center__c,BGAMob_Country_Nm__c,Mobile_App_Visibility__c from Account_Address__c ';
      avin+= 'where Mobile_App_Visibility__c=true AND Authorized_Avionics_Dealer__c=true ';
      str = '%'+ str +'%';
               avin+= ' and Avionics_Support_Level__c like: str'; 
      avin+= ' order by BGAMob_Country_Nm__c,BGAMob_State_Province__c'; 
     System.debug('avin value--->'+avin);
    lisAvionics =Database.query(avin);
            }
       if(strProd!='AvionicSalesandInstallation' && strProd!='AvionicSalesInstallationandRepair'){ 
             String mech = 'Select Id,Report_Account_name__c,Report_Account_Name_small__c,Engine_Authorization__c,BGAMob_Contact_Name__c,BGAMob_Contact_Email__c,';
      mech += 'Mechanical_Product_Lines__c,Avionics_Support_Level__c,BGAMob_Customer_Phone__c,BGAMob_State_Province__c, Authorized_Avionics_Dealer__c,Authorized_Mechanical_Service_Center__c,BGAMob_Country_Nm__c,Mobile_App_Visibility__c from Account_Address__c ';
      mech += 'where Mobile_App_Visibility__c=true AND Authorized_Mechanical_Service_Center__c=true';
      
       str = '%'+ strProd +'%';
               mech += ' and Mechanical_Product_Lines__c like: str'; 
      mech += ' order by BGAMob_Country_Nm__c,BGAMob_State_Province__c'; 
       //System.debug('mech  value--->'+mech);
    lisMechanical=Database.query(mech);
            }
            else
            {
            if(strProd=='AvionicSalesandInstallation')
             str ='Avionic Sales and Installation';
             if(strProd=='AvionicSalesInstallationandRepair')
             str ='Avionic Sales, Installation and Repair';
             
            String mech = 'Select Id,Report_Account_name__c,Report_Account_Name_small__c,Engine_Authorization__c,BGAMob_Contact_Name__c,BGAMob_Contact_Email__c,';
      mech += 'Mechanical_Product_Lines__c,Avionics_Support_Level__c,BGAMob_Customer_Phone__c,BGAMob_State_Province__c, Authorized_Avionics_Dealer__c,Authorized_Mechanical_Service_Center__c,BGAMob_Country_Nm__c,Mobile_App_Visibility__c from Account_Address__c ';
      mech += 'where Mobile_App_Visibility__c=true AND Authorized_Mechanical_Service_Center__c=true';
      
       str = '%'+ str +'%';
               mech += ' and Avionics_Support_Level__c like: str'; 
      mech += ' order by BGAMob_Country_Nm__c,BGAMob_State_Province__c'; 
       System.debug('mech  value--->'+mech);
    lisMechanical=Database.query(mech);
            }
            lAccRec.add(lisAvionics);
        lAccRec.add(lisMechanical);
        lAccRec.add(lisAll);  
           return lAccRec;
           }
        
        
         @RemoteAction
           public static List<List<Account_Address__c>> getContactByProductUsingGPS(String strProd,Decimal lat,Decimal lng)
           {
           
          String str = null;
    
           
           
          
           List<List<Account_Address__c>> lAccRec = new List<List<Account_Address__c>>();
    
      List<Account_Address__c> lisAvionics = new List<Account_Address__c>();
      
      List<Account_Address__c> lisMechanical = new List<Account_Address__c>();
      List<Account_Address__c> lisAll = new List<Account_Address__c>();
      
     if(strProd!='AvionicSalesandInstallation' && strProd!='AvionicSalesInstallationandRepair'){ 
 String q = 'Select Id,Report_Account_name__c,Report_Account_Name_small__c,BGAMob_Geo_Code__Latitude__s ,BGAMob_Geo_Code__Longitude__s ,Engine_Authorization__c,BGAMob_Contact_Name__c,BGAMob_Contact_Email__c,';
      q+= 'Mechanical_Product_Lines__c,Avionics_Support_Level__c,BGAMob_Customer_Phone__c,BGAMob_State_Province__c, Authorized_Avionics_Dealer__c,Authorized_Mechanical_Service_Center__c,BGAMob_Country_Nm__c,Mobile_App_Visibility__c from Account_Address__c ';
      q+= 'where Mobile_App_Visibility__c=true ';
       str = '%'+ strProd +'%';
               q+= ' and Mechanical_Product_Lines__c like: str'; 
q += ' and  BGAMob_Geo_Code__Latitude__s != null and BGAMob_Geo_Code__Longitude__s != null ';
      q += ' order by DISTANCE(BGAMob_Geo_Code__c, GEOLOCATION(';
      q += String.valueOf(lat) + ',' + String.valueOf(lng) + '), \'mi\')';

        lisAll = Database.query(q);
        }
        else
        {
        if(strProd=='AvionicSalesandInstallation')
             str ='Avionic Sales and Installation';
             if(strProd=='AvionicSalesInstallationandRepair')
             str ='Avionic Sales, Installation and Repair';
             String q = 'Select Id,Report_Account_name__c,Report_Account_Name_small__c,BGAMob_Geo_Code__Latitude__s ,BGAMob_Geo_Code__Longitude__s ,Engine_Authorization__c,BGAMob_Contact_Name__c,BGAMob_Contact_Email__c,';
      q+= 'Mechanical_Product_Lines__c,Avionics_Support_Level__c,BGAMob_Customer_Phone__c,BGAMob_State_Province__c, Authorized_Avionics_Dealer__c,Authorized_Mechanical_Service_Center__c,BGAMob_Country_Nm__c,Mobile_App_Visibility__c from Account_Address__c ';
      q+= 'where Mobile_App_Visibility__c=true ';
       str = '%'+ str +'%';
               q+= ' and Avionics_Support_Level__c like: str'; 
q += ' and  BGAMob_Geo_Code__Latitude__s != null and BGAMob_Geo_Code__Longitude__s != null ';
      q += ' order by DISTANCE(BGAMob_Geo_Code__c, GEOLOCATION(';
      q += String.valueOf(lat) + ',' + String.valueOf(lng) + '), \'mi\')';

        lisAll = Database.query(q);
        }
        
        if(strProd!='AvionicSalesandInstallation' && strProd!='AvionicSalesInstallationandRepair'){ 
 String avin = 'Select Id,Report_Account_name__c,Report_Account_Name_small__c,BGAMob_Geo_Code__Latitude__s ,BGAMob_Geo_Code__Longitude__s ,Engine_Authorization__c,Avionics_Support_Level__c,BGAMob_Contact_Name__c,BGAMob_Contact_Email__c,';
      avin+= 'Mechanical_Product_Lines__c,BGAMob_Customer_Phone__c,BGAMob_State_Province__c, Authorized_Avionics_Dealer__c,Authorized_Mechanical_Service_Center__c,BGAMob_Country_Nm__c,Mobile_App_Visibility__c from Account_Address__c ';
      avin+= 'where Mobile_App_Visibility__c=true AND Authorized_Avionics_Dealer__c=true ';
       str = '%'+ strProd +'%';
               avin += ' and Mechanical_Product_Lines__c like: str'; 
      avin += ' and  BGAMob_Geo_Code__Latitude__s != null and BGAMob_Geo_Code__Longitude__s != null ';
      avin += ' order by DISTANCE(BGAMob_Geo_Code__c, GEOLOCATION(';
      avin += String.valueOf(lat) + ',' + String.valueOf(lng) + '), \'mi\')';
    
    lisAvionics =Database.query(avin);
        }
        else
        {
        if(strProd=='AvionicSalesandInstallation')
             str ='Avionic Sales and Installation';
             if(strProd=='AvionicSalesInstallationandRepair')
             str ='Avionic Sales, Installation and Repair';
              String avin = 'Select Id,Report_Account_name__c,Report_Account_Name_small__c,BGAMob_Geo_Code__Latitude__s ,BGAMob_Geo_Code__Longitude__s ,Engine_Authorization__c,Avionics_Support_Level__c,BGAMob_Contact_Name__c,BGAMob_Contact_Email__c,';
      avin+= 'Mechanical_Product_Lines__c,BGAMob_Customer_Phone__c,BGAMob_State_Province__c, Authorized_Avionics_Dealer__c,Authorized_Mechanical_Service_Center__c,BGAMob_Country_Nm__c,Mobile_App_Visibility__c from Account_Address__c ';
      avin+= 'where Mobile_App_Visibility__c=true AND Authorized_Avionics_Dealer__c=true ';
       str = '%'+ str  +'%';
               avin += ' and Avionics_Support_Level__c like: str'; 
      avin += ' and  BGAMob_Geo_Code__Latitude__s != null and BGAMob_Geo_Code__Longitude__s != null ';
      avin += ' order by DISTANCE(BGAMob_Geo_Code__c, GEOLOCATION(';
      avin += String.valueOf(lat) + ',' + String.valueOf(lng) + '), \'mi\')';
    
    lisAvionics =Database.query(avin);
        }
        
        
         
      if(strProd!='AvionicSalesandInstallation' && strProd!='AvionicSalesInstallationandRepair'){ 
 String mech = 'Select Id,Report_Account_name__c,Report_Account_Name_small__c,BGAMob_Geo_Code__Latitude__s ,BGAMob_Geo_Code__Longitude__s ,Engine_Authorization__c,Avionics_Support_Level__c,BGAMob_Contact_Name__c,BGAMob_Contact_Email__c,';
      mech += 'Mechanical_Product_Lines__c,BGAMob_Customer_Phone__c,BGAMob_State_Province__c, Authorized_Avionics_Dealer__c,Authorized_Mechanical_Service_Center__c,BGAMob_Country_Nm__c,Mobile_App_Visibility__c from Account_Address__c ';
      mech += 'where Mobile_App_Visibility__c=true AND Authorized_Mechanical_Service_Center__c=true';
      str = '%'+ strProd +'%';
               mech+= ' and Mechanical_Product_Lines__c like: str'; 
      mech += ' and  BGAMob_Geo_Code__Latitude__s != null and BGAMob_Geo_Code__Longitude__s != null ';
      mech += ' order by DISTANCE(BGAMob_Geo_Code__c, GEOLOCATION(';
      mech += String.valueOf(lat) + ',' + String.valueOf(lng) + '), \'mi\')';
      
    lisMechanical=Database.query(mech);
        }
        else
        {
        if(strProd=='AvionicSalesandInstallation')
             str ='Avionic Sales and Installation';
             if(strProd=='AvionicSalesInstallationandRepair')
             str ='Avionic Sales, Installation and Repair';
              String mech = 'Select Id,Report_Account_name__c,Report_Account_Name_small__c,BGAMob_Geo_Code__Latitude__s ,BGAMob_Geo_Code__Longitude__s ,Engine_Authorization__c,Avionics_Support_Level__c,BGAMob_Contact_Name__c,BGAMob_Contact_Email__c,';
      mech += 'Mechanical_Product_Lines__c,BGAMob_Customer_Phone__c,BGAMob_State_Province__c, Authorized_Avionics_Dealer__c,Authorized_Mechanical_Service_Center__c,BGAMob_Country_Nm__c,Mobile_App_Visibility__c from Account_Address__c ';
      mech += 'where Mobile_App_Visibility__c=true AND Authorized_Mechanical_Service_Center__c=true';
      str = '%'+ str +'%';
               mech+= ' and Avionics_Support_Level__c like: str'; 
      mech += ' and  BGAMob_Geo_Code__Latitude__s != null and BGAMob_Geo_Code__Longitude__s != null ';
      mech += ' order by DISTANCE(BGAMob_Geo_Code__c, GEOLOCATION(';
      mech += String.valueOf(lat) + ',' + String.valueOf(lng) + '), \'mi\')';
      
    lisMechanical=Database.query(mech);
        }
            lAccRec.add(lisAvionics);
        lAccRec.add(lisMechanical);
        lAccRec.add(lisAll);  
           return lAccRec;
           }
}