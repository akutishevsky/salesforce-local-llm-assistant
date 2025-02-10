import { api } from "lwc";
import LightningModal from "lightning/modal";

export default class ModalAssistantConfiguration extends LightningModal {
    @api content;

    devices = [];
    selectedDevice;

    connectedCallback() {
        try {
            this.composeDevices(this.content.deviceList);
        } catch (error) {
            console.error(error);
        }
    }

    composeDevices(deviceList) {
        deviceList.forEach((device) => {
            const deviceParts = device.split(":");
            this.devices.push({
                label: deviceParts[1],
                value: deviceParts[0]
            });
        });
    }

    selectDevice(event) {
        this.selectedDevice = event.target.value;
    }

    modalClose() {
        this.close();
    }

    applyConfiguration() {
        try {
            this.dispatchEvent(
                new CustomEvent("applyconfiguration", {
                    detail: {
                        configuration: this.collectConfigValues()
                    }
                })
            );
            this.close();
        } catch (error) {
            console.error(error.message);
        }
    }

    collectConfigValues() {
        const completionTokenLimit = this.template.querySelector(
            '[data-name="completionTokenLimit"]'
        ).value;
        const temperature = this.template.querySelector(
            '[data-name="temperature"]'
        ).value;
        const topP = this.template.querySelector('[data-name="topP"]').value;

        return {
            completionTokenLimit: completionTokenLimit,
            temperature: temperature,
            topP: topP
        };
    }
}
