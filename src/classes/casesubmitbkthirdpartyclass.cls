public class casesubmitbkthirdpartyclass {
    public pagereference closeform(){
        PageReference pageRef = new PageReference('/apex/BKThirdPartyTecIssueform');
        pageRef.setRedirect(true);
        return pageRef;
    }

}