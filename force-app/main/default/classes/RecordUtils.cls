public with sharing class RecordUtils {
    public static Map<Id, Map<String, Object>> getPopulatedFields(
        List<Id> recordIds
    ) {
        if (recordIds.isEmpty()) {
            return null;
        }

        Id recordId = recordIds[0];
        String sObjectName = getSObjectName(recordId);
        List<String> sObjectFields = getSObjectFields(recordId);

        List<SObject> records = RecordSelector.selectRecords(
            sObjectName,
            sObjectFields,
            recordIds
        );

        return extractPopulatedFields(records, sObjectFields);
    }

    public static List<Map<String, String>> getPopulatedFields(
        String recordId
    ) {
        Id recordIdAsId = (Id) recordId;
        String objectName = getSObjectName(recordIdAsId);

        Schema.DescribeSObjectResult describeResult = recordIdAsId.getSObjectType()
            .getDescribe();

        List<String> sObjectFields = getSObjectFields(recordIdAsId);

        SObject record = RecordSelector.selectRecord(
            sObjectFields,
            recordIdAsId
        );

        return extractPopulatedFields(record);
    }

    private static String getSObjectName(Id recordId) {
        return recordId.getSObjectType().getDescribe().getName();
    }

    private static List<String> getSObjectFields(Id recordId) {
        Schema.DescribeSObjectResult describeResult = recordId.getSObjectType()
            .getDescribe();
        Map<String, SObjectField> fields = describeResult.fields.getMap();
        List<String> accessibleFields = new List<String>();
        for (String fieldName : fields.keySet()) {
            Boolean isAccessible = fields.get(fieldName)
                .getDescribe()
                .isAccessible();
            if (isAccessible) {
                accessibleFields.add(fieldName);
            }
        }
        return accessibleFields;
    }

    private static Map<Id, Map<String, Object>> extractPopulatedFields(
        List<SObject> records,
        List<String> sObjectFields
    ) {
        Map<Id, Map<String, Object>> populatedFieldsByRecordIds = new Map<Id, Map<String, Object>>();

        for (SObject record : records) {
            Map<String, Object> populatedFields = new Map<String, Object>();
            for (String fieldName : sObjectFields) {
                if (record.get(fieldName) != null) {
                    populatedFields.put(fieldName, record.get(fieldName));
                }
            }
            populatedFieldsByRecordIds.put(record.Id, populatedFields);
        }

        return populatedFieldsByRecordIds;
    }

    private static List<Map<String, String>> extractPopulatedFields(
        SObject record
    ) {
        List<Map<String, String>> populatedFields = new List<Map<String, String>>();

        for (String key : record.getPopulatedFieldsAsMap().keySet()) {
            populatedFields.add(
                new Map<String, String>{ 'label' => key, 'value' => key }
            );
        }

        return populatedFields;
    }
}
