({
    createTable: function(component,event, resultData) {
        if ( $.fn.DataTable.isDataTable("#searchworkgroupByUserId") ) {
            $('#searchworkgroupByUserId').DataTable().clear().destroy();
        }
        else {
            var table=$('#searchworkgroupByUserId').DataTable({
                data:resultData,
                "columns" :[
                    {title:"Workgroup Name","data":"workgroupName","defaultContent": ""},                            
                    {title:"Level Of Support","data":"levelOfSupport","defaultContent": ""},                           
                    {title:"Role","data":"userRole","defaultContent": ""},
                    {title:"Workgroup Type","data":"workgroupType","defaultContent": ""},                            
                    {title:"Workgroup Manager","data":"workgroupManager","defaultContent": ""},                           
                    {title:"Workgroup Admin","data":"workgroupAdmin","defaultContent": ""},
                    {title:"Workgroup Business Hours","data":"workgroupBusinessHours","defaultContent": ""},                            
                    {title:"User Is Scheduled","data":"scheduled","defaultContent": ""},                           
                    
                ],
                "stripeClasses": [],                                                                                        
                "autoWidth": false
                
            });
        }     
    },
})