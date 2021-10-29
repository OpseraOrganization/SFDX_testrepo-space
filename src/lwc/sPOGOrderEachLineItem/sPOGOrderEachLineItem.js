import { LightningElement, track, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import executeRequest from "@salesforce/apex/SPoG_Handler.executeRequest";

const lineColumns = [
    {label:'',fieldName: ''},
    {label:'Line Item #',fieldName: 'lineItemNumber'},
    {label:'Material',fieldName: 'productNumber'},
    {label:'Plant',fieldName: 'shippingFrom'},
    {label:'Delay Code', fieldName:'delayCode'},   
    //{label:'CRM Case',fieldName: 'repairCase'}, 
    {label:'CLIN',fieldName: 'contractLineItemNumber'},
    {label:'Order Qty',fieldName: 'quantity'},
    {label:'Unit Price',fieldName:'lineItemNetValue',type:'integer'},
    //{label:'Ship to Name',fieldName: 'shipTo.name'},
    //{label:'Serial Number #',fieldName: 'serialNumber'},    
    {label:'Customer Part',fieldName: 'customerMaterialNumber'}
    
];

const deliveryColumns = [
    {label:'Sched Line#', fieldName:'scheduledLineitemNumber'},
    {label:'ESD Date*', fieldName:'schedulatedDate'},
    {label:'Schedule Qty', fieldName:'shippedQuantity'},   
    {label:'Delivered Qty', fieldName:'shippedQuantity'},       
    {label:'Sched Delv Block', fieldName:'scheduleLineBlockDescription'},
    {label:'Original Request Date', fieldName:'requestedShipDate'},
    {label:'Actual GI Date', fieldName:'shippingDate'},
    {label:'Delivery#', fieldName:'deliveryNumber', sortable: "true"},
    {label:'AWB#', fieldName:'trackingNumber'}, 
    {label:'Initial GI Date',fieldName: 'esdDateInt'}, 
    {label:'Current GI Date',fieldName: 'esdDateFin'},
    {label:'Initial BFD Date',fieldName: 'promDateInt'},
    {label:'Current BFD Date',fieldName: 'promDateFin'},    
    {label:'No of Days Moved',fieldName: 'noOfDays'}  ,  
    {label:'Shipper/Invoice Docs', type:"button",    
     typeAttributes: {  
        label: 'Shipper/Invoice', 
        name: 'Delivery',  
        title: 'Download',  
        disabled: false,  
        iconPosition: 'left', 
        variant: 'brand',
    }}, 
,
];



export default class SPOGOrderEachLineItem extends LightningElement {
    @api line;
    @api item;
    @api showheader;
    lineColumns = lineColumns;
    deliveryColumns = deliveryColumns;
    @track iconToshow = 'utility:chevronright';
    @track deliveryItemsClass = 'hideLineItems';
    @api headerClass;
    @track sortBy = 'deliveryNumber';
    @track sortDirection ='desc';
    @track gridData;
    @api attachments;
    @track deliveryattachmnest;
    @track deliv;
    @track showRadios = false;
    @track selectedradioindex;
    @track isModalOpen = false;
    @track sno = 1;

    connectedCallback() {
        console.log('header', this.showheader);
        this.gridData = this.line.deliveries ? this.line.deliveries : [];
        this.sortData('deliveryNumber', 'asc');
        //this.line.lineItemNetValue = Intl.NumberFormat('en-US', {style: 'currency', currency: 'USD'})
        //.format(this.line.lineItemNetValue);
    }

    toggleDelivery(event) {
        if(this.iconToshow === 'utility:chevrondown') {
            this.iconToshow = 'utility:chevronright';
            this.deliveryItemsClass = 'hideLineItems'
        } else if(this.iconToshow === 'utility:chevronright') {
            this.iconToshow = 'utility:chevrondown';
            this.deliveryItemsClass = 'showLineItems'
        }
       
    }

    handleSortdata(event) {
        // field name
        this.sortBy = event.detail.fieldName;

        // sort direction
        this.sortDirection = event.detail.sortDirection;

        // calling sortdata function to sort the data based on direction and selected field
        this.sortData(event.detail.fieldName, event.detail.sortDirection);
    }

    sortData(fieldname, direction) {
        // serialize the data before calling sort function
        let parseData = JSON.parse(JSON.stringify(this.gridData));

        // Return the value stored in the field
        let keyValue = (a) => {
            return a[fieldname];
        };

        // cheking reverse direction 
        let isReverse = direction === 'asc' ? 1: -1;

        // sorting data 
        parseData.sort((x, y) => {
            x = keyValue(x) ? keyValue(x) : ''; // handling null values
            y = keyValue(y) ? keyValue(y) : '';

            // sorting values based on direction
            return isReverse * ((x > y) - (y > x));
        });

        // set the sorted data to data table data
        this.gridData = parseData;
    }

    get linItemCurrency() {
        return Intl.NumberFormat('en-US', {style: 'currency', currency: 'USD'}).format(this.line.lineItemNetValue);
    }




    handleRowAction(event) {
       
       /* const row = event.detail.row;
        const { id } = row;
        console.log('detail -- ',event.detail);
        console.log('row -- ',JSON.stringify(event.detail.row));
        console.log('row -- ',JSON.stringify(event.detail.row.deliveryNumber));
        console.log('row23 -- ',event.detail.row.id);
        //console.log('Index -- ',event.detail.index);
        //console.log('Index2 -- ',event.detail.index.row);
        console.log('Id -- ',id);
        const index = this.findRowIndexById(id);
        console.log('Index -- ',index); */
        var deliverNum = event.detail.row.deliveryNumber;
        console.log('deliverNum -- ', deliverNum);
        if(deliverNum){
        this.attchmentslist(deliverNum);
        }
        else{
            this.showInfoToast('No Delivery Number Found','warning'); 
        }
    }

   /* findRowIndexById(id) {
        let ret = -1;
        this.gridData.some((row, index) => {
            console.log('rowID -- ',row.id);
            console.log('ID23 -- ', id);
            if (row.id === id) {
                ret = index;
                return true;
            }
            return false;
        });
        return ret;
    } */

    attchmentslist(deliverNum){

        console.log('attachments --- 1  ',JSON.stringify(this.attachments));
        var searchRes = [];
        var allData = this.attachments; 
        var searchKeyword = deliverNum.toUpperCase(); 
        for(var key in allData) {
            if(allData[key].order && allData[key].order.toUpperCase().indexOf(searchKeyword) > -1)
            {
                console.log('match found'); 
                if(allData[key].fileId === 'SHIPPER' || allData[key].fileId === 'INVOICE'){
                    searchRes.push(allData[key]); 
                }
                
            }
        }

        if(searchRes.length > 0 ){
        this.isModalOpen = true;
        this.deliveryattachmnest = searchRes;
        this.deliv = deliverNum;
        
        }else{
         this.showInfoToast('Delivery '+ deliverNum +' Don\'t have any attachments','warning');
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
            console.log('message --   ' ,res.attachmentId);
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