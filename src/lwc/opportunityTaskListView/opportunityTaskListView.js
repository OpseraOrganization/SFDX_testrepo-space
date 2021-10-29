/**
 * Created by Meiying Liang on 12/14/2019.
 */

import { LightningElement, wire, track, api } from 'lwc';
import getOpportunityTaskList from '@salesforce/apex/OpportunityTaskListView.getOpportunityTaskList'
import { NavigationMixin } from 'lightning/navigation';

/*
const COLUMNS = [
    { label: 'View', fieldName: 'taskUrl',initialWidth: 74, type: 'url',typeAttributes: { label: 'Detail', target: '_self' } },
    { label: 'Name', fieldName: 'Subject', sortable: true },
    { label: 'Content', fieldName: 'Description', sortable: true},
    { label: 'Created Date', fieldName: 'CreatedDate',type: 'date', sortable: true },
    { label: 'Activity Date', fieldName: 'Activity_Date__c', type: 'date-local', sortable: true }
];
*/

export default class OpportunityTaskListView extends NavigationMixin(LightningElement) {
    @track page = 1; //this is initialize for 1st page
    @track items = []; //it contains all the records.
    @track startingRecord = 1; //start record position per page
    @track endingRecord = 0; //end record position per page
    @track pageSize = 15; //default value we are assigning
    @track totalRecountCount = 0; //total record count received from all retrieved records
    @track totalPage = 0; //total number of page is needed to display all records
    @track data = [];
    //@track columns = COLUMNS;
    @track sortDirection;
    @track sortedField;
    @track isSubjectSortDirectionUp = true;
    @track isDescriptionSortDirectionUp = true;
    @track isCreatedDateSortDirectionUp = true;
    @track isActivityDateSortDirectionUp = true;

    @api recordId;
    @wire(getOpportunityTaskList,{ recordId: '$recordId'})
    histories({error, data})
    {
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

                currentData.push(rowData);
            });
            this.items = currentData;

            this.totalRecountCount = data.length;
            this.totalPage = Math.ceil(this.totalRecountCount / this.pageSize);

            this.data = this.items.slice(0,this.pageSize);
            this.endingRecord = this.pageSize;

            //sort by CreatedDate desc for first time page loading
            this.sortedField = 'CreatedDate';
            this.sortDirection = 'desc';

            this.sortData(this.sortedField, this.sortDirection);
        }
        else if(error)
        {
            window.console.log(error);
        }
    }

    previousHandler()
    {
        if (this.page > 1)
        {
            this.page = this.page - 1;
            this.displayRecordPerPage(this.page);
        }
    }

    nextHandler()
    {
        if((this.page<this.totalPage) && this.page !== this.totalPage)
        {
            this.page = this.page + 1; //increase page by 1
            this.displayRecordPerPage(this.page);
        }
    }

    handleSort(event)
    {
        if(event.target.id.includes('Subject'))
            this.sortedField = 'Subject';
        else if(event.target.id.includes('Description'))
            this.sortedField = 'Description';
        else if(event.target.id.includes('Activity_Date__c'))
            this.sortedField = 'Activity_Date__c';
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
        else if(fieldName == 'Activity_Date__c')
        {
            this.isActivityDateSortDirectionUp = direction == 'desc' ? false : true;
        }

        this.page = 1;

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
        this.items = parseData;

        this.displayRecordPerPage(this.page);
    }

    displayRecordPerPage(page)
    {
        this.startingRecord = ((page -1) * this.pageSize) ;
        this.endingRecord = (this.pageSize * page);

        this.endingRecord = (this.endingRecord > this.totalRecountCount)
                            ? this.totalRecountCount : this.endingRecord;

        this.data = this.items.slice(this.startingRecord, this.endingRecord);

        this.startingRecord = this.startingRecord + 1;
    }

    navigateToViewAllTaskPage() {
        this[NavigationMixin.Navigate]({
            type: "standard__component",
            attributes: {
                componentName: "c__ViewOpportunityTaskWrapper"
            },
            state: {
                c__opportunityId: this.recordId
            }
        });
    }
}