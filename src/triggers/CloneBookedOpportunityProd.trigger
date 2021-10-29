trigger CloneBookedOpportunityProd on OpportunityLineItem (before insert) {
    List <OpportunityLineItem> lstopp = Trigger.new;
    set<Id>oppid= new set<id>();
    list<Opportunity>opplist= new list<Opportunity>();
    String profileId;
    profileId=Userinfo.getprofileId();
    profileid=profileId.substring(0,15); 
     if(!(profileid == label.Honeywell_System_Administrator_US_Label  || profileid == label.DS_Sales_Admin_Label  || profileid ==label.Honeywell_System_Administrator_Label  || profileid==label.D_S_Sales_Spiral_API_User_Label))
     {
        try {
            for(Integer i=0;i<lstopp.size();i++)
               {
                if(lstopp[i].Type__c == 'Booked' && lstopp[i].SBU__c=='D&S')
                {
                 lstopp[i].Type__c = 'Forecast';
                }
              }
          }catch(Exception ex){}
       }
      for(OpportunityLineItem oppline: lstopp) 
      {
      system.debug('inside for****'+oppline);
       if(oppline.OpportunityId!=null)
       {
          oppid.add(oppline.Opportunityid);
       }
       system.debug('oppid values****'+oppid);
      }
      try
      {
      
       if(oppid.size()>0)
       {   
        opplist=[select id,    Is_Product_Created__c from Opportunity where id IN: oppid];
        for(opportunity opp: opplist)
        {
                opp.Is_Product_Created__c=true;
                update opp;
        } 
        }
      }
      
         catch(Exception ex){}
}