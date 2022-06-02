import { LightningElement, api, wire, track } from 'lwc';
import { getRecord , getFieldValue , updateRecord  } from 'lightning/uiRecordApi';
import { CloseActionScreenEvent } from 'lightning/actions';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import convertFastTrack from '@salesforce/apex/CRM_CreateOpportunityApexCtlr.convertFastTrack';

import NAME_FIELD from "@salesforce/schema/Opportunity.Name";
import TYPE_FIELD from "@salesforce/schema/Opportunity.Business_Type__c";
import WINDECLDATE_FIELD from "@salesforce/schema/Opportunity.G5_Approval_Date__c";

const fields = [NAME_FIELD,TYPE_FIELD,WINDECLDATE_FIELD];

export default class CRM_FastTrackConversion extends LightningElement {
    @api recordId;
    loaded = false;
    opportunity;
    showSpinner = false;
    converted = false;

    @wire(getRecord, { recordId: '$recordId', fields: fields })
    wiredRecord({ error, data }) {
        if (error) {
            this.showToast('Error','An unexpected error occurred, please contact an admin','error');
            this.dispatchEvent(new CloseActionScreenEvent());
        } else if (data && !this.converted) {
            this.opportunity = data;
            this.validateRecord();
        }
    }

    validateRecord() {
        var type = getFieldValue(this.opportunity, TYPE_FIELD);
        if(type !== undefined && type !== 'Fast Track Opportunity'){
            this.showToast('Not Allowed','Action only available for Fast Track Opportunities.','info');
            this.cancel();
            return;
        }
        var winDeclarationDate = getFieldValue(this.opportunity, WINDECLDATE_FIELD);
        if(winDeclarationDate !== undefined && winDeclarationDate !== null){
            this.showToast('Not Allowed', 'It\'s only permitted to convert a Fast Track Opportunity to a Standard Opportunity before Win Declaration.','info');
            this.cancel();
            return;
        }
        this.loaded = true;
    }

    get name() {
        return getFieldValue(this.opportunity, NAME_FIELD);
    }

    showToast(title,message,variant){
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(event);
    }

    cancel(){
        this.dispatchEvent(new CloseActionScreenEvent());
    }

    convert(){
        this.showSpinner = true;
        this.converted = true;
        convertFastTrack({ recordId: this.recordId })
            .then((result) => {
                this.showToast('Success','The opportunity has been converted to standard','success');
                this.dispatchEvent(new CloseActionScreenEvent());
                return refreshApex(this.opportunity);
            })
            .catch((error) => {
                this.showToast('Error converting the Fast Track to Standard',error.body.message,'error');
                this.dispatchEvent(new CloseActionScreenEvent());
            });
    }
}