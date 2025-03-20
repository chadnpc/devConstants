#!/usr/bin/env pwsh
using namespace System.Linq

#region    Classes

enum HttpRequestMethod {
  GET = 0
  POST = 1
  PATCH = 2
  PUT = 3
  DELETE = 4
  HEAD = 5
  TRACE = 6
  CONNECT = 7
  OPTIONS = 8
} # Read more details @ https://restful-api.dev/rest-fundamentals#rest

enum CimWin32ServiceState {
  Stopped = 1
  StartPending = 2
  StopPending = 3
  Running = 4
  ContinuePending = 5
  PausePending = 6
  Paused = 7
}

enum HttpstatusType {
  Success = 0
  Informational = 1
  Redirection = 2
  ClientError = 3
  ServerError = 4
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

enum Country {
  Afghanistan = 93
  Albania = 355
  Algeria = 213
  AmericanSamoa = 1684
  Andorra = 376
  Angola = 244
  Anguilla = 1264
  Antarctica = 672
  AntiguaAndBarbuda = 1268
  Argentina = 54
  Armenia = 374
  Aruba = 297
  Australia = 61
  Austria = 43
  Azerbaijan = 994
  Bahamas = 1242
  Bahrain = 973
  Bangladesh = 880
  Barbados = 1246
  Belarus = 375
  Belgium = 32
  Belize = 501
  Benin = 229
  Bermuda = 1441
  Bhutan = 975
  Bolivia = 591
  BosniaAndHerzegovina = 387
  Botswana = 267
  Brazil = 55
  BritishIndianOceanTerritory = 246
  BritishVirginIslands = 1284
  Brunei = 673
  Bulgaria = 359
  BurkinaFaso = 226
  Burundi = 257
  CaboVerde = 238
  Cambodia = 855
  Cameroon = 237
  Canada = 1
  CaymanIslands = 1345
  CentralAfricanRepublic = 236
  Chad = 235
  Chile = 56
  China = 86
  ChristmasIsland = 61
  CocosIslands = 61
  Colombia = 57
  Comoros = 269
  Congo = 242
  CookIslands = 682
  CostaRica = 506
  Croatia = 385
  Cuba = 53
  Curacao = 599
  Cyprus = 357
  CzechRepublic = 420
  CoteDIvoire = 225
  Denmark = 45
  Djibouti = 253
  Dominica = 1767
  DominicanRepublic = 1809
  DR_Congo = 243
  Ecuador = 593
  Egypt = 20
  ElSalvador = 503
  EquatorialGuinea = 240
  Eritrea = 291
  Estonia = 372
  Eswatini = 268
  Ethiopia = 251
  Fiji = 679
  Finland = 358
  France = 33
  Gabon = 241
  Gambia = 220
  Georgia = 995
  Germany = 49
  Ghana = 233
  Greece = 30
  Greenland = 299
  Grenada = 1473
  Guatemala = 502
  Guinea = 224
  GuineaBissau = 245
  Guyana = 592
  Haiti = 509
  Honduras = 504
  HongKong = 852
  Hungary = 36
  Iceland = 354
  India = 91
  Indonesia = 62
  Iran = 98
  Iraq = 964
  Ireland = 353
  Israel = 972
  Italy = 39
  Jamaica = 1876
  Japan = 81
  Jordan = 962
  Kazakhstan = 7
  Kenya = 254
  Kiribati = 686
  Kuwait = 965
  Kyrgyzstan = 996
  Laos = 856
  Latvia = 371
  Lebanon = 961
  Lesotho = 266
  Liberia = 231
  Libya = 218
  Liechtenstein = 423
  Lithuania = 370
  Luxembourg = 352
  Macao = 853
  Madagascar = 261
  Malawi = 265
  Malaysia = 60
  Maldives = 960
  Mali = 223
  Malta = 356
  MarshallIslands = 692
  Mauritania = 222
  Mauritius = 230
  Mexico = 52
  Moldova = 373
  Monaco = 377
  Mongolia = 976
  Montenegro = 382
  Morocco = 212
  Mozambique = 258
  Myanmar = 95
  Namibia = 264
  Nepal = 977
  Netherlands = 31
  NewZealand = 64
  Nicaragua = 505
  Niger = 227
  Nigeria = 234
  NorthKorea = 850
  NorthMacedonia = 389
  Norway = 47
  Oman = 968
  Pakistan = 92
  Palau = 680
  Panama = 507
  PapuaNewGuinea = 675
  Paraguay = 595
  Peru = 51
  Philippines = 63
  Poland = 48
  Portugal = 351
  Qatar = 974
  Romania = 40
  Russia = 7
  Rwanda = 250
  SaudiArabia = 966
  Senegal = 221
  Serbia = 381
  Seychelles = 248
  Singapore = 65
  Slovakia = 421
  Slovenia = 386
  SouthAfrica = 27
  SouthKorea = 82
  SouthSudan = 211
  Spain = 34
  SriLanka = 94
  Sudan = 249
  Suriname = 597
  Sweden = 46
  Switzerland = 41
  Syria = 963
  Taiwan = 886
  Tajikistan = 992
  Tanzania = 255
  Thailand = 66
  Togo = 228
  Tonga = 676
  TrinidadAndTobago = 1868
  Tunisia = 216
  Turkey = 90
  Turkmenistan = 993
  Tuvalu = 688
  Uganda = 256
  Ukraine = 380
  UnitedArabEmirates = 971
  UnitedKingdom = 44
  UnitedStates = 1
  Uruguay = 598
  Uzbekistan = 998
  Vanuatu = 678
  Venezuela = 58
  Vietnam = 84
  Yemen = 967
  Zambia = 260
  Zimbabwe = 263
}

class ExitCode {
  [ValidateNotNull()][int] $Value
  [ValidateNotNullOrWhiteSpace()][string] $HexValue
  [ValidateNotNullOrWhiteSpace()][string] $ErrorString
  [ValidateNotNullOrWhiteSpace()][string] $Description

