import ast
import copy
import mimetypes
import bottle
from bson import ObjectId
import gridfs
import pymongo
import sys
import lib.crud_ops
from mako.template import Template

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


#--setParameter textSearchEnabled=true
# db.collection.ensureIndex(
#                            { "$**": "text" },
#                            { name: "TextIndex" }
#                          )
# http://docs.mongodb.org/manual/tutorial/create-text-index-on-multiple-fields/


#establish a connection to the db:
connection = pymongo.MongoClient("mongodb://localhost") #TODO: TRY CATCH?
db = connection.ipac
# get collections of my network devices and servers in the inventory
collection = db.test
#get gridfs for the dbs
fs = gridfs.GridFS(db)

unprocessed_fs = gridfs.GridFS(db, "unprocessed")





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


###########################################
###    NAV BAR MAPPINGS
###########################################
#home page
@bottle.route('/')
def home_page():
    return bottle.template('home.tpl')


#view all inventory
@bottle.route('/viewAll')
def view_all():
    results = lib.crud_ops.find_all(collection)
    return bottle.template('devices/all_devices.tpl', {'results':results})

@bottle.route('/about')
def about_page():
    return bottle.template('about.tpl')



##########################################
###   CRUD ET AL.
##########################################

# Device view
@bottle.route('/showDevice')
def device_view():
    device_id = bottle.request.query.id
    result = lib.crud_ops.find_by_id(collection, device_id)
    files = lib.crud_ops.get_attached_files(db.fs.files, device_id)
    return bottle.template('devices/device_view.tpl', {'device':result, 'attached_files':files})

@bottle.route('/addDevice')
def add_device_form():
    return bottle.template('devices/add_device.tpl')

@bottle.route('/addDevice', method='POST')
def add_device_post():
    json = bottle.request.body.read()
    dict = ast.literal_eval(json) #TODO: try around this
    #TODO: verify data before taking into db
    collection.insert(dict)
    return bottle.template('devices/add_device.tpl') #TODO return success ro fail page

@bottle.route('/searchResult')
def result_page():
    search_text = bottle.request.query.q
    results = lib.crud_ops.search(db, collection, search_text)
    formated_results = {"count":(len(results)), "results":results, 'search':search_text}

    return bottle.template('devices/results.tpl', {'results':formated_results})




@bottle.route('/ingest', method='POST') #TODO: this is dumb, had to because i needed this function quick
def ingest():
    upload = bottle.request.files.get('data')
    raw = upload.file.read()
    uploaded_dict = ast.literal_eval(raw)
    # print uploaded_dict
    new_id = collection.insert(uploaded_dict)
    # print new_id
    device_url = '/showDevice?id=' + str(new_id)
    return bottle.redirect(device_url)



# trying out different html code:
@bottle.route('/test')
def test_page():
    return bottle.template('tryHTML/test.tpl')



@bottle.route('/upload', method='POST') #TODO: Change allowed extensions.
def do_upload():
    data = bottle.request.files.data
    did = bottle.request.query.id
    device_url = '/showDevice?id=' + str(did) +'#attached_files'
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
    old_filename = bottle.request.query.ofn
    filedict = {'_id': ObjectId(fid), 'ofn': old_filename}
    device={'_id': ObjectId(device_id)}

    return bottle.template('file_control/edit_existing_filename.tpl', {'device':device, 'file':filedict})

@bottle.route('/updateFilename', method='POST')
def update_filename():
    # /updateFilename?fid=FILE_ID&did=DEVICE_ID&type=TYPE
    fid= ObjectId(bottle.request.query.fid)
    did= ObjectId(bottle.request.query.did)

    form_dict = bottle.request.forms
    new_name = str(form_dict['new_filename']) + str(form_dict['ext'])
    device_url = '/showDevice?id=' + str(did) + '#attached_files'
    db.fs.files.update({'_id': fid}, {'$set': {'filename': new_name}})
    return bottle.redirect(device_url)





@bottle.route('/removeFile')
def delete_file():
    # /removeFile?fid=FILE_ID&did=DEVICE_ID&type=TYPE
    fid= ObjectId(bottle.request.query.fid)
    did = ObjectId(bottle.request.query.did)
    device_url = '/showDevice?id=' + str(did) + '#attached_files'
    fs.delete(fid)
    return bottle.redirect(device_url)

@bottle.route('/removeDevice')
def delete_device():
    # Need to delete any files related to this device, then delete the device
    did = ObjectId(bottle.request.query.did)

    results = db.fs.files.find({'device_id': did})
    for file in results:
        fs.delete(file['_id']) # delete all files associated with this entry
    collection.remove(did)
    return bottle.redirect('/viewAll');





bottle.debug(True)
bottle.run(host='localhost', port=8080)