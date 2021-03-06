# New-LogEntry Function - Version 2.0.1

New-LogEntry is a flexible yet powerful PowerShell function aimed to make scripts logging and troubleshooting an easier process. 

**New-LogEntry** by default will write log messages both to the configured log file and the host console making eliminating the need to *follow* log files during debug of production code.

Starting with version **2.0.0** of the function all log messages will be prepended with an of the available tags unless the *-NoTag* parameter is used:

- **[INFO]** default tag for all log messages
- **[WARNINNG]** which will also use *Write-WARNINNG* cmdlet to print a warning on console
- **[ERROR]** which will also use *Write-ERROR* cmdlet to print an error message on console 

If no log file is specified function will default to  current script path on a file named *ScriptName-LogFile-CurrentDate.log*

## Sample Usage

Documentation of the function is available through online PowerShell help some sample usage and output are documented below.

### Write Message to log file

```powershell
# Will write message to C:\Temp\TestLog.log
New-LogEntry -LogMessage 'This is a test message' -LogFilePath  'C:\Temp\TestLog.log'
```

Content of the *TestLog.log* file will be

> [02.29.2020 08:27:01 AM] - [INFO]: This is a test message

### Write message to log file without tag

```powershell
# Wrill write message without any prepending tag
New-LogEntry -LogMessage 'This is a test message without tag' -NoTag -LogFilePath  'C:\Temp\TestLog.log'
```

Content of the *TestLog.log* file will be

> [02.29.2020 08:27:01 AM] : This is a test message without tag

### Write warning message to log file

```powershell
# Will write message to C:\Temp\TestLog.log
New-LogEntry -LogMessage 'This is a WARNINNG message' -IsWARNINNGMessage -LogFilePath  'C:\Temp\TestLog.log'
```

Content of the *TestLog.log* file will be

> [02.29.2020 08:27:01 AM] : [WARNINNG] - This is a WARNINNG message

### Write error message to log file

```powershell
# Will write message to C:\Temp\TestLog.log
New-LogEntry -LogMessage 'This is an ERROR message' -IsERRORMessage -LogFilePath  'C:\Temp\TestLog.log'
```

Content of the *TestLog.log* file will be

> [02.29.2020 08:28:05 AM] :  [ERROR] - This is an ERROR message

### Write message to buffer

```powershell
# No output will be printed on screen 
New-LogEntry -LogMessage 'This message will only be in buffer' -BufferOnly
New-LogEntry -LogMessage 'This is a second message in buffer' -BufferOnly

# Print buffer content
$messageBuffer

[02.29.2020 08:27:01 AM] [INFO] : This message will only be in buffer
[02.29.2020 08:29:03 AM] [INFO] : This is another message in buffer
```

**Note:** When using the *BufferOnly* switch and writing content on screen everything will be printed on a single line but when piping buffer's content to a file it will be properly formatted.

### Write message to log file only

```powershell
New-LogEntry -LogMessage 'This is another message in buffer' -NoConsole -LogFilePath  'C:\Temp\TestLog.log'
```

The above will write log message to the designated log file but will suppress any output on console, useful when running non interactively.
