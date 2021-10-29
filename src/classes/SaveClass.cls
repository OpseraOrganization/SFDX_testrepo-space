public with sharing class SaveClass{
 private ApexPages.StandardController controller;
 public String retURL {get; set;}
 public String saveNewURL {get; set;}
 public String rType {get; set;}
 public String cancelURL {get; set;}
 public String ent {get; set;}
 public String confirmationToken {get; set;}

 public SaveClass(ApexPages.StandardController controller) {
  this.controller = controller;
  retURL = ApexPages.currentPage().getParameters().get('retURL');
  rType = ApexPages.currentPage().getParameters().get('RecordType');
  cancelURL = ApexPages.currentPage().getParameters().get('cancelURL');
  ent = ApexPages.currentPage().getParameters().get('ent');
  confirmationToken = ApexPages.currentPage().getParameters().get('_CONFIRMATIONTOKEN');
  saveNewURL = ApexPages.currentPage().getParameters().get('save_new_url');
  
 }
 
 public PageReference redirect(){
  
  PageReference returnURL;
  // Redirect if Record Type corresponds to custom VisualForce page
  if(rType == '012a0000001ZPAK')//012e0000000Co5P
   {
   returnURL = new PageReference('/apex/VOCObservational');
  }
  else if(rType == '012a0000001ZPAJ') //012e0000000Co5K
  {
   returnURL = new PageReference('/apex/VOCAnecdotal');
  }
  else if(rType == '012a0000001ZPAL') //012e0000000Co5U
  {
   returnURL = new PageReference('/apex/VOCTraditional');
  }
  else {
   returnURL = new PageReference('/a4J/e');
  }
  returnURL.getParameters().put('retURL', retURL);
  returnURL.getParameters().put('RecordType', rType);
  returnURL.getParameters().put('cancelURL', cancelURL);
  returnURL.getParameters().put('ent', ent);
  returnURL.getParameters().put('_CONFIRMATIONTOKEN', confirmationToken);
  returnURL.getParameters().put('save_new_url', saveNewURL);
  returnURL.getParameters().put('nooverride', '1');
  returnURL.setRedirect(true);
  return returnURL;
 }
 public PageReference cancel() {
          PageReference pr = new PageReference('/a4J/o');
          pr.setRedirect(true);
          return pr;
     }

}