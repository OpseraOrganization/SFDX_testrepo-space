import { LightningElement, api, wire, track } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import Quote_Status from '@salesforce/schema/HWS_Service_Quote__c.HWS_Quote_Status__c';
import Response_Resolution from '@salesforce/schema/HWS_Service_Quote__c.HWS_Response_Resolution__c';
import HWS_Workgroup from '@salesforce/schema/HWS_Service_Quote__c.HWS_Workgroup__c';
import HWS_WorkGroupType from '@salesforce/schema/HWS_Service_Quote__c.HWS_WorkGroupType__c';
import PO_Required from '@salesforce/schema/HWS_Service_Quote__c.HWS_PO_Required__c';
import Owner_Id from '@salesforce/schema/HWS_Service_Quote__c.OwnerId';
import User_Id from '@salesforce/user/Id';
import getWgMemberDetails from '@salesforce/apex/HWS_QuoteActions.getWgMemberDetails';
import updateOwnership from '@salesforce/apex/HWS_QuoteActions.updateOwnership';
import getValidUser from '@salesforce/apex/HWS_QuoteActions.getValidUser';

export default class hwsServiceQuoteAction extends LightningElement {

    recordFormVisible = false;
    @api isLoaded = false;
    objectApiName = 'HWS_Service_Quote__c';
    @api recordId;
    fields = [];
    @track wireRecorddetails = [];
    actionClicked = '';
    acceptDisable = false;
    rejectDisable = false;
    cancelDisable = false;
    closeDisable = false;
    disableEscalate = false;
    disableSave = false;
    count = 1;
    serviceQuote;
    userId = User_Id;
    ocPermission = false;
    cdmPermission = false;
    selectedItemValue;


    changeOwnerScreenVisible = false;
    disableChangeOwner = true;
    workgroupId;
    workgroupMemberList = [];
    totalNumberOfRows = 0;
    initialRows = 20;
    currentCount = 0;
    totalNumberOfRows = 0;
    rowNumberOffset = 0;
    loadMoreStatus = 'Please scroll down to load more data';
    targetDatatable;
    tabledatalist = [];
    allRecords;
    compId;
    recordTypeName;
    connectedCallback() {
        this.isLoaded = false;
        getValidUser({compId:this.recordId})
            .then(result => {
                this.recordTypeName= result.recordName;
                this.cdmPermission = result.validPermission.some(e => e.PermissionSet.Name === 'HWS_CustomerDeliveryManager');
                this.ocPermission = result.validPermission.some(e => e.PermissionSet.Name === 'HWS_OrderCoordinator');                   
            })          
            this.isLoaded = true;          
    }
        
