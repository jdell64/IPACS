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
    <h2>UPLOAD .JSON:</h2>
    <form action="/ingest" enctype="multipart/form-data" method="post">
        <p>This form takes .json and loads it into the db for viewing. The json file MUST look like this:
        <br><br>
            {"name" : "", "device_type" : "", "os" : "", "info": [{ "key" : [{"key" : "value"}, {"key" : "value"}]}, { "key" : [{"key" : "value"}, {"key" : "value"}]} ] }
            <br><br>eg:<br>
            {"name" : "complex_server","device_type" : "server","os" : "linux","info" : [{"net_info" : [{"ip" : "192.168.0.5","name" : "eth0"},{"ip" : "192.168.0.28","name" : "eth1"}]},{"os_info" : [{"name" : "RHEL 5.2"}]},{"drive_info" : [{}]}]}
<br>
        </p>
        <p><h3>Rules:</h3><br>
        1) name, device_type, os and info are required fields<br>
        2) type must be one of the following: "server" or "net"
        3) if it is a server, the os must be "windows" or "linux"
        4) info is an array of dictionaries. eg. [{"key":"value"}, {"key": "value"}]
        5) each item in info is an array of dictionaries.

        </p>
    <label for="json_input">Upload .JSON file:<br></label><input id="json_input" name="data" type="file"><br>
    <input type="submit">
    </form>
</section>
<br><br><br><br>
<form action="" method="post" name="addDevForm">
    <h2>EXPERIMENTAL</h2>
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