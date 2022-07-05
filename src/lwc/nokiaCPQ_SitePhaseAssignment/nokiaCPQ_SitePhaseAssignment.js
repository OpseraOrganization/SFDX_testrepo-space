import { LightningElement, track, wire, api } from 'lwc';
import { createRecord } from "lightning/uiRecordApi";
import getLineItems from '@salesforce/apex/NokiaCPQ_SitePhaseController.getLineItems';
import saveSitePhaseQuantity from '@salesforce/apex/NokiaCPQ_SitePhaseController.saveSitePhaseQuantityLineItem';
import saveSitePhaseConfiguration from '@salesforce/apex/NokiaCPQ_SitePhaseController.saveSitePhaseConfiguration';
import { refreshApex } from '@salesforce/apex';


const recordsPerPage = [10, 25, 50];
export default class NokiaCPQ_sitePhaseAssignment extends LightningElement {
    // Variable Section //
    parameters = {};
    lineItems = [];
    @track error = '';
    @track isSitesToUse = false;
    @track productList = [];
    @track siteNum = [];
    @track sitesList = [];
    @track phasesList = [];
    @track showPhaseFunctions = false;
    @track isOpenPhasesModal = false;
    @track arePhasesVisible = false;
    @track siteName = null;
    @track mapSites = new Map();
    @track mapPhases = new Map();
    @track tableSites = new Set();
    @track siteIds = new Set();
    @track tablePhases = new Set();
    @track siteSize = 0;
    @track colSpan = 1;
    @track colWidth = '100%';
    @track oppId = '';
    @api configId = '';
    @track mUpsertData = new Map();
    @track addSitePhaseDisabled = true;
    @track showSpinner = false;
    @track removedSites = [];
    @track addedSites = [];
    @track removedPhases = [];
    @track addedPhases = [];
    @track selectedSites = [];
    @track selectedPhases = [];
    @track sitesToUse = [];
    @track SHowNegVal = false;
    @track NegVal = [];
    mapNegativeSiteCheck = new Map();
    mapOriginalData = new Map();
    wiredLineItems;
    prodCode;
    prodDesc;
    prodName;
    @track showProdDetail = false;
    mProdDetail = new Map();
    @track productListWithPagination = [];
    @track hidePagination = false;
    @track pageLength = 25;
    @track page = 1;
    @track totalPages = 1;
    @api pageSizeOptions = recordsPerPage;
    @track disablePhases = false;
    @track oSelectedSites = [];
    @track oSelectedPhases = [];
    @track hasAggregation = false; // surinder ITPC:1125
    @track showDeltaOnlyFlagChecked = false; // suirnder
    nonZeroQtyLines = []; //surinder

    connectedCallback() {
        const dynamicCSS = document.createElement('style');
        dynamicCSS.innerText = `.slds-text-align_left input{text-align: left!important;} .slds-form-element__help{display : none !important;} input{ text-align: right!important; padding: 0px 5px !important; } .redFont input{color: red !important;} .blackFont input{color: black !important;} .blueFont input{color: blue !important; font-weight: bold;} `;
        dynamicCSS.innerText += ".dynamicheight{height:" + (parseFloat(window.innerHeight) - 250) + "px;}";
        document.body.appendChild(dynamicCSS);
    }

    // Event to go back to Cart
    handleGoBackClick(event) {
        if (confirm("Please Save and Validate before returning to Cart. Do you want to continue to return to Cart?")) {
            window.history.back();
        }
    }

    //#region Get and Prepare Line Item, sites and Phases Data STARTS
    // Get all lineItem Data//
    @wire(getLineItems, { prodConfigId: '$configId' })
    getLineItems(result) {
        this.showSpinner = true;
        this.wiredLineItems = result;
        this.page = 1;
        setTimeout(() => {
            let data = result.data;
            let error = result.error;
            if (data) {
                this.oppId = data.oppId;
                this.hasAggregation = data.hasAggregation;// surinder ITPC:1125
                /* ITCCPQ-666 - November Release(Enable phases for Partners) - Siva 
                this.disablePhases = data.quoteType && data.quoteType.indexOf('Indirect') >= 0;
                */
                let mSites = new Map(); // Map of SiteName => SiteObject
                let mPhases = new Map(); // Map of PhaseName => Phase Object
                console.log('data-->' + JSON.stringify(data));
                var dsite = data.sites ? [...new Set(data.sites)] : [];
                var dphase = data.phases ? [...new Set(data.phases)] : [];
                console.log('data-->' + JSON.stringify(data));
                console.log('dsite-->' + JSON.stringify(dsite));
                console.log('dphase-->' + JSON.stringify(dphase));
                //prepare sites/phases data for given Opportunity
                this.prepareSitePhase(dsite, dphase);
                //iterate over line item data and prepare original data as well as allocated sites/phases
                this.parseAllocatedSitePhase(data, mSites, mPhases);
                if (data.quoteUsesPhases && this.tablePhases && !this.tablePhases.has('Δ')) {
                    this.tablePhases.add('Δ');
                }
                //based on the allocated sites/phases,prepare a data for display
                this.prepareDataForDisplay(data, mSites, mPhases);
                //data for the first page
                //surinder
                if (this.showDeltaOnlyFlagChecked) {
                    this.nonZeroQtyLines = [];
                    this.productListWithPagination = [];
                    for (let lineItem of this.productList) {
                        for (let site of lineItem.sites) {
                            for (let phase of site.phases) {
                                console.log('phase=>' + JSON.stringify(phase));
                                if (phase.quantity != 0 && phase.phaseName == 'Δ') {
                                    this.nonZeroQtyLines.push(lineItem);
                                }
                            }
                        }
                    }

                    // this.productListWithPagination =  this.nonZeroQtyLines;                    
                    if (this.nonZeroQtyLines.length > 0) {
                        this.totalPages = (((this.nonZeroQtyLines.length / this.pageLength) - ((this.nonZeroQtyLines.length % this.pageLength) / this.pageLength)) + (((this.nonZeroQtyLines.length % this.pageLength) === 0) ? 0 : 1));
                        let length = (this.nonZeroQtyLines.length < this.pageLength) ? this.nonZeroQtyLines.length : this.pageLength;
                        for (let i = 0; i < length; i++) {
                            this.productListWithPagination.push(this.nonZeroQtyLines[i]);
                        }
                    }
                } else {  // changes end
                    //determine total available pages for the pagination
                    if (this.productList.length > 0) {
                        this.totalPages = (((this.productList.length / this.pageLength) - ((this.productList.length % this.pageLength) / this.pageLength)) + (((this.productList.length % this.pageLength) === 0) ? 0 : 1));
                    }
                    let length = (this.productList.length < this.pageLength) ? this.productList.length : this.pageLength;
                    for (let i = 0; i < length; i++) {
                        this.productListWithPagination.push(this.productList[i]);
                    }
                }
                this.siteSize = this.tableSites.size;
                this.colSpan = this.tablePhases.size + 1;
                this.colWidth = 100 / this.colSpan + '%';
                //if site order is defined, sort the sites accordingly
                var hasSiteOrder = data.siteOrder && data.siteOrder.length > 0;
                var hasPhaseOrder = data.phaseOrder && data.phaseOrder.length > 0;
                if (!(this.selectedSites && this.selectedSites.length > 0)) {
                    if (hasSiteOrder && data.siteOrder.length >= (this.tableSites.size - 1)) {
                        data.siteOrder.forEach(e => {
                            var site = this.sitesList.find((item) => item.id == e);
                            if (site && this.tableSites.has(site.name)) {
                                this.selectedSites.push(e);
                            }
                        });
                        //this.selectedSites = data.siteOrder;
                    }
                    else if (dsite && dsite.length > 0 && this.tableSites && this.tableSites.size > 0) {
                        dsite.forEach(element => {
                            if (this.tableSites.has(element.name)) {
                                this.selectedSites.push(element.id);
                            }
                        });
                    }
                }
                //if phase order is defined, sort the phases accordingly
                if (!(this.selectedPhases && this.selectedPhases.length > 0)) {
                    if (hasPhaseOrder && data.phaseOrder.length >= (this.tablePhases.size - 1)) {
                        data.phaseOrder.forEach(e => {
                            var phase = this.phasesList.find((item) => item.id == e);
                            if (phase && this.tablePhases.has(phase.name)) {
                                this.selectedPhases.push(e);
                            }
                        });
                        //this.selectedPhases = data.phaseOrder;
                    }
                    else if (dphase && dphase.length > 0 && this.tablePhases && this.tablePhases.size > 0) {
                        dphase.forEach(element => {
                            if (this.tablePhases.has(element.name)) {
                                this.selectedPhases.push(element.id);
                            }
                        });
                    }
                }

                this.showPhaseFunctions = this.tablePhases.size > 0;
                this.arePhasesVisible = this.tablePhases.size > 0;
                this.error = undefined;
                this.sortData();
                this.oSelectedSites = [...this.selectedSites];
                this.oSelectedPhases = [...this.selectedPhases];
            } else if (error) {
                this.error = error;
            }
            this.showSpinner = false;
        }, 0);
    }

