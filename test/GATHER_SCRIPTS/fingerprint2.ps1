Param(
    [string]$targetPC
)


# SET THESE TO MATCH YOUR ENVIRONMENTS (used on line 216):
$mongohost  = "127.0.0.1"
$mongodbName = "ipac"
$collectionName = "test"


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
    $info=@()
    #Computer System Info
    if($computerSystemInfo){
        $domain = $computerSystemInfo.Domain
        $manufacturer = $computerSystemInfo.Manufacturer
        $model = $computerSystemInfo.Model
        $computerName = $computerSystemInfo.Name
        #computer system output
        $output += @{"name"=  $computerName; "device_type" = "server"; "os" = "windows"}
        $info += @{"system_info" =@(@{"computer_domain"= "$domain";"computer_name" = "$computerName"; "make"=$manufacturer; "model"=$model})}
    }

    #Motherboard Info
    if($motherboardInfo){
        $mbMake = $motherboardInfo.Manufacturer
        $mbSerial = $motherboardInfo.SerialNumber
        #motherboard output
        $info +=@{"mb_info" = @(@{"make" = "$mbMake"; "serial" = "$mbSerial"})}
    }


    #CPU Info
    if($cpuInfo){
        $tempCPUList=@()
        $cpuNum=1
        foreach($cpu in $cpuInfo){
            $cpuManufacturer = $cpu.Manufacturer    
            $n = ([float]$cpu.MaxClockSpeed)/1000
            $n = ("{0:N1}" -f $n)
            $cpuSpeed =  "$n GHz"
            $cpuName = $cpu.Name
            $tempCPUList += @{"number"= $cpuNum;"name" = "$cpuName"; "make" = "$cpuManufacturer"; "speed" = "$cpuSpeed"}
            $cpuNum++
        }
        $info +=@{"cpu_info" = $tempCPUList}

    }

    if($winInfo){
        #os Info
        $osProdType = $osProductTypeDictionary[($winInfo.ProductType)]
        $osBit = $winInfo.OSArchitecture
        $osMajorVersion = $winInfo.Version.Substring(0,3)
        $winVersionName =""
        switch ($osProdType) {
            "Server" {$winVersionName = $winClientDictionary.get_Item($osMajorVersion)}
            "Unknown" {$winVersionName = $winClientDictionary.get_Item($osMajorVersion)}
            "Client" {$winVersionName = $winClientDictionary.get_Item($osMajorVersion)}
            default {$winVersionName = $winServerDictionary.get_Item($osMajorVersion)}
        }
        $osVersionNumber = $winInfo.Version
        #OS output
       $info += @{"os_info" = @( @{"name" = "$winVersionName"; "bit"= "$osBit"; "version_number"= "$osVersionNumber"; "type" = "$osProdType"})
    }
    }
    if($memoryInfo){
        #physical memory info
        $tempMEMList =@()
        $memNum = 1
        foreach ($mem in $memoryInfo){
            
            $memorySpeed = $mem.Speed
            $memorySize = $mem.Capacity
            $memorySize /= 1073741824
            $memorySize = "$memorySize GB"
            if ($memorySpeed){$memorySpeed = "$memorySpeed Hz"}
            $tempMEMList+= @{"number" = $memNum; "size" = $memorySize; "speed" = $memorySpeed}

            $memNum++
            }

        #memory Output
        $info += @{"mem_info" = $tempMEMList}

    }

    #Hard drive Info
    #drive Output

    if($drivesInfo){
  
        $tempDRIVEList =@()
        $currentDrive=1
        foreach ($drive in $drivesInfo){
            $currentDriveHash = @{}

            $free = $drive.FreeSpace
            $maxSize = $drive.Size 
            $used = ($maxSize - $free) 
            if($maxSize){
                $usedp = $used / $maxSize
                $usedp = "{0:N0}" -f $usedp
                $usedp = "$usedp %"
            }

            $tempArray =@($maxSize, $free, $used)

            for($i=0; $i -lt $tempArray.Length; $i++){
                if($tempArray[$i]){
                    $tempstr = ""
                    $tempArray[$i] = "{0:N2}" -f ($tempArray[$i]/1073741824)
                    $tempstr = $tempArray[$i]
                    $tempstr = "$tempstr GB"
                    $tempArray[$i] = $tempstr
                } else {
                    $tempArray[$i] = $NULL
                }
            }

            $maxSize = $tempArray[0]
            $free = $tempArray[1]
            $tempstr = $tempArray[2]
            if ($tempstr){
                $tempstr = "$tempstr ($usedp)"
            }
            $used = $tempstr 



            $currentDriveHash += @{"device_id" = $drive.DeviceID}
            $currentDriveHash += @{"name" = $drive.VolumeName}
            $currentDriveHash += @{"type" = ($driveTypeDictionary[($drive.DriveType)])}
            $currentDriveHash += @{"free" = $free}
            $currentDriveHash += @{"used" = $used}
            $currentDriveHash += @{"max_size" = $maxSize}
            $currentDriveHash += @{"drive_num" = $currentDrive}
            $currentDrive++
            $tempDRIVEList += $currentDriveHash
            }

        #memory Output
        $info += @{"hd_info" = $tempDRIVEList}

    }

    if($networkInfo){
        
        $tempNICList =@()
        $currentNetDevice = 1
        foreach ($netDevice in $networkInfo){
            $currentNetHash = @{}
            $currentNetHash += @{"name" = $netDevice.Description}
            $currentNetHash += @{"nic_num" = $currentNetDevice}
            $currentNetHash += @{"dhcp"=  $netDevice.DHCPEnabled}
            $currentNetHash += @{"ip" =  $netDevice.IPAddress | Where-Object {$_ -like "*.*.*.*"}}
            $currentgw =  $netDevice.defaultIPGateway
            if($currentgw){
                $currentgw= $currentgw[0]
        
            } else {
                $currentgw = "N/A"
            }
            $currentNetHash += @{"gw"=  $currentgw}
            $tempNICList += $currentNetHash
            $currentNetDevice++
        }

        $info += @{"net_info" = $tempNICList}

    }


    $output += @{"info" = $info}

    


    <#####################################################################
                Output
    #####################################################################>
    
    if($output.Count -ne 0){
        $jsonOutput =  ConvertTo-Json @($output) -Depth 5
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
    

####RESET VARS####
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
} else {
    $isList = Test-Path($targetPC)
    $cred = Get-Credential
}
if (!$isList){
    $fileContent = $targetPC
} else {
    $fileContent = Get-Content $targetPC
}
    foreach ($target in $fileContent) {
        $canConnect = Test-Connection -ComputerName $target -Quiet
        if($canConnect){
            Write-Host "Able to ping to $target."
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
                    Write-Host -nonewline "`tgetting SYSTEM info..."
                    $computerSystemInfo = gwmi Win32_computerSystem -ComputerName $target -Credential $cred
                    Write-Host  "done."
                    Write-Host -nonewline "`tgetting MOTHERBOARD info..."
                    $motherboardInfo = gwmi Win32_baseboard -ComputerName $target -Credential $cred
                    Write-Host  "done."
                    Write-Host -nonewline "`tgetting PROCESSOR info..."
                    $cpuInfo = gwmi Win32_processor -ComputerName $target -Credential $cred
                    Write-Host  "done."
                    Write-Host -nonewline "`tgetting OS info..."
                    $winInfo = gwmi Win32_operatingSystem -ComputerName $target -Credential $cred
                    Write-Host  "done."
                    Write-Host -nonewline "`tgetting MEMORY info..."
                    $memoryInfo = gwmi Win32_PhysicalMemory -ComputerName $target -Credential $cred
                    Write-Host  "done."
                    Write-Host -nonewline "`tgetting DISK info..."
                    $drivesInfo = gwmi Win32_LogicalDisk -ComputerName $target -Credential $cred
                    Write-Host  "done."
                    Write-Host -nonewline "`tgetting NETWORK info..."
                    $networkInfo = (gwmi win32_networkadapterconfiguration -ComputerName $target -Credential $cred | where IPAddress -NE $NULL) 
                    Write-Host  "done."
                }
                generateJSON  
           } catch {
                write-host "ERROR: $target not added to DB; Error with WMI: " $error[0]
           }
        } else {
            write-host "ERROR: $target not added to DB; Unable to ping host."
        }
    }
 
   exit

    
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
