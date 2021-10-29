@istest(seealldata = true)
public class BGAMobCustomWebtocase_test{

static testMethod void TestMethod1(){


ApexPages.StandardController controller;
BGAMobCustomWebtocase bga = new BGAMobCustomWebtocase(controller);
bga.aircraftname='test';
bga.filename='test';

BGAMobCustomWebtocase.insertCase('3216549875','test@gmail.com','test@gmail.com','test@gmail.com','test@gmail.com','test@gmail.com','asd','asd','2017-09-30','asd','','asdas','tets');
BGAMobCustomWebtocase.getMakeLists();
BGAMobCustomWebtocase.getAccessToken();
Case ca = new Case(Subject='Test Controller Acct Case');
insert ca;
BGAMobCustomWebtocase.caseownerupdate(ca.id);
}


}