  ExitCode([PSCustomObject]$object) {
    [Enumerable]::ToArray($object.PsObject.Properties).ForEach({ $n = $_.Name.replace(' ', ''); if ($n -and $_.value) { $this.$n = $_.value } })
  }
}

class ErrorCode : ExitCode {
  ErrorCode([PSCustomObject]$object) : base($object) {}
}

class Httpstatus {
  [ValidateNotNullOrWhiteSpace()][string]$Name
  [ValidateNotNull()][int]$Value
  [ValidateNotNull()][HttpstatusType]$Type
  [ValidateNotNullOrWhiteSpace()][string]$Description
  hidden [ValidateNotNull()][System.Net.HttpStatusCode]$Code
  Httpstatus([PSCustomObject]$object) {
    [Enumerable]::ToArray($object.PsObject.Properties).ForEach({ $n = $_.Name.replace(' ', ''); if ($n -and $_.value) { $this.$n = $_.value } })
    $c = [System.Net.HttpStatusCode]::($this.Name); $c ? ($this.Code = $c) : $null
  }
}

class CountryCode {
  [ValidateNotNull()][int] $Value
  static [hashtable]$ISO3166Alpha2 = @{
    AF = "Afghanistan"
    AL = "Albania"
    DZ = "Algeria"
    AS = "American Samoa"
    AD = "Andorra"
    AO = "Angola"
    AI = "Anguilla"
    AQ = "Antarctica"
    AG = "Antigua and Barbuda"
    AR = "Argentina"
    AM = "Armenia"
    AW = "Aruba"
    AU = "Australia"
    AT = "Austria"
    AZ = "Azerbaijan"
    BS = "Bahamas"
    BH = "Bahrain"
    BD = "Bangladesh"
    BB = "Barbados"
    BY = "Belarus"
    BE = "Belgium"
    BZ = "Belize"
    BJ = "Benin"
    BM = "Bermuda"
    BT = "Bhutan"
    BO = "Bolivia"
    BA = "Bosnia and Herzegovina"
    BW = "Botswana"
    BR = "Brazil"
    IO = "British Indian Ocean Territory"
    VG = "British Virgin Islands"
    BN = "Brunei"
    BG = "Bulgaria"
    BF = "Burkina Faso"
    BI = "Burundi"
    CV = "Cabo Verde"
    KH = "Cambodia"
    CM = "Cameroon"
    CA = "Canada"
    CF = "Central African Republic"
    TD = "Chad"
    CL = "Chile"
    CN = "China"
    CO = "Colombia"
    CR = "Costa Rica"
    HR = "Croatia"
    CU = "Cuba"
    CY = "Cyprus"
    CZ = "Czech Republic"
    DK = "Denmark"
    DJ = "Djibouti"
  }
  CountryCode([string]$str) {
    $n = $str.Length -eq 2 ? [CountryCode]::GetName($str) : [CountryCode]::FindISO3166Alpha2Code($str).Value
    $this.value = [Country]::$n.value__
  }
  static [psobject[]] FindISO3166Alpha2Code([string]$CountryName) {
    return [CountryCode]::ISO3166Alpha2.GetEnumerator().Where({ $_.Value -eq $CountryName })
  }
  static [string] GetName([string]$2LetterISO3166Alpha2Code) {
    return [CountryCode]::ISO3166Alpha2[$2LetterISO3166Alpha2Code]
  }
  [string] ToString() {
    return $this.value
  }
}

class CurrencyCode {
  [ValidateNotNullOrWhiteSpace()][String]$description;
  CurrencyCode([string]$Culture) {
    $regionInfo = [System.Globalization.RegionInfo]::new($Culture)
    $this.description = [CurrencyCode]::GetDescription($regionInfo.ThreeLetterISORegionName)
  }
  static [String] GetDescription([string]$ThreeLetterISORegionName) {
    [ValidateNotNullOrWhiteSpace()][string]$ThreeLetterISORegionName = $ThreeLetterISORegionName
    $desc = @{
      AED = "United Arab Emirates Dirham"
      AFN = "Afghanistan Afghani"
      ALL = "Albania Lek"
      AMD = "Armenia Dram"
      ANG = "Netherlands Antilles Guilder"
      AOA = "Angola Kwanza"
      ARS = "Argentina Peso"
      AUD = "Australia Dollar"
      AWG = "Aruba Guilder"
      AZN = "Azerbaijan New Manat"
      BAM = "Bosnia and Herzegovina Convertible Marka"
      BBD = "Barbados Dollar"
      BDT = "Bangladesh Taka"
      BGN = "Bulgaria Lev"
      BHD = "Bahrain Dinar"
      BIF = "Burundi Franc"
      BMD = "Bermuda Dollar"
      BND = "Brunei Darussalam Dollar"
      BOB = "Bolivia Bolíviano"
      BRL = "Brazil Real"
      BSD = "Bahamas Dollar"
      BTN = "Bhutan Ngultrum"
      BWP = "Botswana Pula"
      BYR = "Belarus Ruble"
      BZD = "Belize Dollar"
      CAD = "Canada Dollar"
      CDF = "Congo/Kinshasa Franc"
      CHF = "Switzerland Franc"
      CLP = "Chile Peso"
      CNY = "China Yuan Renminbi"
      COP = "Colombia Peso"
      CRC = "Costa Rica Colon"
      CUC = "Cuba Convertible Peso"
      CUP = "Cuba Peso"
      CVE = "Cape Verde Escudo"
      CZK = "Czech Republic Koruna"
      DJF = "Djibouti Franc"
      DKK = "Denmark Krone"
      DOP = "Dominican Republic Peso"
      DZD = "Algeria Dinar"
      EGP = "Egypt Pound"
      ERN = "Eritrea Nakfa"
      ETB = "Ethiopia Birr"
      EUR = "Euro Member Countries"
      FJD = "Fiji Dollar"
      FKP = "Falkland Islands (Malvinas) Pound"
      GBP = "United Kingdom Pound"
      GEL = "Georgia Lari"
      GGP = "Guernsey Pound"
      GHS = "Ghana Cedi"
      GIP = "Gibraltar Pound"
      GMD = "Gambia Dalasi"
      GNF = "Guinea Franc"
      GTQ = "Guatemala Quetzal"
      GYD = "Guyana Dollar"
      HKD = "Hong Kong Dollar"
      HNL = "Honduras Lempira"
      HRK = "Croatia Kuna"
      HTG = "Haiti Gourde"
      HUF = "Hungary Forint"
      IDR = "Indonesia Rupiah"
      ILS = "Israel Shekel"
      IMP = "Isle of Man Pound"
      INR = "India Rupee"
      IQD = "Iraq Dinar"
      IRR = "Iran Rial"
      ISK = "Iceland Krona"
      JEP = "Jersey Pound"
      JMD = "Jamaica Dollar"
      JOD = "Jordan Dinar"
      JPY = "Japan Yen"
      KES = "Kenya Shilling"
      KGS = "Kyrgyzstan Som"
      KHR = "Cambodia Riel"
      KMF = "Comoros Franc"
      KPW = "Korea (North) Won"
      KRW = "Korea (South) Won"
      KWD = "Kuwait Dinar"
      KYD = "Cayman Islands Dollar"
      KZT = "Kazakhstan Tenge"
      LAK = "Laos Kip"
      LBP = "Lebanon Pound"
      LKR = "Sri Lanka Rupee"
      LRD = "Liberia Dollar"
      LSL = "Lesotho Loti"
      LYD = "Libya Dinar"
      MAD = "Morocco Dirham"
      MDL = "Moldova Leu"
      MGA = "Madagascar Ariary"
      MKD = "Macedonia Denar"
      MMK = "Myanmar (Burma) Kyat"
      MNT = "Mongolia Tughrik"
      MOP = "Macau Pataca"
      MRO = "Mauritania Ouguiya"
      MUR = "Mauritius Rupee"
      MVR = "Maldives (Maldive Islands) Rufiyaa"
      MWK = "Malawi Kwacha"
      MXN = "Mexico Peso"
      MYR = "Malaysia Ringgit"
      MZN = "Mozambique Metical"
      NAD = "Namibia Dollar"
      NGN = "Nigeria Naira"
      NIO = "Nicaragua Cordoba"
      NOK = "Norway Krone"
      NPR = "Nepal Rupee"
      NZD = "New Zealand Dollar"
      OMR = "Oman Rial"
      PAB = "Panama Balboa"
      PEN = "Peru Sol"
      PGK = "Papua New Guinea Kina"
      PHP = "Philippines Peso"
      PKR = "Pakistan Rupee"
      PLN = "Poland Zloty"
      PYG = "Paraguay Guarani"
      QAR = "Qatar Riyal"
      RON = "Romania New Leu"
      RSD = "Serbia Dinar"
      RUB = "Russia Ruble"
      RWF = "Rwanda Franc"
      SAR = "Saudi Arabia Riyal"
      SBD = "Solomon Islands Dollar"
      SCR = "Seychelles Rupee"
      SDG = "Sudan Pound"
      SEK = "Sweden Krona"
      SGD = "Singapore Dollar"
      SHP = "Saint Helena Pound"
      SLL = "Sierra Leone Leone"
      SOS = "Somalia Shilling"
      SPL = "Seborga Luigino"
      SRD = "Suriname Dollar"
      STD = "São Tomé and Príncipe Dobra"
      SVC = "El Salvador Colon"
      SYP = "Syria Pound"
      SZL = "Swaziland Lilangeni"
      THB = "Thailand Baht"
      TJS = "Tajikistan Somoni"
      TMT = "Turkmenistan Manat"
      TND = "Tunisia Dinar"
      TOP = "Tonga Pa'anga"
      TRY = "Turkey Lira"
      TTD = "Trinidad and Tobago Dollar"
      TVD = "Tuvalu Dollar"
      TWD = "Taiwan New Dollar"
      TZS = "Tanzania Shilling"
      UAH = "Ukraine Hryvnia"
      UGX = "Uganda Shilling"
      USD = "United States Dollar"
      UYU = "Uruguay Peso"
      UZS = "Uzbekistan Som"
      VEF = "Venezuela Bolivar"
      VND = "Viet Nam Dong"
      VUV = "Vanuatu Vatu"
      WST = "Samoa Tala"
      XAF = "Communauté Financière Africaine (BEAC) CFA Franc BEAC"
      XCD = "East Caribbean Dollar"
      XDR = "International Monetary Fund (IMF) Special Drawing Rights"
      XOF = "Communauté Financière Africaine (BCEAO) Franc"
      XPF = "Comptoirs Français du Pacifique (CFP) Franc"
      YER = "Yemen Rial"
      ZAR = "South Africa Rand"
      ZMW = "Zambia Kwacha"
      ZWD = "Zimbabwe Dollar"
    }
    return $desc[$ThreeLetterISORegionName]
  }
}

class ServicePort {
  [string]$Service
  [string]$Protocol
  [string]$Description
  hidden [ValidateNotNull()][string]$value
  ServicePort([PSCustomObject]$object) {
    [Enumerable]::ToArray($object.PsObject.Properties).ForEach({ $n = $_.Name.replace(' ', ''); if ($n -and $_.value) { $this.$n = $_.value } })
  }
  [string] ToString() {
    return $this.value
  }
}
class devConstants {
  static [hashtable]$data = (Get-ModuleData)
  devConstants() {}
}
#endregion Classes
# Types that will be available to users when they import the module.
$typestoExport = @(
  [devConstants], [ExitCode], [ErrorCode], [Httpstatus], [ServicePort], [CimWin32ServiceState], [CurrencyCode], [CountryCode], [Country], [WbemErrorCode]
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
