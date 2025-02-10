public with sharing class RecordSelector {
    public static SObject selectRecord(List<String> fields, Id recordId) {
        String fieldsToSelect = String.join(fields, ',');
        String sObjectName = recordId.getSObjectType().getDescribe().getName();

        return Database.query(
            'SELECT ' +
                String.escapeSingleQuotes(fieldsToSelect) +
                ' FROM ' +
                String.escapeSingleQuotes(sObjectName) +
                ' WHERE Id = :recordId WITH USER_MODE'
        );
    }

    public static List<SObject> selectRecords(
        String sObjectName,
        List<String> sObjectFields,
        List<Id> recordIds
    ) {
        String fieldsToSelect = String.join(sObjectFields, ',');

        return Database.query(
            'SELECT ' +
                String.escapeSingleQuotes(fieldsToSelect) +
                ' FROM ' +
                String.escapeSingleQuotes(sObjectName) +
                ' WHERE Id IN :recordIds WITH USER_MODE'
        );
    }

    public static String selectRelatedRecords(String payloadJson) {
        RelatedRecordsPayload payload = (RelatedRecordsPayload) JSON.deserialize(
            payloadJson,
            RelatedRecordsPayload.class
        );

        String parentRecordId = payload.recordId;
        String fieldsToSelect = String.join(payload.fields, ',');

        List<SObject> records = Database.query(
            'SELECT ' +
                String.escapeSingleQuotes(fieldsToSelect) +
                ' FROM ' +
                String.escapeSingleQuotes(payload.relatedObjectApiName) +
                ' WHERE ' +
                String.escapeSingleQuotes(payload.parentRelationshipField) +
                ' = :parentRecordId WITH USER_MODE'
        );

        return JSON.serialize(records);
    }

    public class RelatedRecordsPayload {
        public String recordId;
        public String relatedObjectApiName;
        public List<String> fields;
        public String parentRelationshipField;

        public RelatedRecordsPayload() {
            return;
        }
    }
}
