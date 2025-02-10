@IsTest
public with sharing class SystemPromptSelectorTest {
    @IsTest
    static void getAllSuccess() {
        String promptName = 'Test prompt';
        Integer numberOfPrompts = 5000;

        Test.startTest();

        TestDataFactory.createSystemPrompts(promptName, numberOfPrompts);
        List<System_Prompt__c> systemPrompts = SystemPromptSelector.getAll();

        Test.stopTest();

        Assert.areEqual(
            1000,
            systemPrompts.size(),
            'Number of prompts should be 1000'
        );
        Assert.isTrue(
            systemPrompts[0].Name.contains(promptName),
            'Prompt name should contain: ' + promptName
        );
    }
}
