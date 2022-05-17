public with sharing class octocatController {
    @AuraEnabled
    public static string getCat() {
        return GitHubCallout.getGITHUBUserStr('octocat');
    }
}
