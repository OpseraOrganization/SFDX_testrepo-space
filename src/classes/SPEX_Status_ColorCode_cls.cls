/***********************************************************************************************************
* Company Name          : Honeywell Aero
* Name                  : SPEX_Inv_Platform_Sel_cls
* Description           : Apex class used to return color code depending on the status
* 
* Modification History  :
* Date             Version No.    Modified by           Brief Description of Modification
* 03-Oct-2012      0.01           NTTDATA               Initial Version

***********************************************************************************************************/
public class SPEX_Status_ColorCode_cls
{
    /**
     * Constructor which takes status as input and calculates color code for the status.
    */
    public SPEX_Status_ColorCode_cls(String strStatus)
    {
        getColorCode(strStatus);
    }
    
    /**
     * This method is used to get the color code for the status. This color code is used in CSS of visual force page.
     * @param strStatus - String - Status for which color code is required
     * @return String - Color code of the status
    */
    public static String getColorCode(String strStatus)
    {
        if('Stock_Out' == strStatus)
        {
            return 'val red';
        }
        else if('At_Risk' == strStatus)
        {
            return 'val yellow';
        }
        else if('Grey' == strStatus)
        {
            return 'val grey';
        }
        else
        {
            return 'val green';
        }
    }
}