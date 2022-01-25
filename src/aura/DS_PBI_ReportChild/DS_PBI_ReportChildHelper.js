({
	loadReportDataNew : function(component,event,helper,accessToken,reportId,reportURL) {
        		console.log('loadReportDataNew');              
                var PBIReportURL=reportURL;
                console.log('*****ReportId**********{!reportId}'+reportId);
                console.log('*****Report URL**********{!ReportURL}'+reportURL);
                var filter = {
                    $schema: "http://powerbi.com/product/schema#basic"
                };
                console.log('********After filter***********');
                console.log('After filter');
                var embedConfiguration = {
                    
                    type: 'report',
                    
                    id: reportId,
                    
                    embedUrl: PBIReportURL,
                    
                    settings: {
                        
                        filterPaneEnabled: false,
                        
                        navContentPaneEnabled: true
                        
                    }
                };
              
                powerbi.accessToken = accessToken;
                console.log('********powerbi.accessToken*********'+powerbi.accessToken);
                console.log('*******Before finding report********');
                var element = component.find('myReport').getElement();
                console.log('****Element found********'+element);
        		console.log('****embedConfiguration********'+JSON.stringify(embedConfiguration));
                var report = powerbi.embed(element, embedConfiguration);
        		console.log('****report********'+report);
        		console.log('*********Before embeding the report******');
                
	}
})