<!DOCTYPE html>

<!-- pass in results, a dict containing cursors-->
<html>
<head>
    <title>IPAC</title>
    <link rel="stylesheet" type="text/css" href="style.css">

    <script src="custom.js"></script>

</head>
<body>

%win_servers = results['win']
%lin_servers = results['lin']
%net_devices = results['net']

%include('main/header.tpl')

<!--TODO: turn these into functions taking the list as input and outputting the html -->
<div id="content">
    <!--Windows servers-->
    %if win_servers.count() > 0 :
    <div class="list_container">
        <div class="head_wrapper">
            <div class="head_title">
                <h3>Windows Servers</h3>
            </div>
            <div class="head_actions">
                &nbsp;<a href=""><img width="50" height="50" src="add.png"/></a>

                <div class="clear_both"></div>
            </div>
            <div class="clear_both"></div>
        </div>
        <div class="clear_both"></div>
        <div class="body_wrapper">
            <ul>
                <div class="device_wrapper">
                    %for server in win_servers:
                    <li class="device">
                        <div class="device_link">
                            <a href="/showDevice?id={{server['_id']}}">{{server['name']}}&nbsp;</a>
                        </div>
                        <div class="action_panel">
                            &nbsp;<a href=""><img width="25" height="25" src="edit.png"/></a>
                            &nbsp;<a href=""><img width="25" height="25" src="delete.png"/></a>

                        </div>

                        <div class="clear_both"></div>
                    </li>

                    %end #end for loop

                </div>
            </ul>
        </div>
        <div class="clear_both"></div>
    </div>
    %end #end if -- Windows Servers

    <!--Linux Servers-->
    %if lin_servers.count() > 0 :
    <div class="list_container">
        <div class="head_wrapper">
            <div class="head_title">
                <h3>Linux Servers</h3>
            </div>
            <div class="head_actions">
                &nbsp;<a href=""><img width="50" height="50" src="add.png"/></a>

                <div class="clear_both"></div>
            </div>
            <div class="clear_both"></div>
        </div>
        <div class="clear_both"></div>
        <div class="body_wrapper">
            <ul>
                <div class="device_wrapper">
                    %for server in lin_servers:
                    <li class="device">
                        <div class="device_link">
                            <a href="/showDevice?id={{server['_id']}}">{{server['name']}}&nbsp;</a>
                        </div>
                        <div class="action_panel">
                            &nbsp;<a href=""><img width="25" height="25" src="edit.png"/></a>
                            &nbsp;<a href=""><img width="25" height="25" src="delete.png"/></a>

                        </div>

                        <div class="clear_both"></div>
                    </li>

                    %end #end for loop

                </div>
            </ul>
        </div>
        <div class="clear_both"></div>
    </div>
    %end #end if -- linux Servers


    <!--Network devices-->


    %if net_devices.count() > 0 :
    <div class="list_container">
        <div class="head_wrapper">
            <div class="head_title">
                <h3>Network Devices</h3>
            </div>
            <div class="head_actions">
                &nbsp;<a href=""><img width="50" height="50" src="add.png"/></a>

                <div class="clear_both"></div>
            </div>
            <div class="clear_both"></div>
        </div>
        <div class="clear_both"></div>
        <div class="body_wrapper">
            <ul>
                <div class="device_wrapper">
                    %for device in net_devices:
                    <li class="device">
                        <div class="device_link">
                            <a href="/showDevice?id={{device['_id']}}">{{device['name']}}&nbsp;</a>
                        </div>
                        <div class="action_panel">
                            &nbsp;<a href=""><img width="25" height="25" src="edit.png"/></a>
                            &nbsp;<a href=""><img width="25" height="25" src="delete.png"/></a>

                        </div>

                        <div class="clear_both"></div>
                    </li>

                    %end #end for loop

                </div>
            </ul>
        </div>
        <div class="clear_both"></div>
    </div>
    %end #end if -- net devices

    <!--TODO: add "other devices" for those that can't be classified.-->

</div>

%include('main/footer.tpl')
</body>
</html>