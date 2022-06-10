import { LightningElement,api,track, wire } from 'lwc';
import proposal from '@salesforce/apex/quoteTreeController.fetchQuote';
import { NavigationMixin } from 'lightning/navigation';

export default class treeGrid extends   NavigationMixin( LightningElement )  {
    @api recordId;
    @track showButtons;  
    @track totalQuotes;
      
    gridData;   
    @track gridColumns = [{
        type: 'text',
        fieldName: 'Name',
        label: 'Quote Number',
    },    
    {
        type: 'text',
        fieldName: 'NokiaCPQ_Proposal_Id__c',
        label: 'Version'
    },
    {
        type: 'text',
        fieldName: 'Apttus_Proposal__Proposal_Name__c',
        label: 'Quote Name'
    },
    {
        type: 'text',
        fieldName: 'Apttus_Proposal__Approval_Stage__c',
        label: 'Approval Stage'
    },
    {
        type: 'text',
        fieldName: 'Apttus_Proposal__Proposal_Expiration_Date__c',
        label: 'Quote Expiration Date'
    },
    {
        type: 'text',
        fieldName: 'Apttus_Proposal__Primary__c',
        label: 'Primary'
    },
    {
        type: 'button',
        typeAttributes: {
            label: 'View',
            variant: 'brand'
        }
    }];
    @track gridColumns1 = [{
        type: 'text',
        fieldName: 'Name',
        label: 'Quote Number',
    },    
    {
        type: 'text',
        fieldName: 'NokiaCPQ_Proposal_Id__c',
        label: 'Version'
    },
    {
        type: 'text',
        fieldName: 'Apttus_Proposal__Proposal_Name__c',
        label: 'Quote Name'
    },
    {
        type: 'text',
        fieldName: 'Apttus_Proposal__Approval_Stage__c',
        label: 'Approval Stage'
    },
    {
        type: 'text',
        fieldName: 'Apttus_Proposal__Proposal_Expiration_Date__c',
        label: 'Quote Expiration Date'
    },   
    {
        type: 'button',
        typeAttributes: {
            label: 'View',
            variant: 'brand'
        }
    }];
    
    @track gridData;  
    @track showPrimary; 
    @track hidePrimary; 
    @wire(proposal,{recordId: '$recordId'})
    proposalTreeData({ error, data }) {
      if ( data ) {          
            if(data.length>0){
                this.showButtons=true;
                this.totalQuotes=data.length;
            }
            var tempData = JSON.parse( JSON.stringify( data ) );   
            if (tempData[0].Quote_Type__c=='Direct CPQ'){
                              
                this.showPrimary=true;
            }else{
                this.hidePrimary=true;
                
            }        
            for ( var i = 0; i < tempData.length; i++ ) {
                tempData[ i ]._children = tempData[ i ][ 'Quote_Proposal__r' ];
                delete tempData[ i ].Quote_Proposal__r;
            }
            this.gridData = tempData;
        } else if ( error ) { 
                 
            if ( Array.isArray( error.body ) )
                console.log( 'Error is ' + error.body.map( e => e.message ).join( ', ' ) );
            else if ( typeof error.body.message === 'string' )
                console.log( 'Error is ' + error.body.message );
        }

    }
    clickToExpandAll( e ) {
        const grid =  this.template.querySelector( 'lightning-tree-grid' );
        grid.expandAll();
    }
    clickToCollapseAll( e ) {
        const grid =  this.template.querySelector( 'lightning-tree-grid' );
        grid.collapseAll();      
    }
    handleRowAction(event) {
        const row = event.detail.row;
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: row.Id,
                actionName: 'view'
            }
        });
    }
   
}