/****************************************************************
* Class Name : HWS_EmailQuote 
* Created Date: 25-12-2021
* Created By: TCS
* Description : This Class Contains Common logic for sending to VF pages  HWS_EmailQuote and HWS_PreviewPdf
* Modification Log:
---------------------------------------------------------
Modified By				 Modified For US#	Modified Date
Sabarinathan Nagarethinam	  HWSDDP-175		  15/12/2021
******************************************************************/

Public Without sharing class HWS_EmailQuoteHelper{  
	@InvocableMethod // HWSDDP-80
	Public Static void emailQuoteforStatus(list<id> quoteIds) {
		HWS_EmailQuote.emailQuote(quoteIds[0],false);  
		
	}
}