    prepareSitePhase(dsite, dphase) {
        if (dsite && dsite.length > 0) {
            //sort the sites according the alphabetical order
            dsite.sort((st1, st2) => {
                return st1.name.localeCompare(st2.name);
            });
            //Create Map of Names and Id as well as the list of available sites
            dsite.forEach(element => {
                this.mapSites.set(element.name, element.id);
                this.sitesList.push({ 'id': element.id, 'name': element.name, 'value': element.id, 'label': element.name });
            });
        }

        if (dphase && dphase.length > 0) {
            //sort the phases according the alphabetical order
            dphase.sort((ph1, ph2) => {
                return ph1.name.localeCompare(ph2.name);
            });
            //Create Map of Names and Id as well as the list of available phases
            dphase.forEach(element => {
                this.mapPhases.set(element.name, element.id);
                this.phasesList.push({ 'id': element.id, 'name': element.name, 'value': element.id, 'label': element.name });
            });
        }
    }

    parseAllocatedSitePhase(data, mSites, mPhases) {
        for (let lineItem of data.lines) {
            for (let site of lineItem.sites) {
                //contains all the allocated sites
                this.tableSites.add(site.siteName);
                //contains mapping of sites with line item
                mSites.set(site.siteName + lineItem.lineItemId, site);
                //prepare a Map of quantity allocation at site level in case we are not using phases so we can determine the changes on SAVE
                if (!data.quoteUsesPhases) {
                    this.mapOriginalData.set(site.recordId, site.quantity);
                }
                if (site.phases) {
                    for (let phase of site.phases) {
                        if (phase.phaseName == 'delta') {
                            if (phase.recordId) {
                                //prepare a Map of quantity allocation at phase level in case we are not using phases so we can determine the changes on SAVE
                                this.mapOriginalData.set(phase.recordId, phase.quantity);
                            }
                            //contains all the allocated phases
                            this.tablePhases.add('Δ');
                            //contains mapping of sites & phases with line item
                            mPhases.set('Δ' + site.siteName + lineItem.lineItemId, phase);
                        }
                        else {
                            //prepare a Map of quantity allocation at phase level in case we are not using phases so we can determine the changes on SAVE
                            this.mapOriginalData.set(phase.recordId, phase.quantity);
                            this.tablePhases.add(phase.phaseName);
                            mPhases.set(phase.phaseName + site.siteName + lineItem.lineItemId, phase);
                        }
                    }
                }
            }
        }
    }

    prepareDataForDisplay(data, mSites, mPhases) {
        let dataTable = [];
        for (let lineItem of data.lines) {
            let allocatedQty = 0;
            let lineQty = lineItem.quantity;
            let row = {};
            row.lineItemId = lineItem.lineItemId;
            row.prodId = lineItem.prodId;
            row.productName = lineItem.productName;

            //row.productCode = lineItem.productCode;
            // row.URL = "/" + lineItem.prodId;
            let prod = {};
            prod.productName = lineItem.productName;
            prod.productCode = lineItem.productCode;
            prod.productDesc = lineItem.productDesc;
            prod.alias = lineItem.alias;
            this.mProdDetail.set(lineItem.prodId, prod);
            row.quantity = lineItem.quantity;
            row.spares = lineItem.spares;
            row.alias = lineItem.alias;
            let lSites = [];
            //based on the maps created before about site/phase mapping with line item, prepare the data to display according to the quantity allocated each site/phase level for a Line item
            allocatedQty = this.prepareSitePhaseForDisplay(lineItem, mSites, mPhases, lSites);
            //in case there is a difference between allocated quantity and line quantity, difference will be added under "No Site Assigned" and "Δ" in case we are using Phases
            if (allocatedQty != lineQty) {
                this.assignQtyDifference((lineQty - allocatedQty), lSites, data, lineItem);
            }
            row.sites = lSites;
            dataTable.push(row);
        }
        // DATA TRANSFORMATION ENDS///////////////////////////////
        this.productList = dataTable;
    }

    prepareSitePhaseForDisplay(lineItem, mSites, mPhases, lSites) {
        let allocatedQty = 0;
        for (let strSite of this.tableSites) {
            let lPhases = [];
            let site = {};
            let lineItemId = lineItem.lineItemId;
            let objSite = mSites.get(strSite + lineItemId);
            let siteId = this.mapSites.get(strSite);
            let recordId = '';
            //if for a given line, no quantity is assigned to the site then default it with 0 else assign allocated quantity 
            if (objSite) {
                site['quantity'] = objSite.quantity;
                recordId = objSite.recordId;
                allocatedQty += Number(objSite.quantity);
            }
            else {
                site['quantity'] = 0;
            }
            //"No Site Assigned" is always disabled
            //surinder - ITPC 1125
            if (strSite == 'No Site Assigned' || this.hasAggregation) {
                site['disable'] = true;
            }
            site['recordId'] = recordId;
            site['siteId'] = siteId;
            site['id'] = lineItemId + '~' + strSite + '~' + siteId + '~' + recordId;
            site['siteName'] = strSite;
            //If we have phases, then allocate quantities at phase level for each line-site combination
            if (this.tablePhases) {
                for (let strPhases of this.tablePhases) {
                    let phase = {};
                    let objPhase = mPhases.get(strPhases + strSite + lineItemId);
                    let phaseId = this.mapPhases.get(strPhases);
                    let recordId;
                    if (objPhase) {
                        phase['quantity'] = objPhase.quantity;
                        phase['recordId'] = objPhase.recordId;
                        recordId = objPhase.recordId;
                        if (objPhase.quantity != 0 && strPhases == 'Δ') {
                            phase['class'] = 'redFont';
                        }
                    }
                    else {
                        phase['quantity'] = 0;
                        if (strPhases == 'Δ' && mPhases.size == 0 && objSite) {
                            phase['quantity'] = objSite.quantity;
                            phase['recordId'] = objSite.recordId;
                            if (objSite.quantity != 0) {
                                phase['class'] = 'redFont';
                            }
                        }
                    }
                    //surinder - ITPC 1125
                    if (strPhases == 'Δ' || this.hasAggregation) {
                        phase['disable'] = true;
                    }
                    phase['id'] = lineItemId + '~' + strSite + '~' + siteId + '~' + strPhases + '~' + phaseId + '~' + recordId;
                    phase['phaseId'] = phaseId;
                    phase['siteId'] = siteId;
                    phase['phaseName'] = strPhases;
                    phase['siteName'] = strSite;
                    lPhases.push(phase);
                }
            }
            if (lPhases) {
                site.phases = lPhases;
            }
            lSites.push(site);
        }
        return allocatedQty;
    }

