public class FilesDetails {

	@auraenabled
	public static list<ContentDocumentLink> getattachment(list<id> idlist){
		list<ContentDocumentLink> attlist = [SELECT ContentDocumentId,Id,LinkedEntityId,ContentDocument.title,ContentDocument.FileType,ContentDocument.CreatedBy.Name,ContentDocument.ContentSize,ContentDocument.FileExtension,ContentDocument.CreatedDate  FROM ContentDocumentLink WHERE LinkedEntityId  in : idlist];
		system.debug('attlist: '+ attlist);
		system.debug('accountid: '+ idlist);
		return attlist;
	}
	
	 @auraenabled
	public static integer getcount(list<id> idlist){
		AggregateResult aggresult = [SELECT count(id) countrec FROM ContentDocumentLink WHERE LinkedEntityId  in : idlist];
		system.debug('attlist: '+ aggresult.get('countrec'));
		system.debug('accountid: '+ idlist);
		integer count = (integer) aggresult.get('countrec');
		return count;
	}
}