<!DOCTYPE html>

<!-- pass in a document-->
<html>
<head>
    <title>IPAC</title>
    <link rel="stylesheet" type="text/css" href="style.css">
    <script src="jquery-2.1.0.js"></script>
    <script src="custom.js"></script>
</head>
<body>
%include('main/header.tpl')


<section>
    UPLOAD .JSON or Add Manually:


</section>

<form action="">
    <div class="device_item">
        <label for="dev_name">Device Name</label>
        <input id="dev_name" type="text">
    </div>
    <div class="device_item">
        <label for="dev_name">Device Type</label>
        <input id="dev_type" type="text">
    </div>
    <div class="device_item">
        <label for="dev_os">Device OS</label>
        <input id="dev_os" type="text">
    </div>
    <div class="device_item">
        <div class="device_info">
            <div class="device_info_header">
                <label>Device Information Header</label>
                <div>
                    <select multiple="multiple" id="lstBox1" name="device_info_header">
                        <option value="net_info">Network Info</option>
                        <option value="os_info">OS Info</option>
                        <option value="drive_info">Drive Info</option>
                        <option value="time_dif">Time Difference Info</option>
                    </select>
                </div>
                <div id="arrows">
                    <input type='button' class="delete" value='  <  ' />
                    <input type='button' class='add' value='  >  ' />
                </div>
                <div>
                    <select multiple="multiple" id="lstBox2" name="device_info_header"></select>
                </div>
                <input type="text" name="other_info" id="dev_info_other_text" style="display:none;">
                <div class="clear_both" />
                <div class="other_ops">Other:
                    <input id="other_field" type="text" />
                    <input type="button" class="add2" value='  >  ' />
                </div>
                <br>
                <br>NEXT BUTTON (creates headers or dictionary keys) TAKES YOU TO:
                <br>
                <br>TITLE (eg. Net Info, or OS Info)
                <br>Key:
                <input type="text">
                <br>Value:
                <input type="text">
                <br>Add more button
                <br>
                <br>next button (loop through the headers/keys).
                <br>
                <br>finally, a submit button</div>
        </div>
    </div>
</form>

%include('main/footer.tpl')
</body>
</html>