/**
 * @description       : 
 * @author            : Lovel Panchal
 * @group             : 
 * @last modified on  : 11-18-2020
 * @last modified by  : Lovel Panchal
 * Modifications Log 
 * Ver   Date         Author          Modification
 * 1.0   11-06-2020   Lovel Panchal   Initial Version
 **/
 import {
    LightningElement,
    track,
    wire,
    api
} from 'lwc';
import getRecordsList from '@salesforce/apex/QTO_ManualAssociationController.getAllAssociationData';
import insertJunctionRecord from '@salesforce/apex/QTO_ManualAssociationController.saveAssociationData';
import getTableHeaders from '@salesforce/apex/QTO_ManualAssociationController.getTableHeaders';
import getStatus from '@salesforce/apex/QTO_ManualAssociationController.getStatus';
import {
    getRecord,
    getFieldValue
} from 'lightning/uiRecordApi';
import {
    ShowToastEvent
} from 'lightning/platformShowToastEvent';
// DSI-2340
import getQuoteLinesToAssociate from '@salesforce/apex/QTO_ManualAssociationController.getQuoteLinesToAssociate';


export default class QTOtable extends LightningElement {
    @api recordId;
    @track error;
    @track columns = [];
    @track data; //All Data available for data table    
    @track showTable = false; //Used to render table after we get the data from apex controller    
    @track recordsToDisplay = []; //Records to be displayed on the page
    @track rowNumberOffset; //Row number
    @track showSpinner = false;
    @track preSelectedRows;
    @track SelectedFilterdRows;
    @track pageNumber;
    @track inProgress = false;
    @api ObjectName;
    @api name;
    @track recordsToDisplay = []; //Records to be displayed on the page


    connectedCallback() {
        console.log("recordId==>" + this.recordId);
        console.log("ObjectName==>" + this.ObjectName);
        if (this.ObjectName == 'QTO_Customer_Document_Quote_Line__c')
            this.name = 'Quote Lines';
        else if (this.ObjectName == 'QTO_Customer_Document_Agreement_Line__c')
            this.name = 'Agreement Lines';
        else if (this.ObjectName == 'Customer_Document_Line_Items__c')
            this.name = 'Customer Document Lines';
        else
            this.name = this.ObjectName;

        this.getRecordListClient(this.ObjectName);
    }

    @wire(getTableHeaders, {
        objectName: '$ObjectName'
    })
    wiredInitData({
        error,
        data
    }) {
        if (data) {

            this.columns = data;
            console.log('data-->' + JSON.stringify(this.columns));
        } else if (error) {
            this.error = error;
        }
    }


    refreshQuote() {
        this.getStatus();
    }


