{let item_type=ezpreference( 'admin_list_limit' )
     number_of_items=min( $item_type, 3)|choose( 10, 10, 25, 50 )
     select_name='SelectedObjectIDArray'
     select_type='checkbox'
     select_attribute='contentobject_id'
     browse_list_count=0
     page_uri_suffix=false()
     node_array=array()}
{section show=is_set( $node_list )}
    {def $page_uri=$requested_uri }
    {def $page_uri_suffix=concat( '?', $requested_uri_suffix)}
    {set browse_list_count=$node_list_count
         node_array=$node_list}
    {section-else}
    {def $page_uri=concat( '/content/browse/', $main_node.node_id )}

    {set browse_list_count=fetch( content, list_count, hash( parent_node_id, $node_id, depth, 1, objectname_filter, $view_parameters.namefilter))
         node_array=fetch( content, list, hash( parent_node_id, $node_id, depth, 1, offset, $view_parameters.offset, limit, $number_of_items, sort_by, $main_node.sort_array, objectname_filter, $view_parameters.namefilter ) )}
{/section}

{section show=eq( $browse.return_type, 'NodeID' )}
    {set select_name='SelectedNodeIDArray'}
    {set select_attribute='node_id'}
{/section}

{section show=eq( $browse.selection, 'single' )}
    {set select_type='radio'}
{/section}

{section show=$browse.description_template}
    {include name=Description uri=$browse.description_template browse=$browse }
{section-else}

<div class="context-block">

{* DESIGN: Header START *}<div class="box-header"><div class="box-tc"><div class="box-ml"><div class="box-mr"><div class="box-tl"><div class="box-tr">

<h1 class="context-title">{'Browse'|i18n( 'design/admin/content/browse' )}</h1>

{* DESIGN: Mainline *}<div class="header-mainline"></div>

{* DESIGN: Header END *}</div></div></div></div></div></div>

{* DESIGN: Content START *}<div class="box-bc"><div class="box-ml"><div class="box-mr"><div class="box-bl"><div class="box-br"><div class="box-content">

<div class="block">

<p>{'To select objects, choose the appropriate radiobutton or checkbox(es), and click the "Select" button.'|i18n( 'design/admin/content/browse' )}</p>
<p>{'To select an object that is a child of one of the displayed objects, click the object name and you will get a list of the children of the object.'|i18n( 'design/admin/content/browse' )}</p>

</div>

{* DESIGN: Content END *}</div></div></div></div></div></div>

</div>

{/section}

<div class="context-block">

<form name="browse" method="post" action={$browse.from_page|ezurl}>

{* DESIGN: Header START *}<div class="box-header"><div class="box-tc"><div class="box-ml"><div class="box-mr"><div class="box-tl"><div class="box-tr">
{section show=is_set( $node_list )|not()}
    {let current_node=fetch( content, node, hash( node_id, $browse.start_node ) )}
    {section show=$browse.start_node|gt( 1 )}
        <h2 class="context-title">
        <a href={concat( '/content/browse/', $main_node.parent_node_id, '/' )|ezurl}><img src={'back-button-16x16.gif'|ezimage} alt="{'Back'|i18n( 'design/admin/content/browse' )}" /></a>
        {$current_node.object.content_class.identifier|class_icon( original, $current_node.object.content_class.name|wash )}&nbsp;{$current_node.name|wash}&nbsp;[{$browse_list_count}]</h2>
    {section-else}
    <h2 class="context-title"><img src={'back-button-16x16.gif'|ezimage} alt="Back" /> {'folder'|class_icon( small, $current_node.object.content_class.name|wash )}&nbsp;{'Top level'|i18n( 'design/admin/content/browse' )}&nbsp;[{$current_node.children_count}]</h2>
    {/section}
    {/let}
{section-else}
 <h2 class="context-title"><img src={'back-button-16x16.gif'|ezimage} alt="Back" /> {'folder'|class_icon( small)}&nbsp;{'Search result'|i18n( 'design/admin/content/browse' )}&nbsp;[{$node_list|count()}]</h2>

