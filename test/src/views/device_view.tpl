<!DOCTYPE html>

<!-- pass in a document-->
<html>
<head>
    <title>IPAC</title>
    <link rel="stylesheet" type="text/css" href="style.css">
    <script src="jquery-2.1.0.js"></script>


</head>
<body>


<div id="title">
    <h1>IPAC</h1>

    <p>Inventory, Preformance, and Capacity</p>
</div>
<div id="nav_bar">


</div>

%import lib.format_functions


<div id="device_content">
    %if device:
    <div class="list_container">
        <div class="head_wrapper">
            <div class="device_meta">
                <table>
                    %if device['name']:
                    <tr>
                        <td><h3>Device Name:</h3></td>
                        <td><h3>{{device['name']}}</h3></td>
                    </tr>
                    %end
                    %if device['device_type']:
                    <tr>
                        <td><h3>Device Type:</h3></td>
                        <td><h3>{{device['device_type']}}</h3></td>
                    </tr>
                    %end
                    %if device['os']:
                    <tr>
                        <td><h3>Device OS:</h3></td>
                        <td><h3>{{device['os']}}</h3></td>
                    </tr>
                    %end

                </table>
            </div>
            <div class="clear_both"></div>
        </div>
        <div class="clear_both"></div>
        <div class="body_wrapper">

            <div id="change_tags">
                %info_html = lib.format_functions.unpack_device(device['info'])
                {{info_html}}
                %lib.format_functions.unpack_device("CLEAR")
                <script src="custom.js"></script>

            </div>
            <div class="clear_both"></div>
        </div>
    </div>
    %end #end if -- device
    <div class="add_file_container">
        <div class="head_wrapper">
            <h3>Device Files</h3>
        </div>
        <div class="body_wrapper">
            <h3>Attached Files:</h3>

            <div class="attached_files">
                %if files.count < 0:
                {{files}}
                %else:
                <p>No files currently attached.</p>
                %end
            </div>
            <div class="attach_form">
            <h3>Attach a file:</h3>
            <form action="/upload?id={{device['_id']}}" method="post"
                  enctype="multipart/form-data">
                <input type="file" name="data"/><br>
                <input type="submit"/>
            </form>
            </div>
        </div>


    </div>
</div>


<!--Call the js after the pageload-->

</body>
</html>