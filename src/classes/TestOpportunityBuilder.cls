/**
 * Created by Nikolay Kolev on 4/8/2019.
 * OWNED BY THE CRM SALES TEAM.
 */

public class TestOpportunityBuilder {
    public static RecordType getRecordType(String developerName) {
        return [
                SELECT
                        Id,
                        Name
                FROM RecordType
                WHERE SobjectType = 'Opportunity'
                AND DeveloperName = :developerName
                LIMIT 1
        ];
    }

    private RecordType opportunityRecordType = null;
    private String name = 'testOpportunity';
    private String stage = 'prospecting';
    private Date closeDate = Date.today().addDays(30);
    private Map<String, Object> fields = new Map<String, Object>();

    public TestOpportunityBuilder() {}

    public TestOpportunityBuilder(String name) {
        this.name = name;
    }

    public TestOpportunityBuilder(String name, String developerName) {
        this.name = name;

        opportunityRecordType = getRecordType(developerName);
    }

    public TestOpportunityBuilder setStage(String stage) {
        this.stage = stage;

        return this;
    }

    public TestOpportunityBuilder setCloseDate(Date closeDate) {
        this.closeDate = closeDate;

        return this;
    }
    public TestOpportunityBuilder addField(String field, Object value) {
        fields.put(field, value);

        return this;
    }

    public Opportunity build() {
        Opportunity opp = new Opportunity();
        opp.Name = name;
        opp.StageName = stage;
        opp.CloseDate = closeDate;


        if (opportunityRecordType != null) {
            opp.RecordTypeId = opportunityRecordType.Id;
        }

        for (String field: fields.keySet()) {
            Object value = fields.get(field);
            opp.put(field, value);
        }

        return opp;
    }

    public Opportunity generate() {
        Opportunity opp = build();
        Database.insert(opp);
        return opp;
    }
}