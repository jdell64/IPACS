<h1>IPACS</h1>


<ol>
<h2>Description</h2>

IPACS (Inventory, Performance, and Capacity System) is meant to be a free inventory system for users to track and monitor
their assets. It is being designed with a datacenter / server enterprise model in mind, but can be adapted to other
inventory needs.


<h2>Overall Process</h2>

The current process consists of the following phases:

<ol>
<li>Gather</li>
At the moment, there is one gather script (/GATHER_SCRIPTS/windows/windows_fingerprint.ps1). This script gathers information
on the servers listed in a file specified when run (in command line).

This script is run on the same server as the mongodb instance.

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
<li>bottle.py</li>
<li>pymongo</li>
<li>Server</li>
</ul>

IPACS is built with python bottle. It uses pymongo to interact with a mongodb. The current system setup is on a Windows
machine, but the next iterations will be moving to a CentOS machine for testing.



<h2>Current Status and Features</h2>

<h2>Future Features</h2>

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

comming soon
</ol>