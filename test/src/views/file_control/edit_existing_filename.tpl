<!DOCTYPE html>

<!-- pass in device dict with _id, type file dict with _id and old name-->
<html>
<head>
    <title>Preformance and Capacity Management</title>
    <link rel="stylesheet" type="text/css" href="style.css">
</head>
<body>
<h2>Change filename for file: {{file['ofn']}}:</h2>
%file_extension = str(file['ofn'])[(str(file['ofn']).index('.')):]
%current_filename= str(file['ofn'])[:(str(file['ofn']).index('.'))]


<form action="/updateFilename?fid={{file['_id']}}&did={{device['_id']}}" method="post" enctype="multipart/form-data">
    Filename: <input type="text" name="new_filename" value="{{current_filename}}"  /> {{file_extension}}<br>
    <input type="hidden" name="ext" value="{{file_extension}}"/>
    <input type="submit"/>
</form>
</body>
</html>