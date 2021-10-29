@istest(seealldata = true)
public class BGAMOBDel_test{

static testMethod void TestMethod1(){

ApexPages.StandardController controller;
BGAMOBDel bga = new BGAMOBDel(controller);
bga.getCountries();
BGAMOBDel.getState1('india');
BGAMOBDel.getCountriesFromAccounts();
BGAMOBDel.getContactAll();
BGAMOBDel.getProduct();
BGAMOBDel.getContactCloseTo(34.048927,-111.093735);
BGAMOBDel.getContactByProduct('APU GTCP36-6, 100/150, RE100 & RE220 Line; TFE731 -2 through -5, including -20/-40/-50/-60 Line; TPE331 Pre-Century Series through -12 Line');
BGAMOBDel.getContactByProductUsingGPS('APU GTCP36-6, 100/150, RE100 & RE220 Line; TFE731 -2 through -5, including -20/-40/-50/-60 Line; TPE331 Pre-Century Series through -12 Line',34.048927,-111.093735);
BGAMOBdel.getfilterResult('Avionics Dealers','Mechanical Components Repair Center','Mechanical Service Center','TFE','APU','TPE','HTF','CFE','Pilatus Ltd Service Provider','Satcom/Connectivity');
BGAMOBDel.getResultValue('India','--None--');
BGAMOBDel.getResultValue('India','');

}

}