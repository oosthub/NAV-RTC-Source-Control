##################################################################
# Created by BO
#
# Used with the NAV Source Control System
# GitHub: https://github.com/oosthub/NAV-RTC-Source-Control
################################################################## 

function Git-Reset {
   param(
        [parameter(Mandatory=$true)][string]$Path,
        [parameter(Mandatory=$true)][string]$Upstream,
        [parameter(Mandatory=$true)][string]$LogPath,
        [Parameter(Mandatory=$true)][boolean][switch]$Hard
    )

   Write-Host "Attempting to Git Reset"

   Set-Location -Path $Path
   git add . > $LogPath

   if($Hard -eq $false)
   {
     git reset $Upstream
   }
   elseif($Hard -eq $true)
   {
     git reset --hard > $LogPath
   }

    Write-Host "DONE"
}

function Git-ResetHard {
   param(
        [parameter(Mandatory=$true)][string]$Path,
        [parameter(Mandatory=$true)][string]$Repo,
        [parameter(Mandatory=$true)][string]$Branch,
        [parameter(Mandatory=$true)][string]$LogPath,
        [Parameter(Mandatory=$true)][string]$Editor
    )

   Write-Host "Attempting to Git Reset"
   Set-Location -Path $Path
   git reset --hard $Repo/$Branch > $LogPath
   Start-Process $Editor """$LogPath"""
   Write-Host "DONE"
}

function Git-Log {
   param(
        [parameter(Mandatory=$true)][string]$Path,
        [parameter(Mandatory=$true)][string]$LogPath,
        [Parameter(Mandatory=$true)][string]$Editor,
        [Parameter(Mandatory=$false)][string]$File
    )
   Write-Host "Attempting to Git Log"
   Set-Location -Path $Path
   if($File -eq '')
   {
     git log --pretty=format:'%h was %an, %ar, message: %s' > $LogPath
   }
   elseif($File -ne '')
   {
     git log -- $File --pretty=format:'%h was %an, %ar, message: %s' > $LogPath
   }

   Start-Process $Editor """$LogPath"""
   Write-Host "DONE"
}

function Git-Status {
   param(
        [parameter(Mandatory=$true)][string]$Path,
        [parameter(Mandatory=$true)][string]$LogPath,
        [Parameter(Mandatory=$true)][string]$Editor
    )
   Write-Host "Attempting to Git Status"
   Set-Location -Path $Path

   git fetch
   git status > $LogPath

   Start-Process $Editor """$LogPath"""
   Write-Host "DONE"

}

function Git-Pull {
   param(
        [parameter(Mandatory=$true)][string]$Path,
        [parameter(Mandatory=$true)][string]$LogPath,
        [Parameter(Mandatory=$true)][string]$Editor
    )
   Write-Host "Attempting to Pull Latest"
   Set-Location -Path $Path

   git pull > $LogPath
   
   Start-Process $Editor """$LogPath"""
   Write-Host "DONE"

}

function Git-ViewFile {
   param(
        [parameter(Mandatory=$true)]$Path,
        [Parameter(Mandatory=$true)]$Editor
    )

   Write-Host "Attempting to Open File"
   Start-Process $Editor """$Path"""
    
   Write-Host "DONE"
}

function Git-CompareFile {
   param(
        [parameter(Mandatory=$true)]$Path1,
        [parameter(Mandatory=$true)]$Path2,
        [Parameter(Mandatory=$true)]$Editor
    )

   Write-Host "Attempting to Open File"
   $arguments = """$Path1""" + ' ' + """$Path2"""
   Start-Process $Editor -argumentlist $arguments
    
   Write-Host "DONE"
}

function Git-SetBranchLocation {
   param(
        [parameter(Mandatory=$true)]$Path
    )

   Write-Host "Switching to Branch"
   Set-Location -Path $Path

}

function Git-OpenGui {
   param(
        [parameter(Mandatory=$true)]$Path
    )
    Set-Location -Path $Path
    git gui
}

function Git-PushUp {
   param(
        [parameter(Mandatory=$true)]$Path,
        [parameter(Mandatory=$true)][string]$Repo,
        [parameter(Mandatory=$true)][string]$Branch,
        [parameter(Mandatory=$true)][string]$LogPath,
        [Parameter(Mandatory=$true)]$Editor
    )

    Set-Location -Path $Path
    git push --porcelain $Repo $Branch > $LogPath
    git log -10 --pretty=format:'%h was %an, %ar, message: %s' >> $LogPath

    Start-Process $Editor """$LogPath"""
}

function Git-Clone {
   param(
        [parameter(Mandatory=$true)]$LocalParentPath,
        [parameter(Mandatory=$true)]$HttpPath
    )
    Set-Location -Path $LocalParentPath
    git clone $HttpPath
}

function Git-Diff {
   param(
        [parameter(Mandatory=$true)]$Path,
        [parameter(Mandatory=$true)][string]$Repo,
        [parameter(Mandatory=$true)][string]$Branch,
        [parameter(Mandatory=$true)][string]$LogPath,
        [Parameter(Mandatory=$true)]$Editor
    )

    Set-Location -Path $Path
    git diff --name-only $Repo/$Branch > $LogPath
}


Export-ModuleMember -Function * -Alias * -Variable *