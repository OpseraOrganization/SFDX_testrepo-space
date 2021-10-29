import { LightningElement, wire, track } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import getSession from '@salesforce/apex/SPoG_ShowBannerInfoHelper.getSessionId';
import infoMessage from '@salesforce/label/c.SPoG_InfobannerMsg';
import infoLink from '@salesforce/label/c.SPoG_InfobannerLink';
import infoLinkName from '@salesforce/label/c.SPoG_InfobannerLinkName';

export default class SPoG_ShowBannerInfo extends LightningElement {
    @track showInfoMessage = false;
    SPoG_InfobannerMsg = infoMessage;
    linkName = infoLinkName;
    link = infoLink;
    @track baneerInfoFirst;
    @track bannerInfoSecond;

    _session;
    
    @wire(getSession) sessionDetial(response){
        
        let banners = this.SPoG_InfobannerMsg.split(this.linkName);
        this.baneerInfoFirst = banners[0];
        this.bannerInfoSecond = banners[1];

        this._session = response;
        if(response.data) {
            let cookie = decodeURIComponent(document.cookie).split(';');
            let sessionIdFound = false;
            for(let i=0; i< cookie.length ; i++) {
                let curItem = cookie[i];
                if(curItem.includes('showBanner=')) {
                    sessionIdFound = true;
                    let existSession = curItem.split('=')[1];
                    if(existSession === 'dfd4!74kljsd'+response.data+'incnjdhe474!sljfdi'){
                        this.showInfoMessage = false;
                    } else {
                        this.showInfoMessage = true;
                        document.cookie = 'showBanner='+'dfd4!74kljsd'+response.data+'incnjdhe474!sljfdi';
                    }
                    
                }
            }

            if(sessionIdFound === false) {
                this.showInfoMessage = true;
                document.cookie = 'showBanner='+'dfd4!74kljsd'+response.data+'incnjdhe474!sljfdi';
            }
        }
    } 


    closeBanner() {
        this.showInfoMessage = false;
        refreshApex(this._session);
    }
}