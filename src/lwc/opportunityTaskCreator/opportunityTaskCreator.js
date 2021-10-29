/**
 * Created by Meiying Liang on 12/14/2019.
 */

import { LightningElement, track, api } from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';

import SUBJECT_FIELD from '@salesforce/schema/Task.Subject';
import ACTIVITY_DATE_FIELD from '@salesforce/schema/Task.ActivityDate';
import RECORD_TYPE_ID_FIELD from '@salesforce/schema/Task.RecordTypeId';
import WHAT_ID_FIELD from '@salesforce/schema/Task.WhatId';
import OWNER_ID_FIELD from '@salesforce/schema/Task.OwnerId';
import STATUS_FIELD from '@salesforce/schema/Task.Status__c';
import TYPE_FIELD from '@salesforce/schema/Task.Type__c';
import DESCRIPTION_FIELD from '@salesforce/schema/Task.Description';
import CREATED_DATE_FIELD from '@salesforce/schema/Task.CreatedDate';
import PRIORITY_FIELD from '@salesforce/schema/Task.Priority';
import COMPLETED_DATE_TIME_FIELD from '@salesforce/schema/Task.Completed_Date_Time__c';
import ACTIVITY_DATE_C_FIELD from '@salesforce/schema/Task.Activity_Date__c';
import saveOpportunityTask from '@salesforce/apex/OpportunityTaskListView.saveOpportunityTask';

export default class OpportunityTaskCreator extends LightningElement {
    @api isLoading = false;

    @api recordId;
    @track rec = {
        Subject : SUBJECT_FIELD,
        Description : DESCRIPTION_FIELD,
        Status : STATUS_FIELD,
        Priority : PRIORITY_FIELD,
        Type : TYPE_FIELD,
        WhatId : WHAT_ID_FIELD,
        ActivityDate : ACTIVITY_DATE_FIELD,
        Activity_Date__c : ACTIVITY_DATE_C_FIELD,
        Completed_Date_Time__c : COMPLETED_DATE_TIME_FIELD
    };

    @track completedDateTime;

    @track customerStatusComments = '';

    @track nextStepComments = '';
    @track nextStepDate;

    @track LogCallComments = '';
    @track LogCallActivityDate;

    @track LogEmailComments = '';
    @track LogEmailActivityDate;

    @track LogF2FComments = '';
    @track LogF2FActivityDate;

    @track LogMeetingComments = '';
    @track LogMeetingActivityDate;

    @track SalesSIPComments = '';
    @track SalesSIPDueDate;
    @track SalesSIPCompletedDate;

    @track CustomerStatus_F2FMeeting = false;
    @track CustomerStatus_VirtualMeeting = false;
    @track CustomerStatus_Call = false;
    @track F2FMeeting_CustomerStatus = false;
    @track LogCall_CustomerStatus = false;
    @track VirtualMeeting_CustomerStatus = false;

    initializeValues() {
        this.completedDateTime = null;

        this.customerStatusComments = '';

        this.nextStepComments = '';
        this.nextStepDate = null;

        this.LogCallComments = '';
        this.LogCallActivityDate = null;

        this.LogEmailComments = '';
        this.LogEmailActivityDate = null;

        this.LogF2FComments = '';
        this.LogF2FActivityDate = null;

        this.LogMeetingComments = '';
        this.LogMeetingActivityDate = null;

        this.SalesSIPComments = '';
        this.SalesSIPDueDate = null;
        this.SalesSIPCompletedDate = null;

        this.CustomerStatus_F2FMeeting = false;
        this.CustomerStatus_VirtualMeeting = false;
        this.CustomerStatus_Call = false;
        this.F2FMeeting_CustomerStatus = false;
        this.LogCall_CustomerStatus = false;
        this.VirtualMeeting_CustomerStatus = false;
    }

    handleChangeCustomerStatusComments(event) {
        this.customerStatusComments = event.target.value;
    }

    handleChangeNextStepComments(event) {
        this.nextStepComments = event.target.value;
    }

    handleChangeNextStepDate(event) {
        this.nextStepDate = event.target.value;
    }

    handleChangeLogCallComments(event) {
        this.LogCallComments = event.target.value;
    }

    handleChangeLogCallActivityDate(event) {
        this.LogCallActivityDate = event.target.value;
    }

    handleChangeLogEmailComments(event) {
        this.LogEmailComments = event.target.value;
    }

    handleChangeLogEmailActivityDate(event) {
        this.LogEmailActivityDate = event.target.value;
    }

    handleChangeLogF2FComments(event) {
        this.LogF2FComments = event.target.value;
    }

    handleChangeLogF2FActivityDate(event) {
        this.LogF2FActivityDate = event.target.value;
    }

    handleChangeLogMeetingComments(event) {
        this.LogMeetingComments = event.target.value;
    }

    handleChangeLogMeetingActivityDate(event) {
        this.LogMeetingActivityDate = event.target.value;
    }

    handleChangeSalesSIPComments(event) {
        this.SalesSIPComments = event.target.value;
    }

