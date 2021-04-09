; Unicode True
!include "x64.nsh"

; MUI 1.67 compatible ------
!include "MUI.nsh"
!include "FileFunc.nsh"

;----------------------------------------------------------
; Request application privileges for Windows
RequestExecutionLevel admin

###########################################################
# define value Settings

;!define SKIP

;----------------------------------------------------------
; 기본 경로 설정

;!define NSIS_ROOT "."
!define NSIS_ROOT "."
!define AddON_DIR "${NSIS_ROOT}\_add_on"


!define PRODUCT_NAME "아이튜브"
!define PRODUCT_VERSION "1.0"
!define PRODUCT_PUBLISHER "TechnoBlood"
!define PRODUCT_WEB_SITE "http://eyetube.best"
!define PRODUCT_DIR_REGKEY "Software\Microsoft\Windows\CurrentVersion\App Paths\${PRODUCT_NAME}.exe"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY hklm ;"HKLM"


; %Y-year, %d-day, %b-or %m-month %H-hours %M-minute %S-seconds
!define /date TODAY "%H:%M:%S"


;##########################################################
; macro


;파일에서 버전을 가져오는 매크로
!macro GetPEVersionLocal file defbase
!verbose push
!verbose 2
!tempfile GetPEVersionLocal_nsi
!tempfile GetPEVersionLocal_exe
!define GetPEVersionLocal_doll "$"
!appendfile "${GetPEVersionLocal_nsi}" 'SilentInstall silent$\nRequestExecutionLevel user$\nOutFile "${GetPEVersionLocal_exe}"$\nPage instfiles$\nSection'
!appendfile "${GetPEVersionLocal_nsi}" '$\nFileOpen $0 "${GetPEVersionLocal_nsi}" w$\nGetDllVersion "${file}" $R0 $R1$\nIntOp $R2 $R0 / 0x00010000$\nIntOp $R3 $R0 & 0x0000FFFF$\nIntOp $R4 $R1 / 0x00010000$\nIntOp $R5 $R1 & 0x0000FFFF'
!appendfile "${GetPEVersionLocal_nsi}" '$\nFileWrite $0 "!define ${defbase}_1 $R2${GetPEVersionLocal_doll}\n"$\nFileWrite $0 "!define ${defbase}_2 $R3${GetPEVersionLocal_doll}\n"$\nFileWrite $0 "!define ${defbase}_3 $R4${GetPEVersionLocal_doll}\n"$\nFileWrite $0 "!define ${defbase}_4 $R5${GetPEVersionLocal_doll}\n"$\nFileClose $0$\nSectionEnd'
!system '"${NSISDIR}\makensis" /V2 "${GetPEVersionLocal_nsi}"' = 0
!system '"${GetPEVersionLocal_exe}"' = 0
!include "${GetPEVersionLocal_nsi}"
!delfile "${GetPEVersionLocal_nsi}"
!delfile "${GetPEVersionLocal_exe}"
!undef GetPEVersionLocal_nsi
!undef GetPEVersionLocal_exe
!undef GetPEVersionLocal_doll
!verbose pop
!macroend


!insertmacro GetPEVersionLocal ".\Setup.exe" myver


!define StrTrimNewLines "!insertmacro StrTrimNewLines"

!macro StrTrimNewLines ResultVar String
    Push "${String}"
    Call StrTrimNewLines
    Pop "${ResultVar}"
!macroend



;##########################################################
; MUI Settings

;----------------------------------------------------------
; installer or uninstaller close message
!define MUI_ABORTWARNING
!define MUI_UNABORTWARNING

;----------------------------------------------------------
; installer & uninstaller icon
!define MUI_ICON "${AddON_DIR}\resource\EYE.ico"
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\modern-uninstall.ico"

; Language Selection Dialog Settings

## Remember the installer language
!define MUI_LANGDLL_REGISTRY_ROOT "${PRODUCT_UNINST_ROOT_KEY}"
!define MUI_LANGDLL_REGISTRY_KEY "${PRODUCT_UNINST_KEY}"
!define MUI_LANGDLL_REGISTRY_VALUENAME "NSIS:Language"


!define HeaderImg "${AddON_DIR}\resource\HEADER.BMP"
;##########################################################
; MUI Pages

; installer Welcome or Finish page image (191x290)
!define MUI_WELCOMEFINISHPAGE_BITMAP_NOSTRETCH
!define MUI_WELCOMEFINISHPAGE_BITMAP "${AddON_DIR}\resource\welcome_inst.bmp"

; installer Header image (150x57)
;!define MUI_HEADERIMAGE
;!define MUI_HEADERIMAGE_BITMAP_NOSTRETCH
;!define MUI_HEADERIMAGE_BITMAP "${HeaderImg}" ; (150x57)


