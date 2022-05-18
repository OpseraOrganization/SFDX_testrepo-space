/**
* @Name: QTO_CustomerDocumentAssociationBatch
* @Author: akanksha trivedi
* @CreateDate: 10/29/2020
* @Description: To Associate with Quotes and Agreements
---------------------------------------------------------------------------------------------
* @LastModifiedBy: Neeharika Upadrasta, Nokia
* @LastModifiedDate: 9 Jan 2021
* @ChangeDescription: Added Customer Doc and Task error related constants
**/

public class QTO_Constants {
	
	//Customer Document Statuses
	public static final String CUSTOMER_DOCUMENT_REGISTRATION_STATUS = 'Registered';
	public Static final String CD_STATUS_SUCESSFUL = 'Association Successful';
	public Static final String CD_STATUS_FAILED = 'Association Failed';
	public Static final String CD_STATUS_EXCEPTION = 'Association-Exception';
	public Static final String CD_STATUS_LEGACY = 'Ready for Hand-off to Legacy';	 
	public Static final String CONSUMED = 'Consumed';
	public Static final String ASSOCIATED = 'Associated';
	public Static final String NOT_ASSOCIATED = 'Not Associated';
	public Static final String EXCEPTION_ASSOCIATION = 'Exception-Association';
	public Static final String EXCEPTION_HEADER_MISMATCH = 'Exception-Header-Mismatch';

	public static final String MANUAL = 'Manual';
	public static final String COMPLETED = 'Completed';
	public static final String PO_PDF = 'PO PDF';
	public static final Set<String> SET_STATUS = new Set<String>{'Draft','Rejected','Withdrawn'};
	public Static final String IN_APPLICATION = 'In Application';
	public Static final String IN_EFFECT = 'In Effect';
	public Static final String RISK_ORDER = 'Risk Order';
	public static final String INVESTIGATING_GROUP = 'Order Management';
	public static final String CLASS_STANDARDPO = 'Standard PO';
	public static final String SUB_CLASS_LEGACY = 'Legacy Based';
	
	//Task/Error logs
	public Static final String SUBJ_CD_MATCH = 'CD Match';
	public Static final String DESC_REGISTER = 'Issue when Registering the Customer Document';
	public Static final String OPEN = 'Open';
	public Static final String QUEUE = 'Queue';
	public Static final String ERROR = 'Error';
	public Static final String WARNING = 'Warning';
	public Static final String ERROR_501 = '501';
	public Static final String ERROR_502 = '502';
	public Static final String ERROR_602 = '602';
	public Static final String ERROR_602_Message = 'Maintenance PO';
	public Static final String ERROR_INCORRECTAGMT = 'Cannot select the correct agreement';
	public Static final String ASSIGNEE_QUEUE= 'PEGA Order Entry';
	public Static final String TASK_MESSAGE = ' Please go to Log for further details.';
	public Static final String ISSUE_CORRECTAGMT = 'Please select the correct agreement';
	public Static final String ISSUE_NOKIA_LEGAL_ENTITY_ACCOUNT = 'Header mismatch on Nokia Legal Entity Account';
	public Static final String ISSUE_CURRENCY = 'Header mismatch on Currency';
	public Static final String ISSUE_PAYMENT_TERMS = 'Header mismatch on Payment Terms';
	public Static final String ISSUE_INCOTERM = 'Header mismatch on INCO Terms';
	public Static final String ISSUE_PLACE_OF_DELIVERY = 'Header mismatch on Place of Delivery/Shipment';
	
	
	// DSI-2211
	public static final String CLOSED_VALIDATED = 'Closed-validated';
	public static final String CLOSED_CANCELLED = 'Closed-cancelled';
	public static final String CLOSED_CONSUMED = 'Closed-consumed';
	public static final String CLOSED_REJECTED = 'Closed-rejected';
	
	public static final String MATCHED = 'Matched';
	
	
	//Agreement
	public Static final String AGMT_BUSTYPE_SWM = 'SW Maintenance (SWM)';
	public Static final String AGMT_BUSTYPE_HW = 'HW maintenance';  
	
	//DSI-2136
	public Static final String CREATE = 'Create';
	public Static final String COPY = 'Copy';
	public Static final String Cancel = 'Cancel';
	public Static final String Change = 'Change';
	public Static final String BLANKET='Blanket';
	public Static final String PURCHASEORDER='Purchase Order';
	public Static final String STANDARD='Standard';
	public Static final String CONTRACT='Contract';
	public Static final String INHOUSEORDER='In-House Order';
	public Static final String RISKORDER='Risk-Order';
	public Static final String ENGINEERINGORDER='Engineering Order';
		
	public static final String MARKET_OPERATION = 'Market Operation';
	public static final String ORDER_MANAGEMENT = 'Order Management';
	public static final String MODIFICATION_TERM_SET = 'Modification Term Set';
	public static final String CHANGE_CONTRACTUAL_ALLOWED = 'Change Contractual Allowed';
	public static final String CANCELLATION_CONTRACTUAL_ALLOWED = 'Cancellation Contractual Allowed';
	public static final String CHANGE_ALLOWED = 'Change Allowed';
	public static final String CHANGE_REFUSED = 'Change Refused';
	public static final String CANCELLATION_ALLOWED = 'Cancellation Allowed';
	public static final String CANCELLATION_REFUSED = 'Cancellation Refused';
	public static final String MODIFICATION_TERM_DETERMINED = 'Modification Term Determined';
	public static final String STATUS_DRAFT_WITH_EXCEPTIONS = 'Draft with Exceptions';
	public static final String STATUS_REGISTERED = 'Registered';
	public static final String CD_STATUS_LINES_HANDOFF = 'Ready for line item hand-off';
	
	public static final String STATUS_ENRICHED = 'Enriched(Lines)';
	public static final String STATUS_ENRICHMENT_FAILED = 'Exception-Enrichment(Lines)';
	public static final String STATUS_MANUAL_ENRICHED = 'Manually-Enriched(Lines)';
	
	public static final String STATUS_ASSOCIATED = 'Associated(Lines)';
	public static final String STATUS_ASSOCIATION_FAILED = 'Exception-Association(Lines)';
	
	public static final String STATUS_MATCHED = 'Matched(Lines)';
	public static final String STATUS_MATCHING_FAILED = 'Exception-Matching(Lines)';
	
	public static final String ASSOCIATION_FAILED = 'Association Failed';

	public static final String ENRICHMENT = 'Enrichment';
	public static final String ASSOCIATION = 'Association';
	public static final String MATCHING = 'Matching';
	
	public static final String CD_STATUS_CPO_CREATION = 'Ready for CPO creation';
	public static final String SUCCESSFUL = 'Successful';

}