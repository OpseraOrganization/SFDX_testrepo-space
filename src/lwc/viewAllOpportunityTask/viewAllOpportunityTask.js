/**
 * Created by Meiying Liang on 2/14/2020.
 */

import { LightningElement, wire, track, api } from 'lwc';
import { CurrentPageReference, NavigationMixin } from 'lightning/navigation';
import getOpportunityTaskList from '@salesforce/apex/OpportunityTaskListView.getOpportunityTaskList'

export default class ViewAllOpportunityTask extends NavigationMixin(LightningElement) {
    @track items = []; //it contains all the records.
    @track data = [];
    @track sortDirection;
    @track sortedField;
    @track isSubjectSortDirectionUp = true;
    @track isDescriptionSortDirectionUp = true;
    @track isCreatedDateSortDirectionUp = true;
    @track isActivityDateSortDirectionUp = true;
    @track isCreatedBySortDirectionUp = true;
    @track isStatusSortDirectionUp = true;
    @track oppId;

    @wire(CurrentPageReference)
    setCurrentPageReference(currentPageReference) {
        if(currentPageReference != null)
        {
            this.callGetOpportunityTaskList(currentPageReference.state.c__opportunityId);
        }
    }

    callGetOpportunityTaskList(oppId){
        getOpportunityTaskList({recordId : oppId})
        .then(data => {
            if(data)
            {
                let currentData = [];

                data.forEach(row => {
                    let rowData = {};

                    rowData.taskUrl = `/${row.Id}`;
                    rowData.Subject = row.Subject;
                    if(row.Description != null)
                        rowData.Description = row.Description.substring(0,50);
                    else
                        rowData.Description = row.Description;

                    rowData.FullDescription = row.Description;
                    rowData.CreatedDate = row.CreatedDate;
                    rowData.Activity_Date__c = row.Activity_Date__c;
                    rowData.CreatedBy = row.CreatedBy.Name;
                    rowData.Status = row.Status;

                    currentData.push(rowData);
                });
                this.data = this.items = currentData;

                //sort by CreatedDate desc for first time page loading
                this.sortedField = 'CreatedDate';
                this.sortDirection = 'desc';

                this.sortData(this.sortedField, this.sortDirection);
            }
        })
        .catch(error => {
            console.log(error);
        });
    }

    handleSort(event)
    {
        if(event.target.id.includes('Subject'))
            this.sortedField = 'Subject';
        else if(event.target.id.includes('Description'))
            this.sortedField = 'Description';
        else if(event.target.id.includes('Activity_Date__c'))
            this.sortedField = 'Activity_Date__c';
        else if(event.target.id.includes('CreatedBy'))
            this.sortedField = 'CreatedBy';
        else if(event.target.id.includes('Status'))
            this.sortedField = 'Status';
        else
            this.sortedField = 'CreatedDate';

        this.sortDirection = this.sortDirection == 'desc' ? 'asc' : 'desc';

        this.sortData(this.sortedField, this.sortDirection);
    }

    sortData(fieldName, direction)
    {
        this.isSubjectSortDirectionUp = true;
        this.isDescriptionSortDirectionUp = true;
        this.isCreatedDateSortDirectionUp = true;
        this.isActivityDateSortDirectionUp = true;
        this.isCreatedBySortDirectionUp = true;
        this.isStatusSortDirectionUp = true;

        if(fieldName == 'Subject')
        {
            this.isSubjectSortDirectionUp = direction == 'desc' ? false : true;
        }
        else if(fieldName == 'Description')
        {
            this.isDescriptionSortDirectionUp = direction == 'desc' ? false : true;
        }
        else if(fieldName == 'CreatedDate')
        {
            this.isCreatedDateSortDirectionUp = direction == 'desc' ? false : true;
        }
        else if(fieldName == 'CreatedBy')
        {
            this.isCreatedBySortDirectionUp = direction == 'desc' ? false : true;
        }
        else if(fieldName == 'Activity_Date__c')
        {
            this.isActivityDateSortDirectionUp = direction == 'desc' ? false : true;
        }
        else if(fieldName == 'Status')
        {
            this.isStatusSortDirectionUp = direction == 'desc' ? false : true;
        }
        // serialize the data before calling sort function
        let parseData = JSON.parse(JSON.stringify(this.items));

        // Return the value stored in the field
        let keyValue = (a) => {
            return a[fieldName];
        };

        // cheking reverse direction
        let isReverse = direction === 'asc' ? 1: -1;

        // sorting data
        parseData.sort((x, y) => {
            x = keyValue(x) ? keyValue(x) : ''; // handling null values
            y = keyValue(y) ? keyValue(y) : '';

            // sorting values based on direction
            return isReverse * ((x > y) - (y > x));
        });

        // set the sorted data to data table data
        this.data = this.items = parseData;
    }
}