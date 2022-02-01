import { LightningElement, wire } from "lwc";
import VEHICLE_UPDATE_MESSAGE from "@salesforce/messageChannel/VehicleUpdate__c";
import { updateRecord } from "lightning/uiRecordApi";
import {
  subscribe,
  unsubscribe,
  MessageContext
} from "lightning/messageService";

export default class VehicleDetails extends LightningElement {
  vehicle = null;
  interested = false;
  cardTitle = "";
  subscription = null;
  @wire(MessageContext)
  messageContext;
  connectedCallback() {
    this.subscription = subscribe(
      this.messageContext,
      VEHICLE_UPDATE_MESSAGE,
      (message) => {
        this.handleVehicleUpdate(message);
      }
    );
  }

  disconnectedCallback() {
    unsubscribe(this.subscription);
    this.subscription = null;
  }

  handleVehicleUpdate(message) {
    this.vehicle = message.vehicle;
    this.cardTitle = message.vehicle.Name;
    this.interested = this.vehicle.Interested__c;
  }

  handleInterestClick(event) {
    var checkboxVal = event.target.checked;
    console.log(checkboxVal);
    let vehicleUpdate = {
      fields: {
        Id: this.vehicle.Id,
        Interested__c: checkboxVal
      }
    };

    updateRecord(vehicleUpdate);
  }
}
