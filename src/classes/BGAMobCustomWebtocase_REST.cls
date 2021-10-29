@RestResource(urlMapping='/bgawebtocase/*')
global without sharing class BGAMobCustomWebtocase_REST {	
    @HttpPost
    global static void createCase(){
        RestRequest req = RestContext.request;
		RestResponse res = RestContext.response;
        String response;
        String requestBody;
        Case newCase;
        try{
            requestBody = req.requestBody.toString();
            Map<String,Object> jsonMap = (Map<String,Object>)JSON.deserializeUntyped(requestBody);
            res.addHeader('Content-Type', 'application/json');
            res.addHeader('Access-Control-Allow-Origin', '*');
            
            List<String> keyList = new List<String>{'phone','Email','Alter','make','location','serial','Tail', 'Model', 'Expdate', 'descrp', 'enc', 'strname', 'strusername'};
            List<String> dataList = new List<String>();
            for(String key : keyList){
                String val = jsonMap.get(key)!=Null?''+jsonMap.get(key):'';
                response+= '\n'+jsonMap.get(key);
                dataList.add(val);
            }
            newCase = BGAMobCustomWebtocase.insertCase(dataList[0], dataList[1], dataList[2], dataList[3], dataList[4], dataList[5], dataList[6], dataList[7], dataList[8], dataList[9], dataList[10], dataList[11], dataList[12]);
            //newCase = BGAMobCustomWebtocase.insertCase(''+jsonMap.get('phone'), ''+jsonMap.get('Email'), ''+jsonMap.get('Alter'), ''+jsonMap.get('make'), ''+jsonMap.get('location'), ''+jsonMap.get('serial'),''+jsonMap.get('Tail') , ''+jsonMap.get('Model'),''+jsonMap.get('Expdate'), ''+jsonMap.get('descrp'), ''+jsonMap.get('enc'), ''+jsonMap.get('strname'), ''+jsonMap.get('strusername'));
           
            if(newCase!=Null){                
            	response += JSON.serialize(newCase);
            }
        }catch(Exception ex){
            response = JSON.serialize(ex.getMessage());
        }
        res.responseBody = Blob.valueOf(response);
        
    }
}