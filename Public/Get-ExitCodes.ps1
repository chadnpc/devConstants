function Get-ExitCodes {
  [CmdletBinding()][OutputType([ExitCode[]])]
  param ()
  end {
    return [ExitCode[]][devConstants]::data['ExitCodes']
  }
}