/**
 * Display progress message and create/update necessary objects for email author page.
 */
function doPrepareEmailTemplate(emailTemplateId, attachIds, protectionLevel) {
				
	if ((emailTemplateId == null) || (emailTemplateId.length == 0)) {
		alert("Unable to locate Apttus out-of-the-box EmailTemplate (ApttusEmailTemplateForReviewSignatures).");
		
		return;
		
	} else {
		selectedTemplateId = emailTemplateId;
		
	}
	
	attachmentIds = attachIds;
	pLevel = protectionLevel;  			

	var exception = null;
   
	try { 
		// delay to allow the progress message to show	
		setTimeout("prepareTemplate()", 1000);

	} catch(ex) {                  
		
		exception = ex;
		// hide modal panel
		erroralert("prepareTemplate():", ex);
		
	} finally {
		
		if (exception != null) {
			
			// back to agreement detail page
			goBack();
			
		} 
		
	}
	
}

/**
 * Cancel the generation
 */
function cancel() {
	// Go back to the detail page
	goBack();
	
}        

/**
* Init SFDC Communication
*/
function initCall(sessionID) {
	
try {
		sforce.connection.sessionId = sessionID; //to avoid session timeout
	} catch(e) {
		erroralert(cERROR_UNKNOWN,e);
		goBack(); 
		
	}
}
/*
 *Initilise the spinner and show it.
 */
function showWaiting(){
	$('.spinner').show();
}
/*
 *Initilise the spinner and hide it.
 */
function endWaiting(){
	$('.spinner').hide();			
}
/**
 * Initilise Table selector
 */
function initTableSelector()
{
$(document).on('click','.temContent',function() {
		 $.each($('.selectedTr'),function() {
			 $(this).removeClass('selectedTr');
		 });
		 
		 $.each($('.selectedTd'),function() {
			 $(this).removeClass('selectedTd');
		 });
		 
		 var rowElem = $(this);   
		 
		 $(rowElem).addClass('selectedTr'); 
		 $.each($(rowElem).children(),function() {
			 $(this).addClass('selectedTd') ; 
		 });
	});	
}