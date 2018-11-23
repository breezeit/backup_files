; Eject any drive  ------------ Thalon
; http://www.autohotkey.com/forum/topic8923.html
; Eject Removable Hardware -------------- Vspider
; http://www.autohotkey.com/forum/topic54164.html
; Crazy Scripting : Safely Remove USB Flash Drive ------- skan
; http://www.autohotkey.com/forum/topic44873.html
; 2000�µ���U����Ч XP�µ������̷�ͼ�껹�ڣ�����������ʾ
; https://autohotkey.com/boards/viewtopic.php?t=4491

����U��:
Devs =  `r`n
DevF = 0
Gosub, DeviceList
If (Devs = "`r`n") {
Traytip, ����, �Ҳ������ƶ�Ӳ��, 10
return
}
Traytip, ������ƶ������̷����Ե�������, %Devs%, 10
SetCapsLockState, On
Input, Driveletter, L1
SetCapsLockState, Off
Traytip

DriveGet, RDRV, List, REMOVABLE
 StringReplace, RDRV, RDRV, A
 StringReplace, RDRV, RDRV, B
 Loop, Parse, RDRV
  { If (Driveletter = A_LoopField)
  DevF = 1
  }
If (DevF = 0){
Traytip, Error, �Ҳ�����������̷��Ŀ��ƶ�Ӳ��, 10
return
}

if ejecttype=1
{
Driveletter = %Driveletter%:
DrivePath = \\.\%Driveletter%
DriveGet, Label, Label, %Driveletter%

hVolume := DllCall("CreateFile"
      , str, DrivePath
      , UInt, 0x80000000 | 0x40000000   ;GENERIC_READ | GENERIC_WRITE
      , UInt, 0x0      ;Tries to get exclusiv rights to the drive +++(see below)
      , UInt, Null
      , UInt, 0x3         ;OPEN_EXISTING
      , UInt, 0x0
      , UInt, NULL)

if A_LastError = 32         ;Another application has read or write-access to the drive (In this case no handle was retreived to release)
{
   hVolume := DllCall("CreateFile"         ;Get handle even if another application reads the drive
      , str, DrivePath
      , UInt, 0x80000000 | 0x40000000   ;GENERIC_READ | GENERIC_WRITE
      , UInt, 0x1       ;FILE_SHARE_READ
      , UInt, Null
      , UInt, 0x3         ;OPEN_EXISTING
      , UInt, 0x0
      , UInt, NULL)

   if hVolume != -1
   {
      msgbox, 4164, ����, ��һ��Ӧ�ó������ڶ�ȡ���豸.`nȷ�ϼ�������?
      IfMsgbox, No
      {
         DllCall("CloseHandle", UInt, hVolume)   ;Release handle here
         return
      }
   }

   if A_LastError = 32      ;No read access was possible also
   {
      msgbox, 4164, ����!, ��һ��Ӧ�ó�������д����豸!`nȷ�ϼ�������?
      IfMsgbox, No
         return
      else
      {
         hVolume := DllCall("CreateFile"         ;Get handle even if another application reads or writes to the drive
            , str, DrivePath
            , UInt, 0x80000000 | 0x40000000   ;GENERIC_READ | GENERIC_WRITE
            , UInt, 0x1 | 0x2 ;FILE_SHARE_READ | FILE_SHARE_WRITE
            , UInt, Null
            , UInt, 0x3         ;OPEN_EXISTING
            , UInt, 0x0
            , UInt, NULL)
      }
   }
}

if hVolume != -1      ;Drive is thrown out
{
      DllCall("DeviceIoControl"
      , UInt, hVolume
      , UInt, 0x2D4808   ;IOCTL_STORAGE_EJECT_MEDIA
      , UInt, NULL
      , UInt, 0
      , UInt, NULL
      , UInt, 0
      , UInt, &dwBytesReturned   ;Not used
      , UInt,  NULL)

   DllCall("CloseHandle", UInt, hVolume)
   TrayTip, ��ȫɾ��Ӳ��, %Driveletter% %Label% ���ڿ��԰�ȫ�شӼ������ɾ��., 2, 1
}
}
else if ejecttype=2
{
Driveletter = %Driveletter%:
USBD_SafelyRemove( Driveletter )
}
else
Eject(Driveletter) 
return

