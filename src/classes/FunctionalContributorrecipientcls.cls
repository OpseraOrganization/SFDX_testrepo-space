public class FunctionalContributorrecipientcls 
{    
    public List<Functional_Contributor_Update__c> memberAddList {get;set;}
    public List<Functional_Contributor_Update__c> memberAddList1 {get;set;}
    public Integer rowNum{get;set;}
    public Integer rowNum1{get;set;}
    public boolean callwindow{get;set;}
    public List<Functional_Contributor_Update__c> memberAddList3=new List<Functional_Contributor_Update__c>();
    public List<Functional_Contributor_Update__c> memberAddList4=new List<Functional_Contributor_Update__c>();
    public Functional_Contributor_Update__c opp{get;set;}
    public String posId=ApexPages.currentPage().getParameters().get('Id');
    
    public FunctionalContributorrecipientcls()
    {       
        memberAddList = new List<Functional_Contributor_Update__c>();
        memberAddList.add(new Functional_Contributor_Update__c());
        
        opp=new Functional_Contributor_Update__c ();
        opp.Opportunity_Proposal__c=posId; 
             
        memberAddList1 = new List<Functional_Contributor_Update__c>();
        memberAddList1.add(new Functional_Contributor_Update__c());
        callwindow=false;
           
    } 
         
    public void AddRow()
    {
        memberAddList.add(new Functional_Contributor_Update__c());
    }
     public void AddRow1()
    {
        memberAddList1.add(new Functional_Contributor_Update__c());
    }
    public void delRow()
    {
        rowNum = Integer.valueOf(apexpages.currentpage().getparameters().get('index'));
        memberAddList.remove(rowNum);       
    }    
     public void delRow1()
    {
        rowNum1 = Integer.valueOf(apexpages.currentpage().getparameters().get('index'));
        memberAddList1.remove(rowNum1);         
    }
    
    public pagereference  saveMemb()
    {
        system.debug('test123------->'+memberAddList.size());
        system.debug('test456------->'+memberAddList1.size()); 
        Opportunity_Proposal__c oppproposal=[select id,name,Description__c,Negotiation_Complete_Date__c,Opportunity_Account_Name__c,Pricing_Analyst__c from Opportunity_Proposal__c where id=:posId];
            if(oppproposal != null)
            {
                try
                { 
                    if((oppproposal.Description__c != null ) && (oppproposal.Negotiation_Complete_Date__c != null)  && (oppproposal.Pricing_Analyst__c != null))
                    {
                        set<id> conid=new set<id>();
                        for(Functional_Contributor_Update__c oppprop12:memberAddList)
                        {
                            conid.add(oppprop12.SFDC_Recipients__c );
                        }
                        map<id,contact> con;
                        if(conid!= null)
                        {
                            con=new map<id,contact>([select id,name,email from contact where id=:conid]);
                            
                        }
                        
                        for(Functional_Contributor_Update__c oppprop:memberAddList)
                        {
                            if(oppprop.SFDC_Recipients__c != null)
                            {
                                system.debug('test321------->'+oppprop);
                                oppprop.Opportunity_Proposal__c=posId;
                                oppprop.Request_Date__c=system.today();
                                oppprop.Recipients_Email__c=con.get(oppprop.SFDC_Recipients__c).email;
                                oppprop.Resend_Email__c=true;  
                                memberAddList3.add(oppprop);
                            }
                        } 
                        insert memberAddList3;
                              
                        for(Functional_Contributor_Update__c oppprop1:memberAddList1)
                        {
                            if(oppprop1.Non_SFDC_Recipient__c!= null)
                            {
                                system.debug('test654------->'+oppprop1);
                                oppprop1.Opportunity_Proposal__c=posId; 
                                oppprop1.Request_Date__c=system.today();
                                oppprop1.Recipients_Email__c=oppprop1.Non_SFDC_Recipient__c;
                                oppprop1.Resend_Email__c=true;   
                                memberAddList4.add(oppprop1);
                            }
                        }
                        insert memberAddList4;
                        pagereference ref=new pagereference('/'+posId);
                        return ref;
                        //callwindow=true;
                    }
                    else
                    {
                        callwindow=true;
                    }
                }
                catch(Exception e) 
                {
                }
            }
        return null;
        
    }
    public pagereference cancelpage()
    {
        pagereference ref=new pagereference('/'+posId);
        return ref;
    }
}