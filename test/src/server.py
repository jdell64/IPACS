import copy
import mimetypes
import bottle
from bson import ObjectId
import gridfs
import pymongo
import sys
import lib.crud_ops

__author__ = 'Jeff Tindell'


 #
 #
 #
# Inventory Preformance And Capacity System

# The point of this program is to take json documents consisting of server or network devices basic configuration
# and display it on a basic web form.

# It will also hold and link documents regarding the systems (config files or whatever).

#
# Copyright (C) 2014  Richard Tindell II
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>



#establish a connection to the db:
connection = pymongo.MongoClient("mongodb://localhost")
db = connection.ipac
# get collections of my network devices and servers in the inventory
collection = db.test
#get gridfs for the two dbs
fs = gridfs.GridFS(db)





# Static Routes
@bottle.get('/<filename:re:.*\.js>')
def javascripts(filename):
    return bottle.static_file(filename, root='static/js')


@bottle.get('/<filename:re:.*\.css>')
def stylesheets(filename):
    return bottle.static_file(filename, root='static/css')


@bottle.get('/<filename:re:.*\.(jpg|png|gif|ico)>')
def images(filename):
    return bottle.static_file(filename, root='static/img')


@bottle.get('/<filename:re:.*\.(eot|ttf|woff|svg)>')
def fonts(filename):
    return bottle.static_file(filename, root='static/fonts')



#home page

@bottle.route('/')
def home_page():
    results = lib.crud_ops.find_all(collection)
    print results
    print type(results)
    return bottle.template('all_devices.tpl', {'results':results})



    #send the results to the home page:
    # template_args = {'network_devices': net_devices, 'servers': servers, 'errors': err_list}
    # return bottle.template('home.tpl', template_args)

# trying out different html code:
@bottle.route('/test')
def test_page():
    return bottle.template('tryHTML/test.tpl')



@bottle.route('/showDevice')
def show_device():
    # get the url information (passed in as /showDevice?id=35jfjae3...&type=server)
    # type will either be server or net (for now).

    device_id = bottle.request.query.id
    device_type = bottle.request.query.type

    cursor = None
    device = {}
    attached_files = {}

    if device_id: # was an id sent in?
        # if so, search the database for the proper object

        query = {"_id" : ObjectId(device_id)}

        if device_type == "server":
            cursor = db.servers.find(query)
        elif device_type == "net":
            cursor = db.net_devices.find(query)
        else: # couldnt find device type
            errors.append({'text': 'device type not recognized'})
    else: # no id was sent in
        errors.append({'text':'Device not found, No id sent in.'})

    #after the search
    if cursor: #if the search turn up something
        for documents in cursor: # get the dictionaries out of the cursor
            device = documents
    #search the files db for any attached files
        attached_files = db.fs.files.find({"device_id" : ObjectId(device_id)})

    # return the search results
        return bottle.template('device_view.tpl', {'device': device, 'attached_files': attached_files})
    else: #the search was unsucessful
        errors.append({'text': 'search turned up no results'})
    bottle.redirect('/')


@bottle.route('/addDevice')
def add_device():

    return None


@bottle.route('/addFile')
def add_file():
    device_id = bottle.request.query.id
    device_name = bottle.request.query.name
    device_type = bottle.request.query.type
    device={'_id': device_id, 'name': device_name, 'type': device_type}

    return bottle.template('file_control/add_file_to_existing.tpl', {'device':device})


@bottle.route('/upload', method='POST')
def do_upload():
    data = bottle.request.files.data
    did = bottle.request.query.id
    type = bottle.request.query.type
    device_url = '/showDevice?id=' + str(did) + '&type=' + type+'#files'
    raw = data.file.read()  # This is dangerous for big files
    file_name = data.filename
    try:
        newfile_id = fs.put(raw, filename=file_name, device_id = ObjectId(did))
    except:
        return "error inserting new file"

    return bottle.redirect(device_url)



@bottle.route('/download')
def download():
    file_id = ObjectId(bottle.request.query.id)
    if file_id:
        try:
            file_to_download = fs.get(file_id)
        except:
            return "document id not found for id:" + file_id, sys.exc_info()[0]
        file_extension = str(file_to_download.name)[(str(file_to_download.name).index('.')):]

        bottle.response.headers['Content-Type'] = (mimetypes.types_map[file_extension])
        bottle.response.headers['Content-Disposition'] = 'attachment; filename=' + file_to_download.name

        return  file_to_download

@bottle.route('/editFilename')
def edit_page():
    # in comes device id, device type, and file id, and filename
    device_id = bottle.request.query.did
    fid = bottle.request.query.fid
    device_type = bottle.request.query.type
    old_filename = bottle.request.query.ofn
    filedict = {'_id': ObjectId(fid), 'ofn': old_filename}
    device={'_id': ObjectId(device_id), 'type': device_type}

    return bottle.template('file_control/edit_existing_filename.tpl', {'device':device, 'file':filedict})

@bottle.route('/updateFilename', method='POST')
def update_filename():
    # /updateFilename?fid=FILE_ID&did=DEVICE_ID&type=TYPE
    fid= ObjectId(bottle.request.query.fid)
    did= ObjectId(bottle.request.query.did)
    dtype = bottle.request.query.type
    form_dict = bottle.request.forms
    new_name = str(form_dict['new_filename']) + str(form_dict['ext'])

    device_url = '/showDevice?id=' + str(did) + '&type=' + dtype + '#files'
    db.fs.files.update({'_id': fid}, {'$set': {'filename': new_name}})
    return bottle.redirect(device_url)





@bottle.route('/removeFile')
def delete_file():
    # /removeFile?fid=FILE_ID&did=DEVICE_ID&type=TYPE
    fid= ObjectId(bottle.request.query.fid)
    did = ObjectId(bottle.request.query.did)
    dtype = bottle.request.query.type
    device_url = '/showDevice?id=' + str(did) + '&type=' + dtype + '#files'
    fs.delete(fid)
    return bottle.redirect(device_url)

@bottle.route('/removeDevice')
def delete_device():
    # Need to delete any files related to this device, then delete the device
    did = ObjectId(bottle.request.query.did)
    dtype = bottle.request.query.type
    results = db.fs.files.find({'device_id': did})
    for file in results:
        fs.delete(file['_id']) # delete all files associated with this entry
    if dtype == 'net':
        col = db.net_devices
    elif dtype == 'server':
        col = db.servers
    else:
        return bottle.redirect('/')

    col.remove(did)


    return bottle.redirect('/')





bottle.debug(True)
bottle.run(host='localhost', port=8080)