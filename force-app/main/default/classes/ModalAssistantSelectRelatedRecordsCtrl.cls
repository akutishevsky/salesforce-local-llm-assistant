public with sharing class ModalAssistantSelectRelatedRecordsCtrl {
    @AuraEnabled(cacheable=true)
    public static List<Map<String, String>> getRelatedObjects(Id recordId) {
        try {
            return SObjectUtils.getRelatedObjects(recordId);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<Map<String, String>> getObjectFields(
        String objectApiName
    ) {
        try {
            return SObjectUtils.getSObjectFields(objectApiName);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<SObjectUtils.RelationshipField> getRelationshipFields(
        String objectChild,
        Id parentRecordId
    ) {
        try {
            return SObjectUtils.getRelationshipFields(
                objectChild,
                parentRecordId
            );
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static String selectRelatedRecords(String payloadJson) {
        try {
            return RecordSelector.selectRelatedRecords(payloadJson);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}