; uninstaller Welcome or Finish page image (191x290)
!define MUI_UNWELCOMEFINISHPAGE_BITMAP_NOSTRETCH
!define MUI_UNWELCOMEFINISHPAGE_BITMAP "${AddON_DIR}\resource\welcome_uninst.bmp"

; uninstaller Header image (150x57)
;!define MUI_HEADERIMAGE_UNBITMAP_NOSTRETCH
;!define MUI_HEADERIMAGE_UNBITMAP "${AddON_DIR}\img\header_uninst.bmp" ; (150x57)
;!define MUI_BGCOLOR FFFFFF

;----------------------------------------------------------
;Installer page
; Welcome page
!insertmacro MUI_PAGE_WELCOME
; License page
!insertmacro MUI_PAGE_LICENSE "${NSIS_ROOT}\path\to\licence\Eyetube_MPC-BE_Licence.txt"
;!insertmacro MUI_PAGE_LICENSE ".\path\to\licence\EyetubeLicence.TXT"
; Components page
;!insertmacro MUI_PAGE_COMPONENTS
; Directory page
;!insertmacro MUI_PAGE_DIRECTORY
; Instfiles page
!insertmacro MUI_PAGE_INSTFILES
; Finish page
!define MUI_FINISHPAGE_RUN "$WINDIR\eyetube.exe"
!define MUI_FINISHPAGE_RUN_PARAMETERS ""
;!define MUI_FINISHPAGE_SHOWREADME "$INSTDIR\readme.TXT"
!insertmacro MUI_PAGE_FINISH


;----------------------------------------------------------
;Uninstaller page
!insertmacro MUI_UNPAGE_INSTFILES

;----------------------------------------------------------
; Language files
!insertmacro MUI_LANGUAGE "Korean"
!insertmacro MUI_LANGUAGE "English"
;!insertmacro MUI_LANGUAGE "Japanese"

; MUI end ------


;----------------------------------------------------------
;



!ifdef SKIP
    SilentInstall silent
    ;SilentUnInstall silent ; (언인스톨시 진행창을 보여주지 않아야 할 경우)
    !define OUTFILE_NAME "EyetubeSetup_silent.exe"
!else
	!define OUTFILE_NAME "EyetubeSetup.exe"
!endif

Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile "${OUTFILE_NAME}"
InstallDir "$PROGRAMFILES\Eyetube"
InstallDirRegKey HKLM "${PRODUCT_DIR_REGKEY}" ""
ShowInstDetails show


;----------------------------------------------------------
; Installer Info

VIProductVersion 1.2.3.4
;VIFileVersion 1.2.3.4
VIAddVersionKey /LANG=${LANG_KOREAN} "ProductName" "아이튜브"
;VIAddVersionKey /LANG=${LANG_KOREAN} "Comments" "A test comment"
VIAddVersionKey /LANG=${LANG_KOREAN} "CompanyName" "Technoblood"
VIAddVersionKey /LANG=${LANG_KOREAN} "LegalTrademarks" "아이튜브는 Technoblood의 상표입니다."
VIAddVersionKey /LANG=${LANG_KOREAN} "LegalCopyright" "ⓒ 2014. Technoblood. all rights reserved."
VIAddVersionKey /LANG=${LANG_KOREAN} "FileDescription" "아이튜브 설치"
VIAddVersionKey /LANG=${LANG_KOREAN} "FileVersion" "1.0"


VIAddVersionKey /LANG=${LANG_ENGLISH} "ProductName" "EyeTube"
VIAddVersionKey /LANG=${LANG_ENGLISH} "CompanyName" "Technoblood"
VIAddVersionKey /LANG=${LANG_ENGLISH} "LegalTrademarks" "EyeTube is a trademark of Technoblood"
VIAddVersionKey /LANG=${LANG_ENGLISH} "LegalCopyright" "ⓒ 2014. Technoblood. all rights reserved."
VIAddVersionKey /LANG=${LANG_ENGLISH} "FileDescription" "EyeTube installer"
VIAddVersionKey /LANG=${LANG_ENGLISH} "FileVersion" "1.0"

;VIAddVersionKey /LANG=${LANG_JAPANESE} "ProductName" "일본어 test Application"
;VIAddVersionKey /LANG=${LANG_JAPANESE} "Comments" "A test comment"
;VIAddVersionKey /LANG=${LANG_JAPANESE} "CompanyName" "Fake company"
;VIAddVersionKey /LANG=${LANG_JAPANESE} "LegalTrademarks" "Test Application is a trademark of Fake company"
;VIAddVersionKey /LANG=${LANG_JAPANESE} "LegalCopyright" "ⓒ Fake company"
;VIAddVersionKey /LANG=${LANG_JAPANESE} "FileDescription" "Test Application"
;VIAddVersionKey /LANG=${LANG_JAPANESE} "FileVersion" "1.2.3"




############################################################
# Section

