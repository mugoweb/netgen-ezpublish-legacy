<div class="block ajaxuploader-preview">
    <h4>{$node.name|wash()} ({$node.class_name|wash()})</h4>

    <dl>
    {foreach $node.data_map as $attribute}
        {if $attribute.has_content}
            <dt>{$attribute.contentclass_attribute_name|wash()}</dt>
            <dd>{attribute_view_gui attribute=$attribute}</dd>
        {/if}
    {/foreach}
    </dl>
</div>
