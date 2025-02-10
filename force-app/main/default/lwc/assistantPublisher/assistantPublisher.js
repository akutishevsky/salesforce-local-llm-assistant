import { LightningElement, api } from "lwc";
import ModalAssistantSelectRecordFields from "c/modalAssistantSelectRecordFields";
import ModalAssistantSelectRelatedRecords from "c/modalAssistantSelectRelatedRecords";
import selectRecord from "@salesforce/apex/ModalAssistantSelectRecordFieldsCtrl.selectRecord";
import selectRelatedRecords from "@salesforce/apex/ModalAssistantSelectRelatedRecordsCtrl.selectRelatedRecords";

export default class AssistantPublisher extends LightningElement {
    @api recordId;

    generateResponse() {
        const textarea = this.template.querySelector("textarea");

        this.dispatchEvent(
            new CustomEvent("generateresponse", { detail: textarea.value })
        );

        textarea.value = "";
    }

    async openModalAssistantSelectRecordFields() {
        await ModalAssistantSelectRecordFields.open({
            size: "small",
            content: this.recordId,
            onselectfields: (e) => {
                e.stopPropagation();
                this.selectRecord(e.detail);
            }
        });
    }

    async openModalAssistantSelectRelatedRecords() {
        await ModalAssistantSelectRelatedRecords.open({
            size: "small",
            content: this.recordId,
            onselectrelatedrecordsfields: async (e) => {
                e.stopPropagation();
                const relatedRecordsJson = await selectRelatedRecords({
                    payloadJson: JSON.stringify({
                        recordId: this.recordId,
                        relatedObjectApiName: e.detail.selectedObject,
                        fields: e.detail.selectedField,
                        parentRelationshipField:
                            e.detail.selectedRelationshipField
                    })
                });

                this.dispatchEvent(
                    new CustomEvent("selectedrelatedrecords", {
                        detail: relatedRecordsJson
                    })
                );
            }
        });
    }

    async selectRecord(detail) {
        const { selectedFields } = detail;
        const selectedRecord = await selectRecord({
            fields: selectedFields,
            recordId: this.recordId
        });

        this.dispatchEvent(
            new CustomEvent("selectedrecord", { detail: selectedRecord })
        );
    }
}
