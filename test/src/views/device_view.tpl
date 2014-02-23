<!DOCTYPE html>

<!-- pass in a document-->
<html>
<head>
    <title>IPAC</title>
    <link rel="stylesheet" type="text/css" href="style.css">

    <script src="custom.js"></script>

</head>
<body>



<div id="title">
    <h1>IPAC</h1>
    <p>Inventory, Preformance, and Capacity</p>
</div>
<div id="nav_bar">


</div>


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
                            <a href="">{{server['name']}}&nbsp;</a>
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

</div>

</body>
</html>