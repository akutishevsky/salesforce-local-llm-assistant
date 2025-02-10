public class PicklistLocalLLMAgentSettings extends VisualEditor.DynamicPickList {
    public override VisualEditor.DataRow getDefaultValue() {
        Local_LLM_Assistant_Setting__mdt setting = getSettings()[0];
        VisualEditor.DataRow defaultValue = new VisualEditor.DataRow(
            setting.Label,
            String.valueOf(setting.Id)
        );
        return defaultValue;
    }

    public override VisualEditor.DynamicPickListRows getValues() {
        VisualEditor.DynamicPickListRows values = new VisualEditor.DynamicPickListRows();
        List<Local_LLM_Assistant_Setting__mdt> settings = getSettings();
        for (Local_LLM_Assistant_Setting__mdt setting : settings) {
            values.addRow(
                new VisualEditor.DataRow(
                    setting.Label,
                    String.valueOf(setting.Id)
                )
            );
        }

        return values;
    }

    private List<Local_LLM_Assistant_Setting__mdt> getSettings() {
        return Local_LLM_Assistant_Setting__mdt.getAll().values();
    }
}
