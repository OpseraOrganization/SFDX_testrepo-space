import { LightningElement,api } from 'lwc';
import syncPriceAction from'@salesforce/apex/HWS_QuoteActions.syncPriceAction';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { updateRecord } from 'lightning/uiRecordApi';
import HWS_Sync_Price_Failed from '@salesforce/label/c.HWS_Sync_Price_Failed';
import HWS_Sync_Price_Success from '@salesforce/label/c.HWS_Sync_Price_Success';
export default class HwsSyncPriceAction extends LightningElement {
    @api recordId;
    @api invoke(){
        syncPriceAction({ sRecordId : this.recordId })
        .then(result => {
            if(result =='ok'){
                this.dispatchEvent(
                    new ShowToastEvent( {
                        title: 'Success',
                        message: HWS_Sync_Price_Success,
                        variant: 'success'
                    } )
                    
                );
            }
            else{
                this.dispatchEvent(
                new ShowToastEvent( {
                    title: 'Failed',
                    message: HWS_Sync_Price_Failed,
                    variant: 'error'
                } )
                );
            }
             eval("$A.get('e.force:refreshView').fire();");
        }).catch( error => {
            this.dispatchEvent(
                new ShowToastEvent( {
                    title: 'Failed',
                    message: error.body.message,
                    variant: 'error'
                } )
            );
        });
    }
}