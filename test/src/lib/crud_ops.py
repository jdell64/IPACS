import pymongo


def find_all(col):
    assert type(col) == pymongo.collection.Collection, 'Pass in the collection object!'
    all_devices = {}
    query = {"device_type":"net"}
    net_devices = col.find(query)
    query = {"os": "windows"}
    win_servers = col.find(query)
    query = {"device_type":"server", "os": "linux"}
    lin_servers = col.find(query)
    all_devices['net'] = net_devices
    all_devices['win'] = win_servers
    all_devices['lin']= lin_servers
    return all_devices