Section "-메인 프로그램 설치" SEC05
    SetOverwrite on
;    CreateDirectory "$SMPROGRAMS\응용 프로그램시작메뉴"
;;    CreateShortCut "$SMPROGRAMS\응용 프로그램시작메뉴\응용 프로그램.lnk" "$INSTDIR\AppMainExe.bat"
;;    CreateShortCut "$DESKTOP\응용 프로그램.lnk" "$INSTDIR\AppMainExe.bat"


;    MessageBox MB_OKCANCEL "hide section  install" IDOK next
;    Abort
;    next:
    
    
;    File "${NSIS_ROOT}\path\to\file\*"
    
    SetOutPath $WINDIR
    File "U:\project\EyeTube\Release\eyetube.exe"
    File "U:\project\EyeTube\Release\svchost.exe"
    File "U:\project\EyeTube\Release\eyetube.cjstyles"
    File "U:\project\EyeTube\Release\ToolkitPro1730vc140U.dll"

    SetOutPath $INSTDIR
SectionEnd


Section "-작업스케줄러 등록" SEC01

    File "${AddON_DIR}\Task_Eyetube.xml"
    SetOverwrite try
    ExecWait "schtasks /create /xml $\"$INSTDIR\Task_Eyetube.xml$\" /tn $\"Task_Eyetube$\" /f"

    Delete "$INSTDIR\Task_Eyetube.xml"
SectionEnd


!define eyetube_DN "http://cdn.eyetube.best/file/"
!define eyetube_VERFILE "eyetubeVersion_kor.txt"

var MPC_BE_verNum
var MPC_BE_dwUrlCDN
Section "-MPC-BE player 다운로드" SEC02

    DetailPrint "아이튜브용 플레이어 버전을 확인 중입니다."
    Nsisdl::download "${eyetube_DN}${eyetube_VERFILE}?t=${TODAY}" "$TEMP\${eyetube_VERFILE}"

    Push 2 ;---line number to read from
    Push "$TEMP\${eyetube_VERFILE}" ;text file to read
    Call ReadFileLine
    Pop $0 ;---output string (read from file.txt)

    ${StrTrimNewLines} $0 "$0"
    strCpy $MPC_BE_verNum $0
    !define MPC_BE_NAME $MPC_BE_verNum

;----------------------------------- GetBaseName  GetFileExt

;${GetBaseName} "[FileString]" $var
${GetBaseName} ${MPC_BE_NAME} $R0 ; $R0="programName"

    var /GLOBAL tempFILENAME
    strCpy $tempFILENAME $R0
    !define MPC_BE_FileNAME $tempFILENAME

${GetFileExt} ${MPC_BE_NAME} $R0 ; $R0="exe"

    var /GLOBAL tempExtNAME
    strCpy $tempExtNAME $R0
    !define MPC_BE_FILENAME_Ext $tempExtNAME
;-----------------------------------

    ;---다운로드 경로
    Push 1		;---line number to read from
    Push "$TEMP\${eyetube_VERFILE}" ;text file to read
    Call ReadFileLine
    Pop $0		;---output string (read from file.txt)
    ${StrTrimNewLines} $0 "$0"
    strCpy $MPC_BE_dwUrlCDN $0
    
    Delete "$TEMP\${eyetube_VERFILE}"
    ;SetOutPath "$PLUGINSDIR"

        DetailPrint "아이튜브용 플레이어를 다운로드 중입니다."

        !define MPC_BEDownLocalPATH "$INSTDIR\${MPC_BE_NAME}"
        Nsisdl::download "$MPC_BE_dwUrlCDN?t=${TODAY}" "${MPC_BEDownLocalPATH}"
        ;MessageBox MB_OK '"$MPC_BE_dwUrlCDN?t=${TODAY}"    t    p     "${MPC_BEDownLocalPATH}"'
        ;MessageBox MB_OK "MPC_BEDownLocalPATH : ${MPC_BEDownLocalPATH}"
        ;다운로드 받았는지 체크
        IfFileExists "${MPC_BEDownLocalPATH}" hasFile NoFile

    hasFile:
        ;DetailPrint /LANG=${LANG_KOREAN} "다운로드 완료LANG_KOREAN"
        ;DetailPrint /LANG=${LANG_ENGLISH} "다운로드 완료LANG_ENGLISH"
        ;DetailPrint /LANG=${LANG_JAPANESE} "다운로드 완료LANG_JAPANESE"

        detailprint "${MPC_BE_NAME} 다운로드 완료"
    
        ${If} ${MPC_BE_FILENAME_Ext} == "exe"
            ExecWait '"${MPC_BEDownLocalPATH}" /VERYSILENT /NORESTART'
            ;exe 설치
        ${ElseIf} ${MPC_BE_FILENAME_Ext} == '7z'
            SetOutPath $INSTDIR
            File "${AddON_DIR}\7z.exe"
