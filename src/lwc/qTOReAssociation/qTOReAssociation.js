import { LightningElement, wire, api, track } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import ASSOCIATION_PROCESS_STATUS from '@salesforce/label/c.QTO_Association_process_status';
import ASSOCIATION_PROCESS_INITIAL_MSG from '@salesforce/label/c.QTO_Association_process_Initial_Msg';
import ASSOCIATION_PROCESS_INPROGRESS_MSG from '@salesforce/label/c.QTO_Association_process_inProgress_MSG';
import ASSOCIATION_PROCESS_ALLOWED_MSG from '@salesforce/label/c.QTO_Association_process_allowed_msg';
import ASSOCIATION_PROCESS_COMPLETED_MSG from '@salesforce/label/c.QTO_Association_process_complete_Msg';
import STATUS from '@salesforce/schema/Customer_Document__c.Status__c';
//import getBatchStatus from '@salesforce/apex/QTO_ReAssociationController.getBatchStatus_V1';
import reAssociateCDLineItems from '@salesforce/apex/QTO_ReAssociationController.reAssociateCustomerDocumentLineItems';
import reMatchingCDLineItems from '@salesforce/apex/QTO_ReAssociationController.reMatchingCustomerDocumentLineItems';
import reEnrichmentCDLineItems from '@salesforce/apex/QTO_ReAssociationController.reEnrichmentCustomerDocumentLineItems';
// DSI - 2150
import reProcessManuallyEnrichedLines from "@salesforce/apex/QTO_ReAssociationController.reProcessManuallyEnrichedCustomerDocumentLineItems";
// DSI - 2331
import reProcessDraftWithExceptionsCustomerDocument from "@salesforce/apex/QTO_ReAssociationController.reProcessDraftWithExceptionsCustomerDocument";

import getBatchStatus from '@salesforce/apex/QTO_ReAssociationController.getBatchStatus';

import submitAssociationBatch from '@salesforce/apex/QTO_ReAssociationController.submitBatchJob';
export default class QTOReAssociation extends LightningElement {
    @api recordId;
    @api source;
    @track batchStatus='';
    @track disableButton = false;
    @track isBatchCalled = false;
    @track batchId;
    @track dontAllowToProcess;
    @track error;
    @track cdStatus;
    @track styleClass;
    batchClass = 'QTO_CustomerDocumentAssociationBatch';
    label = {
        ASSOCIATION_PROCESS_ALLOWED_MSG,
    };
    
    @wire(getRecord, {recordId: '$recordId', fields: [STATUS]})
    wiredRecord({error, data}){
        if(data){
            this.cdStatus = data.fields.Status__c.value;    
            if(this.cdStatus == 'Exception-Association' || this.cdStatus == 'Registered'){
                this.dontAllowToProcess = false;
            }
            this.styleClass = 'slds-text-small';
            this.checkBatchStatus();
        }
    }

            
    checkBatchStatus() { 
        //alert("checkBatchStatus");
       // alert('this.recordId-->'+this.recordId);
       // alert('this.batchId-->'+this.batchId);   
        console.log('** '+this.batchClass);
        console.log('** '+this.batchId);
        getBatchStatus({clsName : this.batchClass, batchId : this.batchId != undefined ? this.batchId :''})
        //getBatchStatus({clsName : this.batchClass, batchId : this.batchId != undefined ? this.batchId :'',cdId : this.recordId})
        .then(result =>{
            console.log('result-->'+result); 
            if(result === 'Completed'){
                console.log(' in completed');  
                this.disableButton = false;
                if(this.batchId != undefined){
                    console.log('batch id defined'+this.batchId);
                    this.batchStatus = ASSOCIATION_PROCESS_STATUS+' : '+result +'. '+ASSOCIATION_PROCESS_COMPLETED_MSG;
                    this.batchId = undefined;
                    this.styleClass = 'slds-text-small slds-text-color_success';
                }else{
                    if(this.isBatchCalled){
                        this.disableButton = true;
                        this.executeBatch();
                    }else{
                        this.batchStatus = ASSOCIATION_PROCESS_INITIAL_MSG ;
                    }                    
                }                
            }else{
                this.disableButton = true;
                console.log('entered in else');
                if(this.batchId != undefined){
                    console.log('batch id defined'+this.batchId);
                    this.batchStatus = ASSOCIATION_PROCESS_STATUS+' : '+result+'...';
                }else{
                    this.batchStatus = ASSOCIATION_PROCESS_INPROGRESS_MSG;
                }
                setInterval(this.checkBatchStatus(),1000);
            }
        })
        .catch(error => {
            this.error = error.body.message;
        });
                  
    }

