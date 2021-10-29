public with sharing class AircraftNotificationsSubcribe_controller {
    public Contact cont {get;set;}
    public string subscribedPlatforms {get;set;}
    public string selectedSubscription{get;set;}
    public boolean displaySubs{get;set;}
    
    public AircraftNotificationsSubcribe_controller(ApexPages.StandardController controller) {
        cont = (contact)controller.getRecord();
        displaySubs = true;
        if(cont.Aircraft_Notifications__c == false || cont.Contact_Is_Employee__c == false){
             ApexPages.Message msg = new Apexpages.Message(ApexPages.Severity.Error,'Please select "Aircraft Delivery Notification" for Aircraft Notification Subscription on Contact and should be Honeywell Employee.');
             
             ApexPages.addMessage(msg);
             displaySubs = false;
        }
        
        rightSelectedPlatforms = new List<selectOption>();
        set<id> platformIds = new set<id>();
        if(cont.Aircraft_Alert_for_Platforms__c != null){        
            if(cont.Aircraft_Alert_for_Platforms__c == 'All'){
                subscribedPlatforms = 'All Platforms selected as Subscriptions for Aircraft Notifications.';
                selectedSubscription = 'all';
            }
            else if(cont.Aircraft_Alert_for_Platforms__c == 'None' || cont.Aircraft_Alert_for_Platforms__c == ''){
                subscribedPlatforms = 'No Platform is selected for Aircraft Notifications';
                selectedSubscription = 'clear';
            }else{
                for(string plat : cont.Aircraft_Alert_for_Platforms__c.split(';')){
                    platformIds.add(plat);
                }
            
                subscribedPlatforms = '';
                if(platformIds.size()>0)   
                    for(Platform__c plat : [select Name from Platform__c where id in: platformIds]){
                        subscribedPlatforms += plat.Name + '; ';
                    }
                    
                selectedSubscription = 'update';
            }
        }
    }
  
    public PageReference save() {
        if(selectedSubscription == null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Please select either of the option for Subscription updates.'));
        }else if(selectedSubscription == 'update' && rightSelectedPlatforms.size() == 0){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Please select the Platforms by Searching in Search window'));
        }
        else{
            if(cont.Aircraft_Alert_for_Platforms__c == 'All' || cont.Aircraft_Alert_for_Platforms__c == 'None' || cont.Aircraft_Alert_for_Platforms__c==null)
                    cont.Aircraft_Alert_for_Platforms__c = '';
        
            if(selectedSubscription == 'update'){
                
                if(rightSelectedPlatforms.size() > 0){
                    rightSelectedPlatforms.sort();
                    for(selectOption platform : rightSelectedPlatforms){
                        cont.Aircraft_Alert_for_Platforms__c += platform.getValue() + ';';
                    }
                    
                }
            }else if(selectedSubscription == 'all'){
                cont.Aircraft_Alert_for_Platforms__c = 'All';
            }else{
                cont.Aircraft_Alert_for_Platforms__c = 'None';
            }
            
            if(selectedSubscription != null && cont.Aircraft_Alert_for_Platforms__c != null){
                try{
                    update cont;
                }catch(Exception ex){
                    ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.Error,ex.getMessage()));
                    return null;
                }
                
                pagereference subscriptionPage = new pagereference('/apex/AircraftNotificationsSubcribe_VF?id=' + cont.id + '&success=true');
                subscriptionPage.setRedirect(true);
                return subscriptionPage ;
            }
        }
        return null;
    }


    public AircraftNotificationsSubcribe_controller() {
        leftSelectPlatforms = new List<string>();
    }


    public string platformSearchTerm {get;set;}
    public List<selectOption> leftSearchedPlatforms {get;set;}
    public List<string> leftSelectPlatforms {get;set;}
    public List<string> rightSelectPlatforms {get;set;}
    public Map<id,Platform__c> searchResults;
    public List<selectOption> rightSelectedPlatforms {get;set;}
        
    public pagereference searchPlatform(){
        if((platformSearchTerm == null || platformSearchTerm == '') || platformSearchTerm.length() <2){
            ApexPages.addMessage(new Apexpages.Message(Apexpages.severity.Error,'Please enter minimum 2 letters for Platform name'));    
        }else{
            leftSearchedPlatforms  = new List<selectOption>();
            rightSelectedPlatforms = new List<selectOption>();
            searchResults = new Map<id,Platform__c>([select Id, Name from Platform__c where name like: platformSearchTerm+'%']);
            
            for(platform__c platform : searchResults.values()){
                leftSearchedPlatforms.add(new SelectOption(platform.id,platform.Name));
            }
            leftSearchedPlatforms.sort();
        }
        return null;
    }
    
    public pagereference toRight(){
        if(leftSelectPlatforms.size() > 0){        
                
            for(string str: leftSelectPlatforms){
                system.debug('---->' + str);
                rightSelectedPlatforms.add(new selectOption(str,searchResults.get(str).Name));
            }
            rightSelectedPlatforms.sort();
            integer i = 0;
            integer[] removeListItems = new List<Integer>();
            for(SelectOption selPlat : rightSelectedPlatforms){
                i=0;
                for(SelectOption platform : leftSearchedPlatforms){
                    if(platform.getValue() == selPlat.getValue()){
                        system.debug('platform.getName--->' + platform.getLabel());
                        system.debug('selPlat.getValue--->' + selPlat.getLabel());                    
                        removeListItems.add(i);
                        system.debug('Index-->' + i);
                        
                    }
                    i++;
                }
                
                
            }
            integer j = 0;
            for(integer removeIndex: removeListItems){
                system.debug('leftSearchedPlatforms--->' + leftSearchedPlatforms.get(removeIndex-j));
                system.debug('removeIndex-->' + removeIndex);
                leftSearchedPlatforms.remove(removeIndex-j);
                j++;
            }
        }
        return null;
    }
    
    public pagereference toLeft(){
    
        if(rightSelectPlatforms.size() > 0){
            for(string str: rightSelectPlatforms){
                system.debug('---->' + str);
                leftsearchedPlatforms.add(new selectOption(str,searchResults.get(str).Name));
            }
            
            integer i = 0;
            integer[] removeListItems = new List<Integer>();
            for(SelectOption selPlat : leftsearchedPlatforms){
                i=0;
                for(SelectOption platform : rightSelectedPlatforms){
                    if(platform.getValue() == selPlat.getValue()){
                        system.debug('platform.getName--->' + platform.getLabel());
                        system.debug('selPlat.getValue--->' + selPlat.getLabel());                    
                        removeListItems.add(i);
                        system.debug('Index-->' + i);
                        
                    }
                    i++;
                }
                
                
            }
            integer j = 0;
            for(integer removeIndex: removeListItems){
                system.debug('leftSearchedPlatforms--->' + rightSelectedPlatforms.get(removeIndex-j));
                system.debug('removeIndex-->' + removeIndex);
                rightSelectedPlatforms.remove(removeIndex-j);
                j++;
            }
            
        }
        return null;
        
        
    }
    
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('update', 'Update Subscription')); 
        options.add(new SelectOption('all','Select All')); 
        options.add(new SelectOption('clear','Remove All')); 
        
        return options; 
    }
}