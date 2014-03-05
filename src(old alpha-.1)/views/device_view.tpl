<!DOCTYPE html>

<!-- pass in device dict-->
<html>
<head>
    <title>Preformance and Capacity Management</title>
    <link rel="stylesheet" type="text/css" href="style.css">
</head>
<body>

<div class="centerText">
<h1>Device: {{device['device_name']}}</h1>

<h2>Type: {{device['type']}}</h2>
</div>

%sys_dict={}
%os_dict={}
%cpu_dict={}
%mb_dict={}
%mem_dict={}
%net_dict={}
%drive_dict={}


%for key, value in device.iteritems():
    %if value is None:
        %var=None
    %elif key.find('system_')!=-1:
        %sys_dict[key[7:]] = value
    %elif key.find('os_')!=-1:
        %os_dict[key[3:]] = value
    %elif key.find('cpu_')!=-1:
        %cpu_dict[key[4:]] = value
    %elif key.find('mb_')!=-1:
        %mb_dict[key[3:]] = value
    %elif key.find('mem_')!=-1:
        %mem_dict[key[4:]] = value
    %elif key.find('eth')!=-1:
        %net_dict[key[3:]] = value
    %elif key.find('drive')!=-1:
        %drive_dict[key[5:]] = value
    %end
%end


%multi_dict ={'System Info' : sys_dict, 'OS Info': os_dict, 'CPU Info': cpu_dict, 'Motherboard Info': mb_dict, 'Memory Info': mem_dict, 'Network Info': net_dict, 'Drive Info': drive_dict}

%for header, dictionary in  multi_dict.iteritems():

%if len(dictionary):

<div class="tableWrap">
<h2>{{header}}</h2>

    <table>
        <tr><th>Key</th><th>Value</th></tr>
    %for key, value in sorted(dictionary.iteritems()):
        %label = "tr_class"

        %if key.find('_')!=-1:
            %label += key[:1]
        %end
        %if key.find('dhcp') ==-1:
            %try:
                %value = value / 1073741824
                %value =  "%.2f" % round(value, 2)
                %value = "" + value + " GB"
            %except TypeError:
                %value = value
            %end
        %end
    <tr class="{{label}}"><td>{{key}}</td> <td>{{value}}</td></tr>

    %end

    </table>
    </div>
    <br>
%end
%end

%if attached_files.count():
<div class="tableWrap">
    <h2>Files</h2>
     <table id="files">
         <tr><th>Filename</th><th>Size</th><th>Uploaded</th><th>Actions</th></tr>
         %for file in attached_files:
            %date = file['uploadDate']
         <tr>
             <td><a href="/download?id={{file['_id']}}">{{file['filename']}}</a></td>
             <td>{{file['length']}} bytes</td>
             <td>{{date.strftime('%c')}}</td>
             <td>&nbsp;
                 <a href="/removeFile?fid={{file['_id']}}&did={{device['_id']}}&type={{device['type']}}">
                     <img width="15" height="15" src="delete.png"/>
                 </a>&nbsp;
                 <a href="/editFilename?fid={{file['_id']}}&did={{device['_id']}}&type={{device['type']}}&ofn={{file['filename']}}">
                     <img width="15" height="15" src="edit.png"/>
                 </a>
             </td>
         </tr>
         %end
     </table>
</div>
%end



<p>
    <br>
    <br>
    <a href="/addFile?id={{device['_id']}}&name={{device['device_name']}}&type={{device['type']}}">Attach file to device entry</a><br>
    <a href="/"><--  Return to Homepage</a>
</p>

</body>
</html>