    reEnrichmentCDLines() {
        //alert('this.recordId-->'+this.recordId);
        reEnrichmentCDLineItems({cdId : this.recordId})
        .then(result =>{
            console.log(' in completed');  
            this.disableButton = false;
            this.batchStatus = 'Line item enrichment process has been completed';
            this.styleClass = 'slds-text-small slds-text-color_success'; 
        })
        .catch(error => {
            this.error = error.body.message;
        });    
    }
    // DSI - 2150
    reProcessManuallyEnrichedLines() {
        reProcessManuallyEnrichedLines({cdId : this.recordId})
        .then(result =>{
            console.log(' in completed');  
            this.disableButton = false;
            this.batchStatus = 'Line item association process has been completed';
            this.styleClass = 'slds-text-small slds-text-color_success'; 
        })
        .catch(error => {
            this.error = error.body.message;
        });    
    }

    reAssociationCDLines() {
        //alert('this.recordId-->'+this.recordId);
        reAssociateCDLineItems({cdId : this.recordId})
        .then(result =>{
            console.log(' in completed');  
            this.disableButton = false;
            this.batchStatus = 'Line item association process has been completed';
            this.styleClass = 'slds-text-small slds-text-color_success'; 
        })
        .catch(error => {
            this.error = error.body.message;
        });    
    }


    reMatchingCDLines() {
        //alert('this.recordId-->'+this.recordId);
        reMatchingCDLineItems({cdId : this.recordId})
        .then(result =>{
            console.log(' in completed');  
            this.disableButton = false;
            this.batchStatus = 'Line item matching process has been completed';
            this.styleClass = 'slds-text-small slds-text-color_success'; 
        })
        .catch(error => {
            this.error = error.body.message;
        });    
    }

    // DSI - 2331
    async reProcessCustomerDocument() {
        try {
            await reProcessDraftWithExceptionsCustomerDocument({recordId: this.recordId});
            this.disableButton = false;
            this.batchStatus = 'Customer Document has been processed';
            this.styleClass = 'slds-text-small slds-text-color_success'; 
        } catch(error) {
            this.error = error.body.message;
        }
    }

    submitAssociationBatch(){
       //alert("submitAssociationBatch");
       // alert('this.cdStatus-->'+this.cdStatus);
       //alert('this.recordId-->'+this.recordId);
        console.log('** '+this.recordId);
        console.log('cd status '+this.cdStatus);
        if(this.cdStatus !== 'Exception-Association' && this.cdStatus !== 'Registered') {
            //alert("submitAssociationBatch" + this.cdStatus);
            if(this.cdStatus == 'Exception-Enrichment(Lines)') {
                this.reEnrichmentCDLines(); 
                this.disableButton = true;  
                this.batchStatus = 'Line item enrichment process has been started';
            } // DSI - 2150
            else if(this.cdStatus == 'Manually-Enriched(Lines)') {
                this.reProcessManuallyEnrichedLines(); 
                this.disableButton = true;  
                this.batchStatus = 'Line item association process has been started';
            }
            else if(this.cdStatus == 'Exception-Association(Lines)') {
                this.reAssociationCDLines(); 
                this.disableButton = true;  
                this.batchStatus = 'Line item association process has been started';    
            }
            else if(this.cdStatus == 'Exception-Matching(Lines)') {
                this.reMatchingCDLines();  
                this.disableButton = true;  
                this.batchStatus = 'Line item matching process has been started';
            }
            // DSI-2331
            else if(this.cdStatus === 'Draft with Exceptions' || this.cdStatus === 'Draft') {
                this.reProcessCustomerDocument();
                this.disableButton = true;
                this.batchStatus = 'Customer Document is being processed';
            }
            else {
                this.dontAllowToProcess = true;
                this.batchStatus = undefined;
            }
        }
        else {
                this.disableButton = true;
                this.isBatchCalled = true;
                this.checkBatchStatus();
        }        
    }
 
    executeBatch(){
        this.batchStatus = ASSOCIATION_PROCESS_STATUS+' : Submitted' ;
        console.log('check.... '+this.disableButton);
        this.isBatchCalled = false;
		submitAssociationBatch({cdId : this.recordId})
            .then(result =>{
                this.batchId = result;
                console.log('result-->'+this.batchId); 
                this.checkBatchStatus();
            })
            .catch(error => {
                this.error = error.body.message;
            });
    }
}