IPACS
=====


Description
-----------

IPACS (Inventory, Performance, and Capacity System) is meant to be a free inventory system for users to track and monitor
their assets. It is being designed with a datacenter / server enterprise model in mind, but can be adapted to other
inventory needs.


Overall Process
---------------

The current process consists of the following phases:

<ol>
<li>Gather</li>
At the moment, there is one gather script (/GATHER_SCRIPTS/windows/windows_fingerprint.ps1). This script gathers information
on the servers listed in a file specified when run (in command line).

This script is run on the same server as the mongodb instance.

The output of the script (input to the db) must be in a .json file in the following format:
<blockquote>
{
        "name" : "complex_server",
        "device_type" : "server",
        "os" : "linux",
        "info" : [
                {
                        "net_info" : [
                                {
                                        "ip" : "192.168.0.5",
                                        "name" : "eth0"
                                },
                                {
                                        "ip" : "192.168.0.28",
                                        "name" : "eth1"
                                }
                        ]
                },
                {
                        "os_info" : [{
                                "name" : "RHEL 5.2"
                        }]
                },
                {
                        "drive_info" :[ {

                        }]
                }
        ]
}
</blockquote>
<span>
<strong>note</strong>: name, device_type, os, and info are required. info must be
list of json documents (python dictionaries, powershell hashtables... etc). Each
dictionary in the info list must also contain lists (even if there is only one item in the list). 
</span>

<li>Write</li>

Each of the gather scripts (agents soon) will write to the database or at least send json documents to be written to the
database.

<li>Display</li>
The information is displayed from the database in a bottle webapp. At the moment, the webapp is not very resilient.
</ol>

A number of revamps are desired in every phase. Notably, agents for Windows, Linux, Network devices, and Solaris to report configuration
information. Displaying needs to be a bit more intuitive as well as useful, integrating report running.


<h2>Requirements</h2>

<ul>
<li>MongoDB</li>
<li>Python 2.7</li>
<li>bottle.py version < .12</li>
<li>pymongo</li>
<li>Server</li>
</ul>

IPACS is built with python bottle. It uses pymongo to interact with a mongodb. The current system setup is on a Windows
machine, but the next iterations will be moving to a CentOS machine for testing.




<h2>Current Status and Features</h2>


<h2>Required status for .2 release</h2>

The minimum requirements for the next version to be released are:

-   Create an "add new device" form with the minimum requirements of Name, Type, and info.
-   Hyperlink to create new device on bottom of "viewAll" page. This is important because if a device type does not exist, you will still want to be able to create it.
-   Edit device form.
-   "Actions" li in the nav bar
-   Readme file standardized in md syntax
-   About page
-   Home page written
-   css for attached files
-   attached files allowed file extensions.
-   test copied to project home

Required status for .21 release
------------------------------

-   Logo for the tab in browsers
-   logo for the header


for .22 release
---------------

-   Edit filename pop-up
-   add nav tag

for .3 release
--------------

-   separate business logic into external class
-   "remote to machine" link

for .9 release
--------------

-   Evaluate bottle as primary webapp technology. Possibly switch to django, pyramid, flask (in anticipation
	of future changes).

for 1.0 release
---------------

-   Simple Authentication
-   HTTPS


for 2.0 release
---------------

-   ldap integration with most ldap (specifically AD) for SSO

Future Features
---------------

-   ORM
    ---
	
	While I am testing with mongoDB, I would like to use some type of ORM like hibernate so this application is not
	dependant on any particular database technology. This would also help if a particular user of this software had 
	a requirement to use a particular database.
	
-   Install Script
    --------------	
	I would like to make it as simple as possible to run this software. Putting together an install script or at least
	an install document would be paramount on the distribution of this software.
	
-   Additional Fingerprinting Capabilities
    --------------------------------------

	Right now, the fingerprint.ps1 script is the only script capable of fingerprinting systems. The script needs to be expanded
	to fingerprint linux and solaris hosts as well as network devices.
	
	There is also the need to develop a script to run on a linux server as I do not want this system to be dependant on a windows server.

-   Auto Discovery / new work flow
    ------------------------------

    A list of IPs be populated by a user. The system will maintain this list, and if it can reach the host at least once a week,
    the host will remain on the list. If a host cannot be reached within 7 days, it will be moved to a seperate list for user
    action (the list will be "unreachable_hosts" or something). The user can then decom the server or put it in a reserved list.
    Decoming the server will release the ip for use in the inventory system. When an IP is put in the original list, it will be
    fingerprinted and the resulting data stored in the db. If the system cannot be fingerprinted within a week, it will be moved
    to the unreachable list.

<h2>Wish List</h2>

<h2>Contributing</h2>

<h2>Copying Permission</h2>

 This file is part of IPACS.

    IPACS is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    IPACS is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with IPACS.  If not, see <http://www.gnu.org/licenses/>.




<h2>Contact info</h2>

coming soon
</ol>