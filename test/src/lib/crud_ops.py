from bson import ObjectId
import pymongo


def find_all(col):
    assert type(col) == pymongo.collection.Collection, 'Pass in the collection object!'
    all_devices = {}
    query = {"device_type":"net"}
    net_devices = col.find(query)
    query = {"device_type":"server", "os": "windows"}
    win_servers = col.find(query)
    query = {"device_type":"server", "os": "linux"}
    lin_servers = col.find(query)
    all_devices['net'] = net_devices
    all_devices['win'] = win_servers
    all_devices['lin']= lin_servers
    return all_devices


def find_bY_id(col, obj_id):
    assert type(col) == pymongo.collection.Collection, 'Pass in the collection object!'
    query = {"_id": ObjectId(obj_id)}
    result = col.find_one(query)
    return result

def search(col, obj_key, obj_value): #not sure best implementation of this
    return None

