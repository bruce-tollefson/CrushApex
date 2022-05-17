public virtual class RESTFramework {

    private class RESTFrameworkException extends Exception{}

    public string namedCredential {get; private set;}
    public Map<String, String> headers {get; private set;}
    public string endpoint {get; private set;}
    public string method {get; private set;}
    public string body {get; private set;}

    public RESTFramework() {
        this.headers = new Map<String, String>();
    }

    public RESTFramework(String namedCredential, String endpoint, String method, String body){
        this.namedCredential = namedCredential;
        this.method = method;
        this.endpoint = endpoint;
        this.body = body;
        this.headers = new Map<String, String>();
    }

    public void setNamedCredential(String namedCredential){
        if(this.namedCredential == null){
        this.namedCredential = namedCredential;
        }else{
            throw new RESTFrameworkException('The named credential has already been set');
        }
    }

    public void addHeader(String headerKey, String headerValue){
        this.headers.put(headerKey, headerValue);
    }

    public void setEndpoint(String endpoint){
        if(this.endpoint == null ) this.endpoint = endpoint; else throw new RESTFrameworkException('The endpoint has already been set');
    }

    public void setMethod(String method){
        if(this.method == null) this.method = method; else throw new RESTFrameworkException('The method has already been set');
    }

    public void setBody(String body){
        if(this.body == null) this.body = body; else throw new RESTFrameworkException('The body has already been set');
    }

    public virtual HttpResponse send(){
        http h = new http();
        HttpRequest request = buildRequest();
        HttpResponse response = h.send(request);
        checkResponse(response);
        return response;
    }

    protected virtual boolean checkResponse(HttpResponse response){
        Integer statusCode = response.getStatusCode();
        if(statusCode >= 200 && statusCode <= 299) return true;
        return false;
    }

    protected virtual HttpRequest buildRequest(){
        HttpRequest request = new HttpRequest();
        request.setMethod(this.method.toUpperCase());
        request.setEndpoint(buildEndpoint());
        for(String header :this.headers.keySet()){
            request.setHeader(header, this.headers.get(header));
        }
        request.setBody(this.body);
        return request;
    }

    protected virtual String buildEndpoint(){
        this.endpoint = (this.namedCredential != null ? 'callout:'+this.namedCredential : '')+this.endpoint;
        if(String.isBlank(this.endpoint)) throw new RESTFrameworkException('The endpoint can\'t be blank');
        return this.endpoint;
    }
}
