({
    doInit : function(component, event, helper) {
        
		helper.getTileDetail(component, event, helper);
         
	} ,
    onClick: function (component, event){
        var id = event.target.dataset.menuItemId;
        
        if (id) {
            component.getSuper().navigate(id);
        }
        else{
            var urlEvent = $A.get("e.force:navigateToURL");
            urlEvent.setParams({
                
        });
             urlEvent.fire();}
 },
    onClick1: function (component, event){
        var articleURL = window.location.href;
        var portalname=$A.get("$Label.c.DS_PortalCustomer");
        var swx = articleURL.includes("proposal/a3k");
        var DP = articleURL.includes("swx-upsell-proposal/a8h");
        var baseURL = articleURL.split(portalname);
        var tileOne = articleURL.includes("DP");
        var tab=$A.get("$Label.c.DSTabDP");
        var RMP= articleURL.includes("type=RMP");
		var tabRMP=$A.get("$Label.c.DSTabRMP");
        
        if(swx === true){
             component.set("v.pathURL",baseURL[0]+portalname+"s/swx-offer");
        }
        if(DP === true){
             component.set("v.pathURL",baseURL[0]+portalname+"s/digitalproposallist?"+tab+'&isfromBack=true');
        } if(RMP === true){
             component.set("v.pathURL",baseURL[0]+portalname+"s/catalogue?"+tabRMP+'&isfromBack=true');
        }  
        
 },
    menuItemsChanged: function (cmp, evt) {
        var menuItems = evt.getParam('value');
        menuItems.forEach(function (item) {
            if (item.label === 'Support') {
                item.label = 'Home';
            }
        });
        cmp.set('v.shadowMenuItems', menuItems);
    },
    gotoURL : function(component, event, helper) {
        helper.gotoURL(component);
    }
})