Param(
    [string]$targetPC
)


# SET THESE TO MATCH YOUR ENVIRONMENTS (used on line 216):
$mongohost  = "127.0.0.1"
$mongodbName = "pacman"
$collectionName = "servers"


<#####################################################################

______  _                                         _         _   
|  ___|(_)                                       (_)       | |  
| |_    _  _ __    __ _   ___  _ __  _ __   _ __  _  _ __  | |_ 
|  _|  | || '_ \  / _` | / _ \| '__|| '_ \ | '__|| || '_ \ | __|
| |    | || | | || (_| ||  __/| |   | |_) || |   | || | | || |_ 
\_|    |_||_| |_| \__, | \___||_|   | .__/ |_|   |_||_| |_| \__|
                   __/ |            | |                         
                  |___/             |_|                         


 by jeff Tindell


 Copyright (C) 2014  Richard Tindell II

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>


#####################################################################>




<#####################################################################
            Global Variables 
#####################################################################>



#dictionaries
#Drive type dictionary (from http://msdn.microsoft.com/en-us/library/aa394173(v=vs.85).aspx)
$driveTypeDictionary = "Unknown","No Root Directory", "Removable Disk", "Local Disk", "Network Drive", "Compact Disk", "RAM Disk" 
#OS Version number dictionary (from http://msdn.microsoft.com/en-us/library/windows/desktop/ms724832(v=vs.85).aspx)
$osProductTypeDictionary = "Unknown","Client","Domain Controller","Server"
#Windows Client Dictionaries
$winClientDictionary = @{"6.3" = "Windows 8.1"; "6.2" = "Windows 8"; "6.1" = "Windows 7"; "6.0" = "Windows Vista"; 
                         "5.2" = "Windows XP 64-Bit"; "5.1" = "Windows XP"}
$winServerDictionary = @{"6.3" = "Windows Server 2012 R2"; "6.2" = "Windows Server 2012"; "6.1" = "Windows Server 2008 R2";
                         "6.0" = "Windows Server 2008"; "5.2" = "Windows Server 2003 R2"; "5.1" = "Windows Server 2003"}

#synonyms for localhost:
$localList = '127.0.0.1', 'localhost', '.'

$cred = Get-Credential
 $computerSystemInfo = $null 
    $motherboardInfo = $null
    $cpuInfo = $null 
    $winInfo =$null
    $memoryInfo =$null
    $drivesInfo = $null
    $networkInfo =$null
    $computername = $null



<#####################################################################
            Main Logic Function
#####################################################################>


