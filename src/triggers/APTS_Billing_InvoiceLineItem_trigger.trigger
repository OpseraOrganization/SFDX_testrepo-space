trigger APTS_Billing_InvoiceLineItem_trigger on Apttus_Billing__InvoiceLineItem__c ( after insert, after update, before insert) {

    if(Trigger.isAfter){
        if(Trigger.isupdate){
            Product_Helper.processIs_License_Required(null,true,trigger.new,trigger.oldmap,false,null,null);
        }else if(Trigger.isInsert){
            Product_Helper.processIs_License_Required(null,true,trigger.new,null,false,null,null);
        }
    }
    //For insert 
    If(Trigger.isInsert && Trigger.isAfter){
        set<ID> invids=new set<ID>();
        Map<String,Apttus_Billing__InvoiceLineItem__c> invitemsmap2 = new Map<String,Apttus_Billing__InvoiceLineItem__c>();
        //for(Apttus_Billing__InvoiceLineItem__c invitem: [select id, Apttus_Billing__InvoiceId__r.id from Apttus_Billing__InvoiceLineItem__c where id in:trigger.newmap.keyset() Order By createddate ASC]){            
           Set<Id> invoicelineitemid = New  Set<Id>();
        for(Apttus_Billing__InvoiceLineItem__c invitem:trigger.new){
            invids.add(invitem.Apttus_Billing__InvoiceId__c);
          
            invoicelineitemid.Add(invitem.id);
            
        }        
        system.debug('invids--'+invids);
         system.debug('invoicelineitemid--'+invoicelineitemid);
        APTS_NGBSS_Company_Master_Data__c  CMD; 
        Company_Header_info__c CH;
        Apttus_Billing__InvoiceLineItem__c BillingInvoiceLine = [Select id,LockBox_Number__c,Apttus_Billing__BillingScheduleId__r.Apttus_Billing__OrderLineItemId__r.Apttus_Config2__OrderId__r.id,Apttus_Billing__AssetLineItemId__r.Apttus_Config2__ProductId__r.Plant__c from Apttus_Billing__InvoiceLineItem__c Where id In:invoicelineitemid limit 1 ];
         system.debug('invids--'+BillingInvoiceLine );
        String  plant = String.valueOf(BillingInvoiceLine.Apttus_Billing__AssetLineItemId__r.Apttus_Config2__ProductId__r.Plant__c); 
        IF(plant != Null && plant != '')
        {
        CH = [Select id,Head_Address__c,Name From Company_Header_info__c Where Name =: plant limit 1];
        } 
        If(BillingInvoiceLine.LockBox_Number__c != Null && BillingInvoiceLine.LockBox_Number__c !='')
        {
        CMD = [Select id,Name,APTS_NGBSS_Sales_Org__c,APTS_NGBSS_LockBox_Number__c,APTS_NGBSS_Currency__c from APTS_NGBSS_Company_Master_Data__c where Name =: BillingInvoiceLine.LockBox_Number__c limit 1];
        }
        system.debug('CMD --'+CMD );       
        system.debug('invids--'+invids);
        list<Apttus_Billing__Invoice__c> updateinvs= new list<Apttus_Billing__Invoice__c>();
        List<Apttus_Billing__Invoice__c> invList = [select id,Plant__c,Card_Holder_Name__c,APTS_Sales_Org__c,Apttus_Billing__SoldToAccountId__c,Authorization_Code__c,Authorization_Reference_Code__c,
                                                    APTS_PO_Date__c,Apttus_Billing__PONumber__c,Order_Number__c,Card_Token__c,Card_Type__c,ValidTo__c,SendToSAP__c,CC_Amount__c,
                                                    Price_List__c,Apttus_Billing__SoldToCity__c,Apttus_Billing__SoldToStreet__c,APTS_Company_Master_Data__c,
                                                    Apttus_Billing__SoldToState__c,Apttus_Billing__SoldToCountry__c,Apttus_Billing__SoldToPostalCode__c,
                                                    Apttus_Billing__BillingCity__c,Apttus_Billing__BillingStreet__c,Apttus_Billing__BillingState__c,
                                                    Apttus_Billing__BillingCountry__c,Apttus_Billing__BillingPostalCode__c,
                                                    Apttus_Billing__ShipToCity__c,Apttus_Billing__ShipToStreet__c,Apttus_Billing__ShipToState__c,
                                                    Apttus_Billing__ShipToCountry__c,Apttus_Billing__ShipToPostalCode__c,Order_record__c,
                                                    SoldTo_SAP_Account_Name__c,BillTo_SAP_Account_Name__c,ShipTo_SAP_Account_Name__c,   
                                                    SoldTo_Number__c,BillTo_Number__c,ShipTo_Number__c,Plant_code__c,
                                                    (select id, name,APTS_Sales_Org__c,Send_INV_To_SAP__c,APTS_PO_Date__c,Order_Number__c,APTS_PO_Number__c,                                                 
                                                    Apttus_Billing__AssetLineItemId__r.Apttus_Config2__ProductId__r.Plant__c,Apttus_Billing__SoldToAccountId__c,
                                                    Apttus_Billing__BillingScheduleId__r.Apttus_Billing__OrderLineItemId__r.Apttus_Config2__PriceListId__r.Name,
                                                    Apttus_Billing__SoldToCity__c,Apttus_Billing__SoldToStreet__c,LockBox_Number__c,
                                                    Apttus_Billing__SoldToState__c,Apttus_Billing__SoldToCountry__c,Apttus_Billing__SoldToPostalCode__c,
                                                    Apttus_Billing__BillingCity__c,Apttus_Billing__BillingStreet__c,Apttus_Billing__BillingState__c,
                                                    Apttus_Billing__BillingCountry__c,Apttus_Billing__BillingPostalCode__c,
                                                    Apttus_Billing__ShipToCity__c,Apttus_Billing__ShipToStreet__c,Apttus_Billing__ShipToState__c,
                                                    Apttus_Billing__ShipToCountry__c,Apttus_Billing__ShipToPostalCode__c,
                                                    SoldTo_SAP_Account_Name__c,BillTo_SAP_Account_Name__c,ShipTo_SAP_Account_Name__c,
                                                    SoldTo_Number__c,BillTo_Number__c,ShipTo_Number__c,
                                                    Apttus_Billing__AssetLineItemId__r.Apttus_Config2__ProductId__r.Assignment__c,
                                                    Apttus_Billing__AssetLineItemId__r.Apttus_Config2__ProductId__r.Inte__c,
                                                    Apttus_Billing__BillingScheduleId__r.Apttus_Billing__OrderLineItemId__r.Apttus_Config2__OrderId__r.Card_Holder_Name__c,
                                                    Apttus_Billing__BillingScheduleId__r.Apttus_Billing__OrderLineItemId__r.Apttus_Config2__OrderId__r.Card_Token__c,
                                                    Apttus_Billing__BillingScheduleId__r.Apttus_Billing__OrderLineItemId__r.Apttus_Config2__OrderId__r.cardType__c,
                                                    Apttus_Billing__BillingScheduleId__r.Apttus_Billing__OrderLineItemId__r.Apttus_Config2__OrderId__r.ValidTo__c,
                                                    Apttus_Billing__BillingScheduleId__r.Apttus_Billing__OrderLineItemId__r.Apttus_Config2__OrderId__r.Authorization_Code__c,
                                                    Apttus_Billing__BillingScheduleId__r.Apttus_Billing__OrderLineItemId__r.Apttus_Config2__OrderId__r.Authorization_Reference_Code__c,
                                                    Apttus_Billing__BillingScheduleId__r.Apttus_Billing__OrderLineItemId__r.Apttus_Config2__OrderId__r.CC_Amount__c
                                                    from Apttus_Billing__InvoiceLineItems__r Order By createddate ASC) from Apttus_Billing__Invoice__c where id in:invids]; 
        
        for(Apttus_Billing__Invoice__c inv:invList){
            system.debug('inv'+inv);
            //boolean cardupdate= true;
            //boolean assigmtupdate= true;
            //boolean plant= true;
            boolean poupdate=true;
            boolean sendSAP=true;
            
            for(Integer i=1; i<inv.Apttus_Billing__InvoiceLineItems__r.size(); i++){
                /*if(inv.Apttus_Billing__InvoiceLineItems__r[i].Card_Holder_Name__c != inv.Apttus_Billing__InvoiceLineItems__r[0].Card_Holder_Name__c 
                   || inv.Apttus_Billing__InvoiceLineItems__r[i].Card_Token__c != inv.Apttus_Billing__InvoiceLineItems__r[0].Card_Token__c 
                   || inv.Apttus_Billing__InvoiceLineItems__r[i].Card_Type__c != inv.Apttus_Billing__InvoiceLineItems__r[0].Card_Type__c 
                   || inv.Apttus_Billing__InvoiceLineItems__r[i].ValidTo__c != inv.Apttus_Billing__InvoiceLineItems__r[0].ValidTo__c ){
                       cardupdate= false;
                   }*/
                   inv.Order_Number__c = inv.Apttus_Billing__InvoiceLineItems__r[0].Order_Number__c;
                   if(inv.Apttus_Billing__InvoiceLineItems__r[i].APTS_PO_Date__c!= inv.Apttus_Billing__InvoiceLineItems__r[0].APTS_PO_Date__c
                   || inv.Apttus_Billing__InvoiceLineItems__r[i].APTS_PO_Number__c!= inv.Apttus_Billing__InvoiceLineItems__r[0].APTS_PO_Number__c){ 
                       poupdate= false;
                   }
                /*if(inv.Apttus_Billing__InvoiceLineItems__r[i].Assignment__c != inv.Apttus_Billing__InvoiceLineItems__r[0].Assignment__c 
                   || inv.Apttus_Billing__InvoiceLineItems__r[i].InternalsalesHdrInstrn__c != inv.Apttus_Billing__InvoiceLineItems__r[0].InternalsalesHdrInstrn__c){
                       assigmtupdate= false;
                   }*/
                /*if(inv.Apttus_Billing__InvoiceLineItems__r[i].Plant__c != inv.Apttus_Billing__InvoiceLineItems__r[0].Plant__c){
                       plant= false;
                   }*/
                if(inv.Apttus_Billing__InvoiceLineItems__r[i].Send_INV_To_SAP__c != inv.Apttus_Billing__InvoiceLineItems__r[0].Send_INV_To_SAP__c){
                       sendSAP= false;
                   }
            }
            IF(inv.Apttus_Billing__InvoiceLineItems__r[0].APTS_Sales_Org__c != Null)
            {
              Inv.APTS_Sales_Org__c = inv.Apttus_Billing__InvoiceLineItems__r[0].APTS_Sales_Org__c;
            }
            //if(cardupdate== true){
                inv.Card_Holder_Name__c = inv.Apttus_Billing__InvoiceLineItems__r[0].Apttus_Billing__BillingScheduleId__r.Apttus_Billing__OrderLineItemId__r.Apttus_Config2__OrderId__r.Card_Holder_Name__c;
                inv.Card_Token__c = inv.Apttus_Billing__InvoiceLineItems__r[0].Apttus_Billing__BillingScheduleId__r.Apttus_Billing__OrderLineItemId__r.Apttus_Config2__OrderId__r.Card_Token__c;
                inv.Card_Type__c = inv.Apttus_Billing__InvoiceLineItems__r[0].Apttus_Billing__BillingScheduleId__r.Apttus_Billing__OrderLineItemId__r.Apttus_Config2__OrderId__r.cardType__c;
                inv.ValidTo__c = inv.Apttus_Billing__InvoiceLineItems__r[0].Apttus_Billing__BillingScheduleId__r.Apttus_Billing__OrderLineItemId__r.Apttus_Config2__OrderId__r.ValidTo__c;
                inv.Authorization_Code__c = inv.Apttus_Billing__InvoiceLineItems__r[0].Apttus_Billing__BillingScheduleId__r.Apttus_Billing__OrderLineItemId__r.Apttus_Config2__OrderId__r.Authorization_Code__c;
                inv.Authorization_Reference_Code__c = inv.Apttus_Billing__InvoiceLineItems__r[0].Apttus_Billing__BillingScheduleId__r.Apttus_Billing__OrderLineItemId__r.Apttus_Config2__OrderId__r.Authorization_Reference_Code__c;
                If(inv.Apttus_Billing__InvoiceLineItems__r[0].Apttus_Billing__BillingScheduleId__r.Apttus_Billing__OrderLineItemId__r.Apttus_Config2__OrderId__r.CC_Amount__c != Null && inv.Apttus_Billing__InvoiceLineItems__r[0].Apttus_Billing__BillingScheduleId__r.Apttus_Billing__OrderLineItemId__r.Apttus_Config2__OrderId__r.CC_Amount__c != ''){
                inv.CC_Amount__c= inv.Apttus_Billing__InvoiceLineItems__r[0].Apttus_Billing__BillingScheduleId__r.Apttus_Billing__OrderLineItemId__r.Apttus_Config2__OrderId__r.CC_Amount__c;
                }
            /*}else{
                inv.Card_Holder_Name__c = '';
                inv.Card_Token__c = '';
                inv.Card_Type__c = '';
                inv.ValidTo__c = '';
            }*/
            if(poupdate== true){
                inv.APTS_PO_Date__c = inv.Apttus_Billing__InvoiceLineItems__r[0].APTS_PO_Date__c;
                inv.Apttus_Billing__PONumber__c = inv.Apttus_Billing__InvoiceLineItems__r[0].APTS_PO_Number__c;
                
            }else{
                //inv.APTS_PO_Date__c = '';
                inv.Apttus_Billing__PONumber__c = '';
                 }
            //if(assigmtupdate == true){
                //inv.Assignment__c = inv.Apttus_Billing__InvoiceLineItems__r[0].Assignment__c;
                //inv.InternalsalesHdrInstrn__c = inv.Apttus_Billing__InvoiceLineItems__r[0].InternalsalesHdrInstrn__c;
                
                inv.Assignment__c = inv.Apttus_Billing__InvoiceLineItems__r[0].Apttus_Billing__AssetLineItemId__r.Apttus_Config2__ProductId__r.Assignment__c;
                inv.InternalsalesHdrInstrn__c = inv.Apttus_Billing__InvoiceLineItems__r[0].Apttus_Billing__AssetLineItemId__r.Apttus_Config2__ProductId__r.Inte__c;
                
           /* }else{
                inv.Assignment__c = '';
                inv.InternalsalesHdrInstrn__c = '';
            }*/
            //if(plant == true){
                inv.Plant__c = inv.Apttus_Billing__InvoiceLineItems__r[0].Apttus_Billing__AssetLineItemId__r.Apttus_Config2__ProductId__r.Plant__c;
            /*}else{
                inv.Plant__c = 0;
            }*/
            if(sendSAP == true){
                inv.SendToSAP__c = inv.Apttus_Billing__InvoiceLineItems__r[0].Send_INV_To_SAP__c;
            }else{
                inv.SendToSAP__c = false;
            }
            
            inv.Price_List__c = inv.Apttus_Billing__InvoiceLineItems__r[0].Apttus_Billing__BillingScheduleId__r.Apttus_Billing__OrderLineItemId__r.Apttus_Config2__PriceListId__r.Name;
            //inv.SoldToXref__c = inv.Apttus_Billing__InvoiceLineItems__r[0].SoldToXref__c ;
            
            //Updating SoldTo Details
            inv.Apttus_Billing__SoldToCity__c = inv.Apttus_Billing__InvoiceLineItems__r[0].Apttus_Billing__SoldToCity__c;
            inv.Apttus_Billing__SoldToStreet__c = inv.Apttus_Billing__InvoiceLineItems__r[0].Apttus_Billing__SoldToStreet__c;
            inv.Apttus_Billing__SoldToState__c =  inv.Apttus_Billing__InvoiceLineItems__r[0].Apttus_Billing__SoldToState__c;
            inv.Apttus_Billing__SoldToCountry__c =  inv.Apttus_Billing__InvoiceLineItems__r[0].Apttus_Billing__SoldToCountry__c;
            inv.Apttus_Billing__SoldToPostalCode__c =  inv.Apttus_Billing__InvoiceLineItems__r[0].Apttus_Billing__SoldToPostalCode__c;
                    
            //Updating BillTo Details        
             inv.Apttus_Billing__BillingCity__c =  inv.Apttus_Billing__InvoiceLineItems__r[0].Apttus_Billing__BillingCity__c;
             inv.Apttus_Billing__BillingStreet__c =  inv.Apttus_Billing__InvoiceLineItems__r[0].Apttus_Billing__BillingStreet__c;
             inv.Apttus_Billing__BillingState__c =  inv.Apttus_Billing__InvoiceLineItems__r[0].Apttus_Billing__BillingState__c;
             inv.Apttus_Billing__BillingCountry__c =  inv.Apttus_Billing__InvoiceLineItems__r[0].Apttus_Billing__BillingCountry__c;
             inv.Apttus_Billing__BillingPostalCode__c =  inv.Apttus_Billing__InvoiceLineItems__r[0].Apttus_Billing__BillingPostalCode__c;
             inv.Order_Number__c =  inv.Apttus_Billing__InvoiceLineItems__r[0].Order_Number__c;
             inv.Order_record__c = BillingInvoiceLine.Apttus_Billing__BillingScheduleId__r.Apttus_Billing__OrderLineItemId__r.Apttus_Config2__OrderId__r.id;
              If(CMD != Null && (inv.Price_List__c == 'Aspire PriceList' || inv.Price_List__c == 'Aspire PriceList_SAPOrders'))
             {
             inv.APTS_Company_Master_Data__c =  CMD.id;    
             
             }
             IF(CH != Null && (inv.Price_List__c == 'Aspire PriceList' || inv.Price_List__c == 'Aspire PriceList_SAPOrders'))
             {
              inv.Plant_code__c = CH.id;  
             }   
            //Updating ShipTo Details       
            inv.Apttus_Billing__ShipToCity__c =  inv.Apttus_Billing__InvoiceLineItems__r[0].Apttus_Billing__ShipToCity__c;
            inv.Apttus_Billing__ShipToStreet__c =  inv.Apttus_Billing__InvoiceLineItems__r[0].Apttus_Billing__ShipToStreet__c;
            inv.Apttus_Billing__ShipToState__c =  inv.Apttus_Billing__InvoiceLineItems__r[0].Apttus_Billing__ShipToState__c;
            inv.Apttus_Billing__ShipToCountry__c =  inv.Apttus_Billing__InvoiceLineItems__r[0].Apttus_Billing__ShipToCountry__c;
            inv.Apttus_Billing__ShipToPostalCode__c =  inv.Apttus_Billing__InvoiceLineItems__r[0].Apttus_Billing__ShipToPostalCode__c;
             
            //Updating Account Names
            
            inv.SoldTo_SAP_Account_Name__c = inv.Apttus_Billing__InvoiceLineItems__r[0].SoldTo_SAP_Account_Name__c;
            inv.BillTo_SAP_Account_Name__c = inv.Apttus_Billing__InvoiceLineItems__r[0].BillTo_SAP_Account_Name__c;
            inv.ShipTo_SAP_Account_Name__c = inv.Apttus_Billing__InvoiceLineItems__r[0].ShipTo_SAP_Account_Name__c;
            
            //Updating SAP Account Numbers
            inv.SoldTo_Number__c = inv.Apttus_Billing__InvoiceLineItems__r[0].SoldTo_Number__c;
            inv.BillTo_Number__c = inv.Apttus_Billing__InvoiceLineItems__r[0].BillTo_Number__c;
            inv.ShipTo_Number__c = inv.Apttus_Billing__InvoiceLineItems__r[0].ShipTo_Number__c;
            
            //update Soldto Account
            inv.Apttus_Billing__SoldToAccountId__c = inv.Apttus_Billing__InvoiceLineItems__r[0].Apttus_Billing__SoldToAccountId__c;
            
            updateinvs.add(inv);
            system.debug('In Invoice LI after insert trigger '+ updateinvs);
        }
        if(updateinvs!=null && updateinvs.size()>0){
            update updateinvs;
        }
      }
    
    If(Trigger.isInsert && Trigger.isBefore){
    
       system.debug('InvoiceLineItem before insert trigger');
    
       Set<ID> bsIds = new Set<ID>();
       for(Apttus_Billing__InvoiceLineItem__c invLi:Trigger.New){
            bsIds.add(invLi.Apttus_Billing__BillingScheduleId__c);        
            
         }
         system.debug('bsids are '+bsIds);
        List<Apttus_Billing__BillingSchedule__c> bsList = [Select id,
                                                            Apttus_Billing__OrderLineItemId__r.Apttus_Config2__OrderId__r.Generic_xref_SoldTo__c,
                                                            Apttus_Billing__OrderLineItemId__r.Apttus_Config2__OrderId__r.Generic_xref_BillTo__c,
                                                            Apttus_Billing__OrderLineItemId__r.Apttus_Config2__OrderId__r.Generic_xref_ShipTo__c,
                                                            Apttus_Billing__OrderLineItemId__r.Apttus_Config2__OrderId__r.Sold_To_City__c,
                                                            Apttus_Billing__OrderLineItemId__r.Apttus_Config2__OrderId__r.Sold_To_Street__c,
                                                            Apttus_Billing__OrderLineItemId__r.Apttus_Config2__OrderId__r.Sold_To_State__c,
                                                            Apttus_Billing__OrderLineItemId__r.Apttus_Config2__OrderId__r.Sold_To_Country__c,
                                                            Apttus_Billing__OrderLineItemId__r.Apttus_Config2__OrderId__r.Sold_To_Postal_Code__c,
                                                            Apttus_Billing__OrderLineItemId__r.Apttus_Config2__OrderId__r.Billing_City__c,
                                                            Apttus_Billing__OrderLineItemId__r.Apttus_Config2__OrderId__r.Billing_Street__c,
                                                            Apttus_Billing__OrderLineItemId__r.Apttus_Config2__OrderId__r.Billing_State__c,
                                                            Apttus_Billing__OrderLineItemId__r.Apttus_Config2__OrderId__r.Billing_Country__c,
                                                            Apttus_Billing__OrderLineItemId__r.Apttus_Config2__OrderId__r.Billing_Postal_Code__c,
                                                            Apttus_Billing__OrderLineItemId__r.Apttus_Config2__OrderId__r.Ship_To_City__c,
                                                            Apttus_Billing__OrderLineItemId__r.Apttus_Config2__OrderId__r.Name,
                                                            Apttus_Billing__OrderLineItemId__r.Apttus_Config2__OrderId__r.Ship_To_Street__c,
                                                            Apttus_Billing__OrderLineItemId__r.Apttus_Config2__OrderId__r.Ship_To_State__c,
                                                            Apttus_Billing__OrderLineItemId__r.Apttus_Config2__OrderId__r.Ship_To_Country__c,
                                                            Apttus_Billing__OrderLineItemId__r.Apttus_Config2__OrderId__r.Ship_To_Postal_Code__c,
                                                            Apttus_Billing__OrderLineItemId__r.Apttus_Config2__OrderId__r.SoldTo_SAP_Account_Name__c,
                                                            Apttus_Billing__OrderLineItemId__r.Apttus_Config2__OrderId__r.BillTo_SAP_Account_Name__c,
                                                            Apttus_Billing__OrderLineItemId__r.Apttus_Config2__OrderId__r.ShipTo_SAP_Account_Name__c
                                                            from Apttus_Billing__BillingSchedule__c where ID IN:bsIds];
        
        system.debug('bsList is '+bsList);
        for(Apttus_Billing__InvoiceLineItem__c invLI:Trigger.New){
            for(Apttus_Billing__BillingSchedule__c bs:bsList){
            
                system.debug('invLI.Apttus_Billing__BillingScheduleId__c '+invLI.Apttus_Billing__BillingScheduleId__c);
                system.debug('bs.id '+ bs.id);
                
                if(invLI.Apttus_Billing__BillingScheduleId__c == bs.id){
                    if(bs.Apttus_Billing__OrderLineItemId__r.Apttus_Config2__OrderId__r.Generic_xref_SoldTo__c == true){
                   
                        system.debug('if - invLI.Apttus_Billing__BillingScheduleId__c '+invLI.Apttus_Billing__BillingScheduleId__c);
                        system.debug('if - bs.id '+ bs.id);
                        
                        invLI.Apttus_Billing__SoldToCity__c = bs.Apttus_Billing__OrderLineItemId__r.Apttus_Config2__OrderId__r.Sold_To_City__c;
                        invLi.Apttus_Billing__SoldToStreet__c = bs.Apttus_Billing__OrderLineItemId__r.Apttus_Config2__OrderId__r.Sold_To_Street__c;
                        invLI.Apttus_Billing__SoldToState__c = bs.Apttus_Billing__OrderLineItemId__r.Apttus_Config2__OrderId__r.Sold_To_State__c;
                        invLi.Apttus_Billing__SoldToCountry__c = bs.Apttus_Billing__OrderLineItemId__r.Apttus_Config2__OrderId__r.Sold_To_Country__c;
                        invLi.Apttus_Billing__SoldToPostalCode__c = bs.Apttus_Billing__OrderLineItemId__r.Apttus_Config2__OrderId__r.Sold_To_Postal_Code__c;
                    }
                    if(bs.Apttus_Billing__OrderLineItemId__r.Apttus_Config2__OrderId__r.Generic_xref_BillTo__c == true){

                        invLI.Apttus_Billing__BillingCity__c = bs.Apttus_Billing__OrderLineItemId__r.Apttus_Config2__OrderId__r.Billing_City__c;
                        invLi.Apttus_Billing__BillingStreet__c = bs.Apttus_Billing__OrderLineItemId__r.Apttus_Config2__OrderId__r.Billing_Street__c;
                        invLI.Apttus_Billing__BillingState__c = bs.Apttus_Billing__OrderLineItemId__r.Apttus_Config2__OrderId__r.Billing_State__c;
                        invLi.Apttus_Billing__BillingCountry__c = bs.Apttus_Billing__OrderLineItemId__r.Apttus_Config2__OrderId__r.Billing_Country__c;
                        invLi.Apttus_Billing__BillingPostalCode__c = bs.Apttus_Billing__OrderLineItemId__r.Apttus_Config2__OrderId__r.Billing_Postal_Code__c;
                    }
                    if(bs.Apttus_Billing__OrderLineItemId__r.Apttus_Config2__OrderId__r.Generic_xref_ShipTo__c == true){
             
                        invLI.Apttus_Billing__ShipToCity__c = bs.Apttus_Billing__OrderLineItemId__r.Apttus_Config2__OrderId__r.Ship_To_City__c;
                        invLi.Apttus_Billing__ShipToStreet__c = bs.Apttus_Billing__OrderLineItemId__r.Apttus_Config2__OrderId__r.Ship_To_Street__c;
                        invLI.Apttus_Billing__ShipToState__c = bs.Apttus_Billing__OrderLineItemId__r.Apttus_Config2__OrderId__r.Ship_To_State__c;
                        invLi.Apttus_Billing__ShipToCountry__c = bs.Apttus_Billing__OrderLineItemId__r.Apttus_Config2__OrderId__r.Ship_To_Country__c;
                        invLi.Apttus_Billing__ShipToPostalCode__c = bs.Apttus_Billing__OrderLineItemId__r.Apttus_Config2__OrderId__r.Ship_To_Postal_Code__c;
                    }
                    
                    invLI.SoldTo_SAP_Account_Name__c = bs.Apttus_Billing__OrderLineItemId__r.Apttus_Config2__OrderId__r.SoldTo_SAP_Account_Name__c;
                    invLI.BillTo_SAP_Account_Name__c = bs.Apttus_Billing__OrderLineItemId__r.Apttus_Config2__OrderId__r.BillTo_SAP_Account_Name__c;
                    invLI.ShipTo_SAP_Account_Name__c = bs.Apttus_Billing__OrderLineItemId__r.Apttus_Config2__OrderId__r.ShipTo_SAP_Account_Name__c;
 

                    break;
                }
            }
        }    
        
    }
}