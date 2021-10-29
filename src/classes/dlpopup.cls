public class dlpopup {
    
    public boolean displaypopup{get;set;}
    public string ASM {get;set;}
    public Boolean refreshPage {get; set;}
    public Boolean showpopup {get; set;}
    public ApexPages.StandardController stdCtrl {get; set;}
    public Discretionary_Line_Item__c dl {get;set;}
    public  String isDtp {get;set;}
    
    public dlpopup(ApexPages.StandardController controller) {
      
        isDtp =ApexPages.currentPage().getParameters().get('isdtp');
        System.debug('@@@url'+isDtp);
        dl= [SELECT Id,Discretionary_Request__c, Discretionary_Request__r.Approval_Status__c,Approval_Status__c,Requested_Amount__c,Req_Amount_changed__c FROM Discretionary_Line_Item__c
             WHERE Id = :ApexPages.currentPage().getParameters().get('id')];
        refreshPage=false;
        stdCtrl=controller;
        if (dl.Discretionary_Request__r.Approval_Status__c == 'new'){
            showpopup=true;
        }else{showpopup=false;}
        system.debug('**********'+dl.Discretionary_Request__r.Approval_Status__c);    
    }
    
    public pagereference submit()
    {        
        stdCtrl.save();                
        return null;
    }
    public Pagereference submitLtgn()
    {
        stdCtrl.save();        
        Discretionary_Line_Item__c newItem = new Discretionary_Line_Item__c();
        newItem.Req_Amount_Changed__c =false;
        newItem.Id=dl.id;
        update newItem;
        system.debug('new pagerefe'+dl.Discretionary_Request__c);
        return new Pagereference('/apex/SendDiscretionaryApproval?id='+dl.Discretionary_Request__c);
    }
    
    public pagereference acknowledge()
    {
        if(dl.Approval_Status__c!='Pending Close'){
            dl.acknowledge__c= True;
            update dl;
        }
        //PageReference pagref = new PageReference('/'+dl.id);
        return null ;
    }
    public pagereference closeitem()
    {
        refreshPage=true;
        stdCtrl.save();
        return null;
    }
    
   @AuraEnabled
    public static String iSShowbutton(Id discItemId)
    {
        if(discItemId !=null)
        {
            Discretionary_Line_Item__c  dll= [SELECT Id, Discretionary_Request__r.Approval_Status__c,Approval_Status__c,Requested_Amount__c,Req_Amount_changed__c FROM Discretionary_Line_Item__c
                                             WHERE Id = :discItemId];            
            if (dll.Discretionary_Request__r.Approval_Status__c == 'new')
            {
                return 'true';
            }
            else
            {
                return 'false';
            }            
        }
        return null;
    }
   
    
}