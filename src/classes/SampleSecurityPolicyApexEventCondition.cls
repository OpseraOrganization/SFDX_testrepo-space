global class SampleSecurityPolicyApexEventCondition implements TxnSecurity.EventCondition {

	public boolean evaluate(SObject event) {
		return false;
	}

}