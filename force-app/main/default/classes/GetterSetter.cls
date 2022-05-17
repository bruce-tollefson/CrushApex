public with sharing class GetterSetter {

    public static String pubString = 'Getting Public String';
    private static String priString = 'Getting Private String';


    public String pubGetString {get; private set;}
    public String pubSetString {private get; set;}

    public void setpubGetString(String setter){
        this.pubGetString = setter;
    }

    public void getpubSetString(){
        system.debug(this.pubSetString);
    }


    public static Integer doubler{
        get{
            System.debug('Doubler: '+ doubler);
            return doubler * 2;
        }
        set{
            doubler = value;
        }
    }

    public Integer tripler{
        get{
            System.debug('Doubler: '+ tripler);
            return tripler * 3;
        }
        private set;
    }

    public void setTripler(Integer tripler){
        this.tripler = tripler;
    }
}
