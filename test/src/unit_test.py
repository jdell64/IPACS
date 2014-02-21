__author__ = 'Jeff Tindell'

# import lib.math
# print lib.math.addTwoNumbers(7,2)


import pymongo
import lib.debug_functions


connection = pymongo.MongoClient('localhost', 27017)
db = connection.ipac
collection = db.test

print type(collection)
query = {"device_type":"net"}
net_devices = collection.find(query)

query = {"os": "windows"}
win_servers = collection.find(query)

query = {"device_type":"server", "os": "linux"}
lin_servers = collection.find(query)

query = {}
allDoc = collection.find(query)
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


