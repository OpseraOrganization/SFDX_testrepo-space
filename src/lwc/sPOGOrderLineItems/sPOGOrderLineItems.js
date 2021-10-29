import { LightningElement, api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import executeRequest from "@salesforce/apex/SPoG_Handler.executeRequest";    

export default class SPOGOrderLineItems extends LightningElement {
    @api items;
    lineItemNumber = 0;
    @track lineItemsToShow;
    @track prodNum;
    @track custNum;
    @track attachments;
    @track isModalOpen = false;
    @track deliveryattachmnest;
    @track selectedradioindex;
    @track showRadios = false;

    connectedCallback() {
        this.lineItemsToShow = this.items[0].lineItems;
        this.attachments = this.items[0].attachments;
    }

    //if this is set to blank, the header will be shown
    get headerClass() {
        return this.lineItemNumber++ === 0 ? '' : 'hideHeader';
    }

    searchProduct(event) {
        this.prodNum = event.target.value;
        window.clearTimeout(this.delayTimeout);
        this.delayTimeout = setTimeout(() => {
            this.refineFilters();
        },300);
    }

    searchCustMaterial(event) {
        this.custNum = event.target.value;
        window.clearTimeout(this.delayTimeout);
        this.delayTimeout = setTimeout(() => {
            this.refineFilters();
        },300);
    }

    refineFilters() {
        this.lineItemsToShow = this.items[0].lineItems;
        if(this.prodNum) {
            this.lineItemsToShow = this.lineItemsToShow.filter(ele=>ele.productNumber.toUpperCase().includes(this.prodNum.toUpperCase()));
        }
        if(this.custNum) {
            this.lineItemsToShow = this.lineItemsToShow.filter(ele=>
                ele.customerMaterialNumber.toUpperCase().includes(this.custNum.toUpperCase()));
        }
        this.lineItemNumber = 0;
    }

    downloadcommonDocuments(){
        this.lineItemNumber = 0;
        
        console.log('attachments --- 1  ',JSON.stringify(this.attachments));
        var searchRes = [];
        var allData = this.attachments; 
       // var searchKeyword = deliverNum.toUpperCase(); 
        for(var key in allData) {
          
                if(allData[key].fileId != 'SHIPPER' && allData[key].fileId != 'INVOICE'){
                    searchRes.push(allData[key]); 
                    console.log('match found'); 
                }
        }

        if(searchRes.length > 0 ){
        this.isModalOpen = true;
        this.deliveryattachmnest = searchRes;
        
        }else{
         this.showInfoToast(' Don\'t have any attachments','warning');
        }

    }

    showInfoToast(mess,varri) {
        const evt = new ShowToastEvent({
            title: 'Information',
            message: mess,
            variant: varri,
            mode: 'dismissable'
        });
        this.dispatchEvent(evt);
    }

    closeModal() {
        // to close modal set isModalOpen tarck value as false
        this.isModalOpen = false;
        this.lineItemNumber = 0;
    }

    onSelect(event) {
        this.selectedradioindex = event.target.dataset.index;
        console.log('Index of Selected Attachment -- ',this.selectedradioindex);
        this.showRadios = true;

    }
    downloaddeliveryattachment(){

        var selectedItem =this.deliveryattachmnest[this.selectedradioindex];
        console.log('selectedItem --  ',selectedItem);
        console.log('documentId --  ',selectedItem.documentId);
        console.log('componentId --  ',selectedItem.componentId);
        
        var inputParams = {};
        inputParams.doAction = 'getPOAttachment';
        inputParams.documentId =selectedItem.documentId;
        inputParams.componentId =selectedItem.componentId;

        executeRequest({serverInput: JSON.stringify(inputParams)})
        .then(result => {
            //this.wiredContact = result;
            console.log('result --   ' ,result);
            var res = JSON.parse(result);
            console.log('message --   ' ,res.message);
            console.log('attachmentId --   ' ,res.attachmentId);
            if(res.isSuccess) {
                this.openDownloadLink(res.attachmentId);         
            }
            else {
                this.showInfoToast(res.message,'warning');
                
            }
        })
        .catch(error => {
            console.log('error -- ',error);
            this.error = error;
            this.showInfoToast('Application Error Please Contact Support','error');
           
        });

    }

    openDownloadLink(attachmentId) {
        //replace below with url event 
        window.open('/servlet/servlet.FileDownload?file='+attachmentId);
        //delete the attachment after a delay to clean up stored files
         
       // window.setTimeout(this.deleteThisAttachment,7000,component,attachmentId); 
        //this.deleteThisAttachment(component,attachmentId); 
    } 

    /* deleteThisAttachment(inputId) {
        console.log('Inside temporary SF attachment');
        var serverAction = component.get('c.executeRequest'); 
        
        var inputParams = {};
        inputParams.doAction = 'deleteAttachment'; 
        inputParams.attachmentId = inputId ; 
        
        serverAction.setParams({
            serverInput : JSON.stringify(inputParams)
        }); 
        
        serverAction.setCallback(this,function(response){
            if(response.getState() === 'SUCCESS') {
                console.log('Deleted the temporary SF attachment'); 
            }
        }); 
        enqueueAction(serverAction);
    } */
}