/**
 * @author Arkadiusz Bednarz <arkadiusz.bednarz@accenture.com>
 * @date 10/01/2022
 * @description Mock class for NewCaseWhenChangeSalonStatusTest class.
 */

@isTest
public class MockNewCaseWhenChangeSalonStatusTest implements HttpCalloutMock {
    
    HttpResponse res;
    Integer code;
    
    public MockNewCaseWhenChangeSalonStatusTest(HttpResponse res, Integer code){
        this.res = res;
        this.code = code;
    }
    public HttpResponse respond(HttpRequest req) {
        return res;
    }
    
    public static void setTestMockResponse(Integer status){
        HttpResponse mockResp = new HttpResponse();
        
        mockResp.setStatusCode(status);
        mockResp.setHeader('Content-Type', 'application/json');
        
        test.setMock(HttpCalloutMock.class, new MockNewCaseWhenChangeSalonStatusTest(mockResp,status));
    }

}