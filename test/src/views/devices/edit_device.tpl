<!DOCTYPE html>
<html>

<!-- pass in a document-->

%include('main/header.tpl')
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
                {{!info_html}}
                %lib.format_functions.unpack_device("CLEAR")


            </div>
            <div class="clear_both"></div>
        </div>
    </div>
    %end #end if -- device


</body>
</html>