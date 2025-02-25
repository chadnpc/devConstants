function Get-ErrorCodes {
  [CmdletBinding()]
  param ()
  end {
    return [devConstants]::data['ErrorCodes']
  }
}