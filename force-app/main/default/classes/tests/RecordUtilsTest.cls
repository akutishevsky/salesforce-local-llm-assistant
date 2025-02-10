@IsTest
public with sharing class RecordUtilsTest {
    private static final String ACCOUNT_NAME = 'Test Account';

    @TestSetup
    static void makeData() {
        Test.startTest();
        TestDataFactory.createAccount(ACCOUNT_NAME);
        Test.stopTest();
    }

    @IsTest
    static void getPopulatedFieldsMultipleRecordIdsSuccess() {
        Test.startTest();
        List<Id> accountIds = new List<Id>{
            TestDataFactory.getAccountId(ACCOUNT_NAME)
        };
        Map<Id, Map<String, Object>> populatedFields = RecordUtils.getPopulatedFields(
            accountIds
        );
        Test.stopTest();

        Assert.isFalse(
            populatedFields.isEmpty(),
            'Populated fields should not be empty'
        );
        Assert.areEqual(
            ACCOUNT_NAME,
            String.valueOf(populatedFields.get(accountIds[0]).get('name')),
            'Name should be populated'
        );
    }

    @IsTest
    static void getPopulatedFieldsMultipleRecordIdsReturnNull() {
        Test.startTest();
        Map<Id, Map<String, Object>> populatedFields = RecordUtils.getPopulatedFields(
            new List<Id>()
        );
        Test.stopTest();

        Assert.isNull(populatedFields, 'Populated fields should be null');
    }

    @IsTest
    static void getPopulatedFieldsSingleRecordIdSuccess() {
        Test.startTest();
        Id accountId = TestDataFactory.getAccountId(ACCOUNT_NAME);
        List<Map<String, String>> populatedFields = RecordUtils.getPopulatedFields(
            accountId
        );
        Test.stopTest();

        Assert.isFalse(
            populatedFields.isEmpty(),
            'Populated fields should not be empty'
        );

        for (Map<String, String> field : populatedFields) {
            if (field.get('name') != null) {
                Assert.areEqual(
                    ACCOUNT_NAME,
                    field.get('name'),
                    'Name should be populated'
                );
            }
        }
    }
}
