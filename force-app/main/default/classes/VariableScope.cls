public with sharing class VariableScope {


    public String parentString = 'Class String';

    public VariableScope() {
        String parentString = 'constructor string';
        System.debug(parentString);
    }


    public void method1(){
        String parentString = 'method1 parent string';
        System.debug(parentString);
        String childStr = 'child string';
        System.debug(childStr);
        if(true){
            //childStr = 'child string';
            //System.debug(childStr);
            String grandChildStr = ' if sgrandchildtring';
            System.debug(grandChildStr);
        }
        //String grandChildStr = 'grandchild string';
        String grandChildStr = 'update grandchild if string';
        System.debug(grandChildStr);
    }
}
