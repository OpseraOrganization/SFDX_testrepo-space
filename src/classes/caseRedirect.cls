public with sharing class caseRedirect {

private ApexPages.StandardController controller;
public String rType {get; set;}
Id profileId=userinfo.getProfileId();
public caseRedirect(ApexPages.StandardController controller) {
    system.debug('Redirect pageee');
    this.controller = controller;
    rType = ApexPages.currentPage().getParameters().get('RecordType');
}

public PageReference redirect() {
    PageReference returnURL;
    // Redirect if Record Type corresponds to custom VisualForce page
    system.debug('Redirect pageee record type'+rType );
    system.debug('ProfileId'+'{$ProfileId}');
    IF(rType == label.TechnicalIssue_RecordTypeID && (ProfileId==Label.Sys_Admin_Profile_Id || ProfileId==Label.Honeywell_System_Administrator_US || ProfileId==Label.Honeywell_System_Administrator_Non_US)) {
        system.debug('ProfileId'+'{$ProfileId}');
        returnURL = new PageReference('/apex/TechnicalIssue_Page');
    }
    ELSE {

       returnURL = new PageReference('/500/e');
    }

    
    returnURL.getParameters().put('RecordType', rType);
    returnURL.getParameters().put('nooverride', '1');

    
    returnURL.setRedirect(true);
    return returnURL;

}
}