    handleChangeSalesSIPDueDate(event) {
        this.SalesSIPDueDate = event.target.value;
    }

    handleChangeSalesSIPCompletedDate(event) {
        this.SalesSIPCompletedDate = event.target.value;
    }

    handleCheckbox(event) {
        if(event.target.name === 'Log_F2F_Meeting_Customer_Status')
        {
            this.F2FMeeting_CustomerStatus = !this.F2FMeeting_CustomerStatus;
        }
        else if(event.target.name === 'CustomerStatus_F2F_Meeting')
        {
            if(this.CustomerStatus_F2FMeeting === false)
            {
                this.CustomerStatus_F2FMeeting = true;
                this.CustomerStatus_VirtualMeeting = false;
                this.CustomerStatus_Call = false;
            }
            else
            {
                this.CustomerStatus_F2FMeeting = false;
            }
        }
        else if(event.target.name === 'CustomerStatus_Virtual_Meeting')
        {
            if(this.CustomerStatus_VirtualMeeting === false)
            {
                this.CustomerStatus_F2FMeeting = false;
                this.CustomerStatus_VirtualMeeting = true;
                this.CustomerStatus_Call = false;
            }
            else
            {
                this.CustomerStatus_VirtualMeeting = false;
            }
        }
        else if(event.target.name === 'CustomerStatus_Call')
        {
            if(this.CustomerStatus_Call === false)
            {
                this.CustomerStatus_F2FMeeting = false;
                this.CustomerStatus_VirtualMeeting = false;
                this.CustomerStatus_Call = true;
            }
            else
            {
                this.CustomerStatus_Call = false;
            }
        }
        else if(event.target.name === 'Log_Virtual_Meeting_Customer_Status')
        {
            this.VirtualMeeting_CustomerStatus = !this.VirtualMeeting_CustomerStatus;
        }
        else if(event.target.name === 'Log_Call_Customer_Status')
        {
            this.LogCall_CustomerStatus = !this.LogCall_CustomerStatus;
        }
    }

    currentDate() {
        return new Date().toLocaleDateString("en-US");
    }

    cloneCustomerStatus(comments, activityDate) {
        if(comments.length !== 0)
        {
            this.rec.Subject = 'Customer Status';
            this.rec.Description = comments;

            if(activityDate == null)
            {
                this.rec.Activity_Date__c = this.currentDate();
            }
            else
            {
                this.rec.Activity_Date__c = activityDate;
            }

            this.rec.Completed_Date_Time__c = this.completedDateTime = null;
            this.rec.ActivityDate = this.currentDate();

            this.callApexMethod('Customer_Status');
        }
    }

    cloneF2FMeeting(comments) {
        if(comments.length !== 0)
        {
            this.rec.Subject = 'Log F2F Meeting';
            this.rec.Description = comments;

            this.rec.Activity_Date__c = this.currentDate();

            this.rec.ActivityDate = this.currentDate();
            this.rec.Completed_Date_Time__c = this.completedDateTime = null;

            this.callApexMethod('Log_F2F');
        }
    }

    cloneVirtualMeeting(comments) {
        if(comments.length !== 0)
        {
            this.rec.Subject = 'Log Virtual Meeting';
            this.rec.Description = comments;

            this.rec.Activity_Date__c = this.currentDate();

            this.rec.ActivityDate = this.currentDate();
            this.rec.Completed_Date_Time__c = this.completedDateTime = null;

            this.callApexMethod('Log_Meeting');
        }
    }

    cloneCall(comments) {
        if(comments.length !== 0)
        {
            this.rec.Subject = 'Log Call';
            this.rec.Description = comments;

            this.rec.Activity_Date__c = this.currentDate();

            this.rec.ActivityDate = this.currentDate();
            this.rec.Completed_Date_Time__c = this.completedDateTime = null;

            this.callApexMethod('Log_Call');
        }
    }

    createCustomerStatusTask() {
        if(this.customerStatusComments.length !== 0)
        {
            this.rec.Subject = 'Customer Status';
            this.rec.Description = this.customerStatusComments;

            this.rec.ActivityDate = this.currentDate();

            this.rec.Completed_Date_Time__c = this.completedDateTime;
            this.rec.Activity_Date__c = this.currentDate();

            this.callApexMethod('Customer_Status');

            if(this.CustomerStatus_F2FMeeting === true)
            {
                this.cloneF2FMeeting(this.customerStatusComments);
            }
            else if(this.CustomerStatus_VirtualMeeting === true)
            {
                this.cloneVirtualMeeting(this.customerStatusComments);
            }
            else if(this.CustomerStatus_Call === true)
            {
                this.cloneCall(this.customerStatusComments);
            }

            this.initializeValues();
        }
        else
        {
            this.showError();
        }
    }

