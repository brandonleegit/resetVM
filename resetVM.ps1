#variables
$vcenter = 'vcenter.domain.local'
$cred = get-credential
$Log = 'c:\log\testfail.log'
$Time = get-date
$servers = 'testserver'

#connect vCenter

connect-viserver -server $vcenter -credential $cred

#Health Check


Foreach($server in $servers)

{

if(Test-Connection -Cn $server -BufferSize 16 -Count 1 -ea 0 -quiet) {

   “Testing connection to $server is successful”

}

if (!(Test-Connection -Cn $server -BufferSize 16 -Count 1 -ea 0 -quiet)) {

    "Connection Failed `t`t" + $Time.DateTime + "`t`t" + ($endTime – $Time).TotalSeconds + " seconds" | Out-File $Log -Append; send-mailmessage -from "<$server@somewhere.com>" -to "Some One <someone@somewhere.com>" -subject "$server not responding" -body "Test Server not responding, waiting 10 seconds and will try again" -smtpserver 1.2.3.4;

    "Waiting 10 seconds"
    
    sleep 10


if (!(Test-Connection -Cn $server -BufferSize 16 -Count 4 -ea 0 -quiet)) {

    "Connection Failed `t`t" + $Time.DateTime + "`t`t" + ($endTime – $Time).TotalSeconds + " seconds" | Out-File $Log -Append ; (Get-VM -Name $server).ExtensionData.ResetVM(); 

    send-mailmessage -from "<$server@somewhere.com>" -to "Some One <someone@somewhere.com>" -subject "Test Server crash" -body "Test Server must have crashed" -smtpserver 1.2.3.4;

    sleep 30

    }

ELSE {“Successful `t`t" + $Time.DateTime + "`t`t" + ($endTime – $Time).TotalSeconds + " seconds" | Out-File $Log -Append; send-mailmessage -from "<$server@somewhere.com>" -to "Some One <someone@somewhere.com>" -subject "$server is responding" -body "Test Server is responding again and was not reset" -smtpserver 1.2.3.4;} #end if


}

}


