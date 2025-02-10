const MESSAGE_TYPE = {
    INBOUND: "inbound",
    OUTBOUND: "outbound"
};

class Message {
    constructor(component, message) {
        if (new.target === Message) {
            throw new TypeError("Cannot construct Message instances directly");
        }
        this.component = component;
        this.message = message;
    }

    createAvatarElement(messageElement, avatarIcon) {
        const avatarWrapper = document.createElement("span");
        avatarWrapper.setAttribute("aria-hidden", "true");
        avatarWrapper.classList.add(
            "slds-avatar",
            "slds-avatar_circle",
            "slds-chat-avatar"
        );

        const avatarInitials = document.createElement("span");
        avatarInitials.classList.add(
            "slds-avatar__initials",
            "slds-avatar__initials_inverse"
        );
        avatarInitials.innerText = avatarIcon;

        avatarWrapper.appendChild(avatarInitials);
        messageElement.appendChild(avatarWrapper);
    }

    createChatElements() {
        const chatContainer =
            this.component.template.querySelector(".slds-chat");

        const listItem = document.createElement("li");
        listItem.classList.add(
            "slds-chat-listitem",
            `slds-chat-listitem_${this.getMessageType()}`
        );

        const messageWrapper = document.createElement("div");
        messageWrapper.classList.add("slds-chat-message");

        this.createAvatarElement(messageWrapper, this.getAvatarIcon());

        return { chatContainer, listItem, messageWrapper };
    }

    createMessageBodyElements() {
        const messageBody = document.createElement("div");
        messageBody.classList.add("slds-chat-message__body");

        const messageText = document.createElement("div");
        messageText.classList.add(
            "slds-chat-message__text",
            `slds-chat-message__text_${this.getMessageType()}`
        );

        return { messageBody, messageText };
    }

    appendMessageText(messageTextElement) {
        if (!this.message) return;

        const textElement = document.createElement("span");
        textElement.innerText = this.message;
        messageTextElement.appendChild(textElement);
    }

    render() {
        const { chatContainer, listItem, messageWrapper } =
            this.createChatElements();
        const { messageBody, messageText } = this.createMessageBodyElements();

        this.appendMessageText(messageText);

        messageBody.appendChild(messageText);
        messageWrapper.appendChild(messageBody);
        listItem.appendChild(messageWrapper);

        const fragment = document.createDocumentFragment();
        fragment.appendChild(listItem);
        chatContainer.appendChild(fragment);

        return messageText;
    }

    getMessageType() {
        throw new Error("Method 'getMessageType()' must be implemented.");
    }

    getAvatarIcon() {
        throw new Error("Method 'getAvatarIcon()' must be implemented.");
    }
}

/**
 * Represents an inbound message in a chat interface.
 * @class
 * @extends Message
 *
 * @example
 * // Create and render an inbound message
 * const component = // ... your component reference
 * const message = "Hello, how can I help you?";
 * new InboundMessage(component, message).render();
 */
class InboundMessage extends Message {
    getMessageType() {
        return MESSAGE_TYPE.INBOUND;
    }

    getAvatarIcon() {
        return "🤖";
    }
}

/**
 * Represents an outbound message in a chat interface.
 * @class
 * @extends Message
 *
 * @example
 * // Create and render an outbound message
 * const component = // ... your component reference
 * const message = "I have a question about my account.";
 * new OutboundMessage(component, message).render();
 */
class OutboundMessage extends Message {
    getMessageType() {
        return MESSAGE_TYPE.OUTBOUND;
    }

    getAvatarIcon() {
        return "🧑‍💻";
    }
}

export { InboundMessage, OutboundMessage };
