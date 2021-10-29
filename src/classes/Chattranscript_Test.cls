@isTest (seeAllData=True)
private class Chattranscript_Test {
    static testMethod void Chattranscript_Test () {
    LiveChatTranscript lct = new LiveChatTranscript();
    lct.body='<p align="center">Chat Started: Thursday, January 28, 2021, 13:07:21 (+0530)</p><p align="center">Chat Origin: 10MinuteCSR</p><p align="center">Agent Priyanka J</p>( 4s ) Priyanka J: Welcome to 10MinuteCSR Support.<br>( 4s ) Visitor: Need help on &quot;Test&quot;<br>( 18s ) Priyanka J: hi<br>';
    lct.LiveChatVisitorId='5711B000000mOC2';
    insert lct;
    }
    }