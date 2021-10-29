trigger RetrievingFields_Body on LiveChatTranscript (before insert) {
for (LiveChatTranscript lct:Trigger.new)
{
    if(lct.body!=null){
    Integer Result= lct.body.indexOf(')',0);
    String Latest=lct.body.substring (Result+1,lct.body.length());
    Integer Result1= Latest.indexOf(')',0);
    Integer Result2=Latest.indexOf('(',0);
    String Last=Latest.substring(Result2+1,Result1);
    system.debug('last***************'+lct.body);
    lct.First_Agent_Response_Time__c=Last;
    Integer Result3=lct.body.indexOf('&quot;',0);
    system.debug('Result3*****************'+Result3);
    if(Result3!=-1){
    String  Result4 = lct.body.substring(Result3+6,lct.body.length());
    system.debug('Result4*******************'+Result4);
    Integer Result5=Result4.indexOf('&quot;',0);
    String Result6=Result4.substring(0,Result5);
    system.debug('Result5*******************'+Result5);
    lct.Chat_Subject__c=Result6;
    }
    }
}
}