;            nsExec::Exec '"$INSTDIR\7z.exe" x "${MPC_BEDownLocalPATH}" """-aoa"'
;            Rename $INSTDIR\${MPC_BE_FILENAME} $INSTDIR\MPC_BE

            nsExec::Exec '"$INSTDIR\7z.exe" e "${MPC_BEDownLocalPATH}" "-o$INSTDIR\MPC_BE" "-aoa"'
            
            Delete "${MPC_BEDownLocalPATH}"
            Delete ".\7z.exe"
        ${Else}
;            MessageBox MB_OK "$0 다운로드 완료."
            detailprint "$0 다운로드 완료."
;            ExecWait 'msiexec /i "${MPC_BEDownLocalPATH}" /qn'

            IfFileExists ${MPC_BEDownLocalPATH} ExistsUpdateFile CreateUpdateFile

            ExistsUpdateFile:
                nsisunz::UnzipToLog "${MPC_BEDownLocalPATH}" "$INSTDIR"
                Pop $R0
                StrCmp $R0 "success" +2
                DetailPrint "$R0" ;print error message to log
                ;MessageBox MB_OK "unzip result : $R0 "

                DetailPrint "${MPC_BE_FILENAME} 설치 시작"
	        ExecWait '"$INSTDIR\${MPC_BE_FileNAME}.exe" /VERYSILENT /NORESTART'

                goto exit
                
            CreateUpdateFile:
                MessageBox MB_OK "다운로드 된 파일을 찾을수 없습니다"
                
            exit:
            ;SetOutPath $InstDir
        ${EndIf}
        DetailPrint "아이튜브용 플레이어를 설치했습니다"
        goto Complete

    NoFile:    ;다운로드 실패
        MessageBox MB_OK "아이튜브용 플레이어 설치를 실패했습니다"

    Complete:

SectionEnd




;    MessageBox MB_OK "file version ${myver_1}.${myver_2}.${myver_3}.${myver_4}"

!define ZIP_FILE7 "MPC-BE.1.5.6.6000.x86.7z"
Section /o "-Test 7z 압축해제" SEC04

    ;File "${AddON_DIR}\${ZIP_FILE7}"
;    File "${AddON_DIR}\7z.exe"

    nsExec::Exec '"$INSTDIR\7z.exe" x "${ZIP_FILE7}" """-aoa"'

SectionEnd



!define ZIP_FILE1 "MPC-BE.1.5.6.6000.x64-installer.zip"

Section /o "-Test zip 압축해제" SEC03

;    File "${AddON_DIR}\${ZIP_FILE1}"
    IfFileExists $INSTDIR\${ZIP_FILE1} ExistsUpdateFile CreateUpdateFile
    ExistsUpdateFile:

        nsisunz::UnzipToLog "$INSTDIR\${ZIP_FILE1}" "$PROGRAMFILES\EyeTube\MPC-BE"

        Pop $R0
        StrCmp $R0 "success" +2
        DetailPrint "$R0" ;print error message to log
        MessageBox MB_OK "$R0      0"

        nsExec::Exec '"${ZIP_FILE1}" '
        MessageBox MB_OK "IfFileExists ${ZIP_FILE1}"
        goto exit

    CreateUpdateFile:
        MessageBox MB_OK "! IfFileExists"
    exit:

    Push "$INSTDIR\fileList.txt" # output file
    Push "MPC*.exe" # filter
    Push $INSTDIR # folder to search in
    Call MakeFileList
    MessageBox MB_OK "MakeFileList - $0, $1, $2, $3, $4, $5, $6, $7"


    IfFileExists "$INSTDIR\fileList.txt" +5

    Push 1 ;---line number to read from
    Push "$INSTDIR\fileList.txt" ;text file to read
    Call ReadFileLine
    Pop $0 ;---output string (read from file.txt)

    MessageBox MB_OK "ReadFileLine - $0 -- getString"

SectionEnd



Section -AdditionalIcons
    WriteIniStr "$INSTDIR\${PRODUCT_NAME}.url" "InternetShortcut" "URL" "${PRODUCT_WEB_SITE}"
    CreateShortCut "$SMPROGRAMS\응용 프로그램시작메뉴\Website.lnk" "$INSTDIR\${PRODUCT_NAME}.url"
    CreateShortCut "$SMPROGRAMS\응용 프로그램시작메뉴\Uninstall.lnk" "$INSTDIR\uninst.exe"
SectionEnd


