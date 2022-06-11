import { LightningElement, track, wire, api } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import getDetails from '@salesforce/apex/NokiaCPQ_AccreditationExportController.getDetails';
import getAttachments from '@salesforce/apex/NokiaCPQ_AccreditationExportController.getAttachments';
import exportData from '@salesforce/apex/NokiaCPQ_AccreditationExportController.export';
import hasOEPPermission from '@salesforce/customPermission/OEP_Imp_Accreditation';
import strUserId from '@salesforce/user/Id';
import PROFILE_NAME_FIELD from '@salesforce/schema/User.Profile.Name';
import { getRecord } from 'lightning/uiRecordApi';

export default class NokiaCPQ_AccreditationExport extends LightningElement {

    @api accountId;
    @api portfolioList = [];
    @api attList = [];
    prfName;
    hasData = true;
    hasAttData = true;
    showSpinner = false;
    wiredDetail;
    wiredAttDetail;

    get isOEPUser() {
        return hasOEPPermission || this.prfName === 'System Administrator';
    }

    showToast(title, message, variant) {
        const childComponent = this.template.querySelector('c-nokia-c-p-q_notification');
        childComponent.showToast(title, message, variant);
    }
    resetMessage() {
        const childComponent = this.template.querySelector('c-nokia-c-p-q_notification');
        childComponent.resetMessage();
    }

    @wire(getRecord, {
        recordId: strUserId,
        fields: [PROFILE_NAME_FIELD]
    }) wireuser({
        error,
        data
    }) {
        if (data) {
            this.prfName = data.fields.Profile.value.fields.Name.value;
        }
    }

    @wire(getDetails, { accId: '$accountId' })
    getDetails(result) {
        this.showSpinner = true;
        this.wiredDetail = result;
        setTimeout(() => {
            if (result.data) {
                this.prepareExportData(result.data);
            } else if (result.error) {
                this.showSpinner = false;
                console.log('error: ', result.error);
                this.showToast('Error', 'Something went wrong. Please try again.', 'error');
            }
        }, 50);
    }

    prepareExportData(data) {
        let tempData = [];
        data.forEach(ele => {
            tempData.push({ portfolio: ele.portfolio, accrIds: ele.accrIds, ppcExport: ele.ppcExport, oepExport: ele.oepExport, attParentId: ele.attParentId, canExportOEP: ele.portfolio != 'All' });
        });
        this.portfolioList = tempData;
        //this.portfolioList = [...new Set(result.data)];
        if (this.portfolioList && this.portfolioList.length > 0) {
            this.hasData = true;
        } else {
            this.hasData = false;
        }
        this.showSpinner = false;
    }

    @wire(getAttachments, { accId: '$accountId' })
    getAttachments(result) {
        this.showSpinner = true;
        this.wiredAttDetail = result;
        setTimeout(() => {
            if (result.data) {
                this.attList = [...new Set(result.data)];
                if (this.attList && this.attList.length > 0) {
                    this.hasAttData = true;
                } else {
                    this.hasAttData = false;
                }
                this.showSpinner = false;
            } else if (result.error) {
                console.log('error: ', result.error);
                this.showToast('Error', 'Something went wrong. Please try again.', 'error');
            }
        }, 0);
    }

    onDownloadClick(event) {
        this.showSpinner = true;
        let href = event.target.dataset.href;
        setTimeout(() => {
            window.open(href, '_parent');
            this.showSpinner = false;
        },0);
    }

    onExportClick(event) {
        this.showSpinner = true;
        let dset = event.target.dataset;
        let url = dset.url;
        let accountId = this.accountId;
        let portfolio = dset.portfolio;
        setTimeout(() => {
            this.resetMessage();
            let oElement = this.portfolioList.find(x => x.portfolio == portfolio);
            let accr = oElement.accrIds;
            if (dset.attparentid) {
                window.open(url, '_parent');
            } else {
                exportData({ accrSet: accr, portfolio: portfolio, accountId: accountId })
                    .then(result => {
                        if (result) {
                            url = url + result;
                        }
                        window.open(url, '_parent');
                        return refreshApex(this.wiredDetail);
                    })
                    .catch((error) => {
                        console.log('onExportClick error-->' + error);
                        this.showSpinner = false;
                        this.showToast('Error', 'Something went wrong. Please try again.', 'error');
                    });
            }
        }, 0);
    }

    handleTabChange(event) {
        let value = event.target.value;
        this.showSpinner = true;
        setTimeout(() => {
            this.resetMessage();
            setTimeout(() => {
                this.showSpinner = false;
            }, 500);
            if (value == 'view') {
                return refreshApex(this.wiredAttDetail);
            } else {
                return refreshApex(this.wiredDetail);
            }
        }, 0);
    }

    close() {
        this.showSpinner = true;
        var origin = window.location.origin
        if (origin.indexOf("partners") >= 0) {//https://cpqperf-nokiapartners.cs196.force.com
            window.open(origin + '/s/account/' + this.accountId, '_parent');
        } else {
            window.open(origin + '/' + this.accountId, '_parent');
        }
    }

}