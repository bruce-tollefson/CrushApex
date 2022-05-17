public with sharing class AccountTriggerHandler extends TriggerHandler {
    public AccountTriggerHandler() {}

    protected override void beforeInsert(){
        GithubCallout.getGITHUBUserStr('Octocat');
    }

    protected override void beforeUpdate(){

    }

    protected override void beforeDelete(){}

    protected override void afterInsert(){

    }

    protected override void afterUpdate(){}

    protected override void afterDelete(){}

    protected override void afterUndelete(){}
}
