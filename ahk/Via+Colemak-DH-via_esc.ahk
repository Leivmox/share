; ==================================================================
; AHK 备用方案: 配合 VIA 硬件级 Colemak-DH 布局使用 (无应用切换)
; ==================================================================
#MaxHotkeysPerInterval 200
#SingleInstance force
#NoEnv
#InstallKeybdHook
SetWorkingDir %A_ScriptDir%

; --- 1. 管理员权限 ---
if not A_IsAdmin
{
    Run *RunAs "%A_ScriptFullPath%"
    ExitApp
}

; --- 2. 性能优化 ---
Process, Priority, , High
SetBatchLines, -1
ListLines Off
#KeyHistory 0

; --- 3. 初始化设置 ---
SetCapsLockState, AlwaysOff
global EnglishID := 0x04090409 
global ChineseID := 0x08040804 

; ==================================================================
; 【全局快捷键】(不受 CS2 影响，照常生效)
; ==================================================================
!q::
    WinGetClass, class, A
    if (class ~= "Progman|WorkerW")
        return
    WinClose, A
return

; 原物理 E 位置 -> 对应 Colemak 的 f
#f::Send #e
^!q::WinMinimize, A
^!t::Run, "D:\Windows\WindowsTerminal\wt.exe"

; ==================================================================
; 【开发工具专属区】 VS Code / Windows Terminal / IDEA
; ==================================================================
#If WinActive("ahk_exe Code.exe") or WinActive("ahk_exe WindowsTerminal.exe") or WinActive("ahk_exe idea64.exe")
    ; 单按 Esc：发送 Esc 功能，并强制切换到英文
    Esc::
        SendInput {Esc}
        DllCall("PostMessage", "Ptr", WinExist("A"), "UInt", 0x50, "Ptr", 0, "Ptr", EnglishID)
    return
#If ; --- 开发工具专属区结束 ---

; ==================================================================
; 【非 CS2 环境生效区】 (包含原来的控制区与增强功能区)
; ==================================================================
#If !WinActive("ahk_exe cs2.exe")
    ; --- 控制区：模式切换 (原本的 CapsLock 现已全面替换为 Esc) ---
    ; Esc + 空格 -> 强制切英文
    Esc & Space::
        DllCall("PostMessage", "Ptr", WinExist("A"), "UInt", 0x50, "Ptr", 0, "Ptr", EnglishID)
    return

    ; Esc + Alt -> 切中文
    Esc & LAlt::
        DllCall("PostMessage", "Ptr", WinExist("A"), "UInt", 0x50, "Ptr", 0, "Ptr", ChineseID)
    return

    ; --- 单按 Esc 恢复正常 Esc 功能 (不切输入法) ---
    ; * 号代表通配符，允许 Ctrl/Shift/Alt + Esc 正常透传
    *Esc::
        if GetKeyState("Shift", "P")
            SendInput +{Esc}
        else if GetKeyState("Ctrl", "P")
            SendInput ^{Esc}
        else
            SendInput {Esc}
    return

    ; --- 导航层 (硬件 Colemak 布局下的物理 HJKL 位置，实际输出的是 m n e i) ---
    Esc & m::SendInput {Left}
    Esc & n::SendInput {Down}
    Esc & e::SendInput {Up}
    Esc & i::SendInput {Right}
    
    ; --- 编辑 (物理位置) -> Colemak 里的 c 和 v 依然是 c 和 v ---
    Esc & c::SendInput ^{Insert}
    Esc & v::SendInput +{Insert}
    Esc & Backspace::SendInput {Delete}

    ; --- 标点符号区 ---
    Esc & ,::
        SendInput {Text}《》
        SendInput {Left}
    return

    Esc & .::SendInput {Text}。
    Esc & /::SendInput {Text}¿ 

    ; --- 系统快捷键 (右Alt) ---
    ; 原物理 L 位置 -> 对应 Colemak 的 i
    >!i::DllCall("User32\LockWorkStation")
    ; 原物理 P 位置 -> 对应 Colemak 的 ;
    >!;::Send #p  
#If ; --- 非 CS2 环境区结束 ---

; --- 辅助函数 ---
ShowTip(Text) {
    Tooltip, [%Text%]
    SetTimer, RemoveTooltip, -1000
}

RemoveTooltip:
    Tooltip
return