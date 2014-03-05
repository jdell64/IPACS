//TODO: JS FIDDLE: http://jsfiddle.net/jdell64/Tu9bB/39/

var noOfFields = 0;
var headerIndex = 0;
var endJSON_String = "";
$('#submit').hide();
var json_obj = new Object();
var infoList = [];
var infoDocs = {};
var headerList = [];

function resetKVPairs() {

    var str = '<label for="key0">key</label><input name="key0" id="key0" class="key" type="text" />'
    str += '<label for="value0">value</label><input name="value0" id="value0" class="value" type="text" />'
    noOfFields = 0;
    $('#kv_pairs').empty()
    $('#kv_pairs').append(str)
}


//set the name, device type, and os seperately

//TODO: two functions scrub quotes, scrub white spaces

//TODO: HIDE AND SHOWS
//TODO: MAKE BACK BUTTONS AND START OVER BUTTON

function isInArray(value, array) {
    return array.indexOf(value) > -1;
}

function cleanSpaces(input_string) {
    return input_string.replace(/\s/g, '_');
}

$(document).ready(function () {
    //get the list boxes working:

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
        var other_field_str = cleanSpaces($('#other_field').val());
        if (other_field_str) {
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
        }
    });



    //next buttons working
    $('#top_three_next').click(function (e) {

        json_obj.name = $('#name').val(); //manditory
        json_obj.device_type = $('#device_type').val(); //manditory
        json_obj.os = $('#os').val(); //not a manditory field


        //debug lines:
        endJSON_String = JSON.stringify(json_obj);
        $('#test').text(endJSON_String);
    });

    $('#info_headers_next').click(function (e) {
        var list_in_box = [];
        headerList = [];
        $('#lstBox2 option').each(function () {
            list_in_box.push($(this).val());
        });

        //add the values of multiListValues (type=array) to headerList

        var index = 0;
        for (index = 0; index < list_in_box.length; index++) {
            // get rid of white space and quotes before adding
            headerList.push(list_in_box[index]);
        }

        $('#current_header').text(headerList[0])



        //debug lines:
        endJSON_String = JSON.stringify(json_obj);
        $('#test').text(endJSON_String + "\n\nCurrent Headers:\n\n" + headerList);
    });

    //adding more kv for the same header
    $('#add_another_kv').click(function (e) {

        e.preventDefault();


        if (!$('#key' + noOfFields).val()) {
            alert('Key Must Have Value');
        } else {
            noOfFields++;
            var newField = '<br><label for="key' + noOfFields + '">key' + noOfFields + '</label>';
            newField += '<input type="text" id="key' + noOfFields + '" name="key' + noOfFields + '" class="key"/>';
            newField += '<label for="value' + noOfFields + '">value' + noOfFields + '</label>';
            newField += '<input type="text" id="value' + noOfFields + '" name="value' + noOfFields + '" class="value"/>';
            $('.value:last').after(newField);

            //adding a hidden input inside the form to know the number of inserted fields
            //make sure that the input is not already here
            //then adding it to handle the number of inputs later
            if ($('#noOfFields').length === 0) {
                $('#kv_pairs').append('<input type="hidden" value="2" id="noOfFields"/>');
            } else {
                $('#noOfFields').attr('value', noOfFields);

            }
        }

    });

    $('#add_kv_group').click(function (e) { //TODO: MAKE THIS WORK


    });

    $('#header_key_next').click(function (e) {


        if (headerIndex < headerList.length) {

            if (headerList[headerIndex + 1]) {
                $('#current_header').text(headerList[headerIndex + 1])
            };
            keys = [];
            values = [];
            $('input.key:text').each(function () {
                if ($(this).val()) {
                    keys.push($(this).val());
                }
            });
            $('input.value:text').each(function () {
                values.push($(this).val());
            });

            var tempObject = new Object(); //prototype for the key, value
            var tempList = []; //prototype for the list to hold the key,values

            var index = 0;
            for (index = 0; index < keys.length; index++) {
                key = keys[index];
                value = values[index];
                tempObject[key] = value;
            }

            tempList.push(tempObject);
            infoDocs[(headerList[headerIndex])] = tempList;
            headerIndex++;

            resetKVPairs();
        }
        if (headerList.length === headerIndex + 1) { //last time

            this.value = "Finish Last Header";
        } else if (headerList.length === headerIndex) {
            $('#header_key_next').attr("disabled", true);
            infoList.push(infoDocs);
            json_obj.info = infoList;
            $('#header_key_next').hide();
            $('#submit').show();

        }

    });
    $('#submit').click(function (e) {
        e.preventDefault();
        //TODO: SEND STRING ON SUBMIT
        endJSON_String = JSON.stringify(json_obj);
        $('#test').text(endJSON_String); //TODO:remove text div

        alert("I am about to POST this:\n\n" + endJSON_String);

       $.post("/addDevice", endJSON_String);
    });



});