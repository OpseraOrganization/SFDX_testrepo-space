var jq = jQuery.noConflict();

jq(document).ready(function(){
	GBButtons.updateAndShowButtons();
	GBCustomThemeConfig.init();
	GBMixpanel.init(mpToken);
	GBMixpanel.track('Page View', {'Page': 'MCT'});
});

var GBCustomThemeConfig = (function(window, document, jq) {
	var TYPE_GLOBAL = 'Global',
		TYPE_GRID = 'Grid',
		_customThemeRecords, // array of custom theme objects
		_customThemeMap = {}, // key is custom theme id and value is custom theme object
		_editedCustomThemeMap = {}, // key is custom theme id and value is custom theme object
		_currentNewRowId = -1;
	
	function setProps(props) {

		// parse theme definitions
		for (var i = 0; i < props.customThemeRecords.length; i++) {
			props.customThemeRecords[i].themeBody = JSON.parse(props.customThemeRecords[i].themeBody); 
		}
		_customThemeRecords = props.customThemeRecords;
	}
	
	function init() {
		_buildCustomThemeList();
		_initEventHandlers();
		_showCustomTheme();
		// disable autocomplete at the form level (MS Edge seems to not respect autocomplete="off" at the input level)
		jq('.gbForm').attr('autocomplete', 'off');
	}
	
	function _showCustomTheme() {
		var themeId = _getParamValue('cid');
		
		if (themeId) {
			var row = jq('#customThemeList tr[id="'+ themeId + '"]');
			if (row.length > 0) {
				row.find('td.themeSummary').click();
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
		jq('#customThemeList').on('click', 'td.themeSummary', function (e) {
			_showThemeDetails(jq(this).parent('tr').attr('id'));
			_highlightRow(jq(this).parent('tr'));
			_updateEditedCustomThemeMap();
		});
		
		jq('.gbwPage').on('click', '.addNewBtn', function(e) {
			_insertNewThemeRow();
			GBMixpanel.track('New Theme', {'New Theme': ''});
		});
		
		jq('#customThemeList').on('click', 'span.minus', function(e) {
			_removeRow(jq(this).closest('tr'));
		});
		
		jq('.gbwPage').on('click', '.saveThemeBtn', function(e) {
			_beginSave(e);
		});
		
		jq('.gbwPage').on('click', '.deleteBtn', function(e) {
			_doDelete();
		});
		
		jq('#themeDetails').on('change', 'input, select', function() {
			_updateThemeList(jq(this));
			_clearInvalidFields();
			_updateEditedCustomThemeMap();
		});
		
		jq('#themeDetails').on('click', '.addLink', function() {
			_addNewThemeRuleItem();
			_updateThemeList(jq(this));
			_updateEditedCustomThemeMap();
		});
		
		jq('#themeDetails').on('click', '.clearLink', function() {
			_clearThemeRuleItem(jq(this));
			_updateThemeList(jq(this));
			_updateEditedCustomThemeMap();
		});
		
		jq('#themeDetails').on('click', '.colorPickerRow > div', function() {
			var elem = jq(this);
			
			if(elem.hasClass('selected')){
				// if we clicked a selected tile, unselect
				elem.removeClass('selected');
			}else{
				// if we clicked a not selected tile, select it
				elem.closest('.colorPickerDiv').find('.colorPickerRow > div').removeClass('selected');
				elem.addClass('selected');	
			}
			
			_updateThemeList(jq(this));
			_updateEditedCustomThemeMap();
		});

		jq('#themeDetails').on('change', '.hexCheckBox', function() {
			_toggleHexBox(jq(this));
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
		
		jq('#themeDetails .tooltip').tooltipster()
			// For keyboard accessibility
			.focus(function() {
		    jq(this).tooltipster('show');
			})
			.blur(function() {
		    jq(this).tooltipster('hide');
			});
		
		/* TODO: JA, implement resizable for #themeBody 
		jq('#themeBody').resizable({
			handles: 'se',
			minHeight: 300,
			minWidth: 400,
	    });*/
	}
	
	function _beginSave(e) {
		if (jq.isEmptyObject(_editedCustomThemeMap)) {
			alert('No changes since last save.');
			return;
		}
		var validationMessage = _validateInputs(); 
		if (validationMessage == null) {
			_doSave();
		} else {
			_showWarningMessage(jq('.saveThemeBtn'), 
					validationMessage, 
					e);
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
	
	function _clearThemeRuleItem(clearBtn){
		clearBtn.closest('.themeConfigItem').remove();
		
		// re-number items
		jq('#themeConfigContainer .themeConfigItem').each(function(index){
			var number = index + 1,
				item = jq(this);
			
			item.attr('data-index', number);
			item.find('.themeConfigIndex').text(number + '. ');
		});
	}
	
	function _doDelete() {
		var checkedRows = jq('#customThemeList input.themeCheck:checked'),
			idsToDelete = [],
			themeId,
			themeRecord,
			warningMessage = 'Delete selected theme? This will remove the custom functionality'
								+ ' from any associated grids.';
		
		if (checkedRows.length == 0) {
			alert('No records marked for deletion.');
			return;
		}
		
		checkedRows.each(function() {
			themeId = jq(this).closest('tr.themeRow').attr('id');
			themeRecord = (_editedCustomThemeMap[themeId] || _customThemeMap[themeId]);
			if (themeRecord.themeType == TYPE_GLOBAL) {
				warningMessage += ' Deleting the global theme will impact all grids.';
				
				return false; // break out of loop
			}
		});
		
		if (confirm(warningMessage)) {
			
			checkedRows.each(function() {
				idsToDelete.push(jq(this).closest('tr.themeRow').attr('data-recordId'));
			});
			
			jq('[id*="idsToDelete"]').val(JSON.stringify(idsToDelete));
			deleteCustomTheme();
		}
		return;
	}
	
	/**
	 * When edits are made to custom theme name or type, this function shows those edits 
	 * in the custom theme table and highlights the edited fields in orange.
	 */
	function _updateThemeList(jqElem) {
		var themeId = jq('#themeDetails').attr('data-themeId'),
			themeRow = jq('#customThemeList').find('tr#'+ themeId);
		
		if (jqElem.hasClass('themeSummary')) {
			themeRow.find('td.themeSummary').text(jqElem.val());
		} else if (jqElem.hasClass('themeType')) {
			themeRow.find('td.themeType').text(jqElem.val());
		}

		themeRow.find('td.themeSummary, td.themeType').addClass('orange');
	}
	
	/**
	 * Removes the orange highlight on fields in the custom theme table
	 * when fields are edited.
	 */
	function _clearInvalidFields() {
		var themeId = jq('#themeDetails').attr('data-themeId'),
			themeRow = jq('#customThemeList').find('tr#'+ themeId);
		if (jq('#themeDetails').find('input.themeSummary').val()) {
			themeRow.find('td.themeSummary').removeClass('red');
		}
		if (jq('#themeDetails').find('select.themeType').val()) {
			themeRow.find('td.themeType').removeClass('red');
		}
	}
	
	/**
	 * Builds the HTML for the custom theme table.
	 */
	function _buildCustomThemeList() {
		var customTheme,
			htmlArr = [];
		
		if (_customThemeRecords.length == 0) {
			return;
		}
		
		for (var i=0; i<_customThemeRecords.length; i++) {
			customTheme = _customThemeRecords[i];
			htmlArr = htmlArr.concat(_getRowHtml(customTheme, false));
		}
		
		jq('#customThemeList').append(htmlArr.join(''));
		jq('#customThemeList .themeListInfo').addClass('none');
	}
	
	/**
	 * Returns the HTML for a single custom theme row in the custom theme table. 
	 */
	function _getRowHtml(customTheme, isNewRow) {
		var htmlArr = [];
		htmlArr.push('<tr class ="themeRow" id="'+ customTheme.themeId +'" data-recordId="' + customTheme.recordId +'">');
		htmlArr.push('<td>');
		if (isNewRow) {
			htmlArr.push('<span class="minus">&nbsp;</span>');
		} else {
			htmlArr.push('<input class="themeCheck" type="checkbox"/>');
		}
		htmlArr.push('</td>');
		htmlArr.push('<td class="themeSummary">');
		htmlArr.push(customTheme.summary);
		htmlArr.push('</td>');
		htmlArr.push('<td class="themeType">');
		htmlArr.push(customTheme.themeType);
		htmlArr.push('</td>');
		htmlArr.push('</tr>');
		// map the record for lookup later
		_customThemeMap[customTheme.themeId] = customTheme;
		
		return htmlArr;
	}
	
	/**
	 * Adds a new row to the custom theme table when the New button is clicked.
	 * Defaults the summary (component name) and type of the new custom theme.
	 */
	function _insertNewThemeRow() {
		var customTheme = {},
			htmlArr = [];
		
		// set the defaults for new theme
		customTheme.themeId = _currentNewRowId;
		customTheme.summary = 'New theme';
		customTheme.themeType = 'Grid';
		customTheme.themeBody = [];
		
		htmlArr = htmlArr.concat(_getRowHtml(customTheme, true));
		
		_currentNewRowId--;
		
		jq('#customThemeList').append(htmlArr.join(''));
		jq('#customThemeList').find('#'+ customTheme.themeId +' td.themeSummary').addClass('orange').click();
		jq('#customThemeList .themeListInfo').addClass('none');
		
		// fire the change event so this new theme gets registered as an unsaved change
		jq('#themeDetails .inputs .themeSummary').change();
	}
	
	/**
	 * Removes a row from the custom theme table.
	 */
	function _removeRow(row) {
		delete _customThemeMap[row.attr('id')];
		delete _editedCustomThemeMap[row.attr('id')];
		jq('#themeDetails').removeAttr('data-themeId').addClass('none');
		jq('#themeDetails').find('input, select, textarea').val('');
		jq('#themeDetailsInfo').removeClass('none');
		row.remove();
		if (jq('#customThemeList').find('tr').length == 2) {
			// the last new theme row was removed, show the info message 
			jq('#customThemeList .themeListInfo').removeClass('none');
		}
	}
	
	function _updateEditedCustomThemeMap() {
		var themeId = jq('#themeDetails').attr('data-themeId'),
			editedCustomTheme = {};
		
		editedCustomTheme.summary = jq('#themeDetails').find('input.themeSummary').val();
		editedCustomTheme.themeType = jq('#themeDetails').find('select.themeType').val();
		editedCustomTheme.recordId = jq('#themeDetails').attr('data-recordId');
		editedCustomTheme.themeBody = [];

		// get theme rules
		jq('#themeConfigContainer .themeConfigItem').each(function(){
			var item = jq(this),
				elem,
				bgColor,
				textColor,
				isBgHex = item.find('.bgColorPicker .hexCheckBox').prop('checked'),
				isTextHex = item.find('.textColorPicker .hexCheckBox').prop('checked'),
				bgHexVal = item.find('.bgColorPicker .hexInput').val(),
				textHexVal = item.find('.textColorPicker .hexInput').val();
			
			elem = item.find('.elementDropdown').val();
			
			if(isBgHex){
				if(bgHexVal !== ''){
					bgColor = '#' + bgHexVal;	
				}
			}else{
				bgColor = item.find('.bgColorPicker .selected').attr('data-colorid');
			}

			if(isTextHex){
				if(textHexVal !== ''){
					textColor = '#' + textHexVal;
				}
			}else{
				textColor = item.find('.textColorPicker .selected').attr('data-colorid');
			}
			
			editedCustomTheme.themeBody.push({
				elem: elem,
				bgColor: bgColor,
				textColor: textColor
			});
		});

		_editedCustomThemeMap[themeId] = editedCustomTheme;
	}
	
	/**
	 * Checks if any custom theme is missing required fields, or if there are more than one 
	 * global JS or global CSS, and returns error messages accordingly.
	 */
	function _validateInputs() {
		var themeId,
			customTheme,
			editedCustomTheme,
			addedRequiredFieldsMessage = false,
			invalidIds = [],
			globalThemeIds = [],
			messages = [],
			uniqueElemArr = [],
			themeRule;
		
		for (themeId in _editedCustomThemeMap) {
			editedCustomTheme = _editedCustomThemeMap[themeId];
			uniqueElemArr = []; // reset

			// required fields
			if (!editedCustomTheme.summary || !editedCustomTheme.themeType || !editedCustomTheme.themeBody) {
				if (!addedRequiredFieldsMessage) {
					messages.push('Theme Name and Type are both required for all custom themes.');
					addedRequiredFieldsMessage = true; // only add this once
				}
				invalidIds.push(themeId);
			}

			// there should be at least one rule per theme
			if(editedCustomTheme.themeBody.length == 0){
				messages.push('Please add at least one rule to the ' + editedCustomTheme.summary + ' theme by clicking the blue "Add" link.');
			}
			
			// loop through theme rules
			for (var j =0; j<editedCustomTheme.themeBody.length; j++) {
				themeRule = editedCustomTheme.themeBody[j];
				
				// an element can be used once in a theme
				if(uniqueElemArr.indexOf(themeRule.elem) == -1){
					uniqueElemArr.push(themeRule.elem);	
				}else{
					messages.push('An element can only be used once in a theme. Please remove one of the "' + themeRule.elem 
						+ '" elements from the ' + editedCustomTheme.summary + ' theme.');
				}
				
				// each theme rule should have at least 1 color
				if(themeRule.bgColor == undefined && themeRule.textColor == undefined){
					messages.push('Each theme rule should have a background color or a text color. Please correct the ' + editedCustomTheme.summary + ' theme.');
					break;
				}
				
				// each theme should have an element selected
				if(themeRule.elem == undefined || themeRule.elem == "0"){
					messages.push('Each theme rule should have an element selected. Please correct the ' + editedCustomTheme.summary + ' theme.');
				}
			}
			
			if(editedCustomTheme.themeType == 'Global'){
				globalThemeIds.push(themeId);
			}
		}
		
		for (themeId in _customThemeMap) {
			customTheme = _customThemeMap[themeId];
			editedCustomTheme = _editedCustomThemeMap[themeId];
			
			if(customTheme.themeType == 'Global' && !editedCustomTheme){
				globalThemeIds.push(themeId);
			}
		}

		if (globalThemeIds.length > 1) {
			messages.push('There can only be one global theme.');
			invalidIds = invalidIds.concat(globalThemeIds);
		}
		
		if (messages.length > 0) {
			for (var i =0; i<invalidIds.length; i++) {
				jq('#customThemeList tr[id="'+ invalidIds[i] +'"] td').addClass('red');
			}
			return messages.join('<br/>');
		}
		return null;
	}
	
	function _doSave() {

		// stringify theme definitions
		for(var k in _editedCustomThemeMap){
			GBMixpanel.track('Save Theme', {
				'Scope': _editedCustomThemeMap[k].themeType,
				'Element Count': _editedCustomThemeMap[k].themeBody.length,
				'Elements': _editedCustomThemeMap[k].themeBody.map(function (item){return item.elem})
			});
			_editedCustomThemeMap[k].themeBody = JSON.stringify(_editedCustomThemeMap[k].themeBody);
		}
		
		jq('[id*="editedCustomThemeInput"]').val(JSON.stringify(_editedCustomThemeMap));
		GBMixpanel.trackSave();
		saveCustomTheme();
	}
	
	/**
	 * Loads the selected custom theme into the theme details section.
	 */
	function _showThemeDetails(themeId) {		
		var themeRecord = (_editedCustomThemeMap[themeId] || _customThemeMap[themeId]);
		
		jq('#themeDetails').attr('data-themeId', themeId);
		jq('#themeDetails').attr('data-recordId', themeRecord.recordId);
		jq('#themeDetails').find('input.themeSummary').val(_htmlUnescape(themeRecord.summary));
		jq('#themeDetails').find('select.themeType').val(themeRecord.themeType);
		
		jq('#themeDetails').find('input.themeSummary').focus();
		
		jq('#themeDetailsInfo').addClass('none');
		jq('#themeDetails').removeClass('none');

		_renderThemeConfigurator(themeRecord);
		_setThemeConfiguratorValues(themeRecord);
		
	}

	function _renderThemeConfigurator(theme){
		var container = jq('#themeConfigContainer'),
			htmlArr = [];

		// add default first row
		if(theme.themeBody.length == 0){
			htmlArr.push(_getThemeRuleItemHtml(1));
		}
		
		for (var i = 0; i < theme.themeBody.length; i++) {
			htmlArr.push(_getThemeRuleItemHtml(i+1));
		}

		htmlArr.push('<a class="addLink">Add</a>');
		
		container.empty().append(htmlArr.join(''));
	}
	
	function _setThemeConfiguratorValues(theme){
		jq('#themeConfigContainer .themeConfigItem').each(function(index){
			var item = jq(this),
				rule = theme.themeBody[index];
			
			if(rule == undefined){
				return; // it's the default empty rule
			}
			
			// set element
			item.find('.elementDropdown').val(rule.elem);

			// set colors
			if(rule.bgColor != undefined){
				var isBgHex = rule.bgColor.length > 2
					bgHexCheckBox = item.find('.bgColorPicker .hexCheckBox');
				if(isBgHex){
					bgHexCheckBox.prop('checked', true);
					_toggleHexBox(bgHexCheckBox);
					item.find('.bgColorPicker .hexInput').val(rule.bgColor.substring(1, rule.bgColor.length));
				}else{
					item.find('.bgColorPicker .color-'+rule.bgColor).addClass('selected');
				}
			}

			if(rule.textColor != undefined){
				var isTextHex = rule.textColor.length > 2,
					textHexCheckBox = item.find('.textColorPicker .hexCheckBox'); // TODO try saying that 3x very fast
				
				if(isTextHex){
					textHexCheckBox.prop('checked', true);
					_toggleHexBox(textHexCheckBox);
					item.find('.textColorPicker .hexInput').val(rule.textColor.substring(1, rule.textColor.length));
				}else{
					item.find('.textColorPicker .color-'+rule.textColor).addClass('selected');
				}
			}
			
		});
	}
	
	function _toggleHexBox(checkbox){
		var container = checkbox.closest('.colorPickerContainer'),
			isChecked = checkbox.prop('checked');
		
		if(isChecked){
			container.find('.colorPickerDiv').hide();
			container.find('.colorPickerDiv .selected').removeClass('selected');
			container.find('.hexInputContainer').show();
		}else{
			container.find('.colorPickerDiv').show();
			container.find('.hexInput').val('');
			container.find('.hexInputContainer').hide();
		}
		
	}
	
	function _addNewThemeRuleItem(){
		var lastItem = jq('#themeConfigContainer .themeConfigItem:last'),
			lastIndex = lastItem.attr('data-index') * 1,
			index = lastIndex + 1;
		
		if(lastItem.length > 0){
			lastItem.after(_getThemeRuleItemHtml(index));	
		}else{
			// if this is the first rule
			jq('#themeConfigContainer').prepend(_getThemeRuleItemHtml(1));
		}
	}
	
	function _getThemeRuleItemHtml(index){
		var htmlArr = [];
		
		htmlArr.push('<div class="themeConfigItem" data-index="'+index+'">');
		htmlArr.push('<div class="themeConfigRow">');

		htmlArr.push('<span class="themeConfigIndex">' + index + '. </span>');
		htmlArr.push('<select class="elementDropdown">');

		htmlArr.push('<option value="0">--Select--</option>');
		htmlArr.push('<option value="Parent headers">Parent headers</option>');
		htmlArr.push('<option value="Related object headers">Related object headers</option>');
		htmlArr.push('<option value="Data rows">Data rows</option>');
		htmlArr.push('<option value="Data row hover/selection">Data row hover/selection</option>');
		htmlArr.push('<option value="Summary rows">Summary rows</option>');
		htmlArr.push('<option value="Grouping rows">Grouping rows</option>');
		htmlArr.push('<option value="Buttons:Standard">Standard Buttons</option>');
		htmlArr.push('<option value="Buttons:Quick Filters">Quick Filter Buttons</option>');
		htmlArr.push('<option value="Buttons:Custom Actions">Custom Action Buttons</option>');

		htmlArr.push('</select>');
		htmlArr.push('<a class="clearLink">Clear</a>');
		htmlArr.push('</div>'); // themeConfigRow

		htmlArr.push('<div class="themeConfigRow clearfix">');
		htmlArr.push('<div class="bgColorPicker">'+_getColorPickerHtml('bgColor')+'</div>');
		htmlArr.push('<div class="textColorPicker">'+_getColorPickerHtml('textColor')+'</div>');
		htmlArr.push('</div>'); // themeConfigRow
		htmlArr.push('</div>'); // themeConfigItem
		
		return htmlArr.join('');
	}
	
	function _getColorPickerHtml(type){
		var htmlArr = [];

		htmlArr.push('<div class="colorPickerContainer">');
		htmlArr.push('<div class="colorPickerHeader">'+((type == 'bgColor') ? 'Background' : 'Text' )+' color:</div>');

		htmlArr.push('<div class="colorPickerDiv">');
		
		htmlArr.push('<div class="colorPickerRow">');
		for (var i = 1; i <= 6; i++) {
			htmlArr.push('<div class="color-'+i+'" data-colorId="'+i+'"></div>');
		}
		htmlArr.push('</div>'); // colorPickerRow


		htmlArr.push('<div class="colorPickerRow">');
		for (var j = 7; j <= 12; j++) {
			htmlArr.push('<div class="color-'+j+'" data-colorId="'+j+'"></div>');
		}
		htmlArr.push('</div>'); // colorPickerRow
		
		htmlArr.push('</div>'); // colorPickerDiv
		htmlArr.push('<input type="checkbox" class="hexCheckBox" name="isUseHex"/>Use hex code');
		htmlArr.push('<div class="hexInputContainer">#<input type="text" class="hexInput" name="hexCode" maxlength="6"/></div>');
		htmlArr.push('</div>'); // colorPickerContainer
		return htmlArr.join('');
	}
	
	function _highlightRow(clickedRow) {
		jq('#customThemeList tr').removeClass('highlightRow');
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
		TYPE_GLOBAL: TYPE_GLOBAL,
		TYPE_GRID: TYPE_GRID
	}
	
})(window, document, jq); // end GBCustomThemeConfig

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

		var props = _getCustomThemeProps();
		
		track('MCT Save', props);
	}
	
	function _getCustomThemeProps() {
		var hasGlobal = false,
			numberThemeComponents = 0,
			type;
		
		jq('#customThemeList .themeRow .themeType').each(function() {
			type = jq(this).text();
			
			if (type == GBCustomThemeConfig.TYPE_GLOBAL) {
				hasGlobal = true;
				numberThemeComponents++;
			} else if (type == GBCustomThemeConfig.TYPE_GRID) {
				numberThemeComponents++;
			}
		});
		
		return {'Has Global Themes': hasGlobal,
				'# Themes': numberThemeComponents};
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