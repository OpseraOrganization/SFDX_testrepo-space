/**
 * Created by Nikolay Kolev on 4/3/2019.
 * OWNED BY THE CRM SALES TEAM.
 */

public with sharing class TechSalesHashBuilder {
    public enum Criteria {
        ALL,
        NO_COUNTRY
    }

    private String name = '';
    private String sbu = '';
    private String region = '';
    private String country = '';

    public TechSalesHashBuilder() {}

    public TechSalesHashBuilder setName(String name) {
        this.name = name != null ? name.trim(): '';
        return this;
    }
    public TechSalesHashBuilder setSbu(String sbu) {
        this.sbu = sbu != null ? sbu.trim(): '';
        return this;
    }
    public TechSalesHashBuilder setRegion(String region) {
        this.region = region != null ? region.trim(): '';
        return this;
    }
    public TechSalesHashBuilder setCountry(String country) {
        this.country = country != null ? country.trim(): '';
        return this;
    }

    /**
     *
     * @description The purpose of this method is to construct a unique hash key that will be used as a key in a map of
     * product line tech sales. Later this method will be used to construct a key based on the same values but this time
     * those values will be extracted by the line item object. In the end that will serve as a comparison mechanism between
     * the line item object and the product line tech sales to determine whether those values are the same or not.
     * @param criteria Enum that defines which path to take in order to construct the correct hash.
     *
     * @return Returns a hash code that corresponds to those values.
     */
    public Integer getHash(TechSalesHashBuilder.Criteria criteria) {
        String stringToHash = '';

        switch on criteria {
            when ALL {
                stringToHash += name+sbu+region+country;
            }
            when NO_COUNTRY {
                stringToHash += name+sbu+region;
            }
        }
        return stringToHash.hashCode();
    }
}