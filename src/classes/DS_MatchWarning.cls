public class DS_MatchWarning {

  @AuraEnabled public String Id { get; set; }
  @AuraEnabled public String Name { get; set; }
  @AuraEnabled public String Message { get; set; }

  public DS_MatchWarning(String id, String name, String message) {
	this.Id = id;
	this.Name = name;
	this.Message = message;
  }
}