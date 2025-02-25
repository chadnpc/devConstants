function Get-HttpStatusCodes {
  [CmdletBinding()]
  param ()
  end {
    return [devConstants]::data['HttpStatusCodes']
  }
}