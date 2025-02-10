public with sharing class SObjectUtils {
    public static List<Map<String, String>> getRelatedObjects(Id recordId) {
        List<Map<String, String>> relatedObjects = new List<Map<String, String>>();

        Schema.SObjectType targetType = recordId.getSObjectType();
        Schema.DescribeSObjectResult targetDescribe = targetType.getDescribe();

        List<Schema.ChildRelationship> childRelationships = targetDescribe.getChildRelationships();

        for (Schema.ChildRelationship relationship : childRelationships) {
            Schema.SObjectType childObjectType = relationship.getChildSObject();
            Schema.DescribeSObjectResult childDescribe = childObjectType.getDescribe();

            String objectLabel = childDescribe.getLabel();
            String objectApiName = childDescribe.getName();

            relatedObjects.add(
                new Map<String, String>{
                    'label' => objectLabel,
                    'value' => objectApiName
                }
            );
        }

        return relatedObjects;
    }

    public static List<Map<String, String>> getSObjectFields(
        String sObjectApiName
    ) {
        List<Map<String, String>> sObjectFields = new List<Map<String, String>>();

        Schema.SObjectType sObjectType = Schema.getGlobalDescribe()
            .get(sObjectApiName);

        Schema.DescribeSObjectResult sObjectDescribeResult = sObjectType.getDescribe();
        Map<String, Schema.SObjectField> fieldsByNames = sObjectDescribeResult.fields.getMap();

        for (String fieldName : fieldsByNames.keySet()) {
            Schema.DescribeFieldResult fieldDescribe = fieldsByNames.get(
                    fieldName
                )
                .getDescribe();

            Map<String, String> valuesByLabels = new Map<String, String>{
                'label' => fieldDescribe.getLabel(),
                'value' => fieldName
            };

            sObjectFields.add(valuesByLabels);
        }

        return sObjectFields;
    }

    public static List<RelationshipField> getRelationshipFields(
        String childSObjectName,
        Id parentRecordId
    ) {
        Schema.DescribeSObjectResult[] childSObjectDescribeResults = Schema.describeSObjects(
            new List<String>{ childSObjectName }
        );
        Schema.DescribeSObjectResult childSObjectDescribeResult = childSObjectDescribeResults[0]
            .getSObjectType()
            .getDescribe();
        String parentSObjectName = parentRecordId.getSObjectType()
            .getDescribe()
            .getName();

        Map<String, Schema.SObjectField> sourceFields = childSObjectDescribeResult.fields.getMap();

        return composeRelationshipFields(parentSObjectName, sourceFields);
    }

    private static List<RelationshipField> composeRelationshipFields(
        String parentSObjectName,
        Map<String, Schema.SObjectField> sourceFields
    ) {
        List<RelationshipField> relationshipFields = new List<RelationshipField>();

        for (String fieldName : sourceFields.keySet()) {
            Schema.DescribeFieldResult fieldDescribe = sourceFields.get(
                    fieldName
                )
                .getDescribe();

            Boolean isReferenceField =
                fieldDescribe.getType() == Schema.DisplayType.REFERENCE;
            if (isReferenceField == false) {
                continue;
            }

            List<SObjectType> relatedSObjectTypes = fieldDescribe.getReferenceTo();
            for (SObjectType relatedSObjectType : relatedSObjectTypes) {
                Boolean isRelatedSObject =
                    relatedSObjectType.getDescribe().getName() ==
                    parentSObjectName;

                if (isRelatedSObject == false) {
                    continue;
                }

                relationshipFields.add(
                    new RelationshipField(
                        relatedSObjectType.getDescribe().getLabel() +
                            ' (' +
                            fieldName +
                            ')',
                        fieldName
                    )
                );
            }
        }

        return relationshipFields;
    }

    public class RelationshipField {
        @AuraEnabled
        public String label { get; set; }
        @AuraEnabled
        public String value { get; set; }

        public RelationshipField(String label, String value) {
            this.label = label;
            this.value = value;
        }
    }
}
