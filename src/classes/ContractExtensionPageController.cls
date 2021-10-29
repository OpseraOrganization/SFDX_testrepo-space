public class ContractExtensionPageController {
    
    public Contract cont {get;set;}
    public Boolean isEdit{get;set;}   
    public  Id contId ;
    public List<SelectOption> extNumberList{get;set;}
    public List<Approver> approverList {get;set;}
    
    
    
    public ContractExtensionPageController(ApexPages.StandardController controller)
    {
        isEdit =false;
        cont = new Contract();
        extNumberList = new List<SelectOption>();
        approverList = new List<Approver>();
        contId =controller.getId();
        cont =[Select id,Name,Contract_Extension_Number__c,Desired_extension_duration__c,EndDate,ContractExtAdditional_Approvers__c,
               Reason_for_extension__c,AnticipatedNewContractExecutionDate__c,Extension_Request_Status__c,Extension_Approver__c
               ,Approved_Date__c,customer_code_s__c,Extension_2_Approved_Date__c,Extension_3_Approved_Date__c,Aircraft_Type__c,ContractExt_DurationHistory__c
               ,Contract_Extension_Number_History__c,Additional_Approver__c,Additional_Approver_2__c
               From Contract Where Id =: contId];
        if(cont.Contract_Extension_Number_History__c!=null && cont.Contract_Extension_Number_History__c!=0 )
        {
            if(cont.Contract_Extension_Number_History__c==1)
            {
                extNumberList.add(new SelectOption('2','2'));
                extNumberList.add(new SelectOption('3','3'));
            }else if(cont.Contract_Extension_Number_History__c==2)
            {
                extNumberList.add(new SelectOption('3','3'));
            }
        }
        else
        {
            extNumberList.add(new SelectOption('1','1'));
            extNumberList.add(new SelectOption('2','2'));
            extNumberList.add(new SelectOption('3','3'));
        }
        if(cont.ContractExtAdditional_Approvers__c !=null)
        {
            String aText=cont.ContractExtAdditional_Approvers__c;
            for(String app : aText.split(';'))
            {
                Approver app1 = new Approver();
                app1.approver.Extension_Approver__c =app.trim();
                approverList.add(app1);
            }
            
        }
        
    }
    public Pagereference doEdit()
    {        
        isEdit=true;        
        return null;
    }
    public Pagereference doSave()
    {
        Integer etnDays =0;
        if(cont.ContractExt_DurationHistory__c !=null)
        {
            etnDays =Integer.valueof(cont.ContractExt_DurationHistory__c);            
        }
          etnDays =Integer.valueOf(cont.Desired_extension_duration__c)+etnDays;
        if(!approverList.isEmpty())
        {
            String aText='';
            for(Approver app : approverList)
            {
                aText=aText+app.approver.Extension_Approver__c+';';
            }
            aText.removeEnd(';');
            cont.ContractExtAdditional_Approvers__c =aText;
        }
        
       // if(etnDays <=180||etnDays >=180)   
       // {
            upsert cont;
            isEdit=false;
       // }  
      //  else
      //  {
           // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Accumulative extension (ext. 1+ ext. 2+ ext. 3) durations cannot exceed 180 days'));
      //  }  
        return null;
    }
    public Pagereference doUpdateDate()
    {
        Integer etnDays =0;
        if(cont.ContractExt_DurationHistory__c !=null)
        {
            etnDays =Integer.valueof(cont.ContractExt_DurationHistory__c);            
        }
        etnDays =Integer.valueOf(cont.Desired_extension_duration__c)+etnDays;
        if( cont.EndDate !=null)
        {
           // if(etnDays <= 180)
           // {
                Date endDate =cont.EndDate;
                System.debug('@@@@endDate'+endDate+'@@@@cont.Desired_extension_duration__c'+cont.Desired_extension_duration__c);
                cont.AnticipatedNewContractExecutionDate__c =endDate.addDays(Integer.valueOf(cont.Desired_extension_duration__c));
           // }
            /*else
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Accumulative extension (ext. 1+ ext. 2+ ext. 3) durations cannot exceed 180 days'));
            }   */           
        }
        return null;
        
    }
    public Pagereference doCancel()
    {
        isEdit=false;
        cont =[Select id,Name,Contract_Extension_Number__c,Desired_extension_duration__c,EndDate,
               Reason_for_extension__c,AnticipatedNewContractExecutionDate__c,Extension_Request_Status__c,Extension_Approver__c,Additional_Approver__c,Additional_Approver_2__c
               ,Approved_Date__c,customer_code_s__c,Extension_2_Approved_Date__c,Extension_3_Approved_Date__c,Aircraft_Type__c,ContractExt_DurationHistory__c
               From Contract Where Id =: contId];
        return null;
    }
    public Pagereference addApprover()
    {              
        approverList.add(new Approver());
        return null;
    }
    public Pagereference removeApprover()
    {        
        if(!approverList.isEmpty())
        {
            approverList.remove(approverList.size()-1);
        }
        return null;
    }
    public Pagereference submitForApproval()
    {
        Integer etnDays =0;
        
        if(cont.ContractExt_DurationHistory__c !=null)
        {
          etnDays =Integer.valueof(cont.ContractExt_DurationHistory__c);            
        }
        etnDays =Integer.valueOf(cont.Desired_extension_duration__c)+etnDays;
       /* if(etnDays <=180)
        {*/
       
            List<Approval.ProcessSubmitRequest> requests = new List<Approval.ProcessSubmitRequest>();
            
            Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();                
            req1.setComments(cont.Reason_for_extension__c);
            req1.setObjectId(cont.id);
            // Submit on behalf of a specific submitter
            req1.setSubmitterId(UserInfo.getUserId());
            /* List<Id> approversIdList = new List<Id>();
            if(!approverList.isEmpty())
            {
            String aText='';
            for(Approver app : approverList)
            {
            approversIdList.add(app.approver.Extension_Approver__c);
            }
            System.debug('@@@@approversIdList'+approversIdList);
            
            
            for (Approver app : approverList) {
            Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
            
            req.setComments(cont.Reason_for_extension__c);
            req.setObjectId(cont.id);
            req.setNextApproverIds(new Id[] {app.approver.Extension_Approver__c});                    
            
            requests.add(req);
            System.debug('@@@requests'+requests);
            }
            System.debug('@@@requests'+requests);
            }      
            */
            requests.add(req1);            
            if(!test.isrunningtest()){
            
            List<Approval.ProcessResult> results = Approval.process(requests);  
              
            }       
       /* }  
        else
        {
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Extenison duration should not be exceed 180 days'));
        }  */
        return null;
        
       // return null;
    }
    public class Approver
    {
        public Contract approver {get;set;}
        public Boolean isAdded {get;set;}
        
        public Approver()
        {
            approver = new Contract();
        }
    }
}