    assignQtyDifference(diff, lSites, data, lineItem) {
        //let diff = lineQty - allocatedQty;
        //If "No Site Assigned" is there for a given line item then add a difference under it else add it and allocate
        let arrSite = lSites.filter(item => item.siteName == 'No Site Assigned');
        if (arrSite && arrSite.length > 0) {
            let nsa = arrSite[0];
            nsa.quantity += diff;
            if (nsa.quantity != 0) {
                nsa.class = 'blueFont';
            }
            //If we are using Phases and "No Site Assigned" has "Δ" for a given line item then add a difference under it else add it and allocate
            if (data.quoteUsesPhases) {
                if (nsa.phases && nsa.phases.length > 0) {
                    let arrPhases = nsa.phases.filter(item => item.phaseName == 'Δ');
                    if (arrPhases && arrPhases.length > 0) {
                        let deltaPhase = arrPhases[0];
                        deltaPhase.quantity += diff;
                        if (deltaPhase.quantity != 0) {
                            deltaPhase.class = 'blueFont';
                        }
                    } else {
                        let phase = {};
                        phase['quantity'] = diff;
                        if (diff != 0) {
                            phase.class = 'blueFont';
                        }
                        phase['disable'] = true;
                        phase['id'] = lineItem.lineItemId + '~No Site Assigned~' + undefined + '~Δ~' + undefined + '~' + undefined;
                        phase['phaseId'] = undefined;
                        phase['siteId'] = undefined;
                        phase['phaseName'] = 'Δ';
                        phase['siteName'] = 'No Site Assigned';
                        nsa.phases.push(phase);
                    }
                }
            }
        } else {
            let site = {};
            let lPhases = [];
            site['quantity'] = diff;
            if (diff != 0) {
                site.class = 'blueFont';
            }
            site['disable'] = true;
            site['recordId'] = undefined;
            site['siteId'] = undefined;
            site['id'] = lineItem.lineItemId + '~No Site Assigned~' + undefined + '~' + undefined;
            site['siteName'] = 'No Site Assigned';
            if (data.quoteUsesPhases && this.tablePhases) {
                for (let strPhases of this.tablePhases) {
                    let phase = {};
                    let phaseId = this.mapPhases.get(strPhases);
                    phase['quantity'] = 0;
                    if (strPhases == 'Δ') {
                        phase['disable'] = true;
                        phase['quantity'] = diff;
                        if (diff != 0) {
                            site.class = 'blueFont';
                        }
                    }
                    phase['id'] = lineItem.lineItemId + '~No Site Assigned~' + undefined + '~' + strPhases + '~' + phaseId + '~' + undefined;
                    phase['phaseId'] = phaseId;
                    phase['siteId'] = undefined;
                    phase['phaseName'] = strPhases;
                    phase['siteName'] = 'No Site Assigned';
                    lPhases.push(phase);

                }
                site.phases = lPhases;
            }
            lSites.push(site);
            this.tableSites.add('No Site Assigned');
        }
    }
    //#region Get and Prepare Line Item, sites and Phases Data ENDS
    //#region Pagination STARTS
    // Calculate Page Size and render table
    pageLengthChange(event) {
        this.showSpinner = true;
        this.pageLength = event.target.value;
        //added by Surinder.
        let pList = this.showDeltaOnlyFlagChecked ? this.nonZeroQtyLines : this.productList;
        setTimeout(() => {
            let results = [];
            this.totalPages = (((pList.length / this.pageLength) - ((pList.length % this.pageLength) / this.pageLength)) + (((pList.length % this.pageLength) === 0) ? 0 : 1));

            if (this.page > this.totalPages) {
                this.page -= (this.page - this.totalPages);
            }
            for (let i = 0; i < this.pageLength; i++) {
                if ((i + ((this.page - 1) * this.pageLength)) < pList.length) {
                    results.push(pList[i + ((this.page - 1) * this.pageLength)]);
                }
            }
            this.productListWithPagination = results;
            this.showSpinner = false;
        }, 0);

    }
    // To go to next page and re-render table
    nextpage() {
        let results = [];
        this.showSpinner = true;
        //added by Surinder.
        let pList = this.showDeltaOnlyFlagChecked ? this.nonZeroQtyLines : this.productList;
        setTimeout(() => {
            if (this.page < (((pList.length / this.pageLength) - ((pList.length % this.pageLength) / this.pageLength)) + (((pList.length % this.pageLength) === 0) ? 0 : 1))) {
                this.page = this.page + 1;
                for (let i = 0; i < this.pageLength; i++) {
                    if ((i + ((this.page - 1) * this.pageLength)) < pList.length) {
                        results.push(pList[i + ((this.page - 1) * this.pageLength)]);
                    }
                }
                this.productListWithPagination = results;
            }
            this.showSpinner = false;
        }, 0);
    }
    // To go to previous page and re-render table
    prevpage() {
        let results = [];
        this.showSpinner = true;
        let pList = this.showDeltaOnlyFlagChecked ? this.nonZeroQtyLines : this.productList;
        //added by Surinder.         
        this.showSpinner = true;
        setTimeout(() => {
            if (this.page > 1) {
                this.page = this.page - 1;
                for (let i = 0; i < this.pageLength; i++) {
                    if ((i + ((this.page - 1) * this.pageLength)) < pList.length) {
                        results.push(pList[i + ((this.page - 1) * this.pageLength)]);
                    }
                }
                this.productListWithPagination = results;
                this.backUpProductList = results;
            }
            this.showSpinner = false;
        }, 0);
    }
    //#region Pagination ENDS

    //#region Quantity Updates STARTS
    // When Site Level Quantity is change, update related data
    onChangeSiteQuantity(event) {
        let quantity = event.target.value;
        let key = event.target.dataset.label;
        let arrUpdateSite = key.split('~');
        let obj = {};
        if (quantity < 0) {
            event.target.className = 'fontRed';
        }
        else {
            if (quantity.length > 18) {
                quantity = quantity.substring(0, 18);
                event.target.value = quantity;
            }
            event.target.className = 'fontBlack';
        }
        obj.quantity = quantity;
        obj.lineItemId = arrUpdateSite[0];
        obj.siteName = arrUpdateSite[1];
        obj.siteId = arrUpdateSite[2];
        if (arrUpdateSite[3])
            obj.recordId = arrUpdateSite[3];
        this.onSiteChangeHandler(obj);
        console.log('productListWithPagination-->' + JSON.stringify(this.productListWithPagination));
        this.mUpsertData.set(key, obj);
    }
    // When Site Level Quantity is change, update related data (Handler Function called from onSiteChange)
    onSiteChangeHandler(updated_site) {
        let updatedQuantity = 0;
        for (let lineItem of this.productList) {
            for (let site of lineItem.sites) {
                if (updated_site.lineItemId == lineItem.lineItemId && updated_site.siteName == site.siteName) {
                    site.quantity = updated_site.quantity;
                }
                let siteQuantity = 0;
                if (site.siteName != 'No Site Assigned' && updated_site.lineItemId == lineItem.lineItemId) {
                    if (site.quantity) {
                        siteQuantity = Number(site.quantity)
                    }
                    updatedQuantity = siteQuantity + Number(updatedQuantity);
                }
            }
        }
        for (let lineItem of this.productList) {
            for (let site of lineItem.sites) {
                if (updated_site.lineItemId == lineItem.lineItemId && site.siteName == 'No Site Assigned') {
                    site.quantity = Number(lineItem.quantity) - Number(updatedQuantity);
                    if (site.quantity < 0) {
                        site.class = 'redFont';
                    }
                    else {
                        site.class = 'blackFont';
                    }
                    if (site.phases != undefined && site.phases != null && site.phases.length > 0) {
                        let updateDeltaQuantity = 0;
                        for (let phase of site.phases) {
                            if (updated_site.lineItemId == lineItem.lineItemId && 'No Site Assigned' == site.siteName && 'Δ' != phase.phaseName) {
                                updateDeltaQuantity = Number(phase.quantity) + Number(updateDeltaQuantity);
                            }
                        }
                        for (let phase of site.phases) {
                            if (updated_site.lineItemId == lineItem.lineItemId && 'No Site Assigned' == site.siteName && 'Δ' == phase.phaseName) {
                                phase.quantity = Number(site.quantity) - updateDeltaQuantity;
                                if (phase.quantity != 0) {
                                    phase.class = 'redFont';
                                }
                                else {
                                    phase.class = 'blackFont';
                                }
                            }
                        }
                    }
                }

                //// Logic to Reset Delta in case of Site Quantity gets changed ////-----------------------------------------------------
                if (site.phases != undefined && site.phases != null && site.phases.length > 0) {
                    let updateDeltaQuantity = 0;
                    for (let phase of site.phases) {
                        if (updated_site.lineItemId == lineItem.lineItemId && updated_site.siteName == site.siteName && 'Δ' != phase.phaseName) {
                            updateDeltaQuantity = Number(phase.quantity) + Number(updateDeltaQuantity);
                        }
                    }
                    for (let phase of site.phases) {
                        if (updated_site.lineItemId == lineItem.lineItemId && updated_site.siteName == site.siteName && 'Δ' == phase.phaseName) {
                            phase.quantity = Number(updated_site.quantity) - updateDeltaQuantity;
                            if (phase.quantity != 0) {
                                phase.class = 'redFont';
                            }
                            else {
                                phase.class = 'blackFont';
                            }
                        }
                    }
                }
            }
        }
    }

