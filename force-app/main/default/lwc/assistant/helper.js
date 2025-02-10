const composeIFrameOrigin = () => {
    const iFrameOrigin =
        "https://" +
        window.location.hostname
            .replace(/^([^.]+)/, "$1--c")
            .replace("lightning", "vf");
    return iFrameOrigin;
};

const isValidIFrameOrigin = (event) => {
    const iFrameOrigin = composeIFrameOrigin();
    return event.origin === iFrameOrigin;
};

/**
 * @param {*} cmp - The `this` context of the Lightning Web Component.
 * @param {*} payload - The payload to be sent to the iframe.
 */
const sendMessageToIframe = (cmp, payload) => {
    const iframe = cmp.template.querySelector("iframe");
    iframe.contentWindow.postMessage(payload, composeIFrameOrigin());
};

const resetPayload = (cmp) => {
    cmp.selectedRecord = null;
    cmp.relatedRecordsJson = "";
    cmp.payload.clearUserPrompt();
};

export { isValidIFrameOrigin, sendMessageToIframe, resetPayload };
