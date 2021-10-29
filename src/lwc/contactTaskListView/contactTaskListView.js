/**
 * Created by Meiying Liang on 3/8/2020.
 */

import { LightningElement, wire, track, api } from 'lwc';
import getContactTaskList from '@salesforce/apex/ContactTaskList.getContactTaskList'

export default class ContactTaskListView extends LightningElement {
    @track items = []; //it contains all the records.
    @track data = [];
    @track sortDirection;
    @track sortedField;
    @track isNameSortDirectionUp = true;
    @track isStatusSortDirectionUp = true;
    @track isPhoneSortDirectionUp = true;
    @track isEmailSortDirectionUp = true;

    @api recordId;
    @wire(getContactTaskList,{ recordId: '$recordId'})
    histories({error, data})
    {
        if(data)
        {
            let currentData = [];

            data.forEach(row => {
                let rowData = {};

                rowData.taskUrl = `/${row.Id}`;
                rowData.Name = row.Name;
                rowData.Phone = row.Phone;
                rowData.Email = row.Email;
                rowData.Status = row.Contact_Status__c;

                currentData.push(rowData);
            });
            this.items = currentData;

            //sort by CreatedDate desc for first time page loading
            this.sortedField = 'Name';
            this.sortDirection = 'desc';

            this.sortData(this.sortedField, this.sortDirection);
        }
        else if(error)
        {
            window.console.log(error);
        }
    }

    handleSort(event)
    {
        if(event.target.id.includes('Name'))
            this.sortedField = 'Name';
        else if(event.target.id.includes('Phone'))
            this.sortedField = 'Phone';
        else if(event.target.id.includes('Email'))
            this.sortedField = 'Email';
        else
            this.sortedField = 'Contact_Status__c';

        this.sortDirection = this.sortDirection == 'desc' ? 'asc' : 'desc';

        this.sortData(this.sortedField, this.sortDirection);
    }

    sortData(fieldName, direction)
    {
        this.isNameSortDirectionUp = true;
        this.isStatusSortDirectionUp = true;
        this.isPhoneSortDirectionUp = true;
        this.isEmailSortDirectionUp = true;

        if(fieldName == 'Name')
        {
            this.isNameSortDirectionUp = direction == 'desc' ? false : true;
        }
        else if(fieldName == 'Contact_Status__c')
        {
            this.isStatusSortDirectionUp = direction == 'desc' ? false : true;
        }
        else if(fieldName == 'Phone')
        {
            this.isPhoneSortDirectionUp = direction == 'desc' ? false : true;
        }
        else if(fieldName == 'Email')
        {
            this.isEmailSortDirectionUp = direction == 'desc' ? false : true;
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