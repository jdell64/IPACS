import ast
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
    query= {"$or":[{"$and":[{"device_type":{"$ne":"server"}}, {"device_type":{"$ne":"net"}}]}, {"device_type":"server", "$and":[{"os":{"$ne":"windows"}}, {"os":{"$ne":"linux"}}]}]}
    other_dev = col.find(query)
    all_devices['net'] = net_devices
    all_devices['win'] = win_servers
    all_devices['lin']= lin_servers
    all_devices['oth'] = other_dev
    return all_devices


def find_by_id(col, obj_id):
    assert type(col) == pymongo.collection.Collection, 'Pass in the collection object!'
    query = {"_id": ObjectId(obj_id)}
    result = col.find_one(query)
    return result

def search(db, col, search_text):
    if(not search_text ):
        return "";
    else:
        search_text = str(search_text)
    query = col.find({})
    results = []
    for result in query:
        if(str(result.values()).find(search_text)>=0):
            results.append(result)
    return results


def get_attached_files(col, obj_id):
    assert type(col) == pymongo.collection.Collection, 'Pass in the collection object!'
    query = {"device_id": ObjectId(obj_id)}
    results = col.find(query)
    file_dict = []
    for dict in results:
        file_dict.append(dict)
    return file_dict
