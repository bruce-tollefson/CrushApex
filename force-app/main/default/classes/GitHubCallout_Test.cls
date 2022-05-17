@isTest
public with sharing class GitHubCallout_Test {

    @isTest
    public static void testGithubUserGet(){
        test.setMock(HttpCalloutMock.class, new GitHubCallout_Mock(200));

        GithubUser.fullUser responseUser = GitHubCallout.getGITHUBUserStr('octocat');

        system.assertEquals('The Octocat', responseUser.name);
    }
}
