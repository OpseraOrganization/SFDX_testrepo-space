import { api, LightningElement, track } from 'lwc';

export default class NokiaCPQ_notification extends LightningElement {
     /**
     * Keep track of show notification message, based on the Track property's value
     * render a component 
     */
      @track isNotificationMessage = false;

      /**
       * Keep track of show error type notification message, based on the Track property's value
       * render a component 
       */
      @track showError = false;
  
      /**
       * Keep track of show success type notification message, based on the Track property's value
       * render a component 
       */
      @track showSuccess = false;
  
      /**
       * Keep track of show information type notification message, based on the Track property's value
       * render a component 
       */
      @track showInfo = false;
  
      /**
       * Keep track of show notification message, based on the Track property's value
       * render a component 
       */
      @track showMessage = '';
      @track showWarning = false;
       /**
       * Reset notification messages from screen 
       */
      @api
      resetMessage() {
          this.showError = false;
          this.showSuccess = false;
          this.showInfo = false;
          this.showWarning = false;
          this.isNotificationMessage = false;
      }
      
      /**
       * Show custom toast notification message on interface
       * 
       * @param title - title text of message
       * @param message - message text
       * @param variant - type of message (error/info)
       */
      @api
      showToast(title, message, variant) {
        
          this.resetMessage();
          if (variant == 'success') {
              this.showSuccess = true;
          }else if (variant == 'error') {
              this.showError = true;
          } else if (variant ==  'info') {
              this.showInfo = true;
          } else{
              this.showWarning  = true;
          }
  
          this.showMessage = message;
          this.isNotificationMessage = true;
  
          /*window.clearTimeout(this.delayTimeout);
          this.delayTimeout = setTimeout(() => {
             this.resetMessage();
          }, 5000);*/
      }
}