    // When Phase Level Quantity is change, update related data
    onChangePhaseQuantity(event) {
        let quantity = event.target.value;
        let key = event.target.name;
        let arrUpdatedPhase = key.split('~');
        let obj = {};
        if (quantity < 0) {
            event.target.className = 'fontRed';
        }
        else {
            if (quantity.length > 18) {
                quantity = quantity.substring(0, 18);
                event.target.value = quantity;
            }
            event.target.className = 'fontBlack';
        }
        obj.quantity = quantity;
        obj.lineItemId = arrUpdatedPhase[0];
        obj.siteName = arrUpdatedPhase[1];
        obj.siteId = arrUpdatedPhase[2];
        obj.phaseName = arrUpdatedPhase[3];
        obj.phaseId = arrUpdatedPhase[4];
        if (arrUpdatedPhase[5])
            obj.recordId = arrUpdatedPhase[5];
        this.onPhaseChangeHandler(obj);
        this.mUpsertData.set(key, obj);
    }
    // When Phase Level Quantity is change, update related data (Handler Function called from onPhaseChange)
    onPhaseChangeHandler(updated_phase) {
        let updatedQuantity = 0;
        for (let lineItem of this.productList) {
            for (let site of lineItem.sites) {
                for (let phase of site.phases) {
                    if (updated_phase.lineItemId == lineItem.lineItemId && updated_phase.siteName == phase.siteName && updated_phase.phaseName == phase.phaseName) {
                        phase.quantity = updated_phase.quantity;
                    }
                    let phaseQuantity = 0;
                    if ('Δ' != phase.phaseName && updated_phase.lineItemId == lineItem.lineItemId && updated_phase.siteName == phase.siteName) {
                        if (phase.quantity) {
                            phaseQuantity = Number(phase.quantity)
                        }
                        updatedQuantity = phaseQuantity + updatedQuantity;
                    }
                }
            }
        }
        for (let lineItem of this.productList) {
            for (let site of lineItem.sites) {
                for (let phase of site.phases) {
                    if (updated_phase.lineItemId == lineItem.lineItemId && updated_phase.siteName == site.siteName && 'Δ' == phase.phaseName) {
                        phase.quantity = Number(site.quantity) - Number(updatedQuantity);
                        if (phase.quantity != 0) {
                            phase.class = 'redFont';
                        }
                        else {
                            phase.class = 'blackFont';
                        }
                    }
                }
            }
        }
    }
    //#region Quantity Updates ENDS

    // When Site is selected, update the table
    onselectSite(event) {
        let selectedSite = event.detail.value;
        this.selectedSites = selectedSite;
        this.sitesList.sort((st1, st2) => {
            return st1.name.localeCompare(st2.name);
        });
    }
    // When Phase is selected, update the table
    onselectPhase(event) {
        let selectedPhase = event.detail.value;
        this.selectedPhases = selectedPhase;
        this.phasesList.sort((st1, st2) => {
            return st1.name.localeCompare(st2.name);
        });
    }

    //#region Submit Site/Phase Data STARTS
    // Submit Data - This method will call main save logic and refresh data
    submitDetails(event) {
        if ((event.target.name == 'submitSites' && !this.siteUpdateCheck()) || (event.target.name == 'submitPhases' && !this.phaseUpdateCheck())) {
            return false;
        }
        this.showSpinner = true;
        setTimeout(() => {
            this.refreshData();
            if (!this.tablePhases || this.tablePhases.size == 0) {
                this.arePhasesVisible = false;
                this.quoteUsesPhases = false;
            }
            this.isSitesToUse = false;
            this.isOpenPhasesModal = false;
            this.addSitePhaseDisabled = true;
            let inputCmp = this.template.querySelectorAll("lightning-input[name=input1]");
            if (inputCmp) {
                inputCmp.forEach(function (element) {
                    element.value = '';
                }, this);
            }
            this.removedSites = [];
            this.addedSites = [];
            this.removedPhases = [];
            this.addedPhases = [];
            this.showSpinner = false;
        }, 0);
        this.oSelectedSites = [...this.selectedSites];
        this.oSelectedPhases = [...this.selectedPhases];
    }

    siteUpdateCheck() {
        var rNames = '';
        this.removedSites = [];
        this.addedSites = [];
        if (this.oSelectedSites && this.oSelectedSites.length > 0) {
            this.oSelectedSites.forEach(element => {
                if (!this.selectedSites.some(site => site == element)) {
                    var siteVal = this.sitesList.find(x => x.id === element);
                    this.removedSites.push({ 'siteId': siteVal.id, 'siteName': siteVal.name });
                    rNames += siteVal.name + ',';
                }
            });
            this.selectedSites.forEach(element => {
                if (!this.oSelectedSites.some(site => site == element)) {
                    var siteVal = this.sitesList.find(x => x.id === element);
                    this.addedSites.push({ 'siteId': siteVal.id, 'siteName': siteVal.name });
                }
            });
        } else {

            this.selectedSites.forEach(element => {
                var siteVal = this.sitesList.find(x => x.id === element);
                this.addedSites.push({ 'siteId': siteVal.id, 'siteName': siteVal.name });
            });
        }
        if (this.removedSites.length > 0) {
            return window.confirm('You have chosen to unselect below Sites: \n' + rNames.slice(0, -1) + '\nAny quantities allocated will be removed. Do you want to continue?');
        }
        return true;
    }

    phaseUpdateCheck() {
        var rNames = '';
        this.removedPhases = [];
        this.addedPhases = [];
        if (this.oSelectedPhases && this.oSelectedPhases.length > 0) {
            this.oSelectedPhases.forEach(element => {
                if (!this.selectedPhases.some(phase => phase == element)) {
                    var phaseVal = this.phasesList.find(x => x.id === element);
                    this.removedPhases.push({ 'phaseId': phaseVal.id, 'phaseName': phaseVal.name });
                    rNames += phaseVal.name + ',';
                }
            });
            this.selectedPhases.forEach(element => {
                if (!this.oSelectedPhases.some(phase => phase == element)) {
                    var phaseVal = this.phasesList.find(x => x.id === element);
                    this.addedPhases.push({ 'phaseId': phaseVal.id, 'phaseName': phaseVal.name });
                }
            });
        } else {
            this.selectedPhases.forEach(element => {
                var phaseVal = this.phasesList.find(x => x.id === element);
                this.addedPhases.push({ 'phaseId': phaseVal.id, 'phaseName': phaseVal.name });
            });
        }
        if (this.removedPhases.length > 0) {
            return window.confirm('You have chosen to unselect below Phases: \n' + rNames.slice(0, -1) + '\nAny quantities allocated will be removed. Do you want to continue?');
        }
        return true;
    }

