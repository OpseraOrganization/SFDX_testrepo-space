/*
 * Copyright © 2010-2019 Primal Cause, Inc. All rights reserved.
 * GridBuddy time functions for date picker
 */
function enableDatePicker(dataType, inputField, pConstrainInput){
	var constrainDateInput = (pConstrainInput!=false);
	
	if(dataType.toUpperCase() == 'DATE'){
		//enable date here
		jQuery(inputField).datepicker( 'destroy');
		jQuery(inputField).datepicker({
			changeMonth: true,
			changeYear: true,
			showOtherMonths: true,
			selectOtherMonths: true,
			constrainInput: constrainDateInput
		});
	}else if(dataType.toUpperCase() == 'DATETIME'){
		//enable datetime here
		jQuery(inputField).datepicker('destroy');
		jQuery(inputField).datepicker({
			changeMonth: true,
			changeYear: true,
			showOtherMonths: true,
			selectOtherMonths: true,
			onSelect: appendTime,
			constrainInput: constrainDateInput
		});
	} 	
}

function getCurrentDateFormatted() {
	var localeDateFormat = '';
	if (dateFormat) localeDateFormat = dateFormat;
	return jQuery.datepicker.formatDate(dateFormat, new Date());
}

/*
 * takes time in the locale format and returns it in 24 hour standard format: 14:48:00
 * the way we parse the 12 hour time, it can parse the china time too so we don't need 2 separate functions
 */
function parseTime(timeString) {

    if (currentLocale == ''
		|| currentLocale == 'en-US' 
		|| currentLocale == 'en-AU' 
		|| currentLocale == 'en-CA' 
		|| currentLocale == 'en-NZ' 
		|| currentLocale == 'ar' 
		|| currentLocale == 'el'
		|| currentLocale == 'zh-TW' 
    	|| currentLocale == 'zh-CN' 
		|| currentLocale == 'zh-HK' 
		|| currentLocale == 'ko') {
        timeString = parse12HourTime(timeString);
    } else {
    	timeString = parse24HourTime(timeString);
    }
    return timeString;

}
// takes a string in ' AM 3:45' or ' AM3:45' or ' 3:45 AM' format and returns it in '03:45:00' format
// this takes care of china time too
function parse12HourTime(timeString){
	var timeStringArray, 
		amPm;
		
	if(timeString.indexOf('AM') != -1){
		amPm = 'AM';
		timeString = timeString.replace('AM', '');
	}else{
		amPm = 'PM';
		timeString = timeString.replace('PM', '');
	}
	timeString = timeString.trim();
	
	timeStringArray = timeString.split(':');
	if(amPm == 'PM' && timeStringArray[0]<12){  // fix for: 12:10PM returns 00:10:00 but the retun value should be 12:10:00 since this is afternoon 12.10
		timeStringArray[0] = (timeStringArray[0] * 1) + 12;
		timeStringArray[0] = timeStringArray[0].toString();
	} else if((amPm == 'AM' && timeStringArray[0]==12)){  // fix for : 12.10AM returns 24:10:00 but the return value should be 00:10:00 since this is morning 12.10
		timeStringArray[0] = (timeStringArray[0] * 1) - 12;
		timeStringArray[0] = timeStringArray[0].toString();
	}
	timeStringArray[0] = ("0" + timeStringArray[0]).slice(-2); // we prepend a 0 and then use the .slice() function to get the last 2 digits
	timeString = timeStringArray.join(':');
	timeString = timeString + ':00';
	return timeString;
}

// takes a string in ' 3:45' format and returns it in '03:45:00' format
function parse24HourTime(timeString){
	var timeStringArray;
	
	timeString = timeString.trim();
	timeStringArray = timeString.split(':');
	timeStringArray[0] = ("0" + timeStringArray[0]).slice(-2); // we prepend a 0 and then use the .slice() function to get the last 2 digits
	timeString = timeStringArray.join(':');
	timeString = timeString + ':00';
	return timeString;
}

