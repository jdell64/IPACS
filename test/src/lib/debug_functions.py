from bson import ObjectId
import pymongo

__author__ = 'Jeff Tindell'


def recursive_print(document):
    if "number_of_docs" not in recursive_print.__dict__: recursive_print.number_of_docs = 1
    print type(document),
    if isinstance(document, pymongo.cursor.Cursor):
        for doc in document:
            print "\nDocument" + str(recursive_print.number_of_docs)
            recursive_print.counter =0
            recursive_print.number_of_docs +=1
            recursive_print(doc)
        recursive_print.number_of_docs = 0
    elif isinstance(document, list):
        print "[",
        for item in document:
            recursive_print(item)
        print "]"
    elif isinstance(document, dict):
        print "{",
        for key, value in document.items():
            print str(key) + ":"
            recursive_print(value)
        print "}"
    else:
        recursive_print.counter+=1
        print str(document)


#
#
#
# def recursive_print2(document, number_of_times):
#     tabs = "\t" * number_of_times
#     number_of_times +=1
#     # print document, type(document)
# # put in an document from mongodb and print every element on its own line
#     if isinstance(document, pymongo.cursor.Cursor):
#         for doc in document:
#             print ""
#             recursive_print(doc,number_of_times)
#     elif isinstance(document, list):
#         for item in document:
#             recursive_print(item, number_of_times)
#             # print tabs + str(item)
#     elif isinstance(document, dict):
#         for key, value in document.items():
#             print tabs + str(key) + ":"
#             recursive_print(value,number_of_times)
#     else:
#         print tabs + str(document)