{/section}
{* DESIGN: Subline *}<div class="header-subline"></div>

{* DESIGN: Header END *}</div></div></div></div></div></div>

{* DESIGN: Content START *}<div class="box-ml"><div class="box-mr"><div class="box-content">

{* Items per page and view mode selector. *}
<div class="context-toolbar">
<div class="block">
<div class="left">
    <p>
    {switch match=$number_of_items}
    {case match=25}
        <a href={'/user/preferences/set/admin_list_limit/1'|ezurl}>10</a>
        <span class="current">25</span>
        <a href={'/user/preferences/set/admin_list_limit/3'|ezurl}>50</a>

        {/case}

        {case match=50}
        <a href={'/user/preferences/set/admin_list_limit/1'|ezurl}>10</a>
        <a href={'/user/preferences/set/admin_list_limit/2'|ezurl}>25</a>
        <span class="current">50</span>
        {/case}

        {case}
        <span class="current">10</span>
        <a href={'/user/preferences/set/admin_list_limit/2'|ezurl}>25</a>
        <a href={'/user/preferences/set/admin_list_limit/3'|ezurl}>50</a>
        {/case}

        {/switch}
    </p>
</div>
<div class="right">
    <p>
    {switch match=ezpreference( 'admin_children_browsemode' )}
    {case match='thumbnail'}
      <a href={'/user/preferences/set/admin_children_browsemode/list'|ezurl} title="{'Display sub items using a simple list.'|i18n( 'design/admin/content/browse' )}">{'List'|i18n( 'design/admin/content/browse' )}</a>
      <span class="current">{'Thumbnail'|i18n( 'design/admin/content/browse' )}</span>
    {/case}
    {case}
      <span class="current">{'List'|i18n( 'design/admin/content/browse' )}</span>
      <a href={'/user/preferences/set/admin_children_browsemode/thumbnail'|ezurl} title="{'Display sub items as thumbnails.'|i18n( 'design/admin/content/browse' )}">{'Thumbnail'|i18n( 'design/admin/content/browse' )}</a>
    {/case}
    {/switch}
    </p>
</div>
<div class="break"></div>
</div>
</div>

{* Display the actual list of nodes. *}
{switch match=ezpreference( 'admin_children_browsemode' )}
    {case match='thumbnail'}
        {include uri='design:content/browse_mode_thumbnail.tpl'}
    {/case}
    {case}
        {include uri='design:content/browse_mode_list.tpl'}
    {/case}
{/switch}

<div class="context-toolbar">
{include name=navigator
         uri='design:navigator/alphabetical.tpl'
         page_uri=$page_uri
         page_uri_suffix=$page_uri_suffix
         item_count=$browse_list_count
         view_parameters=$view_parameters
         node_id=$node_id
         item_limit=$number_of_items}
</div>

{section var=PersistentData show=$browse.persistent_data loop=$browse.persistent_data}
    <input type="hidden" name="{$PersistentData.key|wash}" value="{$PersistentData.item|wash}" />
{/section}

<input type="hidden" name="BrowseActionName" value="{$browse.action_name}" />
{section show=$browse.browse_custom_action}
    <input type="hidden" name="{$browse.browse_custom_action.name}" value="{$browse.browse_custom_action.value}" />
{/section}

{section show=$cancel_action}
<input type="hidden" name="BrowseCancelURI" value="{$cancel_action}" />
{/section}

{* DESIGN: Content END *}</div></div></div>

<div class="controlbar">
{* DESIGN: Control bar START *}<div class="box-bc"><div class="box-ml"><div class="box-mr"><div class="box-tc"><div class="box-bl"><div class="box-br">
<div class="block">
    <input class="button" type="submit" name="SelectButton" value="{'Select'|i18n( 'design/admin/content/browse' )}" />
    <input class="button" type="submit" name="BrowseCancelButton" value="{'Cancel'|i18n( 'design/admin/content/browse' )}" />
</div>
{* DESIGN: Control bar END *}</div></div></div></div></div></div>
</div>

</form>

{/let}

</div>
