/**
 * @author Arkadiusz Bednarz <arkadiusz.bednarz@accenture.com>
 * @date 31/01/2022
 * @description class for getting objects from database .
 */
public class DatabaseObjects {
  /**
   * @author Arkadiusz Bednarz <arkadiusz.bednarz@accenture.com>
   * @date 31/12/2021
   * @description method getting all accounts or specific accounts.
   */
  @auraEnabled(cacheable=true)
  public static List<Account> fetchAccount(String accName) {
    List<Account> accList = new List<Account>();
    if (!accName.equals('')) {
      String searchKey = '%' + accName + '%';
      accList = [
        SELECT Id, Name, Number_of_salons__c
        FROM Account
        WHERE Number_of_salons__c != 0 AND Account.Name LIKE :searchKey
        LIMIT 100
      ];
    } else {
      accList = [
        SELECT Id, Name, Number_of_salons__c
        FROM Account
        WHERE Number_of_salons__c != 0
        LIMIT 100
      ];
    }
    return accList;
  }

  /**
   * @author Arkadiusz Bednarz <arkadiusz.bednarz@accenture.com>
   * @date 31/12/2021
   * @description method getting all salons or specific salons.
   */
  @auraEnabled(cacheable=true)
  public static List<Salon__c> getSalons(String accountId) {
    List<Salon__c> salonList = new List<Salon__c>();
    if (!accountId.equals('')) {
      salonList = [
        SELECT Id, Name, City__c, Region__c
        FROM Salon__c
        WHERE Account__c = :accountId
        LIMIT 100
      ];
    } else {
      salonList = [SELECT Id, Name, City__c, Region__c FROM Salon__c LIMIT 100];
    }
    return salonList;
  }

  /**
   * @author Arkadiusz Bednarz <arkadiusz.bednarz@accenture.com>
   * @date 31/12/2021
   * @description method getting all vehicles or specific vehicles..
   */
  @auraEnabled(cacheable=true)
  public static List<Vehicle__c> fetchVehicles(String salonId) {
    List<Vehicle__c> vehicleList = new List<Vehicle__c>();
    if (!salonId.equals('')) {
      vehicleList = [
        SELECT Id, Name, Brand__c, Model__c, Physical_Salon__c, Serial_Number__c
        FROM Vehicle__c
        WHERE Salon__c = :salonId
        LIMIT 100
      ];
    } else {
      vehicleList = [
        SELECT Id, Name, Brand__c, Model__c, Physical_Salon__c, Serial_Number__c
        FROM Vehicle__c
        LIMIT 100
      ];
    }
    return vehicleList;
  }

  @auraEnabled(cacheable=true)
  public static List<Vehicle__c> getVehicleDetail(String vehicleId) {
    List<Vehicle__c> vehicleList = [
      SELECT
        Id,
        Name,
        Brand__c,
        Model__c,
        Physical_Salon__c,
        Serial_Number__c,
        Interested__c
      FROM Vehicle__c
      WHERE Id = :vehicleId
      LIMIT 100
    ];
    return vehicleList;
  }
}
