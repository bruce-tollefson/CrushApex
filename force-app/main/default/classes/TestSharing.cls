@isTest
public with sharing class TestSharing {
    @isTest(SeeAllData=True)
    public static void showSharing() {
        User u = [Select Id from User where Email='udemy_apex@gmail.com.invalid'];
        System.runAs(u){
            system.debug('WithoutSharing: '+WithoutSharing.getAccountSize());
            system.debug('WithSharing: '+WithSharing.getAccountSize());
            System.debug('WithoutSharing-inherited: '+WithoutSharing.callInheritedSharing());
            system.debug('WithSharing-inherited: '+WithSharing.callInheritedSharing());
        }

    }
}
