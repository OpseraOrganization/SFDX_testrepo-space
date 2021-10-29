// Code we will invoke on page load.
public with sharing class CustomLandingController {
    public PageReference forwardToCustomAuthPage() {
       // return Network.communitiesLanding();
        if(UserInfo.getUserType() == 'Guest'){
            return new PageReference('/D_S_Portal_CommunitiesLogin');        
            
        }
        else{
            //return null;
            return new PageReference('/home/home.jsp');        
        }
    }

    public CustomLandingController() {}
}