;^Q::
�����б�:
Menu, USB, Add, ȫ������,nul
Menu, USB, disable,ȫ������
Menu, USB, Add
DriveGet, RDRV, List
StringReplace, RDRV, RDRV, A
StringReplace, RDRV, RDRV, B
 Loop, Parse, RDRV
  {
   DriveGet, Label, Label, %A_LoopField%:
   DriveGet, Size, Capacity, %A_LoopField%:
   Capacity := DriveSpace( A_LoopField,1 )
   VarSetCapacity( DiskFreeSz,16,0 )
   DllCall( "shlwapi.dll\" (A_IsUnicode?"StrFormatByteSizeW":"StrFormatByteSize64A"), Int64,Capacity, Str,DiskFreeSz, UInt,16 )

   Capacity2 := DriveSpace( A_LoopField,2 )
   VarSetCapacity( DiskSz,16,0 )
   DllCall( "shlwapi.dll\" (A_IsUnicode?"StrFormatByteSizeW":"StrFormatByteSize64A"), Int64,Capacity2, Str,DiskSz, UInt,16 )

   If (size != "")
   Menu, USB, Add, &%A_LoopField%: %Label%`t%DiskFreeSz% - %DiskSz%,opRem
  }
 Menu, USB, Show
 Menu, USB, DeleteAll
Return

DeviceList:
 DriveGet, RDRV, List, REMOVABLE
 StringReplace, RDRV, RDRV, A
 StringReplace, RDRV, RDRV, B
 Loop, Parse, RDRV
  {
   DriveGet, Label, Label, %A_LoopField%:
   DriveGet, Size, Capacity, %A_LoopField%:
   Capacity := DriveSpace( A_LoopField,2 ), VarSetCapacity( DiskSz,16,0 )
   DllCall( "shlwapi.dll\" (A_IsUnicode?"StrFormatByteSizeW":"StrFormatByteSize64A"), Int64,Capacity, Str,DiskSz, UInt,16 )
   If (Label = "") {
   Label = NO LABEL
   }
   Devs = %Devs% %A_LoopField%: %Label%`t`t%DiskSz% `r`n
  }
Return

DriveSpace(Drv="", Free=1)
{ ; www.autohotkey.com/forum/viewtopic.php?p=92483#92483
 Drv := Drv . ":\"
 VarSetCapacity(SPC, 30, 0)   ; Sectors Per Cluster
 VarSetCapacity(BPS, 30, 0)   ; Bytes Per Sector
 VarSetCapacity(FC , 30, 0)   ; Free Clusters
 VarSetCapacity(TC , 30, 0)   ; Total Clusters
 DllCall( "GetDiskFreeSpace", Str,Drv, UIntP,SPC, UIntP,BPS, UIntP,FC, UIntP,TC )
;msgbox % SPC "*" BPS "*" FC "*" SPC*BPS*FC
Return Free=1 ? (SPC*BPS*FC) : (SPC*BPS*TC) ; Ternary Operator requires 1.0.46+
}

WM_DEVICECHANGE(wParam, lParam)
{
   If (wParam=0x8000 || wParam=0x8004) ;DBT_DEVICEARRIVAL, DBT_DEVICEREMOVECOMPLETE
      {
          devicetype:=NumGet(lParam+0, 4) ;DEV_BROADCAST_HDR.dbcv_devicetype
          if (devicetype=2) ;2 = DBT_DEVTYP_VOLUME
              {
                   unitmask:=NumGet(lParam+0, 12) ;DEV_BROADCAST_VOLUME .dbcv_unitmask
                   NewDrive:=
                   NewDriveList:=
                   Loop, 26 ;�����豸���̷���
                      {
                          NewDrive:=unitmask & 1
                          if NewDrive
                              {
                                  NewDriveName:=Chr(0x40 + A_Index)
                                  If (wParam = 0x8000)
                                      {
                                          Loop,6
                                             {
                                                 Sleep 500
                                                 DriveGet,DriveState,Status,%NewDriveName%:
                                                 If (DriveState = "Ready")
                                                      {
                                                          DriveGet,DriveLabel,Label,%NewDriveName%:
                                                          DriveGet,DriveType,Type,%NewDriveName%:
                                                          DriveGet,DriveCap,Capacity,%NewDriveName%:
                                                          Break
                                                      }
                                             }
                                          ;If (DriveLabel = "SYS" OR DriveCap = "")
                                          ;CanOpen := 0
                                          ;Else
                                          ;CanOpen := 1
                                          If (DriveType="CDROM")
                                          If (DriveCap>1000)
                                          DriveType:="DVD����"
                                          Else
                                          DriveType:="CD����"
                                          If (DriveType="Removable")
                                          DriveType:="���ƶ��洢��"
                                          If (DriveType="Unknown")
                                          DriveType:="δ֪"
                                      }
                                  NewDriveList:=NewDriveList . "`n"DriveLabel . " (" . DriveType . " " . NewDriveName . ":)"
                              }
                          unitmask >>= 1
                      }

                   if wParam=0x8000 ;�����������趨ִ�в���
                      {
                          TrayTip,Notices,����ý���Ѳ���!%NewDriveList%,,1
                          SetTimer,tipoff,3000
                      }
                  Else
                      {
                          TrayTip,Safe To Remove Hardware,����ý���ѵ���!%NewDriveList%,,1
                          SetTimer,tipoff,3000
                      }
              }
      }
}
Return

