public class HWTrng_sendmail_cls {

String strkey = ApexPages.currentPage().getParameters().get('key');
String strsim = ApexPages.currentPage().getParameters().get('sim');
String strip = ApexPages.currentPage().getParameters().get('ip');
public void mailer()
{
Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
String[] toAddresses = new String[] {'Nazeerahamed.Fazlullah@Honeywell.com'};
mail.setToAddresses(toAddresses);
mail.setSubject('Alert: The course and access information');
mail.setHtmlBody('<b>Alert: The course and access information</b> <br/> <b> Key :</b>' + strkey + ' <br/> <b> Sim : </b> ' + strsim + ' <br/> <b>IP : </b>' + strip);
Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
}
}