from datetime import datetime
from bson import ObjectId
from dateutil import tz

__author__ = 'Jeff Tindell'

# import lib.math
# print lib.math.addTwoNumbers(7,2)


import pymongo


connection = pymongo.MongoClient('localhost', 27017)
db = connection.ipac
collection = db.test

query = {"device_type":"net"}
net_devices = collection.find(query)

query = {"os": "windows"}
win_servers = collection.find(query)

query = {"device_type":"server", "os": "linux"}
lin_servers = collection.find(query)

query = {}
allDoc = collection.find(query)

query = {}
oneDoc = collection.find_one(query)

#
# def rec_print(obj):
#     if "output" not in rec_print.__dict__: rec_print.output = ""
#     if isinstance(obj, unicode):
#         rec_print.output += "<li>"+str(obj)+ "</li>"
#     elif isinstance(obj, dict):
#         for k, v in obj.items():
#             rec_print.output += "<li>" +str(k) +"</li><ul>"
#             rec_print(v)
#             rec_print.output += "</ul>\n"
#     elif isinstance(obj, list):
#         for items in obj:
#             rec_print(items)
#     else:
#         print "uknown type for", obj, type(obj)
#
#     return rec_print.output





# Trying out the unpack_device function
#
# import  lib.format_functions
#
# spelled_out = lib.format_functions.unpack_device(oneDoc['info'])
#
# print spelled_out, type(spelled_out)





# if isinstance(allDoc, unicode)
#
#
# print "Network Devices\n"
# lib.debug_functions.recursive_print(net_devices)
# print "Linux Servers"
# lib.debug_functions.recursive_print(lin_servers)
# print "Windows Servers"
# lib.debug_functions.recursive_print(win_servers)
#
# #
# print "all"
# lib.debug_functions.recursive_print(allDoc)

#
#
# obj_id = ObjectId('530ca5942da57ac8163b33d6')
#
# print type(obj_id.__str__())
# print str(obj_id.binary)
#

fmt = '%m-%d-%Y %H:%M:%S'

file = db.fs.files.find_one({"_id" : ObjectId("5310aa542da57aa168e653ea")})
dt= file['uploadDate']
from_tz = tz.gettz('UTC')
to_tz = tz.gettz('America/New_York')
new_dt = dt.replace(tzinfo=from_tz)
new_dt = new_dt.astimezone(to_tz).strftime('%a %b %d %X')
dt = dt.strftime('%a %b %d %X')
print dt, new_dt