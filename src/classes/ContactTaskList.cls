/**
 * Created by Meiying Liang on 3/8/2020.
 */

public with sharing class ContactTaskList {
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContactTaskList(string recordId) {
        system.debug('recordId:' + recordId);

        Set<Id> contactIds = new Set<Id>();
        AggregateResult[] taskResult = [
                SELECT WhoId
                FROM Task
                WHERE WhatId = :recordId And WhoId != null
                GROUP BY WhoId
        ];

        if(taskResult != null)
        {
            for(AggregateResult t : taskResult)
            {
                contactIds.add(t.get(('WhoId')).toString());
            }
        }

        system.debug(contactIds);

        if(contactIds != null)
        {
            List<Contact> result = [
                    SELECT Id,Name,Phone,Email,Contact_Status__c
                    FROM Contact
                    WHERE Id IN :contactIds
                    LIMIT  1000
            ];

            system.debug('ContactTaskList:' + result);

            return result;
        }

        return null;
    }
}