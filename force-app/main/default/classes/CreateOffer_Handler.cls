/**
 * @author Arkadiusz Bednarz <arkadiusz.bednarz@accenture.com>
 * @date 29/12/2021
 * @description Handler class for Create_offer trigger.
 */


public class CreateOffer_Handler {


    /**
     * @author Arkadiusz Bednarz <arkadiusz.bednarz@accenture.com>
     * @date 29/12/2021
     * @description validation for entering a physical offer. only 1 for 1 vehicle .
     * @param offers - entry list from trigger
     * @param vehicles - set of Id from Vehicle__c objects where Offer_type__c = physical
     * @param carsNotExist - list of Vehicle__c with Salon__c objects where Vehicle__c equal one of vehicle record
     */

     public static void checkAv(List<Offer__c> offers) {   
        Set<Id> vehicles = new Set<Id>();
        List <Salon__c> salons = [SELECT Name from Salon__c];
           if(offers.size()>0 && salons.size()>0){
           for (Offer__c offer : offers) {
               if (offer.Offer_type__c.equals('physical')) {
                   vehicles.add(offer.Vehicle__c);
               }
           }
            List<Vehicle__c> carsNotExist = [SELECT Id, Salon__c FROM Vehicle__c WHERE Id in :vehicles];
               if(carsNotExist.size()>0){
                for (Offer__c offer : offers) {
                        for (Vehicle__c p : carsNotExist) {
                            if (p.Id.equals(offer.Vehicle__c)) {
                                for(Salon__c s  : salons){
                                    if(!p.Salon__c.equals(offer.Salon__c)&& (s.Id).equals(p.Salon__c)) {
                                        offer.addError('Vehicle is available in ' + s.Name + ' salon');
                                        break;   
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }