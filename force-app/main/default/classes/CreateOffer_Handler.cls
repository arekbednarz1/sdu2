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
        List<Id>updateList= new List<Id>();
        Map<Id,String> mapWithValuesToUpdateSalons = new Map<Id,String>();
        List<Vehicle__c>updatedSalonsList = new List<Vehicle__c>();
        if(inOffers==null || inOffers.isEmpty()){
            return;
        }    
        for(Offer__c offerToAdd : inOffers){
            if(Constants.PHYSICAL_OFFER.equals(offerToAdd.Offer_type__c)){
                Id vehicleId = offerToAdd.Vehicle__c;
                mapWithValuesToUpdateSalons.put(vehicleId,offerToAdd.Salon__c);
                updateList.add(vehicleId); 
            }   
        }
            
        List<Vehicle__c> vehicleWithNoSalon = [SELECT Id,Salon__c FROM Vehicle__c WHERE Id IN: updateList];
        for(Vehicle__c noSalonVehicle : vehicleWithNoSalon){
            noSalonVehicle.Salon__c = mapWithValuesToUpdateSalons.get(noSalonVehicle.Id);
            updatedSalonsList.add(noSalonVehicle);
        }    
        update updatedSalonsList;    
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
        if(inOffers==null || inOffers.isEmpty()){
            return;
        }    
        for (Offer__c offer : inOffers) {      
            if (Constants.PHYSICAL_OFFER.equals(offer.Offer_type__c)){        
                vehiclesWithPhysicalOffer.add(offer.Vehicle__c);
                physicalOffers.add(offer);    
            }       
        }    
        Map<Id,String> carsSalonsPhysicalMap = new Map<Id,String>();
        List<Offer__c> allPhysicalOffers = [SELECT Vehicle__c, Salon__r.Name FROM Offer__c WHERE Vehicle__c IN :vehiclesWithPhysicalOffer];    
        for (Offer__c offer : allPhysicalOffers){
           carsSalonsPhysicalMap.put(offer.Vehicle__c,offer.Salon__r.Name);
        }
        for(Offer__c offer  : physicalOffers){
            if(carsSalonsPhysicalmap.containsKey(offer.Vehicle__c)) {    
                String salonWithOffer = carsSalonsPhysicalMap.get(offer.Vehicle__c);
                offer.addError('Vehicle is available in ' +salonWithOffer+ ' salon');                        
            }      
        }     
    }    
}    

