public class AccessModifiers {

    public static String accessModString = 'Public String';
    private static String accessModStr = 'Private String';

    public static final String FINAL_STRING = 'Final String';

    public static void accessModPubMethod(){
        //FINAL_STRING = 'Updated from Public Method';
        //system.debug(FINAL_STRING);
    }

    private static void accessModPriMethod(){
        system.debug('You were able to access the Private Method');
    }

    static void accessModMethod(String paramString){
        system.debug(paramString);
    }
}
