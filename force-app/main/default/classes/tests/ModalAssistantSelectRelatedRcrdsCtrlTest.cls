@IsTest
public with sharing class ModalAssistantSelectRelatedRcrdsCtrlTest {
    private static final String ACCOUNT_NAME = 'Test Account';

    @TestSetup
    static void makeData() {
        Test.startTest();
        TestDataFactory.createAccount(ACCOUNT_NAME);
        Test.stopTest();
    }

    @IsTest
    static void getRelatedObjectsSuccess() {
        Test.startTest();
        List<Map<String, String>> relatedObjects = ModalAssistantSelectRelatedRecordsCtrl.getRelatedObjects(
            TestDataFactory.getAccountId(ACCOUNT_NAME)
        );
        Test.stopTest();

        Assert.isNotNull(relatedObjects, 'Related objects should not be null');
    }

    @IsTest
    static void getRelatedObjectsException() {
        Boolean exceptionThrown = false;

        try {
            ModalAssistantSelectRelatedRecordsCtrl.getRelatedObjects(null);
        } catch (Exception e) {
            exceptionThrown = true;
        }

        Assert.isTrue(exceptionThrown, 'Exception should be thrown');
    }

    @IsTest
    static void getObjectFieldsSuccess() {
        Test.startTest();
        List<Map<String, String>> objectFields = ModalAssistantSelectRelatedRecordsCtrl.getObjectFields(
            'Account'
        );
        Test.stopTest();

        Assert.isNotNull(objectFields, 'Object fields should not be null');
    }

    @IsTest
    static void getObjectFieldsException() {
        Boolean exceptionThrown = false;

        try {
            ModalAssistantSelectRelatedRecordsCtrl.getObjectFields(null);
        } catch (Exception e) {
            exceptionThrown = true;
        }

        Assert.isTrue(exceptionThrown, 'Exception should be thrown');
    }

    @IsTest
    static void getRelationshipFieldsSuccess() {
        Test.startTest();
        List<SObjectUtils.RelationshipField> relationshipFields = ModalAssistantSelectRelatedRecordsCtrl.getRelationshipFields(
            'Account',
            TestDataFactory.getAccountId(ACCOUNT_NAME)
        );
        Test.stopTest();

        Assert.isNotNull(
            relationshipFields,
            'Relationship fields should not be null'
        );
    }

    @IsTest
    static void getRelationshipFieldsException() {
        Boolean exceptionThrown = false;

        try {
            ModalAssistantSelectRelatedRecordsCtrl.getRelationshipFields(
                null,
                null
            );
        } catch (Exception e) {
            exceptionThrown = true;
        }

        Assert.isTrue(exceptionThrown, 'Exception should be thrown');
    }

    @IsTest
    static void selectRelatedRecordsSuccess() {
        Test.startTest();
        String payloadJson = JSON.serialize(
            new Map<String, Object>{
                'recordId' => TestDataFactory.getAccountId(ACCOUNT_NAME),
                'relatedObjectApiName' => 'Contact',
                'fields' => new List<String>{ 'Id', 'FirstName', 'LastName' },
                'parentRelationshipField' => 'AccountId'
            }
        );
        String result = ModalAssistantSelectRelatedRecordsCtrl.selectRelatedRecords(
            payloadJson
        );
        Test.stopTest();

        Assert.isNotNull(result, 'Result should not be null');
    }

    @IsTest
    static void selectRelatedRecordsException() {
        Boolean exceptionThrown = false;

        try {
            ModalAssistantSelectRelatedRecordsCtrl.selectRelatedRecords(null);
        } catch (Exception e) {
            exceptionThrown = true;
        }

        Assert.isTrue(exceptionThrown, 'Exception should be thrown');
    }
}
