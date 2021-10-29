@RestResource(urlMapping='/Cases/*')
global class PegaCaseServiceController {
   @HttpPut
    global static void updateCaseFields() {
        String errMessage;
        // Added for INC0000157782
        Integer OpenTaskSize=0; 
        List<Task> TasktoCLose = new List<Task>();
        List<Task> TasktoCLoseUpdate = new List<Task>();
        // End for INC0000157782
        try{
        
        RestRequest request = RestContext.request;
        String caseId = request.requestURI.substring(
        request.requestURI.lastIndexOf('/')+1);
        Case thisCase = [SELECT Id,CaseNumber,(SELECT id,Status,IsClosed from Tasks where IsClosed=FALSE) FROM Case WHERE Id = :caseId]; // Modified for INC0000157782
        FromJSON caseDetail = (FromJSON)JSON.deserialize(request.requestBody.toString(),FromJSON.class);
        System.debug('Request: '+caseDetail);
        if(thisCase!=null){
            // Added for INC0000157782
            system.debug('task size---> '+thisCase.Tasks.size());
            OpenTaskSize = thisCase.Tasks.size();
            if(OpenTaskSize == 0)
                thisCase.status=caseDetail.Status;
            else{
                TasktoCLose = thisCase.Tasks;
                for(Task t:TasktoCLose){
                    t.status = 'Completed';
                    TasktoCLoseUpdate.add(t);
                }
                if(TasktoCLoseUpdate.size()>0){
                    update TasktoCLoseUpdate;
                    thisCase.status=caseDetail.Status;
                }
            }
            // End for INC0000157782
            thisCase.Sub_Status__c=caseDetail.SubStatus;
            if(caseDetail.Status=='Done'){
            thisCase.Resolution__c=Label.Pega_Resolution_Message;
            }
            if(caseDetail.salesOrderNumber==''){
                caseDetail.SalesOrderNumber=null;
            }
            if(caseDetail.SalesOrderNumber!=null){
            thisCase.Sales_Order_Number__c=caseDetail.SalesOrderNumber;
            }
            if(caseDetail.OwnerId!=null){
            thisCase.OwnerId=caseDetail.OwnerId;
            }
            System.debug('Esc: '+caseDetail.EscalatedTo);
            if(caseDetail.EscalatedTo==''){
                caseDetail.EscalatedTo=null;
            }
            if(caseDetail.ReasonForHold!=null){
                thisCase.Reason_for_hold__c=caseDetail.ReasonForHold;
            }
            System.debug('Esc1: '+caseDetail.EscalatedTo);
            List<Contact> planner=[Select Id from Contact where Email=:caseDetail.EscalatedTo limit 1]; // Modified for INC0000270816
            
            if(planner!=null && planner.size()>0 && caseDetail.EscalatedTo!=null){
                thisCase.VN_Name__c=planner[0].id;
                System.debug('$$Planner:'+planner[0].id);
            }  
            System.debug('this case'+thisCase);
        }
       
        update thisCase;
        CaseResponse caseReturn = new CaseResponse(thisCase.CaseNumber,'Success',null);  
        System.debug('Case: '+caseReturn);
        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.responseBody = Blob.valueOf(JSON.Serialize(caseReturn,true));
        System.debug('Res: '+RestContext.response.responseBody);           
        
        }
        catch(QueryException e){
            //errMessage ='Update Failed,Required parameters missing';
            errMessage=e.getMessage();   
            CaseResponse caseReturn = new CaseResponse(null,'Failure',errMessage);
            RestContext.response.addHeader('Content-Type', 'application/json');
            RestContext.response.responseBody = Blob.valueOf(JSON.Serialize(caseReturn,true));

        }
        catch(DMLException e){            
            errMessage=e.getDmlMessage(0);
            if(errMessage.containsIgnoreCase('UpdateTimeinreopen')){
                errMessage='Status of the case must be passed';
            }
           
            CaseResponse caseReturn = new CaseResponse(null,'Failure',errMessage);
            RestContext.response.addHeader('Content-Type', 'application/json');
            RestContext.response.responseBody = Blob.valueOf(JSON.Serialize(caseReturn,true));

        }
    
        catch(Exception e){
            //errMessage ='Update Failed,Required parameters missing';
            errMessage='Error Occured while updating the case';      
            CaseResponse caseReturn = new CaseResponse(null,'Failure',errMessage);
            RestContext.response.addHeader('Content-Type', 'application/json');
            RestContext.response.responseBody = Blob.valueOf(JSON.Serialize(caseReturn,true));

        }
       
    }    
    
     public class CaseResponse{
        public String CaseNumber;
        public String Status;
        public String Error;
        
      public CaseResponse(String caserecNumber, String statusmsg,String errormsg){
         
          CaseNumber = caserecNumber;
          Status = statusmsg;          
          Error =  errormsg;
      }
        
    }
    
    public class fromJSON{
  public String Status;  
  public String SubStatus;
  public String Resolution;
  public String SalesOrderNumber;  
  public Id OwnerId;  
  public String EscalatedTo;  
    public String ReasonForHold;
  
        public fromJSON(){
            
        }     
    }
}