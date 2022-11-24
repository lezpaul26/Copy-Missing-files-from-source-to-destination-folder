Param (
    [string] $sourcePath ="", # Path que tenia el acceso directo
    [string] $destPath  =""   # Path que tenia el acceso directo
)

$todaysdate=Get-Date -Format "MM-dd-yyyy"

$logfilepath = "D:\log_"+$todaysdate+".log"


function WriteToLogFile ($message)
{
   Add-content $logfilepath -value $message +" - "+ (Get-Date).ToString()
}
if(Test-Path $logfilepath)
{
    Remove-Item $logfilepath
}



$objFSOFolder = $objFSO.GetFolder($sourcePath)

$objFSOFolders = $objFSOFolder.SubFolders

Foreach ($file in $objFSOFolders){ 

Write-Output "$($file.Name)"
}

Try
    {       
            foreach($dir in $objFSOFolders ){
                if (Test-Path "$($destPath)\$($dir.name)" -PathType Container) 
                    {
                        try {                            
                                $objFSOFoldersPath = Get-ChildItem -Path "$($sourcePath)\$($dir.name)\"
                                foreach($dirfile in $objFSOFoldersPath){                                    
                                    if (-not (Test-Path "$($destPath)\$($dir.name)\$($dirfile.name)" -PathType Container)){
                                        if(-not(Test-Path -Path "$($destPath)\$($dir.name)\$($dirfile.name)" -PathType Leaf)){
                                            Copy-Item -Path "$($sourcePath)\$($dir.name)\$($dirfile.name)" -Destination "$($destPath)\$($dir.name)\$($dirfile.name)"
                                        }
                                        else{                                              
                                        }#Else
                                    }#IfFile 
                                    else{
                                    }                                                                       
                                }#Foreach
                            }
                     catch {
                                WriteToLogFile "Unable to create directory "$($destPath)\$($dir.name)\$($dirfile.name)". Error was: $_"
                           }                               
            }
            else{
                                $objFSOFoldersPath = Get-ChildItem -Path "$($sourcePath)\$($dir.name)\"
                                New-Item -Path "$($destPath)\$($dir.name)" -ItemType Directory -ErrorAction Stop | Out-Null #-Force
                                foreach($dirfile in $objFSOFoldersPath){
                                    Copy-Item -Path "$($sourcePath)\$($dir.name)\$($dirfile.name)" -Destination "$($destPath)\$($dir.name)\$($dirfile.name)"
                                }
                }
        
        }
    }
    Catch
    {            
        WriteToLogFile "An error occurred trying stop: $LINE " + $_.Exception.Message
        Write-Host "An error occurred trying stop: $LINE " -ForegroundColor Red        
        Write-Host $_.Exception.Message
    }
    Finally
    {
        
        Write-Host "finish trying start: $LINE "
    }