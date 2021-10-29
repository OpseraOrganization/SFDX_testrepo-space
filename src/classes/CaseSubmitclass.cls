public class CaseSubmitclass {
    public pagereference closeform(){
        PageReference pageRef = new PageReference('/apex/CPAuthorization_WebCase');
        pageRef.setRedirect(true);
        return pageRef;
    }
}