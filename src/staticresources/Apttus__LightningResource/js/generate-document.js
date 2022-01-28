/**
 * Callback after a template is selected
 * templateId the selected template id
 */
function onSelectTemplate(templateId) {
		
	// call the action
	doSelect(""+ templateId +"");
	
}
		
/**
 * Callback when the async generate action button is clicked
 */
function onAsyncGenerateActionClick() {
	// show the modal panel
	
	// return false to allow the action to proceed
	return false;
	
}

/**
 * Callback when the submit action button is clicked
 */
function onSubmitActionClick() {
	// show the modal panel
	// return false to allow the action to proceed
	return false;
	
}
			
/**
 * Go back to the detail page
 */
function goBack() {
	// get the agreement id
	var agreementId = "{!JSENCODE(agreementId)}";

	// go back to the detail page
	navigateTo("/" + agreementId);
	
}
		
/**
 * Cancel the generation
 */
function cancel() {
	// Go back to the detail page
	goBack();
	
}
		
/**
 * Callback after the document was downloaded
 */
function afterDownload() {
	
	// delay to allow the document to be downloaded	
	setTimeout(function() {
		
		// return to the agreement detail page
		//doReturn();
	}, 5000);
	
	// return true to allow the download to proceed
	return true;
	
}
		
/**
 * Callback after the timeout occurred
 */
function afterTimeout() {
	
	try {
		
		// get the timeout message
		var cMsg = "{!JSENCODE(TimeoutMessage)}";
		var message = "";
		var lines = cMsg.split("\\n");
		for (var i = 0; i < lines.length; i++) {
			if (i > 0) {
				message += "\n";
			}
			message += lines[i];
		}
		
		// hide modal panel
		
		// show timeout message
		if (confirm(message)) {
			// back to agreement detail page
			goBack();
			
		}
		
	} catch(ex) {
		erroralert(cERROR_UNKNOWN, ex);
		// back to agreement detail page
		goBack();
		
	} 
	
}
		
/**
 * Callback after generate is done
 */
function afterGenerate() {
	
	// cancel timeout
	cancelTimeout();
	
}

/**
 * Callback after the submit is done
 */
function afterSubmit() {
	
	try {
		
		// hide modal panel
		// get the confirmation message
		var message = "{!JSENCODE($Label.SubmitDocStatusMessage)}";
		// show confirmation message
		alert(message);
		
	} catch(ex) {
		erroralert(cERROR_UNKNOWN, ex);
		
	} finally {
		// back to agreement detail page
		goBack();
		
	}
	
}

/**
 * Cancel the timeout
 */
function cancelTimeout() {

	if (gTimeoutId != null) {
		clearTimeout(gTimeoutId);
		gTimeoutId = null;
		
	}
	
}

/**
 * Generate the document
 */
function doGenerateDoc() {
	
	var exception = null;
   
	try {
	
		var timeoutMillis = parseInt("{!CallTimeoutMillis}") - 2000;
		
		
		// delay to allow prepare step to run	
		setTimeout(function() {
			try {
				// generate the document
				generateDoc();
			} catch (e) {
				erroralert("generateDoc():", e);
				// back to agreement detail page
				goBack();
					
			} 
			
		}, 1000);
		
		// delay until timeout	
		gTimeoutId = setTimeout(function() {
						try {
							// handle timeout
							afterTimeout();
						} catch (e) {
							erroralert("afterTimeout():", e);
							// back to agreement detail page
							goBack();
							
						} 
			
					 }, timeoutMillis);
					 
	} catch(ex) {
		exception = ex;
		// hide modal panel
		
		erroralert("generateDoc():", ex);
		
	} finally {
		if (exception != null) {
			// back to agreement detail page
			goBack();
			
		} 
		
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
	initDocumentoutputFormats();
}
/**
 * Handle logic on Select templates when user click on the templats row.
 *
 */
function selectTemplateRow(id) {
	showWaiting();
	onSelectTemplate(id);
	$.each($(".slds-button") , function(){
		$(this).removeAttr("disabled");
	});
}
/**
 * Disable All buttons.
 *
 */
function disableActionButtons( ) {
	$.each($(".action-button") , function(){
		$(this).attr("disabled","true");
	});
}
/**
 * Handle logig on generate document button pressed.
 *
 */
function onGenerateDocument(timeOut) {
		showWaiting();
		console.log('Timeout Value '+timeOut );
		var exception = null;
	   
		try {
			console.log('Timeout Value '+timeOut );
			var timeoutMillis = parseInt(timeout) - 2000;
			console.log('Timeout timeoutMillis '+timeoutMillis );
			// delay to allow prepare step to run	
			setTimeout(function() {
				try {
					// generate the document
					console.log('In');
					generateDoc();
					console.log('agter');
				} catch (e) {
					erroralert("generateDoc():", e);
					// back to agreement detail page
					goBack();
				} 
			}, 1000);
			
			// delay until timeout	
			gTimeoutId = setTimeout(function() {
							try {
								// handle timeout
								afterTimeout();
							} catch (e) {
								erroralert("afterTimeout():", e);
								// back to agreement detail page
								goBack();
							} 
						 }, timeoutMillis);
						 
		} catch(ex) {
			exception = ex;
			// hide modal panel
			erroralert("generateDoc():", ex);
		} finally {
			if (exception != null) {
				// back to agreement detail page
				goBack();
			} 
		}
 }
/**
 * Initialise the document output formats and apply required classses
 *
 */
function initDocumentoutputFormats(){
	 $.each($("label:contains('DOC')") , function(){
			 $(this).addClass('doctype-card doc hide-lable');
	});
	$.each($("label:contains('DOCX')") , function(){
		$(this).addClass('doctype-card docx hide-lable');
	});
	
	
	$.each($("label:contains('RTF')") , function(){
		$(this).addClass('doctype-card rtf hide-lable');
	});
	 $.each($("label:contains('PDF')") , function(){
		$(this).addClass('doctype-card pdf hide-lable');
	});       
	$.each($("label:contains('PDF/A')") , function(){
		$(this).addClass('doctype-card pdfa hide-lable');
	});
	$.each($("label:contains('Inline PDF')") , function(){
		$(this).addClass('doctype-card inline-pdf hide-lable');
	});
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