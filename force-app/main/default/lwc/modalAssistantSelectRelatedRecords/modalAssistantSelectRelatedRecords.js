import { api, wire } from "lwc";
import LightningModal from "lightning/modal";

import getRelatedObjects from "@salesforce/apex/ModalAssistantSelectRelatedRecordsCtrl.getRelatedObjects";
import getObjectFields from "@salesforce/apex/ModalAssistantSelectRelatedRecordsCtrl.getObjectFields";
import getRelationshipFields from "@salesforce/apex/ModalAssistantSelectRelatedRecordsCtrl.getRelationshipFields";

export default class ModalAssistantSelectRelatedRecords extends LightningModal {
    @api content;

    selectedObject;
    selectedField;
    selectedObjectFields;
    selectedRelationshipField;

    _relatedObjects;
    get relatedObjects() {
        return this._relatedObjects;
    }

    _relationshipFields;
    get relationshipFields() {
        return this._relationshipFields;
    }

    @wire(getRelatedObjects, { recordId: "$content" })
    setRelatedObjects({ data, error }) {
        if (data) {
            this._relatedObjects = data;
        } else if (error) {
            console.error(error);
        }
    }

    @wire(getObjectFields, { objectApiName: "$selectedObject" })
    setObjectFields({ data, error }) {
        if (data) {
            this.selectedObjectFields = null;
            this.selectedObjectFields = data;
        } else if (error) {
            console.error(error);
        }
    }

    @wire(getRelationshipFields, {
        objectChild: "$selectedObject",
        parentRecordId: "$content"
    })
    setRelationshipFields({ data, error }) {
        if (data) {
            this._relationshipFields = data;
            this.selectedRelationshipField = this._relationshipFields[0].value;
        } else if (error) {
            console.error(error);
        }
    }

    modalClose() {
        this.close();
    }

    selectObject(event) {
        this.selectedObject = event.detail.value;
        console.log("this.selectedObject", this.selectedObject);
    }

    selectRelationshipField(event) {
        this.selectedRelationshipField = event.detail.value;
        console.log(
            "this.selectedRelationshipField",
            this.selectedRelationshipField
        );
    }

    selectField(event) {
        this.selectedField = event.detail.value;
    }

    confirm() {
        if (
            !this.selectedObject ||
            !this.selectedField ||
            !this.selectedRelationshipField
        ) {
            console.log("Please select an object and a field");
        }

        this.dispatchEvent(
            new CustomEvent("selectrelatedrecordsfields", {
                detail: {
                    selectedObject: this.selectedObject,
                    selectedField: this.selectedField,
                    selectedRelationshipField: this.selectedRelationshipField
                }
            })
        );

        this.modalClose();
    }
}
