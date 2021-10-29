public class Thankyou_page_emailnotification {

    /*public Thankyou_page_emailnotification(ApexPages.StandardController controller) {

    }*/
public pagereference thankyou()
{
ApexPages.Message msg1 = new ApexPages.Message(ApexPages.Severity.Info,'Thanks for your response');
                        ApexPages.addMessage(msg1);

return null;
}
                      
}