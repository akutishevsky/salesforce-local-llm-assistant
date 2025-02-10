import { LightningElement, api } from "lwc";
import ModalAssistantConfiguration from "c/modalAssistantConfiguration";
import ModalAssistantSystemPrompt from "c/modalAssistantSystemPrompt";

export default class AssistantHeader extends LightningElement {
    @api deviceList;

    loadModel() {
        this.dispatchEvent(new CustomEvent("loadmodel", {}));
    }

    async openModalAssistantConfiguration() {
        await ModalAssistantConfiguration.open({
            size: "small",
            content: { deviceList: this.deviceList },
            onapplyconfiguration: (e) => {
                e.stopPropagation();
                this.dispatchEvent(
                    new CustomEvent("applyconfiguration", {
                        detail: e.detail.configuration
                    })
                );
            }
        });
    }

    async openModalSystemPrompt() {
        await ModalAssistantSystemPrompt.open({
            size: "small",
            content: "",
            onselectsystemprompt: (e) => {
                e.stopPropagation();
                this.selectSystemPrompt(e.detail.systemPrompt);
            }
        });
    }

    selectSystemPrompt(prompt) {
        this.dispatchEvent(
            new CustomEvent("selectsystemprompt", {
                detail: prompt
            })
        );
    }
}