    @wire(getRecord, {
        recordId: '$recordId',
        fields: [Quote_Status, Response_Resolution,PO_Required,HWS_WorkGroupType,HWS_Workgroup, Owner_Id
        ],
        modes: ['View']
    })
    selectedCloneRecord(result) {
        this.wireRecorddetails = result;
        if (result.error) {
            let message = 'Unknown error';
            if (Array.isArray(error.body)) {
                message = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                message = error.body.message;
            }
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error loading',
                    message: message,
                    variant: 'error',
                }),
            );
        } else if (result.data) {

            this.serviceQuote = result.data;
            this.workgroupId = getFieldValue(this.serviceQuote, HWS_Workgroup);
            let fieldDisable = (getFieldValue(this.serviceQuote, Quote_Status) == 'Completed' || getFieldValue(this.serviceQuote, Quote_Status) == 'Cancelled' || getFieldValue(this.serviceQuote, Quote_Status) == 'Draft');
            let cancelFieldDisable = (getFieldValue(this.serviceQuote, Quote_Status) == 'Completed' || getFieldValue(this.serviceQuote, Quote_Status) == 'Cancelled');
            this.acceptDisable = fieldDisable ? true : false;
            this.rejectDisable = fieldDisable ? true : false;
            this.cancelDisable = cancelFieldDisable ? true : false;
            this.closeDisable = fieldDisable ? true : false;
            this.disableChangeOwner = fieldDisable ? true : false;
            
            if (!fieldDisable || !cancelFieldDisable) {
                this.isLoaded = false;
                getWgMemberDetails({ workgroupId: this.workgroupId })
                    .then(result => {
                        this.workgroupMemberList = result;
                        if(!fieldDisable){
                            this.disableChangeOwner = !(result.some(e => e.CH_User__c === User_Id) && (getFieldValue(this.serviceQuote, Owner_Id) == User_Id)); //updated for HWSDDP-159
                            this.closeDisable = !((getFieldValue(this.serviceQuote, Owner_Id) == User_Id) && (this.ocPermission == true) && (getFieldValue(this.serviceQuote, Response_Resolution) != null));
                            this.acceptDisable = !((getFieldValue(this.serviceQuote, Owner_Id) == User_Id) && this.cdmPermission == true && (getFieldValue(this.serviceQuote, HWS_WorkGroupType) == 'Exclusions Quotation Support-CDM') &&
                            ((getFieldValue(this.serviceQuote, Quote_Status) == 'CDM Review') || (getFieldValue(this.serviceQuote, Quote_Status) == 'Pending Customer Review') || 
                            (getFieldValue(this.serviceQuote, Quote_Status) == 'Accepted by Customer') || (getFieldValue(this.serviceQuote, Quote_Status) == 'Rejected by Customer') || (getFieldValue(this.serviceQuote, Quote_Status) == 'In Progress')));
                                                
                            this.rejectDisable = !((getFieldValue(this.serviceQuote, Owner_Id) == User_Id) && this.cdmPermission == true && (getFieldValue(this.serviceQuote, HWS_WorkGroupType) == 'Exclusions Quotation Support-CDM') &&
                            ((getFieldValue(this.serviceQuote, Quote_Status) == 'CDM Review') || (getFieldValue(this.serviceQuote, Quote_Status) == 'Pending Customer Review') || 
                            (getFieldValue(this.serviceQuote, Quote_Status) == 'Accepted by Customer') || (getFieldValue(this.serviceQuote, Quote_Status) == 'Rejected by Customer') || (getFieldValue(this.serviceQuote, Quote_Status) == 'In Progress')));
                            }
                        if(!cancelFieldDisable){
                            this.cancelDisable = !((getFieldValue(this.serviceQuote, Owner_Id) == User_Id) && (this.cdmPermission == true || ((getFieldValue(this.serviceQuote, Response_Resolution) != null) && (this.ocPermission == true) && (result.some(e => e.CH_User__c === User_Id && e.CH_Role__c === 'WG Manager-Quotation Manager')))));
                        }
                        this.isLoaded = true;
                    })
                    .catch(error => {
                        this.isLoaded = true;
                        this.error = error;
                    });
            }


            let disableEsc = getFieldValue(this.serviceQuote, Owner_Id) != this.userId;

            this.disableEscalate = disableEsc ? true : false;

            if (this.disableEscalate == true && this.actionClicked == 'escalate') {
                this.recordFormVisible = false;
            }

        }
    }
    
    isNullOrEmpty(value) {
        if (value == null || value == '' || value == undefined) {
            return true;
        }
        return false;
    }

    handleSubmit(event) {

        event.preventDefault();
        const fields = event.detail.fields;
        const today = new Date();
        this.disableSave = true;
		
        if (this.actionClicked == 'accept') {
            fields.HWS_Quote_Status__c = 'Accepted by CDM';
            fields.HWS_Date_of_Resolution__c = today.toISOString();
            this.recordFormVisible = false;
        }
        if (this.actionClicked == 'reject') {
            fields.HWS_Quote_Status__c = 'Rejected by CDM';
            fields.HWS_Date_of_Resolution__c = today.toISOString();
            this.recordFormVisible = false;
        }
        if (this.actionClicked == 'close') {
            fields.HWS_Quote_Status__c = 'Completed';
            fields.HWS_QuoteClosedDate__c = today.toISOString();
            this.recordFormVisible = false;
        }
        if (this.actionClicked == 'cancel') {
            fields.HWS_Quote_Status__c = 'Cancelled';
            fields.HWS_QuoteClosedDate__c = today.toISOString();
            this.recordFormVisible = false;
        }
		
        if (this.actionClicked == 'escalate') {
            fields.HWS_Escalated_Date__c = today.toISOString();
            this.recordFormVisible = false;

        }
        this.template.querySelector('lightning-record-edit-form').submit(fields);
        
    }

    handleSuccess(event) {

        if (event.detail.id !== null) {
            //if (this.recordFormVisible == true) {
                this.dispatchEvent(new ShowToastEvent({
                    title: "SUCCESS!",
                    message: "Record has been updated succesfully.",
                    variant: "success",
                }), );
            //}
            this.disableSave = false;
            refreshApex(this.wireRecorddetails);
        };
    }
    handleError(event) {

        let message = this.isNullOrEmpty(event.detail.detail) == false ? event.detail.detail : '';
    //    if (message.includes("Service Assurance Manager") || message.includes("RMA Closed")) {
            this.dispatchEvent(new ShowToastEvent({
                title: "Error!",
                message: message,
                variant: "error",
            }), );
      //  }
        this.disableSave = false;
        refreshApex(this.wireRecorddetails);
    }

   handleAccept() {
        this.actionClicked = 'accept';
        this.changeOwnerScreenVisible = false;
        this.recordFormVisible = true;
        if (getFieldValue(this.serviceQuote,PO_Required) == true) {        
            
            this.fields = [{ "fieldname": "HWS_Purchase_Order_Number__c", "fieldapiname": "HWS_Purchase_Order_Number__c", "type": "text", "required": true },
            { "fieldname": "HWS_Response_Resolution__c", "fieldapiname": "HWS_Response_Resolution__c", "type": "text", "required": true },
            { "fieldname": "HWS_Internal_Comments__c", "fieldapiname": "HWS_Internal_Comments__c", "type": "text", "required": false }
            ];
            }
            else{
                this.fields = [{ "fieldname": "HWS_Purchase_Order_Number__c", "fieldapiname": "HWS_Purchase_Order_Number__c", "type": "text", "required": false },
                { "fieldname": "HWS_Response_Resolution__c", "fieldapiname": "HWS_Response_Resolution__c", "type": "text", "required": true },
                { "fieldname": "HWS_Internal_Comments__c", "fieldapiname": "HWS_Internal_Comments__c", "type": "text", "required": false }
            ];
            }
   }
    handleReject() {
              
        this.actionClicked = 'reject';
        this.changeOwnerScreenVisible = false;
        this.recordFormVisible = true;
        if (this.recordTypeName==='Damaged Part Quote'){
        this.fields = [{ "fieldname": "HWS_Reason_for_Rejection__c", "fieldapiname": "HWS_Reason_for_Rejection__c", "type": "picklist", "required": true },
             { "fieldname": "HWS_Disposition_Instructions__c", "fieldapiname": "HWS_Disposition_Instructions__c", "type": "picklist", "required": true },
            { "fieldname": "HWS_Response_Resolution__c", "fieldapiname": "HWS_Response_Resolution__c", "type": "text", "required": true },
            { "fieldname": "HWS_Internal_Comments__c", "fieldapiname": "HWS_Internal_Comments__c", "type": "text", "required": false }
        ];
        }
        if (this.recordTypeName==='UnReturned Part Quote'){
            this.fields = [{ "fieldname": "HWS_Reason_for_Rejection__c", "fieldapiname": "HWS_Reason_for_Rejection__c", "type": "picklist", "required": true },           
            { "fieldname": "HWS_Response_Resolution__c", "fieldapiname": "HWS_Response_Resolution__c", "type": "text", "required": true },
            { "fieldname": "HWS_Internal_Comments__c", "fieldapiname": "HWS_Internal_Comments__c", "type": "text", "required": false }
        ];
        }    
    }
    handleCancel() {        
        this.actionClicked = 'cancel';
        this.changeOwnerScreenVisible = false;
        this.recordFormVisible = true;
        
         this.fields = [            
            { "fieldname": "HWS_CancellationReason__c", "fieldapiname": "HWS_CancellationReason__c", "type": "text", "required": true },
            { "fieldname": "HWS_Internal_Comments__c", "fieldapiname": "HWS_Internal_Comments__c", "type": "text", "required": false }
        ];
    }
    handleClose() {
        this.actionClicked = 'close';
        this.changeOwnerScreenVisible = false;
        this.recordFormVisible = true;
        this.fields = [{ "fieldname": "HWS_Order_Resolution__c", "fieldapiname": "HWS_Order_Resolution__c", "type": "picklist", "required": true },
            { "fieldname": "HWS_Internal_Comments__c", "fieldapiname": "HWS_Internal_Comments__c", "type": "text", "required": false }
        ];
    }
    handleEscalate() {
		this.disableSave = false;
        this.actionClicked = 'escalate';
        this.changeOwnerScreenVisible = false;
        this.recordFormVisible = true;
        this.fields = [{ "fieldname": "HWS_Escalation_Comments__c", "fieldapiname": "HWS_Escalation_Comments__c", "type": "text", "required": false, "clearvalue": false, "valueonload": "" }];

    }
    @track wgMemberList = [];
    @track changeOwnerTableCols = [
        { label: 'User', fieldName: 'WG_User_Name', type: 'text' },
        { label: 'Role', fieldName: 'WG_User_Role', type: 'text' }
    ];
    handleOnselect(event) {
        this.isLoaded = false;
        this.selectedItemValue = event.detail.value;
        this.recordFormVisible = false;
        if (this.selectedItemValue == 'Change_Ownership') {
            this.changeOwnerScreenVisible = true;
            this.actionClicked = 'Change_Owner';
            let allRecords = [];
            this.workgroupMemberList.forEach(element => {
                let elt = {};
                if (element.CH_Workgroup_Member_Type__c === 'User') {
                    elt.WG_User_Name = element.CH_User__r.Name;
                    elt.WG_User_Role = element.CH_Role__c;
                    allRecords.push(elt);
                }
            });
            this.allRecords = allRecords;
            this.totalNumberOfRows = allRecords.length;
            let showRows = this.initializeDataTable(allRecords, (allRecords.length > this.initialRows) ? this.initialRows : allRecords.length, this.rowNumberOffset);
            this.tabledatalist = showRows;
            if (this.targetDatatable && this.allRecords.length <= this.initialRows) {
                this.targetDatatable.enableInfiniteLoading = false;
                this.loadMoreStatus = 'No more data to load';
            }
            if (this.targetDatatable) {
                this.targetDatatable.isLoading = false;
            }
            this.isLoaded = true;
        }
    }
    
    initializeDataTable(dataList, limit, offSet) {
        var tempList = [];
        for (var i = offSet; i < limit; i++) {
            tempList.push(dataList[i]);
        }
        return tempList;
    }
    
    handleRowSelection = event => {
        this.isLoaded = false;
        var selectedRows = event.detail.selectedRows;
        var strUserName = selectedRows[0].WG_User_Name;
        var strUserRole = selectedRows[0].WG_User_Role;
        updateOwnership({
                userName: strUserName,
                userRole: strUserRole,
                sRecordId: this.recordId,
                workgroupId: this.workgroupId
            })
            .then(result => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Ownership has been successfully updated',
                        variant: 'success'
                    })
                );
                this.isLoaded = true;
                this.changeOwnerScreenVisible = false;
                eval("$A.get('e.force:refreshView').fire();");
            }).catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Failed',
                        message: error.body.message,
                        variant: 'error'
                    })
                );
                this.isLoaded = true;
            });
    }
    
    loadMoreData(event) {
        event.target.isLoading = true;
        this.targetDatatable = event.target;
        this.loadMoreStatus = 'Loading....';
        let recordOffset = this.currentCount;
        let recordLimit = this.initialRows;
        if (this.tabledatalist.length == this.totalNumberOfRows) {
            this.targetDatatable.enableInfiniteLoading = false;
            this.loadMoreStatus = 'No more data to load';
            event.target.isLoading = false;
        } else {
            let currentData = this.tabledatalist;
            let allRecords = this.allRecords;
            let newList = this.initializeDataTable(allRecords, (allRecords.length - recordOffset > recordLimit) ? recordLimit + recordOffset : allRecords.length, recordOffset);
            let newData = currentData.concat(newList);
            this.filteredRecords = newData;
            this.tabledatalist = newData;
            recordOffset = recordOffset + recordLimit;
            this.currentCount = recordOffset;
            this.loadMoreStatus = 'Please scroll down to load more data';
            if ((this.tabledatalist.length >= this.totalNumberOfRows) || newList.length < this.initialRows) {
                this.targetDatatable.enableInfiniteLoading = false;
                this.loadMoreStatus = 'No more data to load';
            }
            event.target.isLoading = false;
        }
    }
}