tipoff:
TrayTip,
Return

opRem:
StringMid,rempath,A_thismenuitem,2,2
run,%rempath%
Return

USBD_SafelyRemove( Drv ) {
 If ! ( Serial := USBD_GetDeviceSerial( Drv ) )
   Return
 DeviceID := USBD_GetDeviceID( Serial )
 DeviceEject( DeviceID )
 IfExist, %Drv%\, TrayTip, %DeviceID%, Drive %Drv% was not Ejected!, 10, 3
 Else, TrayTip, %DeviceID%, Drive %Drv% was safely Removed, 10, 1
}

USBD_GetDeviceSerial( Drv="" ) {
 DriveGet, DriveType, Type, %Drv%
 IfNotEqual,DriveType,Removable, Return
 RegRead, Hex, HKLM, SYSTEM\MountedDevices, \DosDevices\%Drv%
 VarSetCapacity(U,(Sz:=StrLen(Hex)//2)),  VarSetCapacity(A,Sz+1)
 Loop % Sz
  NumPut( "0x" . SubStr(hex,2*A_Index-1,2), U, A_Index-1, "Char" )
 DllCall( "WideCharToMultiByte", Int,0,Int,0, UInt,&U,UInt,Sz, Str,A,UInt,Sz, Int,0,Int,0)
 StringSplit, Part, A, #
 ParentIdPrefixCheck := SubStr( Part3,1,InStr(Part3,"&",0,0)-1 )
 IfEqual,A_OSVersion,WIN_VISTA, Return,ParentIdPrefixCheck
 Loop, HKLM, SYSTEM\CurrentControlSet\Enum\USBSTOR,1,0
  { Device := A_LoopRegName
    Loop, HKLM, SYSTEM\CurrentControlSet\Enum\USBSTOR\%Device%,1,0
     { Serial := A_LoopRegName
       RegRead, PIPrefix, HKLM, SYSTEM\CurrentControlSet\Enum\USBSTOR\%Device%\%Serial%
              , ParentIdPrefix
       If ( PIPrefix = ParentIdPrefixCheck )
         Return, SubStr( Serial,1,InStr(Serial,"&",0,0)-1 )
     }
}}

USBD_GetDeviceID( Serial ) {
 Loop, HKLM, SYSTEM\CurrentControlSet\Enum\USB\,1,0
  { Device := A_LoopRegName
    Loop, HKLM, SYSTEM\CurrentControlSet\Enum\USB\%Device%,1,0
    If ( A_LoopRegName=Serial )
      Return DllCall( "CharUpperA", Str, "USB\" Device "\" Serial, Str )
}}

DeviceEject( DeviceID ) {
 hMod := DllCall( "LoadLibrary", Str,"SetupAPI.dll" ), VarSetCapacity(VE,255,0)
 If ! DllCall( "SetupAPI\CM_Locate_DevNodeA", UIntP,DI, Str,DeviceID, Int,0 )
 If ! DllCall( "SetupAPI\CM_Get_DevNode_Status", UIntP,STS, UIntP,PR, UInt,DI, Int,0)
 DllCall( "SetupAPI\CM_Request_Device_EjectA", UInt,DI, UIntP,VT, Str,VE, UInt,255, Int,0)
 DllCall( "FreeLibrary", UInt,hMod )
}

Eject( DRV  ) {                       ;  By SKAN,  http://goo.gl/pUUGRt,  CD:01/Sep/2014 | MD:13/Sep/2014
Local hMod, hVol, queryEnum, VAR := "", sPHDRV := "", nDID := 0, nVT := 1, nTC := A_TickCount 
Local IOCTL_STORAGE_GET_DEVICE_NUMBER := 0x2D1080, STORAGE_DEVICE_NUMBER,  FILE_DEVICE_DISK := 0x00000007 

  DriveGet, VAR, Type, % DRV := SubStr( DRV, 1, 1 ) ":"
  If ( VAR = "" )
     Return  ( ErrorLevel := -1 ) + 1
        
  If ( VAR = "CDROM" ) {
     Drive, Eject, %DRV%  
     If ( nTC + 1000 > A_Tickcount ) 
        Drive, Eject, %DRV%, 1
     Return  ( ErrorLevel ? 0 : 1 )
  } 

; Find physical drive number from drive letter.   
  hVol := DllCall( "CreateFile", "Str","\\.\" DRV, "Int",0, "Int",0, "Int",0, "Int",3, "Int",0, "Int",0 )

  VarSetcapacity( STORAGE_DEVICE_NUMBER, 12, 0 )
  DllCall( "DeviceIoControl", "Ptr",hVol, "UInt",IOCTL_STORAGE_GET_DEVICE_NUMBER
         , "Int",0, "Int",0, "Ptr",&STORAGE_DEVICE_NUMBER, "Int",12, "PtrP",0, "Ptr",0 )  

  DllCall( "CloseHandle", "Ptr",hVol )

  If (  NumGet( STORAGE_DEVICE_NUMBER, "UInt" ) = FILE_DEVICE_DISK  ) 
     sPHDRV := "\\\\.\\PHYSICALDRIVE" NumGet( STORAGE_DEVICE_NUMBER, 4, "UInt" )
  
; Find PNPDeviceID = USBSTOR for given physical drive
  queryEnum := ComObjGet( "winmgmts:" ).ExecQuery( "Select * from Win32_DiskDrive "
                      . "where DeviceID='" sPHDRV "' and InterfaceType='USB'" )._NewEnum()
  If not queryEnum[ DRV ]
     Return ( ErrorLevel := -2 ) + 2
     
  hMod := DllCall( "LoadLibrary", "Str","SetupAPI.dll", "UPtr" )
  
; Locate USBSTOR node and move up to its parent
  DllCall( "SetupAPI\CM_Locate_DevNode", "PtrP",nDID, "Str",DRV.PNPDeviceID, "Int",0 )
  DllCall( "SetupAPI\CM_Get_Parent", "PtrP",nDID, "UInt",nDID, "Int",0 )

  VarSetCapacity( VAR, 520, 0 )
  While % ( nDID and nVT and A_Index < 4 ) 
    DllCall( "SetupAPI\CM_Request_Device_Eject", "UInt",nDID, "PtrP",nVT, "Str",VAR, "Int",260, "Int",0 )
  
  DllCall("FreeLibrary", "Ptr",hMod ),    DllCall( "SetLastError", "UInt",nVT )     

Return ( nVT ? ( ErrorLevel := -3 ) + 3 : 1 )  
}
