from datetime import date
from dateutil import tz

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

def start_view(header):
    output ='<div class="list_container">'
    output +='<div class="head_wrapper">'
    output +='<div class="head_title">'
    output += "<h3>"+header+"</h3>"
    output += '</div><div class="head_actions">'
    output +='&nbsp;<a href="/addDevice"><img width="50" height="50" src="add.png"/></a>'
    output +='<div class="clear_both"></div></div><div class="clear_both"></div>'
    output +='</div><div class="clear_both"></div><div class="body_wrapper">'
    output +='<ul><div class="device_wrapper">'
    return output

def view_all_overview(dict_in):
    output ='<li class="device">'
    output +='<div class="device_link">'
    output +='<a href="/showDevice?id='+str(dict_in['_id'])+'">'+dict_in['name']+'&nbsp;</a>'
    output +='</div><div class="action_panel">&nbsp;<a href=""><img width="25" height="25" src="edit.png"/></a>'
    output +='&nbsp;<a href="/removeDevice?did='+str(dict_in['_id'])+'"><img width="25" height="25" src="delete.png"/></a>'
    output +='</div><div class="clear_both"></div></li>'
    return output

def end_view():
    output ='</div></ul></div><div class="clear_both"></div></div>'
    return output

def search_format(dict):
    output ='<li class="device">'
    output +='<div class="device_link">'
    output +='<a href="/showDevice?id='+str(dict['_id'])+'">'+dict['name']+'&nbsp;</a>'
    output +='</div><div class="action_panel">&nbsp;<a href=""><img width="25" height="25" src="edit.png"/></a>'
    output +='&nbsp;<a href="/removeDevice?did='+str(dict['_id'])+'"><img width="25" height="25" src="delete.png"/></a>'
    output +='</div><div class="clear_both"></div></li>'

    return output



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

        else:
            if (device is None):
                unpack_device.output += "<div class=\"DELETE_ROW\">"+str(device)+"</div>"
            elif(str(device) ==""):
                unpack_device.output += "<div class=\"DELETE_ROW\">"+str(device)+"</div>"
            else:
                device = str(device)
                unpack_device.output += "<div class=\"device_info_item\">"+device+"</div>"
        # else:
        #      print device , type(device)


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
    unpack_files.output += "<div id=\"attached_file_header\">"
    unpack_files.output +=  "<div>Filename</div><div>Size</div><div>Upload Date</div></div>"
    unpack_files.output += "<div class=\"clear_both\"/>"
    # TODO: make header here
    for file in files:
        unpack_files.output += "<div class=\"file_wrapper\">"
        unpack_files.output += "<div class=\"file_descriptor\">"
        file_id = file['_id'].__str__()
        unpack_files.output += "<a href=\"/download?id="+file_id+"\">"

        unpack_files.output += str(file['filename']) # TODO: make url here
        unpack_files.output += "</a></div>"
        unpack_files.output += "<div class=\"file_descriptor\">"
        size = float(file['length'])
        size_in_mb = "%.2f" % (size/1024)
        unpack_files.output += size_in_mb + " MB"
        unpack_files.output += "</div>"
        unpack_files.output += "<div class=\"file_descriptor\">"
        dt= file['uploadDate']
        from_tz = tz.gettz('UTC')
        to_tz = tz.gettz('America/New_York')
        new_dt = dt.replace(tzinfo=from_tz)
        new_dt = new_dt.astimezone(to_tz).strftime('%a %b %d %X')

        unpack_files.output += new_dt
        unpack_files.output += "</div>"
        unpack_files.output += "</div>" #end file_wrapper
        #Add the actions div
        device_id=str(file['device_id'].__str__())
        act_div  = "<div class=\"file_actions\"><div class=\"clear_both\"/>"
        act_div += "<a href=\"/editFilename?fid="+file_id+"&did="+device_id+"&ofn="+file['filename']+"\">"
        act_div += "<img width=\"20\" height=\"20\" src=\"edit.png\"/></a>&nbsp;"
        act_div += "<a href=\"/removeFile?fid="+file_id+"&did="+device_id+"\">"
        act_div += "<img width=\"20\" height=\"20\" src=\"delete.png\"/></a></div>"

        unpack_files.output += act_div
    unpack_files.output += "<div class=\"clear_both\"/></div>" #end file list container

    return unpack_files.output

