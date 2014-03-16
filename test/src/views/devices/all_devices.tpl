<!DOCTYPE html>

<!-- pass in results, a dict containing cursors-->
<html>
<head>
    <title>IPAC</title>
    <link rel="stylesheet" type="text/css" href="style.css">
      <script src="jquery-2.1.0.js"></script>
    <script src="custom.js"></script>


</head>
<body>

%win_servers = results['win']
%lin_servers = results['lin']
%net_devices = results['net']
%oth_devices = results['oth']
%import lib.format_functions
%include('main/header.tpl')

<!--TODO: turn these into functions taking the list as input and outputting the html -->
<div id="content">
    <!--Windows servers-->
    %if win_servers.count() > 0 :
    {{!lib.format_functions.start_view("Windows Servers")}}
                    %for server in win_servers:
                        {{!lib.format_functions.view_all_overview(server)}}
                    %end #end for loop
    {{!lib.format_functions.end_view()}}
    %end #end if -- Windows Servers

    <!--Linux Servers-->
    %if lin_servers.count() > 0 :
    {{!lib.format_functions.start_view("Linux Servers")}}
                    %for server in lin_servers:
                        {{!lib.format_functions.view_all_overview(server)}}
                    %end #end for loop
    {{!lib.format_functions.end_view()}}

    %end #end if -- linux Servers

    <!--Network devices-->

    %if net_devices.count() > 0 :
    {{!lib.format_functions.start_view("Network Devices")}}
                    %for device in net_devices:
                        {{!lib.format_functions.view_all_overview(device)}}
                    %end #end for loop
    {{!lib.format_functions.end_view()}}

    %end #end if -- net devices

    <!--other devices-->

    %if oth_devices.count() > 0 :
    {{!lib.format_functions.start_view("Other Devices")}}
                    %for device in oth_devices:
                        {{!lib.format_functions.view_all_overview(device)}}
                    %end #end for loop
    {{!lib.format_functions.end_view()}}
    %end #end if -- oth devices


    <!--TODO: add "other devices" for those that can't be classified.-->


</div>

%include('main/footer.tpl')
</body>
</html>