/**********************************************************************************************************************
* Date          Modified By         Remarks
* 27/01/2021    Soham               Created - To enable the NDA Chat Bot for Customer Portal. This is developed as 
                                    part of DEM0053592 - Enabling the NDA Chat Bot
***********************************************************************************************************************/
import { LightningElement, track, wire, api} from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
// Import custom labels
import ndaChatBotURL from '@salesforce/label/c.NCP_NDAChatbotURL';
import ndaChatBotURLSandbox from '@salesforce/label/c.NCP_NDAChatbotURL_Sandbox';
import ndaChatBotURLForSSO41 from '@salesforce/label/c.NCP_NDAChatbotURL_SSO41';
import ndaChatBotURLForSSO41Sandbox from '@salesforce/label/c.NCP_NDAChatbotURL_SSO41_Sandbox';
import ndaChatBotURLForGuestLogin from '@salesforce/label/c.NCP_NDAChatbotURL_Guest';
import ndaChatBotURLForGuestProdLogin from '@salesforce/label/c.NCP_NDAChatbotURL_GuestProd';
//Import Static Resource
import NDAIMAGE from '@salesforce/resourceUrl/NDAChatbotFolder';
// Import Apex Methods
import checkBotRefresh from '@salesforce/apex/NCP_NDAChatBotController.chatBotRefresh';
import isProductionFlag from '@salesforce/apex/NCP_NDAChatBotController.isProductionOrg';
import isGuestUserFlag from '@salesforce/apex/NCP_NDAChatBotController.isGuestUser';

export default class NCP_NDAChatBot extends LightningElement {
    @api fromsource = "No Source passed";
    currentPageReference = null; 
    urlStateParameters = null;
    /* Params from Url */
    conversationId = null;
    conversationCode = null;
    urlType = null;
    
    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
        if (currentPageReference) {
            this.urlStateParameters = currentPageReference.state;
            this.setParametersBasedOnUrl();
        }
    }
 
    setParametersBasedOnUrl() {
       this.conversationId = this.urlStateParameters.conversationid || null;
       this.conversationCode = this.urlStateParameters.conversationcode || null;
       console.log('Conversation Id: ' + this.conversationId);
       console.log('Conversation Code: ' + this.conversationCode);
    }

    @track isProduction;
    @track error;
    @track resourcePath = NDAIMAGE + '/NDAChatbot/ndachatbot.png';
    @track isBotRefresh = false;
    @track isGuestUser = false;

    openForm() {
        console.log('Called Open Form');
        this.template.querySelector('div').style.display = "block";
        this.template.querySelector('button').style.display = "none";
        if(sessionStorage.getItem('SessionId') != null){
            this.isBotRefresh = true;
            //alert(' OpenForm isBotRefresh ' + this.isBotRefresh); 
         }
         //alert(' OpenForm no session isBotRefresh ' + this.isBotRefresh); 
    }
        
    closeForm() {
        console.log('Called Close Form');
        this.template.querySelector('div').style.display = "none";
        this.template.querySelector('button').style.display = "block";
        //alert( 'close' + this.isBotRefresh);
    }

    get fullUrl() {
        console.log('isProductionFlag: ' + this.isProduction);
        if(this.isProduction){
            if(this.isGuestUser){
                return this.fromsource = ndaChatBotURLForGuestProdLogin;
            }else {
               return this.fromsource === "No Source passed" ? ndaChatBotURL : ndaChatBotURLForSSO41;
            }
        }
        else{
            console.log('ndaChatBotURLSandbox: ' + ndaChatBotURLSandbox);
            console.log('ndaChatBotURLForSSO41Sandbox: ' + ndaChatBotURLForSSO41Sandbox);
            if(this.isGuestUser){
                //alert('you are here' + ndaChatBotURLForGuestLogin);
                return this.fromsource = ndaChatBotURLForGuestLogin;
            }else {
                //alert('Else' +  this.fromsource + ' ' + ndaChatBotURLSandbox + ' ' + ndaChatBotURLForSSO41Sandbox);
             return this.fromsource === "No Source passed" ? ndaChatBotURLSandbox : ndaChatBotURLForSSO41Sandbox;
            }
            //return this.fromsource;
        }
    }  
    connectedCallback(){
        console.log('connectedCallback');
        isProductionFlag()
        .then(result => {
            console.log('result: ' + result);
            //alert('production' + result);
            this.isProduction = result;
            this.error = undefined;
        })
        .catch(error => {
            this.error = error;
            this.isProduction = undefined;
        });
        isGuestUserFlag()
        .then(result => {
            console.log('result: ' + result);
            //alert('GuestUser' + result);
            this.isGuestUser = result;
            this.error = undefined;
        })
        .catch(error => {
            this.error = error;
            this.isGuestUser = undefined;
        });
        checkBotRefresh()
        .then(result => {
            console.log('result: ' + result);
            //alert('checkbot' + result);       
           if(sessionStorage.getItem('SessionId') == null)
           {
            this.isBotRefresh = false;
            sessionStorage.setItem('SessionId', result);
            //alert('Null Session ' + this.isBotRefresh);  
           }
           else{
            if(sessionStorage.getItem('SessionId') == result){
                this.isBotRefresh = false;
                //alert('EQUAL1 ' + sessionStorage.getItem('SessionId'));
                //alert('isBotRefresh ' + this.isBotRefresh); 
                
             }else{
                 sessionStorage.setItem('SessionId', result);
                 //alert('NOT EQUAL ' + sessionStorage.getItem('SessionId'));
                 this.isBotRefresh = false;
                 //alert('isBotRefresh ' + this.isBotRefresh); 
             }
           }        
            this.error = undefined;
        })
        .catch(error => {
            this.error = error;
            this.isBotRefresh = undefined;
            //alert('error');
        });
   }
}