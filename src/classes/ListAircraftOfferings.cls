public with sharing class ListAircraftOfferings 
{
    
    /*
        This class is to control ManageAircraftOfferings.page.
    */
    
    // Public varibales settings
    public string airId {get; set;}
    public string airName {get; set;}
    public string platfrmId {get; set;}
    public string offerId {get; set;}
    public string pltFrmName {get; set;}
    public List<Aircraft_Offerings__c> airOffer {get; set;}
    public List<OFFERING_MAPPER__c> airPlatOffer1 {get; set;}
    public Boolean showOtherInputsScreen {get; set;}
    public Integer selectedRow {get; set;}
    public string actionedRMUName {get; set;}
    public string relatedOpportunityName {get; set;}
    
    //Get Aircraft Platform Offering size and values to display in view page
    public integer airPlatOfferSIZE {get; set;}
    public List<TempCLA> airPlatOfferOpp{get; set;}
    
    public List<String> idds; 

    class TempCLA
    {
        public  Integer recCnt                  {get; set;}
        public  OFFERING_MAPPER__c a            {get; set;}
        private Opportunity o;
        public  String aofStatus                {get; set;}
        public  Boolean actionRecord            {get; set;}
        public  String  relatedOpportunityName  {get; set;}
        public  String  installationStage       {get; set;}
        public  Boolean isCustomerContacted     {get; set;}
        //public  Boolean proposalSent          {get; set;}
        
        public Opportunity getOpp()
        {
            return o;
        }
        
        public void setOpp(Opportunity pO)
        {
            o=pO;
        }
        
        TempCLA()
        {
            aofStatus = 'Active';
            actionRecord = false;
            isCustomerContacted = false;
        }
         
        
    }
    
    
    Opportunity localAcc{get; set;}
    public Opportunity getAccountfieldlkp()
    {
        return localAcc;
    }
    public void setAccountfieldlkp(Opportunity acc)
    {
        localAcc = acc;
    }
        
    //Contructor
    public ListAircraftOfferings() 
    {
        airId       = ApexPages.currentPage().getParameters().get('airId');
        startProcess();
        showOtherInputsScreen = false;
        idds = new List<String>();
        //getOptionsListStatus();
    }
    
    public void startProcess()
    {
        airName         = null;
        pltFrmName      = null;
        platfrmId       = null;
   system.debug('############'+airId);     
        List<Fleet_Asset_Detail__c> airDtl = [
                                        Select 
                                                Name,
                                                Platform_Name__r.Name,
                                                Platform_Name__c 
                                        From    Fleet_Asset_Detail__c 
                                        Where   Id = :airId LIMIT 1
                                    ];
         system.debug('############'+airDtl[0]);  
        for(integer i=0;i<airDtl.size();i++)
        {
                airName     = airDtl[i].Name;
                pltFrmName  = airDtl[i].Platform_Name__r.Name;
                platfrmId   = airDtl[i].Platform_Name__c;
                
                getAirOffer();
                getAirPlatfrmOffer();
        }
        
    }
    
   //Get Aircraft Offering size and values to display in view page
   public integer airOfferSIZE {get; set;}
   
   public List<TempDisplayInstalledSection> listInstalledSection{get; set;}
   public class TempDisplayInstalledSection
   {
        public Boolean              actionRecord{get; set;}
        public Aircraft_Offerings__c    a{get; set;}
   }    
   
   public void getAirOffer()
    {
        
        airOffer = [
                        Select  Id,
                                Name,
                                RMU_Dealer_Price__c,
                                RMU_Honeywell_Price__c,
                                Tail_Revenue_Amount__c,
                                Offering_Mapper__r.Name,
                                Offering_Mapper__c ,
                                CreatedDate,
                                CreatedBy.Name,
                                Installed_By_Dealer_Name__r.Name,
                                Installed_By_Dealer_Name__c,
                                //Status__c,
                                Opportunity__c,
                                Opportunity__r.Name,
                                Opportunity__r.StageName,
                                Installed_Date__c,
                                Is_Customer_Contacted__c,
                                Proposal_Provided__c
                        From    Aircraft_Offerings__c 
                        Where   Aircraft_Customer_Fleet__c = :airId Order 
                        By      CreatedDate desc
                    ];
                    
       listInstalledSection = new List<TempDisplayInstalledSection>();
       
       for(integer p=0;p < airOffer.size();p++)
       {
            TempDisplayInstalledSection tdis = new TempDisplayInstalledSection();
            tdis.a = airOffer[p];
            tdis.actionRecord = false;
            listInstalledSection.add(tdis);
            
       }
                    
       airOfferSIZE = airOffer.size();
       
    }
    
    public void getAirPlatfrmOffer()
    {
        
        airPlatOffer1 = [
                            Select 
                                    Id,
                                    Name,
                                    RMU_DEALER_PRC__c,
                                    RMU_HONEYWELL_PRC__c,
                                    TAIL_REV_AMT__c,
                                    CreatedDate,
                                    CreatedBy.Name 
                            From    OFFERING_MAPPER__c 
                            Where   Aircraft_Platform__c = :platfrmId 
                            And     Id Not In (
                                                Select 
                                                Offering_Mapper__c 
                                                From 
                                                Aircraft_Offerings__c 
                                                Where Aircraft_Customer_Fleet__c = :airId 
                                               ) 
                                              Order By CreatedDate desc
                      ];
                      
        airPlatOfferSIZE = airPlatOffer1.size();
        airPlatOfferOpp = new List<TempCLA>();
        
        for(integer p=0;p<airPlatOffer1.size();p++)
        {
            TempCLA ptcla = new TempCLA();
            ptcla.a = airPlatOffer1[p];
            ptcla.recCnt = p;
            ptcla.actionRecord = false;
            ptcla.o = new Opportunity();
            airPlatOfferOpp.add(ptcla);
        }
                      
                      
    }
    
    //Install offering, create mapping record between Aircraft and platform Offering, and return navigation to parent page again
    public string retURL {get; set;}
    public PageReference installOffering()
    {
             if(localAcc == null && 1==2)
             {
                showOtherInputsScreen = true;
                return null;
             }
             
             return processInstallOffering();
    }
    
    public PageReference processInstallOffering()
    {
            
                 List<Aircraft_Offerings__c> aoc;
                 
                 for(integer k=0;k<airPlatOfferOpp.size();k++)
                 if(airPlatOfferOpp[k].actionRecord == true)
                 {
                    
                    aoc = 
                                                [Select Id From Aircraft_Offerings__c 
                                                Where Offering_Mapper__c        = :airPlatOfferOpp[k].a.Id 
                                                And Aircraft_Customer_Fleet__c  = :airId
                                                ];
                    if(aoc.size() == 0 )
                    {
                             
                             Aircraft_Offerings__c ao       = new Aircraft_Offerings__c();
                            
                             ao.Aircraft_Customer_Fleet__c  = airId;
                             ao.Offering_Mapper__c          = airPlatOfferOpp[k].a.Id;
                             ao.Installed_By_Dealer_Name__c = airPlatOfferOpp[k].getOpp().AccountId;
                             //ao.Status__c                 = airPlatOfferOpp[k].installationStage;
                             ao.Opportunity__c              = airPlatOfferOpp[k].relatedOpportunityName;
                             ao.Is_Customer_Contacted__c    = airPlatOfferOpp[k].isCustomerContacted; 
                             
                             
                             insert ao;
                            
                             ApexPages.Message pMsg;
                             pMsg = new ApexPages.Message(ApexPages.Severity.INFO, 'RMU - '+ airPlatOfferOpp[k].a.Name + ' - installed successfully.');
                             ApexPages.addMessage(pMsg);
                             
                    }
                     
                 }
                 
            
            startProcess();
            
            return null;
            
    }
    public string delId {get; set;}
    public PageReference unInstallOffering()
    {
            for(integer k=0;k< listInstalledSection.size();k++)
            if(listInstalledSection[k].actionRecord == true)
            {
                    List<Aircraft_Offerings__c> aoc = [Select Id From Aircraft_Offerings__c 
                                                        Where Id = :listInstalledSection[k].a.Id
                                                        ];
                
                    if(aoc.size() > 0 )
                    {
                        Aircraft_Offerings__c delAirOffer = new Aircraft_Offerings__c(Id=listInstalledSection[k].a.Id);
                        delete delAirOffer;
                    }
                    
                    ApexPages.Message pMsg;
                    pMsg = new ApexPages.Message(ApexPages.Severity.INFO, 'RMU - '+ listInstalledSection[k].a.Offering_Mapper__r.Name + ' - Uninstalled successfully.');
                    ApexPages.addMessage(pMsg);
            }
            
            startProcess();
            
            return null;
    }
    
    public PageReference saveInstallOffering()
    {
         for(integer k=0;k< listInstalledSection.size();k++)
         if(listInstalledSection[k].actionRecord == true)
         {
            Aircraft_Offerings__c aoc           = new Aircraft_Offerings__c(Id=listInstalledSection[k].a.Id );

            //aoc.Status__c                     = listInstalledSection[k].a.Status__c                   ;
            aoc.Installed_By_Dealer_Name__c     = listInstalledSection[k].a.Installed_By_Dealer_Name__c ;
            aoc.Opportunity__c                  = listInstalledSection[k].a.Opportunity__c              ;
            aoc.Is_Customer_Contacted__c        = listInstalledSection[k].a.Is_Customer_Contacted__c    ;
            
            update aoc;
            
            ApexPages.Message pMsg;
            pMsg = new ApexPages.Message(ApexPages.Severity.INFO, 'RMU - '+ listInstalledSection[k].a.Offering_Mapper__r.Name + ' - is updated successfully.');
            ApexPages.addMessage(pMsg);
            
         }
            
        startProcess();
        return null;
    }
    
    
    public List<SelectOption> optionsStatus{get; set;}
    
    /*
    public void getOptionsListStatus() 
    {       
            //{!$ObjectType.Aircraft_Offerings__c.Fields.Status__c.Label}
            Schema.DescribeFieldResult fieldResult = Aircraft_Offerings__c.Fields.Status__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            
                
            
            optionsStatus = new List<SelectOption>();           
            optionsStatus.add(new SelectOption('','--None--'));
            
            for(integer i=0;i<ple.size();i++)
            {
                optionsStatus.add(new SelectOption(ple[i].getValue(),ple[i].getValue()));   
            }
    }
    */
    
    public List<SelectOption> getListRelatedOpportunities() 
    {
            List<SelectOption> options = new List<SelectOption>();          
            options.add(new SelectOption('','--None--'));
         
            //List<Opportunity_Aircraft__c> ls = [Select Opportunity__c,Opportunity__r.Name,Opportunity__r.CloseDate From Opportunity_Aircraft__c Where Aircraft__c = :airId Order By Opportunity__r.CloseDate Desc];
            
            List<Opportunity> ls = [
                                                    Select Id,Name,CloseDate 
                                                    From Opportunity 
                                                    Where Aircraft_ref__c = :airId Order 
                                                    By CloseDate Desc
                                                ];
            
            for(integer i=0;i<ls.size();i++)
            {
                String formatedCloseDate = 
                                                    ls[i].CloseDate.day()   + '/' +
                                                    ls[i].CloseDate.month()     + '/' +
                                                    ls[i].CloseDate.year()  ;
                                                     
                options.add(new SelectOption(ls[i].Id,ls[i].Name + ' - ['+formatedCloseDate+']'));  
            } 
         
            return options;

    }
    /*
    public List<SelectOption> getItemsInstallationStage() 
    {
            
            Schema.DescribeFieldResult fieldResult = Aircraft_Offerings__c.Fields.Status__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            
            List<SelectOption> options = new List<SelectOption>();          
            options.add(new SelectOption('','--None--'));
            
            for(integer i=0;i<ple.size();i++)
            {
                options.add(new SelectOption(ple[i].getValue(),ple[i].getValue())); 
            }
            
            return options;
    }
       
    static testMethod void myunitTest2()
    {
         ListAircraftOfferings lao = new ListAircraftOfferings();
         
//       lao.getOptionsListStatus()         ;
        
//       lao.getItemsInstallationStage()    ;
           
         lao.airId      = 'a0030000006G7R9';
         lao.getListRelatedOpportunities()  ;
         lao.startProcess();
         
         lao.airId      = 'a0030000006G7R9';
         lao.offerId    = 'a1V800000004OPd';
         
         lao.airPlatOfferOpp[0].actionRecord = true;
         lao.processInstallOffering();

         lao.listInstalledSection[0].actionRecord = true;
         lao.saveInstallOffering();
         
         lao.listInstalledSection[0].actionRecord = true;
         lao.unInstallOffering();
         
    }
   */  

}