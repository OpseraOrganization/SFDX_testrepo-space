//eGreensheet changes for SR INC000005896880 
global class TESTEG_Controller {
    
    public id opportunityid{get;set;}
    public string oppnum{get;set;}
    public string oppowner{get;set;}    
    public string oppnamee{get;set;}
    public Workflow_Details__c workflow;
    public Workflow_details__c wfd{get;set;} 
    public id campaignId{get;set;}
    Public  Opportunity_Proposal__c OppProp{get;set;}
    /* Values from Opp */
    public string oppNumber{get;set;}
    public string oppNumm{get;set;}
    public string oppNamm{get;set;}
    public boolean atr{get;set;}
    public boolean bga{get;set;}
    public boolean dns{get;set;}
    public boolean his{get;set;}
    public boolean htsi{get;set;}
    public boolean airlines{get;set;}
    public boolean airbus{get;set;} 
    public boolean boeing{get;set;}
    public boolean comp{get;set;}
    public boolean oe{get;set;}
    public boolean am{get;set;}
    public boolean america{get;set;}
    public boolean apac{get;set;}
    public boolean emeai{get;set;}
    public boolean globall{get;set;}
    public string acctid{get;set;}
            
    public string acctname{get;set;}
    
    ApexPages.StandardController scontroller; 
    
    public TESTEG_Controller(ApexPages.StandardController controller) {
        campaignId = ApexPages.currentPage().getParameters().get('campaignId');
        String campaignName = ApexPages.currentPage().getParameters().get('campaignName');
        this.workflow= (Workflow_Details__c)controller.getRecord();
        system.debug('workflow rec:'+workflow);
        this.workflow.campaign__c = campaignId;
        this.workflow.Wokflow_Name__c='eG-'+campaignName;
        scontroller = controller;
        string str =apexpages.currentpage().getparameters().get('retURL');
        system.debug ('return url'+str);
          string strId = ApexPages.currentPage().getParameters().get('propid');
        wfd = new Workflow_details__c();
       if(str!=null) {
           str = str.substring(1);       
       if(str.length()== 15 && str.substring(0,3)=='a3n'){
       
     Opportunity_Proposal__c  OppProp = [SELECT Id, Opportunity__r.Name,Opportunity__r.Account.id, Last_Opened_Case__c,Name,Opportunity_Account_Name__c,Opportunity_Amount__c,Opportunity_Name__c,Opportunity_Number__c,Opportunity__c from Opportunity_Proposal__c where id=:strid]; 
       system.debug('**global**'+globall);
     
       wfd.Case__c = OppProp.Last_Opened_Case__c;
      wfd.Wokflow_Name__c = 'eG-'+OppProp.Opportunity__r.Name;
       wfd.Opportunity_Description__c = OppProp.Opportunity__c;
       wfd.Opportunity_Proposal__c =  OppProp.id;
       wfd.Opportunity_Number__c = OppProp.Opportunity_Number__c;
       wfd.Customer_Name__c = OppProp.Opportunity__r.Account.id;
       }
       }
             if(workflow.Opportunity_Description__c!=null){
            Opportunity opp= [select Name,Account.id,Opportunity_Number__c,Ownerfullname__c,SBU__c,Opportunity_Owner_formula__c,Region__c,CBT_Tier_2__c,RecordTypeId,AccountId,Account_Name_formula__c from Opportunity where id=:workflow.Opportunity_Description__c];
           workflow.Wokflow_Name__c='eG-'+ opp.Name;
           workflow.Customer_Name__c=opp.Account.id;
           workflow.Opportunity_Number__c = opp.Opportunity_Number__c;
           }
    
    }
    
    public pagereference saveAAS(){
        
        //Test
        system.debug('sfdcNumber--->' + oppNumber);
        system.debug('oppNumber--->' + oppNumm);
        system.debug('oppname--->' + oppnamee);
        system.debug('atr--->' + atr);
        system.debug('dns--->' + dns);
        system.debug('acctid--->' + acctid);
        system.debug(':::his::::'+his);
        system.debug('**global**'+globall);
        system.debug(wfd.Wokflow_Name__c+'**wfd details**'+wfd);
        if(workflow.Opportunity_Description__c!=null){
            Opportunity opp= [select Name,Opportunity_Number__c,Ownerfullname__c,SBU__c,Opportunity_Owner_formula__c,Region__c,CBT_Tier_2__c,RecordTypeId,AccountId,Account_Name_formula__c from Opportunity where id=:workflow.Opportunity_Description__c];
            workflow.Opportunity_Lead_Owner__c=oppowner;
            //workflow.Wokflow_Name__c='eG-'+ opp.Name;
            
            //system.debug('opportunity name'+opp.Name);
            //workflow.Atlas_or_P_DR__c=oppNumber;
            system.debug('opp Region:'+opp.Region__c); 
            workflow.Opportunity_Number__c=oppNumber;
            workflow.Customer_Name__c=opp.AccountId;
           // workflow.Opportunity_Description__c = opp.Name;
           // workflow.Opportunity_Description__c = wfd.Opportunity_Description__c;  
            workflow.Opportunity_Description__c = opp.Id; //added for INC0001313566
            workflow.Opportunity_Proposal__c = wfd.Opportunity_Proposal__c;
            //workflow.Customer_Name__c=opp.Account_Name_formula__c;
            //workflow.Opportunity_Lead_Owner__c=opp.Opportunity_Owner_formula__c;
            //workflow.Opportunity_Number__c=oppNumm;
            workflow.Opportunity_Name__c=oppnamm;
            workflow.Status__c='Draft';
            
             // updated for HIS change 
            workflow.HIS__c = True;
            
      /* if(wfd.Sales_Channel__c != null)  { 
     Opportunity_Proposal__c  OppProp = [SELECT Id, Opportunity__r.Name, Last_Opened_Case__c,Name,Opportunity_Account_Name__c,Opportunity_Amount__c,Opportunity_Name__c,Opportunity_Number__c,Opportunity__c from Opportunity_Proposal__c ]; 
       wfd.Wokflow_Name__c = 'eG-'+OppProp.Opportunity__r.Name;
     }*/
            if(wfd.Sales_Channel__c != null){
                system.debug('wfd.Sales_Channel__c value:'+wfd.Sales_Channel__c);
                workflow.Sales_Channel__c = wfd.Sales_Channel__c;
            }
            if(wfd.Product_SBU__c != null){
                workflow.Product_SBU__c = wfd.Product_SBU__c;
            }
            if(wfd.Wokflow_Name__c != null){
                workflow.Wokflow_Name__c = wfd.Wokflow_Name__c;
            }
            
            if(wfd.Case__c!=null)
                workflow.case__c = wfd.Case__c;
            
            if(opp.SBU__c =='ATR'){
                system.debug('INNN'+atr);
                workflow.ATR__c=True;
                workflow.BG_A__c=false;
                workflow.Defence_Space__c=false;
            }else if(opp.SBU__c=='BGA'){
                system.debug('INAAAA'+BGA);
                workflow.ATR__c=false;
                workflow.BG_A__c=True;
                workflow.Defence_Space__c=false;
            }else if(opp.SBU__c=='D&S'){
                workflow.Defence_Space__c=True;
                workflow.BG_A__c=False;
                workflow.ATR__c=False;
            }else{
                workflow.ATR__c=True;
                workflow.BG_A__c=True;
                workflow.Defence_Space__c=True;
            }
            
            if(opp.RecordTypeId==label.AM_Catalog || opp.RecordTypeId==label.AM_Complex || opp.RecordTypeId==label.AM_Standard){
                workflow.AM__c=True;
                workflow.OE__c=False;
            }else if(opp.RecordTypeId==label.OE_Complex || opp.RecordTypeId==label.OE_Standard || opp.RecordTypeId==label.BGA_OE){
                workflow.AM__c=False;
                workflow.OE__c=True;
            }else{
                workflow.AM__c=True;
                workflow.OE__c=True;
            }
            
            if(opp.Region__c=='Americas' && workflow.APAC__c!=true && workflow.EMEAI__c!=true && workflow.Global__c!=true){
                workflow.Americas__c=True;
                workflow.APAC__c=False;
                workflow.EMEAI__c=False;
                workflow.Global__c=False;
            }else if(opp.Region__c=='Asia/Pacific Rim' && workflow.Americas__c!=true && workflow.EMEAI__c!=true && workflow.Global__c!=true) {
           
                workflow.Americas__c=False;
                workflow.APAC__c=True;
                workflow.EMEAI__c=False;
                workflow.Global__c=False;
            }else if(opp.Region__c=='Europe/MiddleEast/Africa/India' && workflow.Americas__c!=true && workflow.APAC__c!=true && workflow.Global__c!=true){
                workflow.Americas__c=False;
                workflow.APAC__c=False;
                workflow.EMEAI__c=True;
                workflow.Global__c=False;
            }
            
            else {
                workflow.Americas__c=True;
                workflow.APAC__c=True;
                workflow.EMEAI__c=True;
                system.debug('**global123**'+globall);
                workflow.Global__c=True;
                system.debug('**global!@#**'+globall);
            }
            system.debug('**cbt team1'+opp.CBT_Tier_2__c);
            if(opp.CBT_Tier_2__c=='Airlines'){
                workflow.Airlines__c=True;
                workflow.Airbus__c=False;
                workflow.RACC__c=False;
                workflow.Boeing__c=False;
                workflow.HTSI__c=False;
                system.debug('**htsi**'+htsi);
            }else  if(opp.CBT_Tier_2__c=='Airbus'){
                workflow.Airlines__c=False;
                workflow.Airbus__c=True;
                workflow.RACC__c=False;
                workflow.Boeing__c=False;
                workflow.HTSI__c=False;
            }else if(opp.CBT_Tier_2__c=='Boeing ATR'){
                workflow.Airlines__c=False;
                workflow.Airbus__c=False;
                workflow.RACC__c=False;
                workflow.Boeing__c=True;
                workflow.HTSI__c=False;
            }else if(opp.CBT_Tier_2__c=='Components Business'){
                workflow.Airlines__c=False;
                workflow.Airbus__c=False;
                workflow.RACC__c=True;
                workflow.Boeing__c=False;
                workflow.HTSI__c=False;
            }else if(opp.CBT_Tier_2__c=='HTSI'){
                workflow.Airlines__c=False;
                workflow.Airbus__c=False;
                workflow.RACC__c=False;
                workflow.Boeing__c=False;
                workflow.HTSI__c=True;
            }else{
                workflow.Airlines__c=True;
                workflow.Airbus__c=True;
                workflow.RACC__c=True;
                workflow.Boeing__c=True;
                workflow.HTSI__c=True;
                system.debug('**htsi1**'+htsi);
            }
            system.debug('**cbt team2'+opp.CBT_Tier_2__c);
        }else{
            if(wfd.Sales_Channel__c != null){
                system.debug('wfd.Sales_Channel__c value:'+wfd.Sales_Channel__c);
                workflow.Sales_Channel__c = wfd.Sales_Channel__c;
            }
            if(wfd.Product_SBU__c != null){
                workflow.Product_SBU__c = wfd.Product_SBU__c;
            }
            workflow.Opportunity_Lead_Owner__c=oppowner;
            workflow.Atlas_or_P_DR__c=oppNumber;
            if(acctid != '000000000000000'){
                workflow.Customer_Name__c=acctid;
            }
            workflow.Opportunity_Number__c=oppNumber;
            workflow.Opportunity_Name__c=oppnamm;
            workflow.Opportunity_Description__c = wfd.Opportunity_Description__c;
            workflow.Opportunity_Proposal__c = wfd.Opportunity_Proposal__c;
            //workflow.ATR__c=True;
            //workflow.BG_A__c=True;
            //workflow.Defence_Space__c=True;
            //workflow.Airlines__c=True;
            //workflow.Airbus__c=True;
            //workflow.RACC__c=True;
            //workflow.Boeing__c=True;
            //workflow.HTSI__c=True;
            //workflow.Americas__c=True;
            //workflow.APAC__c=True;
            //workflow.EMEAI__c=True;
            //workflow.Global__c=True;
            //workflow.AM__c=True;
            //workflow.OE__c=True;
            system.debug('**htsi**'+htsi);
            //system.debug('*****' +wfd.Case__c);
            
            if(wfd.Wokflow_Name__c != null){
                workflow.Wokflow_Name__c = wfd.Wokflow_Name__c;
            }
            
            if(wfd.Case__c != null)
                workflow.case__c = wfd.Case__c;
        }
        
        if(workflow.Defence_Space__c== true && (workflow.case__c==null)){
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Case is required for D&S eGreensheet'));
            workflow.case__c.addError('Case is required for D&S eGreensheet');        
        }
        if(workflow.Sales_K__c==null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please enter value'));
        }        
        
        insert workflow; 
        
        //system.debug('YYYYYY'+workflow.id);
        pagereference pa = new PageReference ('/'+workflow.Id);
        return pa;
    }
    @RemoteAction
    global static List<string> getnameandnum(string opportunityId)
    {   
        List<string> listopp= null;
        system.debug('--->' + opportunityid);
        if(opportunityid!= null && opportunityid!= ''){ 
            Opportunity opportunity= [select Name,Opportunity_Number__c,Ownerfullname__c,SBU__c,Opportunity_Owner_formula__c,Region__c,CBT_Tier_2__c,RecordTypeId,AccountId,Account_Name_formula__c  from Opportunity where id=:opportunityId];
            if(Opportunity!= null){
                listopp= new List<string>(); 
                if(opportunity.name != null)   
                    listopp.add(opportunity.name);
               // else
                   // listopp.add('');
                    
                if(opportunity.Ownerfullname__c != null)     
                    listopp.add(opportunity.Ownerfullname__c ); 
               // else
                 //   listopp.add('');   
                  if(opportunity.SBU__c!= null && opportunity.SBU__c=='ATR' || opportunity.SBU__c=='BGA'||opportunity.SBU__c=='D&S')
                     listopp.add(opportunity.SBU__c );  
                     //else
                     //listopp.add('');
                     if(opportunity.CBT_Tier_2__c!= null && opportunity.CBT_Tier_2__c=='Airlines' || opportunity.CBT_Tier_2__c=='Airbus'||opportunity.CBT_Tier_2__c=='HTSI'|| opportunity.CBT_Tier_2__c=='Boeing'||opportunity.CBT_Tier_2__c=='Components')
                      listopp.add(opportunity.CBT_Tier_2__c );  
                     // else
                     //listopp.add('');
                     if(opportunity.RecordTypeId!=null)
                 listopp.add(opportunity.RecordTypeId);
                 //else
                     //listopp.add('');
                     if(opportunity.Region__c!=null)
                 listopp.add(opportunity.Region__c);
                // else
                     //listopp.add('');
                 
                  if(opportunity.Opportunity_Number__c!=null)
                 listopp.add(opportunity.Opportunity_Number__c);
                 //else
                     //listopp.add(''); 
                 if(opportunity.Account_Name_formula__c!=null)
                 listopp.add(opportunity.Account_Name_formula__c);
                 //else
                    // listopp.add(''); 
                     
                 if(opportunity.AccountId !=null)
                 listopp.add(opportunity.AccountId);
                // else
                  //   listopp.add(''); 
                 
            }
        }
        system.debug('---->' + listopp);
        return listopp; 
    }
}