/**
 * Created by Nikolay Kolev on 4/12/2019.
 * OWNED BY THE CRM SALES TEAM.
 */

public class TestProductBuilder {

    private String name = 'Test Product';
    private Boolean isActive = true;
    private Map<String, Object> fields = new Map<String, Object>();

    public TestProductBuilder() {}

    public TestProductBuilder(String name) {
        this.name = name;
    }
    public TestProductBuilder setIsActive(Boolean isActive) {
        this.isActive = isActive;

        return this;
    }
    public TestProductBuilder addField(String field, Object value) {
        fields.put(field, value);

        return this;
    }
    public Product2 build() {
        Product2 product = new Product2();
        product.name = name;
        product.IsActive = isActive;

        for (String field: fields.keySet()) {
            Object value = fields.get(field);
            product.put(field, value);
        }
        return product;
    }
    public Product2 generate() {
        Product2 product = build();
        Database.insert(product);
        return product;
    }
}