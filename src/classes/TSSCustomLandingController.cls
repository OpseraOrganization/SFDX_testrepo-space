// Default Landing Controller to check user is authorized and direct to appropiraqte Page.
public with sharing class TSSCustomLandingController {
public PageReference forwardToTSSCustomAuthPage() {
    if(UserInfo.getUserType() == 'Guest'){
        return new PageReference('' + Label.TSS_Login_Page + ''); 
    }
    else {  
        return new PageReference('' + Label.TSS_Community_Home + '');
    }
}

public TSSCustomLandingController() {}
}