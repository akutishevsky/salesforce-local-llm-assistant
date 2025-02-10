@IsTest
public with sharing class PicklistLocalLLMAgentSettingsTest {
    @IsTest
    static void getDefaultValueSuccess() {
        Test.startTest();
        VisualEditor.DataRow defaultValue = new PicklistLocalLLMAgentSettings()
            .getDefaultValue();
        Test.stopTest();

        Assert.isNotNull(defaultValue, 'Default value should not be null');
    }

    @IsTest
    static void getValuesSuccess() {
        Test.startTest();
        VisualEditor.DynamicPickListRows values = new PicklistLocalLLMAgentSettings()
            .getValues();
        Test.stopTest();

        Assert.isNotNull(values, 'Values should not be null');
    }
}
