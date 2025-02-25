function Get-ExitCodes {
  [CmdletBinding()]
  param ()
  end {
    return [devConstants]::data['ExitCodes']
  }
}