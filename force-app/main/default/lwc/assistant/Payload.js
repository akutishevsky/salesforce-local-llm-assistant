/**
 * the same as in the `force-app/main/default/pages/PicollmWeb.page`
 */
const IFRAME_STRATEGIES = {
    LOAD_MODEL: "LOAD_MODEL",
    GENERATE_RESPONSE: "GENERATE_RESPONSE",
    SET_SYSTEM_PROMPT: "SET_SYSTEM_PROMPT",
    SET_CONFIGURATION: "SET_CONFIGURATION"
};

const composeCSVHeader = (record) => {
    let csvHeader = "\n";
    const keys = Object.keys(record).filter((key) => key !== "attributes");
    csvHeader += keys.join(",");
    return csvHeader;
};

const composeCSVBody = (records) => {
    let csvBody = "\n";

    if (Array.isArray(records) === false) {
        records = [records];
    }

    records.forEach((record) => {
        const values = Object.entries(record)
            .filter(([key]) => key !== "attributes")
            .map(([, value]) => value);
        csvBody += values.join(",") + "\n";
    });
    return csvBody;
};

class Payload {
    picoApiKey = "";
    systemPrompt = "";
    userPrompt = "";
    configuration = {};
    strategy = "";

    /**
     * @param {string} picoApiKey - Pico API Key from the `Local_LLM_Assistant_Setting__mdt` custom metadata.
     */
    constructor(picoApiKey) {
        this.picoApiKey = picoApiKey;
        if (this.picoApiKey === "") {
            throw new Error("Pico API Key is not set.");
        }
    }

    setStrategy(strategy) {
        this.strategy = strategy;
        return this;
    }

    setConfiguration(event) {
        this.configuration = event.detail;
        return this;
    }

    setSystemPrompt(event) {
        this.systemPrompt = event.detail;
        return this;
    }

    /**
     * @param {*} cmp - The `this` context of the Lightning Web Component.
     * @param {*} userPrompt - The user prompt to be displayed in the chat.
     * @returns {Payload} - The instance of the `Payload` class.
     */
    setUserPrompt(cmp, userPrompt) {
        let prompt = "";

        if (cmp.selectedRecord !== null) {
            let selectedRecordCsv = composeCSVHeader(cmp.selectedRecord);
            selectedRecordCsv += composeCSVBody(cmp.selectedRecord);

            prompt += `${selectedRecordCsv}`;
        }

        if (cmp.relatedRecordsJson !== "") {
            const relatedRecords = JSON.parse(cmp.relatedRecordsJson);
            let relatedRecordsCsv = composeCSVHeader(relatedRecords[0]);
            relatedRecordsCsv += composeCSVBody(relatedRecords);
            prompt += `${relatedRecordsCsv}`;
        }

        prompt +=
            cmp.selectedRecord !== null || cmp.relatedRecordsJson !== ""
                ? `\n\n${userPrompt}`
                : `${userPrompt}`;

        this.userPrompt = prompt;

        if (this.userPrompt === "") {
            throw new Error("Please, provide a user prompt.");
        }

        return this;
    }

    clearUserPrompt() {
        this.userPrompt = "";
        return this;
    }

    getUserPrompt() {
        return this.userPrompt;
    }

    getPayload() {
        return {
            picoApiKey: this.picoApiKey,
            systemPrompt: this.systemPrompt,
            userPrompt: this.userPrompt,
            configuration: this.configuration,
            strategy: this.strategy
        };
    }
}

export { IFRAME_STRATEGIES, Payload };
