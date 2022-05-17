public with sharing class Overloading {


    public static void overloadedMethod(){
        system.debug('Class with no parameters');
    }

    public static void overloadedMethod(Integer x, Integer y){
        system.debug(x * y);
    }

    public static void overloadedMethod(Decimal x, Decimal y){
        system.debug('Decimal');
        system.debug(x * y);
    }

    public static void overloadedMethod(String overloadedString){
        system.debug(overloadedString);
        overloadedMethod();
    }

}
