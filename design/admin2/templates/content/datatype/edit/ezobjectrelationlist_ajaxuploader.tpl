{def $uploadable_classes = ezini( 'CreateSettings', 'MimeClassMap', 'upload.ini' )|append( ezini( 'CreateSettings', 'DefaultClass', 'upload.ini' ) )|unique()
     $allowed_class_list = $attribute.class_content.class_constraint_list
     $merge_count = $uploadable_classes|merge( $allowed_class_list )|count()
     $merge_unique_count = $uploadable_classes|merge( $allowed_class_list )|unique()|count()}
{if and( ezmodule( 'ezjscore' ),
        or( $allowed_class_list|count()|eq( 0 ), $merge_count|gt( $merge_unique_count ) ) )}
    <input type="submit" value="{'Upload a file'|i18n( 'design/admin2/content/datatype' )}"
            name="RelationUploadNew{$attribute.id}-{$attribute.version}"
            class="button relation-upload-new hide"
            title="{'Upload a file to create a new object and add it to the relation'|i18n( 'design/admin2/content/datatype' )}" />

    {run-once}
    {ezscript_require( 'ezjsc::yui3', 'ezjsc::yui3io', 'ezmodalwindow.js', 'ezajaxuploader.js' )}
    <script type="text/javascript">
    {literal}
    (function () {
        var uploaderConf = {
            target: {},
            open: {
                action: 'ezajaxuploader::uploadform::ezobjectrelationlist'
            },
            upload: {
                action: 'ezajaxuploader::upload::ezobjectrelationlist',
                form: 'form.ajaxuploader-upload'
            },
            location: {
                action: 'ezajaxuploader::preview::ezobjectrelationlist',
                form: 'form.ajaxuploader-location',
                browse: 'div.ajaxuploader-browse',
    {/literal}
                required: "{'Please choose a location'|i18n( 'design/admin2/content/datatype' )|wash( 'javascript' )}"
    {literal}
            },

            preview: {
                form: 'form.ajaxuploader-preview',

                // this is the eZAjaxUploader instance
                callback: function () {
                    var box = this.Y.one('#ezobjectrelationlist_browse_' + this.conf.target.ObjectRelationsAttributeId),
                        table = box.one('table.list');
                        tbody = box.one('table.list tbody'),
                        last = tbody.get('children').slice(-1).item(0),
                        tr = false, priority = false, tds = false,
                        result = this.lastMetaData;

                    if ( !table.hasClass('hide') ) {
                        // table is visible, clone the last line
                        tr = last.cloneNode(true);
                        tbody.append(tr);
                        if ( last.hasClass('bgdark') ) {
                            tr.removeClass('bgdark').addClass('bglight');
                        } else {
                            tr.removeClass('bglight').addClass('bgdark');
                        }
                    } else {
                        // table is hidden, no related object yet
                        // the only line in the table is the "template line"
                        tr = last;
                        table.removeClass('hide');
                    }
                    tds = tr.get('children');
                    tds.item(0).all('input').set('value', result.object_info.id);
                    tds.item(1).setContent(result.object_info.name);
                    tds.item(2).setContent(result.object_info.class_name);
                    tds.item(3).setContent(result.object_info.section_name);
                    tds.item(4).setContent(result.object_info.published);
                    priority = tds.item(5).one('input');
                    priority.set('value', parseInt(priority.get('value')) + 1);

                    box.one('input[name*=_data_object_relation_list_ajax_filled_]').set('value', 1);

                    box.one('.ezobject-relation-remove-button').removeClass('button-disabled').addClass('button').set('disabled', false);
                    box.all('.ezobject-relation-no-relation').addClass('hide');

                    this.modalWindow.close();
                }
            },
    {/literal}
            title: "{'Upload a file and add the resulting object in the relation'|i18n( 'design/admin2/content/datatype' )|wash( 'javascript' )}",
    {literal}

            // validation, error settings
            requiredInput: 'input.input-required',
            labelErrorClass: 'message-error',
            validationErrorText: "Some required fields are empty.",
            validationErrorTextElement: '.ajaxuploader-error',
            errorTemplate: '<div class="message-error">%message</div>',

            loading:{
                opacity: 0.2,
                loader: "#ajaxuploader-loader",
                zIndex:51
            }
        };

        var windowConf = {
            window: '#modal-window',
            content: '.window-content',
            close: '.window-close, .window-cancel',
            title: 'h2 span',
            width: 650,
            centered: false,
            xy: ['centered', 50],
            zIndex: 50,
            mask: '#overlay-mask'
        };

        YUI().use('node', 'overlay', 'dom-base', 'io-ez', 'io-form', 'io-upload-iframe', 'json-parse', function (Y) {
            Y.on('domready', function() {
                var win = new eZModalWindow(windowConf, Y),
                    tokenNode = Y.one('#ezxform_token_js');

                Y.all('.relation-upload-new').each(function () {
                    var data = this.get('name').replace("RelationUploadNew", '').split("-"),
                        conf = Y.clone(uploaderConf, true),
                        uploader;

                    conf.target = {
                       ObjectRelationsAttributeId: data[0],
                       Version: data[1]
                    };
                    if ( tokenNode ) {
                        conf.token = _tokenNode.get('title');
                    }
                    uploader = new eZAjaxUploader(win, conf, Y);
                    this.on('click', function (e) {
                        uploader.open();
                        e.halt();
                    });
                    this.removeClass('hide');
                });
            });
        });

    })();
    {/literal}
    </script>
    {/run-once}
{/if}
{undef $merge_count $merge_unique_count $allowed_class_list $uploadable_classes}
