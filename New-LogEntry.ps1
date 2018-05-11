function New-LogEntry
{
<#
	.SYNOPSIS
		Function to create a log file for PowerShell scripts
	
	.DESCRIPTION
		Function supports both writing to a text file (default), sending messages only to console via ConsoleOnly parameter or both via WriteToConsole parameter.
		
		The BufferOnly parameter will not write message neither to console or logfile but save to a temporary buffer which can then be piped to file or printed to screen.
	
	.PARAMETER logMessage
		A string containing the message PowerShell should log for example
		about current action being performed.
	
	.PARAMETER WriteToConsole
		Writes the log message both to the log file and the interactive
		console, similar to built-in Write-Host.
	
	.PARAMETER logFilePath
		Specifies the path and log file name that will be created.
		
		Parameter only accepts full path IE C:\MyLog.log
	
	.PARAMETER isErrorMessage
		Prepend the log message with the [Error] tag in file and
		uses the Write-Error built-in cmdlet to throw a non terminating
		error in PowerShell Console
	
	.PARAMETER IsWarningMessage
		Prepend the log message with the [Warning] tag in file and
		uses the Write-Warning built-in cmdlet to throw a warning in
		PowerShell Console
	
	.PARAMETER ConsoleOnly
		Print the log message to console without writing it file
	
	.PARAMETER BufferOnly
		Saves log message to a variable without printing to console
		or writing to log file
	
	.PARAMETER SaveToBuffer
		Saves log message to a variable for later use
	
	.PARAMETER NoTimeStamp
		Does not prepend the message with the current date
	
	.EXAMPLE
		Example 1: Write a log message to log file
		PS C:\> New-LogEntry -logMessage "Test Entry"
		
		This will simply output the message "Test Entry" in the logfile
		
		Example 2: Write a log message to console only
		PS C:\> New-LogEntry -logMessage "Test Entry" -ConsoleOnly
		
		This will print Test Entry on console
		
		Example 3: Write an error log message
		New-LogEntry -logMessage "Test Log Error" -isErrorMessage
		
		This will prepend the [Error] tag in front of
		log message like:
		
		[06-21 03:20:57] : [Error] - Test Log Error
	
	.NOTES
		There 1 second delay between function execution
		and call to log file to avoi potentail file locks
		under heavy logging activities.
#>
	
	[CmdletBinding()]
	param
	(
		[AllowNull()]
		[Alias('Log', 'Message')]
		[string]
		$LogMessage,
		[switch]
		$WriteToConsole = $false,
		[AllowNull()]
		[Alias('Path', 'LogFile', 'File')]
		[string]
		$LogFilePath,
		[switch]
		$IsErrorMessage = $false,
		[switch]
		$IsWarningMessage = $false,
		[switch]
		$ConsoleOnly = $false,
		[switch]
		$BufferOnly = $false,
		[switch]
		$SaveToBuffer = $false
	)
	
	# Use current path if no filepath is specified
	if ([string]::IsNullOrEmpty($logFilePath) -eq $true)
	{
		$logFilePath = $PSCommandPath + '-LogFile-' + $(Get-Date -Format 'yyyy-MM-dd') + '.log'
	}
	
	# Don't do anything on empty Log Message
	if ([string]::IsNullOrEmpty($logMessage) -eq $true)
	{
		return
	}
	
	# Format message according to switches used
	$tmpMessage = $logMessage
	
	if ($isErrorMessage -eq $true)
	{
		$tmpMessage = "[$(Get-Date -Format 'MM-dd hh:mm:ss')] : [Error] - $logMessage"
	}
	elseif ($IsWarningMessage -eq $true)
	{
		$tmpMessage = "[$(Get-Date -Format 'MM-dd hh:mm:ss')] : [Warning] - $logMessage"
	}
	else
	{
		$tmpMessage = "[$(Get-Date -Format 'MM-dd hh:mm:ss')] : $logMessage"
	}
	
	# Write log messages to console
	if (($ConsoleOnly -eq $true) -or ($WriteToConsole -eq $true))
	{
		if ($IsError -eq $true)
		{
			Write-Error $logMessage
		}
		elseif ($IsWarningMessage -eq $true)
		{
			Write-Warning $logMessage
		}
		else
		{
			Write-Output -InputObject $logMessage
		}
		
		# Write to console and exit
		if ($ConsoleOnly -eq $true)
		{
			return
		}
	}
	
	# Write log messages to file
	if (([string]::IsNullOrEmpty($logFilePath) -eq $false) -and ($BufferOnly -ne $true))
	{
		Start-Sleep -Milliseconds 500
		
		Add-Content -Path $logFilePath -Value $tmpMessage
	}
	
	# Save message to buffer
	if (($BufferOnly -eq $true) -or ($SaveToBuffer -eq $true))
	{
		$script:messageBuffer += $tmpMessage + "`r`n"
		
		# Remove blank lines
		$script:messageBuffer = $script:messageBuffer -creplace '(?m)^\s*\r?\n', ''
	}
}