﻿
#!/usr/bin/env pwsh
#region    Classes
enum CimWin32ServiceState {
  Stopped = 1
  StartPending = 2
  StopPending = 3
  Running = 4
  ContinuePending = 5
  PausePending = 6
  Paused = 7
}

enum WbemErrorCode {
  wbemNoErr = 0
  wbemErrFailed = 0x80041001
  wbemErrNotFound = 0x80041002
  wbemErrAccessDenied = 0x80041003
  wbemErrProviderFailure = 0x80041004
  wbemErrTypeMismatch = 0x80041005
  wbemErrOutOfMemory = 0x80041006
  wbemErrInvalidContext = 0x80041007
  wbemErrInvalidParameter = 0x80041008
  wbemErrNotAvailable = 0x80041009
  wbemErrCriticalError = 0x8004100a
  wbemErrInvalidStream = 0x8004100b
  wbemErrNotSupported = 0x8004100c
  wbemErrInvalidSuperclass = 0x8004100d
  wbemErrInvalidNamespace = 0x8004100e
  wbemErrInvalidObject = 0x8004100f
  wbemErrInvalidClass = 0x80041010
  wbemErrProviderNotFound = 0x80041011
  wbemErrInvalidProviderRegistration = 0x80041012
  wbemErrProviderLoadFailure = 0x80041013
  wbemErrInitializationFailure = 0x80041014
  wbemErrTransportFailure = 0x80041015
  wbemErrInvalidOperation = 0x80041016
  wbemErrInvalidQuery = 0x80041017
  wbemErrInvalidQueryType = 0x80041018
  wbemErrAlreadyExists = 0x80041019
  wbemErrOverrideNotAllowed = 0x8004101a
  wbemErrPropagatedQualifier = 0x8004101b
  wbemErrPropagatedProperty = 0x8004101c
  wbemErrUnexpected = 0x8004101d
  wbemErrIllegalOperation = 0x8004101e
  wbemErrCannotBeKey = 0x8004101f
  wbemErrIncompleteClass = 0x80041020
  wbemErrInvalidSyntax = 0x80041021
  wbemErrNondecoratedObject = 0x80041022
  wbemErrReadOnly = 0x80041023
  wbemErrProviderNotCapable = 0x80041024
  wbemErrClassHasChildren = 0x80041025
  wbemErrClassHasInstances = 0x80041026
  wbemErrQueryNotImplemented = 0x80041027
  wbemErrIllegalNull = 0x80041028
  wbemErrInvalidQualifierType = 0x80041029
  wbemErrInvalidPropertyType = 0x8004102a
  wbemErrValueOutOfRange = 0x8004102b
  wbemErrCannotBeSingleton = 0x8004102c
  wbemErrInvalidCimType = 0x8004102d
  wbemErrInvalidMethod = 0x8004102e
  wbemErrInvalidMethodParameters = 0x8004102f
  wbemErrSystemProperty = 0x80041030
  wbemErrInvalidProperty = 0x80041031
  wbemErrCallCancelled = 0x80041032
  wbemErrShuttingDown = 0x80041033
  wbemErrPropagatedMethod = 0x80041034
  wbemErrUnsupportedParameter = 0x80041035
  wbemErrMissingParameter = 0x80041036
  wbemErrInvalidParameterId = 0x80041037
  wbemErrNonConsecutiveParameterIds = 0x80041038
  wbemErrParameterIdOnRetval = 0x80041039
  wbemErrInvalidObjectPath = 0x8004103a
  wbemErrOutOfDiskSpace = 0x8004103b
  wbemErrBufferTooSmall = 0x8004103c
  wbemErrUnsupportedPutExtension = 0x8004103d
  wbemErrUnknownObjectType = 0x8004103e
  wbemErrUnknownPacketType = 0x8004103f
  wbemErrMarshalVersionMismatch = 0x80041040
  wbemErrMarshalInvalidSignature = 0x80041041
  wbemErrInvalidQualifier = 0x80041042
  wbemErrInvalidDuplicateParameter = 0x80041043
  wbemErrTooMuchData = 0x80041044
  wbemErrServerTooBusy = 0x80041045
  wbemErrInvalidFlavor = 0x80041046
  wbemErrCircularReference = 0x80041047
  wbemErrUnsupportedClassUpdate = 0x80041048
  wbemErrCannotChangeKeyInheritance = 0x80041049
  wbemErrCannotChangeIndexInheritance = 0x80041050
  wbemErrTooManyProperties = 0x80041051
  wbemErrUpdateTypeMismatch = 0x80041052
  wbemErrUpdateOverrideNotAllowed = 0x80041053
  wbemErrUpdatePropagatedMethod = 0x80041054
  wbemErrMethodNotImplemented = 0x80041055
  wbemErrMethodDisabled = 0x80041056
  wbemErrRefresherBusy = 0x80041057
  wbemErrUnparsableQuery = 0x80041058
  wbemErrNotEventClass = 0x80041059
  wbemErrMissingGroupWithin = 0x8004105a
  wbemErrMissingAggregationList = 0x8004105b
  wbemErrPropertyNotAnObject = 0x8004105c
  wbemErrAggregatingByObject = 0x8004105d
  wbemErrUninterpretableProviderQuery = 0x8004105f
  wbemErrBackupRestoreWinmgmtRunning = 0x80041060
  wbemErrQueueOverflow = 0x80041061
  wbemErrPrivilegeNotHeld = 0x80041062
  wbemErrInvalidOperator = 0x80041063
  wbemErrLocalCredentials = 0x80041064
  wbemErrCannotBeAbstract = 0x80041065
  wbemErrAmendedObject = 0x80041066
  wbemErrClientTooSlow = 0x80041067
  wbemErrNullSecurityDescriptor = 0x80041068
  wbemErrTimeout = 0x80041069
  wbemErrInvalidAssociation = 0x8004106a
  wbemErrAmbiguousOperation = 0x8004106b
  wbemErrQuotaViolation = 0x8004106c
  wbemErrTransactionConflict = 0x8004106d
  wbemErrForcedRollback = 0x8004106e
  wbemErrUnsupportedLocale = 0x8004106f
  wbemErrHandleOutOfDate = 0x80041070
  wbemErrConnectionFailed = 0x80041071
  wbemErrInvalidHandleRequest = 0x80041072
  wbemErrPropertyNameTooWide = 0x80041073
  wbemErrClassNameTooWide = 0x80041074
  wbemErrMethodNameTooWide = 0x80041075
  wbemErrQualifierNameTooWide = 0x80041076
  wbemErrRerunCommand = 0x80041077
  wbemErrDatabaseVerMismatch = 0x80041078
  wbemErrVetoPut = 0x80041079
  wbemErrVetoDelete = 0x8004107a
  wbemErrInvalidLocale = 0x80041080
  wbemErrProviderSuspended = 0x80041081
  wbemErrSynchronizationRequired = 0x80041082
  wbemErrNoSchema = 0x80041083
  wbemErrProviderAlreadyRegistered = 0x80041084
  wbemErrProviderNotRegistered = 0x80041085
  wbemErrFatalTransportError = 0x80041086
  wbemErrEncryptedConnectionRequired = 0x80041087
  wbemErrRegistrationTooBroad = 0x80042001
  wbemErrRegistrationTooPrecise = 0x80042002
  wbemErrTimedout = 0x80043001
  wbemErrResetToDefault = 0x80043002
}
class devConstants {
  static [hashtable]$data = (Get-ModuleData)
  devConstants() {}
}
#endregion Classes
# Types that will be available to users when they import the module.
$typestoExport = @(
  [devConstants], [CimWin32ServiceState], [WbemErrorCode]
)
$TypeAcceleratorsClass = [PsObject].Assembly.GetType('System.Management.Automation.TypeAccelerators')
foreach ($Type in $typestoExport) {
  if ($Type.FullName -in $TypeAcceleratorsClass::Get.Keys) {
    $Message = @(
      "Unable to register type accelerator '$($Type.FullName)'"
      'Accelerator already exists.'
    ) -join ' - '

    [System.Management.Automation.ErrorRecord]::new(
      [System.InvalidOperationException]::new($Message),
      'TypeAcceleratorAlreadyExists',
      [System.Management.Automation.ErrorCategory]::InvalidOperation,
      $Type.FullName
    ) | Write-Warning
  }
}
# Add type accelerators for every exportable type.
foreach ($Type in $typestoExport) {
  $TypeAcceleratorsClass::Add($Type.FullName, $Type)
}
# Remove type accelerators when the module is removed.
$MyInvocation.MyCommand.ScriptBlock.Module.OnRemove = {
  foreach ($Type in $typestoExport) {
    $TypeAcceleratorsClass::Remove($Type.FullName)
  }
}.GetNewClosure();

$scripts = @();
$Public = Get-ChildItem "$PSScriptRoot/Public" -Filter "*.ps1" -Recurse -ErrorAction SilentlyContinue
$scripts += Get-ChildItem "$PSScriptRoot/Private" -Filter "*.ps1" -Recurse -ErrorAction SilentlyContinue
$scripts += $Public

foreach ($file in $scripts) {
  Try {
    if ([string]::IsNullOrWhiteSpace($file.fullname)) { continue }
    . "$($file.fullname)"
  } Catch {
    Write-Warning "Failed to import function $($file.BaseName): $_"
    $host.UI.WriteErrorLine($_)
  }
}

$Param = @{
  Function = $Public.BaseName
  Cmdlet   = '*'
  Alias    = '*'
  Verbose  = $false
}
Export-ModuleMember @Param
