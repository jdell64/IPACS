<!DOCTYPE html>

<!-- pass in network_devices, servers-->
<html>
<head>
    <title>Preformance and Capacity Management</title>
    <link rel="stylesheet" type="text/css" href="style.css">
</head>
<body>

<div class="centerText">
<h1>Current Inventory</h1>
</div>
<div id="errors">
    %if errors:
    <h3>Errors found:</h3>
    <ul>
        %for error in errors:
        <li>{{error['text']}}</li>
        %end
    </ul>

    %end
</div>
%number_of_net = network_devices.count()
%number_of_servers = servers.count()
%if not number_of_net and not number_of_servers:
<div class="centerText">
    <h3>No current Inventory.</h3>
    </div>
%else:

%if number_of_net:

<div class="centerText">
<h3>Found {{number_of_net}} network device(s) in the database</h3>
</div>

<div class="tableWrap">
    <table class="floatLeft">
        <thead>
        <h3>Network Equipment</h3>
        <tr>
            <th>Device Name</th><th>Action</th>
        </tr>
        </thead>
        <tbody>
        %for device in network_devices:
        <tr>
            <td><a href="showDevice?id={{device['_id']}}&type={{device['type']}}">{{device['device_name']}}</a></td>
            <td>&nbsp;<a href="/removeDevice?did={{device['_id']}}&type={{device['type']}}"><img width="15" height="15" src="delete.png"/></a></td>
        </tr>
        %end

        </tbody>


    </table>
</div>



<div id="empty">
    &nbsp;
</div>
<br>
%end


%if number_of_servers:

<div class="centerText">
<h3>Found {{number_of_servers}} server(s) in the database</h3>
</div>
<div class="tableWrap">
    <table class="floatLeft">
        <thead>
        <h3>Servers</h3>
        <tr>
            <th>Device Name</th><th>Action</th>
        </tr>
        </thead>
        <tbody>
        %for device in servers:
        <tr>
            <td><a href="showDevice?id={{device['_id']}}&type={{device['type']}}">{{device['device_name']}}</a></td>
            <td>&nbsp;<a href="/removeDevice?did={{device['_id']}}&type={{device['type']}}"><img width="15" height="15" src="delete.png"/></a></td>
        </tr>
        %end

        </tbody>


    </table>
</div>


%end
<div class="clearBoth"></div>


</body>
</html>
