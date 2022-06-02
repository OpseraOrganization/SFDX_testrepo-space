({
    loadReportData : function(component,event,helper,accessToken) {
        
        var PBIReportURL='https://app.powerbi.com/reportEmbed?reportId=41ce4df4-e935-47be-9468-9db1af041791&groupId=c2fc73b7-1680-4cc6-b3af-23a2156e75dd';
        console.log('*****ReportId**********{!reportId}');
        console.log('*****Report URL**********{!ReportURL}');
        //var token = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6Imk2bEdrM0ZaenhSY1ViMkMzbkVRN3N5SEpsWSIsImtpZCI6Imk2bEdrM0ZaenhSY1ViMkMzbkVRN3N5SEpsWSJ9.eyJhdWQiOiJodHRwczovL2FuYWx5c2lzLndpbmRvd3MubmV0L3Bvd2VyYmkvYXBpIiwiaXNzIjoiaHR0cHM6Ly9zdHMud2luZG93cy5uZXQvNWQ0NzE3NTEtOTY3NS00MjhkLTkxN2ItNzBmNDRmOTYzMGIwLyIsImlhdCI6MTUzOTg2MzAxOCwibmJmIjoxNTM5ODYzMDE4LCJleHAiOjE1Mzk5NDk3MTcsImFjciI6IjEiLCJhaW8iOiI0MlJnWUxDYVdWcldkNGYvczRPZTE4VE9mOWQzMWl5eDcydU4zMUhsZVhqRGMyYXhHZXdBIiwiYWx0c2VjaWQiOiI1OjoxMDAzN0ZGRTk5QTdDQ0RFIiwiYW1yIjpbInB3ZCJdLCJhcHBpZCI6IjZmYzg3N2RlLThmMzAtNDU3ZS04ZDk3LWY5YzNjNzYyMjkwOCIsImFwcGlkYWNyIjoiMSIsImVtYWlsIjoia2VzaGF2YS5wcmF2ZWVuLmQubkBhY2NlbnR1cmUuY29tIiwiaG9tZV9vaWQiOiJjMjZhMjY1ZS01Y2FlLTQyNjYtYjlmMi1kODAxYmJkNTg4NTciLCJpZHAiOiJodHRwczovL3N0cy53aW5kb3dzLm5ldC9lMDc5M2QzOS0wOTM5LTQ5NmQtYjEyOS0xOThlZGQ5MTZmZWIvIiwiaXBhZGRyIjoiMTcwLjI1MS4xNTQuMTAxIiwibmFtZSI6Iktlc2hhdmEgUHJhdmVlbiBEIE4iLCJvaWQiOiJlN2IwMGNkNy0yZmU2LTRjNGEtYTc0My1iNDNjN2RiOGYwMTEiLCJwdWlkIjoiMTAwMzdGRkVBMjU2ODYwNCIsInNjcCI6IkRhc2hib2FyZC5SZWFkLkFsbCBEYXRhc2V0LlJlYWQuQWxsIEdyb3VwLlJlYWQgR3JvdXAuUmVhZC5BbGwgTWV0YWRhdGEuVmlld19BbnkgUmVwb3J0LlJlYWQuQWxsIiwic3ViIjoicGZqeW9rNFlIV1p4dTdrWTgtZ2NJVkxmcklBdWRKVlUwRXVKaVhMbUU3dyIsInRpZCI6IjVkNDcxNzUxLTk2NzUtNDI4ZC05MTdiLTcwZjQ0Zjk2MzBiMCIsInVuaXF1ZV9uYW1lIjoia2VzaGF2YS5wcmF2ZWVuLmQubkBhY2NlbnR1cmUuY29tIiwidXRpIjoiTUJEN0w2Z1k5VXlNcEgyRm54RVhBQSIsInZlciI6IjEuMCJ9.cwRY-r3pq_aOkkfgPOx2Mlu1WiAYG9h3aHf8eCUs-llpHklCM622nAjcfXb7I2EDdDyFTFGef2yXJjniqhpf5GIbwABFVT02mTIBMFdtntzvB5TJvTsk_jS46fkVVUEqCC749LySi89XgXnVXjoH1lPgjri_FDceuJ26_sIq0F01yY7pesREXxOJ1BEurvGBhjt63uLumPgb0_iT8-J7LLOGPEuSgIESzEtK3UJlBEOfSw5VxtOrKa0Izuyt-cphM-YaagLFoM4RxC7tJp_kK5ptB_cSrTf2jCkiDJRu9d2pZ027wOge0OBDEv1y5hOM9_GQxzTx9jZANoFx8iqVpA';
        var filter = {
            $schema: "http://powerbi.com/product/schema#basic"
        };
        console.log('********After filter***********');
        console.log('After filter');
        var embedConfiguration = {
            
            type: 'report',
            
            id: '41ce4df4-e935-47be-9468-9db1af041791',
            
            
            
            embedUrl: PBIReportURL,
            
            settings: {
                
                filterPaneEnabled: false,
                
                navContentPaneEnabled: true
                
            }
        };
        
        powerbi.accessToken = accessToken;
        //powerbi.accessToken = token;
        console.log('********powerbi.accessToken*********'+powerbi.accessToken);
        console.log('*******Before finding report********');
        var element = component.find('myReport').getElement();
        console.log('****Element found********');
        var report = powerbi.embed(element, embedConfiguration);
        console.log('*********Before embeding the report******');
    }, 
    loadReportDataNew : function(component,event,helper,accessToken,reportId,reportURL) {
        console.log('loadReportDataNew');
        var PBIReportURL=reportURL;
        console.log('*****ReportId**********{!reportId}'+reportId);
        console.log('*****Report URL**********{!ReportURL}'+reportURL);
        //var token = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6Imk2bEdrM0ZaenhSY1ViMkMzbkVRN3N5SEpsWSIsImtpZCI6Imk2bEdrM0ZaenhSY1ViMkMzbkVRN3N5SEpsWSJ9.eyJhdWQiOiJodHRwczovL2FuYWx5c2lzLndpbmRvd3MubmV0L3Bvd2VyYmkvYXBpIiwiaXNzIjoiaHR0cHM6Ly9zdHMud2luZG93cy5uZXQvNWQ0NzE3NTEtOTY3NS00MjhkLTkxN2ItNzBmNDRmOTYzMGIwLyIsImlhdCI6MTUzOTg2MzAxOCwibmJmIjoxNTM5ODYzMDE4LCJleHAiOjE1Mzk5NDk3MTcsImFjciI6IjEiLCJhaW8iOiI0MlJnWUxDYVdWcldkNGYvczRPZTE4VE9mOWQzMWl5eDcydU4zMUhsZVhqRGMyYXhHZXdBIiwiYWx0c2VjaWQiOiI1OjoxMDAzN0ZGRTk5QTdDQ0RFIiwiYW1yIjpbInB3ZCJdLCJhcHBpZCI6IjZmYzg3N2RlLThmMzAtNDU3ZS04ZDk3LWY5YzNjNzYyMjkwOCIsImFwcGlkYWNyIjoiMSIsImVtYWlsIjoia2VzaGF2YS5wcmF2ZWVuLmQubkBhY2NlbnR1cmUuY29tIiwiaG9tZV9vaWQiOiJjMjZhMjY1ZS01Y2FlLTQyNjYtYjlmMi1kODAxYmJkNTg4NTciLCJpZHAiOiJodHRwczovL3N0cy53aW5kb3dzLm5ldC9lMDc5M2QzOS0wOTM5LTQ5NmQtYjEyOS0xOThlZGQ5MTZmZWIvIiwiaXBhZGRyIjoiMTcwLjI1MS4xNTQuMTAxIiwibmFtZSI6Iktlc2hhdmEgUHJhdmVlbiBEIE4iLCJvaWQiOiJlN2IwMGNkNy0yZmU2LTRjNGEtYTc0My1iNDNjN2RiOGYwMTEiLCJwdWlkIjoiMTAwMzdGRkVBMjU2ODYwNCIsInNjcCI6IkRhc2hib2FyZC5SZWFkLkFsbCBEYXRhc2V0LlJlYWQuQWxsIEdyb3VwLlJlYWQgR3JvdXAuUmVhZC5BbGwgTWV0YWRhdGEuVmlld19BbnkgUmVwb3J0LlJlYWQuQWxsIiwic3ViIjoicGZqeW9rNFlIV1p4dTdrWTgtZ2NJVkxmcklBdWRKVlUwRXVKaVhMbUU3dyIsInRpZCI6IjVkNDcxNzUxLTk2NzUtNDI4ZC05MTdiLTcwZjQ0Zjk2MzBiMCIsInVuaXF1ZV9uYW1lIjoia2VzaGF2YS5wcmF2ZWVuLmQubkBhY2NlbnR1cmUuY29tIiwidXRpIjoiTUJEN0w2Z1k5VXlNcEgyRm54RVhBQSIsInZlciI6IjEuMCJ9.cwRY-r3pq_aOkkfgPOx2Mlu1WiAYG9h3aHf8eCUs-llpHklCM622nAjcfXb7I2EDdDyFTFGef2yXJjniqhpf5GIbwABFVT02mTIBMFdtntzvB5TJvTsk_jS46fkVVUEqCC749LySi89XgXnVXjoH1lPgjri_FDceuJ26_sIq0F01yY7pesREXxOJ1BEurvGBhjt63uLumPgb0_iT8-J7LLOGPEuSgIESzEtK3UJlBEOfSw5VxtOrKa0Izuyt-cphM-YaagLFoM4RxC7tJp_kK5ptB_cSrTf2jCkiDJRu9d2pZ027wOge0OBDEv1y5hOM9_GQxzTx9jZANoFx8iqVpA';
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
        //powerbi.accessToken = token;
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