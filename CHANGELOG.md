# New-LogEntry - Change History

## Version 2.0.2

- Removed the *-NoTimeStamp* parameter from function

## Version 2.0.1

- Fixed typo in header section
- Updated header section with missing examples
- Added missing comment based help

## Version 2.0.0

- Function now uses [Mutex objects](https://docs.microsoft.com/en-us/windows/win32/sync/mutex-objects) to avoid situations where function was called before lock on log file was released causing exceptions to be thrown and log lines to be missed
- Code rewritten from scratch optimized for exeuction time
- Implemented the *[Info]* tag by default prepended to all log messages when not using the *-IsError* or *-IsWarning* parameters
- Optimized function to write log messages to a buffer rather than a file stream
- Implemented *-BufferOnlyInfo*, *-BufferOnlyWarning* and *BufferOnlyError* to better handle redirection of messages to buffer rather than a file
- Log messages will now be printed to console by default unless the *-NoConsole* parameter is used to allow easier troubleshooting of runtime scripts
- Updated timestamp format to use **MM/dd/yyyy hh:mm:ss tt** format to clearly indicate AM/PM time of the log
- Fixed an issue causnig function to throw an exception when log filename contained special characters like *[*

## Version 1.1.2

- Time stamp will now include year in the format MM-dd-yy

## Version 1.1.1

- Function now supports *ShouldProcess* directive
- Introduced support for passing log messages via PipeLine
- Implemented additional aliases
- Minor case style cleanup

## Version 1.1.0

- Removed unused code
- Updated Header section
- Splatted commands for better readability
- Implemented  **NoTimeStamp** parameter to suppress log timestamp
- Fixed an issue causing Write-Error not to be correctly called
- Various code optimizations

## Version 1.0.0

- Initial Release
