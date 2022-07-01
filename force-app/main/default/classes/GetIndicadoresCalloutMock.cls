@isTest
global class GetIndicadoresCalloutMock implements HttpCalloutMock {
    
        protected Integer code;
        protected String status;
        protected String bodyAsString;
        protected Blob bodyAsBlob;
        protected Map<String, String> responseHeaders;
 
        public GetIndicadoresCalloutMock(Integer code, String status, String body) {
            this.code = code;
            this.status = status;
            this.bodyAsString = body;
        }    
        
    
    global HTTPResponse respond(HTTPRequest request) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody(bodyAsString);
        response.setStatusCode(code);
        return response; 
    }
}