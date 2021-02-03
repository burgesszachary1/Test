#########################################################
#See which processes have an active internet connection in Windows 10
#Gets process IDs and feeds into get-process

#original command
#while (1) {cls; & "C:\Users\burge\Documents\PowershellApp\GetCommandLineOfConnectedRunningProcesses.ps1"; start-sleep 5}

WHILE(1)
{
#clear the screen, an alias for "cls"
Clear-Host

#store programs that have an established internet connection into object
$OwnProcessName = get-nettcpconnection -State established | sort-object -property owningprocess | format-list -property owningprocess

[string]$BigStrOfProcNames = $OwnProcessName | Out-String
$CharArray = $BigStrOfProcNames.Split(":")

# build array of strings from array of chars, containing the desired process IDs

$ArrOfStrs = $CharArray
$ArrOfStrsCnt = $ArrOfStrs.Count

#holds the index of special character "`r" when it finds it
$IndexOfReturn = 0

#TrimStart() remove leading whitespace, 
#set each array value to PROCESS ID; take substr from subscr 0-`r
for (($i = 0); $i -lt $ArrOfStrsCnt; $i++) 
{
    $ArrOfStrs[$i] = $ArrOfStrs[$i].TrimStart()
    $IndexOfReturn = $ArrOfStrs[$i].IndexOf("`r")

    #skip first string
    If ($IndexOfReturn -gt 0) 
    {
        #substring() args (start,length of string); logic needs revision
        $ArrOfStrs[$i] = $ArrOfStrs[$i].Substring(0,$IndexOfReturn)
    }
}

#start at $i = 1, ignores first value which is not a valid process ID
for (($i = 1); $i -lt $ArrOfStrsCnt; $i++)
{
    If (-NOT ($ArrOfStrs[$i] -eq $ArrOfStrs[$i+1]))
    {
        $tmp = $ArrOfStrs[$i] 
        [string]$getCMD = Get-WmiObject Win32_Process -Filter "processid = $tmp" | Select-Object CommandLine
        
        #Get length of character length Get-WmiObject output,
        #take the desired substring
        $str_LEN = $getCMD.Length
        $subSTR = $getCMD.Substring(14,$str_LEN-15) #2nd arg gives total desired length of string
        
        If ($str_LEN -gt 124)
        {
            $subSTR = $getCMD.Substring(14,114)
        }

        write-Host -NoNewline "PROCESS ID: "
        Write-Host $ArrOfStrs[$i]
        Write-Host "-------------------------"
        $subSTR
        Write-Host

        #may delete code below
        #writes same output line as above, but to a file
        [string]$token = $ArrofStrs[$i];
        [string]$temp = Get-WmiObject Win32_Process -Filter "processid = $token" | Select-Object CommandLine 
        Add-Content LOG_FILE_OUTPUT.txt "$temp"
    }
}

Start-Sleep 7
}

