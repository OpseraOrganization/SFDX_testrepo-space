@RestResource(UrlMapping = '/ngbss/orders/*/cart/*')
global with sharing class RepriceCartRestResource{
    @HttpPost
    global static void repriceCart(){
        RestRequest request = RestContext.request;
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type','application/json');
        system.debug('request >> '+ request);
        String action = request.params.get('action');
        system.debug('URL Data >> '+ request.requestURI.split('/')[5]);
        String cartId = request.requestURI.split('/')[5];
        system.debug('cartId >> '+ cartId);
        String orderId = request.requestURI.split('/')[3];
        system.debug('orderId >> '+ orderId);
        integer orderCount = [select count() from Apttus_Config2__Order__c where id=:orderId];
        integer cartCount = [select count() from Apttus_Config2__ProductConfiguration__c where id=:cartId];
        
        try{ 
            if(action == Null)
                throw new MyException('action is mandatory parameter');
            else if(action != 'reprice')
                throw new MyException('action must be reprice');
            else{
                if(orderCount==0){
                    // throw exception
                    throw new MyException('OrderId is Invalid');
                }
                if(cartCount==0){
                    // throw exception
                    throw new MyException('cartId is Invalid');
                }
                pricechange p = repriceCart(cartId);
                res.responseBody = Blob.valueOf(JSON.serialize(p));
                res.statusCode = 200; 
            }
        }
        catch(Exception e){
            MyExc error = new MyExc('BAD_REQUEST',e.getMessage());
            res.responseBody = Blob.valueOf(json.serialize(error));
            res.statusCode = 400;     
        }
    }
    public static pricechange repriceCart(Id cartId){
        Apttus_CPQApi.CPQ.UpdatePriceRequestDO request = new Apttus_CPQApi.CPQ.UpdatePriceRequestDO();
        request.CartId=cartId;
        Apttus_CPQApi.CPQ.UpdatePriceResponseDO repricecart=Apttus_CPQApi.CPQWebService.updatePriceForCart(request);
        pricechange p = new pricechange();
        p.isPricePending = repricecart.IsPricePending;
        p.pendingLineNumbers= repricecart.PendingLineNumbers;
        p.completedLineNumbers= repricecart.CompletedLineNumbers;
        return p;
    }
    global class pricechange{
        public boolean isPricePending;
        public List<Integer> pendingLineNumbers;
        public List<Integer> completedLineNumbers;
    }
    global class MyExc { 
        public string errorCode;
        public string message;
        
        MyExc(string errorCode, string message){
            this.errorCode = errorCode;
            this.message = message;
        }
    }
    public class MyException extends Exception {}
}