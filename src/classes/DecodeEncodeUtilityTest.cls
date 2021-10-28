@isTest
public class DecodeEncodeUtilityTest {
	public testMethod static void decodeEndcodeTest(){
		String inputValue = DecodeEncodeUtility.encodeValues('test');
		System.assertnotEquals(null,inputValue );
		String outputValue =DecodeEncodeUtility.decodeValues(inputValue);	  
		System.assertnotEquals(null,outputValue );
	}
}