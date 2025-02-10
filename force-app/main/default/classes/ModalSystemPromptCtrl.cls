public with sharing class ModalSystemPromptCtrl {
    @AuraEnabled(cacheable=true)
    public static List<System_Prompt__c> getAll() {
        return SystemPromptSelector.getAll();
    }
}
