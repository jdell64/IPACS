<!DOCTYPE html>

<!-- pass in device dict with name, type, and id keys-->
<html>
<head>
    <title>Preformance and Capacity Management</title>
    <link rel="stylesheet" type="text/css" href="style.css">
</head>
<body>
<h2>Add file to {{device['name']}}'s entry:</h2>
<form action="/upload?id={{device['_id']}" method="post" enctype="multipart/form-data">
    <input type="text" name="device_id" value="{{device['_id']}}" disabled /> <br>
    <input type="file" name="data" /><br>
    <input type="submit"/>
</form>
</body>
</html>