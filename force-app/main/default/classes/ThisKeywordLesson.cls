public class ThisKeywordLesson {


    private String privateClassStr = 'This String';
    public static String checkThisStr = 'This';
    Account acct = [Select Id, Name from Account limit 1];


    public ThisKeywordLesson(String privateClassStr1) {
        this.privateClassStr = privateClassStr1;
        System.debug(privateClassStr);
        System.debug(this.privateClassStr);
    }

    public void debugString(){
        System.debug(privateClassStr);
    }

    public void debugThis(){
        System.debug(this);
    }
}
