@isTest
public class HWS_ComponentToProductJSON_Test {
	@isTest
	Public Static void componentToProdWrapper(){
		HWS_ComponentToProductJSON jsonWrap = new HWS_ComponentToProductJSON();
		jsonWrap.ID = '46256.29608.0.19503';
		jsonWrap.Type = 'NSN Other Electromechanical Component';
		jsonWrap.SuperType = 'NSN Standard HW Component';
		jsonWrap.Name = '6900314';
		jsonWrap.Revision = 'Test revision';
		jsonWrap.Originated = '2002-03-12T20:38:34Z';
		jsonWrap.Description = 'TOOL 2.0mm WITH PLASTIC HANDLE';
		jsonWrap.Modified = Date.today();
		jsonWrap.Owner = 'hbathula';
		jsonWrap.Policy = 'NSN Standard HW Component';
		jsonWrap.Current = 'Obsolete';
		jsonWrap.CurrentActualDate = '2009-12-11T12:49:29Z';
		jsonWrap.Vault = 'eService Production';
		jsonWrap.NSNCode = '6900314';
		jsonWrap.PMDSOR_DeletedAtSource = false;
		jsonWrap.PMDSOR_InsertDateTime = '2020-06-24T08:20:15.2922385Z';
		jsonWrap.PMDSOR_UpdateDateTime = '2020-06-24T08:20:15.2922385Z';
		HWS_ComponentToProductJSON.cls_MainAttributes mainAttributes = new HWS_ComponentToProductJSON.cls_MainAttributes();
		mainAttributes.ID = 15578235;
		mainAttributes.Name = 'Estimated Cost';
		mainAttributes.Value = '0.0 Dollar';
	}
}