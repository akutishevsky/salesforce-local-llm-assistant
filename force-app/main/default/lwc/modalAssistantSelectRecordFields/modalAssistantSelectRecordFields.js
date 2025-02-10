import { api, wire } from "lwc";
import LightningModal from "lightning/modal";
import getPopulatedFields from "@salesforce/apex/ModalAssistantSelectRecordFieldsCtrl.getPopulatedFields";

export default class ModalAssistantSelectRecordFields extends LightningModal {
    @api content;

    modalClose() {
        this.close();
    }

    _populatedFields;
    get populatedFields() {
        return this._populatedFields;
    }

    @wire(getPopulatedFields, { recordId: "$content" })
    setPopulatedFields({ data, error }) {
        if (data) {
            this._populatedFields = data;
        } else if (error) {
            console.error(error);
        }
    }

    selectField(event) {
        this._selectedFields = event.detail.value;
    }

    dispatchSelectFieldsEvent() {
        this.dispatchEvent(
            new CustomEvent("selectfields", {
                detail: { selectedFields: this._selectedFields }
            })
        );
        this.close();
    }
}
