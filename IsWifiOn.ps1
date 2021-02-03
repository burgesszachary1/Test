#This script checks every 1 second if your internet connection is UP,
#also writing every 1 second this information to a log_file

#A disconnect from a connection will be searchable "disconnect"

WHILE(1)
{
    Clear-Host

    $ConnectionList = get-netadapter | select Name, Status, Linkspeed | sort-object -property Name

    [string]$StrOfConnections = $ConnectionList | Out-String
    #$CharArray = $BigStrOfProcNames.Split(":")

    [string]$CleanStr = $StrOfConnections.TrimStart()
    $CleanStr = $CleanStr.TrimEnd()
    #Add-Content F_ile.txt "$CleanStr"

    $StrArray = $CleanStr.Split("`r")

    [string]$my_date = Get-Date

    #edit strings
    $StrArray[0] = $StrArray[0] + "   Time Stamp"
    $StrArray[1] = $StrArray[1] + "   ----------"
    $StrArray[7] = $StrArray[7] + "   " + $my_date

    #Write to Shell
    Write-Host -NoNewline $StrArray[0]
    Write-Host $StrArray[1]
    Write-Host $StrArray[7].TrimStart()
    Write-Host "`r"

    $str0 = $StrArray[0]
    $str1 = $StrArray[1]
    $str7 = $StrArray[7].TrimStart()

    #Write to log file
    Add-Content WIFI_OUTPUT_FILE.txt "$str0" -NoNewline
    Add-Content WIFI_OUTPUT_FILE.txt "$str1"
    Add-Content WIFI_OUTPUT_FILE.txt "$str7"
    Add-Content WIFI_OUTPUT_FILE.txt "`r"


    Start-Sleep 1
}