Function generateJSON() {

    $output=@{}
    #Computer System Info
    if($computerSystemInfo){
        $domain = $computerSystemInfo.Domain
        $manufacturer = $computerSystemInfo.Manufacturer
        $model = $computerSystemInfo.Model
        $computerName = $computerSystemInfo.Name
        #computer system output
        $output += @{"device_name"=  $computerName; "type" = "server"}
        $output += @{"system_computer_domain"= "$domain";"system_computer_name" = "$computerName"; "system_make"=$manufacturer; "system_model"=$model}
    }

    #Motherboard Info
    if($motherboardInfo){
        $mbMake = $motherboardInfo.Manufacturer
        $mbSerial = $motherboardInfo.SerialNumber
        #motherboard output
        $output += @{"mb_make" = "$mbMake"; "mb_serial" = "$mbSerial"}
    }


    #CPU Info
    if($cpuInfo){
        if ($cpuInfo -is [system.array]){
            $cpuInfo = $cpuInfo[0]
        }
        $cpuManufacturer = $cpuInfo.Manufacturer    
        $n = ([float]$cpuInfo.MaxClockSpeed)/1000
        $n = ("{0:N1}" -f $n)
        $cpuSpeed =  "$n GHz"
        $cpuName = $cpuInfo.Name
        $output += @{"cpu_name" = "$cpuName"; "cpu_make" = "$cpuManufacturer"; "cpu_speed" = "$cpuSpeed"}
    }

    if($winInfo){
        #os Info
        $osProdType = $osProductTypeDictionary[($winInfo.ProductType)]
        $osBit = $winInfo.OSArchitecture
        $osMajorVersion = $winInfo.Version.Substring(0,3)
        $winVersionName =""
        switch ($osProdType) {
            "Unknown" {$winVersionName = $winClientDictionary.get_Item($osMajorVersion)}
            "Client" {$winVersionName = $winClientDictionary.get_Item($osMajorVersion)}
            default {$winVersionName = $winServerDictionary.get_Item($osMajorVersion)}
        }
        $osVersionNumber = $winInfo.Version
        #OS output
        $output+=  @{"os_name" = "$winVersionName"; "os_Bit"= "$osBit"; "os_version_number"= "$osVersionNumber"; "os_type" = "$osProdType"}
    }

    if($memoryInfo){
        #physical memory info

        $memorySpeed = $memoryInfo.Speed
        $memorySize = $memoryInfo.Capacity
        if ($memorySize) {
            $memorySize /=1073741824
            $memorySize = "$memorySize GB"
            }
            
        if ($memorySpeed){$memorySpeed = "$memorySpeed Hz"}
        
        #memory Output
        $output += @{"mem_size" = $memorySize; "mem_speed" = $memorySpeed}
    }

    #Hard drive Info
    #drive Output

    if($drivesInfo){
        $drivesOutput = @{}
        $currentDrive=1
        foreach ($drive in $drivesInfo){
            $currentDriveHash = @{}
            $label = "drive$currentDrive"+"_"

            $currentDriveHash += @{("$label"+"device_id") = $drive.DeviceID}
            $currentDriveHash += @{("$label"+"name") = $drive.VolumeName}
            $currentDriveHash += @{("$label"+"type") = ($driveTypeDictionary[($drive.DriveType)])}
            $currentDriveHash += @{("$label"+"free") = $drive.FreeSpace}
            $currentDriveHash += @{("$label"+"used") = ($drive.size - $drive.FreeSpace)}
            $currentDriveHash += @{("$label"+"max_size") = $drive.Size}
   
            $output += $currentDriveHash
   
            $currentDrive++

        }
    }
    if($networkInfo){
        $currentNetDevice = 1
        foreach ($netDevice in $networkInfo){
            $currentIP = ($netDevice.IPAddress | Where-Object {$_ -like "*.*.*.*"})
            $currentgw =  $netDevice.defaultIPGateway
            if($currentgw){
                $currentgw= $currentgw[0]
        
            } else {
                $currentgw = "N/A"
            }
    
            $label = "eth$currentNetDevice"+"_"
            $currentNetHash = @{}
            $currentNetHash += @{("$label"+"name")= $netDevice.Description}
            $currentNetHash += @{("$label"+"dhcp")=  $netDevice.DHCPEnabled}
            $currentNetHash += @{("$label"+"ip")=  $currentIP}
            $currentNetHash += @{("$label"+"gw")=  $currentgw}
            $output += $currentNetHash
            $currentNetDevice++
        }
    }


    <#####################################################################
                Output
    #####################################################################>
    
    if($output.Count -ne 0){
        
       

        $jsonOutput = $output | ConvertTo-Json
        Set-Content -Path "./$Computername.json" -Encoding UTF8 -Value $jsonOutput
    

    <#####################################################################
                import into mongodb
    #####################################################################>
        
        mongoimport --host $mongohost --db $mongodbName --collection $collectionName ./$computername.json --jsonArray >$null
        Write-Host "$target written to db"
        Remove-Item ./$computername.json
        
    } else { 
            Write-Host "ERROR $target not added to db. No hostname found. Linux host or net_device?"
    }    
    

   $computerSystemInfo = $null 
    $motherboardInfo = $null
    $cpuInfo = $null 
    $winInfo =$null
    $memoryInfo =$null
    $drivesInfo = $null
    $networkInfo =$null
    $computername = $null


 }


