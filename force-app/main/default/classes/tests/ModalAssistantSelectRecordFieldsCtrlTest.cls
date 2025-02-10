@IsTest
public with sharing class ModalAssistantSelectRecordFieldsCtrlTest {
    private static final String ACCOUNT_NAME = 'Test Account';

    @TestSetup
    static void makeData() {
        Test.startTest();
        TestDataFactory.createAccount(ACCOUNT_NAME);
        Test.stopTest();
    }

    @IsTest
    static void getPopulatedFieldsSuccess() {
        Test.startTest();
        Object populatedFields = ModalAssistantSelectRecordFieldsCtrl.getPopulatedFields(
            TestDataFactory.getAccountId(ACCOUNT_NAME)
        );
        Test.stopTest();

        Assert.isNotNull(
            populatedFields,
            'Populated Fields should not be null'
        );
    }

    @IsTest
    static void getPopulatedFieldsException() {
        Boolean exceptionThrown = false;

        try {
            ModalAssistantSelectRecordFieldsCtrl.getPopulatedFields(null);
        } catch (Exception e) {
            exceptionThrown = true;
        }

        Assert.isTrue(exceptionThrown, 'Exception should be thrown');
    }

    @IsTest
    static void selectRecordSuccess() {
        Test.startTest();
        SObject record = ModalAssistantSelectRecordFieldsCtrl.selectRecord(
            new List<String>{ 'Name' },
            TestDataFactory.getAccountId(ACCOUNT_NAME)
        );
        Test.stopTest();

        Assert.isNotNull(record, 'Record should not be null');
        Assert.areEqual(
            ACCOUNT_NAME,
            record.get('name'),
            'Record Name should be match'
        );
    }

    @IsTest
    static void selectRecordException() {
        Boolean exceptionThrown = false;

        try {
            ModalAssistantSelectRecordFieldsCtrl.selectRecord(null, null);
        } catch (Exception e) {
            exceptionThrown = true;
        }

        Assert.isTrue(exceptionThrown, 'Exception should be thrown');
    }
}
