public with sharing class GetGithubInvocable {

    @InvocableMethod(Label = 'Get Github User')
    public static List<Result> getGithubUser( List<Request> request){

        GithubUser.fullUser gitUser = GitHubCallout.getGITHUBUserStr(request[0].username);
        Result rlt = new Result();
        rlt.avatar_url = gitUser.avatar_url;
        rlt.html_url = gitUser.html_url;
        rlt.name = gitUser.name;
        return new List<Result>{rlt};
    }

    public class Request{
        @InvocableVariable (required=true)
        public string username;
        @InvocableVariable
        public string repoName;
    }

    public class Result{
        @InvocableVariable
        public string avatar_url;
        @InvocableVariable
        public string html_url;
        @InvocableVariable
        public string name;
    }
}
