

#Global Variables 
$SiteURL = "https://tcwlv.sharepoint.com/sites/SiteWithDummydocandversions" 

#Serverrelative url of the Library, this will be used in this sample
$SiteRelativeURL= "/sites/SiteWithDummydocandversions/DocLibMajor"
$Folder="DocLibMajors"
$FolderDisplayName = "DocLibMajor"

#Local file path where a single dummy document is available
$File= "C:\Users\KasperLarsen\OneDrive - Fellowmind Denmark\Documents\Salling Group - Kickoff.pptx"
$FileExtension = $File.Substring($File.LastIndexOf(".")+1)




#This will be max count of dummy  files which we have to create
$majorVersionCount = 30
#this will define how many minor versions the script should create per major version
$minorVersionCount = 0
$NumberOfFiles = 10
#this will define how many minor versions the script should create before a major version is added




#For Sample Document Creation the file needs to be part of some location.
$FilePath= Get-ChildItem $File  
$FileName = $FilePath.BaseName #Inorder to get the filename for the manipulation we used this function(BaseName)

#For Logging the Operations
$LogTime = Get-Date -Format "MM-dd-yyyy_hh-mm-ss"
$LogFile = 'C:\temp\'+"FileFolderCreation_"+$LogTime+".txt"

$LogTime

 Try 
{
    #Connect to PnP Online
    $conn = Connect-PnPOnline -Url $SiteURL -Interactive -ReturnConnection
    #To Create Folder and Files  
    try
    {
        $FileCnt=0
	    while($FileCnt -lt $NumberOfFiles)
	    {
            $NewFileName= $FileName+$LogTime+"_"+$FileCnt+"." +$FileExtension
            for($i=0; $i -lt $majorVersionCount;$i++)
            {
                $major = Add-PnPFile -Path $File -Folder $Folder -NewFileName $NewFileName -Connection $conn -CheckinType MajorCheckIn 
                #Set-PnPFileCheckedOut -Url $major.ServerRelativeUrl  -Connection  $conn
                #Set-PnPFileCheckedIn -Url $major.ServerRelativeUrl -CheckinType MajorCheckIn -Comment "Major version created" -Connection $conn

                for($j=0; $j -lt $minorVersionCount;$j++)
                {
                    $minor = Add-PnPFile -Path $File -Folder $Folder -NewFileName $NewFileName -CheckinType MinorCheckIn    -Connection $conn 
                    #Set-PnPFileCheckedOut -Url $minor.ServerRelativeUrl  -Connection  $conn
                    #Set-PnPFileCheckedIn -Url $minor.ServerRelativeUrl -CheckinType MinorCheckIn -Comment "Auto created" -Connection $conn
                }
            }
            $FileCnt++
        }
    }
    catch
    {
        write-host "Error: $($_.Exception.Message)" -foregroundcolor Red
    }
}
catch 
{
    write-host "Error: $($_.Exception.Message)" -foregroundcolor Red
}

