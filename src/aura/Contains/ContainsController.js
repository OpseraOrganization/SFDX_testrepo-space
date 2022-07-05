({
	filter: function(component, event, helper) {
        let list = component.get('v.items'),
        	elements = component.get('v.elements'),
        	caseSensitive = component.get('v.caseSensitive'),
        	fullMatch = component.get('v.fullMatch');
        if(elements !== "" && elements){
            if(elements.constructor === Object || elements.constructor === Array){
                for(let i in elements){
                    for(let key in list){
                        if(helper.compare(elements[i], list[key], fullMatch, caseSensitive)) return component.set('v.condition', true);
                    }
                }
            }
            else {
                for(let key in list){
                    if(helper.compare(elements, list[key], fullMatch, caseSensitive)) return component.set('v.condition', true);
                }     
            }
        }
        component.set('v.condition', false);
    }
})