    // Logic to reset the vairable and rebind data table
    refreshData() {
        let isSiteAdded = this.addedSites && this.addedSites.length > 0;
        let isSiteRemoved = this.removedSites && this.removedSites.length > 0;
        let isPhaseAdded = this.addedPhases && this.addedPhases.length > 0;
        let isPhaseRemoved = this.removedPhases && this.removedPhases.length > 0;

        // LOGIC FOR SITE ---------------------------------------------------------------
        if (isSiteAdded || isSiteRemoved) {
            this.productList.forEach(prodItem => {
                if (isSiteAdded) {
                    this.siteAddedHandler(prodItem);
                }
                if (isSiteRemoved) {
                    this.siteRemovedHandler(prodItem);
                }
            });
        }
        // LOGIC FOR PHASE ---------------------------------------------------------------
        if (isPhaseAdded || isPhaseRemoved) {
            this.productList.forEach(prodItem => { // This is for Product
                for (let i = 0; i < prodItem.sites.length; i++) {
                    let site = null;
                    if (prodItem.sites[i]) {
                        site = prodItem.sites[i];
                    }
                    if (isPhaseAdded) {
                        this.phaseAddedHandler(prodItem, site);

                    } if (isPhaseRemoved) {
                        this.phaseRemoveHandler(prodItem, site)
                    }
                }
            });
        }
        this.siteSize = this.tableSites.size;
        this.colSpan = this.tablePhases.size + 1;
        this.colWidth = 100 / this.colSpan + '%';
        this.sortData();
    }
    // When New Site is added, update the calculation on Quantiity
    siteAddedHandler(prodItem) {
        for (let j = 0; j < this.addedSites.length; j++) {
            let st = this.addedSites[j];
            let site = {};
            site['id'] = prodItem.lineItemId + '~' + st.siteName + '~' + st.siteId;
            site['siteName'] = st.siteName;
            site['siteId'] = st.siteId;
            site['quantity'] = 0;
            if (this.showPhaseFunctions && this.tablePhases.size > 0) {
                let lPhases = [];
                for (let strPhaseName of this.tablePhases) {
                    let objphases = {};
                    objphases['siteId'] = st.siteId;
                    objphases['siteName'] = st.siteName;
                    objphases['disable'] = strPhaseName == 'Δ' ? true : false;
                    if (strPhaseName == 'Δ') {
                        objphases['quantity'] = st.quantity ? st.quantity : 0;
                    }
                    else {
                        objphases['quantity'] = 0;
                    }
                    objphases['phaseName'] = strPhaseName;
                    objphases['recordId'] = null;
                    objphases['phaseId'] = this.mapPhases.get(strPhaseName);
                    objphases['id'] = prodItem.lineItemId + '~' + st.siteName + '~' + st.siteId + '~' + strPhaseName + '~' + this.mapPhases.get(strPhaseName) + '~new~';
                    lPhases.push(objphases);
                }
                site.phases = lPhases;
            }
            prodItem.sites.push(site);
        }
    }
    // When  Site is removed, update the calculation on Quantiity
    siteRemovedHandler(prodItem) {
        let deleteQuantity = 0;
        for (let removedSite of this.removedSites) {
            let i = 0;
            for (let site of prodItem.sites) {
                if (site.siteId == removedSite.siteId) {
                    deleteQuantity = Number(site.quantity) + deleteQuantity;
                    prodItem.sites.splice(i, 1);
                }
                i = i + 1;
            }
        }
        if (deleteQuantity != 0) {
            for (let site of prodItem.sites) {
                if (site.siteName == 'No Site Assigned') {
                    site.quantity = deleteQuantity + Number(site.quantity);
                    if (site.phases) {//add deleted quantity to delta as well if phases
                        for (let phase of site.phases) {
                            if (phase.phaseName == 'Δ') {
                                phase.quantity = deleteQuantity + Number(phase.quantity);
                                phase.class = 'redFont';
                            }
                        }
                    }
                }
            }
        }
    }
    // When New Phase is added, update the calculation on Quantiity
    phaseAddedHandler(prodItem, site) {
        for (let j = 0; j < this.addedPhases.length; j++) {
            let ph = this.addedPhases[j];
            if (!site.phases || site.phases.length == 0) {
                site.phases = [];
                let objphases = {};
                objphases['siteId'] = site.siteId;
                objphases['siteName'] = site.siteName;
                objphases['disable'] = true;
                objphases['quantity'] = site.quantity;
                objphases['phaseName'] = 'Δ';
                objphases['recordId'] = site.recordId ? site.recordId : null;
                objphases['phaseId'] = null;
                if (site.quantity != 0) {
                    objphases['class'] = 'redFont';
                }
                objphases['id'] = prodItem.lineItemId + '~' + site.siteName + '~' + site.siteId + '~Δ' + '~Delta' + ' ~ ';
                if (this.tablePhases.size == 0) {
                    this.tablePhases.add('Δ');
                }
                site.phases.push(objphases);
            }
            this.tablePhases.add(ph.phaseName);
            let objphases = {};
            objphases['siteId'] = site.siteId;
            objphases['siteName'] = site.siteName;
            objphases['quantity'] = 0;
            objphases['phaseName'] = ph.phaseName;
            objphases['recordId'] = null;
            objphases['phaseId'] = ph.phaseId;
            objphases['id'] = prodItem.lineItemId + '~' + site.siteName + '~' + site.siteId + '~' + ph.phaseName + '~' + ph.phaseId + '~ ';
            site.phases.push(objphases);
        }
    }
    // When Phase is removed, update the calculation on Quantiity
    phaseRemoveHandler(prodItem, site) {
        for (let removedPhase of this.removedPhases) {
            if (site.phases != null && site.phases.length > 0) {
                let removedQuantity = 0;
                let i = 0;
                for (let phase of site.phases) {
                    if (phase.phaseName == removedPhase.phaseName) {
                        removedQuantity = Number(phase.quantity) + Number(removedQuantity);
                        site.phases.splice(i, 1);
                        if (site.phases.length == 1 && site.phases[0].phaseName == 'Δ') {
                            site.phases.splice(0, 1);
                        }
                    }
                    i = i + 1;
                }
                if (!(this.selectedPhases && this.selectedPhases.length > 0)) {
                    this.showPhaseFunctions = false;
                    this.arePhasesVisible = false;
                }
                if (removedQuantity != 0 && site.phases.length > 0) {
                    for (let phase of site.phases) {
                        if (phase.phaseName == 'Δ') {
                            phase.quantity += removedQuantity;
                            phase.class = 'redFont';
                        }
                    }
                }
            }
        }
    }
    //#region Submit Site/Phase Data ENDS

    // Sort Site and Phase List  
    sortData() {
        this.tableSites.clear();
        this.tableSites.add('No Site Assigned');
        this.selectedSites.forEach(e => {
            console.log('sortData-->' + e);
            var site = this.sitesList.find((item) => item.id == e);
            console.log('sortData-->' + site);
            this.tableSites.add(site.name);
        });

        this.tablePhases.clear();
        if (this.showPhaseFunctions && this.selectedPhases && this.selectedPhases.length > 0) {
            this.tablePhases.clear();
            this.tablePhases.add('Δ');
            this.selectedPhases.forEach(e => {
                console.log('sortData-->' + e);
                var phase = this.phasesList.find((item) => item.id == e);
                console.log('sortData-->' + phase);
                this.tablePhases.add(phase.name);
            });
        }

        this.productList.forEach(prodItem => {
            let sites = [];
            this.tableSites.forEach((siteName) => {
                for (let site of prodItem.sites) {
                    if (siteName == site.siteName) {
                        sites.push(site);
                        if (site.phases) {
                            let phases = [];
                            this.tablePhases.forEach((phaseName) => {
                                for (let phase of site.phases) {
                                    if (phase.phaseName == phaseName) {
                                        phases.push(phase);
                                    }
                                }
                            });
                            site.phases = phases;
                        }
                    }
                }
            });
            prodItem.sites = sites;
        });
    }

    //#region Save STARTS
    //// LOGIC TO SAVE DATA ////////////////////////////////////
    onSave(event) {
        this.resetMessage();
        this.showSpinner = true;
        let isValidate = event.target.label != 'Save';
        let listUpsert = [];
        let listDelete = [];
        let mSet = new Set();
        let sDeltaCheck = new Set();//set to store -ve delta	
        let sSiteQtyCheck = new Set();//set to store -ve site quantity	
        let sPhaseQtyCheck = new Set();//set to store -ve phase quantity
        let sSiteQtyZeroCheck = new Set();//set to store 0 site quantity
        let sTotalQtyCheck = new Set();//set to store Total allocation for each line	
        let mSiteQty = new Map();//set to store Total allocation for each line	
        let mPhaseQty = new Map();//set to store Total allocation for each line
        let sDeltaValidate = new Set();
        let hasPhases = this.showPhaseFunctions;
        let siteOrder = {};
        let phaseOrder = {};

        let validatePhase = false;
        if (this.mapOriginalData && this.mapOriginalData.size > 0) {
            validatePhase = this.prepareDataForUpdate(sTotalQtyCheck, mSiteQty, hasPhases, validatePhase, sDeltaValidate, sDeltaCheck, sPhaseQtyCheck, mPhaseQty, mSet, listUpsert, sSiteQtyCheck, sSiteQtyZeroCheck, listDelete);
        } else {
            validatePhase = this.prepareDataForInsert(sTotalQtyCheck, mSiteQty, hasPhases, validatePhase, sDeltaValidate, sDeltaCheck, sPhaseQtyCheck, mPhaseQty, listUpsert, sSiteQtyCheck, sSiteQtyZeroCheck);
        }
        let quoteUsesPhases = false;
        for (let [key, value] of mPhaseQty) {
            if (value != 0 && key != 'Δ') {
                quoteUsesPhases = true;
            }
        }
        let anySave = listDelete.length > 0;
        //check if no site and no phases
        anySave = this.checkForAnyUpdate(anySave, mSiteQty, quoteUsesPhases, listUpsert, listDelete);

        this.checkSitePhaseOrder(siteOrder, phaseOrder, mSiteQty, mPhaseQty);
        // if (Object.keys(siteOrder).length > 0 || Object.keys(phaseOrder).length > 0) {
        //     for (let [key, value] of mSiteQty) {
        //         if (key != 'No Site Assigned' && value == 0) {
        //             var siteVal = this.sitesList.find(site => site.name == key);
        //             if (siteVal) {
        //                 delete siteOrder[siteVal.id];
        //             }
        //         }
        //     }

        //     for (let [key, value] of mPhaseQty) {
        //         if (key != 'Δ' && value == 0) {
        //             var phaseVal = this.phasesList.find(phase => phase.name == key);
        //             if (phaseVal) {
        //                 delete phaseOrder[phaseVal.id];
        //             }
        //         }
        //     }
        // }

        if (anySave) {
            if (sTotalQtyCheck.size > 0) {
                let msg = 'Save operation failed. The sum of quantities across all sites is greater than the quantity available: ';
                sTotalQtyCheck.forEach(function (element) {
                    msg += element + ',';
                });
                msg = msg.substring(0, msg.length - 1);
                this.showSpinner = false;
                this.showToast('Error', msg, 'error');
                return false;
            }

            if (sSiteQtyCheck.size > 0) {
                let msg = 'Save operation failed. Please correct the issue and retry. Negative quantities exist for the following Product Site combinations: ';
                sSiteQtyCheck.forEach(function (element) {
                    msg += element + ',';
                });
                msg = msg.substring(0, msg.length - 1);
                this.showSpinner = false;
                this.showToast('Error', msg, 'error');
                return false;
            }

            if (sPhaseQtyCheck.size > 0) {
                let msg = 'Save operation failed. Please correct the issue and retry. Negative quantities exist for the following Product Site Phase combinations: ';
                sPhaseQtyCheck.forEach(function (element) {
                    msg += element + ',';
                });
                msg = msg.substring(0, msg.length - 1);
                this.showSpinner = false;
                this.showToast('Error', msg, 'error');
                return false;
            }

            if (sDeltaCheck.size > 0) {
                let msg = 'Warning: Negative delta quantities exist for the following Product Site combinations: ';
                sDeltaCheck.forEach(function (element) {
                    msg += element + ',';
                });
                msg = msg.substring(0, msg.length - 1);
                msg += '. Do you want to Save?';
                let confirm = window.confirm(msg);
                if (!confirm) {
                    this.showSpinner = false;
                    return false;
                }
            }

            if ((listUpsert && listUpsert.length > 0) || (listDelete && listDelete.length > 0)) {
                saveSitePhaseQuantity({ listUpsert: listUpsert, listDelete: listDelete, quoteUsesPhases: quoteUsesPhases, isSaveOnly: !isValidate })
                    .then(result => {
                        if (Object.keys(siteOrder).length > 0 || Object.keys(phaseOrder).length > 0 || (this.selectedSites.length == 0 && this.selectedPhases.length == 0)) {
                            saveSitePhaseConfiguration({ configId: this.configId, siteOrder: siteOrder, phaseOrder: phaseOrder })
                                .then(rt => {
                                    this.postUpdateValidation(result, isValidate, sDeltaValidate, mSiteQty, mPhaseQty);
                                })
                                .catch((error) => {
                                    console.log('saveSitePhaseConfiguration error->' + error);
                                    this.showSpinner = false;
                                    this.showToast('Error', 'Something went wrong. Please try again.', 'error');
                                });
                        } else {
                            this.postUpdateValidation(result, isValidate, sDeltaValidate, mSiteQty, mPhaseQty);
                        }
                    })
                    .catch((error) => {
                        this.showSpinner = false;
                        this.showToast('Error', 'Something went wrong. Please try again.', 'error');
                    });
            } else {
                this.showToast('Info', 'There is no data to Save. Please enter some quantity values and retry.', 'info');
                this.showSpinner = false;
                return false;
            }
        } else if (Object.keys(siteOrder).length > 0 || Object.keys(phaseOrder).length > 0) {
            saveSitePhaseConfiguration({ configId: this.configId, siteOrder: siteOrder, phaseOrder: phaseOrder })
                .then(result => {
                    console.log('saveSitePhaseConfiguration success' + JSON.stringify(result));
                    if (result > 0) {
                        this.postUpdateValidation('saveSitePhaseConfiguration', isValidate, sDeltaValidate, mSiteQty, mPhaseQty);
                    } else if (isValidate && sDeltaValidate.size > 0) {
                        this.validateCheck(sDeltaValidate);
                    } else {
                        this.showToast('Info', 'There is no data to Save. Please enter some quantity values and retry.', 'info');
                        this.showSpinner = false;
                        return false;
                    }
                })
                .catch((error) => {
                    this.showSpinner = false;
                    this.showToast('Error', 'Something went wrong. Please try again.', 'error');
                });
        } else {
            console.log('else');
            if (isValidate && sDeltaValidate.size > 0) {
                this.validateCheck(sDeltaValidate);
            }
            else {
                //nothing to save
                this.showToast('Info', 'There is no data to Save. Please enter some quantity values and retry.', 'info');
                this.showSpinner = false;
                return false;
            }
        }
    }

