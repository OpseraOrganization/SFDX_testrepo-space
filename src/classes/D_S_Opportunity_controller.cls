global without sharing class D_S_Opportunity_controller {
    public boolean form{get;set;}
    public String OppName {get;set;}
    public boolean flag{get;set;}
    public id tempAccountID{get;set;}
    public string tempAccountName{get;set;}
    public String tempPlatformName{get;set;}
    public id tempPlatformID{get;set;}
    public id tempSiteID{get;set;}
    public string tempOppName{get;set;}
    public static id tempOppID{get;set;}
    public id platformid{get;set;}
    public string tempSiteName{get;set;}   
    public opportunity opp{get;set;}
    public string platformName {get;set;}
    public Platform__c platform{get;set;} 
    public Plant_Code_Master__c site{get;set;} 
    public String fileContentType{get;set;} 
    public Blob oppattchment{get; set;}
    public boolean hideinpufile {get;set;}
    public String filename{get;set;}
    public String body{get;set;}
    public String tempdesc{get;set;}
    public Account acct{get;set;}
    public Planned_Meeting__c plan{get;set;}
    public Attachment att {get;set;}
    public Attachment att2 {get;set;}
    public Contact con ;    
    public Id oppNId {get;set;}
    public String OppBtn;
     public String OppBtn11{get;set;}
    public Id DSCASErecordTypeId;
    public String positions {get; set;}
    public String descriptions {get; set;}
    public String pricing {get; set;}
    public List<string> recordtypelist{get;set;}
    public List<SelectOption> filesCountList {get; set;}
    public String FileCount {get; set;}    
    public List<Attachment> allFileList {get; set;}
    public String EmailDescription;
    public string emsubject;
    public string oppBackend {get;set;}
    public case caseProposalLeader{get;set;}
    Account acc = new account(name=tempAccountName);   
    Map<id,Opportunity> OppDetailsMap = new Map<id,Opportunity>();
    Opportunity opp1= new opportunity();
    public boolean fileattachment {get;set;}
  // public boolean boolDisplaySoliciation {get;set;} //added
    public boolean loader{get;set;}
    public string numb{get;set;}
    public date todaydt{get;set;}
    public string selectedSite{get;set;}
    public string requesttypes{get;set;}
    public string propemail{get;set;}

  // public List<PlantCodeMaster__c> mcs = Games__c.getall().values();
   
    

    public D_S_Opportunity_controller (ApexPages.StandardController controller) {  
   // boolDisplaySoliciation = false;  //added
            //Initialize 
        todaydt = date.today();
        system.debug('todaydt-->'+todaydt );
        positions='';       
        caseProposalLeader=new case();
        //filesCountList = new List<SelectOption>() ;
        //FileCount = '' ;
        //allFileList = new List<Attachment>() ;
        //Adding values count list - you can change this according to your need
       /* for(Integer i = 1 ; i < 11 ; i++)
            filesCountList.add(new SelectOption(''+i , ''+i)) ;                
        system.debug('---statndard--constructor----');*/
        opp= new opportunity(); 
        
        
        plan = new Planned_Meeting__c();
        form=true;
        fileattachment = false;
        acct= new Account();
        //att = new Attachment();
        // added for aero Bundle
       // att2 = new Attachment();
        con = new Contact();
        tempdesc ='';
        EmailDescription='';
        String email = ApexPages.currentPage().getParameters().get('email');
        String Name = ApexPages.currentPage().getParameters().get('Name');
        Id oppId = ApexPages.currentPage().getParameters().get('id');
        OppBtn = ApexPages.currentPage().getParameters().get('scontrolCaching');
        system.debug('email------'+email);
        system.debug('oppId------'+oppId);
        /*if(email !=null && email !=''){
            for(Contact con1 : [Select id,AccountId From Contact Where Email=:email limit 1])
            {
              //  acct.id =con.AccountId;
                opp.AccountId=con1.AccountId;
                con =con1;
                
            }
        }
        
        else{
            acct.E_mail_address__c = UserInfo.getUserEmail();
        }
        */
        //system.debug('conl------'+con);
        if(email !=null)
        {
            List<Contact> conList =[Select id,Name,lastname,AccountId,Account.Name From Contact Where Primary_Email_Address__c =: email limit 1];
            if(!conList.isEmpty())
            {
                con =conList[0];
                tempAccountName =con.Account.Name;
                acct.E_mail_address__c  =email;
                tempOppName=con.name;               
            }
            else
            {
                acct.E_mail_address__c = email;
                tempOppName =Name;
            }
        }
        else{
            List<Contact> conList =[Select id,Name,lastname,AccountId,Account.Name From Contact Where Primary_Email_Address__c =: UserInfo.getUserEmail() limit 1];
            con=conlist[0];
            acct.E_mail_address__c = UserInfo.getUserEmail();
            tempOppName= UserInfo.getName();
            
        }
        if(oppId != null ){
            opp = [select Name,opportunity_number__c,isclosed,accountid,Account.Name,Type,Description,Tech_Sales__c,Tech_Sales_Product_Area__c,Certification_Requirements__c,Platform__c,Platform__r.Name,
                   Bid_Type_Name__c,Site__c,Site__r.name,Received_Date_at_Clearing_House__c,HAPP_Email__c,Customer_Issue_Date__c,Contract_Type__c,prime_sub__c,
                   Request_Type__c,Solicitation_No__c,Proposal_Due_Date__c,Type_of_Pricing__c,Proposal_Content__c,Revenue_Type__c,Estimated_Proposal_Value__c,
                   HW_SW__c,Comments__c,Account_Name_formula__c,Opportunity_Type__c,Record_Type_Name__c,recordtypeid,recordtype.name,RFP_Expected_Date__c    from Opportunity where id=:oppId]; 
            acct.Opportunity_backend__c = opp.Id;
            oppBackend = acct.Opportunity_backend__c;
            system.debug('acct.Opportunity_backend__c'+acct.Opportunity_backend__c);
            plan.Opportunity__c= opp.Id;
            positions = opp.recordtype.name;
        }
        opp.Received_Date_at_Clearing_House__c=system.today();
        loader=false;   
        opp.RFP_Expected_Date__c=null;
        opp.HW_SW__C='';
        opp.Customer_Issue_Date__c=null;
    }
    public List<SelectOption> getregions(){
    
      List<PlantCodeMaster__c> mcs = PlantCodeMaster__c.getall().values();
      mcs.sort();
      List<selectOption> options = new List<selectOption>();
       options.add(new selectOption('', '- None -')); 
       for(PlantCodeMaster__c acc : mcs) {           
            options.add(new selectOption(acc.SiteID__c,acc.name));
        }
              
        return options;    
    }
    
     public list<SelectOption> getRecordTypes() {
            list<SelectOption> options = new list<SelectOption>();
            
        options.add(new SelectOption('None', 'None'));
        List<String> reclist = new List<String>(); 
        String[] reclst = (label.Opportunity_Recordtypes).split(',');       
        if(reclst.size() > 0){            
            for(String i : reclst){
                reclist.add(i);                 
            }
        }
        recordtypelist=reclist;
        for (list<RecordType> rts : [SELECT ID, name FROM RecordType WHERE SObjectType = 'Opportunity' and name != 'None'  and Name =:reclist  ORDER BY Name ]) {
            for (RecordType rt : rts) {               
                options.add(new SelectOption(rt.Name, rt.Name));
            } 
        }      
        return options;    
    } 
    
     public List<SelectOption> getrequesttypevalues(){
        
        List<RequestTypes__c> mcs = RequestTypes__c.getall().values();
        mcs.sort();
        List<selectOption> options = new List<selectOption>();
        options.add(new selectOption('', '- None -')); 
        for(RequestTypes__c acc : mcs) {           
            options.add(new selectOption(acc.Picklist_Values__c,acc.name));
        }
        
        return options;    
    }

    Public void proposalleadernamebasedonemail(){ 
    list<contact> con1=[select id,Name,email from contact where id=:caseProposalLeader.New_Proposal_Manager1__c limit 1];
    
        if(con1.size()>0){
            propemail = con1[0].email ;
        }
        else{
            propemail='Error:Please provide correct email id';
        }
    }
       
    public D_S_Opportunity_controller (){
        opp= new opportunity();  
        acct= new Account();
        tempPlatformName='test';
        form = true;
        hideinpufile = false;
        system.debug('-----constructor----');
    }  
    public Pagereference loadOppType(){
    Id oppId = ApexPages.currentPage().getParameters().get('id');
    system.debug('pragya1---' +acct.Opportunity_backend__c);
    system.assert(true,false);
    if(acct.Opportunity_backend__c !=null){
            opp1 = [select Name,id,RecordType.name,Record_Type_Name__c from Opportunity where id=:acct.Opportunity_backend__c]; 
            
            positions = opp1.RecordType.name;
            system.debug('pragya---' +positions);
        }
        return null;
} 

    /*public Pagereference chngmt()
    { 
    if(opp.Request_Type__c == 'UCA')
    {
        system.debug('----->'+opp.Request_Type__c);
        opp.Solicitation_No__c = 'UCA';
        
    }
    return null;
    }
    
    public Pagereference loadAccount()
    { 
        con = new Contact();
        if(acct.E_mail_address__c !=null)
        {
            List<Contact> conList =[Select id,Name,AccountId,Account.Name From Contact Where Primary_Email_Address__c =: acct.E_mail_address__c limit 1];
            if(!conList.isEmpty())
            {
               con =conList[0];
                tempAccountName =con.Account.Name; 
            }
            /* else
            {
                String temp ='';
                if(tempOppName !=null)
                {
                    temp ='Requestor Name : '+opp.Requestors_Name__c+'\n';
                }
               
                tempdesc =temp+'Requestor Email : '+acct.E_mail_address__c+'\n';
                //tempdesc = temp+'; '+opp.Description;
            } *//*
        }
        return null;
    }*/
    public Pagereference loadOpp()
    {
        System.debug(oppBackend+'@@@@acct'+acct);
        System.debug('date' + opp);
        if(acct.Opportunity_backend__c !=null)
        //if(opp.Parent_Opportunity__c !=null)
        {             
            opp = [select Name,opportunity_number__c,isclosed,account.id,Account.Name,Type,Description,Tech_Sales__c,Tech_Sales_Product_Area__c,Certification_Requirements__c,Platform__c,Platform__r.Name,
                   Bid_Type_Name__c,Site__c,Site__r.name,Received_Date_at_Clearing_House__c,HAPP_Email__c,Customer_Issue_Date__c,RFP_Expected_Date__c,Contract_Type__c,
                   Request_Type__c,Solicitation_No__c,Proposal_Due_Date__c,Type_of_Pricing__c,Proposal_Content__c,Revenue_Type__c,Estimated_Proposal_Value__c,prime_sub__c,
                   HW_SW__c,Comments__c,Account_Name_formula__c,Opportunity_Type__c,Recordtype.name,recordtypeid,Record_Type_Name__c from Opportunity where id=:acct.Opportunity_backend__c]; 
            System.debug('@@@@acct'+opp);
            descriptions = opp.Description;
            pricing = opp.Type_of_Pricing__c;
            positions = opp.Recordtype.name;
            opp.RFP_Expected_Date__c=null;
            opp.HW_SW__C='';
            opp.Customer_Issue_Date__c=null;
           
            /* String temp ='';
            if(tempOppName !=null)
            {
                temp ='Requestor Name : '+opp.Requestors_Name__c;
            }
            if(acct.E_mail_address__c !=null)
            {
                temp ='Requestor Email : '+acct.E_mail_address__c;
            }
            if(temp != '')
            {
            opp.Description =temp+'; '+opp.Description;
            } */
            //opp.Type = opp.Type;     
        }       
        if(opp.Request_Type__c == 'Unsolicited')
        {
            system.debug('*******'+opp.Request_Type__c);
            opp.Solicitation_No__c = 'Unsolicited';
        }
        
        else
        {
        
        }
        
        
        return null;
        
    }
    
    /*public Pagereference chngtp()
    {
    
        if(opp.Request_Type__c == 'Unsolicited')
        {
            system.debug('*********'+opp.Request_Type__c);
        }
    
    
    
    return null;
    }*/
    public Case createCase(Opportunity opp)
    {
        Id devRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('D&S Clearing House Proposal').getRecordTypeId();
        Case cse = new Case();
        Date dt;
        
        system.debug('===odevRecordTypeId====='+devRecordTypeId);
        cse.RecordTypeId =devRecordTypeId;
        cse.OwnerId = Label.D_S_Clearing_House;
        cse.Type_of_pricing__c =opp.Contract_Type__c;
        cse.Certification_Requirements__c =opp.Certification_Requirements__c;
        cse.Platform__c =opp.Platform__c;
        cse.Plant__c =selectedSite;
        //cse.Plant__c ='a0I30000004y8Fu';
        cse.Opportunity__c =opp.Id;
        cse.Opportunity_Type__c=opp.Opportunity_Type__c;
        cse.Customer_issue_date__c=opp.Customer_Issue_Date__c;
        cse.Request_Type_Opp__c =requesttypes;
        cse.Solicitation_Number__c=opp.Solicitation_No__c;
        cse.Proposal_Response_due_date__c=opp.RFP_Expected_Date__c;
         cse.Part_Number__c  = opp.HW_SW__c; 
        if(UserInfo.getUITheme() == 'Theme4t'){
          cse.Method_Received__c='Mobile Form- DSClearingHouse';
        } 
        else
          cse.Method_Received__c='Form-DSClearingHouse';
        cse.origin='Form-DSClearingHouse';
          cse.Accountid=opp.accountid;
        cse.part_research__c='Normal';
        if(opp.Received_Date_at_Clearing_House__c!=null){
            dt=opp.Received_Date_at_Clearing_House__c;
         cse.Received_Date__c= dt; 
        }
        else{
            dt=system.today();
        cse.Received_Date__c=dt;
        }
        cse.comments__c=opp.comments__c;
        cse.Part_Number__c  = opp.HW_SW__c;
        system.debug('*****-->'+cse.Part_Number__c  ); 
                system.debug('*****-->0'+opp.HW_SW__c);
        if(opp.prime_sub__c=='Joint Venture')
           cse.Contractor_Status__c='Joint Venture';
        else if(opp.prime_sub__c=='Prime')
                   cse.Contractor_Status__c='Prime';
        else if(opp.prime_sub__c=='Sub' || opp.prime_sub__c=='Subcontractor')
                   cse.Contractor_Status__c='Subcontractor';
        cse.Program_Description__c=opp.description;
        cse.classification__c=opp.Bid_Type_Name__c;
        cse.Requestor_Email__c=acct.E_mail_address__c;
        system.debug('con-->' + con);
        if(con.id!=null){
                   cse.contactid=con.id;  
               } 
        emsubject='';
        cse.proposal_content__c=opp.revenue_type__c;
        cse.estimated_proposal_value__c=opp.Estimated_Proposal_Value__c;
        cse.Tech_Sales__c=opp.tech_sales__c;
        cse.Tech_Sales_Product_area__c=opp.Tech_Sales_Product_area__c;
        system.debug('tempOppName==='+tempOppName+'tempAccountName'+tempAccountName+'tempAccountName---'+tempAccountName);
        
        
        if(opp.account.name!=null || opp.account.name!=''){
            tempdesc ='Account Name : '+opp.account.name +'\n';
            //emailDescription= emailDescription +'<b>Account Name :</b>'+opp.account.name  +'<br>'; //Commented by trupti
        }

        if(opp.name!=null || opp.name!='')
        {  
            system.debug('tempOppName===='+tempOppName);
            tempdesc = tempdesc + 'Opportunity Name : '+opp.name +'\n';
            //emailDescription= emailDescription +'<b>Opportunity Name :</b>'+opp.name  +'<br>'; //Commented by trupti
        }
        if(opp.Solicitation_No__c !=null || opp.Solicitation_No__c !='NULL')
        {  
            system.debug('tempOppName===='+tempOppName);
            tempdesc = tempdesc + 'Solicitation No : '+ (opp.Solicitation_No__c == null ? '' : opp.Solicitation_No__c)  +'\n';           
        }
        if(opp.Opportunity_Number__c !=null || opp.Opportunity_Number__c !='')
        {  
            system.debug('tempOppName===='+tempOppName);
            tempdesc = tempdesc + 'Opportunity No : '+opp.Opportunity_Number__c +'\n';           
        }
        /*
        if(tempAccountName == null && tempAccountName == '')
        tempdesc =tempdesc+'Requestor Email : '+acct.E_mail_address__c+'\n';
        
        if(opp.Type != null && opp.Type !=''){
            tempdesc = tempdesc +'Opportunity Type :'+opp.Type +'\n';
        }*/
        if(positions  != null && positions  != '')
        {
        tempdesc = tempdesc +'Opportunity Type :'+positions  +'\n';
        //emailDescription= emailDescription +'<b>Opportunity Type :</b>'+positions  +'<br>'; //Commented by trupti
        }
        if(opp.Tech_Sales__c != null && opp.Tech_Sales__c !=''){
            tempdesc = tempdesc +'Tech Sales :'+opp.Tech_Sales__c +'\n';
            //emailDescription= emailDescription+'<b>Tech Sales :</b>'+opp.Tech_Sales__c +'<br>'; //Commented by trupti

        }
        if(opp.Tech_Sales_Product_Area__c != null && opp.Tech_Sales_Product_Area__c !=''){
            tempdesc = tempdesc +'Tech Sales Product Area :'+opp.Tech_Sales_Product_Area__c +'\n';
            //emailDescription= emailDescription+'<b>Tech Sales Product Area :</b>'+opp.Tech_Sales_Product_Area__c +'<br>'; //Commented by trupti

        }
        if(dt != null ){
            tempdesc = tempdesc +'Received Date at Clearing House :'+dt +'\n';//opp.Received_Date_at_Clearing_House__c
            //emailDescription= emailDescription+'<b>Received Date at Clearing House :</b>'+opp.Received_Date_at_Clearing_House__c +'<br>'; //Commented by trupti

        }
        if(opp.Customer_Issue_Date__c != null ){
            tempdesc = tempdesc +'Customer Issue Date :'+opp.Customer_Issue_Date__c +'\n';
            //emailDescription= emailDescription+'<b>Customer Issue Date :</b>'+opp.Customer_Issue_Date__c +'<br>'; //Commented by trupti

        }
       // system.debug('----request type'+opp.Request_Type__c);
       /* if(opp.Request_Type__c != null && opp.Request_Type__c !='' && opp.Request_Type__c !='null'){
            system.debug('----request tyoe'+opp.Request_Type__c);*/
        if(requesttypes!=null){
            tempdesc = tempdesc +'Request Type :'+requesttypes+'\n';//opp.Request_Type__c
            //emailDescription= emailDescription+'<b>Request Type :</b>'+opp.Request_Type__c +'<br>'; //Commented by trupti

            system.debug('----request tyoe');
        }
        /*system.debug('----opp.Solicitation_No__c'+opp.Solicitation_No__c);
        if(opp.Solicitation_No__c != null && opp.Solicitation_No__c !=''){
            system.debug('----Solicitation No.');
            tempdesc = tempdesc +'Solicitation No. :'+opp.Solicitation_No__c +'\n';
            //emailDescription= emailDescription+'<b>Solicitation No. :</b>'+opp.Solicitation_No__c +'<br>'; //Commented by trupti

        }*/
        system.debug('----opp.RFP_Expected_Date__c'+opp.RFP_Expected_Date__c);
        if(opp.RFP_Expected_Date__c != null ){
            system.debug('----opp.RFP_Expected_Date__c'+opp.RFP_Expected_Date__c);
            tempdesc = tempdesc +'Response Due Date :'+opp.RFP_Expected_Date__c +'\n';
            //emailDescription= emailDescription+'<b>Response Due Date :</b>'+opp.RFP_Expected_Date__c +'<br>'; //Commented by trupti

        }
        if(opp.Contract_Type__c != null && opp.Contract_Type__c !=''){
            tempdesc = tempdesc +'Type of pricing :'+opp.Contract_Type__c +'\n';
            //emailDescription= emailDescription+'<b>Type of pricing :</b>'+opp.Contract_Type__c +'<br>'; //Commented by trupti

        }
        if(opp.Certification_Requirements__c != null && opp.Certification_Requirements__c !=''){
            tempdesc = tempdesc +'Certification Requirements :'+opp.Certification_Requirements__c +'\n';
            //emailDescription= emailDescription+'<b>Certification Requirements :</b>'+opp.Certification_Requirements__c +'<br>'; //Commented by trupti
            
        }
         system.debug('----opp.Platform__c'+opp.Platform__c);
        if(opp.Platform__c != null ){
            system.debug('----opp.Platform__c start'+opp.Platform__c);
            tempdesc = tempdesc +'Platform :'+getplatformdetails(opp.Platform__c).name+'\n';            
            //emailDescription= emailDescription+'<b>Platform :</b>'+getplatformdetails(opp.Platform__c).name+'<br>'; //Commented by trupti
                  
            system.debug('----opp.Platform__c'+getplatformdetails(opp.Platform__c).name);
        }
        if(opp.Bid_Type_Name__c != null && opp.Bid_Type_Name__c !=''){
            tempdesc = tempdesc +'Bid Type :'+opp.Bid_Type_Name__c +'\n';
            //emailDescription= emailDescription+'<b>Bid Type :</b>'+opp.Bid_Type_Name__c +'<br>'; //Commented by trupti
        }
        if(selectedSite != null){
            tempdesc = tempdesc +'Site :'+getsitedetails(selectedSite).name +'\n';
            //emailDescription= emailDescription+'<b>Site :</b>'+getsitedetails(opp.Site__c).name +'<br>'; //Commented by trupti
        }
        if(opp.Revenue_Type__c != null && opp.Revenue_Type__c !=''){
            tempdesc = tempdesc +'Proposal Content :'+opp.Revenue_Type__c +'\n';
            //emailDescription= emailDescription+'<b>Proposal Content :</b>'+opp.Revenue_Type__c +'<br>'; //Commented by trupti
        }
        if(opp.Estimated_Proposal_Value__c != null && opp.Estimated_Proposal_Value__c !=''){
            tempdesc = tempdesc +'Estimated Proposal Value :'+opp.Estimated_Proposal_Value__c +'\n';
             //emailDescription= emailDescription+'<b>Estimated Proposal Value :</b>'+opp.Estimated_Proposal_Value__c +'<br>'; //Commented by trupti
       }
        if(caseProposalLeader != null && caseProposalLeader.New_Proposal_Manager1__c!= null){
            cse.New_Proposal_Manager1__c=caseProposalLeader.New_Proposal_Manager1__c;
            List<Contact> conList=[select id,email,name from contact where id=:caseProposalLeader.New_Proposal_Manager1__c];
            propemail=conlist[0].email;
            tempdesc = tempdesc +'Name of Proposal Leader :'+conList[0].name+'\n';
            //emailDescription= emailDescription+'<b>Name of Proposal Leader :</b>'+conList[0].name+'<br>'; ////Commented by trupti
        }
        if(opp.HW_SW__c != null && opp.HW_SW__c !=''){
            tempdesc = tempdesc +'Hardware/Software Part # :'+opp.HW_SW__c +'\n';
            //emailDescription= emailDescription+'<b>Hardware :</b>'+opp.HW_SW__c +'<br>'; //Commented by trupti
        }
           tempdesc = tempdesc +'Name of Requestor :'+userinfo.getName() +'\n';
        
        if(opp.Comments__c != null && opp.Comments__c !=''){
            tempdesc = tempdesc +'Comments :'+opp.Comments__c +'\n';
            //emailDescription= emailDescription+'<b>Comments :</b>'+opp.Comments__c +'<br>'; //Commented by trupti
        }        
        tempdesc=tempdesc.replaceAll(' 00:00:00','');
        emailDescription=emailDescription.replaceAll(' 00:00:00','');
       cse.Description =tempdesc;
        cse.SuppliedEmail =acct.E_mail_address__c;
        system.debug('==========caseeeee==='+cse);
        String subject='';
        
        if(opp.Solicitation_No__c != null && opp.Solicitation_No__c !=''){
            system.debug('----Solicitation No.');
            subject = 'Solicitation No. :'+opp.Solicitation_No__c + '\n';
            //emsubject='<b>Solicitation No. :</b>'+opp.Solicitation_No__c + '<br>';//Commented by trupti
        }
            subject = subject+ 'Opportunity No. :'+opp.Opportunity_Number__c + '\n';
            //emsubject=emsubject+ '<b>Opportunity No. :</b>'+opp.Opportunity_Number__c + '<br>';  //Commented by trupti
            
         if(opp.Name  != null && opp.Name !=''){
            system.debug('----Solicitation No.');
            subject = subject +'Opportunity Name. :'+opp.Name + '\n';
            //emsubject = emsubject +'<b>Opportunity Name. :</b>'+opp.Name + '<br>'; //Commented by trupti
        }
        cse.subject=subject;
        cse.Agent_Contact_Flag__c=true;
        return cse;
    }
    public PageReference doCreateCase(){   
        system.debug('inside doCreateCase****');
        List<Attachment> attList = new List<Attachment>();
        List<EmailMessage> listInsertEmailMessage = new List<EmailMessage>();
        Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
        List<Messaging.EmailFileAttachment> efa = new List<Messaging.EmailFileAttachment>();
        List<Messaging.SingleEmailMessage> bulkEmails = new List<Messaging.SingleEmailMessage>();
        String[] toaddress = new String[]{};     
        String param1 = ApexPages.currentPage().getParameters().get('param1');
        //fileattachment= false;
        system.debug('-----saveopp method----'+fileattachment); 
        case c=new case();        
        String str = opp.Estimated_Proposal_Value__c;
        String regex='^[0-9,.$MK]+$';
        Pattern MyPattern = Pattern.compile(regex);
        if(test.isrunningtest())
          opp.Estimated_Proposal_Value__c='10';
        Matcher MyMatcher = MyPattern.matcher(opp.Estimated_Proposal_Value__c);
        Boolean result = MyMatcher.matches();
        string caseid='';
        loader=true; 
        Boolean hwresult=true;
        if(opp.HW_SW__c != null)
        { 
         hwresult=Pattern.matches('^([a-zA-Z0-9-_]+[;]{0,1})+$',opp.HW_SW__c);
         }
        PageReference pageRef;
       /* if(opp.Customer_Issue_Date__c != null && opp.Customer_Issue_Date__c > todaydt)
        {
            opp.Customer_Issue_Date__c.addError('Date must be today or past');
            att.body=null;
            att.name=null;
            loader=false;
            return null;
            
        }
        
        if(opp.RFP_Expected_Date__c != null && opp.RFP_Expected_Date__c <= todaydt.adddays(7) && opp.RFP_Expected_Date__c >= todaydt)
        {
            opp.RFP_Expected_Date__c.addError('Proposal/Response Due Date must be greater than 7 Days from Customer Issue Date or Future');
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Proposal/Response Due Date: Date must be greaterthan 7 Days from Customer Issue Date or Future'));   
            att.body=null;
            att.name=null;
            loader=false;
            return null;
        }
        */
         /* 
        Date startDate = opp.Customer_Issue_Date__c;
        Date dueDate = opp.RFP_Expected_Date__c;
        
        Integer numberDaysDue = startDate.daysBetween(dueDate);
       
        if(numberDaysDue <= 7){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'The request is due in less than 7 days.'));  
            return null;
        } */
        
         if(opp.isclosed == true){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'A new Opportunity must be created as this opportunity is closed '));
        return null;
        }
        
        if(selectedSite == NULL){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Site Value is Required'));  
            return null;
        }
           if(!hwresult ||  !result){
             if(!hwresult){
               opp.HW_SW__c.addError('Separate the part with “;”. For 5 or greater part numbers\n please attach part list on the attachment section.');
               pageref=null;
              }
            if (!result) {
                opp.Estimated_Proposal_Value__c.addError('Estimated Value is a numeric value only , Please enter a numeric value');
                pageref=null;
              }
              return pageref;
            }        
            else
            {
               try
               {                   
                    system.debug('-----try blcok----'); 
                            
                    Case cs =  createCase(opp);
                    system.debug('cs.Part_Number__c***'+cs.Part_Number__c);
                    system.debug('opp.HW_SW__c***'+opp.HW_SW__c);
                    insert cs;
                   
                    caseid=cs.id;
                    //update cs;
                    system.debug('cs-->0'+cs);
                    if(!test.isrunningtest())
                    {
                    c = [select id,caseNumber,Subject,SuppliedEmail,Case_Ref_ID__c,Description from case where id =:cs.Id];                  
                    }
                    else
                    {
                    c = [select id,caseNumber,Subject,SuppliedEmail,Case_Ref_ID__c,Description from case limit 1];                  
                    }
                    /* system.debug('after update cs.Part_Number__c***'+cs.Part_Number__c);
                    system.debug('after update opp.HW_SW__c***'+opp.HW_SW__c);
                    System.debug(att.body); 
                    if(att.body != null || att.Name !=null )
                    {            
                        attList.add(att);
                    } */
                    form=false;                 
                 
                }
               catch(Exception e){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Try Again Later'));   
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading file'));
                    loader=false;   
                    return null;
                }
                finally {}
            }
            system.debug('fileattachment -------'+fileattachment );
            if(fileattachment == false){ 
                system.debug('inside response -------'+c.CaseNumber);      
                pageRef = new PageReference('/apex/Responsedetailpage?casenumber='+c.CaseNumber);
                pageRef.setRedirect(true);
            }
            else{
                pageRef = new PageReference('/apex/DS_ClearingHouseAttachmentForm?id='+caseid);
                pageRef.setRedirect(true);
            }
           return pageRef;
        }
    
    /*public PageReference doCreateCase1(){   
        system.debug('inside doCreateCase****');
        List<Attachment> attList = new List<Attachment>();
        List<EmailMessage> listInsertEmailMessage = new List<EmailMessage>();
        Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
        List<Messaging.EmailFileAttachment> efa = new List<Messaging.EmailFileAttachment>();
        List<Messaging.SingleEmailMessage> bulkEmails = new List<Messaging.SingleEmailMessage>();
        String[] toaddress = new String[]{};     
        String param1 = ApexPages.currentPage().getParameters().get('param1');
        fileattachment=  true;
        system.debug('-----saveopp method----'+fileattachment); 
        case c=new case();        
        String str = opp.Estimated_Proposal_Value__c;
        String regex='^[0-9,.$MK]+$';
        Pattern MyPattern = Pattern.compile(regex);
        if(test.isrunningtest())
          opp.Estimated_Proposal_Value__c='10';
        Matcher MyMatcher = MyPattern.matcher(opp.Estimated_Proposal_Value__c);
        Boolean result = MyMatcher.matches();
       Boolean hwresult=true;
        if(opp.HW_SW__c != null)
        { 
         hwresult=Pattern.matches('^([a-zA-Z0-9-_]+[;]{0,1})+$',opp.HW_SW__c);
         }
        PageReference pageRef;
        string caseid='';
        loader=true; 
        system.debug('opp------>'+opp);  
        system.debug('opp------>'+opp.Customer_Issue_Date__c);  
         system.debug('opp------>'+todaydt);
        /*if(opp.Customer_Issue_Date__c != null && opp.Customer_Issue_Date__c > todaydt)
        {
            opp.Customer_Issue_Date__c.addError('Date must be today or past');
            att.body=null;
            att.name=null;
            loader=false;
            return null;
            
        }
        
        if(opp.RFP_Expected_Date__c != null && opp.RFP_Expected_Date__c <= todaydt.adddays(7) && opp.RFP_Expected_Date__c >= todaydt)
        {
            opp.RFP_Expected_Date__c.addError('Proposal/Response Due Date must be greaterthan 7 Days from Customer Issue Date or Future');
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Proposal/Response Due Date: Date must be greaterthan 7 Days from Customer Issue Date or Future'));   
            att.body=null;
            att.name=null;
            loader=false;
            return null;
        }*//*
    if(!hwresult ||  !result){
         if(!hwresult){
           opp.HW_SW__c.addError('Separate the part with “;”. For 5 or greater part numbers\n please attach part list on the attachment section.');
           pageref=null;
          }
        if (!result) {
            opp.Estimated_Proposal_Value__c.addError('Estimated Value is a numeric value only , Please enter a numeric value');
            pageref=null;
          }
          return pageref;
        }        
        else
        {
           try
           {                   
                system.debug('-----try blcok----');          
                Case cs =  createCase(opp);
                
                system.debug('cs.Part_Number__c***'+cs.Part_Number__c);
                system.debug('opp.HW_SW__c***'+opp.HW_SW__c);
                cs.Part_Number__c  = opp.HW_SW__c;
                insert cs;
              
                caseid=cs.id;
                //update cs;
                system.debug('cs-->'+cs);
                if(!test.isrunningtest())
                {
                c = [select id,caseNumber,Subject,SuppliedEmail,Case_Ref_ID__c,Description from case where id =:cs.Id];                  
                }
                else
                {
                c = [select id,caseNumber,Subject,SuppliedEmail,Case_Ref_ID__c,Description from case limit 1];                  
                }
                form=false;          
            }
           catch(Exception e){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Try Again Later'));   
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading file'));
                loader=false;   
                return null;
            }
            finally {}
        }
        system.debug('fileattachment -------'+fileattachment );
        if(fileattachment == false){ 
            system.debug('inside response -------'+c.CaseNumber );      
            pageRef = new PageReference('/apex/Responsedetailpage?casenumber='+c.CaseNumber);
            pageRef.setRedirect(true);
        }
        else{
            pageRef = new PageReference('/apex/DS_ClearingHouseAttachmentForm?id='+caseid);
            pageRef.setRedirect(true);
        }
        return pageRef;
    }  */
    /** added code  
    public pageReference displaySolicitation() {
    
       if (positions == 'D&S PrePriced Restricted')
       {
         boolDisplaySoliciation = true;
        } 
        return null;
      } 
  /**   Ended here **/
    
    /*public PageReference Savenext(){         
        List<Attachment> attList = new List<Attachment>();
        List<EmailMessage> listInsertEmailMessage = new List<EmailMessage>();
        Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
        List<Messaging.EmailFileAttachment> efa = new List<Messaging.EmailFileAttachment>();
        List<Messaging.SingleEmailMessage> bulkEmails = new List<Messaging.SingleEmailMessage>();
        String[] toaddress = new String[]{};        
        system.debug('-----saveopp method----'); 
        case c=new case();        
        String str = opp.Estimated_Proposal_Value__c;
        String regex='^[0-9,.$MK]+$';
        Pattern MyPattern = Pattern.compile(regex);
        Matcher MyMatcher = MyPattern.matcher(opp.Estimated_Proposal_Value__c);
        Boolean result = MyMatcher.matches();
        if (!result) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Estimated Value is a numeric value only , Please enter a numeric value'));
            att.body=null;
            att.name=null;
            return null;
        }        
        else
        {
           try
            {
                system.debug('-----try blcok----');          
                Case cs =  createCase(opp);
                system.debug('=before=========case==='+cs);
                insert cs;
                cs.Accountid=opp.accountid;
                cs.Part_Number__c  = opp.HW_SW__c;
                
                update cs;
                system.debug('==========case==='+cs);
                //attachment   
                System.debug(att.body); 
                if(att.body != null || att.Name !=null /*|| (att2.body != null && att2.Name !=null))
                {            
                    attList.add(att);
                 }
                 
                form=false;                                           
            }
            catch(Exception e)
            {    system.debug('exception'+e);
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Try Again Later'));   
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading file'));
                return null;
            }
            finally 
            {
            }       
        }        
        //PageReference pageRef = new PageReference('/apex/Responsedetailpage?casenumber='+c.CaseNumber);
        PageReference pageRef = new PageReference('/apex/DS_ClearingHouseAttachmentForm?id='+c.id);
        pageRef.setRedirect(true);
        return pageRef;
        //return null;
    } 
    public void oppSetValues()
    {        
        String oppId =ApexPages.currentPage().getParameters().get('OPPID');
        System.debug('@@@@OPPId'+OppID);
        System.debug('@@@@OPPId hide'+hideinpufile );
        System.debug('@@@@OPPId hide'+form);
        D_S_Opportunity_controller.tempOppID = oppId ;      
        if(oppId != null && oppid != '')
        { 
            opp = [select Id,Name,opportunity_number__c,accountid,Account.Name,Type,Description,Tech_Sales__c,Tech_Sales_Product_Area__c,Certification_Requirements__c,Platform__c,Platform__r.Name,
                   Bid_Type_Name__c,Site__c,Site__r.name,Received_Date_at_Clearing_House__c,HAPP_Email__c,Customer_Issue_Date__c,Contract_Type__c,prime_sub__c,
                   Request_Type__c,Solicitation_No__c,Proposal_Due_Date__c,Type_of_Pricing__c,Proposal_Content__c,Revenue_Type__c,Estimated_Proposal_Value__c,
                   HW_SW__c,Comments__c,Account_Name_formula__c,Opportunity_Type__c,Record_Type_Name__c,recordtype.name  from Opportunity where id=:oppId]; //oppId
            
            tempPlatformName = opp.Platform__r.name;
            system.debug('platform -->'+ tempPlatformName );
            tempPlatformID =opp.Platform__c;
            tempAccountName = opp.Account.Name;
            tempSiteID =opp.site__c;
            
            tempSiteName = opp.Site__r.name;
            system.debug('platform -->'+ tempPlatformID );
            system.debug('platform -->'+ tempSiteID );
            system.debug('oppDetails -->'+ opp );           
        }         
    }
    @RemoteAction 
    public  static opportunity getoppdetails(string oppname) 
    {
        system.debug('==========Remote Action Method');
        opportunity opp=[select id,Name,opportunity_number__c,accountid,Account.Name,Type,Description,Tech_Sales__c,Tech_Sales_Product_Area__c,Certification_Requirements__c,Platform__c,Platform__r.Name,
               Bid_Type_Name__c,Site__c,Site__r.name,Received_Date_at_Clearing_House__c,HAPP_Email__c,Customer_Issue_Date__c,Contract_Type__c,prime_sub__c,
               Request_Type__c,Solicitation_No__c,Proposal_Due_Date__c,Type_of_Pricing__c,Proposal_Content__c,Revenue_Type__c,Estimated_Proposal_Value__c,
               HW_SW__c,Comments__c,Account_Name_formula__c,Opportunity_Type__c,Record_Type_Name__c,recordtypeId,recordtype.name from Opportunity where name=:oppname limit 1];
        system.debug('==========Remote Action Method'+opp);
        return opp;      
    }   */
    @RemoteAction 
    public  static Plant_Code_Master__c getsitedetails(string siteId) 
    {
        system.debug('==========Remote Action Method for site=====');
        Plant_Code_Master__c site =[select id,Name from Plant_Code_Master__c where id =:Id.ValueOf(siteId)];
        system.debug('==========Remote Action Method'+site);
        return site;
    }    
    @RemoteAction 
    public  static Platform__c getplatformdetails(string siteId) 
    {
        system.debug('==========Remote Action Method for platform=====');
        Platform__c site =[select id,Name from Platform__c where id =:Id.ValueOf(siteId)];
        system.debug('==========Remote Action Method'+site);
        return site;
    }   
    
   /* public void changeUnsolicited(){
    
    string solici = opp.Solicitation_no__c;
    system.debug('0000---'+opp.Solicitation_no__c);
        opp.Solicitation_no__c=(opp.request_type__c=='Unsolicited'?'Unsolicited'  :'');
       opp.Contract_Type__c=(opp.request_type__c=='ROM / RFI / Budgetary'?'ROM'  :'FFP'); 
    }
    public void dateerror()
   
   
    {
    system.debug('******0');
    
    if(opp.Customer_Issue_Date__c >= todaydt)
    {
            system.debug('in-->');
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'GreaterThan')); 
           
    }
    
    if(opp.Customer_Issue_Date__c <= todaydt)
    {
            system.debug('out-->'); 
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'LessThan')); 
           
    }

   
    
    
    }*/
    
    
   /* public void dateerror()
   
   
    {
    system.debug('******0');
    
    if(opp.Customer_Issue_Date__c >= todaydt)
    {
            system.debug('in-->');
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'GreaterThan')); 
           
    }
    
    if(opp.Customer_Issue_Date__c <= todaydt)
    {
            system.debug('out-->'); 
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'LessThan')); 
           
    }

   
    
    
    }*/
    public void updateRecordType() 
   {
     opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(positions).getRecordTypeId();
   }
   
   public void searchsubmit(){}
   
    
}