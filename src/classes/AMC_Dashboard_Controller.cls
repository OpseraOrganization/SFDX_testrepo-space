/***********************************************************************************************************
* Company Name          : NTT Data
* Name                  : AMC_Dashboard_Controller 
* Description           : Controller for the AMC Dashboard Page 
* Project               : GTO Usability Project
***********************************************************************************************************/
public class AMC_Dashboard_Controller {
    
    public List<Service_Request__c> serReqList {get; set;}
    
    public List<Service_Request__c> getSerRequest(){
        //if(serReqList)
        system.debug('serReqList>>' + serReqList);
        return serReqList;
    }
    
    
    public AMC_Dashboard_Controller(){
        serReqList = new List<Service_Request__c>();
        serReqList = [SELECT AMC_Item__c,Customer_Update__c ,Name,Product_Number__c,Product_Description__c,Customer_Due_Date__c,Account_Name__r.Name,Aircraft_Type__r.Name,Problem_Description__c,
        Status_for_Ext_Cust_Comment__c,Subject__c  
        FROM Service_Request__c order by CreatedDate desc LIMIT 1000]; 
        
    }
    /*public Integer getinterval(){
        
    }*/
    public string getColor(){
        return 'val red';
    }
}