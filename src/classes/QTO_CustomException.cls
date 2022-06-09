/**
 * @description	   : 
 * @author			: Raj Kamdar
 * @group			 : 
 * @last modified on  : 12-16-2020
 * @last modified by  : Raj Kamdar
 * Modifications Log 
 * Ver   Date		 Author	   Modification
 * 1.0   12-16-2020   Raj Kamdar   Initial Version
**/
public class QTO_CustomException extends Exception {
	String message;
	public QTO_CustomException(String message,String s){
		this.message=message;
	}
}