    getStatus() {
        try {
            if (this.ObjectName != 'QTO_Customer_Document_Quote_Line__c' &&
                this.ObjectName != 'QTO_Customer_Document_Agreement_Line__c' &&
                this.ObjectName != 'Customer_Document_Line_Items__c') {

                getStatus({
                        CDId: this.recordId
                    })
                    .then(result => {
                        console.log('result-->' + JSON.stringify(result));
                        if (this.ObjectName == 'Quote')
                            this.inProgress = result;
                        else {
                            this.inProgress = false;
                        }
                        if (this.inProgress == false) {
                            this.dispatchEvent(
                                new ShowToastEvent({
                                    title: 'Success',
                                    message: 'Association Processed Successfully',
                                    variant: 'success',
                                }),
                            )
                        }

                    })
                    .catch(error => {
                        this.errors = error.body.message;
                        this.dispatchEvent(
                            new ShowToastEvent({
                                title: 'Error',
                                message: error.body.message,
                                variant: 'error',
                            }),
                        )
                    });
            } else {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Data Processed Successfully',
                        variant: 'success',
                    }),
                )
            }
        } catch (err) {
            console.log('Error--' + err.message);
        }
    }
    //get all picklist value dynamically call from any  method
    getRecordListClient(objname) {
        try {
            console.log('objname-->' + objname);
            getRecordsList({
                    objectName: objname,
                    CDId: this.recordId
                })
                .then(result => {
                    console.log('result-->' + JSON.stringify(result));
                    try {
                        //this.data = result.dataList;

                        let recs = [];
                        for(let i=0; i<result.dataList.length; i++){
                            let opp = {};
                            opp.rowNumber = ''+(i+1);
                            opp = Object.assign(opp, result.dataList[i]);
                            recs.push(opp);
                        }
                        this.data = recs;
                        
                        this.preSelectedRows = result.selectedIdSet;
                        if (this.data.length > 0)
                            this.showTable = true;
                        else
                            this.showTable = false;
                    } catch (e) {
                        console.log(e)
                    }
                })
                .catch(error => {
                    this.errors = error.body.message;
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error',
                            message: error.body.message,
                            variant: 'error',
                        }),
                    )
                });
        } catch (err) {
            console.log('Error--' + err.message);
        }
    }
    //Capture the event fired from the paginator component
    handlePaginatorChange(event) {
        //this.SelectedFilterdRows = [];
        //this.recordsToDisplay = [];
        
        this.recordsToDisplay = event.detail;
        this.rowNumberOffset = this.recordsToDisplay[0].rowNumber - 1;
        this.SelectedFilterdRows = this.preSelectedRows;
        
        console.log('recordsToDisplay--' + this.recordsToDisplay);
        console.log('rowNumberOffset--' + this.rowNumberOffset);
        console.log('preSelectedRows--' + this.preSelectedRows);



      
    }




    handleSaveClick(event) {
        try {
            this.showSpinner = true;
            // save changes made through inline edit
            this.ObjectName === 'Customer_Document_Line_Items__c' && this.saveDrafts(this.recordId, this.ObjectName);
            const selectedRecords = this.template.querySelector("lightning-datatable").getSelectedRows();
            console.log('selectedRecords--' + JSON.stringify(selectedRecords) + '--' + this.recordId);

            insertJunctionRecord({
                    saveData: JSON.stringify(selectedRecords),
                    CDId: this.recordId,
                    objectName: this.ObjectName
                })
                .then(result => {
                    this.data = result.dataList;
                    this.preSelectedRows = result.selectedIdSet;
                    this.showSpinner = false;
                    this.inProgress = true;
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Success',
                            message: 'Data Processed Successfully',
                            variant: 'success',
                        }),
                    )
                }).catch(error => {
                    this.showSpinner = false;
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error',
                            message: 'Issue in saving the records ' + JSON.stringify(error),
                            variant: 'error',
                        }),
                    )
                });
        } catch (err) {
            this.showSpinner = false;
            console.log('Error--' + err.message);
        }
    }

    async saveDrafts(recordId, objectApiName) {
        const datatable = this.template.querySelector('lightning-datatable');
        console.log(JSON.stringify(datatable.draftValues));
        console.log('Record Id .....' + recordId);
        console.log('object ApiName .....' + objectApiName);
        // if an element with tag lightning-datatable is found
        if (datatable) {
            try {
                //const result = await saveDraftCDLines({draftString: JSON.stringify(datatable.draftValues), cdId :this.recordId} );
                const result = await insertJunctionRecord({
                    saveData: JSON.stringify(datatable.draftValues),
                    CDId: this.recordId,
                    objectName: objectApiName
                });
                if (result) {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Success',
                            message: 'Changes Saved Successfully',
                            variant: 'success',
                        }),
                    )
                }
            } catch (error) {
                console.error(JSON.stringify(error));
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: 'Issue in saving the records ' + error.body.message || JSON.stringify(error),
                        variant: 'error',
                    }),
                )
            }
        }
    }
    // DSI-2340 START
    _isHeaderAssociations = false;
    _isSoldToParty = true; // default filter for quote line association
    get isQuoteLineAssociation() {
        return this.ObjectName === 'QTO_Customer_Document_Quote_Line__c';
    }

    handleAssociateQuoteLineFilterChange(event) {
        const isChecked = event.target.checked;
        const option = event.target.value;
        console.log({option});
        this.showTable = 0;         

        //if (inputName === 'header_associations') { this._isHeaderAssociations = isChecked; }
        //if (inputName === 'sold_to_party') { this._isSoldToParty = isChecked; }

        //const option = (inputName == 'header_associations' ? 'header_associations'  : this._isSoldToParty ? 'sold_to_party' : 'all';
        //event.target.setAttribute('aria-checked', isChecked);

        getQuoteLinesToAssociate({recordId: this.recordId, option: option})
        .then(data => {
            const {dataList, selectedIdSet} = data;
            this.data = dataList.map((row, index) => {
                return {
                    ...row,
                    rowNumber: index
                }
            });            
            this.preSelectedRows = selectedIdSet || [];
            this.showTable = this.data.length > 0;         
        })
        .catch(error => {
            console.error(error);
            this.errors = error.body?.message || JSON.stringify(error);
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: error.body?.message || JSON.stringify(error),
                    variant: 'error',
                }),
            )
        });
    }

    setHeaderAssociations(value) {
        this._isHeaderAssociations = value;
    }

    setSoldToParty(value) {
        this._isSoldToParty = value;
    }
    // DSI-2340 END
}