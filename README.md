# New-LogEntry

New-LogEntry is a flexible logging function for PowerShell scripts aimed to make scripts troubleshooting easier.

Function supports both writing to a log file, to console only or both.

Function has support for writing/highlighting **Warning** and **Error** messages via built-in providers if writing to console or via the [Warning]/[Error] tags when writing to a log on disk.

If no log file is specified function will default to  current script path on a file named *ScriptName-LogFile-CurrentDate.log*