/** * File Name: REG_ToolWrapper

* Description  Get the status of tools for honeywell Id

* * @author : TCS 

Date 01/18/2019 

* */



    
    public class REG_ToolWrapper{
        //Portal_Tools_Master__c masterToolObj = new Portal_Tools_Master__c();
        public String status = '';
        string contactId = '';
        String honeywellId = '';
        dateTime grantedDate;
        dateTime lastLoginDate;
        dateTime requestedDate;
        public string toolId = '';
        string authorizationMethod = '';
        string autoApprove = '';
        string image = '';
        string launchURL = '';
        string name = '';
        string sortOrder = '';
       
        
       // Contact_Tool_Access__c contactToolObj = new Contact_Tool_Access__c();
 
        //This is the contructor method. When we create a new wrapAccount object we pass a Account that is set to the acc property. We also set the selected value to false
        public REG_ToolWrapper(string status, string conId, string honId, dateTime grantedDate, dateTime lastLoginDate, dateTime requestedDate,
                           string toolId, string authMeth, string autoApprove, string Image, string launchURL, string Name, string sortOrder ) {
            
                this.status = status;
                this.contactId = conId;
                this.honeywellId = honId;
                this.requestedDate = requestedDate;
                this.lastLoginDate = lastLoginDate;
                this.grantedDate = grantedDate;
                this.toolId = toolId;
                this.authorizationMethod = authMeth; 
                this.sortOrder  = sortOrder ;
                this.name = name;   
                this.launchURL = launchURL;
                this.image = image;
                this.autoApprove = autoApprove;
            
        }
    }