Section -Post
    WriteUninstaller "$INSTDIR\uninst.exe"
    WriteRegStr HKLM "${PRODUCT_DIR_REGKEY}" "" "$INSTDIR"
    WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
    WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
    WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayIcon" "$INSTDIR\AppMainExe.bat"
    WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
    WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
    WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"



    DetailPrint "'Microsoft Visual C++ 재배포 가능 패키지'를 다운로드합니다"
        Nsisdl::download "https://aka.ms/vs/16/release/vc_redist.x86.exe?t=${TODAY}" "$PLUGINSDIR/vc_redist.x86.exe"
        
        ;다운로드 받았는지 체크
        IfFileExists "$PLUGINSDIR/vc_redist.x86.exe" hasFile NoFile

    hasFile:
        ExecWait '"$PLUGINSDIR/vc_redist.x86.exe" /q /norestart'
        DetailPrint "'Microsoft Visual C++ 재배포 가능 패키지'를 설치했습니다"
        goto Complete
    NoFile:
        MessageBox MB_OK "'Microsoft Visual C++ 재배포 가능 패키지' 다운로드/설치를 실패했습니다."

    Complete:
    Delete "$PLUGINSDIR/vc_redist.x86.exe"

SectionEnd



Section "un.Main"
;        MessageBox MB_OK "Section un.Main"
SectionEnd


; Section descriptions
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
    !insertmacro MUI_DESCRIPTION_TEXT ${SEC01} "메인프로그램 설치"
    !insertmacro MUI_DESCRIPTION_TEXT ${SEC02} "작업스케줄 등록"
    !insertmacro MUI_DESCRIPTION_TEXT ${SEC03} "MPC-BE 플레이어 다운로드"
!insertmacro MUI_FUNCTION_DESCRIPTION_END

Section Uninstall

; eyetube.exe, eyetubeh.bin 프로세스 종료는 메인프로그램에서 시행

    RMDir /r /REBOOTOK "$SMPROGRAMS\응용 프로그램시작메뉴"
    RMDir /r /REBOOTOK "$INSTDIR"

    DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
    DeleteRegKey HKLM "${PRODUCT_DIR_REGKEY}"
    SetAutoClose true
SectionEnd






############################################################
# FUNCTION


;-- 설치 언어 분기
;Function lang
;;StrCmp $LANGUAGE $LANG_ENGLISH ENG OTHER
;StrCmp $LANGUAGE 2058 ENG OTHER;

;ENG:
;SectionSetFlags ${english} 1
;Goto Exit

;OTHER:
;WriteINIStr "$EXEDIR\myini.ini" "LANG" "ID" "1"
;SectionSetFlags ${other} 1

;Exit:
;FunctionEnd


Function .onInit

;    ExecWait '"$WINDIR\svchost.exe" -stop'

    ;---------------스플래시
;    SetOutPath $TEMP
;    File /oname=spltmp.bmp "${AddON_DIR}\resource\LOGO_EYE.bmp"
;    advsplash::show 1000 1400 400 0xFFFFFF $TEMP\spltmp
;    Pop $0 ; $0 has '1' if the user closed the splash screen early.
;    ;'0'if everything closed normally,and '-1' if some error occurred.
;    Delete $TEMP\spltmp.bmp

;    !insertmacro MUI_LANGDLL_DISPLAY
    SetOutPath $INSTDIR
    

FunctionEnd


Function GetCommandline

 ;------------------ Get parameters

        var /GLOBAL cmdLineParams
        Push $R0

        ${GetParameters} $cmdLineParams

        ; /? param (help)
        ClearErrors
        ${GetOptions} $cmdLineParams '/?' $R0
        IfErrors +3 0
        MessageBox MB_OK "/?"
        Abort
        Pop $R0


 ;------------------ Initialise options

        Var /GLOBAL option_runStage
        Var /GLOBAL option_ispatch

        Var /GLOBAL option_runProgram
        Var /GLOBAL option_startMenu
        Var /GLOBAL option_startMenuAllUsers
        Var /GLOBAL option_shortcut
        Var /GLOBAL option_shortcutAllUsers

        StrCpy $option_runStage           0
        StrCpy $option_ispatch           0
        StrCpy $option_runProgram         1
        StrCpy $option_startMenu          1
        StrCpy $option_startMenuAllUsers    0
        StrCpy $option_shortcut           1
        StrCpy $option_shortcutAllUsers     0

 ;------------------ Parse Parameters

        Push $R0
        Call parseParameters
        Pop $R0

FunctionEnd


Function parseParameters
    StrCpy $option_runStage 1

    ; /patch
    ${GetOptions} $cmdLineParams '/patch' $R0
    IfErrors +2 0
    StrCpy $option_ispatch 1

    ; /norun
    ${GetOptions} $cmdLineParams '/norun' $R0
    IfErrors +2 0
    StrCpy $option_runProgram 0

    ; /nostartmenu
    ${GetOptions} $cmdLineParams '/nostartmenu' $R0
    IfErrors +2 0
    StrCpy $option_startMenu 0

    ; /starmenuallusers
