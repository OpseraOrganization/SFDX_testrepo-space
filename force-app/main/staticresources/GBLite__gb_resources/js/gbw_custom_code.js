var jq = jQuery.noConflict();

jq(document).ready(function(){
	GBButtons.updateAndShowButtons();
	GBCustomCodeConfig.init();
	GBMixpanel.init(mpToken);
	GBMixpanel.track('Page View', {'Page': 'MCC'});
});

var GBCustomCodeConfig = (function(window, document, jq) {
	var TYPE_GLOBAL_CSS = 'Global CSS',
		TYPE_GLOBAL_JS = 'Global JavaScript',
		TYPE_CSS = 'CSS',
		TYPE_JAVASCRIPT = 'JavaScript',
		SCOPE_TABS = 'Tabbed Page',
		SCOPE_GRIDS = 'Grid',
		_customCodeRecords, // array of custom code objects
		_customCodeMap = {}, // key is custom code id and value is custom code object
		_editedCustomCodeMap = {}, // key is custom code id and value is custom code object
		_currentNewRowId = -1,
		_editor;
	
	function setProps(props) {
		_customCodeRecords = props.customCodeRecords;
	}
	
	function init() {
		_buildCustomCodeList();
		_initCodeEditor();
		_initEventHandlers();
		_showCustomCode();
		// disable autocomplete at the form level (MS Edge seems to not respect autocomplete="off" at the input level)
		jq('.gbForm').attr('autocomplete', 'off');
	}
	
	function _initCodeEditor() {
		_editor = ace.edit("codeBody");
        _editor.setTheme("ace/theme/chrome");
        _editor.$blockScrolling = Infinity; // setting this makes it so the editor doesn't scroll to the bottom when code content is longer than the editor's height
	}
	
	function _showCustomCode() {
		var codeId = _getParamValue('cid');
		
		if (!codeId) {
		    codeId = localStorage.getItem('lastAccessedCustomCodeId');
		}
		
		if (codeId) {
			var row = jq('#customCodeList tr[id="'+ codeId + '"]');
			if (row.length > 0) {
				row.find('td.codeSummary').click();
			}
		}
	}
	
	// from gb.js
	function _getParamValue(paramName) {
		var urlParams = window.location.search,
			paramValue = '';
		
		if (urlParams) {
			var paramArray = urlParams.split('&');
			
			jq.each(paramArray, function(i, item) {
				if (item.match(paramName + '=')) {
					paramValue = item.substring(item.indexOf('=') + 1);		
					return false;  
				}
			})
		};
		return paramValue;
	}
	
	function _initEventHandlers() {
		jq('#customCodeList').on('click', 'td.codeSummary', function(e) {
            _showCodeDetails(jq(this).parent('tr').attr('id'));
            _highlightRow(jq(this).parent('tr'));
        });
		
		jq('.gbwPage').on('click', '.addNewBtn', function(e) {
			_insertNewCodeRow();
		});
		
		jq('#customCodeList').on('click', 'span.minus', function(e) {
			_removeRow(jq(this).closest('tr'));
		});
		
		jq('.gbwPage').on('click', '.saveCodeBtn', function(e) {
			_beginSave(e);
		});
		
		jq('.gbwPage').on('click', '.deleteBtn', function(e) {
			_doDelete();
		});
		
		jq('#codeDetails').on('change', 'input, select', function() {
			_updateCodeList(jq(this));
			_clearInvalidFields();
			_updateEditedCustomCodeMap();
			if (jq(this).hasClass('codeType')) {
				_updateEditorMode(jq(this).val());				
			}
		});
		
		// handler for when the contents of the code editor change
		_editor.getSession().on('change', function(e) {
        	_clearInvalidFields();
        	_updateEditedCustomCodeMap();            	
        });
		
		jq('.closeX')
			.click(function() {
				_hideWarningMessage();
			})
			// For keyboard accessibility, 13 = Enter
			.keyup(function(e) {
				if (e.keyCode==13) {
					jq(this).trigger('click');
				}
			});
		
		jq(document).keyup(function(e) {
		  	// hide message or widget if escape key
		  	if (e.keyCode == 27) {
				_hideWarningMessage();
			} 
		});
		
		jq(document).keydown(function(event) {			
			if (!event) {
				event = window.event;
			}	
			
			if (event) {
				//ctrl s	
		    	if (event.keyCode==83 && (event.ctrlKey||event.metaKey)){
		    		_beginSave(event);
		    		event.preventDefault();
		    	}
			}
		});
		
		jq('#codeDetails .tooltip').tooltipster()
			// For keyboard accessibility
			.focus(function() {
		    jq(this).tooltipster('show');
			})
			.blur(function() {
		    jq(this).tooltipster('hide');
			});
		
		/* TODO: APM, implement resizable for #codeBody 
		jq('#codeBody').resizable({
			handles: 'se',
			minHeight: 300,
			minWidth: 400,
	    });*/
	}
	
	function _beginSave(e) {
		if (jq.isEmptyObject(_editedCustomCodeMap)) {
			alert('No changes since last save.');
			return;
		}
		var validationMessage = _validateInputs(); 
		if (validationMessage == null) {
			_doSave();
		} else {
			_showWarningMessage(jq('.saveCodeBtn'), 
					validationMessage, 
					e);
		}
	}
	
	function _updateEditorMode(selectedVal) {
		if (selectedVal.indexOf('JavaScript') > -1) {
			_editor.getSession().setMode("ace/mode/javascript");
		} else {
			_editor.getSession().setMode("ace/mode/css");
		}
	}
	
	function _showWarningMessage(pElemClicked, pMsg, pEvent) {
		var msgPopup = jq("#vldWarning"),
			currentPos = jq(pElemClicked).position();
		
		// set the message text
		msgPopup.find(".msgBody").html(pMsg);
		
		// position the popup based on the pElemClicked position
		msgPopup.css('top', (currentPos.top * 1 + 23));
		msgPopup.css('left', (currentPos.left * 1 + 10));
		msgPopup.show();
		pEvent.stopPropagation();
		
		// make message visible
		jq(window).scrollTop(currentPos.top);
	}

	function _hideWarningMessage() {
		if (jq("#vldWarning").is(':visible')==true) {
			jq("#vldWarning").hide();
		}
	}
	
	function _doDelete() {
		var checkedRows = jq('#customCodeList input.codeCheck:checked'),
			idsToDelete = [],
			codeId,
			codeRecord,
			warningMessage = 'Delete selected extension(s)? This will remove the functionality'
								+ ' from any associated grids or tabbed pages.';
		
		if (checkedRows.length == 0) {
			alert('No records marked for deletion.');
			return;
		}
		
		checkedRows.each(function() {
			codeId = jq(this).closest('tr.codeRow').attr('id');
			codeRecord = (_editedCustomCodeMap[codeId] || _customCodeMap[codeId]);
			if (codeRecord.codeType == TYPE_GLOBAL_CSS || codeRecord.codeType == TYPE_GLOBAL_JS) {
				warningMessage += ' Deleting global extensions will impact all ';
				
				if(codeRecord.codeScope == SCOPE_TABS){
					warningMessage += 'tabbed pages.';
				}else{
					warningMessage += 'grids.';
				}
				
				return false; // break out of loop
			}
		});
		
		if (confirm(warningMessage)) {
			
			checkedRows.each(function() {
				idsToDelete.push(jq(this).closest('tr.codeRow').attr('data-recordId'));
			});
			
			jq('[id*="idsToDelete"]').val(JSON.stringify(idsToDelete));
			deleteCustomCode();
		}
		return;
	}
	
	/**
	 * When edits are made to custom code name or type, this function shows those edits 
	 * in the custom code table and highlights the edited fields in orange.
	 */
	function _updateCodeList(jqElem) {
		if (jqElem.is('input') || jqElem.is('select')) {
			var codeId = jq('#codeDetails').attr('data-codeId'),
				codeRow = jq('#customCodeList').find('tr#'+ codeId);
			
			if (jqElem.hasClass('codeSummary')) {
				codeRow.find('td.codeSummary').text(jqElem.val());
			} else if (jqElem.hasClass('codeType')) {
				codeRow.find('td.codeType').text(jqElem.val());
			}

			codeRow.find('td.codeSummary, td.codeType').addClass('orange');
			
		}
	}
	
	/**
	 * Removes the orange highlight on fields in the custom code table
	 * when fields are edited.
	 */
	function _clearInvalidFields() {
		var codeId = jq('#codeDetails').attr('data-codeId'),
			codeRow = jq('#customCodeList').find('tr#'+ codeId);
		if (jq('#codeDetails').find('input.codeSummary').val()) {
			codeRow.find('td.codeSummary').removeClass('red');
		}
		if (jq('#codeDetails').find('select.codeType').val()) {
			codeRow.find('td.codeType').removeClass('red');
		}

		if (_editor.getValue()
				&& jq('#codeDetails').find('input.codeSummary').val()
				&& jq('#codeDetails').find('select.codeType').val()) {
			codeRow.find('td.codeSummary, td.codeType').removeClass('red');
		}
	}
	
	/**
	 * Builds the HTML for the custom code table.
	 */
	function _buildCustomCodeList() {
		var customCode,
			htmlArr = [];
		
		if (_customCodeRecords.length == 0) {
			return;
		}
		
		for (var i=0; i<_customCodeRecords.length; i++) {
			customCode = _customCodeRecords[i];
			htmlArr = htmlArr.concat(_getRowHtml(customCode, false));
		}
		
		jq('#customCodeList').append(htmlArr.join(''));
		jq('#customCodeList .codeListInfo').addClass('none');
	}
	
	/**
	 * Returns the HTML for a single custom code row in the custom code table. 
	 */
	function _getRowHtml(customCode, isNewRow) {
		var htmlArr = [];
		htmlArr.push('<tr class ="codeRow" id="'+ customCode.codeId +'" data-recordId="' + customCode.recordId +'" >');
		htmlArr.push('<td>');
		if (isNewRow) {
			htmlArr.push('<span class="minus">&nbsp;</span>');
		} else {
			htmlArr.push('<input class="codeCheck" type="checkbox"/>');
		}
		htmlArr.push('</td>');
		htmlArr.push('<td class="codeSummary">');
		htmlArr.push(customCode.summary);
		htmlArr.push('</td>');
		htmlArr.push('<td class="codeType">');
		htmlArr.push(customCode.codeType);
		htmlArr.push('</td>');
		htmlArr.push('</tr>');
		// map the record for lookup later
		_customCodeMap[customCode.codeId] = customCode;
		
		return htmlArr;
	}
	
	/**
	 * Adds a new row to the custom code table when the New button is clicked.
	 * Defaults the summary (component name) and type of the new custom code.
	 */
	function _insertNewCodeRow() {
		var customCode = {},
			htmlArr = [];
		
		// set the defaults for new code
		customCode.codeId = _currentNewRowId;
		customCode.summary = 'New extension';
		customCode.codeType = 'JavaScript';
		customCode.codeScope = 'Grid';
		customCode.codeBody = '';
		
		htmlArr = htmlArr.concat(_getRowHtml(customCode, true));
		
		_currentNewRowId--;
		
		jq('#customCodeList').append(htmlArr.join(''));
		jq('#customCodeList').find('#'+ customCode.codeId +' td.codeSummary').addClass('orange').click();
		jq('#customCodeList .codeListInfo').addClass('none');
		
		// fire the change event so this new code gets registered as an unsaved change
		jq('#codeDetails .inputs .codeSummary').change(); 
		
		// default the code editor to JS syntax since JS is our default type
		_editor.getSession().setMode("ace/mode/javascript");
	}
	
	/**
	 * Removes a row from the custom code table.
	 */
	function _removeRow(row) {
		delete _customCodeMap[row.attr('id')];
		delete _editedCustomCodeMap[row.attr('id')];
		jq('#codeDetails').removeAttr('data-codeId').addClass('none');
		jq('#codeDetails').find('input, select, textarea').val('');
		jq('#codeDetailsInfo').removeClass('none');
		row.remove();
		if (jq('#customCodeList').find('tr').length == 2) {
			// the last new code row was removed, show the info message 
			jq('#customCodeList .codeListInfo').removeClass('none');
		}
	}
	
	function _updateEditedCustomCodeMap() {
		var codeId = jq('#codeDetails').attr('data-codeId'),
			editedCustomCode = {};
		
		editedCustomCode.summary = jq('#codeDetails').find('input.codeSummary').val();
		editedCustomCode.codeType = jq('#codeDetails').find('select.codeType').val();
		editedCustomCode.codeScope = jq('#codeDetails').find('select.codeScope').val();
		editedCustomCode.codeBody = _editor.getValue();
		editedCustomCode.recordId = jq('#codeDetails').attr('data-recordId');

		_editedCustomCodeMap[codeId] = editedCustomCode;
	}
	
	/**
	 * Checks if any custom code is missing required fields, or if there are more than one 
	 * global JS or global CSS, and returns error messages accordingly.
	 */
	function _validateInputs() {
		var codeId,
			customCode,
			editedCustomCode,
			addedRequiredFieldsMessage = false,
			invalidIds = [],
			globalTabJSIds = [],
			globalGridJSIds = [],
			globalTabCSSIds = [],
			globalGridCSSIds = [],
			messages = [];
		
		for (codeId in _editedCustomCodeMap) {
			editedCustomCode = _editedCustomCodeMap[codeId];

			if (!editedCustomCode.summary || !editedCustomCode.codeType || !editedCustomCode.codeBody || !editedCustomCode.codeScope) {
				if (!addedRequiredFieldsMessage) {
					messages.push('Name, Type, and Code Body are required for all extensions.');
					addedRequiredFieldsMessage = true; // only add this once
				}
				invalidIds.push(codeId);
			}
			if (editedCustomCode.codeType == TYPE_GLOBAL_JS) {
				if(editedCustomCode.codeScope == SCOPE_TABS){
					globalTabJSIds.push(codeId);	
				}else{
					globalGridJSIds.push(codeId);
				}
			} else if (editedCustomCode.codeType == TYPE_GLOBAL_CSS) {
				if(editedCustomCode.codeScope == SCOPE_TABS){
					globalTabCSSIds.push(codeId);
				}else{
					globalGridCSSIds.push(codeId);
				}
			}
		}
		
		for (codeId in _customCodeMap) {
			customCode = _customCodeMap[codeId];
			editedCustomCode = _editedCustomCodeMap[codeId];
			
			if (customCode.codeType == TYPE_GLOBAL_JS && !editedCustomCode) {
				if(customCode.codeScope == SCOPE_TABS){
					globalTabJSIds.push(codeId);
				}else{
					globalGridJSIds.push(codeId);
				}
			} else if (customCode.codeType == TYPE_GLOBAL_CSS && !editedCustomCode) {
				if(customCode.codeScope == SCOPE_TABS){
					globalTabCSSIds.push(codeId);
				}else{
					globalGridCSSIds.push(codeId);
				}
			}
		}

		if (globalGridJSIds.length > 1) {
			messages.push('There can only be one Global JavaScript extension for Grids.');
			invalidIds = invalidIds.concat(globalGridJSIds);
		}

		if (globalGridCSSIds.length > 1) {
			messages.push('There can only be one Global CSS extension for Grids.');
			invalidIds = invalidIds.concat(globalGridCSSIds);
		}
		
		if (globalTabJSIds.length > 1) {
			messages.push('There can only be one Global JavaScript extension for Tabbed Pages.');
			invalidIds = invalidIds.concat(globalTabJSIds); 
		}
		
		if (globalTabCSSIds.length > 1) {
			messages.push('There can only be one Global CSS extension for Tabbed Pages.');
			invalidIds = invalidIds.concat(globalTabCSSIds); 
		}
		
		if (messages.length > 0) {
			for (var i =0; i<invalidIds.length; i++) {
				jq('#customCodeList tr[id="'+ invalidIds[i] +'"] td').addClass('red');
			}
			return messages.join('<br/>');
		}
		return null;
	}
	
	function _doSave() {
		jq('[id*="editedCustomCodeInput"]').val(JSON.stringify(_editedCustomCodeMap));
		GBMixpanel.trackSave();
		saveCustomCode();
	}
	
	/**
	 * Loads the selected custom code into the code details section.
	 */
	function _showCodeDetails(codeId) {		
		var codeRecord = (_editedCustomCodeMap[codeId] || _customCodeMap[codeId]);
		
		jq('#codeDetails').attr('data-recordId', codeRecord.recordId);
		jq('#codeDetails').attr('data-codeId', codeId);
		jq('#codeDetails').find('input.codeSummary').val(_htmlUnescape(codeRecord.summary));
		jq('#codeDetails').find('select.codeType').val(codeRecord.codeType);
		jq('#codeDetails').find('select.codeScope').val(codeRecord.codeScope || 'Grid');
		
		_updateEditorMode(codeRecord.codeType);
		
		_editor.setValue(_htmlUnescape(codeRecord.codeBody));
		_editor.clearSelection();
		jq('#codeDetails').find('input.codeSummary').focus();
		
		jq('#codeDetailsInfo').addClass('none');
		jq('#codeDetails').removeClass('none');
		
		localStorage.setItem('lastAccessedCustomCodeId', codeId);
	}
	
	function _highlightRow(clickedRow) {
		jq('#customCodeList tr').removeClass('highlightRow');
		clickedRow.addClass('highlightRow');
	}
	
	function _htmlUnescape(valueToUnescape) {
		if (valueToUnescape) {
			var unescapedString = valueToUnescape.replace(/&#39;/g, "'");
			unescapedString = unescapedString.replace(/&#34;/g, '"');
			unescapedString = unescapedString.replace(/&lt;/g, '<');
			unescapedString = unescapedString.replace(/&gt;/g, '>');
			unescapedString = unescapedString.replace(/&amp;/g, '&');
			return unescapedString;
		}
		return valueToUnescape;
	}
	
	return {
		setProps: setProps,
		init: init,
		TYPE_GLOBAL_CSS: TYPE_GLOBAL_CSS, 
		TYPE_GLOBAL_JS: TYPE_GLOBAL_JS,
		TYPE_CSS: TYPE_CSS,
		TYPE_JAVASCRIPT: TYPE_JAVASCRIPT
	}
	
})(window, document, jq); // end GBCustomCodeConfig

var GBMixpanel = (function(window, document, jq) {

	function init(token) {		 

		if (_getIsDisabled()) {
			return;
		}
		
		mixpanel.init(token, {
			cross_site_cookie: true
		});
	}
	
	function track(eventName, props) {
		 
		if (_getIsDisabled()) {
			return;
		}

		if (!props) {
			props = {};
		}
		
        var allProps = jq.extend({}, props, {
            "Org ID": orgId,
            "GridBuddy Edition": gbEdition,
            "GridBuddy Version": gridBuddyVersion,
            "User ID": userId,
            "User Type": abbreviatedUserType,
            "UI Theme": uiTheme,
            'User Language': userLanguage,
            'Lightning Style Enabled': lightningStylesEnabled,
            'OS Version': _getOSVersion()
        });

		mixpanel.track(eventName, allProps);
        
        mixpanel.people.set({
        	'User ID': userId,
            'User Type': uiTheme,
            'UI Theme': abbreviatedUserType,
            'User Language': userLanguage
        });
        
        mixpanel.identify(userId);
	}

	function _getOSVersion() {

		var OSversion = "Unknown OS";
		var ua = navigator.userAgent;

	  	if(ua && (ua.indexOf("Firefox") == -1)) {
	        var OSversionStr = navigator.appVersion;

	        if (OSversionStr.indexOf("Mac") != -1) {
	        	OSversion = OSversionStr.match(/([Mac]+.+)/)[1];
	        } else if (OSversionStr.indexOf("Windows")) {
	        	OSversion = OSversionStr.match(/([Windows]+.+)/)[1];
	        }
	    }  else if(ua.indexOf("Firefox") != -1 ) {
		    OSversion = navigator.oscpu;
		} 
		return OSversion;   
     }
	
	function trackSave() {
		 
		if (_getIsDisabled()) {
			return;
		}

		var props = _getCustomCodeProps();
		
		track('MCC Save', props);
	}
	
	function _getCustomCodeProps() {
		var props = {},
			hasGlobalJS = false,
			hasGlobalCSS = false,
			numberJSComponents = 0,
			numberCSSComponents = 0,
			type;
		
		jq('#customCodeList .codeRow .codeType').each(function() {
			type = jq(this).text();
			
			if (type == GBCustomCodeConfig.TYPE_GLOBAL_JS) {
				hasGlobalJS = true;
				numberJSComponents++;
			} else if (type == GBCustomCodeConfig.TYPE_GLOBAL_CSS) {
				hasGlobalCSS = true;
				numberCSSComponents++;
			} else if (type == GBCustomCodeConfig.TYPE_CSS) {
				numberCSSComponents++;
			} else if (type == GBCustomCodeConfig.TYPE_JAVASCRIPT) {
				numberJSComponents++;
			}
		});
		
		return {'Has Global JS': hasGlobalJS,
				'Has Global CSS': hasGlobalCSS,
				'# JS Components': numberJSComponents,
				'# CSS Components': numberCSSComponents};
	}
	
	function _getIsDisabled() {
		// don't run if Disable MPT is checked in custom setting or mixpanel is blocked by AdBlocker
		if (isTrackingDisabled || (typeof mixpanel == 'undefined')) {
			return true;
		}
		return false;
	}
	
	return {
		init: init,
		track: track,
		trackSave: trackSave
	};

})(window, document, jq); // end GBMixPanel