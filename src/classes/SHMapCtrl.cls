/**
* (c) 2015 TEKsystems Global Services
*
* Name              : SHMapCtrl
* Created Date      : 11 July, 2016 (19 August 2019 - PMT)
* Created By        : Manjunath Holekade (TEKSystems)
* Purpose           : Controller class for 'SHMap' page and has logic to display stakeholder hierarchy up to 10 levels.
                    : Included the logic to attach the map as part of the Notes and Attachment section under Intelliplan record
* Last Updated By   : Prabuvasan On 24th April 2021
*                       
**/

public class SHMapCtrl{
   
    public string finalNodeList{get; set;}
    public string finalParentList{get; set;} 
    public string finalSupportList{get; set;}
    public string finalTitleList{get; set;}
    public string finalcredList{get; set;}
    public string finalcontSHIDsList{get; set;}
    public string honaccountplanName{get; set;}
    public string honaccountplanID{get; set;}
    public string sfdcBaseURL{get; set;}
    public HON_Account_Plan__c currenthonaccountplan{get; set;}
    public string labelhonaccountplanid{get; set;}
    public string labelhonaccountplanlkpid{get; set;}
    public string labelcontactid{get; set;}
    public string labelcontactlkpid{get; set;}
    public string strImageBlob {get;set;}
    public string objPrefix {get;set;}
    public string finalDecMaker {get;set;}
    
