global class APTS_InvoiceActionResult {
	webservice boolean success = true;
    webservice String message = null;
    
    public APTS_InvoiceActionResult() {
        this.success = true;
    }
    
    public static APTS_InvoiceActionResult withSuccess() {
        APTS_InvoiceActionResult result = new APTS_InvoiceActionResult();
        return result;
    }

    public static APTS_InvoiceActionResult withFailure(String message) {
        APTS_InvoiceActionResult result = new APTS_InvoiceActionResult();
        result.setSuccess(false);
        result.setMessage(message);
        return result;
    }

    public boolean isSuccess() {
        return success;
    }
    
    public void setSuccess(boolean success) {
        this.success = success;
    }
    
    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }
}