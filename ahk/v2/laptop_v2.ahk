#Requires AutoHotkey v2.0
#SingleInstance Force
InstallKeybdHook()
SetWorkingDir(A_ScriptDir)
A_MaxHotkeysPerInterval := 200

; --- 1. 管理员权限 ---
if not A_IsAdmin {
    Run('*RunAs "' A_ScriptFullPath '"')
    ExitApp()
}

; --- 2. 性能优化 ---
ProcessSetPriority("High")
ListLines(false)
KeyHistory(0)

; --- 3. 初始化设置 ---
SetCapsLockState("AlwaysOff")
global EnglishID := 0x04090409 
global ChineseID := 0x08040804 

; ==================================================================
; 【Colemak-DH 映射区】 核心逻辑 (全局永久生效)
; ==================================================================

; --- 第一排 ---
SC012::f
SC013::p
SC014::b
SC015::j
SC016::l
SC017::u
SC018::y
SC019::`;

; --- 第二排 ---
SC01F::r
SC020::s
SC021::t
SC023::m
SC024::n
SC025::e
SC026::i
SC027::o

; --- 第三排 ---
SC02c::x
SC02d::c
SC02e::d
; SC02f (V) 保持不变
SC030::z
SC031::k
SC032::h


; ==================================================================
; 【控制与增强层】 (完全依赖物理 CapsLock)
; ==================================================================

; 退格 (QWERTY 的 M 鍵)
CapsLock & SC032::Send "{Backspace}"

; --- 强制切输入法 ---
CapsLock & Space:: {
    if WinExist("A")
        DllCall("PostMessage", "Ptr", WinExist("A"), "UInt", 0x50, "Ptr", 0, "Ptr", EnglishID)
}

CapsLock & LAlt:: {
    if WinExist("A")
        DllCall("PostMessage", "Ptr", WinExist("A"), "UInt", 0x50, "Ptr", 0, "Ptr", ChineseID)
}

; --- 单按 CapsLock 变 Esc (保留组合键穿透) ---
*CapsLock:: {
    if GetKeyState("Shift", "P")
        SendInput("+{Esc}")
    else if GetKeyState("Ctrl", "P")
        SendInput("^{Esc}")
    else
        SendInput("{Esc}")
}

; --- 导航层 (物理 QWERTY 上的 H J K L 位置) ---
CapsLock & SC023::SendInput("{Left}")   ; 物理 H
CapsLock & SC024::SendInput("{Down}")   ; 物理 J
CapsLock & SC025::SendInput("{Up}")     ; 物理 K
CapsLock & SC026::SendInput("{Right}")  ; 物理 L

; --- 编辑 ---
CapsLock & SC02D::SendInput("^{Insert}") ; 物理 X 复制 (已修改)
CapsLock & SC02F::SendInput("+{Insert}") ; 物理 V 粘贴
CapsLock & Backspace::SendInput("{Delete}")

; --- 标点符号区 ---
CapsLock & ,:: {
    SendInput("{Text}《》")
    SendInput("{Left}")
}
CapsLock & .::SendInput("{Text}。")
CapsLock & /::SendInput("{Text}¿") 

; ==================================================================
; 【符号映射层】 (完全依赖物理右 Alt 和物理 QWERTY 位置)
; ==================================================================

; --- 右 Alt + 原 CapsLock 输出 ~ ---
>!CapsLock::SendInput("{Text}~")

; --- 右 Alt + A S D F G H J K L ; (物理位置) 输出 !@#$%^&*() ---
>!SC01E::SendInput("{Text}!")  ; 物理 A
>!SC01F::SendInput("{Text}@")  ; 物理 S
>!SC020::SendInput("{Text}#")  ; 物理 D
>!SC021::SendInput("{Text}$")  ; 物理 F
>!SC022::SendInput("{Text}%")  ; 物理 G
>!SC023::SendInput("{Text}^")  ; 物理 H
>!SC024::SendInput("{Text}&")  ; 物理 J
>!SC025::SendInput("{Text}*")  ; 物理 K
;>!SC026::SendInput("{Text}(")  ; 物理 L

CapsLock & SC027::SendInput("{Text}(")  ; 物理 ;
CapsLock & SC028::SendInput("{Text})")  ; 物理 '

; --- 右 Alt + Q W E R (物理位置) 输出 _ - + = ---
>!SC010::SendInput("{Text}_")  ; 物理 Q
>!SC011::SendInput("{Text}-")  ; 物理 W
>!SC012::SendInput("{Text}+")  ; 物理 E
>!SC013::SendInput("{Text}=")  ; 物理 R

; --- 右 Alt + U I O P (物理位置) 输出 [ ] { } ---
;>!SC016::SendInput("{Text}[")  ; 物理 U
;>!SC017::SendInput("{Text}]")  ; 物理 I
;>!SC018::SendInput("{Text}{")  ; 物理 O
;>!SC019::SendInput("{Text}}")  ; 物理 P

; --- Capslock + U I O P (物理位置) 输出 [ ] { } ---
CapsLock & SC016::SendInput("{Text}[")  ; 物理 U
CapsLock & SC017::SendInput("{Text}]")  ; 物理 I
CapsLock & SC018::SendInput("{Text}{")  ; 物理 O
CapsLock & SC019::SendInput("{Text}}")  ; 物理 P


; ==================================================================
; 【全局快捷键区】
; ==================================================================
; --- Backspace 與 \ 互換 ---
SC00E::\           ; 將物理 Backspace (SC00E) 映射為 \ (按 Shift 自動出 |)
SC02B::Backspace   ; 將物理 \ (SC02B) 映射為 Backspace


!q:: {
    if !WinExist("A")
        return
    class := WinGetClass("A")
    if (class ~= "Progman|WorkerW")
        return
    WinClose("A")
}

#SC012::Run "explorer"

; 最小化当前窗口
^!q::WinMinimize("A")

; 打开终端
^!t::Run("D:\Windows\WindowsTerminal\wt.exe")


; ==================================================================
; 【辅助函数区】
; ==================================================================

ShowTip(Text) {
    ToolTip("[" Text "]")
    SetTimer(RemoveTooltip, -1000)
}

RemoveTooltip() {
    ToolTip()
}