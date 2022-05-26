public class DMLOperationResult_DTO {
	private Boolean success;
	private List<Database.Error> errors;
	private Id sObjectId;

	/**
	 * @description Constructor
	 * @param result Object, which has to be adapt.
	 * @return void
	 */
	public DMLOperationResult_DTO(Database.SaveResult result)
	{
		this.success = result.isSuccess();
		this.errors = result.getErrors();
		this.sObjectId = result.getId();
	}

	/**
	 * @description Constructor
	 * @param result Object, which has to be adapt.
	 * @return void
	 */
	public DMLOperationResult_DTO(Database.DeleteResult result)
	{
		this.success = result.isSuccess();
		this.errors = result.getErrors();
		this.sObjectId = result.getId();
	}

	/**
	 * @description Constructor
	 * @param result Object, which has to be adapt.
	 * @return void
	 */
	public DMLOperationResult_DTO(Database.UpsertResult result)
	{
		this.success = result.isSuccess();
		this.errors = result.getErrors();
		this.sObjectId = result.getId();
	}

	/**
	 * @description Getter for sObjectId property.
	 * @return Id Value of sObjectId property.
	 */
	public Id getId()
	{
		return this.sObjectId;
	}

	/**
	 * @description Getter for errors property.
	 * @return Id Value of errors property.
	 */
	public List<Database.Error> getErrors()
	{
		return this.errors;
	}

	/**
	 * @description Getter for success property.
	 * @return Id Value of success property.
	 */
	public Boolean isSuccess()
	{
		return this.success;
	}
}