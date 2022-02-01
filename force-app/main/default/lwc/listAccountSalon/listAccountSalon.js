import { LightningElement, wire } from "lwc";
import ACCOUNT_NAME_FIELD from "@salesforce/schema/Account.Name";
import ACCOUNT_SALONS_FIELD from "@salesforce/schema/Account.Number_of_salons__c";
import fetchAccount from "@salesforce/apex/DatabaseObjects.fetchAccount";
import fetchVehicles from "@salesforce/apex/DatabaseObjects.fetchVehicles";
import SALON_NAME_FIELD from "@salesforce/schema/Salon__c.Name";
import SALON_REGION_FIELD from "@salesforce/schema/Salon__c.Region__c";
import SALON_CITY_FIELD from "@salesforce/schema/Salon__c.City__c";
import VEHICLE_UPDATE_MESSAGE from "@salesforce/messageChannel/VehicleUpdate__c";
import getSalons from "@salesforce/apex/DatabaseObjects.getSalons";
import VEHICLE_SERIAL_NUMBER_FIELD from "@salesforce/schema/Vehicle__c.Serial_Number__c";
import VEHICLE_BRAND_FIELD from "@salesforce/schema/Vehicle__c.Brand__c";
import VEHICLE_MODEL_FIELD from "@salesforce/schema/Vehicle__c.Model__c";
import { publish, unsubscribe, MessageContext } from "lightning/messageService";
const ACCOUNTS_ACTIONS = [{ label: "Show salons", name: "show_salons" }];
const ACCOUNTS_COLUMNS = [
  {
    label: "Account Name",
    fieldName: ACCOUNT_NAME_FIELD.fieldApiName,
    type: "text"
  },
  {
    label: "Account Salons",
    fieldName: ACCOUNT_SALONS_FIELD.fieldApiName,
    type: "text"
  },

  {
    type: "action",
    typeAttributes: { rowActions: ACCOUNTS_ACTIONS }
  }
];
const SALON_ACTIONS = [{ label: "Show vehicles", name: "show_vehicles" }];
const SALONS_COLUMNS = [
  {
    label: "Salon Name",
    fieldName: SALON_NAME_FIELD.fieldApiName,
    type: "text"
  },
  {
    label: "City",
    fieldName: SALON_CITY_FIELD.fieldApiName,
    type: "text"
  },
  {
    label: "Region",
    fieldName: SALON_REGION_FIELD.fieldApiName,
    type: "text"
  },
  {
    type: "action",
    typeAttributes: { rowActions: SALON_ACTIONS }
  }
];
const VEHICLE_ACTIONS = [{ label: "Show details", name: "show_details" }];
const VEHICLE_COLUMNS = [
  {
    label: "Serial Number",
    fieldName: VEHICLE_SERIAL_NUMBER_FIELD.fieldApiName,
    type: "text"
  },
  {
    label: "Brand",
    fieldName: VEHICLE_BRAND_FIELD.fieldApiName,
    type: "text"
  },
  {
    label: "Model",
    fieldName: VEHICLE_MODEL_FIELD.fieldApiName,
    type: "text"
  },
  {
    type: "action",
    typeAttributes: { rowActions: VEHICLE_ACTIONS }
  }
];
export default class AccountList extends LightningElement {
  searchAccountName = "";
  accounts_columns = ACCOUNTS_COLUMNS;
  @wire(fetchAccount, { accName: "$searchAccountName" })
  accounts;
  salons_columns = SALONS_COLUMNS;
  searchAccountId = "";
  @wire(getSalons, { accountId: "$searchAccountId" })
  salons;
  searchSalonId = "";
  vehicles_columns = VEHICLE_COLUMNS;
  @wire(fetchVehicles, { salonId: "$searchSalonId" })
  vehicles;
  @wire(MessageContext) messageContext;
  showAccounts = true;
  showSalons = false;
  showVehicles = false;
  allSalons = false;
  allVehicles = false;

  handleBackClick(event) {
    if (this.showSalons) {
      this.showAccounts = true;
      this.showSalons = false;
      this.allSalons = false;
    } else if (this.showVehicles) {
      this.showSalons = true;
      this.showVehicles = false;
      this.allVehicles = false;
    }
  }

  handleAccountAction(event) {
    const actionName = event.detail.action.name;
    const row = event.detail.row;
    switch (actionName) {
      case "show_salons":
        this.searchAccountId = row.Id;
        this.showSalons = true;
        this.showAccounts = false;
        this.allSalons = false;
        this.allVehicles = false;
        break;
      default:
    }
  }

  handleSalonAction(event) {
    const actionName = event.detail.action.name;
    const row = event.detail.row;
    switch (actionName) {
      case "show_vehicles":
        this.searchSalonId = row.Id;
        this.showVehicles = true;
        this.showSalons = false;
        this.allSalons = false;
        this.allVehicles = false;
        break;
      default:
    }
  }

  handleVehicleAction(event) {
    const actionName = event.detail.action.name;
    const row = event.detail.row;
    switch (actionName) {
      case "show_details":
        this.loadVehicle(row);
        this.allSalons = false;
        this.allVehicles = false;

        break;
      default:
    }
  }

  handleInputChange(event) {
    this.searchAccountName = event.detail.value;
  }

  handleAllSalons() {
    this.searchAccountId = "";
    this.showSalons = true;
    this.showAccounts = false;
    this.showVehicles = false;
    this.allSalons = true;
    this.allVehicles = false;
  }

  handleAllVehicles() {
    this.searchSalonId = "";
    this.showSalons = false;
    this.showAccounts = false;
    this.showVehicles = true;
    this.allVehicles = true;
    this.allSalons = false;
  }

  handleAllAccounts() {
    this.searchAccountName = "";
    this.showSalons = false;
    this.showAccounts = true;
    this.showVehicles = false;
    this.allVehicles = false;
    this.allSalons = false;
  }

  loadVehicle(selected) {
    if (selected) {
      const message = {
        vehicle: selected
      };
      publish(this.messageContext, VEHICLE_UPDATE_MESSAGE, message);
    }
  }

  disconnectedCallback() {
    unsubscribe(this.subscription);
    this.subscription = null;
  }
}
