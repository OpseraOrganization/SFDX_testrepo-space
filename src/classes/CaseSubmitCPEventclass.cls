public class CaseSubmitCPEventclass {
    public pagereference closeform(){
        PageReference pageRef = new PageReference('/apex/CP_Feedback_Form');
        pageRef.setRedirect(true);
        return pageRef;
    }
}