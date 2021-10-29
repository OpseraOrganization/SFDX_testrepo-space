public with sharing class DS_CLS_UploadAttachment {

    public boolean attachmentsection{get;set;} 
    public List<attachment> attlist;

    public DS_CLS_UploadAttachment(ApexPages.StandardController controller) {
      List<attachment> attlist = new List<attachment>();
      parentId=ApexPages.currentPage().getParameters().get('id');
      attlist = [SELECT Id, Name, ContentType,createddate,description,CreatedBy.name 
                    FROM Attachment 
                        WHERE ParentId = :parentId ];
      system.debug('attlist::'+attlist);
    }
     //This variable is to hold the ID we are uploading attachment for
  public string parentId{get;set;}
   
    public Attachment a{
        get {
          if (a == null)
            a = new Attachment();
          return a;
        }
        set;
    }
    
    public list<attachment> ats
    {
        get
        {
            list<attachment> tempList = [SELECT Id, Name, ContentType,createddate,description,CreatedBy.name 
                                            FROM Attachment 
                                                WHERE ParentId = :parentId 
                                                    ORDER BY createddate desc];
            return tempList;
        }
    }
    
    //we are not using this, as we upload it in Javascript
    public pagereference upload()
    {
        try
        {
            if(!string.isEmpty(a.name) && a.Body != null)
            {
                
                    system.debug(a.name);
                    system.debug(parentID);
                    a.parentid = parentId;
                    insert a;
                    a.body=null;
                    return new pagereference('/'+parentID);
            }
            else
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Choose a file and Provide file name to upload.')); 
            }
        }
        catch(DmlException ex)
        {
            apexpages.addMessages(ex);
        }
        catch(Exception ex)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error in Uploading Document: '+ex.getMessage())); 
        }
        return null;
    }
    public pagereference pageredirect()
    {   
        string emsubject='';
        string emailDescription='';
         string casedesc='';
        string hwswvalue='';
        List<Attachment> attList = new List<Attachment>();
        List<EmailMessage> listInsertEmailMessage = new List<EmailMessage>();
        Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
        List<Messaging.EmailFileAttachment> efa = new List<Messaging.EmailFileAttachment>();
        List<Messaging.SingleEmailMessage> bulkEmails = new List<Messaging.SingleEmailMessage>();
        String[] toaddress = new String[]{};        
        
        EmailTemplate em= [Select id,Name,HTMLValue,Subject,Body from EmailTemplate WHERE id=:label.D_SClearingHouseFormEmailTemp ];    
        string emailsub = em.Subject;
        string emailhtmlbody=em.HTMLValue;
        case c=new case();
        if(!test.isrunningtest())
        c=[SELECT id,casenumber,subject,Case_Ref_ID__c,Description,SuppliedEmail,Opportunity__r.Opportunity_Number__c,
                       Opportunity__r.Name,Opportunity__r.recordtype.name,Platform__c,Opportunity__r.account.name,Plant__c,Tech_Sales__c,Tech_Sales_Product_area__c,
                       Received_Date__c,Request_Type_Opp__c,Type_of_pricing__c,Certification_Requirements__c,classification__c,proposal_content__c,estimated_proposal_value__c,Part_Number__c,comments__c,New_Proposal_Manager1__r.name,Customer_issue_date__c,Proposal_Response_due_date__c,Solicitation_Number__c  
                FROM case 
                WHERE id=:parentId];
        casedesc=c.Description;
        if(test.isrunningtest()){
            
        }
        else{
        if(casedesc.contains('Hardware/Software Part # :')){
        system.debug('casedesc is ::'+casedesc);
        hwswvalue=casedesc.substringBetween('Hardware/Software Part # :', 'Name of Requestor :');
        system.debug('hwsw is::'+hwswvalue);
        }
        else{
         hwswvalue='';   
        }
        }
        if(test.isrunningtest())
        c=[SELECT id,casenumber,subject,Case_Ref_ID__c,Description,SuppliedEmail,Opportunity__r.Opportunity_Number__c,
                       Opportunity__r.Name,Opportunity__r.recordtype.name,Platform__c,Opportunity__r.account.name,Plant__c,Tech_Sales__c,Tech_Sales_Product_area__c,
                       Received_Date__c,Request_Type_Opp__c,Type_of_pricing__c,Certification_Requirements__c,classification__c,proposal_content__c,estimated_proposal_value__c,Part_Number__c,comments__c,New_Proposal_Manager1__r.name,Customer_issue_date__c,Proposal_Response_due_date__c,Solicitation_Number__c  
                FROM case limit 1];        
        system.debug('Case Record:: '+c);
        attList=[select id,name,body FROM attachment WHERE parentid=:c.id];
        if(test.isrunningtest())
        attList=[select id,name,body FROM attachment limit 1];
        //Added on 2 Nov,18
        if(attList == NULL || attList.isEmpty()){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please upload at least 1 attachment to proceed.'));
            return null;
        }
        /* if(opp.Solicitation_No__c != null && opp.Solicitation_No__c !=''){
            system.debug('----Solicitation No.');
            subject = 'Solicitation No. :'+opp.Solicitation_No__c + '\n';
            emsubject='<b>Solicitation No. :</b>'+opp.Solicitation_No__c + '<br>';
        }
        subject = subject+ 'Opportunity No. :'+opp.Opportunity_Number__c + '\n';
        emsubject=emsubject+ '<b>Opportunity No. :</b>'+opp.Opportunity_Number__c + '<br>';           
        if(opp.Name  != null && opp.Name !=''){
            system.debug('----Solicitation No.');
            subject = subject +'Opportunity Name. :'+opp.Name + '\n';
            emsubject = emsubject +'<b>Opportunity Name. :</b>'+opp.Name + '<br>';
        } */
        if(c.subject != null && c.subject != ''){
            emailsub = emailsub.replace('{!Case.Subject}',c.subject);
            emailhtmlbody = emailhtmlbody.replace('{!Case.Subject}','<br/>' + emsubject);
        }
        else{
            emailsub = emailsub.replace('{!Case.Subject}','');
            emailhtmlbody = emailhtmlbody.replace('{!Case.Subject}','');
        }
        if(c.CaseNumber != null && c.CaseNumber != '')  {
            emailsub = emailsub.replace('{!Case.CaseNumber}',c.CaseNumber);
            emailhtmlbody = emailhtmlbody.replace('{!Case.CaseNumber}',c.CaseNumber);
        }
        else{
            emailsub = emailsub.replace('{!Case.CaseNumber}','');
            emailhtmlbody = emailhtmlbody.replace('{!Case.CaseNumber}','');
        }
        if(c.Case_Ref_ID__c != null && c.Case_Ref_ID__c != ''){
            emailsub = emailsub.replace('{!Case.Case_Ref_ID__c}',c.Case_Ref_ID__c);
            emailhtmlbody = emailhtmlbody.replace('{!Case.Case_Ref_ID__c}',c.Case_Ref_ID__c);
        }
        else{
            emailsub = emailsub.replace('{!Case.Case_Ref_ID__c}','');
            emailhtmlbody = emailhtmlbody.replace('{!Case.Case_Ref_ID__c}','');
        }
        if(c.Description != null && c.Description != ''){
            emailhtmlbody = emailhtmlbody.replace('{!Case.Description}',emailDescription);
        }
        else{
            emailhtmlbody = emailhtmlbody.replace('{!Case.Description}','');
        }
        
        //Added by trupti - 14 Nov,18
        emailhtmlbody = emailhtmlbody.replace('{!Opportunity.Opportunity_Number__c}',c.Opportunity__r.Opportunity_Number__c);
        emailhtmlbody = emailhtmlbody.replace('{!Opportunity.Name}',c.Opportunity__r.Name);
        emailhtmlbody = emailhtmlbody.replace('{!Opportunity.Account}',c.Opportunity__r.account.name);
        emailhtmlbody = emailhtmlbody.replace('{!Opportunity.Contract_Type__c}',c.Type_of_pricing__c);
        emailhtmlbody = emailhtmlbody.replace('{!Opportunity.Type}', c.Opportunity__r.recordtype.name);
        if(c.Plant__c != NULL)
        emailhtmlbody = emailhtmlbody.replace('{!Opportunity.Site__c}',getsitedetails(c.Plant__c).name);
        emailhtmlbody = emailhtmlbody.replace('{!Opportunity.Site__c}','');
        emailhtmlbody = emailhtmlbody.replace('{!Opportunity.Certification_Requirements__c}',c.Certification_Requirements__c);
        if(c.Received_Date__c != NULL)
        emailhtmlbody = emailhtmlbody.replace('{!Opportunity.Received_Date_at_Clearing_House__c}',String.valueOf(c.Received_Date__c));
        emailhtmlbody = emailhtmlbody.replace('{!Opportunity.Received_Date_at_Clearing_House__c}', '');
        if( c.Request_Type_Opp__c != NULL)
        emailhtmlbody = emailhtmlbody.replace('{!Opportunity.Request_Type__c}',c.Request_Type_Opp__c);
        emailhtmlbody = emailhtmlbody.replace('{!Opportunity.Request_Type__c}', '');
        if( c.Tech_Sales__c != NULL)
        emailhtmlbody = emailhtmlbody.replace('{!Opportunity.Tech_Sales__c}',c.Tech_Sales__c);
        emailhtmlbody = emailhtmlbody.replace('{!Opportunity.Tech_Sales__c}','');        
        if(c.Tech_Sales_Product_area__c != NULL)
        emailhtmlbody = emailhtmlbody.replace('{!Opportunity.Tech_Sales_Product_Area__c} ', c.Tech_Sales_Product_area__c);
        emailhtmlbody = emailhtmlbody.replace('{!Opportunity.Tech_Sales_Product_Area__c} ', '');        
        if(getplatformdetails(c.Platform__c).name != NULL)
        emailhtmlbody = emailhtmlbody.replace('{!Opportunity.Platform__c}',getplatformdetails(c.Platform__c).name);
        emailhtmlbody = emailhtmlbody.replace('{!Opportunity.Platform__c}','');     
        if(c.classification__c != NULL)
        emailhtmlbody = emailhtmlbody.replace('{!Opportunity.Bid_Type_Name__c}',c.classification__c);
        emailhtmlbody = emailhtmlbody.replace('{!Opportunity.Bid_Type_Name__c}','');
        if(c.proposal_content__c != NULL)
        emailhtmlbody = emailhtmlbody.replace('{!Opportunity.Revenue_Type__c}',c.proposal_content__c);
        emailhtmlbody = emailhtmlbody.replace('{!Opportunity.Revenue_Type__c}','');
        if(c.estimated_proposal_value__c != NULL)
        emailhtmlbody = emailhtmlbody.replace('{!Opportunity.Estimated_Proposal_Value__c}',c.estimated_proposal_value__c);
        emailhtmlbody = emailhtmlbody.replace('{!Opportunity.Estimated_Proposal_Value__c}','');
        if(hwswvalue!= NULL)
                emailhtmlbody = emailhtmlbody.replace('{!Opportunity.HW_SW__c}', hwswvalue);
                emailhtmlbody = emailhtmlbody.replace('{!Opportunity.HW_SW__c}', '');
            if(c.New_Proposal_Manager1__r.name != NULL)
                emailhtmlbody = emailhtmlbody.replace('{!Opportunity.Account_Contact_Name__c}', c.New_Proposal_Manager1__r.name);
                emailhtmlbody = emailhtmlbody.replace('{!Opportunity.Account_Contact_Name__c}', '');
            if(c.Customer_issue_date__c != NULL)
                emailhtmlbody = emailhtmlbody.replace('{!Opportunity.Customer_Issue_Date__c}',string.valueOf(c.Customer_issue_date__c));
                emailhtmlbody = emailhtmlbody.replace('{!Opportunity.Customer_Issue_Date__c}', '');
            if(c.Proposal_Response_due_date__c != NULL)
                emailhtmlbody = emailhtmlbody.replace('{!Opportunity.RFP_Expected_Date__c}', string.valueOf(c.Proposal_Response_due_date__c));
                emailhtmlbody = emailhtmlbody.replace('{!Opportunity.RFP_Expected_Date__c}', '');
           
                emailhtmlbody = emailhtmlbody.replace('{!User.Name}', userinfo.getName());
                //emailhtmlbody = emailhtmlbody.replace('{!User.Name}', '');
            
             if(c.Solicitation_Number__c != NULL)
                emailhtmlbody = emailhtmlbody.replace('{!Opportunity.Solicitation_No__c}', c.Solicitation_Number__c);
                emailhtmlbody = emailhtmlbody.replace('{!Opportunity.Solicitation_No__c}', '');
         //End   
        
        if(c.comments__c != NULL)
            emailhtmlbody = emailhtmlbody.replace('{!Opportunity.Comments__c}', c.comments__c);
            emailhtmlbody = emailhtmlbody.replace('{!Opportunity.Comments__c}', '');
        /*END*/
       
        EmailMessage emailToCase = new EmailMessage();
        emailToCase.Incoming = false;
        emailToCase.MessageDate = system.now();
        emailToCase.FromAddress = Label.D_S_Clearing_House_Email;
        emailToCase.FromName = 'Your response';
        emailToCase.ParentId = c.id;
        emailToCase.Status = string.valueof(3);
        emailToCase.ToAddress = c.SuppliedEmail ;
        emailToCase.Subject = emailsub;
        if(emailhtmlbody!=null && emailhtmlbody.length()>0 ){
            if(emailhtmlbody.length()<32000)
                emailToCase.Htmlbody =  emailhtmlbody.substring(0,emailhtmlbody.length());
            else
                emailToCase.HtmlBody =  emailhtmlbody.substring(0,32000);
        }
       
       listInsertEmailMessage.add(emailToCase);
       attList=[SELECT id,name,body FROM attachment WHERE parentid=:c.id];
       for(Attachment a: attlist)
       {         
           Messaging.EmailFileAttachment e = new Messaging.EmailFileAttachment();
           e.setFileName(a.name);
           e.setBody(a.body);
           efa.add(e);
       } 
         
        //send email
        if(c.SuppliedEmail!=null && c.SuppliedEmail!='')
        {
            toaddress.add(c.SuppliedEmail);
        }
        msg.setToAddresses(toaddress);
        msg.setOrgWideEmailAddressId(label.D_S_Clearing_House_Id);
        msg.setSubject(emailsub);
        msg.setHTMLBody(emailhtmlbody);
        msg.setFileAttachments(efa);
        bulkEmails.add(msg);
        system.debug('bulkEmails-----'+bulkEmails.size());
        if(bulkEmails.size()>0)
        {
            if(!test.isrunningtest())
            Messaging.sendEmail(bulkEmails);
        }
        system.debug('listInsertEmailMessage-----'+listInsertEmailMessage);                       
        system.debug('listInsertEmailMessage-----'+listInsertEmailMessage.size());                       
        if(listInsertEmailMessage.size()>0)
        {
            try{
                insert listInsertEmailMessage;
               //Commented on 2 Nov,2018:Duplicate attachments were getting created
               /*for(Attachment a:attList)
                /*{
                     Attachment at=new Attachment();
                      at.body=a.body;
                      at.name=a.name;
                      at.ParentId=emailToCase.id;
                      insert at;
                }*/ 
            }
            catch(exception e)
            {
            }
        }
        PageReference pageRef = new PageReference('/apex/Responsedetailpage?casenumber='+c.CaseNumber);
        pageRef.setRedirect(true); // Added on 2,Nov,2018
        return pageRef ;
    }
     public  static Platform__c getplatformdetails(string siteId) {
        Platform__c site =[SELECT id,Name FROM Platform__c WHERE id =:Id.ValueOf(siteId)];
        system.debug('==========Remote Action Method'+site);
        return site;
    }   
    public  static Plant_Code_Master__c getsitedetails(string siteId) {
        Plant_Code_Master__c site =[SELECT id,Name FROM Plant_Code_Master__c WHERE id =:Id.ValueOf(siteId)];
        system.debug('==========Remote Action Method'+site);
        return site;
    }   
}