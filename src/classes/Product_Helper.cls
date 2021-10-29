//update Is_License_Required in invoice : Invoice-->All line items-->AssetLineItem-->Option -->Is_License_Required
public class Product_Helper {
    @InvocableMethod
    public static void checkIs_License_Required(list<product2> prodids){
        String Invoice1;
        String Invoice2;
        String Invoice3;
        String Invoice4;
        String Invoice5;
        String Invoice6;
        String Invoice7;
        String Invoice8;
        String Invoice9;
        String Invoice10; 
        Product_Helper.processIs_License_Required(prodids,false,null,null,false,null,null);
    }
    
    //Calling this method when product-->License changes and invoicelineitem--> AssetLineItem changes and AssetLineItem -->option(product) changes
    public static void processIs_License_Required(list<product2> prodids,boolean lineitems,list<Apttus_Billing__InvoiceLineItem__c> items,Map<ID, Apttus_Billing__InvoiceLineItem__c> olditemsMap,boolean AssetLineItem,list<Apttus_Config2__AssetLineItem__c> assertitems,Map<ID, Apttus_Config2__AssetLineItem__c> oldassertitemsMap){
        list<id> ivsids= new list<id>();
        String Invoice1;
        String Invoice2;
        String Invoice3;
        String Invoice4;
        String Invoice5;
        String Invoice6;
        String Invoice7;
        String Invoice8;
        String Invoice9;
        String Invoice10;
        String Invoice11; 
        String Invoice12;
        String Invoice13;
        String Invoice14;
        String Invoice15;
        String Invoice16;
        String Invoice17;
        String Invoice18;
        String Invoice19;
        String Invoice20;
        map<id,boolean> mapprods=new map<id,boolean>();
        if(prodids!=null){
            system.debug('prodids=='+prodids);
            for(product2 prd:prodids){
                mapprods.put(prd.id,prd.Is_License_Required__c);
            }
            map<id,list<Apttus_Billing__InvoiceLineItem__c>> mapinviditems=new map<id,list<Apttus_Billing__InvoiceLineItem__c>>();//invoice id and line items
            for(Apttus_Billing__InvoiceLineItem__c ili:[select id,Apttus_Billing__InvoiceId__c from Apttus_Billing__InvoiceLineItem__c where Apttus_Billing__AssetLineItemId__r.Apttus_Config2__OptionId__c in:mapprods.keyset()]){
                ivsids.add(ili.Apttus_Billing__InvoiceId__c);
            }
        }
        //for Apttus_Billing__InvoiceLineItem__c and Apttus_Config2__AssetLineItem__c chnages call from triggers
        // calling from Apttus_Billing__InvoiceLineItem__c trigger
        if(lineitems){
            for( Apttus_Billing__InvoiceLineItem__c ili :items){
                if(olditemsMap==null){
                    ivsids.add(ili.Apttus_Billing__InvoiceId__c);
                }else if(olditemsMap!=null && olditemsMap.get(ili.id).Apttus_Billing__AssetLineItemId__c != ili.Apttus_Billing__AssetLineItemId__c){
                    ivsids.add(ili.Apttus_Billing__InvoiceId__c);
                }
            }
        } 
        //calling from Apttus_Config2__AssetLineItem__c trigger
        if(AssetLineItem){
            list<ID> litids=new list<ID>();
            system.debug('assertitems'+assertitems);
            system.debug('oldassertitemsMap'+oldassertitemsMap);
            for( Apttus_Config2__AssetLineItem__c assetili :assertitems){
                if(oldassertitemsMap==null){ 
                    litids.add(assetili.id); 
                }else if(oldassertitemsMap.get(assetili.id).Apttus_Config2__OptionId__c != assetili.Apttus_Config2__OptionId__c){
                    litids.add(assetili.id);
                }
            }
            system.debug('litids'+litids);
            for(Apttus_Billing__InvoiceLineItem__c ili:[select id,Apttus_Billing__InvoiceId__c from Apttus_Billing__InvoiceLineItem__c where Apttus_Billing__AssetLineItemId__c in:litids]){
                ivsids.add(ili.Apttus_Billing__InvoiceId__c);
            }
        }
        system.debug('ivsids'+ivsids);
        //main logic
        list<Apttus_Billing__Invoice__c>  finalinvs=  new list<Apttus_Billing__Invoice__c> ();
        for( Apttus_Billing__Invoice__c inv:[select id,Is_License_Required__c,(Select id,Apttus_Billing__AssetLineItemId__r.Apttus_Config2__OptionId__r.Is_License_Required__c from Apttus_Billing__InvoiceLineItems__r) from Apttus_Billing__Invoice__c where id in:ivsids]){
            boolean Is_License_Required=false;
            for(Apttus_Billing__InvoiceLineItem__c item:inv.Apttus_Billing__InvoiceLineItems__r){
                if(item.Apttus_Billing__AssetLineItemId__r.Apttus_Config2__OptionId__r.Is_License_Required__c){
                    Is_License_Required=true;
                }
            }
            if(Is_License_Required!=inv.Is_License_Required__c){
                inv.Is_License_Required__c=Is_License_Required;
                finalinvs.add(inv);
            }
        }
        if(finalinvs.size()>0){
            update finalinvs;
        } 
    }
}