const renderInboundMessage = (cmp, message) => {
    const chat = cmp.template.querySelector("c-assistant-chat");
    chat.renderInboundMessage(message);
};

const renderOutboundMessage = (cmp, message) => {
    const chat = cmp.template.querySelector("c-assistant-chat");
    chat.renderOutboundMessage(message);
};

const getLastMessageElement = (cmp) => {
    const chat = cmp.template.querySelector("c-assistant-chat");
    return chat.getLastMessageElement();
};

const scrollChat = (cmp) => {
    const chat = cmp.template.querySelector("c-assistant-chat");
    chat.scrollChat();
};

export {
    renderInboundMessage,
    renderOutboundMessage,
    getLastMessageElement,
    scrollChat
};
