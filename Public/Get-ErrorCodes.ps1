function Get-ErrorCodes {
  [CmdletBinding()][OutputType([ErrorCode[]])]
  param ()
  end {
    return [ErrorCode[]][devConstants]::data['ErrorCodes']
  }
}