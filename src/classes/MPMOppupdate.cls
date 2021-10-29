@RestResource(urlMapping='/MPMOppupdate/*')
global with sharing class MPMOppupdate {
    @HttpPost
    global static  List<opportunity> MPMOppupdate(string oppNumber,string Contract,string dealphase,string status,string invoiceno) {           
        List<opportunity> opp=[select id,Opportunity_Number__c,HIPI_CONTRACT_NUMBER__c,Deal_Status__c,stagename,Contract_Number__c,lic_to_IP_agreements__c,Invoice__c from opportunity where Opportunity_Number__c=:oppNumber limit 1];     
        Date today1 = date.valueof(system.today());
        if(
           (Contract != null && Contract != '' && opp[0].HIPI_CONTRACT_NUMBER__c == null ) ||
           (invoiceno != null && invoiceno != '' && opp[0].Invoice__c == null ) ||
           ((dealphase == 'Closed/Won' || dealphase == 'Closed/Lost' || dealphase == 'Closed Won' || dealphase == 'Closed Lost') )
          )
        {
            if((Contract != null && Contract != ''  && opp[0].HIPI_CONTRACT_NUMBER__c == null))
            opp[0].HIPI_CONTRACT_NUMBER__c=Contract;
            if (invoiceno != null && invoiceno != '' && opp[0].Invoice__c == null )
            opp[0].Invoice__c = invoiceno;
            if(dealphase == 'Closed/Won' || dealphase == 'Closed/Lost' || dealphase == 'Closed Won' || dealphase == 'Closed Lost')
            {                       
                if(opp[0].stagename != dealphase)
                {             
                    if(dealphase == 'Closed/Won')
                    {
                         opp[0].stagename= 'Closed Won';
                         opp[0].Deal_Status__c= 'Closed/Won';
                    }
                    if(dealphase == 'Closed/Lost')
                    {
                         opp[0].stagename= 'Closed Lost';
                         opp[0].Deal_Status__c= 'Closed/Lost';
                    }
                    //opp[0].stagename = dealphase;
                }                         
            }
            if(opp[0].lic_to_IP_agreements__c == null){             
                opp[0].lic_to_IP_agreements__c= today1 ;
            }           
            update opp;             
        }                       
        return opp; 
    }  
}