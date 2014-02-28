<!DOCTYPE html>

<!-- pass in a document-->
<html>
<head>
    <title>IPAC</title>
    <link rel="stylesheet" type="text/css" href="style.css">
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

                <br>MAKE THIS A LISTBOX:
                <select name="device_info_header" onchange='CheckOptions(this.value)'>
                    <option value="net_info">Network Info</option>
                    <option value="os_info">OS Info</option>
                    <option value="drive_info">Drive Info</option>
                    <option value="time_dif">Time Difference Info</option>
                    <option value="other">Other...</option>
                </select>
                <input type="text" name="other_info" id="dev_info_other_text" style='display:none;'/>
                <br><br> NEXT BUTTON... TAKES YOU TO:<br><br>
                TITLE (eg. Net Info, or OS Info)<br>
                Key: <input type="text"> <br>
                Value: <input type="text">
                <br>Add more button<br>
                <br>next button<br>


            </div>


            </div>
        </div>
    </div>


</form>

%include('main/footer.tpl')
</body>
</html>