    public SHMapCtrl(ApexPages.StandardController stdController){
        honaccountplanID = System.currentPageReference().getParameters().get('id');
        this.currenthonaccountplan = (HON_Account_Plan__c)stdController.getRecord();  
        sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();     //Get the SFDC base URL
        Schema.DescribeSObjectResult sObjectResult = Stakeholder__c.sObjectType.getDescribe();
        objPrefix = sObjectResult.getKeyPrefix();
        labelhonaccountplanid = System.Label.accountplanfieldid ;
        labelhonaccountplanlkpid= System.Label.accountplanfieldlkpid;
        labelcontactid= System.Label.Contactid;
        labelcontactlkpid= System.Label.Contactlkpid;
        
        List<String> nodeList = new List<String>();
        List<String> titleList = new List<String>();
        List<String> parentList = new List<String>();
        List<String> credList = new List<String>();
        List<String> supportList = new List<String>();
        List<String> contSHIDsList = new List<String>();
        List<String> colDecMaker = new List<String>();        
        Set<Id> tempContactIdsSet = new Set<Id>();    
        List<Stakeholder__c> planList = [select Id, HON_Account_Plan__r.Name,Decision_Maker__c,Influence__c, Support_Level__c, Contact__r.ReportsToId, Contact__r.Name, Contact__r.Title, HON_Account_Plan__c, Contact__r.ReportsTo.Name,  Contact__r.ReportsTo.Title from Stakeholder__c where HON_Account_Plan__c =:currenthonaccountplan.Id]; //Query list of all Stakeholders related to the current HON account plan 
                
        for(Stakeholder__c planListVar :planList ){
            string name = planListVar.Contact__r.Name;
            // US#233 - Remove apostrophe  in Contact name
            // A single apostrophe is an invalid JSON escape sequence ,  breaks the SH Map and renders a blank SHMap even if there are valid stakeholders on the HON account plan
            name =  name.indexof('\'')> 0 ? name.replace('\'', ' '):planListVar.Contact__r.Name;            
             string title = planListVar.Contact__r.Title ;
             // US#233 - Remove Apostrophes in Contact Title         
            title = String.isBlank(planListVar.Contact__r.Title)?' ':((!(String.isBlank(planListVar.Contact__r.Title)) & title.indexof('\'')> 0)?title.replace('\'', ''):planListVar.Contact__r.Title);
          
            string parentName = String.isBlank(planListVar.Contact__r.ReportsTo.Name)?'':planListVar.Contact__r.ReportsTo.Name;
            nodeList.add(name);            
            titleList.add(title);
            parentList.add(parentName);
            contSHIDsList.add('SH-'+planListVar.Id);    //Create the list of stakeholder/contacts - append 'SH-'+stakeholderid in case stakeholder
            
            honaccountplanName = planListVar.HON_Account_Plan__r.Name;
            // US#233 - Remove Apostrophes in HON account plan Name       
            honaccountplanName =  honaccountplanName.indexof('\'')> 0 ? honaccountplanName.replace('\'', ' '):planListVar.HON_Account_Plan__r.Name;
            
            if(planListVar.Influence__c == 'Low'){
                credList.add('&#9733;');            // List to pass the star codes(count included) based on the 'Influence' rating
            }                                  
            else if(planListVar.Influence__c == 'Medium'){
                credList.add('&#9733;&#9733;');
            }                    
            else if(planListVar.Influence__c == 'High'){
                credList.add('&#9733;&#9733;&#9733;');
            }   
            else{
                credList.add('');
            }
            
            if(planListVar.Decision_Maker__c == true){
                colDecMaker.add('Decision Maker');
            } 
            else
            {
                colDecMaker.add('');
            }           
            
                
            if(planListVar.Support_Level__c == 'Anti-Sponsor'){
                supportList.add('Anti-Sponsor'); 
            }                                // List to pass the Support Level values
            else if(planListVar.Support_Level__c == 'Neutral'){
                supportList.add('Neutral');
            }                
            else if(planListVar.Support_Level__c == 'Sponsor'){
                supportList.add('Sponsor');
            }  
            else
            {
                supportList.add('');
            }
               
            tempContactIdsSet.add(planListVar.Contact__r.ReportsToId);  // Temporary list of 'ReportTo' ids
        }
              
       /* for(Integer i=0; i<9;i++){      // Iteration to get the list of contacts upto 9 levels of the hierarchy
            if(tempContactIdsSet.size() > 0){
                List<Contact> imContactList1 = [select Id, ReportsToId, Name, Title, ReportsTo.Name, ReportsTo.Title from Contact where Id IN: tempContactIdsSet]; // Get the list of contacts and related 'ReportTo' ids 
                tempContactIdsSet = new Set<Id>();
                for(Contact imContactList1Var:imContactList1){
                    string name = imContactList1Var.Name;
                    string title = String.isBlank(imContactList1Var.Title)?'':imContactList1Var.Title;
                    string parentName = String.isBlank(imContactList1Var.ReportsTo.Name)?'':imContactList1Var.ReportsTo.Name;
                    nodeList.add(name);
                    titleList.add(title);
                    parentList.add(parentName);
                    contSHIDsList.add(imContactList1Var.Name+'-'+imContactList1Var.Id); //Append to the list of stakeholder/contacts - append the contactname+contactId in case 'Contact'(not Stakeholder)
                    credList.add('0');                                  
                    tempContactIdsSet.add(imContactList1Var.ReportsToId);
                }
            }   
        } */  
        finalNodeList = JSON.serialize(nodeList);  
        finalParentList = JSON.serialize(parentList);  
        finalcredList = JSON.serialize(credList);
        finalTitleList = JSON.serialize(titleList);
        finalSupportList = JSON.serialize(supportList);
        finalcontSHIDsList = JSON.serialize(contSHIDsList);
        finalDecMaker = JSON.serialize(colDecMaker);
        
    }
   
   /* public void attach(){                 // Method to attach the map under Notes and Attachment section
        List<Attachment> existingAttachmentsList = [SELECT Id FROM Attachment WHERE ParentID=:honaccountplanID AND name like 'SH Map -%'];
        if(!existingAttachmentsList.isEmpty())
        {
            delete existingAttachmentsList;
        }
        system.debug('Attachments'+existingAttachmentsList);
        List<HON_Account_Plan__c> currenthonaccountplan = [SELECT Name, Stakeholder_Map_Image_URL__c FROM HON_Account_Plan__c where id =: honaccountplanID ];
        Blob k = EncodingUtil.base64Decode(strImageBlob.replaceFirst('data:image/png;base64,','')); 
        Attachment newAttachment = new Attachment(ParentId = honaccountplanID, Name='SH Map -' + ' ' + currenthonaccountplan[0].Name,  Body = k,ContentType='image/png');
        insert newAttachment;
        currenthonaccountplan[0].Stakeholder_Map_Image_URL__c = sfdcBaseURL + '/servlet/servlet.FileDownload?file=' + newAttachment.id;  // Add the attachment url in the field
        update currenthonaccountplan;
        system.debug('a1a'+newAttachment.id);                
    }   */
}