({
	compare : function(object, target, fullMatch, caseSensitive) {
        let result = false;
        if(object.constructor === target.constructor) {
            if(object.constructor === String){
                if( fullMatch && object === target && caseSensitive ||
                   !fullMatch && target.indexOf(object) != -1 && caseSensitive || 
                   fullMatch && object.toLowerCase() === target.toLowerCase() && !caseSensitive ||
                   !fullMatch && target.toLowerCase().indexOf(object.toLowerCase()) != -1 && !caseSensitive )
                    result= true;
            }
            else if(object.constructor === Object || object.constructor === Array){
                if(JSON.stringify(object) === JSON.stringify(target)) result= true;
            }
            else {
                if(object == target) result= true;
            }
        }
        return result;
	}
})