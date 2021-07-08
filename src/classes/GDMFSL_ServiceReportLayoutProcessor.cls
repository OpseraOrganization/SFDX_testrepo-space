/**
 * :
 *
 * @author : Bryant Daniels
@group             :
@last modified on  : 02-11-2021
@last modified by  : Bryant Daniels
Modifications Log
Ver   Date         Author           Modification
1.0   02-10-2021   Bryant Daniels   Initial Version
 **/
public without sharing class GDMFSL_ServiceReportLayoutProcessor {

    private static Map<String, ServiceReportLayout> mapStringToSRL = new Map<String, ServiceReportLayout>();

    public static Map<String, ServiceReportLayout> getRecords() {

        if (mapStringToSRL.isEmpty()) {
            for (ServiceReportLayout srl : [SELECT Id, DeveloperName, MasterLabel FROM ServiceReportLayout]) {
                mapStringToSRL.put(srl.DeveloperName, srl);
            }
        }

        System.debug('Returned Service Report Layouts: ' + mapStringToSRL);
        return mapStringToSRL;
    }
}