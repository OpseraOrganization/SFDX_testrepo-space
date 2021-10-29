global class Spex_DB_Dataload{
        
/* Start: meta data classes for input structure */

       /* This class represents the fields in the part summary object that are updated by SAP */
        global class PART_SUMMARY_cls
        {
        
            webservice  String PART_NUMBER;
            webservice  String PART_DESCRIPTION;
            webservice  String ABC_CODE;
            webservice  String PRODUCT_FAMILY;
            webservice  String ASSET_MANAGER;
            webservice  Integer STOCK_BY_AMERICAS;
            webservice  Integer STOCK_BY_EMEA;
            webservice  Integer STOCK_BY_APAC;
            webservice  Integer DEMAND_BY_AMERICAS;
            webservice  Integer DEMAND_BY_EMEA;
            webservice  Integer DEMAND_BY_APAC;
            webservice  Integer MIN_STOCK_AMERICAS;
            webservice  Integer MIN_STOCK_EMEA;
            webservice  Integer MIN_STOCK_APAC;

            webservice String TRANSACTION_FLAG;
            
        }
        /* This class represents the fields in the platfrom summary object that are updated by SAP */
        global class PLATFORM_SUMMARY_cls
        {
            webservice  String  PLATFORM;
            webservice  String  OEM_NAME;
            webservice  String  PART_NUMBER;
            webservice  Integer DEMAND_BY_AMERICAS;
            webservice  Integer DEMAND_BY_EMEA;
            webservice  Integer DEMAND_BY_APAC;
            webservice String TRANSACTION_FLAG;
               
        }
        
 /* End: meta data classes for input structure */         
     
         /* SAP/PI will make a call out to this webservie menthod to initiate data loads */  
       webservice static String SPEX_DB_LOAD_SFDC_OBJECTS(PART_SUMMARY_cls[] PARTSUM, PLATFORM_SUMMARY_cls[] PLATSUM) {
        String rtn=' ';//return variable set based on success/failure
        string fstaddr='';
      
        
        system.debug('*****Data by Parts****'+PARTSUM);
        system.debug('*****Data by Platform****'+PLATSUM);
        
        Spex_DB_Dataload cls_obj= new Spex_DB_Dataload();//class obj to call methods defined for modularisation
        PART_SUMMARY_cls[] partsum_update = new PART_SUMMARY_cls[]{}; //separate object array for part summary update records
        PART_SUMMARY_cls[] partsum_delete = new PART_SUMMARY_cls[]{}; //separate object array for part summary delete records
        PART_SUMMARY_cls[] partsum_insert = new PART_SUMMARY_cls[]{}; //separate object array for part summary insert records
        
        PLATFORM_SUMMARY_cls[] platsum_update = new PLATFORM_SUMMARY_cls[]{}; //separate object array for platform summary update records
        PLATFORM_SUMMARY_cls[] platsum_delete = new PLATFORM_SUMMARY_cls[]{}; //separate object array for platform summary delete records
        PLATFORM_SUMMARY_cls[] platsum_insert = new PLATFORM_SUMMARY_cls[]{}; //separate object array for platform summary insert records
                                                                                  
        
       try
       {
                                                             
        if(PARTSUM.size()>0)
        {
        for(PART_SUMMARY_cls sobj:PARTSUM) // separate out the  part summary records based on the transaction flag.
          {
                if (sobj.TRANSACTION_FLAG=='N' || sobj.TRANSACTION_FLAG=='n') // N = n = New Record
                {
                    partsum_insert.add(sobj);
                }
            else if (sobj.TRANSACTION_FLAG=='C' || sobj.TRANSACTION_FLAG=='c') // C = c = Change Record
                {
                    partsum_update.add(sobj);
                }
            else if (sobj.TRANSACTION_FLAG=='D' || sobj.TRANSACTION_FLAG=='d') // D = d = Delete Record
                {
                    partsum_delete.add(sobj);
                }       
            }
            if (partsum_insert.size()>0 || partsum_update.size()>0 || partsum_delete.size()>0) {
                if (partsum_insert.size()>0)
                rtn = cls_obj.INSERT_PART_SUMM(partsum_insert);  
                if(partsum_update.size()>0)
                rtn = cls_obj.UPDATE_PART_SUMM(partsum_update);
                if(partsum_delete.size()>0)
                rtn = cls_obj.DELETE_PART_SUMM(partsum_delete);      
            }
            else{
               rtn = 'Empty Run!';            
               }        
          } 
          else{
              rtn = 'Empty Run!';            
              }            
       if(PLATSUM.size()>0)
        {
        for(PLATFORM_SUMMARY_cls sobj:PLATSUM) // separate out the  platfrom summary records based on the transaction flag.
          {
                if (sobj.TRANSACTION_FLAG=='N' || sobj.TRANSACTION_FLAG=='n')  // N = n = New Record
                {
                    platsum_insert.add(sobj);
                }
             else if (sobj.TRANSACTION_FLAG=='C' || sobj.TRANSACTION_FLAG=='c') // C = c = Change Record
                {
                    platsum_update.add(sobj);
                }
             else if (sobj.TRANSACTION_FLAG=='D' || sobj.TRANSACTION_FLAG=='d') // D = d = Delete Record
                {
                    platsum_delete.add(sobj);
                }
            
            }
            if (platsum_insert.size()>0 || platsum_update.size()>0 || platsum_delete.size()>0) {
                if (platsum_insert.size()>0)
              rtn = cls_obj.INSERT_PLATFORM_SUMM(platsum_insert);  
                if(platsum_update.size()>0)
              rtn = cls_obj.UPDATE_PLATFORM_SUMM(platsum_update);  
                if(platsum_delete.size()>0)
              rtn = cls_obj.DELETE_PLATFORM_SUMM(platsum_delete);  
           }
           else{
              if(rtn != 'Empty Run!')
              rtn = rtn;
              else
              rtn = 'Empty Run!';
               }
         }
          else{
              if(rtn != 'Empty Run!')
              rtn = rtn;
              else
              rtn = 'Empty Run!';
              }
       }
       
       catch(exception e)
        {
            rtn='Failure: Problem with received data/request/xml ';
            rtn=rtn+e;
        }
        
         if(rtn=='Success!') 
            {
            SPEX_DB_Data_Log__c dlog = new SPEX_DB_Data_Log__c();
            dlog.Refresh_Time__c = datetime.now();
            dlog.Load_Status__c = 'Success!!!';
            dlog.Total_Records_Part_Summary__c = PARTSUM.size();
            dlog.Total_Records_Platform_Summary__c = PLATSUM.size();
            dlog.Part_Summary_Updates__c = partsum_update.size();
            dlog.Part_Summary_Inserts__c = partsum_insert.size();
            dlog.Part_Summary_Deletes__c = partsum_delete.size();
            dlog.Platform_Summary_Updates__c = platsum_update.size();
            dlog.Platform_Summary_Inserts__c = platsum_insert.size();
            dlog.Platform_Summary_Deletes__c = platsum_delete.size();
            dlog.Exception_Description__c = '';
            insert dlog;
            return 'Success!';
            }
         else if(rtn=='Empty Run!') 
            {
            SPEX_DB_Data_Log__c dlog = new SPEX_DB_Data_Log__c();
            dlog.Refresh_Time__c = datetime.now();
            dlog.Load_Status__c = 'Empty Run!';
            dlog.Total_Records_Part_Summary__c = PARTSUM.size();
            dlog.Total_Records_Platform_Summary__c = PLATSUM.size();
            dlog.Part_Summary_Updates__c = partsum_update.size();
            dlog.Part_Summary_Inserts__c = partsum_insert.size();
            dlog.Part_Summary_Deletes__c = partsum_delete.size();
            dlog.Platform_Summary_Updates__c = platsum_update.size();
            dlog.Platform_Summary_Inserts__c = platsum_insert.size();
            dlog.Platform_Summary_Deletes__c = platsum_delete.size();
            dlog.Exception_Description__c = 'No data was sent for updates, deletes or inserts';
            insert dlog;
            return 'Success!';
            }
        else
            {
            SPEX_DB_Data_Log__c dlog = new SPEX_DB_Data_Log__c();
            dlog.Refresh_Time__c = datetime.now();
            dlog.Load_Status__c = 'Failed';
            dlog.Total_Records_Part_Summary__c = PARTSUM.size();
            dlog.Total_Records_Platform_Summary__c = PLATSUM.size();
            dlog.Part_Summary_Updates__c = partsum_update.size();
            dlog.Part_Summary_Inserts__c = partsum_insert.size();
            dlog.Part_Summary_Deletes__c = partsum_delete.size();
            dlog.Platform_Summary_Updates__c = platsum_update.size();
            dlog.Platform_Summary_Inserts__c = platsum_insert.size();
            dlog.Platform_Summary_Deletes__c = platsum_delete.size();
            if(string.valueof(rtn).length()>32766)
            dlog.Exception_Description__c = string.valueof(rtn.substring(0,32756));
            else 
            dlog.Exception_Description__c = string.valueof(rtn);
            insert dlog;
            return 'Failure!';
            }
  }
  
   /* Method to update records in part summary object/table */  
  public String UPDATE_PART_SUMM(PART_SUMMARY_cls[] PARTSUMM)
  {
    String rtn=' ';//return variable set based on success/failure
    Set<String> partNumber_Set = new Set<String>(); // to store unique part numbers
    Map<String,PART_SUMMARY_cls> partMap = new Map<String,PART_SUMMARY_cls>(); // to store unique part numbers as key and the corresponding object/row as value
     try
       {
     if(PARTSUMM.size()>0)
        {
     for(PART_SUMMARY_cls sobj:PARTSUMM)  // get all the partnumbers and its corresponding row/object from the object array passed as argument
          {
            partNumber_Set.add(sobj.PART_NUMBER); // store the unique part numbers in the set
            partMap.put(sobj.PART_NUMBER,sobj); // store unique part number as key and the corresponding object/row as value
          }
        }
   list<SPEX_DB_Part_Summary__c> filteredlist = [select id, Part_Number__c, Stock_By_Americas__c, Demand_By_Americas__c, Stock_By_APAC__c, Demand_By_APAC__c, Stock_By_EMEA__c, Demand_By_EMEA__c, ABC_Code__c, Asset_Manager__c, Part_Description__c, Product_Family__c 
                                                    from SPEX_DB_Part_Summary__c where Part_Number__c in :partNumber_Set]; // select existing data from the salesforce object 
    
    if(filteredlist.size()>0)
        {
    for(SPEX_DB_Part_Summary__c temp:filteredlist) // update salesforce existing object data with the values from the new object array
         {
           PART_SUMMARY_cls part_temp = partMap.get(temp.Part_Number__c);//temp variable to hold the part summary object
           temp.Demand_By_Americas__c=part_temp.DEMAND_BY_AMERICAS;
            temp.Stock_By_Americas__c=part_temp.STOCK_BY_AMERICAS;
            if(part_temp.MIN_STOCK_AMERICAS==null)
             temp.Min_Stock_Americas__c=0;
            else
            temp.Min_Stock_Americas__c=part_temp.MIN_STOCK_AMERICAS;   
            temp.Demand_By_EMEA__c=part_temp.DEMAND_BY_EMEA;
            temp.Stock_By_EMEA__c=part_temp.STOCK_BY_EMEA;
            if(part_temp.MIN_STOCK_EMEA==null)
             temp.Min_Stock_EMEA__c=0;
            else
            temp.Min_Stock_EMEA__c=part_temp.MIN_STOCK_EMEA;
            temp.Demand_By_APAC__c=part_temp.DEMAND_BY_APAC;
            temp.Stock_By_APAC__c=part_temp.STOCK_BY_APAC;
            if(part_temp.MIN_STOCK_APAC==null)
             temp.Min_Stock_APAC__c=0;
            else
            temp.Min_Stock_APAC__c=part_temp.MIN_STOCK_APAC;
            temp.ABC_Code__c=part_temp.ABC_CODE;
            temp.Asset_Manager__c=part_temp.ASSET_MANAGER;
            temp.Part_Description__c=part_temp.PART_DESCRIPTION;
            temp.Product_Family__c=part_temp.PRODUCT_FAMILY;
         }
         update filteredlist;
        }
        rtn='Success!';
       }
        catch(exception e)
        {
            rtn='Failure updating Part Summary record(s): ';
            rtn=rtn+e;
        }
        return rtn;                                
  }
  
  /* Method to insert new records in part summary object/table */
  public String INSERT_PART_SUMM(PART_SUMMARY_cls[] PARTSUMM)
  {
    List<SPEX_DB_Part_Summary__c> partsum_List_add = new List<SPEX_DB_Part_Summary__c>();/* store the part records */
    String rtn=' ';//return variable set based on success/failure
    try
    { 
    if(PARTSUMM.size()>0)
        {
        for(PART_SUMMARY_cls sobj:PARTSUMM)
          {
            SPEX_DB_Part_Summary__c parts = new SPEX_DB_Part_Summary__c();
            parts.Part_Number__c=sobj.PART_NUMBER;
            parts.Part_Description__c=sobj.PART_DESCRIPTION;
            parts.Asset_Manager__c=sobj.ASSET_MANAGER;
            parts.ABC_Code__c=sobj.ABC_CODE;
            parts.Product_Family__c=sobj.PRODUCT_FAMILY;
            parts.Demand_By_Americas__c=sobj.DEMAND_BY_AMERICAS;
            parts.Stock_By_Americas__c=sobj.STOCK_BY_AMERICAS;
            if(sobj.MIN_STOCK_AMERICAS==null)
             parts.Min_Stock_Americas__c=0;
            else
            parts.Min_Stock_Americas__c=sobj.MIN_STOCK_AMERICAS;
            parts.Demand_By_EMEA__c=sobj.DEMAND_BY_EMEA;
            parts.Stock_By_EMEA__c=sobj.STOCK_BY_EMEA;
            if(sobj.MIN_STOCK_EMEA==null)
             parts.Min_Stock_EMEA__c=0;
            else
            parts.Min_Stock_EMEA__c=sobj.MIN_STOCK_EMEA;        
            parts.Demand_By_APAC__c=sobj.DEMAND_BY_APAC;
            parts.Stock_By_APAC__c=sobj.STOCK_BY_APAC;
            if(sobj.MIN_STOCK_APAC==null)
             parts.Min_Stock_APAC__c=0;
            else
            parts.Min_Stock_APAC__c=sobj.MIN_STOCK_APAC;
            partsum_List_add.add(parts);
          }
          if(partsum_List_add.size()>0){
                 insert partsum_List_add;  
            }           
        }
        rtn='Success!';
       }
        catch(exception e)
        {
            rtn='Failure inserting Part Summary  record(s): ';
            rtn=rtn+e;
        }
        return rtn;
  }
  
  /* Method to delete records from part summary object/table */
  public String DELETE_PART_SUMM(PART_SUMMARY_cls[] PARTSUMM)
  {
  Set<String> partNumber_Set = new Set<String>(); // to store unique part numbers
  String rtn=' ';//return variable set based on success/failure
  try
  {
     if(PARTSUMM.size()>0)
        {
     for(PART_SUMMARY_cls sobj:PARTSUMM)  // get all the partnumbers to be deleted 
          {
            partNumber_Set.add(sobj.PART_NUMBER); // store the unique part numbers in the set
          }
        }
   list<SPEX_DB_Part_Summary__c> filteredlist = [select id from SPEX_DB_Part_Summary__c where Part_Number__c in :partNumber_Set]; // get ids of existing data from the salesforce object to be deleted 
    
    if(filteredlist.size()>0)   
    delete filteredlist;
    
    rtn='Success!';
    }
        catch(exception e)
        {
            rtn='Failure deleteing Part Summary record(s): ';
            rtn=rtn+e;
        }
        return rtn;
  }
  
  /* Method to update records in platform summary object/table */
  public String UPDATE_PLATFORM_SUMM(PLATFORM_SUMMARY_cls[] PLATSUMM)
  {
  String rtn=' ';//return variable set based on success/failure 
  Set<String> partNumber_Set = new Set<String>(); // to store unique part number ids
  Set<String> partNumber_Set1 = new Set<String>(); // to store unique part number for querring the associated ids
  Set<String> platformName_Set = new Set<String>(); // to store unique platform names
  Map<String, String> platformMap1 = new Map<String, String>();
  Map<String,PLATFORM_SUMMARY_cls> platformMap = new Map<String,PLATFORM_SUMMARY_cls>(); // to store unique part numbers as key and the corresponding object/row as value
  
  try
  {
     if(PLATSUMM.size()>0)
        {
     for(PLATFORM_SUMMARY_cls sobj:PLATSUMM)  // get all the unique part number/platform combinaton and its corresponding row/object from the object array passed as argument
          {
            if(sobj.PART_NUMBER !=null)
            partNumber_Set1.add(sobj.PART_NUMBER); // store the unique part numbers in the set
          }
        }
   list<SPEX_DB_Part_Summary__c> filteredlist1 = [select id, Part_Number__c from SPEX_DB_Part_Summary__c where Part_Number__c in :partNumber_Set1]; // select existing data from the salesforce object
   
   if(filteredlist1.size()>0)
        {
    for(SPEX_DB_Part_Summary__c temp:filteredlist1) // update salesforce existing object data with the values from the new object array
         {
            platformMap1.put(temp.Part_Number__c, temp.id);
         } 
        }
     if(PLATSUMM.size()>0)
        {
     for(PLATFORM_SUMMARY_cls sobj:PLATSUMM)  // get all the unique part number/platform combinaton and its corresponding row/object from the object array passed as argument
          {
            partNumber_Set.add(platformMap1.get(sobj.PART_NUMBER)); // store the unique part number ids in the set
            platformName_Set.add(sobj.PLATFORM); // store the unique platform in the set
            platformMap.put(platformMap1.get(sobj.PART_NUMBER) + sobj.PLATFORM ,sobj); // store unique part number as key and the corresponding object/row as value
          }
        }
   list<SPEX_DB_Platform_Summary__c> filteredlist = [select id, Part_Number__c, Platform__c, Demand_By_Americas__c, Demand_By_APAC__c, Demand_By_EMEA__c, OEM_Name__c 
                                                    from SPEX_DB_Platform_Summary__c where Part_Number__c in :partNumber_Set and Platform__c in :platformName_Set]; // select existing data from the salesforce object 
    
    if(filteredlist.size()>0)
        {
    for(SPEX_DB_Platform_Summary__c temp:filteredlist) // update salesforce existing object data with the values from the new object array
         {
           PLATFORM_SUMMARY_cls platform_temp = platformMap.get(temp.Part_Number__c + temp.Platform__c);//temp variable to hold the platform summary object
          temp.Demand_By_Americas__c=platform_temp.DEMAND_BY_AMERICAS;      
          temp.Demand_By_EMEA__c=platform_temp.DEMAND_BY_EMEA;
          temp.Demand_By_APAC__c=platform_temp.DEMAND_BY_APAC;
          temp.OEM_Name__c=platform_temp.OEM_NAME;
            
         }
         update filteredlist;
        }
        rtn='Success!';
    }
        catch(exception e)
        {
            rtn='Failure updating Platform Summary record(s): ';
            rtn=rtn+e;
        }
        return rtn; 
  }
  
  
  /* Method to insert new records into part summary object/table */
  public String INSERT_PLATFORM_SUMM(PLATFORM_SUMMARY_cls[] PLATSUMM)
  {
    List<SPEX_DB_Platform_Summary__c> platsum_List_add = new List<SPEX_DB_Platform_Summary__c>();/* store the platform records */
    Map<String, String> platformMap = new Map<String, String>(); // to store unique part numbers as key and the corresponding id as value
    Set<String> partNumber_Set = new Set<String>(); // to store unique part numbers
    String rtn=' ';//return variable set based on success/failure   
    try
    {
        if(PLATSUMM.size()>0)
        {
     for(PLATFORM_SUMMARY_cls sobj:PLATSUMM)  // get all the unique part number/platform combinaton and its corresponding row/object from the object array passed as argument
          {
            if(sobj.PART_NUMBER !=null)
            partNumber_Set.add(sobj.PART_NUMBER); // store the unique part numbers in the set
          }
        }
   list<SPEX_DB_Part_Summary__c> filteredlist = [select id, Part_Number__c from SPEX_DB_Part_Summary__c where Part_Number__c in :partNumber_Set]; // select existing data from the salesforce object
   
   if(filteredlist.size()>0)
        {
    for(SPEX_DB_Part_Summary__c temp:filteredlist) // update salesforce existing object data with the values from the new object array
         {
            platformMap.put(temp.Part_Number__c, temp.id);
         } 
        }
        
      if(PLATSUMM.size()>0)
        {
        for(PLATFORM_SUMMARY_cls sobj:PLATSUMM)
          {
            SPEX_DB_Platform_Summary__c platforms = new SPEX_DB_Platform_Summary__c(Part_Number__c=platformMap.get(sobj.PART_NUMBER));
          //  platforms.Part_Number__c= platformMap.get(sobj.PART_NUMBER);
            platforms.OEM_Name__c=sobj.OEM_NAME;
            platforms.Platform__c=sobj.PLATFORM;
            platforms.Demand_By_Americas__c=sobj.DEMAND_BY_AMERICAS;
            platforms.Demand_By_APAC__c=sobj.DEMAND_BY_APAC;
            platforms.Demand_By_EMEA__c=sobj.DEMAND_BY_EMEA;
            if(platforms.Part_Number__c !=null)
            platsum_List_add.add(platforms);    
          }
          if(platsum_List_add.size()>0){
                 insert platsum_List_add;  
            }
        rtn='Success!';
        }
    }
        catch(exception e)
        {
            rtn='Failure inserting Platform Summary record(s): ';
            rtn=rtn+e;
        }
        return rtn; 
  }
  
  /* Method to delete records in part summary object/table */
  public String DELETE_PLATFORM_SUMM(PLATFORM_SUMMARY_cls[] PLATSUMM)
  {
  Set<String> partNumber_Set = new Set<String>(); // to store unique part numbers
  Set<String> partNumber_Set1 = new Set<String>(); // to store unique part numbers
  Set<String> platformName_Set = new Set<String>(); // to store unique platform names
  Map<String, String> platformMap = new Map<String, String>();
  String rtn=' ';//return variable set based on success/failure
  try
  {
     if(PLATSUMM.size()>0)
        {
     for(PLATFORM_SUMMARY_cls sobj:PLATSUMM)  // get all the unique part number/platform combinaton and its corresponding row/object from the object array passed as argument
          {
            if(sobj.PART_NUMBER !=null)
            partNumber_Set1.add(sobj.PART_NUMBER); // store the unique part numbers in the set
          }
        }
   list<SPEX_DB_Part_Summary__c> filteredlist1 = [select id, Part_Number__c from SPEX_DB_Part_Summary__c where Part_Number__c in :partNumber_Set1]; // select existing data from the salesforce object
   
   if(filteredlist1.size()>0)
        {
    for(SPEX_DB_Part_Summary__c temp:filteredlist1) // update salesforce existing object data with the values from the new object array
         {
            platformMap.put(temp.Part_Number__c, temp.id);
         } 
        }
     if(PLATSUMM.size()>0)
        {
     for(PLATFORM_SUMMARY_cls sobj:PLATSUMM)  // get all the partnumbers to be deleted 
          {
            partNumber_Set.add(platformMap.get(sobj.PART_NUMBER)); // store the unique part number ids in the set
            platformName_Set.add(sobj.PLATFORM); // store the unique platform in the set
          }
        }
   list<SPEX_DB_Platform_Summary__c> filteredlist = [select id from SPEX_DB_Platform_Summary__c where Part_Number__c in :partNumber_Set and Platform__c in :platformName_Set]; // get ids of existing data from the salesforce object to be deleted 
    
    if(filteredlist.size()>0)   
    delete filteredlist;
    
    rtn='Success!';
    }
        catch(exception e)
        {
            rtn='Failure deleting platform summary record(s): ';
            rtn=rtn+e;
        }
        return rtn;
    
  }
  
  
}