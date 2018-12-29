# New-LogEntry Function

New-LogEntry is a flexible yet powerful PowerShell function aimed to make scripts logging and troubleshooting an easier process. 

**New-LogEntry** supports writing to a log file on filesystem, to console only or both (also called debug mode).

Function has support for both **Warning** and **Error** tags so that messages can clearly be highlighted. Support is available for console messages as well via built-in PowerShell providers.

If no log file is specified function will default to  current script path on a file named *ScriptName-LogFile-CurrentDate.log*

## Sample Usage

Documentation of the function is available through online PowerShell help some sample usage and output are documented below.

### Write Message to log file

```powershell
# Will write message to C:\Temp\TestLog.log
New-LogEntry -LogMessage 'This is a test message' -LogFilePath  'C:\Temp\TestLog.log'
```

Content of the *TestLog.log* file will be

> [12-28-18 06:47:55] : This is a test message

### Write message to log file without time stamp

```powershell
# Will write message to C:\Temp\TestLog.log
New-LogEntry -LogMessage 'This is a test message without time stamp' -NoTimeStamp -LogFilePath  'C:\Temp\TestLog.log'
```

Content of the *TestLog.log* file will be

> This is a test message without time stamp

### Write warning message to log file

```powershell
# Will write message to C:\Temp\TestLog.log
New-LogEntry -LogMessage "This is a Warning message" -IsWarningMessage -LogFilePath  'C:\Temp\TestLog.log'
```

Content of the *TestLog.log* file will be

> [12-28-18 06:52:55] : [Warning] - This is a Warning message

### Write error message to log file

```powershell
# Will write message to C:\Temp\TestLog.log
New-LogEntry -LogMessage "This is an Error message" -IsErrorMessage -LogFilePath  'C:\Temp\TestLog.log'
```

Content of the *TestLog.log* file will be

> [12-28-18 06:53:49] : [Error] - This is an Error message

### Write message to both log and console

```powershell
# Will write message to C:\Temp\TestLog.log
New-LogEntry -LogMessage 'This is a test message' -Console -LogFilePath  'C:\Temp\TestLog.log'
```

This will write *This is a test message* to STDOUT and to the specified log file

### Write message to buffer

```powershell
# No output will be printed on screen 
New-LogEntry -LogMessage 'This message will only be in buffer' -BufferOnly
New-LogEntry -LogMessage 'This is a second message in buffer' -BufferOnly

# Print buffer content
$messageBuffer

[12-28-18 06:56:25] : This message will only be in buffer
[12-28-18 06:57:38] : This is another message in buffer
```

**Note:** When using the *BufferOnly* switch and writing content on screen everything will be printed on a single line but when piping buffer's content to a file it will be properly formatted.

### Write message to buffer and console

```powershell
New-LogEntry -LogMessage 'This is another message in buffer' -BufferOnly -Console
```

The above will print the message to stdout and save it to the buffer for later use