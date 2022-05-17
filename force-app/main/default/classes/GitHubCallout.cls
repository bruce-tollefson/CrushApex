public with sharing class GitHubCallout {

    private static final String NAMED_CREDENTIAL = 'Github'; 
    private static final String USER_PATH = URL_Path__mdt.getInstance('USER').Label;
    private static final String NAMED_REPO = URL_Path__mdt.getInstance('NAMEDREPO').Label;

    public static GithubUser.fullUser getGITHUBUserStr(String username) {

        String url = 'callout:'+NAMED_CREDENTIAL+'/users/'+username;

        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('GET');
        HttpResponse res = h.send(req);
        return debugUserObject(res.getBody());
    }

    public static GithubUser.fullUser debugUserObject(String response){

        GithubUser.fullUser octocat = (GithubUser.fullUser)JSON.deserialize(response, GithubUser.fullUser.class);
        return octocat;/*
        GithubUser.halfUser octocatStrict = (GithubUser.halfUser)JSON.deserializeStrict(response, GithubUser.halfUser.class);
        system.debug('Strict: '+octocatStrict.name);
        Map<String, Object> octocatMap = (Map<String, Object>)JSON.deserializeUntyped(response);
        System.debug('Map: '+octocatMap.get('name'));*/
    }

    public static void createRepo(String repoName){

        String url = 'callout:'+NAMED_CREDENTIAL+USER_PATH;

        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('POST');
        req.setHeader('Authorization', 'token {!$Credential.Password}');

        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeStringField('name', repoName);
        gen.writeEndObject();
        System.debug(gen.getAsString());
        req.setBody(gen.getAsString());
        HttpResponse res = h.send(req);
        Integer statusCode = res.getStatusCode();
        if(statusCode >= 200 && statusCode <= 299){
            system.debug('Created');
        }else{
            system.debug('Create Failed');
            system.debug(res.getBody());
        }
    }

    public static void updateRepo(String repoName, String newName, Boolean isPrivate){

        String url = 'callout:'+NAMED_CREDENTIAL+NAMED_REPO+repoName;

        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('PATCH');
        req.setHeader('Authorization', 'token {!$Credential.Password}');

        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeStringField('name', newName);
        gen.writeBooleanField('private', isPrivate);
        gen.writeEndObject();
        System.debug(gen.getAsString());
        req.setBody(gen.getAsString());
        HttpResponse res = h.send(req);
        Integer statusCode = res.getStatusCode();
        if(statusCode >= 200 && statusCode <= 299){
            system.debug('Updated');
        }else{
            system.debug('Update Failed');
        }
    }

    public static void deleteRepo(String repoName){

        String url = 'callout:'+NAMED_CREDENTIAL+NAMED_REPO+repoName;

        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('DELETE');
        req.setHeader('Authorization', 'token {!$Credential.Password}');
        HttpResponse res = h.send(req);
        Integer statusCode = res.getStatusCode();
        if(statusCode >= 200 && statusCode <= 299){
            system.debug('Deleted');
        }else{
            system.debug('Delete Failed');
        }
    }
}
