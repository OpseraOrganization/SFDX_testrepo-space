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
				
		erroralert("prepareTemplate():", ex);
		
	} finally {
		
		if (exception != null) {
			
			// back to agreement detail page
			goBack();
			
		} 
		
	}
	
}

/**
 * Prepare email template
`* - clone selected email template
 * - clone and add selected attachments to the cloned template
 * - apply protection if applicable
 * - launch email author page
 */
 function prepareTemplate() {
	// temp email template
	var newTemplateId = null;
	// temporary object
	var tempObjectId = null;
	
	try {
		initCall();
		
		var applyProtection = ((protect == "true" && cPROTECTION_LEVEL_IGNORE != pLevel) || unprotect == "true");
		
		// clone email template
		newTemplateId = cloneEmailTemplate(selectedTemplateId);
		
		// associate selected attachments to the new email template
		var strIds = new String(attachmentIds);
		
		// Use a temp object to get around html editing security. 
		// copy attachments to a temp object and use the temp object for protect/unprotect operation. 
		// copy attachments back to the email template after the protect/unprotect operation is done.
		
		// create a temporary object
		if (applyProtection) {
			
			tempObjectId = createTemporaryObject();
			// copy attachments to the temporary object
			var tempAttIds = copyAttachments(tempObjectId, strIds.split(','));
		
			// apply/remove protection, if applicable
			if ((protect == "true") && (cPROTECTION_LEVEL_IGNORE != pLevel)) { 
				protectTemporaryDocs(tempObjectId, pLevel);
				
			} else if (unprotect == "true"){
				unprotectTemporaryDocs(tempObjectId);
				
			}
		
			// copy attachments to the email template
			copyAttachments(newTemplateId, tempAttIds);
			
		} else {
			
			// copy attachments to the email template
			copyAttachments(newTemplateId, strIds.split(','));
			
		}
		
		// substitute new template id and request email author page
		var tempId = newTemplateId.valueOf(0, 15);
		var url = emailAuthorURL.replace(/__NEW_TEMPLATE_ID_16CHARS__/g, tempId);

		// hide modal panel
		
		
		if('{!isSalesForce1}' == 'true') {
			sforce.one.navigateToURL(url);
		} else {
			// go to email author page
			navigateTo(url);
		}

	} catch(ex) {        
		
		erroralert("prepareTemplate()", ex);
		
		// delete temp email template if it was already created
		if (newTemplateId != null) {
			// invoke action on the controller
			invokeDoDeleteTempEmailTemplate(newTemplateId);
			
		}
		
		// back to agreement detail page
		goBack();
		
	} finally {
		
		// delete temp object if it was already created
		if (tempObjectId != null) {
			// invoke action on the controller
			invokeDoDeleteTempObject(tempObjectId);
			
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