    validateCheck(sDeltaValidate) {
        let msg = '';
        for (let item of sDeltaValidate) {
            msg += item + ',';
        }
        if (msg.length > 0) {
            msg = msg.substring(0, msg.length - 1);
            this.showToast('Warning', 'Validate operation failed. Please correct the issue and retry. "Δ" (Delta) values are not 0 for the following Product Site combinations: ' + msg, 'warning');
            this.showSpinner = false;
        }
    }

    postUpdateValidation(result, isValidate, sDeltaValidate, mSiteQty, mPhaseQty) {
        this.showSpinner = false;

        if (result) {
            if (isValidate && sDeltaValidate.size > 0) {
                this.validateCheck(sDeltaValidate);
            }
            else if (result.isSuccess != undefined) {
                if (result.isSuccess) {
                    this.showToast('Info', result.error, 'info');
                } else {
                    this.showToast('Error', result.error, 'error');
                }
            } else if (result != 'saveSitePhaseConfiguration') {
                let msg = 'No data was saved for the following ';
                let siteNames = '';
                let phaseNames = '';
                for (let [key, value] of mSiteQty) {
                    if (key != 'No Site Assigned' && value == 0) {
                        siteNames += key + ',';
                    }
                }
                if (siteNames.length > 0) {
                    msg += 'sites: ' + siteNames.substring(0, siteNames.length - 1);
                }
                for (let [key, value] of mPhaseQty) {
                    if (key != 'Δ' && value == 0) {
                        phaseNames += key + ',';
                    }
                }
                if (phaseNames.length > 0) {
                    msg += (siteNames.length > 0 ? ' and phases: ' : ' phases: ') + phaseNames.substring(0, phaseNames.length - 1);
                }
                if (siteNames.length > 0 || phaseNames.length > 0) {
                    if (msg.indexOf(',') == msg.length - 1) {
                        msg = msg.substring(0, msg.length - 1);
                    }
                    this.showToast('Info', msg + ' as they have no quantities assigned.', 'info');
                } else {
                    this.showToast('Success', 'Records Saved Successfully.', 'success');
                }
            } else {
                this.showToast('Success', 'Records Saved Successfully.', 'success');
            }
            this.resetData();
            return refreshApex(this.wiredLineItems);
        }
    }

    checkForAnyUpdate(anySave, mSiteQty, quoteUsesPhases, listUpsert, listDelete) {
        if (!anySave) {
            if (mSiteQty.size == 1) {
                anySave = quoteUsesPhases;
            } else if (listUpsert.length > 0) {
                if (!quoteUsesPhases) {
                    for (let [key, value] of mSiteQty) {
                        if (key != 'No Site Assigned' && value != 0 && !anySave) {
                            anySave = true;
                        }
                    }
                } else {
                    anySave = true;
                }
            }
        } else if (!quoteUsesPhases) {
            let deleteAll = true;
            for (let [key, value] of mSiteQty) {
                if (key != 'No Site Assigned' && value != 0 && deleteAll) {
                    deleteAll = false;
                }
            }
            if (deleteAll) {
                this.productList.forEach(prodItem => {
                    for (let site of prodItem.sites) {
                        if (site.recordId && site.recordId != undefined) {
                            listDelete.push(site.recordId);
                        } else if (site.phases) {
                            for (let phase of site.phases) {
                                if (phase.recordId && phase.recordId != undefined) {
                                    listDelete.push(phase.recordId);
                                }
                            }
                        }
                        if (listUpsert && listUpsert.length > 0) {
                            let index = listUpsert.findIndex(element => prodItem.lineItemId == element.lineItemId && element.siteName == site.siteName);
                            if (index >= 0) {
                                listUpsert.splice(index, 1);
                            }
                        }
                    }
                });
            }
        }
        return anySave;
    }

    prepareDataForInsert(sTotalQtyCheck, mSiteQty, hasPhases, validatePhase, sDeltaValidate, sDeltaCheck, sPhaseQtyCheck, mPhaseQty, listUpsert, sSiteQtyCheck, sSiteQtyZeroCheck) {
        this.productList.forEach(prodItem => {
            for (let site of prodItem.sites) {
                if (site.siteName == 'No Site Assigned' && Number(site.quantity) < 0) {
                    sTotalQtyCheck.add(prodItem.productName);
                }
                if (mSiteQty.has(site.siteName)) {
                    mSiteQty.set(site.siteName, Number(mSiteQty.get(site.siteName)) + Number(site.quantity));
                } else {
                    mSiteQty.set(site.siteName, Number(site.quantity));
                }
                if (hasPhases && site.phases && site.phases.length > 0) {
                    for (let phase of site.phases) {
                        if (phase.phaseName == 'Δ' && Number(phase.quantity) != 0) {
                            validatePhase = true;
                            sDeltaValidate.add(prodItem.productName + '-' + site.siteName);
                        }
                        if (Number(phase.quantity) < 0) {
                            if (phase.phaseName == 'Δ') {
                                sDeltaCheck.add(prodItem.productName + '-' + site.siteName);
                            } else {
                                sPhaseQtyCheck.add(prodItem.productName + '-' + site.siteName + '-' + phase.phaseName);
                            }
                        }
                        //add to the map--> Insert
                        //insert site with phases
                        if (mPhaseQty.has(phase.phaseName)) {
                            mPhaseQty.set(phase.phaseName, Number(mPhaseQty.get(phase.phaseName)) + Number(phase.quantity));
                        } else {
                            mPhaseQty.set(phase.phaseName, Number(phase.quantity));
                        }
                        if (phase.quantity != 0) {
                            let upObj = {};
                            upObj.quantity = phase.quantity;
                            upObj.siteId = site.siteId;
                            upObj.phaseId = phase.phaseId;
                            upObj.siteName = site.siteName;
                            upObj.phaseName = phase.phaseName;
                            upObj.lineItemId = prodItem.lineItemId;
                            upObj.prodName = prodItem.productName;
                            listUpsert.push(upObj);
                        }
                    }
                } else {
                    //add to the map --> Insert
                    //insert sites
                    if (Number(site.quantity) < 0) {
                        sSiteQtyCheck.add(prodItem.productName + '-' + site.siteName);
                    }
                    if (Number(site.quantity) == 0 && site.siteName != 'No Site Assigned') {
                        sSiteQtyZeroCheck.add(prodItem.productName + '-' + site.siteName);
                    }
                    if (site.quantity != 0) {
                        let upObj = {};
                        upObj.quantity = site.quantity;
                        upObj.siteId = site.siteId;
                        upObj.siteName = site.siteName;
                        upObj.lineItemId = prodItem.lineItemId;
                        upObj.prodName = prodItem.productName;
                        listUpsert.push(upObj);
                    }
                }
            }
        });
        return validatePhase;
    }

