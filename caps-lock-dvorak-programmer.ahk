#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; Forked from https://gist.github.com/Danik/5808330
; Autohotkey Capslock Remapping Script 
; Danik
; More info at http://danikgames.com/blog/?p=714
; danikgames.com
; 
; Functionality:
; - Deactivates capslock for normal (accidental) use.
; - Hold Capslock and drag anywhere in a window to move it (not just the title bar).
; - Access the following functions when pressing Capslock: 
;     Cursor keys           - C, H, T, N
;     Enter                 - Space
;     Home, PgDn, PgUp, End - G, R, F, D
;     Backspace and Del     - N, M
;
;     Insert                - X
;     Select all            - A
;     Cut, copy, paste      - O, E, U
;     Close tab, window     - <, >
;     Esc                   - P
;     Next, previous tab    - Tab, :
;     Undo, redo            - w and v
; - Numpad at the right hand resting position when holding Ctrl+Shift+Alt (using keys m,.jkluio and spacebar)
;  
; To use capslock as you normally would, you can press WinKey + Capslock


; This script is mostly assembled from modified versions of the following awesome scripts:
;
; # Home Row Computing by Gustavo Duarte: http://duartes.org/gustavo/blog/post/home-row-computing for 
; Changes: 
; - Does not need register remapping of AppsKey using SharpKeys.
; - Uses normal cursor key layout 
; - Added more hotkeys for insert, undo, redo etc.
;
; # Get the Linux Alt+Window Drag Functionality in Windows: http://www.howtogeek.com/howto/windows-vista/get-the-linux-altwindow-drag-functionality-in-windows/
; Changes: The only change was using Capslock instead of Alt. This 
; also removes problems in certain applications.




#Persistent
SetCapsLockState, AlwaysOff



; Capslock + jkli (left, down, up, right)

Capslock & h::Send {Blind}{Left DownTemp}
Capslock & h up::Send {Blind}{Left Up}

Capslock & t::Send {Blind}{Down DownTemp}
Capslock & t up::Send {Blind}{Down Up}

Capslock & c::Send {Blind}{Up DownTemp}
Capslock & c up::Send {Blind}{Up Up}

Capslock & n::Send {Blind}{Right DownTemp}
Capslock & n up::Send {Blind}{Right Up}


; Capslock + grdf (pgdown, pgup, home, end)

Capslock & g::SendInput {Blind}{Home Down}
Capslock & g up::SendInput {Blind}{Home Up}

Capslock & r::SendInput {Blind}{End Down}
Capslock & r up::SendInput {Blind}{End Up}

Capslock & f::SendInput {Blind}{PgUp Down}
Capslock & f up::SendInput {Blind}{PgUp Up}

Capslock & d::SendInput {Blind}{PgDn Down}
Capslock & d up::SendInput {Blind}{PgDn Up}


; Capslock + aoeu (select all, cut-copy-paste)

Capslock & a::SendInput {Ctrl Down}{a Down}
Capslock & a up::SendInput {Ctrl Up}{a Up}

Capslock & o::SendInput {Ctrl Down}{x Down}
Capslock & o up::SendInput {Ctrl Up}{x Up}

Capslock & e::SendInput {Ctrl Down}{c Down}
Capslock & e up::SendInput {Ctrl Up}{c Up}

Capslock & u::SendInput {Ctrl Down}{v Down}
Capslock & u up::SendInput {Ctrl Up}{v Up}


; Capslock + ,.p (close tab or window, press esc)

Capslock & ,::SendInput {Ctrl down}{F4}{Ctrl up}
Capslock & .::SendInput {Alt down}{F4}{Alt up}
Capslock & p::SendInput {Blind}{Esc Down}


; Capslock + bm (insert, backspace, del)

Capslock & x::SendInput {Blind}{Insert Down}
Capslock & m::SendInput {Blind}{Del Down}
Capslock & b::SendInput {Blind}{BS Down}
Capslock & BS::SendInput {Blind}{BS Down}


