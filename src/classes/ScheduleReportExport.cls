public with sharing class ScheduleReportExport {
public class customException extends Exception{}
public void runScheduledReports() {
        executeReportExports();
    }
List<string> listreportid = new List<string>{label.ATR_Classes_by_Airlines,label.ATR_Class_Attendee_report,label.ATR_Class_Attendee_report2};
    private void executeReportExports() {
     try {
                    //executes future method one at a item for each job, each job has own future call
                    list<string> a = label.ATR_Classes_by_Airlines.split(',');
                    list<string> b = label.ATR_Class_Attendee_report.split(',');
                    list<string> c = label.ATR_Class_Attendee_report2.split(',');
                    doExport(a[0], a[1]);
                    doExport(b[0], b[1]);
                    doExport(c[0], c[1]);
        } catch (Exception ex) {
            throw new customException('UNKNOWN_ERROR, ERROR: ' + ex.getMessage());
        }
    }
    
@future (callout=true)
    public static void doExport( Id reportId, String docid) {

        try {

            CSVcontroller report = new CSVcontroller();
            //return the blobcsv file to be attached and saved
            Blob reportCSV = report.getReportAsCSV(reportId, null);
            Document tDoc = new Document(id=docid);
            tDoc.body = reportCSV;
            update tDoc;
        } catch (Exception ex) {
            system.debug('doExportToEmail...ex...' + ex);
            //setJobHistoryFailure(jobId, ex.getMessage());
        }   
    }
    }