    prepareDataForUpdate(sTotalQtyCheck, mSiteQty, hasPhases, validatePhase, sDeltaValidate, sDeltaCheck, sPhaseQtyCheck, mPhaseQty, mSet, listUpsert, sSiteQtyCheck, sSiteQtyZeroCheck, listDelete) {
        if (this.productList && this.productList.length > 0) {
            this.productList.forEach(prodItem => {
                for (let site of prodItem.sites) {
                    if (site.siteName == 'No Site Assigned' && Number(site.quantity) < 0) {
                        sTotalQtyCheck.add(prodItem.productName);
                    }
                    if (mSiteQty.has(site.siteName)) {
                        mSiteQty.set(site.siteName, Number(mSiteQty.get(site.siteName)) + Number(site.quantity));
                    } else {
                        mSiteQty.set(site.siteName, Number(site.quantity));
                    }
                    if (hasPhases && site.phases && site.phases.length > 0) {
                        for (let phase of site.phases) {
                            if (phase.phaseName == 'Δ' && Number(phase.quantity) != 0) {
                                validatePhase = true;
                                sDeltaValidate.add(prodItem.productName + '-' + site.siteName);
                            }
                            if (Number(phase.quantity) < 0) {
                                if (phase.phaseName == 'Δ') {
                                    sDeltaCheck.add(prodItem.productName + '-' + site.siteName);
                                } else {
                                    sPhaseQtyCheck.add(prodItem.productName + '-' + site.siteName + '-' + phase.phaseName);
                                }
                            }
                            let upObj = {};
                            upObj.quantity = phase.quantity;
                            upObj.siteId = site.siteId;
                            upObj.phaseId = phase.phaseId;
                            upObj.siteName = site.siteName;
                            upObj.phaseName = phase.phaseName;
                            upObj.lineItemId = prodItem.lineItemId;
                            upObj.prodName = prodItem.productName;
                            if (mPhaseQty.has(phase.phaseName)) {
                                mPhaseQty.set(phase.phaseName, Number(mPhaseQty.get(phase.phaseName)) + Number(phase.quantity));
                            } else {
                                mPhaseQty.set(phase.phaseName, Number(phase.quantity));
                            }
                            if (phase.recordId && phase.recordId != undefined) {
                                if (this.mapOriginalData.has(phase.recordId)) {
                                    let qty = this.mapOriginalData.get(phase.recordId);
                                    //this.mapOriginalData.delete(phase.recordId);
                                    mSet.add(phase.recordId);
                                    if (phase.quantity != 0) {
                                        if (phase.quantity != qty) {
                                            //add to the map --> Update
                                            upObj.recordId = phase.recordId;
                                            listUpsert.push(upObj);
                                        }
                                    } else {
                                        mSet.delete(phase.recordId);
                                    }
                                }
                            }
                            else {
                                //insert
                                if (phase.quantity != 0) {
                                    listUpsert.push(upObj);
                                }
                            }
                        }
                    } else {
                        if (Number(site.quantity) < 0) {
                            sSiteQtyCheck.add(prodItem.productName + '-' + site.siteName);
                        }
                        if (Number(site.quantity) == 0 && site.siteName != 'No Site Assigned') {
                            sSiteQtyZeroCheck.add(prodItem.productName + '-' + site.siteName);
                        }
                        let upObj = {};
                        upObj.quantity = site.quantity;
                        upObj.siteId = site.siteId;
                        upObj.siteName = site.siteName;
                        upObj.lineItemId = prodItem.lineItemId;
                        upObj.prodName = prodItem.productName;
                        if (site.recordId && site.recordId != undefined) {
                            if (this.mapOriginalData.has(site.recordId)) {
                                let qty = this.mapOriginalData.get(site.recordId);

                                mSet.add(site.recordId);
                                if (site.quantity != 0) {
                                    if (site.quantity != qty) {
                                        upObj.recordId = site.recordId;
                                        listUpsert.push(upObj);
                                    }
                                } else {
                                    mSet.delete(site.recordId);
                                }
                            }
                        } else {
                            //insert
                            if (site.quantity != 0) {
                                listUpsert.push(upObj);
                            }
                        }
                    }
                }
            });
        }
        for (let key of this.mapOriginalData.keys()) {
            if (!mSet.has(key) && key != undefined) {
                listDelete.push(key);
            }
        }
        return validatePhase;
    }

    checkSitePhaseOrder(siteOrder, phaseOrder, mSiteQty, mPhaseQty) {
        for (var i = 0, l = this.selectedSites.length; i < l; i++) {
            if (mSiteQty.size > 0) {
                var site = (this.sitesList.find(site => site.id == this.selectedSites[i])).name;
                if (!(mSiteQty.has(site) && mSiteQty.get(site) == 0)) {
                    siteOrder[this.selectedSites[i]] = i + 1;
                }
            } else {
                siteOrder[this.selectedSites[i]] = i + 1;
            }
        }
        for (var i = 0, l = this.selectedPhases.length; i < l; i++) {
            if (mPhaseQty.size > 0) {
                var phase = (this.phasesList.find(phase => phase.id == this.selectedPhases[i])).name;
                if (!(mPhaseQty.has(phase) && mPhaseQty.get(phase) == 0)) {
                    phaseOrder[this.selectedPhases[i]] = i + 1;
                }
            } else {
                phaseOrder[this.selectedPhases[i]] = i + 1;
            }
        }
    }
    //#region Save ENDS

    // To Enable Phases
    showPhasesToUse() {
        this.resetMessage();
        this.isOpenPhasesModal = true;
    }
    // To check if phases is disable and show note its not available 
    get showPhasesDisabled() {
        //surinder ITPC:1125
        if(this.tablePhases.size > 0 && !this.hasAggregation){}
        return (this.tablePhases.size > 0 && !this.hasAggregation) ? false : true;
    }
    //Enable "Show Incomplete Allocation" for Aggregation.
    get enableShowIncompleteAllocation(){
        return this.tablePhases.size > 0  ? false:true;
    }
    
