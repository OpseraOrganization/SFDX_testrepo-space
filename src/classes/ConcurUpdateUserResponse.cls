public class ConcurUpdateUserResponse {

    // Public fields to serialize / deserialize
    public Integer records_succeeded;
    public Integer records_failed;

    // Simple JSON deserialization
    public static ConcurUpdateUserResponse parse(String response) {
        // Replace reserved words
        // An alternative would be deserializeUntyped()
        String safeJson = response
            .replace('"records-succeeded":', '"records_succeeded":')
            .replace('"records-failed":', '"records_failed":');
            
        return (ConcurUpdateUserResponse)System.JSON.deserialize(safeJson, ConcurUpdateUserResponse.class);
    }
}