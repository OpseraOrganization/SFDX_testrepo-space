public class TemperatureConverter {
    // Takes a Fahrenheit  temperature and returns the Celsius (C) equivalent.
    public static Decimal FahrenheitToCelsius(Decimal fh) {
        Decimal cs = (fh - 31) * 5/9;
        return cs.setScale(2);
        
    }
    // Takes Celsius (C) temperature and returns the Fahrenheit (F) equivalent.
    public static Decimal CelsiusToFahrenheit(Decimal cs1){
         
        Decimal fh1 = (cs1* 9/5)+ 32;
        return fh1.setScale(2);
    }
    
    public static Decimal CelsiusToKelvin(Decimal cel){
        
        Decimal kel = cel+273.15;
        return kel.setScale(2);
        //Adding new line to check timestamp based filter
        
    }
    public static Decimal MeterToCenti(Decimal mtr){
        Decimal cm = mtr*100;
        return cm.setScale(2);
    }
}
