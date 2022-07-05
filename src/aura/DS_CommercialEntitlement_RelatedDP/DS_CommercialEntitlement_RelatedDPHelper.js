({
    
    getRelatedProductsHelper: function(component,event,helper){
        component.set('v.IsSpinner',true);
        component.set('v.showbutton', false);
        component.set('v.showmessage', false);
        component.set('v.MyProductfeatureList', null);
        component.set('v.showThankyou',false);
        component.set('v.IsSpinner',true);
        component.set('v.showConfirmmessage', false);
       component.set('v.showConfirmbuttonSection', true);

        
        component.set('v.showConfirmbutton', true);
        var action = component.get("c.relatedDigitalProposals")
        action.setParams({
            "currentRecordId": component.get("v.recordId"),
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            component.set('v.IsSpinner',false);
            if(state === 'SUCCESS' && component.isValid()){ 
                var result=response.getReturnValue();
                
                if(result==null || result==undefined || result==''||result.length==0)
                {
                    component.set("v.showConfirmbuttonSection",false);
                    component.set('v.showmessage', true);
                }
                
                if(result!=null &&result!=undefined &&result!=''&&result.length!=0){
                    component.set('v.DPData', response.getReturnValue());
                    var pageSize = component.get("v.pageSize");
                    component.set("v.totalRecords", component.get("v.DPData").length);
                    component.set("v.maxpagenumber",Math.ceil(component.get("v.DPData").length / pageSize));
                    component.set("v.startPage",0);
                    component.set("v.endPage",pageSize-1);
                    component.set("v.PAgenumber",Math.ceil(component.get("v.startPage")+1 / pageSize));
                    var PaginationList = [];
                    for(var i=0; i< pageSize; i++){
                        if(component.get("v.DPData").length> i)
                            PaginationList.push(response.getReturnValue()[i]);
                        
                    }
                    if(component.get("v.DPData").length>pageSize)
                          component.set('v.showbutton', true);
                    console.log('PaginationList>>'+JSON.stringify(PaginationList));
                    component.set('v.MyProductfeatureList', PaginationList);
                }
                
            }
            else{
                var   errors = response.getError();
                var errorpgmsg=JSON.stringify(errors);
                alert('Error  ++>'+errorpgmsg);
                
            }
        });
        $A.enqueueAction(action);
    },
    openconfirmbuttonhelper: function (component, event, helper) {
        var MyProductfeatureList = component.get("v.MyProductfeatureList");
        var needtouppdatelist=[];
        
        if(MyProductfeatureList!=null&&MyProductfeatureList!=undefined&&MyProductfeatureList!=''&&MyProductfeatureList.length!=0)
        { 
            for (var indexVar = 0; indexVar < MyProductfeatureList.length; indexVar++) {
                if (MyProductfeatureList[indexVar].isactivated!=MyProductfeatureList[indexVar].upsellitems.Status_In_Network__c)
                {
                    needtouppdatelist.push(MyProductfeatureList[indexVar].upsellitems);
                }
            }
        }
        
        if(needtouppdatelist!=null&&needtouppdatelist!=undefined&&needtouppdatelist!='')
            component.set("v.showConfirmbutton",false);
        
        if(needtouppdatelist==null|| needtouppdatelist==undefined|| needtouppdatelist=='')
            component.set("v.showConfirmbutton",true);
        
        return needtouppdatelist;
    },
    
    next : function(component, event){
        var sObjectList = component.get("v.DPData");
        var end = component.get("v.endPage");
        var start = component.get("v.startPage");
        var pageSize = component.get("v.pageSize");
        var PAgenumber = component.get("v.PAgenumber");
        var Paginationlist = [];
        var counter = 0;
        for(var i=end+1; i<end+pageSize+1; i++){
            if(sObjectList.length > i){
                Paginationlist.push(sObjectList[i]);
            }
            counter ++ ;
        }
        
        start = start + counter;
        end = end + counter;
        component.set("v.startPage",start);
        component.set("v.endPage",end);
        component.set("v.PAgenumber",PAgenumber+1);
        component.set('v.MyProductfeatureList', Paginationlist);
    },
    /*
     * Method will be called when use clicks on previous button and performs the 
     * calculation to show the previous set of records
     */
    previous : function(component, event){
        var sObjectList = component.get("v.DPData");
        var end = component.get("v.endPage");
        var start = component.get("v.startPage");
        var pageSize = component.get("v.pageSize");
        var PAgenumber = component.get("v.PAgenumber");
        var Paginationlist = [];
        var counter = 0;
        for(var i= start-pageSize; i < start ; i++){
            if(i > -1){
                Paginationlist.push(sObjectList[i]);
                counter ++;
            }else{
                start++;
            }
        }
        
        start = start - counter;
        end = end - counter;
        component.set("v.startPage",start);
        component.set("v.endPage",end);
        component.set("v.PAgenumber",PAgenumber-1);
        component.set('v.MyProductfeatureList', Paginationlist);
    },
    
    
})