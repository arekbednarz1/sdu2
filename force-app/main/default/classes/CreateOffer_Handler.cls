/**
 * @author Arkadiusz Bednarz <arkadiusz.bednarz@accenture.com>
 * @date 29/12/2021
 * @description Handler class for Create_offer trigger.
 */


public class CreateOffer_Handler {
 
    
    /**
     * @author Arkadiusz Bednarz <arkadiusz.bednarz@accenture.com>
     * @date 29/12/2021
     * @description method adding Salon__c to Vehicle__c with no salon .
     * @param inOffers - entry list from trigger
     */
    public static void updateSalonOffer(List<Offer__c> inOffers){
        if(inOffers!=null || !inOffers.isEmpty()){
            for(Offer__c offerToAdd : inOffers){
                if(Constants.PHYSICAL_OFFER.equals(offerToAdd.Offer_type__c)){
               	Id vehicleToAddId = offerToAdd.Vehicle__c;
               	Vehicle__c vehicleWithNoSalon = [SELECT Id, Name, Salon__c FROM Vehicle__c WHERE Id =: vehicleToAddId];
               	vehicleWithNoSalon.Salon__c = offerToAdd.Salon__c;
               	update vehicleWithNoSalon;
                }
            }
        }
    }
    
    
    /**
     * @author Arkadiusz Bednarz <arkadiusz.bednarz@accenture.com>
     * @date 29/12/2021
     * @description validation for entering a physical offer. only 1 for 1 vehicle .
     * @param inOffers - entry list from trigger
     */

    public static void checkAv(List<Offer__c> inOffers) {
        Set<Id> vehiclesWithPhysicalOffer = new Set<Id>();
     	List<Offer__c> physicalOffers = new List<Offer__c>();
        if(inOffers!=null || !inOffers.isEmpty()){
            for (Offer__c offer : inOffers) {
                if (Constants.PHYSICAL_OFFER.equals(offer.Offer_type__c)){
                    vehiclesWithPhysicalOffer.add(offer.Vehicle__c);
                    physicalOffers.add(offer);
                }
            }
            Map<Id,String> carsSalonsPhysicalmap = new Map<Id,String>();   
            List<Offer__c> allPhysicalOffers = [SELECT Vehicle__c, Salon__c FROM Offer__c WHERE Vehicle__c IN :vehiclesWithPhysicalOffer];
            if(allPhysicalOffers!=null || !allPhysicalOffers.isEmpty()){
                for (Offer__c offer : allPhysicalOffers) {
                    carsSalonsPhysicalmap.put(offer.Vehicle__c, offer.Salon__c);        
                }
                for(Offer__c offer  : physicalOffers){
                    if(carsSalonsPhysicalmap.containsKey(offer.Vehicle__c)) {
                        String salonWithOffer = [Select Name From Salon__c WHERE ID =:carsSalonsPhysicalmap.get(offer.Vehicle__c)].Name;
                        offer.addError('Vehicle is available in ' +salonWithOffer+ ' salon');
                        break;       
                    }   
                }
            }
        }
    }    
}