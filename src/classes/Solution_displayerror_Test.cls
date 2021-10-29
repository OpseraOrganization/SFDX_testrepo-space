@isTest
private class Solution_displayerror_Test{ 

static testMethod void Solution_displayerror_Testcls()
{

RecordType r1 = [select id,name from RecordType where name='Solution CSO Non-Technical'];
system.debug('PPPPPPP'+r1.id);
Solution SlnRec = new Solution();
SlnRec.Recordtypeid=r1.id;
SlnRec.SolutionName='Testing';
insert SlnRec;
SlnRec.SolutionName='TestingUpdate';
update SlnRec;
}


}