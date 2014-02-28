__author__ = 'Jeff Tindell'

def default_unpack(obj):
    if "output" not in default_unpack.__dict__: default_unpack.output = ""
    if obj=="CLEAR":
        default_unpack.output = ""
    elif isinstance(obj, unicode):
        default_unpack.output += "<li>"+str(obj)+ "</li>"
    elif isinstance(obj, dict):
        for k, v in obj.items():
            default_unpack.output += "<li>" +str(k) +"<ul>"
            default_unpack(v)
            default_unpack.output += "</li></ul>\n"
    elif isinstance(obj, list):
        for items in obj:
            default_unpack(items)
    else:
        print "unknown type for", obj, type(obj)

    return "<div class=\"info_wrapper\">" + str(default_unpack.output) + "</div>"


def get_header(label):
    label_dict = {"net_info": "Network Info:", "os_info": "OS Info", "drive_info": "Drive Info"}
    if label in label_dict:
        header=label_dict[label]
    else:
        header=label
    return header

#
# def unpack_device(device):
#     if "output" not in unpack_device.__dict__: unpack_device.output = ""
#     if device=="CLEAR":
#         default_unpack.output = ""
#     #passed in a list
#     for doc in device:
#         for k, v in doc.items():
#             unpack_device.output += "<div id=\"device_info_head\">" + str(k) + "</div>"
#             if isinstance(v, list):
#                 for items in v:
#                     unpack_device.output += "<div id=\"device_sub_item\">"
#                     unpack_device(items)
#                     unpack_device.output += "</div>"
#             elif isinstance(v, dict):
#                 for keys, values in v:
#
#             elif isinstance(v, unicode):
#                 unpack_device.output +=  str(v)
#
#
#     return "<div class=\"info_wrapper\">" + str(unpack_device.output) + "</div>"

def unpack_device(device):
    if "output" not in unpack_device.__dict__: unpack_device.output = ""
    if "count" not in unpack_device.__dict__: unpack_device.count = 0
    if device=="CLEAR":
        unpack_device.output = ""
        unpack_device.count=0
    elif unpack_device.count ==0:
        unpack_device.count = unpack_device.count +1
        if isinstance(device, list):
            for doc in device:
                unpack_device.output += "<div class=\"device_info_section\">"
                for k, v in doc.items():
                    header = get_header(k)
                    unpack_device.output += "<div class=\"device_info_head\">" + str(header) + "</div>"
                    unpack_device(v)
                unpack_device.output += "</div>"
        else:
            print "wrong input. put in a list"
            print "got a", type(device)
            print device
    else:
        if isinstance(device, list):
            for items in device:
                unpack_device.output += "<div class=\"device_info_list\">"
                unpack_device(items)
                unpack_device.output += "</div>"

        elif isinstance(device, dict):
            for key, value in device.items():
                unpack_device.output += "<div class=\"device_info_dict\">" + key
                unpack_device(value)
                unpack_device.output += "</div>"

        elif isinstance(device, unicode):
             unpack_device.output += "<div class=\"device_info_item\">"+str(device)+"</div>"
        else:
            print "unknown type"


    return "<div class=\"info_wrapper\">" + str(unpack_device.output) + "</div>"


def unpack_files(files):
    if "output" not in unpack_files.__dict__: unpack_files.output = ""
    if "count" not in unpack_files.__dict__: unpack_files.count = 0
    if files=="CLEAR":
        unpack_files.output = ""
        unpack_files.count=0
        return None
    assert isinstance(files, list),"wrong type"
    unpack_files.output += "<div class=\"file_list_container\">"
    # TODO: make header here
    for file in files:
        unpack_files.output += "<div class=\"file_wrapper\">"
        unpack_files.output += "<div class=\"file_descriptor\">"
        file_id = file['_id'].__str__()
        unpack_files.output += "<a href=\"/download?id="+file_id+"\">"
        unpack_files.output += str(file['filename']) # TODO: make url here
        unpack_files.output += "</a></div>"
        unpack_files.output += "<div class=\"file_descriptor\">"
        unpack_files.output += str(file['length'])
        unpack_files.output += "</div>"
        unpack_files.output += "<div class=\"file_descriptor\">"
        unpack_files.output += str(file['uploadDate'])
        unpack_files.output += "</div>"
        unpack_files.output += "</div><br>" #end file_wrapper
        #Add the actions div
        device_id=str(file['device_id'].__str__())
        act_div  = "<div class=\"file_actions\">"
        act_div += "<a href=\"/removeFile?fid="+file_id+"&did="+device_id+"\">"
        act_div += "<img width=\"15\" height=\"15\" src=\"delete.png\"/></a>"
        act_div += "<a href=\"/editFilename?fid="+file_id+"&did="+device_id+"&ofn="+file['filename']+"\">"
        act_div += "<img width=\"15\" height=\"15\" src=\"edit.png\"/></a>"

        unpack_files.output += act_div
    unpack_files.output += "</div><br>" #end file list container

    return unpack_files.output


#
# <a href="/removeFile?fid={{file['_id']}}&did={{device['_id']}}&type={{device['type']}}">
#                      <img width="15" height="15" src="delete.png"/>
#                  </a>&nbsp;
#                  <a href="/editFilename?fid={{file['_id']}}&did={{device['_id']}}&type={{device['type']}}&ofn={{file['filename']}}">
#                      <img width="15" height="15" src="edit.png"/>
#                  </a>