<#####################################################################
            Input Variables and Run
#####################################################################>

Function help(){
    $help_output  = "Fingerprint v2 by Jeff Tindell`n"
    $help_output +="`tuse: .\fingerprint.ps1 [`"computername`" | ip_addresss | `"path_to_list.txt`"]`n"
    $help_output +="`n`tA list file should contain one computername or ip per line:`n"
    $help_output += "`n`tExample List.txt Contents:"
    $help_output += "`n`t`tcomputer1"
    $help_output += "`n`t`tcomputer2"
    $help_output += "`n`t`tcomputer3"
    $help_output += "`n`n"

    Write-Host $help_output
    exit
    
}
if (!$targetPC){
    help
}

if($localList -contains $targetPC){
    $isList = $false
    wmiOnLocalSet

} else {
    $isList = Test-Path($targetPC)
}
if ($isList){
    $fileContent = Get-Content $targetPC

    foreach ($target in $fileContent) {
       
        $canConnect = Test-Connection -ComputerName $target -Quiet
        if($canConnect){
            $ErrorActionPreference = "silentlycontinue"
            try{

                if ($localList -contains $target){
                   $computerSystemInfo = gwmi Win32_computerSystem
                    $motherboardInfo = gwmi Win32_baseboard 
                    $cpuInfo = gwmi Win32_processor 
                    $winInfo = gwmi Win32_operatingSystem
                    $memoryInfo = gwmi Win32_PhysicalMemory
                    $drivesInfo = gwmi Win32_LogicalDisk
                    $networkInfo = (gwmi win32_networkadapterconfiguration | where IPAddress -NE $NULL)
                    
                } else {
                    $computerSystemInfo = gwmi Win32_computerSystem -ComputerName $target -Credential $cred
                    $motherboardInfo = gwmi Win32_baseboard -ComputerName $target -Credential $cred
                    $cpuInfo = gwmi Win32_processor -ComputerName $target -Credential $cred
                    $winInfo = gwmi Win32_operatingSystem -ComputerName $target -Credential $cred
                    $memoryInfo = gwmi Win32_PhysicalMemory -ComputerName $target -Credential $cred
                    $drivesInfo = gwmi Win32_LogicalDisk -ComputerName $target -Credential $cred
                    $networkInfo = (gwmi win32_networkadapterconfiguration -ComputerName $target -Credential $cred | where IPAddress -NE $NULL) 
                }

                generateJSON  

           } catch {
                write-host "ERROR: $target not added to DB; Error with WMI: " $error[0]
 
           }
        } else {
            write-host "ERROR: $target not added to DB; Unable to ping host."
 
        }
       

    }

    
<#####################################################################
    $computerSystemInfo = gwmi Win32_computerSystem
    $motherboardInfo = gwmi Win32_baseboard 
    $cpuInfo = gwmi Win32_processor 
    $winInfo = gwmi Win32_operatingSystem
    $memoryInfo = gwmi Win32_PhysicalMemory
    $drivesInfo = gwmi Win32_LogicalDisk
    $networkInfo = (gwmi win32_networkadapterconfiguration | where IPAddress -NE $NULL)
    generateJSON

    
#####################################################################>
    exit
}





<#####################################################################
            WMI Calls

$computerSystemInfo = gwmi Win32_computerSystem
$motherboardInfo = gwmi Win32_baseboard 
$cpuInfo = gwmi Win32_processor 
$winInfo = gwmi Win32_operatingSystem
$memoryInfo = gwmi Win32_PhysicalMemory
$drivesInfo = gwmi Win32_LogicalDisk
$networkInfo = (gwmi win32_networkadapterconfiguration | where IPAddress -NE $NULL)

#####################################################################>
