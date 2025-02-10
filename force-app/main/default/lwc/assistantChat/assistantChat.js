import { LightningElement, api } from "lwc";
import { InboundMessage, OutboundMessage } from "./Message";

const SCROLL_X = 0;
const SCROLL_Y = 1000;

export default class AssistantChat extends LightningElement {
    @api renderInboundMessage(message) {
        new InboundMessage(this, message).render();
    }

    @api renderOutboundMessage(message) {
        new OutboundMessage(this, message).render();
    }

    @api getLastMessageElement() {
        const messages = this.template.querySelectorAll(
            ".slds-chat-message__text_inbound"
        );
        return messages[messages.length - 1];
    }

    @api scrollChat() {
        this.template.querySelector(".slds-chat").scrollBy(SCROLL_X, SCROLL_Y);
    }
}
