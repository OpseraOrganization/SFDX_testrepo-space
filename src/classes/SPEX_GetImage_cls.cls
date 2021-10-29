/***********************************************************************************************************
* Company Name          : Honeywell Aero
* Name                  : SPEXDTO_cls
* Description           : Apex class used as get the Image Name for the platform provided
* 
* Modification History  :
* Date             Version No.    Modified by           Brief Description of Modification
* 13-Oct-2012      0.01           NTTDATA               Initial Version

***********************************************************************************************************/
public class SPEX_GetImage_cls
{
    /**
     * This method is used to get the Image Name for the platform provided.
     * @param strPlatformName - String - Platform Name for which image name need to be fetched
     * @param strOEMName - String - OEM Name for which image name need to be fetched
    */
    public static String getImageName(String strOEMName)
    {
         String strImageName = 'SPEX-Dassault-LOGO.png';
        if('DASSAULT'==strOEMName.toUpperCase())
        {
            strImageName = 'SPEX-Dassault-LOGO.png';
        }
        else if('GULFSTREAM'==strOEMName.toUpperCase())
        {
            strImageName = 'SPEX-Gulfstream-LOGO.png';
        }
         else if('PILATUS'==strOEMName.toUpperCase())
        {
            strImageName = 'SPEX-Pilatus-LOGO.png';
        }
         else if('CESSNA'==strOEMName.toUpperCase())
        {
            strImageName = 'SPEX-Cessna-LOGO.png';
        }
         else if('HAWKER BEECHCRAFT'==strOEMName.toUpperCase())
        {
            strImageName = 'SPEX-Hawker-LOGO.png';
        }
         else if('BOMBARDIER'==strOEMName.toUpperCase())
        {
            strImageName = 'SPEX-Bombardier-LOGO.png';
        }
        strImageName = 'img/'+strImageName;
        return strImageName;
    }
    
    /**
     * This method is used to get the Image Name for the platform provided.
     * @param strPlatformName - String - Platform Name for which image name need to be fetched
     * @param strOEMName - String - OEM Name for which image name need to be fetched
    */
    public static String getImageName(String strOEMName, String strPlatform)
    {
        String strImageName = 'SPEX-Falcon-F7X.png';
        if('DASSAULT'==strOEMName.toUpperCase())
        {
            if('F7x'==strPlatform)
            {
                strImageName = 'SPEX-Dassault-F7X.png';
            }
            else if('Falcon 2000'==strPlatform)
            {
                strImageName = 'SPEX-F2000.png';
            }
            else if('Falcon 900'==strPlatform)
            {
                strImageName = 'SPEX-F900.png';
            }
        }
        if('GULFSTREAM'==strOEMName.toUpperCase())
        {
            if('G280'==strPlatform)
            {
                strImageName = 'SPEX-Gulfstream-G280.png';
            }
            else if('G350, G450, G500, G550'==strPlatform)
            {
                strImageName = 'SPEX-Gulfstream-G550.png';
            }
            else if('G650'==strPlatform)
            {
                strImageName = 'SPEX-Gulfstream-G650.png';
            }
            else if('GIV CLASSIC (G300,G400,GIV,GIVSP)'==strPlatform)
            {
                strImageName = 'SPEX-Gulfstream-G300.png';
            }
            else if('GV CLASSIC'==strPlatform)
            {
                strImageName = 'SPEX-Gulfstream-GV.png';
            }
        }
        if('PILATUS'==strOEMName.toUpperCase())
          {
            if('PC-12'==strPlatform)
            {
                strImageName = 'SPEX-Pilatus-PC-12.png';
            }
            else if('PC-12 NG'==strPlatform)
            {
                strImageName = 'SPEX-Pilatus-PC-12NG.png';
            }
         }
         if('CESSNA'==strOEMName.toUpperCase())
          {
            if('CESSNA 525 SERIES'==strPlatform)
            {
                strImageName = 'SPEX-Cessna-C525-series.png';
            }
            else if('CESSNA 550 SERIES'==strPlatform)
            {
                strImageName = 'SPEX-Cessna-550-Series.png';
            }
            else if('CESSNA 560 SERIES'==strPlatform)
            {
                strImageName = 'SPEX-Cessna-560-Series.png';
            }
            else if('CESSNA 650 SERIES'==strPlatform)
            {
                strImageName = 'SPEX-Cessna-650-Series.png';
            }
            else if('CESSNA 680 SERIES'==strPlatform)
            {
                strImageName = 'SPEX-Cessna-C680-Series.png';
            }
            else if('CESSNA 750 SERIES'==strPlatform)
            {
                strImageName = 'SPEX-Cessna-C750-Series.png';
            }
         }
          if('BOMBARDIER'==strOEMName.toUpperCase())
          {
            if('LEARJET'==strPlatform)
            {
                strImageName = 'SPEX-Bombardier-Learjet.png';
            }
            else if('CHALLENGER'==strPlatform)
            {
                strImageName = 'SPEX-Bombardier-Challenger.png';
            }
            else if('GLOBAL EXPRESS'==strPlatform)
            {
                strImageName = 'SPEX-Bombardier-Global-Express.png';
            }
         }
          if('HAWKER BEECHCRAFT'==strOEMName.toUpperCase())
          {
            if('HAWKER 800 SERIES'==strPlatform)
            {
                strImageName = 'SPEX-Hawker-800.png';
            }
            else if('HAWKER 1000 SERIES'==strPlatform)
            {
                strImageName = 'SPEX-Hawker-1000.png';
            }
            else if('HAWKER 4000 SERIES'==strPlatform)
            {
                strImageName = 'SPEX-Hawker-4000.png';
            }
         }
        strImageName = 'img/'+strImageName;
        return strImageName;
    }
}