<!DOCTYPE html>

<!-- pass in a document-->
<html>
<head>
    <title>IPAC</title>
    <link rel="stylesheet" type="text/css" href="style.css">
    <script src="jquery-2.1.0.js"></script>
    <script src="custom.js"></script>
    <script src="add_dev_form.js"></script>
</head>
<body>
%include('main/header.tpl')


<section>
    UPLOAD .JSON or Add Manually:


</section>

<form action="" method="post" name="addDevForm">

    NEED BACK BUTTONS AND START OVER BUTTON
    <div id="test"></div>
    <div id="top_three">name:
        <input id="name" type="text"/>type:
        <input id="device_type" type="text"/>os:
        <input id="os" type="text"/>
        <input id="top_three_next" value="next" type="button"/>
    </div>
    <div id="info_headers">
        <select multiple="multiple" id="lstBox1" name="device_info_header">
            <option value="net_info">Network Info</option>
            <option value="os_info">OS Info</option>
            <option value="drive_info">Drive Info</option>
            <option value="time_dif">Time Difference Info</option>
        </select>

        <div id="arrows">
            <input type='button' class="delete" value='  <  '/>
            <input type='button' class='add' value='  >  '/>
        </div>
        <select multiple="multiple" id="lstBox2" name="device_info_header"></select>

        <div class="clear_both"/>
        <div class="other_ops">Other:
            <input id="other_field" type="text"/>
            <input type="button" class="add2" value='  >  '/>
        </div>
        <div class="clear_both"/>
        <input id="info_headers_next" value="next" type="button"/>
    </div>
    <div id='current_header'></div>
    <div class="clear_both"/>
    <div id="header_key_values">
        <div id="kv_pairs">
            <label for="key0">key</label>
            <input name="key0" id="key0" class="key" type="text"/>
            <label for="value0">value</label>
            <input name="value0" id="value0" class="value" type="text"/>
        </div>
        <br>
        <input id="add_another_kv" value="Add Another Key,Value Pair" type="button"/>
        <br>
        <input id="add_kv_group" value="Add Another Group of Pairs" type="button"/>--DOES NOTHING
        <br>
        <input id="header_key_next" value="Next Header" type="button"/>
        <input id="submit" value="submit" type="submit"/>
    </div>


</form>

%include('main/footer.tpl')
</body>
</html>