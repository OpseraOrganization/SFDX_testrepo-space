({

    /*setProducts: function(component){
        var searchedView = component.get('v.listViewName');
        component.set("v.sortAsc",false);
        //console.dir('### AES ask '+component.get("v.sortAsc"));
        var action = component.get("c.getProducts");
        action.setStorable();
        action.setParams({
            listView : searchedView
        });
        var self = this; 
        action.setCallback(this, function(result) {
            var records = result.getReturnValue();
            component.set("v.allProducts", records);
            //console.dir('### AES records.length '+records.length);
            component.set("v.maxPage", Math.floor((records.length+9)/10));
            self.sortBy(component, "Name");
        });
        //console.dir('### do init table');
        //console.dir('### AES ask '+component.get("v.sortAsc"));
        $A.enqueueAction(action);
    },*/
    sortBy: function(component, field) {
        console.dir('### do init table '+component.get("v.sortAsc"));
        var sortAsc = component.get("v.sortAsc"),
        sortField = component.get("v.sortField"),
        records = component.get("v.currentList");
        sortAsc = sortField != field || !sortAsc;
        records.sort(function(a,b){
            var t1 = a[field] == b[field],
                t2 = (!a[field] && b[field]) || (a[field] < b[field]);
            return t1? 0: (sortAsc?-1:1)*(t2?1:-1);
        });
        component.set("v.sortAsc", sortAsc);
        component.set("v.sortField", field);
        component.set("v.currentList", records);
        console.dir(records);
    },    
    saveFavoriteProducts: function(component, id , isSelected) {
        var action = component.get("c.saveFavoriteProducts");        
        action.setParams({
            Id : id,
            selected : isSelected
        });      
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var results = response.getReturnValue();
            }
        });
        $A.enqueueAction(action); 
    }
    
})