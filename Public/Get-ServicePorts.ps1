function Get-ServicePorts {
  [CmdletBinding()][OutputType([ServicePort[]])]
  param (
  )

  process {
    return [ServicePort[]][devConstants]::data['Ports']
  }
}