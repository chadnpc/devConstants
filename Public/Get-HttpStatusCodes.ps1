function Get-HttpStatusCodes {
  [CmdletBinding()][OutputType([Httpstatus[]])]
  param ()
  end {
    return [Httpstatus[]][devConstants]::data['HttpStatusCodes']
  }
}