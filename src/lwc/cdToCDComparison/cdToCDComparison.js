import { LightningElement, api, wire, track } from 'lwc';

import cdDocument from '@salesforce/apex/QTO_CDToCDComparisonController.retriveCdDocuments'
export default class CdToCDComparison extends LightningElement {

    @api
    get recordId() {
        return this._recordId;
    }

    set recordId(recordId) {
        this._recordId = recordId;
    }

    currentCDDocument;
    nokiaCDDocument;
        // Save it
    cdDocument
    @wire(cdDocument, { cdAssociationId : '$recordId' })
    cdDocument1({ error, data }) {
        if (data) {
            console.log('data-->', data);
            this.cdDocument = data;
            this.currentCDDocument = this.cdDocument.cdDoc;
            this.nokiaCDDocument = this.cdDocument.nokiaCdDoc;

            console.log('cdDoc', this.currentCDDocument);
            console.log('ncd', this.nokiaCDDocument);
            
        } else if (error) {
            console.log('error', error);
        }
        this.populateColorHightlight();
    }

    populateColorHightlight() {
        console.log('this is called');
    
        const outputFields = this.template.querySelectorAll('lightning-output-field');

        let allFieldsForDups = [];

       
        console.log('output fields', outputFields);
        if (outputFields) {
            outputFields.forEach(field => {
                console.log('field', field);
                // eslint-disable-next-line no-console
                let currentFieldName = field.fieldName;
                console.log(currentFieldName);
                console.log('cddoc', this.currentCDDocument[currentFieldName]);
                console.log('ndoc', this.nokiaCDDocument[currentFieldName]);

                console.log('field', JSON.stringify(field.fieldName), field.fieldvalue);

                if (allFieldsForDups.includes(currentFieldName) && (this.nokiaCDDocument[currentFieldName] != this.currentCDDocument[currentFieldName])) {
                    if (currentFieldName != 'Customer_Document_ID__c' && currentFieldName != 'Name') {
                        field.classList.add('changeColor');
                    }
                } else {
                    allFieldsForDups.push(currentFieldName);
                }
            });
        }
    }
}