    // When Phases checked
    handleCheckedQuotePhases(event) {
        if (event.target.checked) {
            this.showPhaseFunctions = true;
        }
        else {
            if (this.tablePhases.size > 0) {
                let cnf = window.confirm('You have unselected Quote Uses Phases. This will remove all Phase information from this quote. Do you want to continue with this action?');
                if (cnf) {
                    //surinder
                    this.productListWithPagination = [];
                    let length = (this.productList.length < this.pageLength) ? this.productList.length : this.pageLength;
                    this.totalPages = (((this.productList.length / this.pageLength) - ((this.productList.length % this.pageLength) / this.pageLength)) + (((this.productList.length % this.pageLength) === 0) ? 0 : 1));
                    for (let i = 0; i < length; i++) {
                        //this.productListWithPagination.push(this.productList[i]);
                        if ((i + ((this.page - 1) * this.pageLength)) < this.productList.length) {
                            this.productListWithPagination.push(this.productList[i + ((this.page - 1) * this.pageLength)]);
                        }
                    }
                    this.showDeltaOnlyFlagChecked = false;
                    //changes end----------------------------------
                    this.showSpinner = true;
                    this.showPhaseFunctions = false;
                    this.arePhasesVisible = false;
                    this.tablePhases.clear();
                    this.productList.forEach(prodItem => {
                        for (let site of prodItem.sites) {
                            if (site.phases && site.phases.length > 0) {
                                site.phases = [];
                            }
                        }
                    });
                    this.selectedPhases = [];
                    this.oSelectedPhases = [];
                    this.showSpinner = false;
                } else {
                    event.target.checked = true;
                    this.showPhaseFunctions = true;
                }
            } else {
                this.showPhaseFunctions = false;
            }
        }
    }
    showSelectedPhases(event) {
        if (event.target.checked) {
            this.arePhasesVisible = true;
        }
        else {
            this.arePhasesVisible = false;
            //surinder
            this.productListWithPagination = [];
            let length = (this.productList.length < this.pageLength) ? this.productList.length : this.pageLength;
            this.totalPages = (((this.productList.length / this.pageLength) - ((this.productList.length % this.pageLength) / this.pageLength)) + (((this.productList.length % this.pageLength) === 0) ? 0 : 1));
            for (let i = 0; i < length; i++) {
                //this.productListWithPagination.push(this.productList[i]);
                if ((i + ((this.page - 1) * this.pageLength)) < this.productList.length) {
                    this.productListWithPagination.push(this.productList[i + ((this.page - 1) * this.pageLength)]);
                }
            }
            this.showDeltaOnlyFlagChecked = false;
            //changes end 
        }
    }
    sitePhaseTxtChange(event) {
        event.target.setCustomValidity("");
        event.target.reportValidity();
        if (event.target.value != null && event.target.value != undefined && event.target.value != '') {
            this.addSitePhaseDisabled = false;
        } else {
            this.addSitePhaseDisabled = true;
        }
    }
    // When New Phases are added
    addSitePhase(event) {
        this.showSpinner = true;
        if (event.target.name == 'addNewSite') {
            let inputCmp = this.template.querySelector("lightning-input[data-my-id=txtSiteName]");
            let value = inputCmp.value;
            if (!(value != null && value != undefined && value != '')) {
                inputCmp.setCustomValidity("Please enter Site Name.");
                inputCmp.reportValidity();
                this.showSpinner = false;
                return false;
            }
            let isValid = true;
            this.sitesList.forEach(element => {
                if (element.name == value) {
                    this.showToast('Error', "Site: " + value + " was not created. A site with this name already exists on the opportunity.", 'error');
                    isValid = false;
                    this.showSpinner = false;
                    return false;
                }
            });
            if (isValid) {
                inputCmp.setCustomValidity("");
                inputCmp.reportValidity();
                let fields = { 'Name': value, 'Opportunity__c': this.oppId };
                const recordInputCreate = { apiName: 'NokiaCPQ_Site__c', fields };
                createRecord(recordInputCreate).then(response => {
                    this.sitesList.push({ id: response.id, name: value, value: response.id, label: value });
                    this.selectedSites.push(response.id);
                    this.showToast('Success', 'Site: ' + value + ' has been created successfully.', 'success');
                    inputCmp.value = '';
                    this.showSpinner = false;
                    this.addSitePhaseDisabled = true;
                }).catch(error => {
                    this.showToast('Error', 'Something went wrong while saving the record.', 'error');
                    this.showSpinner = false;
                });
            }
        } else {
            let inputCmp = this.template.querySelector("lightning-input[data-my-id=txtPhaseName]");
            let value = inputCmp.value;
            if (!(value != null && value != undefined && value != '')) {
                inputCmp.setCustomValidity("Please enter Phase Name.");
                inputCmp.reportValidity();
                this.showSpinner = false;
                return false;
            }
            let isValid = true;
            this.phasesList.forEach(element => {
                if (element.name == value) {
                    this.showToast('Error', "Phase: " + value + " was not created. A phase with this name already exists on the opportunity.", 'error');
                    isValid = false;
                    this.showSpinner = false;
                    return false;
                }
            });
            if (isValid) {
                inputCmp.setCustomValidity("");
                inputCmp.reportValidity();
                let fields = { 'Name': value, 'Opportunity__c': this.oppId };
                const recordInputCreate = { apiName: 'NokiaCPQ_Phase__c', fields };
                createRecord(recordInputCreate).then(response => {
                    this.phasesList.push({ id: response.id, name: value, value: response.id, label: value });
                    this.selectedPhases.push(response.id);
                    this.showToast('Success', 'Phase: ' + value + ' has been created successfully.', 'success');
                    inputCmp.value = '';
                    this.showSpinner = false;
                    this.addSitePhaseDisabled = true;
                }).catch(error => {
                    this.showToast('Error', 'Something went wrong while saving the record.', 'error');
                    this.showSpinner = false;
                });
            }
        }
    }

    showSitesToUse(event) {
        this.resetMessage();
        this.isSitesToUse = true;
    }
    closeModal() {
        // to close modal set isModalOpen tarck value as false
        this.isSitesToUse = false;
        this.isOpenPhasesModal = false;
        this.addSitePhaseDisabled = true;
        this.showProdDetail = false;
        let inputCmp = this.template.querySelectorAll("lightning-input[name=input1]");
        if (inputCmp) {
            inputCmp.forEach(function (element) {
                element.value = '';
            }, this);
        }
        // this.addedSites.forEach(element => {
        //     this.sitesList.forEach((item) => {
        //         if (item.id == element.siteId && item.checked) {
        //             item.checked = false;
        //         }
        //     });
        // });
        // this.addedPhases.forEach(element => {
        //     this.phasesList.forEach((item) => {
        //         if (item.id == element.phaseId && item.checked) {
        //             item.checked = false;
        //         }
        //     });
        // });
        this.removedSites = [];
        this.addedSites = [];
        this.removedPhases = [];
        this.addedPhases = [];
        this.selectedSites = [...this.oSelectedSites];
        this.selectedPhases = [...this.oSelectedPhases];
    }

    showToast(title, message, variant) {
        const childComponent = this.template.querySelector('c-nokia-c-p-q_notification');
        const returnedMessage = childComponent.showToast(title, message, variant);
    }
    resetMessage() {
        const childComponent = this.template.querySelector('c-nokia-c-p-q_notification');
        const returnedMessage = childComponent.resetMessage();
    }
    constructor() {
        super();
        this.showSpinner = true;
    }

    onProdClick(event) {
        let prodId = event.target.dataset.id;
        if (prodId && this.mProdDetail.has(prodId)) {
            let prod = this.mProdDetail.get(prodId);
            this.prodCode = prod.productCode;
            this.prodDesc = prod.productDesc;
            this.prodName = prod.productName;
            this.showProdDetail = true;
        }
    }

    //added by surinder
    showOnlyDeltaLines(event) {
        this.showDeltaOnlyFlagChecked = event.target.checked;
        var checked = event.target.checked;;
        this.nonZeroQtyLines = [];
        this.page = 1;
        this.totalPages = 1;
        if (this.showDeltaOnlyFlagChecked) {
            this.productListWithPagination = [];
            aLoop:
            for (let lineItem of this.productList) {
                for (let site of lineItem.sites) {
                    for (let phase of site.phases) {
                        console.log('phase=>' + JSON.stringify(phase));
                        if (phase.quantity != 0 && phase.phaseName == 'Δ') {
                            this.nonZeroQtyLines.push(lineItem);
                            continue aLoop;
                        }
                    }
                }
            }

            // this.productListWithPagination =  this.nonZeroQtyLines;

            if (this.nonZeroQtyLines.length > 0) {
                this.totalPages = (((this.nonZeroQtyLines.length / this.pageLength) - ((this.nonZeroQtyLines.length % this.pageLength) / this.pageLength)) + (((this.nonZeroQtyLines.length % this.pageLength) === 0) ? 0 : 1));
                let length = (this.nonZeroQtyLines.length < this.pageLength) ? this.nonZeroQtyLines.length : this.pageLength;
                for (let i = 0; i < length; i++) {
                    this.productListWithPagination.push(this.nonZeroQtyLines[i]);
                }
            }
        }
        else {
            this.productListWithPagination = [];
            let length = (this.productList.length < this.pageLength) ? this.productList.length : this.pageLength;
            this.totalPages = (((this.productList.length / this.pageLength) - ((this.productList.length % this.pageLength) / this.pageLength)) + (((this.productList.length % this.pageLength) === 0) ? 0 : 1));
            for (let i = 0; i < length; i++) {
                this.productListWithPagination.push(this.productList[i]);
            }

        }
    }
    // changes end
    resetData() {
        this.mapSites = new Map();
        this.mapPhases = new Map();
        this.mProdDetail = new Map();
        this.productList = [];
        this.sitesList = [];
        this.phasesList = [];
        this.siteIds = new Set();
        this.mapOriginalData = new Map();
        this.productListWithPagination = [];
    }
}