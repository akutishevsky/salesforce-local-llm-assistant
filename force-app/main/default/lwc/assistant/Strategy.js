import * as chat from "./chat.js";

const STRATEGIES = {
    MODEL_LOADING: "MODEL_LOADING",
    MODEL_LOADED: "MODEL_LOADED",
    GENERATING_RESPONSE: "GENERATING_RESPONSE",
    STOPPED_GENERATING_RESPONSE: "STOPPED_GENERATING_RESPONSE",
    RECEIVED_DEVICE_LIST: "RECEIVED_DEVICE_LIST",
    DISPLAY_MESSAGE: "DISPLAY_MESSAGE"
};

const displayMessage = (cmp, message) => {
    chat.renderInboundMessage(cmp, message);
    chat.scrollChat(cmp);
    if (cmp.isLoading) {
        cmp.isLoading = false;
    }
};

const disableAnimation = (cmp) => {
    const article = cmp.template.querySelector("article");
    article.classList.remove("animated");
};

class Strategy {
    execute() {
        throw new Error("Strategy.execute() must be implemented.");
    }
}

class StrategyModelLoading extends Strategy {
    execute(cmp) {
        chat.renderInboundMessage(cmp, "Loading the model.");
        cmp.isLoading = true;
    }
}

class StrategyModelLoaded extends Strategy {
    execute(cmp) {
        chat.renderInboundMessage(cmp, "Successfully loaded the model.");
        cmp.isLoading = false;
        cmp.isModelLoaded = true;
    }
}

class StrategyGeneratingResponse extends Strategy {
    _payload;

    execute(cmp, payload) {
        try {
            this._payload = payload;

            if (!cmp.isGenerating) {
                chat.renderInboundMessage(cmp, "");
                cmp.isGenerating = true;
            }

            this.streamMessage(cmp);
            chat.scrollChat(cmp);
        } catch (error) {
            displayMessage(cmp, error.message);
        }
    }

    streamMessage(cmp) {
        const lastChatMessage = chat.getLastMessageElement(cmp);
        lastChatMessage.innerText += this._payload.token;
    }
}

class StrategyStoppedGenerating extends Strategy {
    execute(cmp) {
        try {
            cmp.isGenerating = false;
            disableAnimation(cmp);
        } catch (error) {
            displayMessage(cmp, error.message);
        }
    }
}

class StrategyReceivedDeviceList extends Strategy {
    execute(cmp, payload) {
        try {
            cmp.deviceList = payload.devices;
        } catch (error) {
            displayMessage(cmp, error.message);
        } finally {
            cmp.isLoading = false;
        }
    }
}

class StrategyDisplayMessage extends Strategy {
    execute(cmp, payload) {
        displayMessage(cmp, payload.message);
        disableAnimation(cmp);
    }
}

class Context {
    _strategy;

    constructor(strategy) {
        this._strategy = strategy;
    }

    executeStrategy(cmp, payload) {
        this._strategy.execute(cmp, payload);
    }
}

export {
    STRATEGIES,
    Context,
    Strategy,
    StrategyModelLoaded,
    StrategyModelLoading,
    StrategyGeneratingResponse,
    StrategyStoppedGenerating,
    StrategyReceivedDeviceList,
    StrategyDisplayMessage
};
