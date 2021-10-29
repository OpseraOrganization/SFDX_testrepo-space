public class AddExistingSR{
    public String srcId{get;set;}
    public String textValue{get;set;}
    public String Value{get;set;}
    public String srname{get;set;}
    private integer counter=0;  
    private integer list_size=20; 
    public integer total_size; 
    public String currentFeedbackId=apexpages.currentpage().getparameters().get('FEEDBACK');
    Public List<Service_Request__c> SrList{
    get{
        if(con != null)
            return (List<Service_Request__c>)con.getRecords();
        else
           return null;
        
    }set;}
    public ApexPages.StandardSetController con {
        get {
            if(con == null){
                con = new ApexPages.StandardSetController(Database.getQueryLocator([SELECT Id,Name,Account_Name__c,Complexity_Level__c,Customer_Due_Date__c,Subject__c,CreatedDate,OwnerId,SR_SBU__c,Status__c,VOC_Card_Numb__c FROM Service_Request__c where Name Like : Value LIMIT 1000 ]));
                //con.setPageSize(5);
            }
            return con;
        }set;
    }
    public Boolean hasNext {
        get {
        return con.getHasNext();
        }set;
    }
    
    public Boolean hasPrevious {
        get {
        return con.getHasPrevious();
        }set;
    }
    public Integer pageNumber {
        get{
        return con.getPageNumber();
        }set;
    }
    public Integer recordSize {
        get{
        return con.getResultSize();
        }set;
    }
    public void addError(String msg){
    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,msg));
    }
     public void addInfo(String msg){
    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,msg));
    }
    
    public AddExistingSR(){
        SrList=new  List<Service_Request__c>();
        con = new ApexPages.StandardSetController([SELECT Id,Name,Account_Name__c,Complexity_Level__c,Customer_Due_Date__c,Subject__c,CreatedDate,OwnerId,SR_SBU__c,Status__c,VOC_Card_Numb__c FROM Service_Request__c Limit 1000]);
        SrList=con.getRecords();
    }
    public Pagereference setParentRecord(){
        try{
        Service_Request__c Sr=[SELECT Id,Name,Status__c,VOC_Card_Numb__c,ATR_checkbox__c,BGA__c,D_S__c FROM Service_Request__c  where Name=:srname Limit 10]; 
            Sr.VOC_Card_Numb__c=currentFeedbackId;
            Sr.ATR_checkbox__c=true;
            Sr.BGA__c=true;
            Sr.D_S__c=true;
            update Sr;
            }catch(DmlException de){
                addError( 'Could not save'+ de.getMessage());
           }catch(Exception e){
           
           }
            Pagereference  ref=new Pagereference('/'+currentFeedbackId);
                ref.setRedirect(true);   
                return ref; 
    }
   public void letsGo(){
        if(textValue != 'null'){
            Value='%'+textValue+'%';
            try{
                if(con.getRecords().size()>0){
                con = new ApexPages.StandardSetController([SELECT Id,Name,Account_Name__c,Complexity_Level__c,Customer_Due_Date__c,Subject__c,CreatedDate,OwnerId,SR_SBU__c,Status__c,VOC_Card_Numb__c FROM Service_Request__c where Name Like : Value LIMIT 1000 ]);
                con.setPageSize(10);
                }
            }Catch(Exception e){ }
        }
    }
    public void first() {
        con.first();
    }
    public void last() {
        con.last();
    }
    public void previous() {
        con.previous();
    }
    public void next() {
        con.next();
    }
   
}