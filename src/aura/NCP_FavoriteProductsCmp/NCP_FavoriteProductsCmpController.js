({
    doInit: function(cmp, evt, hlp) {
        // var testList = [
        //     {
        //         Id: 'kdlsfkaf',
        //         Name: '1830 PSS-32 (Photonic Service Switch-32)'
        //     },
        //     {
        //         Id: 'kdlsfkaf',
        //         Name: '1830 PSS-32 (Photonic Service Switch-32)'
        //     },
        //     {
        //         Id: 'kdlsfkaf',
        //         Name: '1830 PSS-32 (Photonic Service Switch-32)'
        //     },
        //     {
        //         Id: 'kdlsfkaf',
        //         Name: '1830 PSS-32 (Photonic Service Switch-32)'
        //     },
        //     {
        //         Id: 'kdlsfkaf',
        //         Name: '1830 PSS-32 (Photonic Service Switch-32)'
        //     },
        //     {
        //         Id: 'kdlsfkaf',
        //         Name: '1830 PSS-32 (Photonic Service Switch-32)'
        //     },
        //     {
        //         Id: 'kdlsfkaf',
        //         Name: '1830 PSS-32 (Photonic Service Switch-32)'
        //     },
        //     {
        //         Id: 'kdlsfkaf',
        //         Name: '1830 PSS-32 (Photonic Service Switch-32)'
        //     },
        //     {
        //         Id: 'kdlsfkaf',
        //         Name: '1830 PSS-32 (Photonic Service Switch-32)'
        //     }
        // ];
        var action = cmp.get('c.loadFavoriteProducts');
        // this has been commented out to fix defect NOKIA-760
        // action.setStorable();
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === 'SUCCESS') {
                var favourites = hlp.sortFavourites(response.getReturnValue());
                cmp.set('v.favorite', favourites);
                cmp.set('v.isInitialised', true);
            }
        });
        $A.enqueueAction(action);
    },
    handleClick:function(component, event, helper) {
        var productId = event.target.id;
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": productId

        });
        navEvt.fire();
    }
})