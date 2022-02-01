import { api, LightningElement, wire } from "lwc";
import fetchAccount from "@salesforce/apex/AccountObjects.fetchAccount";
import fetchVehicles from "@salesforce/apex/AccountObjects.fetchVehicles";
import getSalons from "@salesforce/apex/AccountObjects.getSalons";
import ACCOUNT_NAME_FIELD from "@salesforce/schema/Account.Name";
import CAR_SERIAL_NUMBER_FIELD from "@salesforce/schema/Vehicle__c.Serial_Number__c";
import INTERNS_COUNT_FIELD from "@salesforce/schema/Salon__c.Number_of_interns__c";
import SALON_NAME_FIELD from "@salesforce/schema/Salon__c.Name";
import ACCOUNT_ID_FIELD from "@salesforce/schema/Account.Id";

import {
  publish,
  subscribe,
  unsubscribe,
  MessageContext
} from "lightning/messageService";

const ACCOUNTS_ACTIONS = [{ label: "Show salons", name: "show_salons" }];
const ACCOUNTS_COLUMNS = [
  {
    label: "Account Name",
    fieldName: ACCOUNT_NAME_FIELD.fieldApiName,
    type: "text"
  },
  {
    label: "Account ID",
    fieldName: ACCOUNT_ID_FIELD.fieldApiName,
    type: "text"
  },
  {
    type: "action",
    typeAttributes: { rowActions: ACCOUNTS_ACTIONS }
  }
];
const SALON_ACTIONS = [{ label: "Show vehicles", name: "show_vehicles" }];
const SALON_COLUMNS = [
  {
    label: "Salon Name",
    fieldName: SALON_NAME_FIELD.fieldApiName,
    type: "text"
  },
  {
    label: "Interns",
    fieldName: INTERNS_COUNT_FIELD.fieldApiName,
    type: "number"
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
    fieldName: CAR_SERIAL_NUMBER_FIELD.fieldApiName,
    type: "number"
  },
  {
    type: "action",
    typeAttributes: { rowActions: VEHICLE_ACTIONS }
  }
];
export default class AccountList extends LightningElement {
  accounts_columns = ACCOUNTS_COLUMNS;
  @wire(fetchAccount)
  accounts;
  searchAccountId = "";
  salons_columns = SALON_COLUMNS;
  @api recordId;
  @wire(getSalons, { accountId: "0017Q000004DzgXQAS" })
  salons;
  searchSalonId = "";
  cars_columns = VEHICLE_COLUMNS;
  @wire(fetchVehicles, { salonId: "$searchSalonId" })
  cars;
  @wire(MessageContext) messageContext;
  showAccounts = true;
  showSalons = false;
  showVehicles = false;

  handleBackClick(event) {
    if (this.showSalons) {
      this.showAccounts = true;
      this.showSalons = false;
    } else if (this.showVehicles) {
      this.showSalons = true;
      this.showCars = false;
    }
  }

  handleAccountRowAction(event) {
    const actionName = event.detail.action.name;
    const row = event.detail.row;
    switch (actionName) {
      case "show_salons":
        this.showSalons = true;
        this.showAccounts = false;
        break;
      default:
    }
  }

  handleShowroomRowAction(event) {
    const actionName = event.detail.action.name;
    const row = event.detail.row;
    switch (actionName) {
      case "show_cars":
        this.searchSalonId = row.recordId;
        this.showCars = true;
        this.showShowrooms = false;
        break;
      default:
    }
  }

  handleCarRowAction(event) {
    const actionName = event.detail.action.name;
    const row = event.detail.row;
    switch (actionName) {
      case "show_details":
        this.loadCar(row);
        break;
      default:
    }
  }

  loadCar(selectedCar) {
    if (selectedCar) {
      const message = {
        car: selectedCar
      };
      publish(this.messageContext, "updated", message);
    }
  }

  disconnectedCallback() {
    unsubscribe(this.subscription);
    this.subscription = null;
  }
}
