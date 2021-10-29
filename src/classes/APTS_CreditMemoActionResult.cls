global class APTS_CreditMemoActionResult {
	webservice boolean success = true;
    webservice String message = null;
    
    public APTS_CreditMemoActionResult() {
        this.success = true;
    }
    
    public static APTS_CreditMemoActionResult withSuccess() {
        APTS_CreditMemoActionResult result = new APTS_CreditMemoActionResult();
        return result;
    }

    public static APTS_CreditMemoActionResult withFailure(String message) {
        APTS_CreditMemoActionResult result = new APTS_CreditMemoActionResult();
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