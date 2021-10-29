/**
* Description :webservice exposed to pi for passing screened address records back to sfdc.
                if ADDRESS_BLOCKED tag has value N the record is updated to released.
                else if ADDRESS_BLOCKED = Y and the spl_data_ref_id tag has a new value 
                not currently associated with the address record then address record
                 is updated to pending block but  if ADDRESS_BLOCKED = Y and 
                 if the spl_data_ref_id tag has a does not have
                 new value not currently associated with the address record then address record
                 is not updated
* Copyright : Wipro Technologies Limited Copyright (c) 2001 *
 * @author : Wipro
 * Modification Log ============ Ver Date Author Modification --- ---- ------ -------------* */ 

global class DeiniedPartyResponse{
        
/* Start: meta data classes for input structure */      
        global class ADDRNUMBER_cls
        {
        
            webservice  String ADDRESS_ID;
            webservice  String  BPTYP;
            webservice  String  BPVSY;
            webservice  String  ADDRESS_BLOCKED;
            webservice  String  USER_ACTION;
            webservice  String  RELEASE_REASON_SCHEMA;
            webservice  String  RELEASE_REASON;
            webservice  SPL_ENTITIY_cls[] SPL_ENTITIY;
        }
        
        global class SPL_ENTITIY_cls
        {
            webservice  String  LGREG;
            webservice  String  SPL_LIST_TYPE;
            webservice  String  SPL_PROVIDER_ID;
            webservice  String  SPL_DATA_REF_ID;
            webservice  String  SPL_ENTRY_DATE;
            webservice  String  SPL_TZONE_ENTRY;
            webservice  String  SPL_VALID_FROM;
            webservice  String  SPL_FILE_ID;
            webservice string SPL_COMMENT1;
            webservice string SPL_COMMENT2;
            webservice string SPL_COMMENT3;
            webservice  SPL_NAME_cls[] SPL_NAME;
            webservice  SPL_ADDRESS_cls[] SPL_ADDRESS;
        }
        global class SPL_NAME_cls
        {
            webservice  String  LAUNR;
            webservice  String  SPL_NAME1;
            webservice  String  SPL_ID_NUMBER;
        }
        global class SPL_ADDRESS_cls
        {
            webservice  String  LAUNR;
            webservice  String  SPL_STREET1;
            webservice  String  SPL_CITY;
            webservice  String  SPL_COUNTRY;
        }
 /* End: meta data classes for input structure */         
     
       webservice static String SPL_OFFLINE_SCREENING_RESULT(ADDRNUMBER_cls[] ADDRNUMBER) {
        String rtn=' ';//return variable set based on success/failure
        string fstaddr='';
        system.debug('*****Result****'+ADDRNUMBER);
        Set<String> AddrId_Set = new Set<String>();//Store all address id in the request
        Map<String,ADDRNUMBER_cls> AddridReq_Map = new Map<String,ADDRNUMBER_cls>();/*to store the addressid 
                                                                                     and corresponding request*/
        List<account_address__c> RelAddr_List = new List<Account_address__c>();/* store the address records 
                                                                                  to be released */
        Set<id> Addrid_remSplrefid_set = new set<id>();/* store the address id,(of released address) for which
                                                          spl_ref_id__c records are to be deleted*/ 
        DeiniedPartyResponse cls_obj= new DeiniedPartyResponse();//class obj to call methds defined for modularisation 
        Map<id,ADDRNUMBER_cls> Addrecordid_Req_Map = new Map<id,ADDRNUMBER_cls>();/*to store the sfdc addressid 
                                                                                     and corresponding request
                                                                                      for blocking*/
       try
       {
       
                                                             
        if(ADDRNUMBER.size()>0)
        {
        fstaddr = 'first address : '+ADDRNUMBER[0].ADDRESS_ID+'<--->';
        for(ADDRNUMBER_cls a:ADDRNUMBER)
          {
              AddrId_Set.add(a.ADDRESS_ID);
              AddridReq_Map.put(a.ADDRESS_ID,a);
              system.debug(a.ADDRESS_ID+',,,,,,'+a);
          }
       }   
          system.debug('++++'+AddrId_Set);
          list<account_address__c> filteredlistaccadr=[select id,name,Denied_Party_Status__c 
                                     from Account_address__c where
                                     (not (Report_Account_name__c like '%VARIOUS%'))
                                     and (not (Formula_Strategic_Business_Unit__c like '%Intercompany%'))
                                     and Name in :AddrId_Set
                                     and account_name__c !='' and AccountStatus__c!='Inactive' and Denied_Party_Status__c!='Whitelist'];
         if(AddrId_Set.size()>0) 
         for(account_address__c adr:filteredlistaccadr)
         {
             ADDRNUMBER_cls adr_temp = AddridReq_Map.get(adr.name);//temp variable to hold the addr req
             if(adr_temp.ADDRESS_BLOCKED=='N')
             {
                 adr.Denied_Party_Status__c='Released';
                 RelAddr_List.add(adr);
                 Addrid_remSplrefid_set.add(adr.id);
             }
             else if(adr_temp.ADDRESS_BLOCKED=='Y')
             {
                 Addrecordid_Req_Map.put(adr.id,AddridReq_Map.get(adr.name));
                  system.debug(adr.id+'_11__'+AddridReq_Map.get(adr.name));
             }
         
         }          
        rtn= rtn+cls_obj.ReleaseAddress_fn(RelAddr_List,Addrid_remSplrefid_set);
        rtn= rtn+cls_obj.BlockAddress_fn(Addrecordid_Req_Map);
        }
        catch(exception e)
        {
            rtn=rtn+e;
        }
        if(rtn==' ') 
            {
             DP_Error_Log__c elog = new DP_Error_Log__c();
            elog.time__c = datetime.now();
            elog.status__c = 'Inbound Success';
            if(string.valueof(rtn).length()>32766)
            elog.description__c = fstaddr + string.valueof(rtn.substring(0,32766));
            else 
            elog.description__c = fstaddr + string.valueof(rtn); 
            insert elog;
            return 'success';
            }
        else
             {
             DP_Error_Log__c elog = new DP_Error_Log__c();
            elog.time__c = datetime.now();
            elog.status__c = 'Inbound Failed';
            if(string.valueof(rtn).length()>32766)
            elog.description__c = fstaddr +string.valueof(rtn.substring(0,32766));
            else 
            elog.description__c =fstaddr + string.valueof(rtn);
            insert elog;
            return rtn;
            }
        }
        
        
 /* function to update address to released and remove the spl_ref_id__c rec's under the address*/       
        public string ReleaseAddress_fn(list<account_address__c> updreladdr,set<id> addrid)
        {
            String rtn='';//return value success/fail
            
            list<spl_ref_id__c> Spl_rem_list = new List<spl_ref_id__c>(); //to hold spl_ref_id__c to be removed
            try
            {
                if(addrid.size()>0)
                    Spl_rem_list=[select id from spl_ref_id__c where account_address__c in:addrid];
                if(Spl_rem_list.size()>0)
                    delete Spl_rem_list;
                if(updreladdr.size()>0)
                   update updreladdr;
                   
            /*  // fix for the denied party indicator trigger      
              map<integer,list<account_address__c>> brkup=new map<integer,list<account_address__c>>();
              list<account_address__c> l = new list<account_address__c>();
              integer ii =0,k=1;
              if(updreladdr.size()>0)
              for(account_address__c ad:updreladdr)
              {
                  l.add(ad);
                  ii++;
               if(ii==25)
                {
                    brkup.put(k,l);
                    l = new list<account_address__c>();
                    k++;
                    ii=0;
                }
                
              }
               brkup.put(k,l);
              
              for(integer i:brkup.keySet())
              {
                    update(brkup.get(i));
              }
              
              
           // fix end   
                    
              */      
            }
            catch(exception e)
            {
                rtn=''+e;
            }
            return rtn;
        }
/* function to update address to be blocked and add the spl_ref_id__c rec's under the address*/       
        public string BlockAddress_fn(Map<id,ADDRNUMBER_cls> UpdBlkAddr)
        {
            system.debug(UpdBlkAddr.keySet()+'___'+UpdBlkAddr);
            String rtn='';//return value success/fail
           
            List<account_address__c> BlkAddr_List = new List<Account_address__c>();/* store the address records 
                                                                                  to be blocked*/
            List<spl_ref_id__c> ins_splid_List = new List<spl_ref_id__c>();/* store the address records 
                                                                                  to be blocked*/
            set<id> dupidchk=new set<id>();
            Map<string,set<string>> adrsplforchk_map=new Map<string,set<string>>();//address id & set of splname
            
            list<spl_ref_id__c> Spl_add_list = new List<spl_ref_id__c>(); //to hold spl_ref_id__c to be removed
            try
            {
                if((UpdBlkAddr.keySet()).size()>0)
                    Spl_add_list=[select id,account_address__c,name from spl_ref_id__c 
                                  where account_address__c in:UpdBlkAddr.keySet()];
                
                system.debug(Spl_add_list.size()+'****'+UpdBlkAddr.keySet());
                                  
                for(spl_ref_id__c s:Spl_add_list)
                {   
                
                 system.debug(s.account_address__c+'____'+s.name);
                    if(adrsplforchk_map==null)
                    {
                        set<string> temp = new set<string>();
                        temp.add(s.name);
                        adrsplforchk_map.put(s.account_address__c,temp);
                    }
                     else
                     {
                        if(adrsplforchk_map.get(s.account_address__c)==null)
                        {
                            set<string> temp = new set<string>();
                            temp.add(s.name);
                            adrsplforchk_map.put(s.account_address__c,temp);
                        }
                        else
                            adrsplforchk_map.get(s.account_address__c).add(s.name);
                     }
                }
                system.debug('0******'+adrsplforchk_map);
                for(id i :UpdBlkAddr.keySet())
                {   
                     ADDRNUMBER_cls reqobj=UpdBlkAddr.get(i);
  
                    for(SPL_ENTITIY_cls sobj:reqobj.SPL_ENTITIY)
                    {
                           /* string d=sobj.SPL_ENTRY_DATE;//'20080430070044';
                            Date myDate;
                            try
                            {
                               myDate= date.newInstance(integer.valueof(d.substring(0,4)),integer.valueof(d.substring(4,6)),integer.valueof(d.substring(6,8)));//integer.valueof(d.substring(8,10))
                                //  integer.valueof(d.substring(10,12)),integer.valueof(d.substring(12,14)));
                                system.debug(d.substring(0,4)+d.substring(6,8)+d.substring(4,6)+d.substring(8,10)+d.substring(10,12)+d.substring(12,14)+'*****'+mydate);
                            }
                            catch(exception e)
                            {
                            }*/
                        
                        if(adrsplforchk_map.get(i)==null||!(adrsplforchk_map.get(i)).contains(sobj.SPL_DATA_REF_ID))
                        {    
                            if(dupidchk.size()>0)
                            {   
                                if(!dupidchk.contains(i))
                                {
                                    BlkAddr_List.add(new account_address__c(id=i,Denied_Party_Status__c='Pending Block'));
                                    dupidchk.add(i);
                                }
                            }  
                            else
                            {
                            dupidchk.add(i);
                            BlkAddr_List.add(new account_address__c(id=i,Denied_Party_Status__c='Pending Block'));
                            
                            } 
                            
                            if(sobj.SPL_NAME!=null)
                            for(SPL_NAME_cls snobj:sobj.SPL_NAME)
                            {
                                SPL_Ref_ID__c so = new SPL_Ref_ID__c();
                                so.Account_Address__c= i;
                                so.name=sobj.SPL_DATA_REF_ID;
                                so.SPL_ID_Number__c=snobj.SPL_ID_NUMBER;
                                so.Company_Name__c=snobj.SPL_NAME1;
                                so.SPL_Comment__c=sobj.SPL_COMMENT1;
                                so.SPL_Comment_2__c=sobj.SPL_COMMENT2;
                                so.SPL_Comment_3__c=sobj.SPL_COMMENT3;
                                so.name=sobj.SPL_DATA_REF_ID;
                                so.SPL_File_ID__c=sobj.SPL_FILE_ID;
                                so.SPL_Entry_Date__c=sobj.SPL_ENTRY_DATE;
                                so.SPL_List_Type__c=sobj.SPL_LIST_TYPE;
                                so.SPL_Provider_ID__c=sobj.SPL_PROVIDER_ID;
                                
                                ins_splid_List.add(so);
                            
                            } 
                            if(sobj.SPL_ADDRESS!=null)
                            for(SPL_ADDRESS_cls saobj:sobj.SPL_ADDRESS)
                            {
                                SPL_Ref_ID__c so = new SPL_Ref_ID__c();
                                so.Account_Address__c= i;
                                so.City__c=saobj.SPL_CITY;
                                so.Country__c=saobj.SPL_COUNTRY;
                                so.SPL_Comment__c=sobj.SPL_COMMENT1;
                                so.SPL_Comment_2__c=sobj.SPL_COMMENT2;
                                so.SPL_Comment_3__c=sobj.SPL_COMMENT3;
                                so.name=sobj.SPL_DATA_REF_ID;
                                so.SPL_Entry_Date__c=sobj.SPL_ENTRY_DATE;
                                so.SPL_File_ID__c=sobj.SPL_FILE_ID;
                                so.SPL_List_Type__c=sobj.SPL_LIST_TYPE;
                                so.SPL_Provider_ID__c=sobj.SPL_PROVIDER_ID;
                                ins_splid_List.add(so);
                                                
                            }
                             if(sobj.SPL_ADDRESS==null && sobj.SPL_NAME==null)
                             {
                                SPL_Ref_ID__c so = new SPL_Ref_ID__c();
                                so.Account_Address__c= i;
                                so.SPL_Comment_2__c=sobj.SPL_COMMENT2;
                                so.SPL_Comment_3__c=sobj.SPL_COMMENT3;
                                so.name=sobj.SPL_DATA_REF_ID;
                                so.SPL_Entry_Date__c=sobj.SPL_ENTRY_DATE;
                                so.SPL_File_ID__c=sobj.SPL_FILE_ID;
                                so.SPL_List_Type__c=sobj.SPL_LIST_TYPE;
                                so.SPL_Provider_ID__c=sobj.SPL_PROVIDER_ID;
                                ins_splid_List.add(so);
                             }
                        }
                    }
                }
                
                    system.debug('******ins'+ins_splid_List);
                    if(ins_splid_List.size()>0)
                        insert ins_splid_List;
                   if(BlkAddr_List.size()>0)
                        update BlkAddr_List;
                 
             /*      
            // fix for the denied party indicator trigger      
              map<integer,list<account_address__c>> brkup=new map<integer,list<account_address__c>>();
              list<account_address__c> l = new list<account_address__c>();
              integer ii =0,k=1;
              if(BlkAddr_List.size()>0)
              for(account_address__c ad:BlkAddr_List)
              {
                  l.add(ad);
                  ii++;
                if(ii==25)
                {
                    brkup.put(k,l);
                    l = new list<account_address__c>();
                    k++;
                    ii=0;
                }
                 
              }
               brkup.put(k,l);
              
              for(integer i:brkup.keySet())
              {
                  update(brkup.get(i));
              }
              
           // fix end   */
            }
            catch(exception e)
            {
                rtn=''+e;
            }
            
            return rtn;
        }        
}