({
	doInit : function(component, event, helper) {
        helper.hlpGetFieldHelp(component);
        helper.hlpGetField(component);
	},
	performLookup : function(component, event, helper) {
		helper.hlpPerformLookup(component);
	},
	selectItem : function(component, event, helper) {
        var index = event.currentTarget.dataset.index;
		helper.hlpSelectItem(component, index);
	},
	toggleMenu : function(component, event, helper) {
		helper.hlpToggleMenu(component);
	},
	checkValidity : function(component, event, helper) {
		helper.hlpCheckValidity(component);
	},
	setHelpTextProperties : function(component, event, helper) {
		helper.hlpSetHelpTextProperties(component);
	},
	setInputValue : function(component, event, helper) {
		var selectedName = component.get("v.selectedName");
		document.getElementById(component.getGlobalId() + "_myinput").value = selectedName;
	},
	clearField : function(component, event, helper){
		helper.clearField(component,true);
		helper.toggleIcons(component,true);
	},
	/**
	 * support for highlighting suggestions using the up and down arrow
	 * support for selecting highlighted record by pressing Enter
	 */
	highlight : function(component, event, helper){
		var el = $('#lookup-65 ul li');
		var highlighted = $('#lookup-65 ul li.hlight');
		if(event.code == 'ArrowDown'){
			highlighted.removeClass('hlight').next().addClass('hlight');
			if(highlighted.next().length == 0){
				el.eq(0).addClass('hlight');
			}
		}
		else if(event.code == 'ArrowUp'){
			highlighted.removeClass('hlight').prev().addClass('hlight');
			if(highlighted.prev().length == 0){
				el.eq(-1).addClass('hlight')
			}
		}
		else if(event.code == 'Enter'){
			if($A.util.hasClass(component.find("dropDown"),'slds-is-open')){
				highlighted.click();
			}
		}
	},
	hover : function(component, event, helper){
		$('#lookup-65 ul li').removeClass('hlight')
	}
})