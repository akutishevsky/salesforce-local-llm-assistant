public with sharing class ModalAssistantSelectRecordFieldsCtrl {
    @AuraEnabled(cacheable=true)
    public static Object getPopulatedFields(String recordId) {
        try {
            return RecordUtils.getPopulatedFields(recordId);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static SObject selectRecord(List<String> fields, Id recordId) {
        try {
            return RecordSelector.selectRecord(fields, recordId);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}
