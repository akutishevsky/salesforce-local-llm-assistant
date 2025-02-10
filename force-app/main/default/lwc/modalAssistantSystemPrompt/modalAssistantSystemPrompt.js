import { api, wire } from "lwc";
import LightningModal from "lightning/modal";
import getAll from "@salesforce/apex/ModalSystemPromptCtrl.getAll";

export default class ModalSystemPrompt extends LightningModal {
    @api content;

    modalClose() {
        this.close();
    }

    _systemPrompts;
    get systemPrompts() {
        return this._systemPrompts;
    }

    @wire(getAll, {})
    setSystemPrompts({ data, error }) {
        if (data) {
            this._systemPrompts = data;
        } else if (error) {
            console.error(error);
        }
    }

    selectPrompt(event) {
        const selectedPromptId = event.target.dataset.id;
        const selectedSystemPrompt = this._systemPrompts.find(
            (prompt) => prompt.Id === selectedPromptId
        );

        this.dispatchEvent(
            new CustomEvent("selectsystemprompt", {
                detail: { systemPrompt: selectedSystemPrompt.Prompt__c }
            })
        );

        this.close();
    }
}
