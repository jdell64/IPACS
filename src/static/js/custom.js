$('#change_tags').each(function(){
    var $this = $(this);
    var t = $this.text();
    $this.html(t.replace('\"',''));
    $this.html(t.replace('&lt','<').replace('&gt', '>'));

});$

$('#attached_files').each(function(){
    var $this = $(this);
    var t = $this.text();
    $this.html(t.replace('\"',''));
    $this.html(t.replace('&lt','<').replace('&gt', '>'));

});$


function isInArray(value, array) {
    return array.indexOf(value) > -1;
}
$(document).ready(function () {

    $('.add').click(function (e) {
        var selectedOpts = $('#lstBox1 option:selected');
        var list_in_box = []
        $('#lstBox2 option').each(function () {
            list_in_box.push($(this).val())
        });

        if (selectedOpts.length == 0) {
            e.preventDefault();
        }

        if (list_in_box) {
            if (!isInArray(selectedOpts.val(), list_in_box)) {
                $('#lstBox2').append($(selectedOpts).clone());
            }
        } else {
            $('#lstBox2').append($(selectedOpts).clone());
        }
        e.preventDefault();
    });

    $('.delete').click(function (e) {

        var selectedOpts = $('#lstBox2 option:selected');
        if (selectedOpts.length == 0) {

            e.preventDefault();
        }

        $(selectedOpts).remove();
        e.preventDefault();
    });
    $('.add2').click(function (e) {
        var other_field_str = $('#other_field').val();
        var other_field = $('<option>', {
            value: other_field_str,
            text: other_field_str
        });
        var list_in_box = []
        $('#lstBox2 option').each(function () {
            list_in_box.push($(this).val())
        });

        if (list_in_box) {
            if (!isInArray(other_field.val(), list_in_box)) {
                $('#lstBox2').append(other_field);
            }
        } else {
            $('#lstBox2').append(other_field);
        }

        e.preventDefault();
    });
});

