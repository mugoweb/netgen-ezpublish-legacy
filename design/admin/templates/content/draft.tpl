{let item_type=ezpreference( 'items' )
     number_of_items=min( $item_type, 3)|choose( 10, 10, 25, 50 )
     list_count=fetch('content','draft_count')
     draft_list=fetch( content, draft_version_list, hash( limit, $number_of_items, offset, $view_parameters.offset ) )}

<form name="draftaction" action={concat( 'content/draft/' )|ezurl} method="post">

<div class="context-block">
{* DESIGN: Header START *}<div class="box-header"><div class="box-tc"><div class="box-ml"><div class="box-mr"><div class="box-tl"><div class="box-tr">
<h1 class="context-title">{'My drafts [%draft_count]'|i18n(  'design/admin/content/draft',, hash( '%draft_count', $list_count ) )}</h1>

{* DESIGN: Mainline *}<div class="header-mainline"></div>

{* DESIGN: Header END *}</div></div></div></div></div></div>

{* DESIGN: Content START *}<div class="box-ml"><div class="box-mr"><div class="box-content">

{section show=$draft_list}

{* Items per page and view mode selector. *}
<div class="context-toolbar">
<div class="block">
<div class="left">
    <p>
    {switch match=$number_of_items}
        {case match=25}
        <a href={'/user/preferences/set/items/1/content/draft'|ezurl}>10</a>
        <span class="current">25</span>
        <a href={'/user/preferences/set/items/3/content/draft'|ezurl}>50</a>
        {/case}

        {case match=50}
        <a href={'/user/preferences/set/items/1/content/draft'|ezurl}>10</a>
        <a href={'/user/preferences/set/items/2/content/draft'|ezurl}>25</a>
        <span class="current">50</span>
        {/case}

        {case}
        <span class="current">10</span>
        <a href={'/user/preferences/set/items/2/content/draft'|ezurl}>25</a>
        <a href={'/user/preferences/set/items/3/content/draft'|ezurl}>50</a>
        {/case}
    {/switch}
    </p>
</div>
<div class="break"></div>
</div>
</div>

<table class="list" cellspacing="0">
<tr>
    <th class="tight"><img src={'toggle-button-16x16.gif'|ezimage} alt="{'Invert selection.'|i18n( 'design/admin/content/draft' )}" onclick="ezjs_toggleCheckboxes( document.draftaction, 'DeleteIDArray[]' ); return false;" title="{'Invert selection.'|i18n( 'design/admin/content/draft' )}" /></th>
    <th>{'Name'|i18n( 'design/admin/content/draft' )}</th>
    <th>{'Type'|i18n( 'design/admin/content/draft' )}</th>
    <th>{'Section'|i18n( 'design/admin/content/draft' )}</th>
    <th>{'Modified'|i18n( 'design/admin/content/draft' )}</th>
    <th class="tight">&nbsp;</th>
</tr>

{section var=Drafts loop=$draft_list sequence=array( bglight, bgdark )}
<tr class="{$Drafts.sequence}">
    <td><input type="checkbox" name="DeleteIDArray[]" value="{$Drafts.item.id}" title="{'Select draft for removal.'|i18n( 'design/admin/content/draft' )}" /></td>
    <td>{$Drafts.item.contentobject.content_class.identifier|class_icon( small, $Drafts.item.contentobject.content_class.name )}&nbsp;<a href={concat( '/content/versionview/', $Drafts.item.contentobject.id, '/', $Drafts.item.version, '/' )|ezurl}>{$Drafts.item.contentobject.name|wash}</a></td>
    <td>{$Drafts.item.contentobject.content_class.name|wash}</td>
    <td>{fetch( section, object, hash( section_id, $Drafts.item.contentobject.section_id ) ).name|wash}</td>
    <td>{$Drafts.item.modified|l10n( shortdatetime )}</td>
    <td><a href={concat( '/content/edit/', $Drafts.item.contentobject.id, '/', $Drafts.item.version, '/' )|ezurl} title="{'Edit <%draft_name>.'|i18n( 'design/admin/content/draft',, hash( '%draft_name', $Drafts.item.name ) )|wash}" ><img src={'edit.png'|ezimage} border="0"></a></td>
</tr>
{/section}
</table>
{section-else}
<div class="block">
<p>{'There are no drafts that belong to you.'|i18n( 'design/admin/content/draft' )}</p>
</div>
{/section}

<div class="context-toolbar">
{include name=navigator
         uri='design:navigator/google.tpl'
         page_uri='/content/draft'
         item_count=$list_count
         view_parameters=$view_parameters
         item_limit=$number_of_items}
</div>

{* DESIGN: Content END *}</div></div></div>

<div class="controlbar">
{* DESIGN: Control bar START *}<div class="box-bc"><div class="box-ml"><div class="box-mr"><div class="box-tc"><div class="box-bl"><div class="box-br">
<div class="block">
{section show=$draft_list}
    <input class="button" type="submit" name="RemoveButton" value="{'Remove selected'|i18n( 'design/admin/content/draft')}" title="{'Remove selected drafts.'|i18n( 'design/admin/content/draft' )}" />
    <input class="button" type="submit" name="EmptyButton"  value="{'Remove all'|i18n( 'design/admin/content/draft')}" title="{'Remove all drafts that belong to you.'|i18n( 'design/admin/content/draft' )}" />
{section-else}
    <input class="button-disabled" type="submit" name="RemoveButton" value="{'Remove selected'|i18n( 'design/admin/content/draft')}" disabled="disabled" />
    <input class="button-disabled" type="submit" name="EmptyButton"  value="{'Remove all'|i18n( 'design/admin/content/draft')}" disabled="disabled" />
{/section}
</div>
{* DESIGN: Control bar END *}</div></div></div></div></div></div>
</div>

</div>

{/let}
