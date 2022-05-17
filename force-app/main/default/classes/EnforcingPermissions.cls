@isTest
public with sharing class EnforcingPermissions {
    @isTest(SeeAllData=True)
    public static void enforceObject() {

        User u = [Select Id from User where Email = 'udemy_apex@gmail.com.invalid'];
        System.runAs(u){
            system.debug(Logger__c.sObjectType.getDescribe().isCreateable());
            system.debug(Logger__c.sObjectType.getDescribe().isUpdateable());
            system.debug(Logger__c.sObjectType.getDescribe().isAccessible());
            system.debug(Schema.sObjectType.Logger__c.fields.Message__c.isCreateable());
            system.debug(Schema.sObjectType.Logger__c.fields.Message__c.isUpdateable());
            system.debug(Schema.sObjectType.Logger__c.fields.Message__c.isAccessible());
            system.debug(true);
        }

    }

    @isTest(SeeAllData=True)
    public static void stripInaccessible() {

        User u = [Select Id from User where Email = 'udemy_apex@gmail.com.invalid'];
        System.runAs(u){
            List<Logger__c> logList = [Select Id, Cause__c, Message__c from Logger__c limit 2];
            system.debug(logList);
            SObjectAccessDecision decision = Security.stripInaccessible(AccessType.READABLE, logList);
            system.debug(decision);
            system.debug('Insecure: '+logList[0]);
            system.debug('Insecure: '+logList[1]);
            system.debug('Secure: '+decision.getRecords()[0]);
            system.debug('Secure: '+decision.getRecords()[1]);
            system.debug(true);
        }

    }

    @isTest(SeeAllData=True)
    public static void withSecurity() {

        User u = [Select Id from User where Email = 'udemy_apex@gmail.com.invalid'];
        System.runAs(u){
            List<Logger__c> logList = [Select Id, Cause__c, Message__c from Logger__c WITH SECURITY_ENFORCED limit 2];
            system.debug(logList[0]);
            system.debug(logList[1]);
            system.debug(true);
        }
    }
}
