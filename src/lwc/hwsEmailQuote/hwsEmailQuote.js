import { LightningElement, track, wire, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { loadScript } from 'lightning/platformResourceLoader';
import downloadjs from '@salesforce/resourceUrl/downloadjs';
import emailQuote from '@salesforce/apex/HWS_EmailQuote.emailQuote';
import { CloseActionScreenEvent } from 'lightning/actions';


export default class HwsEmailQuote extends LightningElement {
    boolShowSpinner = false;
    @api recordId;
    submitDetails() {
        this.boolShowSpinner = true;
        emailQuote({ recrdId: this.recordId , isFromUI : "True" }).then(response => {
            console.log(response);
            this.boolShowSpinner = false;
            if (response != null) {
                let rep = response;
                if (rep.includes("Email Cannot be sent as all are Inactive Contacts")) {
                    const evt = new ShowToastEvent({
                        title: "Error",
                        message: "Email Cannot be sent as all are Inactive Contacts.",
                        variant: "Error",
                    });
                    this.dispatchEvent(evt);
                }
                else if (rep.includes("You are not the Authorized Owner To Perform Action")) {
                    const evt = new ShowToastEvent({
                        title: "Error",
                        message: response,
                        variant: "Error",
                    });
                    this.dispatchEvent(evt);
                }
                else {
                    const evt = new ShowToastEvent({
                        title: "Warning",
                        message: response,
                        variant: "warning",
                    });
                    this.dispatchEvent(evt);

                }
            } else {
                const evt = new ShowToastEvent({
                    title: "Success",
                    message: "Email has been sent Succesfully.",
                    variant: "Success",
                });
                this.dispatchEvent(evt);
            }
			eval("$A.get('e.force:refreshView').fire();");
            this.dispatchEvent(new CloseActionScreenEvent());

        }).catch(error => {
            console.log('Error: ' + error.body.message);
        });

    }

    closeQuickAction() {
        this.dispatchEvent(new CloseActionScreenEvent());
    }

    renderedCallback() {

        loadScript(this, downloadjs)
            .then(() => console.log('Loaded download.js'))
            .catch(error => console.log(error));

    }

}