@IsTest
public with sharing class RecordSelectorTest {
    private static final String ACCOUNT_NAME = 'Test Account';
    private static final Integer NUMBER_OF_CONTACTS = 3;

    @TestSetup
    static void makeData() {
        Test.startTest();
        Account account = TestDataFactory.createAccount(ACCOUNT_NAME);
        TestDataFactory.createContacts(account.Id, NUMBER_OF_CONTACTS);
        Test.stopTest();
    }

    @IsTest
    static void selectRecordSuccess() {
        Test.startTest();
        Account account = (Account) RecordSelector.selectRecord(
            new List<String>{ 'Id', 'Name' },
            TestDataFactory.getAccountId(ACCOUNT_NAME)
        );
        Test.stopTest();

        Assert.areEqual(
            ACCOUNT_NAME,
            account.Name,
            'Account name should match'
        );
    }

    @IsTest
    static void selectRecordsSuccess() {
        Test.startTest();
        List<Account> accounts = (List<Account>) RecordSelector.selectRecords(
            'Account',
            new List<String>{ 'Id', 'Name' },
            new List<Id>{ TestDataFactory.getAccountId(ACCOUNT_NAME) }
        );
        Test.stopTest();

        Assert.areEqual(
            ACCOUNT_NAME,
            accounts[0].Name,
            'Account name should match'
        );
    }

    @IsTest
    static void selectRelatedRecordsSuccess() {
        Map<String, Object> payload = new Map<String, Object>{
            'recordId' => TestDataFactory.getAccountId(ACCOUNT_NAME),
            'relatedObjectApiName' => 'Contact',
            'fields' => new List<String>{ 'Id', 'FirstName', 'LastName' },
            'parentRelationshipField' => 'AccountId'
        };
        Test.startTest();
        String recordsJson = RecordSelector.selectRelatedRecords(
            JSON.serialize(payload)
        );
        Test.stopTest();

        List<Contact> contacts = (List<Contact>) JSON.deserialize(
            recordsJson,
            List<Contact>.class
        );
        Assert.isNotNull(contacts, 'Contacts should not be null');
        Assert.areEqual(
            NUMBER_OF_CONTACTS,
            contacts.size(),
            'Number of contacts should match'
        );
    }

    @IsTest
    static void coverRelatedRecordsPayloadConstructorSuccess() {
        RecordSelector.RelatedRecordsPayload payload = new RecordSelector.RelatedRecordsPayload();
        Assert.isNotNull(payload, 'Payload should not be null');
    }
}