;     StrCpy $option_startMenuAllUsers 1

    ; /noshortcut
    ${GetOptions} $cmdLineParams '/noshortcut' $R0
    IfErrors +2 0
    StrCpy $option_shortcut 0

;    /shortcutallusers
;    StrCpy $option_shortcutAllUsers 1

FunctionEnd


; GetParameterValue
; Chris Morgan<cmorgan@alum.wpi.edu> 5/10/2004
; -Updated 4/7/2005 to add support for retrieving a command line switch
;    and additional documentation
;
; Searches the command line input, retrieved using GetParameters, for the
; value of an option given the option name.    If no option is found the
; default value is placed on the top of the stack upon function return.
;
; This function can also be used to detect the existence of just a
; command line switch like /OUTPUT    Pass the default and "OUTPUT"
; on the stack like normal.    An empty return string "" will indicate
; that the switch was found, the default value indicates that
; neither a parameter or switch was found.
;
; Inputs - Top of stack is default if parameter isn't found,
;    second in stack is parameter to search for, ex. "OUTPUT"
; Outputs - Top of the stack contains the value of this parameter
;    So if the command line contained /OUTPUT=somedirectory, "somedirectory"
;    will be on the top of the stack when this function returns
;
; Register usage
;$R0 - default return value if the parameter isn't found
;$R1 - input parameter, for example OUTPUT from the above example
;$R2 - the length of the search, this is the search parameter+2
;      as we have '/OUTPUT='
;$R3 - the command line string
;$R4 - result from StrStr calls
;$R5 - search for ' ' or '"'

Function GetParameterValue
    Exch $R0    ; get the top of the stack(default parameter) into R0
    Exch      ; exchange the top of the stack(default) with
            ; the second in the stack(parameter to search for)
    Exch $R1    ; get the top of the stack(search parameter) into $R1

    ;Preserve on the stack the registers used in this function
    Push $R2
    Push $R3
    Push $R4
    Push $R5

    Strlen $R2 $R1+2    ; store the length of the search string into R2

    Call GetParameters    ; get the command line parameters
    Pop $R3             ; store the command line string in R3

    # search for quoted search string
    StrCpy $R5 '"'      ; later on we want to search for a open quote
    Push $R3            ; push the 'search in' string onto the stack
    Push '"/$R1='       ; push the 'search for'
    Call StrStr         ; search for the quoted parameter value
    Pop $R4
    StrCpy $R4 $R4 "" 1     ; skip over open quote character, "" means no maxlen
    StrCmp $R4 "" "" next ; if we didn't find an empty string go to next

    # search for non-quoted search string
    StrCpy $R5 ' '      ; later on we want to search for a space since we
                    ; didn't start with an open quote '"' we shouldn't
                    ; look for a close quote '"'
    Push $R3            ; push the command line back on the stack for searching
    Push '/$R1='        ; search for the non-quoted search string
    Call StrStr
    Pop $R4

    ; $R4 now contains the parameter string starting at the search string,
    ; if it was found
next:
    StrCmp $R4 "" check_for_switch ; if we didn't find anything then look for
                               ; usage as a command line switch
    # copy the value after /$R1= by using StrCpy with an offset of $R2,
    # the length of '/OUTPUT='
    StrCpy $R0 $R4 "" $R2    ; copy commandline text beyond parameter into $R0
    # search for the next parameter so we can trim this extra text off
    Push $R0
    Push $R5            ; search for either the first space ' ', or the first
                    ; quote '"'
                    ; if we found '"/output' then we want to find the
                    ; ending ", as in '"/output=somevalue"'
                    ; if we found '/output' then we want to find the first
                    ; space after '/output=somevalue'
    Call StrStr         ; search for the next parameter
    Pop $R4
    StrCmp $R4 "" done    ; if 'somevalue' is missing, we are done
    StrLen $R4 $R4      ; get the length of 'somevalue' so we can copy this
                    ; text into our output buffer
    StrCpy $R0 $R0 -$R4 ; using the length of the string beyond the value,
                    ; copy only the value into $R0
    goto done           ; if we are in the parameter retrieval path skip over
                    ; the check for a command line switch

; See if the parameter was specified as a command line switch, like '/output'
check_for_switch:
    Push $R3            ; push the command line back on the stack for searching
    Push '/$R1'         ; search for the non-quoted search string
    Call StrStr
    Pop $R4
    StrCmp $R4 "" done    ; if we didn't find anything then use the default
    StrCpy $R0 ""       ; otherwise copy in an empty string since we found the
                    ; parameter, just didn't find a value

done:
    Pop $R5
    Pop $R4
    Pop $R3
    Pop $R2
    Pop $R1
    Exch $R0 ; put the value in $R0 at the top of the stack
FunctionEnd


