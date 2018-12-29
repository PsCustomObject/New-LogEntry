function New-LogEntry
{
<#
	.SYNOPSIS
		Function to create a log file for PowerShell scripts
	
	.DESCRIPTION
		Function supports both writing to a text file (default), sending messages only to console via ConsoleOnly parameter or both via WriteToConsole parameter.
		
		The BufferOnly parameter will not write message neither to console or logfile but save to a temporary buffer which can then be piped to file or printed to screen.
	
	.PARAMETER logMessage
		A string containing the message PowerShell should log for example about current action being performed.
	
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
		Suppresses timestamp in log message
	
	.EXAMPLE
		Example 1: Write a log message to log file
		PS C:\> New-LogEntry -LogMessage "Test Entry"
		
		This will simply output the message "Test Entry" in the logfile
		
		Example 2: Write a log message to console only
		PS C:\> New-LogEntry -LogMessage "Test Entry" -ConsoleOnly
		
		This will print Test Entry on console
		
		Example 3: Write an error log message
		New-LogEntry -LogMessage "Test Log Error" -isErrorMessage
		
		This will prepend the [Error] tag in front of
		log message like:
		
		[06-21 03:20:57] : [Error] - Test Log Error
	
	.NOTES
		Function supports both PowerShell and PowerShell core
#>
	
	[CmdletBinding(ConfirmImpact = 'High',
				   PositionalBinding = $true,
				   SupportsShouldProcess = $true)]
	param
	(
		[Parameter(Mandatory = $true,
				   ValueFromPipeline = $true)]
		[AllowNull()]
		[Alias('Log', 'Message')]
		[string]
		$LogMessage,
		[Alias('Print', 'Echo', 'Console')]
		[switch]
		$WriteToConsole = $false,
		[AllowNull()]
		[Alias('Path', 'LogFile', 'File', 'LogPath')]
		[string]
		$LogFilePath,
		[Alias('Error', 'IsError', 'WriteError')]
		[switch]
		$IsErrorMessage = $false,
		[Alias('Warning', 'IsWarning', 'WriteWarning')]
		[switch]
		$IsWarningMessage = $false,
		[Alias('EchoOnly')]
		[switch]
		$ConsoleOnly = $false,
		[switch]
		$BufferOnly = $false,
		[switch]
		$SaveToBuffer = $false,
		[Alias('Nodate', 'NoStamp')]
		[switch]
		$NoTimeStamp = $false
	)
	
	# Use script path if no filepath is specified
	if (([string]::IsNullOrEmpty($logFilePath) -eq $true) -and
		(!($ConsoleOnly)))
	{
		$logFilePath = $PSCommandPath + '-LogFile-' + $(Get-Date -Format 'yy-MM-dd') + '.log'
	}
	
	# Don't do anything on empty Log Message
	if ([string]::IsNullOrEmpty($logMessage) -eq $true)
	{
		return
	}
	
	# Format log message
	if (($isErrorMessage) -and
		(!($ConsoleOnly)))
	{
		if ($NoTimeStamp)
		{
			$tmpMessage = "[Error] - $logMessage"
		}
		else
		{
			$tmpMessage = "[$(Get-Date -Format 'MM-dd-yy hh:mm:ss')] : [Error] - $logMessage"
		}
	}
	elseif (($IsWarningMessage -eq $true) -and
		(!($ConsoleOnly)))
	{
		if ($NoTimeStamp)
		{
			$tmpMessage = "[Warning] - $logMessage"
		}
		else
		{
			$tmpMessage = "[$(Get-Date -Format 'MM-dd-yy hh:mm:ss')] : [Warning] - $logMessage"
		}
	}
	else
	{
		if (!($ConsoleOnly))
		{
			if ($NoTimeStamp)
			{
				$tmpMessage = $logMessage
			}
			else
			{
				$tmpMessage = "[$(Get-Date -Format 'MM-dd-yy hh:mm:ss')] : $logMessage"
			}
		}
	}
	
	# Write log messages to console
	if (($ConsoleOnly) -or
		($WriteToConsole))
	{
		if ($IsErrorMessage)
		{
			Write-Error $logMessage
		}
		elseif ($IsWarningMessage)
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
	if (([string]::IsNullOrEmpty($logFilePath) -eq $false) -and
		($BufferOnly -ne $true))
	{
		$paramOutFile = @{
			InputObject = $tmpMessage
			FilePath    = $LogFilePath
			Append	    = $true
			Encoding    = 'utf8'
		}
		
		Out-File @paramOutFile
	}
	
	# Save message to buffer
	if (($BufferOnly -eq $true) -or
		($SaveToBuffer -eq $true))
	{
		$script:messageBuffer += $tmpMessage + '`r`n'
		
		# Remove blank lines
		$script:messageBuffer = $script:messageBuffer -creplace '(?m)^\s*\r?\n', ''
	}
}