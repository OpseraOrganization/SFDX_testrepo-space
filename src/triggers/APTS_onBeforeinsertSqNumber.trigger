trigger APTS_onBeforeinsertSqNumber on Apttus_Billing__InvoiceLineItem__c (before insert) 
{
    map<id,Integer> mapIdtoNumber= new map<id,integer>();
    map<decimal,id> mapLineitemIdtoinvId= new map<decimal,id>();
    decimal i=1;
    for(Apttus_Billing__InvoiceLineItem__c obj:trigger.new)
    {
        if(obj.Apttus_Billing__InvoiceId__c!=null)
        {
            mapIdtoNumber.put(obj.Apttus_Billing__InvoiceId__c,10);
            mapLineitemIdtoinvId.put(i,obj.Apttus_Billing__InvoiceId__c);
            obj.APTS_Number_Increment__c=i;
            obj.APTS_Sequence_Line_Number_Trigger__c=0;
            i++;
        }
    }
    map<id,Integer> mapIdtoNumber1= new map<id,integer>();
    if(mapIdtoNumber!=null && !mapIdtoNumber.isempty() && mapLineitemIdtoinvId!=null && !mapLineitemIdtoinvId.isempty())
    {    
        for(Apttus_Billing__InvoiceLineItem__c obj:trigger.new)
        {
            if(mapLineitemIdtoinvId.get(obj.APTS_Number_Increment__c)!=null && obj.Apttus_Billing__InvoiceId__c==mapLineitemIdtoinvId.get(obj.APTS_Number_Increment__c))
            {
                if(mapIdtoNumber1!=null && !mapIdtoNumber1.isEmpty() && mapIdtoNumber1.get(obj.Apttus_Billing__InvoiceId__c)!=null)
                	obj.APTS_Sequence_Line_Number_Trigger__c+=mapIdtoNumber1.get(obj.Apttus_Billing__InvoiceId__c);
                else
                    obj.APTS_Sequence_Line_Number_Trigger__c+=mapIdtoNumber.get(obj.Apttus_Billing__InvoiceId__c);
                if (mapIdtoNumber1.containsKey(obj.Apttus_Billing__InvoiceId__c))
                		mapIdtoNumber1.put(obj.Apttus_Billing__InvoiceId__c,mapIdtoNumber1.get(obj.Apttus_Billing__InvoiceId__c)+10);
                else
                    mapIdtoNumber1.put(obj.Apttus_Billing__InvoiceId__c,mapIdtoNumber.get(obj.Apttus_Billing__InvoiceId__c)+10);
            }
        }
    }
}