/* change log
INC000009726065 - 10/11/2016
*/
public class CaseListViewReportCtlr {

public CaseListViewReportCtlr () 
    {
    }

public pagereference Download()
    {
        PageReference exdownload = null;
        exdownload = Page.listviewExportData;
        exdownload.setRedirect(false);
        return exdownload ;
    }

 public Map<string, String> CaseLists
    {
        get
        {
            Map<string, String> nameList = new Map<string, String>();
            for(listview lv : [SELECT CreatedBy.name,CreatedDate,DeveloperName,Id,IsSoqlCompatible,
            LastModifiedBy.name,LastModifiedDate,
            LastReferencedDate, LastViewedDate,Name,NamespacePrefix,SobjectType,SystemModstamp FROM ListView where SobjectType = 'Case'])
            {
                nameList.put(lv.Name, lv.LastModifiedBy.name+' '+lv.LastModifiedDate.formatLong());
            }
            return nameList;

        }
        set;
    } 
}