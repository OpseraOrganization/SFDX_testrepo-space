// Code we will invoke on page load.
public with sharing class DirectaccessCustomLandingController{
    public PageReference forwardToTSSCustomAuthPage() {
        if(UserInfo.getUserType() == 'Guest'){
            system.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
            return new PageReference('/TSSCommunityLogin');        
            
        }
        else {  
            return new PageReference('/apex/DirectAccess_Orders');                  
        }
    }

    public DirectaccessCustomLandingController() {}
}