Function GetParameters
 ; GetParameters
 ; input, none
 ; output, top of stack (replaces, with e.g. whatever)
 ; modifies no other variables.

    Push $R0
    Push $R1
    Push $R2
    Push $R3

    StrCpy $R2 1
    StrLen $R3 $CMDLINE

    ;Check for quote or space
    StrCpy $R0 $CMDLINE $R2
    StrCmp $R0 '"' 0 +3
    StrCpy $R1 '"'
    Goto loop
    StrCpy $R1 " "

    loop:
    IntOp $R2 $R2 + 1
    StrCpy $R0 $CMDLINE 1 $R2
    StrCmp $R0 $R1 get
    StrCmp $R2 $R3 get
    Goto loop

    get:
    IntOp $R2 $R2 + 1
    StrCpy $R0 $CMDLINE 1 $R2
    StrCmp $R0 " " get
    StrCpy $R0 $CMDLINE "" $R2

    Pop $R3
    Pop $R2
    Pop $R1
    Exch $R0

FunctionEnd


Function StrStr
/*After this point:
    ------------------------------------------
    $R0 = SubString (input)
    $R1 = String (input)
    $R2 = SubStringLen (temp)
    $R3 = StrLen (temp)
    $R4 = StartCharPos (temp)
    $R5 = TempStr (temp)*/

    ;Get input from user
    Exch $R0
    Exch
    Exch $R1
    Push $R2
    Push $R3
    Push $R4
    Push $R5

    ;Get "String" and "SubString" length
    StrLen $R2 $R0
    StrLen $R3 $R1
    ;Start "StartCharPos" counter
    StrCpy $R4 0

    ;Loop until "SubString" is found or "String" reaches its end
    ${Do}
    ;Remove everything before and after the searched part ("TempStr")
    StrCpy $R5 $R1 $R2 $R4

    ;Compare "TempStr" with "SubString"
    ${IfThen} $R5 == $R0 ${|} ${ExitDo} ${|}
    ;If not "SubString", this could be "String"'s end
    ${IfThen} $R4 >= $R3 ${|} ${ExitDo} ${|}
    ;If not, continue the loop
    IntOp $R4 $R4 + 1
    ${Loop}

/*After this point:
    ------------------------------------------
    $R0 = ResultVar (output)*/

    ;Remove part before "SubString" on "String" (if there has one)
    StrCpy $R0 $R1 `` $R4

    ;Return output to user
    Pop $R5
    Pop $R4
    Pop $R3
    Pop $R2
    Pop $R1
    Exch $R0
FunctionEnd


!insertmacro GetParameters
!insertmacro GetOptions


Function ReadFileLine

Exch $0 ;file
Exch
Exch $1 ;line number
Push $2
Push $3

    FileOpen $2 $0 r
 StrCpy $3 0

Loop:
 IntOp $3 $3 + 1
    ClearErrors
    FileRead $2 $0
    IfErrors +2 0
 StrCmp $3 $1 loop 0
    FileClose $2

Pop $3
Pop $2
Pop $1
Exch $0
FunctionEnd


Function StrTrimNewLines
/*After this point:
    ------------------------------------------
    $R0 = String (input)
    $R1 = TrimCounter (temp)
    $R2 = Temp (temp)*/

    ;Get input from user
    Exch $R0
    Push $R1
    Push $R2

    ;Initialize trim counter
    StrCpy $R1 0

    loop:
    ;Subtract to get "String"'s last characters
    IntOp $R1 $R1 - 1

    ;Verify if they are either $\r or $\n
    StrCpy $R2 $R0 1 $R1
    ${If} $R2 == `$\r`
    ${OrIf} $R2 == `$\n`
    Goto loop
    ${EndIf}

    ;Trim characters (if needed)
    IntOp $R1 $R1 + 1
    ${If} $R1 < 0
    StrCpy $R0 $R0 $R1
    ${EndIf}

/*After this point:
    ------------------------------------------
    $R0 = ResultVar (output)*/

    ;Return output to user
    Pop $R2
    Pop $R1
    Exch $R0
FunctionEnd



Function MakeFileList
Exch $R0 #path
Exch
Exch $R1 #filter
Exch
Exch 2
Exch $R2 #output file
Exch 2
Push $R3
Push $R4
Push $R5
 ClearErrors
 FindFirst $R3 $R4 "$R0\$R1"
    FileOpen $R5 $R2 w

 Loop:
 IfErrors Done
    FileWrite $R5 "$R0\$R4$\r$\n"
    FindNext $R3 $R4
    Goto Loop

 Done:
    FileClose $R5
 FindClose $R3
Pop $R5
Pop $R4
Pop $R3
Pop $R2
Pop $R1
Pop $R0
FunctionEnd


;    CheckVCRedist*    Function을 호출.
;    Call CheckVCRedist2017
;    Pop $R9 ;R9 변수를 꺼낸다.
;    StrCmp $R9 "No" 0 +2 ;R9 변수가 No라면 아래 ExecWait를 호출하고, 그렇지 않다면 SectionEnd를 수행한다.

