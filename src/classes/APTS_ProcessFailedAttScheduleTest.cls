@isTest
public class APTS_ProcessFailedAttScheduleTest{
public static testMethod void ProcessFailedAttachmentsSchedule() {
Test.startTest();
APTS_ProcessFailedAttachmentsSchedule PDFShc = new APTS_ProcessFailedAttachmentsSchedule();
String sch = '0 0 2 * * ?'; 
system.schedule('Process Failed Attachments', sch, PDFShc ); 
Test.stopTest();
}
}