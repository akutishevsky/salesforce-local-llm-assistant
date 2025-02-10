@IsTest
public with sharing class TestDataFactory {
    public static Account createAccount(String name) {
        Account account = new Account(Name = name);
        insert account;
        return account;
    }

    public static Id getAccountId(String name) {
        return [SELECT Id FROM Account WHERE Name = :name].Id;
    }

    public static void createContacts(Id accountId, Integer numberOfContacts) {
        List<Contact> contacts = new List<Contact>();
        for (Integer i = 0; i < numberOfContacts; i++) {
            contacts.add(
                new Contact(
                    AccountId = accountId,
                    FirstName = 'Test',
                    LastName = 'Contact ' + i
                )
            );
        }
        insert contacts;
    }

    public static void createSystemPrompts(
        String promptName,
        Integer numberOfPrompts
    ) {
        List<System_Prompt__c> prompts = new List<System_Prompt__c>();
        for (Integer i = 0; i < numberOfPrompts; i++) {
            prompts.add(
                new System_Prompt__c(
                    Name = promptName + ' ' + i,
                    Prompt__c = 'Test prompt ' + i
                )
            );
        }
        insert prompts;
    }
}