    createNextStepTask() {
        if(this.nextStepComments.length !== 0)
        {
            this.rec.Subject = 'Next Step';
            this.rec.Description = this.nextStepComments;

            if(this.nextStepDate == null)
            {
                this.rec.Activity_Date__c = this.currentDate();
                this.rec.ActivityDate = this.currentDate();
            }
            else
            {
                this.rec.Activity_Date__c = this.nextStepDate;
                this.rec.ActivityDate = this.nextStepDate;
            }

            this.rec.Completed_Date_Time__c = this.completedDateTime;

            this.callApexMethod('Next_Step');

            this.initializeValues();
        }
        else
        {
            this.showError();
        }
    }

    createLogCall() {
        if(this.LogCallComments.length !== 0)
        {
            this.rec.Subject = 'Log Call';
            this.rec.Description = this.LogCallComments;

            if(this.LogCallActivityDate == null)
            {
                this.rec.Activity_Date__c = this.currentDate();
            }
            else
            {
                this.rec.Activity_Date__c = this.LogCallActivityDate;
            }

            this.rec.ActivityDate = this.currentDate();
            this.rec.Completed_Date_Time__c = this.completedDateTime;

            this.callApexMethod('Log_Call');

            if(this.LogCall_CustomerStatus ===  true)
            {
                this.cloneCustomerStatus(this.LogCallComments, this.LogCallActivityDate);
            }

            this.initializeValues();
        }
        else
        {
            this.showError();
        }
    }

    createLogEmail() {
        if(this.LogEmailComments.length !== 0)
        {
            this.rec.Subject = 'Log Email';
            this.rec.Description = this.LogEmailComments;

            if(this.LogEmailActivityDate == null)
            {
                this.rec.Activity_Date__c = this.currentDate();
            }
            else
            {
                this.rec.Activity_Date__c = this.LogEmailActivityDate;
            }

            this.rec.ActivityDate = this.currentDate();
            this.rec.Completed_Date_Time__c = this.completedDateTime;

            this.callApexMethod('Log_Email');

            this.initializeValues();
        }
        else
        {
            this.showError();
        }
    }

    createLogF2F() {
        if(this.LogF2FComments.length !== 0)
        {
            this.rec.Subject = 'Log F2F Meeting';
            this.rec.Description = this.LogF2FComments;

            if(this.LogF2FActivityDate == null)
            {
                this.rec.Activity_Date__c = this.currentDate();
            }
            else
            {
                this.rec.Activity_Date__c = this.LogF2FActivityDate;
            }

            this.rec.ActivityDate = this.currentDate();
            this.rec.Completed_Date_Time__c = this.completedDateTime;

            this.callApexMethod('Log_F2F');

            if(this.F2FMeeting_CustomerStatus === true)
            {
                this.cloneCustomerStatus(this.LogF2FComments, this.LogF2FActivityDate);
            }

            this.initializeValues();
        }
        else
        {
            this.showError();
        }
    }

    createLogMeeting() {
        if(this.LogMeetingComments.length !== 0)
        {
            this.rec.Subject = 'Log Virtual Meeting';
            this.rec.Description = this.LogMeetingComments;

            if(this.LogMeetingActivityDate == null)
            {
                this.rec.Activity_Date__c = this.currentDate();
            }
            else
            {
                this.rec.Activity_Date__c = this.LogMeetingActivityDate;
            }

            this.rec.ActivityDate = this.currentDate();
            this.rec.Completed_Date_Time__c = this.completedDateTime;

            this.callApexMethod('Log_Meeting');

            if(this.VirtualMeeting_CustomerStatus === true)
            {
                this.cloneCustomerStatus(this.LogMeetingComments, this.LogMeetingActivityDate);
            }

            this.initializeValues();
        }
        else
        {
            this.showError();
        }
    }

    createSalesSIP() {
        if(this.SalesSIPComments.length !== 0)
        {
            this.rec.Subject = 'Sales SIP Activity';
            this.rec.Description = this.SalesSIPComments;

            if(this.SalesSIPDueDate == null)
            {
                this.rec.Activity_Date__c = this.currentDate();
                this.rec.ActivityDate = this.currentDate();
            }
            else
            {
                this.rec.Activity_Date__c = this.SalesSIPDueDate;
                this.rec.ActivityDate = this.SalesSIPDueDate;
            }

            this.rec.Completed_Date_Time__c = this.SalesSIPCompletedDate;

            this.callApexMethod('Sales_Activity');

            this.initializeValues();
        }
        else
        {
            this.showError();
        }
    }

    callApexMethod(recType){
        this.isLoading = true;

        this.rec.Status = 'Completed';
        this.rec.Type = 'Call';
        this.rec.WhatId = this.recordId;
        this.rec.Priority = 'Normal';

        saveOpportunityTask({objTask: this.rec, type: recType})
        .then(result => {
            this.rec = {};
            console.log('result ===> ' + result);
            this.dispatchEvent(new ShowToastEvent({
                title: 'Success!',
                message: 'Record created successfully!',
                variant: 'success'
            }),);

            this.isLoading = false;
        })
        .catch(error => {
            this.error = error.message;
            console.log('error:' + error.message);
            this.isLoading = false;
        });
    }

    showError() {
        this.dispatchEvent(new ShowToastEvent({
            title: 'Error!',
            message: 'Comments field is required',
            variant: 'error'
        }),);
    }
}