; Make Capslock & Enter equivalent to Control+Enter
Capslock & Enter::SendInput {Ctrl down}{Enter}{Ctrl up}


; Make Capslock & Alt Equivalent to Control+Alt
!Capslock::SendInput {Ctrl down}{Alt Down}
!Capslock up::SendInput {Ctrl up}{Alt up}


; Capslock + TAB/; (prev/next tab)

Capslock & ;::SendInput {Ctrl Down}{Tab Down}
Capslock & ; up::SendInput {Ctrl Up}{Tab Up}
Capslock & Tab::SendInput {Ctrl Down}{Shift Down}{Tab Down}
Capslock & Tab up::SendInput {Ctrl Up}{Shift Up}{Tab Up}

; Capslock + w/v (undo/redo)

Capslock & w::SendInput {Ctrl Down}{z Down}
Capslock & w up::SendInput {Ctrl Up}{z Up}
Capslock & v::SendInput {Ctrl Down}{y Down}
Capslock & v up::SendInput {Ctrl Up}{y Up}


; Make Capslock+Space -> Enter
Capslock & Space::SendInput {Enter Down}


; Numpad using Ctrl+Shift+Alt + m,.jkluio or space
+^!Space:: SendInput {Numpad0}
+^!m:: SendInput {Numpad1}
+^!w:: SendInput {Numpad2}
+^!v:: SendInput {Numpad3}
+^!h:: SendInput {Numpad4}
+^!t:: SendInput {Numpad5}
+^!n:: SendInput {Numpad6}
+^!g:: SendInput {Numpad7}
+^!c:: SendInput {Numpad8}
+^!r:: SendInput {Numpad9}


; Make Win Key + Capslock work like Capslock (in case it's ever needed)
#Capslock::
If GetKeyState("CapsLock", "T") = 1
    SetCapsLockState, AlwaysOff
Else 
    SetCapsLockState, AlwaysOn
Return





; Drag windows anywhere
;
; This script modified from the original: http://www.autohotkey.com/docs/scripts/EasyWindowDrag.htm
; by The How-To Geek
; http://www.howtogeek.com 

Capslock & LButton::
CoordMode, Mouse  ; Switch to screen/absolute coordinates.
MouseGetPos, EWD_MouseStartX, EWD_MouseStartY, EWD_MouseWin
WinGetPos, EWD_OriginalPosX, EWD_OriginalPosY,,, ahk_id %EWD_MouseWin%
WinGet, EWD_WinState, MinMax, ahk_id %EWD_MouseWin% 
if EWD_WinState = 0  ; Only if the window isn't maximized 
    SetTimer, EWD_WatchMouse, 10 ; Track the mouse as the user drags it.
return

EWD_WatchMouse:
GetKeyState, EWD_LButtonState, LButton, P
if EWD_LButtonState = U  ; Button has been released, so drag is complete.
{
    SetTimer, EWD_WatchMouse, off
    return
}
GetKeyState, EWD_EscapeState, Escape, P
if EWD_EscapeState = D  ; Escape has been pressed, so drag is cancelled.
{
    SetTimer, EWD_WatchMouse, off
    WinMove, ahk_id %EWD_MouseWin%,, %EWD_OriginalPosX%, %EWD_OriginalPosY%
    return
}
; Otherwise, reposition the window to match the change in mouse coordinates
; caused by the user having dragged the mouse:
CoordMode, Mouse
MouseGetPos, EWD_MouseX, EWD_MouseY
WinGetPos, EWD_WinX, EWD_WinY,,, ahk_id %EWD_MouseWin%
SetWinDelay, -1   ; Makes the below move faster/smoother.
WinMove, ahk_id %EWD_MouseWin%,, EWD_WinX + EWD_MouseX - EWD_MouseStartX, EWD_WinY + EWD_MouseY - EWD_MouseStartY
EWD_MouseStartX := EWD_MouseX  ; Update for the next timer-call to this subroutine.
EWD_MouseStartY := EWD_MouseY
return