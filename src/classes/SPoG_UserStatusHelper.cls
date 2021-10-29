/***********************************************
 * @Description : Apex Class to handle User Status related logic.
 * *********************************************/
public with Sharing class SPoG_UserStatusHelper {
    /***********************************************************
     * @Description: Method to get the User Status data for the 
     * current user. 
     * ********************************************************/
    public String getUserStatus(){
        UserStatusResponse result = new UserStatusResponse();
        try{
            String honid = [Select Id,EmployeeNumber from User where ID =: UserInfo.getUserId() LIMIT 1].EmployeeNumber;
            System.debug('===>>>honid:::  '+honid);
            SPoG_InterfaceHelper helper = new SPoG_InterfaceHelper();
            HttpResponse response = helper.getUserStatusDetails(honid);
            if(response.getStatusCode() == 200){
                System.debug('===>>response::: '+response.getBody());
                result.response = response.getBody();
                result.isSuccess = true;
                result.message = 'Success';
            }else{
                System.debug('===>>response::: '+response.getBody());
                result.response = response.getBody();
                result.isSuccess = false;
                result.message = 'Not Valid User';
            }
        }catch(Exception ex){
            System.debug('===>>Exception:: '+ex.getMessage());
            result.response = '';
            result.isSuccess = false;
            result.message = 'Service Error';
        }
        return JSON.serialize(result);
    }
    public class UserStatusResponse{
        public String response;
        public Boolean isSuccess;
        public String message;
    }
}