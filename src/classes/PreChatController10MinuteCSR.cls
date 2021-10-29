/*
Author: NTT DATA INC
Date: 8/4/2016
Test Class: test_PreChatController10MinuteCSR
*/
public class PreChatController10MinuteCSR
{
  public string siteSelectOption{get;set;}

    public PreChatController10MinuteCSR() {
        Schema.DescribeFieldResult fieldResult; 
        List<Schema.PicklistEntry> ple;
        fieldResult = liveChatTranscript.site__c.getDescribe();
        ple = fieldResult.getPicklistValues();
        siteSelectOption = json.serialize (ple);
    }   
}