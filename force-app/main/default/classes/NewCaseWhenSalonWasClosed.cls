/**
 * @author Arkadiusz Bednarz <arkadiusz.bednarz@accenture.com>
 * @date 10/01/2022
 * @description This class creating a new case when Salon__c status is 'close' .
 */

public class NewCaseWhenSalonWasClosed implements Queueable, Database.AllowsCallouts{
    
    List<Case> cases = new List<Case>();
    
    private List<Salon__c> salons;
    public NewCaseWhenSalonWasClosed(List<Salon__c> salons){
        this.salons = salons;
    }

    public void execute(QueueableContext context){
        for(Salon__c salon : salons){
            cases.add(new Case(Subject='Renovation Case '+salon.Name, Salon__c = salon.id));
        }
        sendReq(cases);
        
        insert cases;
    }
    
    public List<Case>getCases(){
        return cases;
    }
    
   public HttpResponse sendReq(List<Case> cases){
        Http server = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://jsonplaceholder.typicode.com/posts');
        req.setMethod('POST');
        req.setBody(JSON.serialize(cases)); 
        HttpResponse resp = server.send(req);
        if(resp.getStatusCode() == 201){
            for(Case cs : cases){
                cs.Status = 'Closed';
            }
        }
        else{
            for(Case cs : cases){
                cs.Status = 'Faild';
            }
            System.debug(LoggingLevel.ERROR, 'Blad polaczenia');
        }
       
        return resp;
    }
}