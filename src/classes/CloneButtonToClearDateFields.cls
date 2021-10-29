public class CloneButtonToClearDateFields {
    private ApexPages.StandardController controller {get; set;}
    private Service_Request__c sr {get;set;}
    public ID newRecordId {get;set;}
    public CloneButtonToClearDateFields(ApexPages.StandardController controller) {
        this.controller = controller;
        sr = (Service_Request__c)controller.getRecord();
    }
    public PageReference srCloneWithoutDateFields() {
        Savepoint sp = Database.setSavepoint();
        Service_Request__c newsr;
        try {
            sr = [select Id,Subject__c,SR_Type__c,Priority__c,Status__c,Case_Number__c,Service_Request_Manager__c,Legacy_Siebel_Account_Id__c,Legacy_Siebel_Account_Name__c,Open_SR_Age__c,IsAttachment__c,SR_TAT__c,Gate_1_Completion_Date_in_Age__c,Problem_Description__c,Deliverable__c,Near_Term_Alternate_Fix__c,Status_Resolution__c,GCC__c,Risk_Assessment__c,CSB_Number__c,Title__c,CSB_Gate__c,sr_owner__c,CSB_SR_Manager__c,Product_Family__c,Field_Event_Number__c,Delay_Status__c,Account_Name__c,SBU__c,CBT__c,CBT_Team__c,Contact_Name__c,Contact_Name_Status__c,Primary_Work_Number__c,Primary_Work_Number_Ext__c,Primary_Cell_Number__c,Product_Name__c,Product_Number__c,Product_Serial_Number__c,Product_Types__c,Catalog_Product_Groups__c,Supported_Products__c,Aircraft_Type__c,Aircraft_Tail_Number__c,Customer_Reason_Change__c,Atr__c,Attribute_Sub__c,Attribute_Details__c,Complexity_Level__c,Complexity_Sub_Level__c,SR_SBU__c,SR_CBT__c,SR_Business_Segment__c,Commit_Date_Reason_Change__c,Owner_Job_Title__c,Owner_Manager__c,Created_By_Job_Title__c,Problem_Description_new__c,Problem_Background__c,Customer_Impact__c,Planned_actions__c,Initial_Safety_Assessment__c,SOF__c,SARB_Not_Required__c,Working_Team__c,Recently_Completed_Action__c,Long_Term_SRD_Strategy__c,CRC__c,MISP__c,ATOC__c,AMC__c,OEM_CAB__c,Top_Technical_Issue__c,Emerging_Issue__c,CL_Key_Code__c,Expected_Update_Period__c,Escalation_Tier__c,ATR_checkbox__c,BGA__c,D_S__c,CH1_Status__c,Key_Code__c,PSPM__c from Service_Request__c where id = :sr.id];
            newsr = sr.clone(false);
            insert newsr;
            newRecordId = newsr.id;
        }catch (Exception e){
            Database.rollback(sp);
            ApexPages.addMessages(e);
            return null;
        }
        return new PageReference('/'+newsr.id+'/e?retURL=%2F'+newsr.id);
    }
}