Unicode True

; MUI 1.67 compatible ------
!include "FileFunc.nsh"
!include "MUI2.nsh"

;----------------------------------------------------------
; Request application privileges for Windows
RequestExecutionLevel admin



; HM NIS Edit Wizard helper defines
!define PRODUCT_NAME "아이튜브플레이어"
!define PRODUCT_VERSION "1.0"
!define PRODUCT_PUBLISHER "Technoblood"
!define PRODUCT_WEB_SITE "http://design.eyetube.best/html/index.html"


;----------------------------------------------------------
; 기본 경로 설정

;!define NSIS_ROOT "."
!define NSIS_ROOT "."
!define AddON_DIR "${NSIS_ROOT}\_add_on"


!define /date TODAY "%H_%M_%S"


;----------------------------------------------------------

!define StrTrimNewLines "!insertmacro StrTrimNewLines"

!macro StrTrimNewLines ResultVar String
    Push "${String}"
    Call StrTrimNewLines
    Pop "${ResultVar}"
!macroend


;##########################################################
; MUI Pages

; installer Welcome or Finish page image (191x290)
!define MUI_WELCOMEFINISHPAGE_BITMAP_NOSTRETCH
!define MUI_WELCOMEFINISHPAGE_BITMAP "${AddON_DIR}\resource\welcome_inst.bmp"

; uninstaller Welcome or Finish page image (191x290)
!define MUI_UNWELCOMEFINISHPAGE_BITMAP_NOSTRETCH
!define MUI_UNWELCOMEFINISHPAGE_BITMAP "${AddON_DIR}\resource\welcome_uninst.bmp"



; MUI Settings
!define MUI_ABORTWARNING
!define MUI_ICON "${AddON_DIR}\resource\EYE.ico"

; Welcome page
;!define MUI_PAGE_CUSTOMFUNCTION_SHOW MyWelcomeShowCallback
!insertmacro MUI_PAGE_WELCOME

; Instfiles page
!insertmacro MUI_PAGE_INSTFILES
; Finish page
!insertmacro MUI_PAGE_FINISH

; Language files
!insertmacro MUI_LANGUAGE "Korean"



; MUI end ------



Name "${PRODUCT_NAME}"
OutFile "EyetubePlayerSetup.exe"
InstallDir "$PROGRAMFILES\Eyetube"
;ShowInstDetails show




!define eyetube_DN "http://cdn.eyetube.best/file/"
!define eyetube_VERFILE "eyetubeVersion_kor.txt"

var MPC_BE_verNum
var MPC_BE_dwUrlCDN
Section "-MPC-BE player 다운로드" SEC02

SetOutPath $INSTDIR
    DetailPrint "아이튜브용 플레이어 버전을 확인 중입니다."
    Nsisdl::download "${eyetube_DN}${eyetube_VERFILE}?t=${TODAY}" "$TEMP\${eyetube_VERFILE}"
        ;MessageBox MB_OK "eyetube_VERFILE : $TEMP\${eyetube_VERFILE}"
        
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

    DetailPrint "아이튜브용 플레이어를 다운로드 중입니다."

;    CreateDirectory $INSTDIR
    !define MPC_BEDownLocalPATH "$INSTDIR\${MPC_BE_NAME}"
    Nsisdl::download "$MPC_BE_dwUrlCDN?t=${TODAY}" "${MPC_BEDownLocalPATH}"
    
    ;다운로드 받았는지 체크
    IfFileExists "${MPC_BEDownLocalPATH}" hasFile NoFile

    hasFile:
        ;DetailPrint /LANG=${LANG_KOREAN} "다운로드 완료LANG_KOREAN"
        ;DetailPrint /LANG=${LANG_ENGLISH} "다운로드 완료LANG_ENGLISH"

        detailprint "${MPC_BE_NAME} 다운로드 완료"


        ${If} ${MPC_BE_FILENAME_Ext} == "exe"
            ExecWait '"${MPC_BEDownLocalPATH}" /VERYSILENT /NORESTART'
            ;exe 설치
        ${ElseIf} ${MPC_BE_FILENAME_Ext} == '7z'
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




#!define MUI_WELCOMEPAGE_TEXT "New text goes here"


Function MyWelcomeShowCallback
SendMessage $mui.WelcomePage.Text ${WM_SETTEXT} 0 "STR:dfdfdfdf$(MUI_TEXT_WELCOME_INFO_TEXT)$\n$\nVersion: 3.5"
FunctionEnd
