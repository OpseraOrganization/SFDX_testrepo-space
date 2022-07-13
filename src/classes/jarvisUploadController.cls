public with sharing class jarvisUploadController{
public Id proposalId;
public Apttus_Proposal__Proposal__c proposal;
public Blob csvFileBody {get; set;}
public string csvAsString {get; set;}
public boolean isCSV {get; set;}
public List<String> uploadedFiles {get; set;}
public String productDataAsString;
public String[] csvFileLines {get; set;}
List<String> csvRecordData;
List<String> csvRecordData1;
public String priorUploadedFiles {get; set;}
Set<String> activeproductCodesSet = new Set<String>();
Set<String> productCodeSet = new Set<String>();
List <Apttus_CPQApi.CPQ.SelectedProductDO> selectedProdDOList = new List <Apttus_CPQApi.CPQ.SelectedProductDO>();
public Id cartId;
public PS_ApttusCPQWebServiceCalls acpq;
Integer flag=0;
Integer flag1=0;
public static string IP_ROUTING_STRING = Nokia_CPQ_Constants.NOKIA_IP_ROUTING;
public static string DIRECT_CPQ= Nokia_CPQ_Constants.QUOTE_TYPE_DIRECTCPQ;
public static string INDIRECT_CPQ = Nokia_CPQ_Constants.QUOTE_TYPE_INDIRECTCPQ;
public List<NokiaCPQ_Site__c> sitesToInsertList;
public List<NokiaCPQ_Site__c> sitesExistingRecords;
public List<NokiaCPQ_Phase__c> phasesToInsertList;
public List<NokiaCPQ_Phase__c> phasesExistingRecords;
List<String> phaseSet = new List<String>();
List<String> siteSet = new List<String>();
Map<String,Set<String> > siteAndProductMap = new Map<String,Set<String> >();
List <Apttus_Config2__LineItem__c> lineItem = new List <Apttus_Config2__LineItem__c>();
List <Apttus_Config2__LineItem__c> updateLineItem = new List <Apttus_Config2__LineItem__c>();
List <CPQ_Site_Phase_and_Quantity__c> insertSitePhaseQuan = new List <CPQ_Site_Phase_and_Quantity__c>();
Map<String,ID> siteNameIDMap = new Map<String,ID>();
Map<String,ID> phaseNameIDMap = new Map<String,ID>();
List<Integer> phases = new List<Integer>();
Map<Integer,String> phasesMap = new Map<Integer,String>();
Map<String,ID> concatenateproductsiteliid = new Map<String,ID>();
Map<String,ID> concatenateproductCodeliid = new Map<String,ID>();
Map<String,String> concatenateproductsiteliName = new Map<String,String>();
Map<String,Integer> productCodeTotalQuantityMap = new Map<String,Integer>();
Map<String,ID> productCodeIDMap = new Map<String,ID>();
Map<ID,String> productIDCodeMap = new Map<ID,String>();
Map<Id, Double> productIdVersionMap = new Map<Id, Double>();
//Added by Christie JJ for ITCCPQ-1125(2188)
public boolean hasAggregation {get; set;}
//constructor
public jarvisUploadController(Apexpages.Standardcontroller controller){
priorUploadedFiles= '';
uploadedFiles = new List<String>();
isCSV = false;
proposalId = ApexPages.currentPage().getParameters().get('id');
if(proposalId != null) {
proposal = [Select Id,Apttus_Proposal__Opportunity__c,Direct_Price_List_Number__c,NokiaCPQ_Is_Maintenance_Quote__c,Quote_Type__c,Is_List_Price_Only__c,Apttus_QPConfig__PriceListId__c,APTS_ConfigureProductsTP__c, NokiaCPQ_Environment_Access_Type__c, NokiaCPQ_Portfolio__c, NokiaCPQPricing_Cluster__c,Configure_button_field__c,Turbo_Pricing_Enable__c,Configure_button_field_TP__c,Configure_grid_flow_button__c,Is_Turbo_Pricing__c,CPQ_PortfolioClusterSF1__c,CPQ_PortfolioClusterSF2__c,CPQ_PortfolioClusterSF3__c,CPQ_PortfolioClusterSF4__c from Apttus_Proposal__Proposal__c where Id =:proposalId Limit 1];
system.debug('----->>proposal if condition'+proposal);
//Added by Christie JJ for ITCCPQ-1125(2188)
hasAggregation = Nokia_CPQ_Utility.checkForAggregation(proposalId);
}
}
public void validateCSVFile(){
Set<String> futureProducts = new Set<String>();
List<String> necessaryColumns = new List<String> { 'Name','Material', 'Description','GLP (USD)','NSP license pts','Total' };
Set<String> columnsInFile = new Set<String>(necessaryColumns);
futureProducts.clear();
String futureProd = '';
Boolean displayerrormsg = false;
boolean displayError = false;
Boolean columnsheadererrormsg= false;
String errorcolumns = '';
string IP_RoutingLike = '%'+IP_ROUTING_STRING+'%';  //ITCCPQ-2594
try{
uploadedFiles.add(csvAsString);
productDataAsString = csvFileBody.toString();
system.debug('csvAsString  :'+productDataAsString);
if(productDataAsString.contains(';')) {
productDataAsString = productDataAsString.replaceAll(';',',');
}
csvFileLines = productDataAsString.split('\n');
system.debug(' productDataAsString::::'+productDataAsString);
String columnNames = csvFileLines.get(0).substring(0).replaceAll('"','');
String columnsref = csvFileLines.get(0);
String phasesRef = columnsref.substringBetween('NSP license pts','Total').replaceAll('"','').removeEnd(',');
String phases = phasesRef.removeStart(',');
if(String.isBlank(phasesRef)) {
isCSV = true;
ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.Severity.ERROR,'Not a valid file as Phases columns are missing');
ApexPages.addMessage(errorMessage);
}
for(String col: columnsInFile) {
if(columnNames.contains(col)) {
}
else{
displayerrormsg= true;
errorcolumns = errorcolumns + col + ',';
}
}
for(Integer i=0; i<csvFileLines.size(); i++) {
csvRecordData = csvFileLines[i].split(GlobalConstants.INVERTEDCOMMA);
if(csvRecordData[1].replaceAll('"','') != 'Material' || csvRecordData[2].replaceAll('"','') != 'Description' || csvRecordData[0].replaceAll('"','') != 'Name') {
columnsheadererrormsg= true;
}
break;
}
if(displayerrormsg) {
isCSV = true;
ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.Severity.ERROR,'Not a valid file as ' + errorcolumns.removeEnd(',')+ ' column is missing.');
ApexPages.addMessage(errorMessage);
}
if(columnsheadererrormsg && !displayerrormsg) {
isCSV = true;
ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.Severity.ERROR,'Columns header format is not correct. It should be like (Name;Material;Description;GLP (USD);NSP license pts;Phases(Dynamic);Total;Targeted Release;GA release;FD release;FA item;jBoQ token) ');
ApexPages.addMessage(errorMessage);
}
for(Integer i=1; i<csvFileLines.size(); i++) {
csvRecordData = csvFileLines[i].split(GlobalConstants.INVERTEDCOMMA);
String mystring = csvRecordData[1].replaceAll('"','').trim();
if(!String.isBlank(csvRecordData[2].replace('"','')) && !String.isBlank(csvRecordData[1]) && (!myString.contains('3HE14159AA') && !myString.contains('x') )) {
productCodeSet.add(csvRecordData[1].replace('"',''));
system.debug('productCodeSet::::'+productCodeSet);
}
}
If(productCodeSet.isEmpty()){
isCSV = true;
ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.Severity.ERROR,'Please upload valid products ');
ApexPages.addMessage(errorMessage);
}
for(Apttus_Config2__PriceListItem__c pli:[SELECT Id,Name,Apttus_Config2__ProductCode__c,Apttus_Config2__PriceListId__c,Apttus_Config2__ProductId__r.Direct_Portfolio__c,Apttus_Config2__ProductId__r.Portfolio__c,Apttus_Config2__ProductId__r.Pricing_Clusters__c,Apttus_Config2__ProductId__r.Pricing_Clusters_Search_Filter__c,Apttus_Config2__ProductId__r.Apttus_Config2__Version__c
FROM Apttus_Config2__PriceListItem__c
WHERE Apttus_Config2__PriceListId__c =:proposal.Apttus_QPConfig__PriceListId__c
AND Apttus_Config2__ProductCode__c in:productCodeSet
AND (Apttus_Config2__ProductId__r.Direct_Portfolio__c =: IP_ROUTING_STRING
OR (Apttus_Config2__ProductId__r.Pricing_Clusters__c != null AND Apttus_Config2__ProductId__r.Portfolio__c like : IP_RoutingLike) )
AND Apttus_Config2__ProductActive__c = true
AND Apttus_Config2__Active__c = TRUE]) { 
/*****ITCCPQ-2128 - Allowing Jarvis Upload for Partners - Siva- START**** */
if((proposal.Quote_Type__c == DIRECT_CPQ && pli.Apttus_Config2__ProductId__r.Direct_Portfolio__c == IP_ROUTING_STRING) ||
(pli.Apttus_Config2__ProductId__r.Pricing_Clusters__c != null && proposal.NokiaCPQPricing_Cluster__c != null &&
proposal.Quote_Type__c == INDIRECT_CPQ && pli.Apttus_Config2__ProductId__r.Portfolio__c.contains(IP_ROUTING_STRING)  //ITCCPQ-2594
&& ((proposal.CPQ_PortfolioClusterSF1__c != null && pli.Apttus_Config2__ProductId__r.Pricing_Clusters_Search_Filter__c.contains(proposal.CPQ_PortfolioClusterSF1__c)))
|| (proposal.CPQ_PortfolioClusterSF2__c != null && pli.Apttus_Config2__ProductId__r.Pricing_Clusters_Search_Filter__c.contains(proposal.CPQ_PortfolioClusterSF2__c))
|| (proposal.CPQ_PortfolioClusterSF3__c != null && pli.Apttus_Config2__ProductId__r.Pricing_Clusters_Search_Filter__c.contains(proposal.CPQ_PortfolioClusterSF3__c))
|| (proposal.CPQ_PortfolioClusterSF4__c != null && pli.Apttus_Config2__ProductId__r.Pricing_Clusters_Search_Filter__c.contains(proposal.CPQ_PortfolioClusterSF4__c))))
{
productCodeIDMap.put(pli.Apttus_Config2__ProductCode__c,pli.Apttus_Config2__ProductId__c);
productIDCodeMap.put(pli.Apttus_Config2__ProductId__c,pli.Apttus_Config2__ProductCode__c);
productIdVersionMap.put(pli.Apttus_Config2__ProductId__c,pli.Apttus_Config2__ProductId__r.Apttus_Config2__Version__c);
activeproductCodesSet.add(pli.Apttus_Config2__ProductCode__c);
}
//ITCCP-2128 - END
}
system.debug('active products set'+ activeproductCodesSet);
for(Integer i=1; i<csvFileLines.size(); i++) {
csvRecordData1 = csvFileLines[i].split(GlobalConstants.INVERTEDCOMMA);
string replacedCRD1 = csvRecordData1[1].replace('"','');
if(!String.isBlank(csvRecordData1[2].replaceAll('"','')) && !String.isBlank(replacedCRD1)) {
if(activeproductCodesSet.contains(replacedCRD1)) {
}
else{
String mystring = replacedCRD1.trim();
if( (!myString.contains('3HE14159AA') && !myString.contains('x') )) {
futureProducts.add(replacedCRD1);
futureProd = futureProd+ replacedCRD1  +'\n'+',';
futureProd.removeEnd(',');
displayError= true;
}
}
}
}
if( !productCodeSet.isEmpty() && futureProducts.size()== productCodeSet.size()) {
isCSV = true;
ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.Severity.ERROR,'All products in the CSV file are not available for Quoting. Please use custom products feature. ');
ApexPages.addMessage(errorMessage);
}
else if(displayError && !String.isBlank(phases) && !displayerrormsg && !columnsheadererrormsg) {
//   isCSV = true;
ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.Severity.Info,'Following products are not available for Quoting : ' + futureProd.removeEnd(',')+ '\n' +'. Click on "IMPORT PRODUCTS" to continue or "CANCEL" to go to Quote');
ApexPages.addMessage(errorMessage);
}
}
catch(exception e) {
if(e.getMessage().contains('BLOB is not a valid UTF-8 string'))
{
ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Please upload valid CSV file only.'));
}else{
ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.ERROR,'Products validate Error. Expected behavior is to have values in Double Quotes(EX: "Name"). Please edit in a text editor(Notepad) and re-upload the file.');
ApexPages.addMessage(errorMessage);
}
}
}
public void importProdutsfromfile(){
Integer totalQuan = 0;
Integer Quantity = 0;
Map<String,Integer> productCodeQuantityMap = new Map<String,Integer>();
Map<String,String> prodcutCodeSiteNameMap = new Map<String,String>();
Map<String,Set<String> > siteAndPhaseMap = new Map<String,Set<String> >();
Set<NokiaCPQ_Site__c> sitesToInsertset = new Set<NokiaCPQ_Site__c>();
sitesToInsertList = new List<NokiaCPQ_Site__c>();
sitesExistingRecords = new List<NokiaCPQ_Site__c>();
Set<NokiaCPQ_Phase__c> phasesToInsertset = new Set<NokiaCPQ_Phase__c>();
phasesToInsertList = new List<NokiaCPQ_Phase__c>();
phasesExistingRecords  = new List<NokiaCPQ_Phase__c>();
try{
// Insertion of sites to oppty
List<NokiaCPQ_Site__c> siteList = [SELECT ID, Name FROM NokiaCPQ_Site__c WHERE Opportunity__c  = : proposal.Apttus_Proposal__Opportunity__c];
for(Integer i=1; i<csvFileLines.size(); i++) {
csvRecordData = csvFileLines[i].split(GlobalConstants.INVERTEDCOMMA);
string replacedCRD0 = csvRecordData[0].replaceAll('"','');
string replacedCRD1 = csvRecordData[1].replaceAll('"','');
if(!String.isBlank(csvRecordData[2].replaceAll('"','')) && !String.isBlank(replacedCRD1) && !String.isBlank(replacedCRD0)) {
if(activeproductCodesSet.contains(replacedCRD1)) {
if(!siteSet.contains(replacedCRD0)) {
siteSet.add(replacedCRD0);
}
prodcutCodeSiteNameMap.put(replacedCRD1+'--'+replacedCRD0,replacedCRD0);
if(siteAndProductMap.containsKey(replacedCRD0.trim())) {
siteAndProductMap.get(replacedCRD0.trim()).add(replacedCRD1);
}
else{
siteAndProductMap.put(replacedCRD0.trim(),new Set<String> {replacedCRD1});
}
}
}
}
Map<String,NokiaCPQ_Site__c> opptySiteNameToSiteMap = new Map<String,NokiaCPQ_Site__c>();
for(NokiaCPQ_Site__c oppSite : siteList) {
opptySiteNameToSiteMap.put(oppSite.Name, oppSite);
}
for(String siteName : siteSet) {
string sitetrm = siteName.trim();
if(!opptySiteNameToSiteMap.containsKey(sitetrm)) {
NokiaCPQ_Site__c siteRecord = new NokiaCPQ_Site__c();
siteRecord.Name = sitetrm;
siteRecord.Opportunity__c = proposal.Apttus_Proposal__Opportunity__c;
sitesToInsertset.add(siteRecord);
}
else if(opptySiteNameToSiteMap.containsKey(sitetrm)) {
sitesExistingRecords.add(opptySiteNameToSiteMap.get(sitetrm));
}
}
if(!sitesToInsertset.isEmpty()) {
sitesToInsertList.addAll(sitesToInsertset);
insert sitesToInsertList;
}
for(Integer i=0; i<csvFileLines.size(); i++) {
csvRecordData = csvFileLines[i].split(GlobalConstants.INVERTEDCOMMA);
for(Integer a=5; a<=20; a++) {
if(csvRecordData[a].replaceAll('"','') =='Total') {
totalQuan= a;
break;
}else{
phases.add(a);
}
}
break;
}
// insert Phases to oppty
for(Integer i=0; i<csvFileLines.size(); i++) {
csvRecordData = csvFileLines[i].split(GlobalConstants.INVERTEDCOMMA);
for(Integer ph : phases) {			  //5 6 7 8
string csvDataPh = csvRecordData[ph].replaceAll('"','');
if(!String.isBlank(csvDataPh)) {
if(!phaseSet.contains(csvDataPh)) {
phaseSet.add(csvDataPh);
}
phasesMap.put(ph,csvDataPh);
}
}
break;
}
List<NokiaCPQ_Phase__c> phaseList = [SELECT ID, Name FROM NokiaCPQ_Phase__c WHERE Opportunity__c  = : proposal.Apttus_Proposal__Opportunity__c];
Map<String,NokiaCPQ_Phase__c> opptyPhaseNameToPhaseMap = new Map<String,NokiaCPQ_Phase__c>();
for(NokiaCPQ_Phase__c oppPhase : phaseList) {
opptyPhaseNameToPhaseMap.put(oppPhase.Name, oppPhase);
}
for(String phaseName : phaseSet) {
string phasetTrm = phaseName.trim();
if(!opptyPhaseNameToPhaseMap.containsKey(phasetTrm)) {
NokiaCPQ_Phase__c phaseRecord = new NokiaCPQ_Phase__c();
phaseRecord.Name = phasetTrm;
phaseRecord.Opportunity__c = proposal.Apttus_Proposal__Opportunity__c;
phasesToInsertset.add(phaseRecord);
}
else if(opptyPhaseNameToPhaseMap.containsKey(phasetTrm)) {
phasesExistingRecords.add(opptyPhaseNameToPhaseMap.get(phasetTrm));
}
}
if(!phasesToInsertset.isEmpty()) {
phasesToInsertList.addAll(phasesToInsertset);
insert phasesToInsertList;
}
for(NokiaCPQ_Site__c site : [SELECT ID, Name FROM NokiaCPQ_Site__c WHERE Opportunity__c  = :proposal.Apttus_Proposal__Opportunity__c]) {
siteNameIDMap.put(site.Name, site.ID);
}
for(NokiaCPQ_Phase__c phase :[SELECT ID, Name FROM NokiaCPQ_Phase__c WHERE Opportunity__c  = : proposal.Apttus_Proposal__Opportunity__c]) {
phaseNameIDMap.put(phase.Name, phase.ID);
}
Integer source = 0;
for(Integer i=1; i<csvFileLines.size(); i++) {
csvRecordData = csvFileLines[i].split(GlobalConstants.INVERTEDCOMMA);
string replacedCRD1 = csvRecordData[1].replaceAll('"','');
if(!String.isBlank(csvRecordData[2].replaceAll('"','')) && !String.isBlank(replacedCRD1)) {
if(activeproductCodesSet.contains(replacedCRD1)) {
if(!productCodeTotalQuantityMap.containsKey(replacedCRD1.trim())) {
productCodeTotalQuantityMap.put(replacedCRD1.trim(),integer.valueOf(csvRecordData[totalQuan].replaceAll('"','').trim()));
}
else{
//  Integer Quantty = productCodeTotalQuantityMap.get(replacedCRD1.trim());
Integer Sum = productCodeTotalQuantityMap.get(replacedCRD1.trim())+ Integer.ValueOf(csvRecordData[totalQuan].replaceAll('"','').trim());
productCodeTotalQuantityMap.put(replacedCRD1.trim(),Sum);
}
}
}
}
System.debug('Jarvis--'+ productCodeTotalQuantityMap);
for(String prodCodes: productCodeTotalQuantityMap.keySet()) {
Apttus_CPQApi.CPQ.SelectedProductDO SelectedProductDOInstance = new Apttus_CPQApi.CPQ.SelectedProductDO();
SelectedProductDOInstance.ProductId = productCodeIDMap.get(prodCodes);
SelectedProductDOInstance.Quantity = productCodeTotalQuantityMap.get(prodCodes);
List<String> customFields = new List<String>();
Apttus_Config2__LineItem__c customData = new Apttus_Config2__LineItem__c();
customFields.add('Apttus_Config2__ProductVersion__c');
customFields.add('Source__c');
//   customFields.add('NokiaCPQ_Site__c');
customFields.add('Apttus_Config2__CopySourceNumber__c');
if(productCodeTotalQuantityMap.get(prodCodes) == 0) {
// CustomData.Source__c ='CSV-0';
CustomData.Apttus_Config2__CopySourceNumber__c = 0;
}else{
source = source +1;
CustomData.Apttus_Config2__CopySourceNumber__c = source;
}
CustomData.Source__c ='JARVIS';
CustomData.Apttus_Config2__ProductVersion__c = productIdVersionMap.get(productCodeIDMap.get(prodCodes));
//  CustomData.NokiaCPQ_Site__c = prodcutCodeSiteNameMap.get(csvRecordData[1].replaceAll('"','')+'--'+csvRecordData[0].replaceAll('"',''));
SelectedProductDOInstance.CustomFields = customFields;
SelectedProductDOInstance.CustomData = customData;
selectedProdDOList.add(SelectedProductDOInstance);
}
}
catch(Exception e) {
ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.ERROR,'Import products Error. Please contact your System Administrator');
ApexPages.addMessage(errorMessage);
}
}
public void createcart(){
if(proposalId != null) {
Apttus_CPQApi.CPQ.CreateCartRequestDO request = new Apttus_CPQApi.CPQ.CreateCartRequestDO();
request.QuoteID = proposalId;
Apttus_CPQApi.CPQ.CreateCartResponseDO cartRespDO = Apttus_CPQApi.CPQWebService.CreateCart(request);
cartId = cartRespDO.cartID;
system.debug('----->>'+ cartId);
}
if(cartId != null) {
Apttus_Config2__ProductConfiguration__c config = new Apttus_Config2__ProductConfiguration__c(Id = cartID);
Apttus_Config2__ProductConfiguration__c contractNumber = [Select id,Apttus_QPConfig__Proposald__r.Direct_Price_List_Number__c from Apttus_Config2__ProductConfiguration__c where id =:cartID limit 1];
config.Apttus_Config2__ContractNumbers__c = contractNumber.Apttus_QPConfig__Proposald__r.Direct_Price_List_Number__c;
config.Apttus_Config2__Status__c = 'Saved';
update config;
sitesToInsertList.addAll(sitesExistingRecords);
phasesToInsertList.addAll(phasesExistingRecords);
List<ID> phasesInCSVOrderlst = new  List<ID> ();
List<ID> sitesInCSVOrderlst = new  List<ID> ();
//arrange sitesToInsertList in the same order as in the csv file for sequencing of Sites
for(String site:siteSet) {
for(NokiaCPQ_Site__c siteObj :sitesToInsertList) {
if(site.trim() == siteObj.Name) {
sitesInCSVOrderlst.add(siteObj.Id);
break;
}
}
}
//arrange phasesToInsertList in the same order as in the csv file for sequencing of Phases
for(String phName:phaseSet) {
for(NokiaCPQ_Phase__c phObj :phasesToInsertList) {
if(phName.trim() == phObj.Name) {
phasesInCSVOrderlst.add(phObj.Id);
break;
}
}
}
//insert SitePhaseConfiguration (ITCCPQ-2170) - Update: below needs to be pushed after SitePhaseConfig obj pushed to qcrm
Nokia_CPQ_Utility.insertSitePhaseConfig(config.Id,sitesInCSVOrderlst,phasesInCSVOrderlst);
}
}
public void addProductsfromfile(){
List<Integer> primaryLines = new List<Integer>();
if(!selectedProdDOList.isEmpty())
{
Apttus_CPQApi.CPQ.AddMultiProductRequestDO lineItemRecords = new Apttus_CPQApi.CPQ.AddMultiProductRequestDO();
lineItemRecords.cartID = cartID;
lineItemRecords.SelectedProducts = selectedProdDOList;
Apttus_CPQApi.CPQ.AddMultiProductResponseDO lineItemRecordsResponse = Apttus_CPQApi.CPQWebService.addMultiProducts(lineItemRecords);
Apttus_CPQApi.CPQWebService.associateConstraintRules(cartId,primaryLines);
Apttus_CPQApi.CPQWebService.applyConstraintRules(cartId, false);
}
lineItem = [Select Id,Name,Apttus_Config2__ProductId__r.ProductCode,NokiaCPQ_Opportunity_Site__r.name,NokiaCPQ_Site__c from Apttus_Config2__LineItem__c where Apttus_Config2__ConfigurationId__c = :cartId ];
for(Apttus_Config2__LineItem__c li : lineItem) {
if(!(li.Apttus_Config2__ProductId__r.ProductCode.equalsIgnoreCase('MT001') || li.Apttus_Config2__ProductId__r.ProductCode.equalsIgnoreCase('MT002') || li.Apttus_Config2__ProductId__r.ProductCode.equalsIgnoreCase('SSP002') || li.Apttus_Config2__ProductId__r.ProductCode.equalsIgnoreCase('SRS001') )) {
concatenateproductsiteliid.put(li.Apttus_Config2__ProductId__r.ProductCode+'--'+li.NokiaCPQ_Site__c,li.id);
concatenateproductCodeliid.put(li.Apttus_Config2__ProductId__r.ProductCode,li.id);
concatenateproductsiteliName.put(li.Apttus_Config2__ProductId__r.ProductCode,li.Name);
}
}
for(Integer i=1; i<csvFileLines.size(); i++) {
csvRecordData = csvFileLines[i].split(GlobalConstants.INVERTEDCOMMA);
if(!String.isBlank(csvRecordData[2].replaceAll('"','')) && !String.isBlank(csvRecordData[1].replaceAll('"',''))) {
if(activeproductCodesSet.contains(csvRecordData[1].replaceAll('"',''))) {
for(Integer ph : phases) {
if(!String.isBlank(csvRecordData[ph].replaceAll('"',''))) {
if(Integer.ValueOf(csvRecordData[ph].replaceAll('"','').trim()) >= 1) {
CPQ_Site_Phase_and_Quantity__c spq = new CPQ_Site_Phase_and_Quantity__c();
spq.Name= concatenateproductsiteliName.get(csvRecordData[1].replaceAll('"','').trim());
//   spq.Line_Item__c= concatenateproductsiteliid.get(csvRecordData[1].replaceAll('"','').trim()+'--'+csvRecordData[0].replaceAll('"','').trim());
spq.Line_Item__c= concatenateproductCodeliid.get(csvRecordData[1].replaceAll('"','').trim());
spq.NCPQ_Quantity__c = Integer.ValueOf(csvRecordData[ph].replaceAll('"','').trim());
spq.NCPQ_Site__c = siteNameIDMap.get(csvRecordData[0].replaceAll('"','').trim());
spq.NCPQ_Phase__c = phaseNameIDMap.get(phasesMap.get(ph).trim());
insertSitePhaseQuan.add(spq);
}
}
}
}
}
}
if(!insertSitePhaseQuan.isEmpty()) {
insert insertSitePhaseQuan;
}
}
public void Reprice(){
if(cartId != null) {
Integer numErrors = 0;
Integer numWarnings = 0;
Boolean IsPricePending = true;
List<string> errorMsgs = new List<string>();
List<string> warningMsgs = new List<string>();
List<Integer> primaryLines = new List<Integer>();
Apttus_CPQApi.CPQWebService.associateConstraintRules(cartID,primaryLines);
Apttus_CPQApi.CPQWebService.applyConstraintRules(cartID, true);
Apttus_CPQApi.CPQ.ConstraintResultDO constRuleResultDO = Apttus_CPQApi.CPQWebService.getConstraintRuleResult(cartID);
List<Apttus_CPQApi.CPQ.AppliedActionDO> appliedActionDOList = constRuleResultDO.ConstraintRuleActions;
for(Apttus_CPQApi.CPQ.AppliedActionDO appliedActDO:appliedActionDOList) {
if(appliedActDO.MessageType.equals('Error') && appliedActDO.IsPending) {
numErrors++;
errorMsgs.add(appliedActDO.Message);
}
else if(appliedActDO.MessageType.equals('Warning') && appliedActDO.IsPending) {
numWarnings++;
warningMsgs.add(appliedActDO.Message);
}
}
if(numErrors < = 0 ) {
do {
Apttus_CPQApi.CPQ.UpdatePriceRequestDO priceReqDO = new Apttus_CPQApi.CPQ.UpdatePriceRequestDO();
priceReqDO.cartID = cartID;
Apttus_CPQApi.CPQ.UpdatePriceResponseDO priceRespDO = Apttus_CPQApi.CPQWebService.updatePriceForCart(priceReqDO);
List<Decimal> complLineNums = priceRespDO.CompletedLineNumbers;
IsPricePending = priceRespDO.IsPricePending;
List<Decimal> PendingLineNumbers = priceRespDO.PendingLineNumbers;
system.debug('IsPricePending :'+ IsPricePending);
} while(IsPricePending);
}
}
}
public void Saveconfig(){
system.debug('Save ..');
if(cartId != null && csvFileBody !=null) {
isCSV = true;
ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.Severity.CONFIRM,'File Uploaded Successfully. Click On Go To Cart.');
ApexPages.addMessage(errorMessage);
}
}
public void setFile()
{
system.debug('csvAsString  :'+csvAsString);
system.debug('csvFileBody  :'+csvFileBody);
if(uploadedFiles.contains(csvAsString)) {
// isCSV = true;
ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.Severity.Warning,'This CSV file is already uploaded. Please select a different file to upload or Click on IMPORT PRODUCTS.');
ApexPages.addMessage(errorMessage);
}
else{
isCSV = false;
validateCSVFile();
}
}
/*  on close return to Proposal */
public PageReference  returntoquote(){
if(cartId!= null) {
Apttus_CPQApi.CPQ.AbandonCartRequestDO request = new Apttus_CPQApi.CPQ.AbandonCartRequestDO();
request.CartId = cartId;
Apttus_CPQApi.CPQ.AbandonCartResponseDO response = Apttus_CPQApi.CPQWebService.abandonCart(request);
}
PageReference pg = new PageReference('/'+proposalId);
pg.setRedirect(true);
return pg;
}
public PageReference close(){
PageReference pg = new PageReference('/'+proposalId);
pg.setRedirect(true);
return pg;
}
public PageReference goToCart(){
// String finalString = Nokia_CPQ_Constants.BLANK_STRING_WITHOUT_SPACE;
// String retResult = Nokia_CPQ_Constants.BLANK_STRING_WITHOUT_SPACE;
// String baseUrl = System.URL.getSalesforceBaseUrl().ToExternalForm();
// if(proposal.Quote_Type__c == DIRECT_CPQ) {
//  retResult = proposal.APTS_ConfigureProductsTP__c;
// }
// else if(proposal.Quote_Type__c == INDIRECT_CPQ) {
//  retResult = proposal.Configure_button_field__c;
//  retResult = retResult.replace('Apttus_QPConfig__ProposalConfiguration','Apttus_Lightning_Page_Redirect');
// }
PageReference pg = new PageReference(Nokia_CPQ_Utility.updateQuoteAndRedirect(proposal));
pg.setRedirect(true);
return pg;
}
}