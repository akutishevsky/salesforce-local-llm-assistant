@IsTest
public with sharing class SObjectUtilsTest {
    private static final String ACCOUNT_NAME = 'Test';

    @TestSetup
    static void setup() {
        Test.startTest();
        TestDataFactory.createAccount(ACCOUNT_NAME);
        Test.stopTest();
    }

    @IsTest
    static void getRelatedObjectsSuccess() {
        Id recordId = TestDataFactory.getAccountId(ACCOUNT_NAME);

        Test.startTest();
        List<Map<String, String>> relatedObjects = SObjectUtils.getRelatedObjects(
            recordId
        );
        Test.stopTest();

        Assert.isFalse(
            relatedObjects.isEmpty(),
            'Related Objects should be populated'
        );
    }

    @IsTest
    static void getSObjectFieldsSuccess() {
        String sObjectApiName = 'Account';

        Test.startTest();

        List<Map<String, String>> sObjectFields = SObjectUtils.getSObjectFields(
            sObjectApiName
        );

        Test.stopTest();

        Assert.areEqual(
            false,
            sObjectFields.isEmpty(),
            'SObject Fields should be populated'
        );
    }

    @IsTest
    static void getRelationshipFieldsSuccess() {
        String childSObjectName = 'Contact';

        Test.startTest();
        Id accountId = TestDataFactory.getAccountId(ACCOUNT_NAME);
        List<SObjectUtils.RelationshipField> relationshipFields = SObjectUtils.getRelationshipFields(
            childSObjectName,
            accountId
        );
        Test.stopTest();

        Assert.isFalse(
            relationshipFields.isEmpty(),
            'Relationship Fields should be populated'
        );
    }
}
