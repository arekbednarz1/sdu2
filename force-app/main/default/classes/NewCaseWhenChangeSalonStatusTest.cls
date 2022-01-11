/**
 * @author Arkadiusz Bednarz <arkadiusz.bednarz@accenture.com>
 * @date 10/01/2022
 * @description test class for NewCaseWhenSalonWasClosed class.
 */

@isTest
public class NewCaseWhenChangeSalonStatusTest {

    public static List<Salon__c> createClosed(){
        Account account = new Account(Name='TEST');
        insert account;
        Salon__c salon = TestCreateRecords.addSalons(1)[0];
        salon.Account__c=account.Id;
        salon.Salon_status__c='close';
        insert salon;
        List<Salon__c> salons = new List<Salon__c>();
        salons.add(salon);
        return salons;
    } 
    
    @isTest
    static void testMethodWhenResponseIsCorrect(){
        MockNewCaseWhenChangeSalonStatusTest.setTestMockResponse(201);
        List<Salon__c> salons = createClosed();
        
        NewCaseWhenSalonWasClosed nc = new NewCaseWhenSalonWasClosed(salons);
        List<Case> cases = nc.getCases();
        
        Test.startTest();
        HttpResponse response = nc.sendReq(cases);
        id jobId = System.enqueueJob(nc);
        Test.stopTest();

        System.assert(jobId != null);
        String contentType = response.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        for(Case c : cases){
            System.assert(c.Status.equals('Closed'));
        }
        
        System.assertEquals(201, response.getStatusCode());
    }
 
    @isTest 
    static void testMethodWhenFaild(){
         MockNewCaseWhenChangeSalonStatusTest.setTestMockResponse(123);
        List<Salon__c> salons = createClosed();
        
        NewCaseWhenSalonWasClosed nc = new NewCaseWhenSalonWasClosed(salons);
        List<Case> cases = nc.getCases();
        
        Test.startTest();
        HttpResponse response = nc.sendReq(cases);
        Test.stopTest();

        
        String contentType = response.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        for(Case cs : cases){
            System.debug(cs.Status);
            System.debug(response.getStatusCode());
            System.assert(cs.Status.equals('Faild'));
            System.assertEquals(123, response.getStatusCode());
        }

    }
}