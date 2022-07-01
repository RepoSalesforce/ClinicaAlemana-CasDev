@isTest
global class GetTokenCalloutMock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest request) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        String strBody = '{"access_token": "abc123","expires_in": 86400,"token_type": "Bearer"}';
        response.setBody(strBody);
        response.setStatusCode(200);
        return response; 
    }
}