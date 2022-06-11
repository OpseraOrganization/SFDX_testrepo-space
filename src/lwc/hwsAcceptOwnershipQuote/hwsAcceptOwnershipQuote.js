import { LightningElement, api } from 'lwc';
import acceptOwnerShip from'@salesforce/apex/HWS_QuoteActions.acceptOwnerShip';
import HWS_AcceptOwnership_Success from '@salesforce/label/c.HWS_AcceptOwnership_Success';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


export default class hwsAcceptOwnershipQuote extends LightningElement {
    @api recordId;
    @api invoke(){
        acceptOwnerShip({ sRecordId : this.recordId })
        .then(result => {
            console.log(JSON.stringify(result));
            this.dispatchEvent(
                new ShowToastEvent( {
                    title: 'Success',
                    message: HWS_AcceptOwnership_Success,
                    variant: 'success'
                } )
            );
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