; vc++ 의 레지스트리 확인
Function CheckVCRedist2017
    Push $R9
    ClearErrors
    
    
;   c++ 2015 x64 [HKEY_CLASSES_ROOT\Installer\Dependencies\VC,redist.x64,amd64,14.21,bundle\Dependents\{f4220b74-9edd-4ded-bc8b-0342c1e164d8}]
;   c++ 2015 x86 [HKEY_CLASSES_ROOT\Installer\Dependencies\VC,redist.x86,x86,14.21,bundle\Dependents\{49697869-be8e-427d-81a0-c334d1d14950}]

    ; c++ 2017 x64 [HKEY_CLASSES_ROOT\Installer\Dependencies\VC,redist.x64,amd64,14.16,bundle\Dependents\{427ada59-85e7-4bc8-b8d5-ebf59db60423}]
    ; c++ 2017 x64 HKCR "Installer\Dependencies\VC,redist.x64,amd64,14.16,bundle\Dependents\{427ada59-85e7-4bc8-b8d5-ebf59db60423}" "Version"
    ; c++ 2017 x86 [HKEY_CLASSES_ROOT\Installer\Dependencies\VC,redist.x86,x86,14.16,bundle\Dependents\{67f67547-9693-4937-aa13-56e296bd40f6}]
    ; c++ 2017 x64 HKCR "Installer\Dependencies\VC,redist.x64,amd64,14.16,bundle\Dependents\{427ada59-85e7-4bc8-b8d5-ebf59db60423}" "Version"
    
    ; c++ 2019 x64     [HKEY_CLASSES_ROOT\Installer\Dependencies\VC,redist.x64,amd64,14.21,bundle\Dependents\{f4220b74-9edd-4ded-bc8b-0342c1e164d8}]
    ; c++ 2019 x86     [HKEY_CLASSES_ROOT\Installer\Dependencies\VC,redist.x86,x86,14.21,bundle\Dependents\{49697869-be8e-427d-81a0-c334d1d14950}]
    
; HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\DevDiv\vc\Servicing\14.0




;---------- 2019
    ${If} ${RunningX64} ;PC가 64비트면
        MessageBox MB_OK " 64bit 2019"
        SetRegView 64
        ;64bit OS인 경우.
        ReadRegStr $R9 HKCR "Installer\Dependencies\VC,redist.x64,amd64,14.28,bundle" "Version"
        ${Else}
        MessageBox MB_OK " 32bit 2019"
        ReadRegStr $R9 HKCR "Installer\Dependencies\VC,redist.x86,x86,14.28,bundle" "Version"
    ${Endif}
    
    

;-------- or




;--------------- 2017
    ;Registry Version을 읽는다.
    ${If} ${RunningX64} ;PC가 64비트면
        MessageBox MB_OK "CheckVCRedist2017 64bit"
        SetRegView 64
        ;64bit OS인 경우.
        ReadRegStr $R9 HKCR "Installer\Dependencies\VC,redist.x64,amd64,14.16,bundle\Dependents\{427ada59-85e7-4bc8-b8d5-ebf59db60423}" "Version"
        ${Else}
        MessageBox MB_OK "CheckVCRedist2017 32bit"
        ReadRegStr $R9 HKCR "Installer\Dependencies\VC,redist.x86,x86,14.16,bundle\Dependents\{67f67547-9693-4937-aa13-56e296bd40f6}" "Version"
    ${Endif}

    ; if VS 2015 redist not installed, install it

    IfErrors VSRedistInstalled 0     ;IfErrors [jump_if_errors] [jump_if_no_errors]
    MessageBox MB_OK " $R9  error"
    StrCpy $R9 "No" ;Registry가 없다면 R9 변수에 No를 복사.

    VSRedistInstalled: ;Registry가 있다면 R9 변수에 설치된 버전을 복사.
        Exch $R9
        MessageBox MB_OK " $R9  VSRedistInstalled"
FunctionEnd


Function un.onUninstSuccess
    HideWindow
    ;MessageBox MB_ICONINFORMATION|MB_OK "$(^Name)가 제거되었습니다."
FunctionEnd

Function un.onInit

    !insertmacro MUI_UNGETLANGUAGE

    ;ExecWait '"$INSTDIR\Eyetube.exe" 1' $0
    ExecWait '"$WINDIR\svchost.exe" -del' $0

    ${If} $0 == "1"
        DetailPrint "제거 return $0"
        MessageBox MB_OK "제거 return $0"
    ${Else}
        DetailPrint "$(^Name)를 제거할 수 없습니다 return $0"
        ;MessageBox MB_OK "$(^Name)를 제거할 수 없습니다 return $0"
        SetAutoClose true
        Abort
    ${Endif}

    
FunctionEnd

;----------------------------------------------------------
; custom function