// TODO use time format from DateUtil.cls
function getCurrentTimeFormatted() {
	var currentTime = '';
	if(currentLocale == ''
		|| currentLocale == 'en-US'
		|| currentLocale == 'en-AU'
		|| currentLocale == 'en-CA'
		|| currentLocale == 'en-NZ'
		|| currentLocale == 'ar'
		|| currentLocale == 'el'){
		currentTime = get12HourTime();
	
	}else if(currentLocale == 'zh-TW'
			 || currentLocale == 'zh-CN'
			 || currentLocale == 'zh-HK'
			 || currentLocale == 'ko'){
		currentTime = getChinaTime(currentLocale);		 
	
	} else {
		currentTime = get24HourTime();
	}
	return currentTime;
}

function getTimeFormatted(dateWithTZ) {
	var currentTime = '';
	if(currentLocale == ''
		|| currentLocale == 'en-US'
		|| currentLocale == 'en-AU'
		|| currentLocale == 'en-CA'
		|| currentLocale == 'en-NZ'
		|| currentLocale == 'ar'
		|| currentLocale == 'el'){
		currentTime = get12HourTime(dateWithTZ);
		
	}else if(currentLocale == 'zh-TW'
			 || currentLocale == 'zh-CN'
			 || currentLocale == 'zh-HK'
			 || currentLocale == 'ko'){
		currentTime = getChinaTime(currentLocale, dateWithTZ);		 
	
	} else {
		currentTime = get24HourTime(dateWithTZ);

	}
	return currentTime;
} 


function disableDatePicker(inputField) {
	jQuery(inputField).datepicker('destroy');
}

function appendTime(dateText, inst){
	var timeElem = jQuery(this).parent().find('input.gbt');
	if(timeElem.length > 0) {
		if(timeElem.val().trim() == '') timeElem.val(getCurrentTimeFormatted());
		// required for UI to register the value has changed
		timeElem.change();
	} else {
		// in case of filters or conditional formatting
		jQuery(this).val(dateText + ' ' + getCurrentTimeFormatted());
		// required for UI to register the value has changed
		jQuery(this).change();
	}
}

function get12HourTime(dateWithTZ){
	var d = dateWithTZ ? dateWithTZ : new Date();
	var hours = d.getHours();
	var minutes = d.getMinutes();
	var amPm;
	var currentTime;
	if(hours == 0){
		hours = 12;
		amPm = 'AM';
	}else if(hours < 12){
		amPm = 'AM';
	}else {
		if (hours > 12) {
			hours -= 12;
		}
		amPm = 'PM';
	}
	if(minutes < 10){
		currentTime = hours + ':' + '0' + minutes + ' ' + amPm;
	}else{
		currentTime = hours + ':' + minutes + ' ' + amPm;
	}
	return currentTime; 		
}

function get24HourTime(dateWithTZ){
	var d = dateWithTZ ? dateWithTZ : new Date();
	var hours = d.getHours();
	var minutes = d.getMinutes();
	var currentTime;
	if(minutes < 10){
		currentTime = hours + ':' + '0' + minutes;
	}else{
		currentTime = hours + ':' + minutes;
	}
	return currentTime; 		
}

function getChinaTime(locale, dateWithTZ){
	var d = dateWithTZ ? dateWithTZ : new Date();
	var hours = d.getHours();
	var minutes = d.getMinutes();
	var amPm;
	var currentTime;
	if(hours == 0){
		hours = 12;
		amPm = 'AM';
	}else if(hours < 12){
		amPm = 'AM';
	}else {
		if (hours > 12) {
			hours -= 12;
		}
		amPm = 'PM';
	}
	
	if (minutes < 10) {
		minutes = '0' + minutes;
	}
	
	if(locale == 'zh-TW' || locale == 'ko'){
		currentTime = amPm + ' ' + hours + ':' + minutes;
	}else if(locale == 'zh-CN' || locale == 'zh-HK'){
		currentTime = amPm + hours + ':' + minutes;
	}
	return currentTime; 		
}
/*end GridBuddy time functions*/
