{* DO NOT EDIT THIS FILE! Use an override template instead. *}
<div class="block">
    <label>{'Default value'|i18n( 'design/standard/class/datatype' )}</label>
    <input type="checkbox" name="ContentClass_ezboolean_default_value_{$class_attribute.id}" {$class_attribute.data_int3|choose( '', 'checked="checked"' )} />
    <input type="hidden" name="ContentClass_ezboolean_default_value_{$class_attribute.id}_exists" value="1" />
</div>
