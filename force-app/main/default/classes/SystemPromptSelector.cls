public with sharing class SystemPromptSelector {
    public static List<System_Prompt__c> getAll() {
        return [
            SELECT Name, Prompt__c
            FROM System_Prompt__c
            WITH USER_MODE
            ORDER BY CreatedDate DESC
            LIMIT 1000
        ];
    }
}
