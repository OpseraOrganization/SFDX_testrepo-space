/**
 * Created by Nikolay Kolev on 3/15/2019.
 * OWNED BY THE CRM SALES TEAM.
 */

public class ErrorLogBuilder {

    private String teamName;
    private String objectInfo;
    private String rawDescription;
    private Map<String, Object> fields = new Map<String, Object>();
    private Exception ex;
    public static final String CRM_SALES = 'CRM Sales Team';

    // In case no team name was provided then don't set up a team name.
    public ErrorLogBuilder(){}
    /**
     * @param The name of the team that will own the error.
     */
    public ErrorLogBuilder(String teamName) {
        this.teamName = teamName;
    }
    /**
     * @param Id of the object and any additional info(up to 255 chars).
     * @return The class itself.
     */
    public ErrorLogBuilder setObjectInfo(String objectInfo) {
        this.objectInfo = objectInfo;
        return this;
    }
    /**
     * @param Description for the error. It must have the stack trace for the error.
     * @return The class itself.
     */
    public ErrorLogBuilder setDescription(String rawDescription) {
        this.rawDescription = rawDescription;
        return this;
    }
    /**
     * @param ex - The exception that triggers the error.
     * @return The class itself.
     */
    public ErrorLogBuilder setException(Exception ex) {
        this.ex = ex;
        return this;
    }
    /**
     * @param fieldName - The name of the field that needs to be populated on the Error Log Object.
     * @param fieldValue - The value of the field that will be populated for the field name.
     * @return The class itself.
     */
    public ErrorLogBuilder setFieldValue(String fieldName, Object fieldValue) {
        this.fields.put(fieldName, fieldValue);
        return this;
    }
    /**
     * @description Will build the error log but NOT insert it.
     * @param None, uses class level variables.
     * @return The Error Log that was built by the class.
     */
    public Error_Log__c build() {
        Error_Log__c errLog = new Error_Log__c();
        errLog.Team_Name__c = teamName;
        errLog.Object__c = objectInfo;
        errLog.Description__c = getDescription();
        if (!fields.isEmpty()) {
            for (String field: fields.keySet()) {
                errLog.put(field, fields.get(field));
            }
        }

        return errLog;
    }
    /**
     * @description Will insert the error log and return it.
     * @param None, uses class level variables.
     * @return The Error Log that was built by the class.
     */
    public Error_Log__c generate() {
        Error_Log__c errLog = build();
        Database.insert(errLog);

        return errLog;
    }
    /**
     * @description Will construct the description message for the error log by combining the custom description the
     * consumer class provided and the exception that was passed over.
     * @return The final description message.
     */
    private String getDescription() {
        String finalizedDescription = '';
        // If the consumer provided an exception then add the relevant info to the description.
        if (ex != null) {
            finalizedDescription +=
                    'Exception Message: ' + ex.getMessage() + '\n' +
                    ex.getCause() + '\n' +
                    ex.getStackTraceString() + '\n';
        }
        // If the consumer class provided any additional information then add that to the description.
        if (rawDescription != null) {
            finalizedDescription += 'Additional Description: ' + rawDescription;
        }

        return finalizedDescription;
    }
}