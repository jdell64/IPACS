$cluster_ip = "192.168.101.71"
add-pssnapin vm*
Connect-VIServer $cluster_ip >$null
$vms = get-vm | where {$_.PowerState -eq "PoweredOn"}
foreach ($vm in $vms){
	$name = $($vm.name).PadRight(32)
	$os = $vm.Guest.OSFullName
	$ip = $vm.Guest.IPAddress |where {$_ -like '*.*.*.*'}
	if($ip){$ip = $ip.padright(20)}
	$output = $name + $ip + $os
	$output
}