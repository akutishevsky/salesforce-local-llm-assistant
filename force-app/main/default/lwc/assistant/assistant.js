import { LightningElement, api, wire } from "lwc";
import { getRecord } from "lightning/uiRecordApi";
import * as chat from "./chat.js";
import { IFRAME_STRATEGIES, Payload } from "./Payload.js";
import {
    STRATEGIES,
    Context,
    StrategyModelLoaded,
    StrategyModelLoading,
    StrategyGeneratingResponse,
    StrategyStoppedGenerating,
    StrategyReceivedDeviceList,
    StrategyDisplayMessage
} from "./Strategy.js";
import * as helper from "./helper.js";

const SETTING_FIELDS = ["Local_LLM_Assistant_Setting__mdt.Pico_API_Key__c"];

export default class Assistant extends LightningElement {
    @api recordId;
    @api settingId;

    iFrameSrc = "/apex/PicollmWeb";
    isLoading = true;
    isModelLoaded = false;
    relatedRecordsJson = "";
    selectedRecord = null;

    deviceList;
    payload;

    isListening = false;
    renderedCallback() {
        if (this.isListening) return;

        window.addEventListener("message", (event) => {
            if (helper.isValidIFrameOrigin(event) === false) {
                return;
            }
            this.executeStrategy(event);
        });

        this.isListening = true;
    }

    executeStrategy(event) {
        let context;

        switch (event.data.strategy) {
            case STRATEGIES.MODEL_LOADING:
                context = new Context(new StrategyModelLoading());
                break;
            case STRATEGIES.MODEL_LOADED:
                context = new Context(new StrategyModelLoaded());
                break;
            case STRATEGIES.GENERATING_RESPONSE:
                context = new Context(new StrategyGeneratingResponse());
                break;
            case STRATEGIES.STOPPED_GENERATING_RESPONSE:
                context = new Context(new StrategyStoppedGenerating());
                break;
            case STRATEGIES.RECEIVED_DEVICE_LIST:
                context = new Context(new StrategyReceivedDeviceList());
                break;
            case STRATEGIES.DISPLAY_MESSAGE:
                context = new Context(new StrategyDisplayMessage());
                break;
            default:
                break;
        }

        context?.executeStrategy(this, event.data);
    }

    @wire(getRecord, { recordId: "$settingId", fields: SETTING_FIELDS })
    initPayload({ error, data }) {
        if (data) {
            this.payload = new Payload(data?.fields?.Pico_API_Key__c?.value);
        } else if (error) {
            chat.renderInboundMessage(this, error.message);
            chat.scrollChat(this);
        }
    }

    loadModel() {
        try {
            this.payload.setStrategy(IFRAME_STRATEGIES.LOAD_MODEL);
            helper.sendMessageToIframe(this, this.payload.getPayload());
        } catch (error) {
            chat.renderInboundMessage(this, error.message);
            chat.scrollChat(this);
        }
    }

    generateResponse(event) {
        try {
            if (this.isModelLoaded === false) {
                chat.renderInboundMessage(
                    this,
                    "Please, load the model first."
                );
                chat.scrollChat(this);
                return;
            }

            this.payload
                .setUserPrompt(this, event.detail)
                .setStrategy(IFRAME_STRATEGIES.GENERATE_RESPONSE);

            chat.renderOutboundMessage(this, this.payload.getUserPrompt());
            chat.scrollChat(this);

            const article = this.template.querySelector("article");
            article.classList.add("animated");

            helper.sendMessageToIframe(this, this.payload.getPayload());
            helper.resetPayload(this);
        } catch (error) {
            chat.renderInboundMessage(this, error.message);
            chat.scrollChat(this);
        }
    }

    setSelectedRecord(event) {
        this.selectedRecord = event.detail;
    }

    setRelatedRecords(event) {
        this.relatedRecordsJson = event.detail;
    }

    selectSystemPrompt(event) {
        try {
            this.payload
                .setSystemPrompt(event)
                .setStrategy(IFRAME_STRATEGIES.SET_SYSTEM_PROMPT);
            helper.sendMessageToIframe(this, this.payload.getPayload());
        } catch (error) {
            chat.renderInboundMessage(this, error.message);
            chat.scrollChat(this);
        }
    }

    applyConfiguration(event) {
        try {
            this.payload
                .setConfiguration(event)
                .setStrategy(IFRAME_STRATEGIES.SET_CONFIGURATION);
            helper.sendMessageToIframe(this, this.payload.getPayload());
        } catch (error) {
            chat.renderInboundMessage(this, error.message);
            chat.scrollChat(this);
        }
    }
}
