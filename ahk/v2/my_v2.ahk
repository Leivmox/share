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
; 【全局快捷键】(不受 CS2 影响，照常生效)
; ==================================================================
!q:: {
    ; v2 中获取类名如果找不到窗口会报错，加个判断更稳健
    if !WinExist("A")
        return
    class := WinGetClass("A")
    if (class ~= "Progman|WorkerW")
        return
    WinClose("A")
}

; 原物理 E 位置 -> 对应 Colemak 的 f
#f::Run "explorer"
^!q::WinMinimize("A")
^!t::Run("D:\Windows\WindowsTerminal\wt.exe")

; ==================================================================
; 【开发工具专属区】 VS Code / Windows Terminal / IDEA
; ==================================================================
#HotIf WinActive("ahk_exe Code.exe") or WinActive("ahk_exe WindowsTerminal.exe") or WinActive("ahk_exe idea64.exe")
    ; 单按 Esc：发送 Esc 功能，并强制切换到英文
    Esc:: {
        SendInput("{Esc}")
        if WinExist("A")
            DllCall("PostMessage", "Ptr", WinExist("A"), "UInt", 0x50, "Ptr", 0, "Ptr", EnglishID)
    }
#HotIf ; --- 开发工具专属区结束 ---

; ==================================================================
; 【非 CS2 环境生效区】 (包含原来的控制区与增强功能区)
; ==================================================================
#HotIf !WinActive("ahk_exe cs2.exe")
    ; --- 控制区：模式切换 (原本的 CapsLock 现已全面替换为 Esc) ---
    ; Esc + 空格 -> 强制切英文
    Esc & Space:: {
        if WinExist("A")
            DllCall("PostMessage", "Ptr", WinExist("A"), "UInt", 0x50, "Ptr", 0, "Ptr", EnglishID)
    }

    ; Esc + Alt -> 切中文
    Esc & LAlt:: {
        if WinExist("A")
            DllCall("PostMessage", "Ptr", WinExist("A"), "UInt", 0x50, "Ptr", 0, "Ptr", ChineseID)
    }

    ; --- 单按 Esc 恢复正常 Esc 功能 (不切输入法) ---
    *Esc:: {
        if GetKeyState("Shift", "P")
            SendInput("+{Esc}")
        else if GetKeyState("Ctrl", "P")
            SendInput("^{Esc}")
        else
            SendInput("{Esc}")
    }

; --- 导航层 (硬件 Colemak 布局下的物理 HJKL 位置，实际输出的是 m n e i) ---
    Esc & m::SendInput("{Left}")
    Esc & n::SendInput("{Down}")
    Esc & e::SendInput("{Up}")
    Esc & i::SendInput("{Right}")
    
    ; --- 编辑层 ---
    Esc & a::SendInput("^a")             ; 全选
    Esc & c::SendInput("^c")             ; Ctrl+C
    Esc & v::SendInput("^v")             ; Ctrl+V
    Esc & z::SendInput("^z")             ; 撤销
    Esc & s::SendInput("^s")             ; 保存
    Esc & x::SendInput("^x")             ; 剪切
    Esc & f::SendInput("^f")             ; 查找
    Esc & g::SendInput("^+z")            ; 重做
    Esc & w::SendInput("^w")             ; 关闭标签页

    
    ; --- 特殊功能键 ---
    Esc & h::SendInput("{Backspace}")    ; 退格方案
    Esc & Backspace::SendInput("^{Backspace}")
    Esc & Insert::SendInput("^{Insert}")
    ;Esc & Backspace::SendInput("{Delete}")
    Esc & Enter::SendInput("{Backspace}")

    ; --- 标点符号区 ---
    Esc & ,:: {
        SendInput("{Text}《》")
        SendInput("{Left}")
    }
    Esc & .::SendInput("{Text}。")
    Esc & /::SendInput("{Text}¿") 

; ====== 符号与括号区 ======
    ; 括号 ()
    Esc & o::SendInput("{Text}(")
    Esc & '::SendInput("{Text})")

    ; 方括号 []
    Esc & l::SendInput("[")
    Esc & u::SendInput("]")

    ; 花括号 {} (注：分号需用反引号 ` 转义，否则会被 AHK 当做注释)
    Esc & y::SendInput("{Text}{")
    Esc & `;::SendInput("{Text}}")

    ; ================================

    ; --- 系统快捷键 (右Alt) ---
    ; 原物理 L 位置 -> 对应 Colemak 的 i
    >!i::DllCall("User32\LockWorkStation")
    ; 原物理 P 位置 -> 对应 Colemak 的 ;
    >!;::Send("#p")  
#HotIf ; --- 非 CS2 环境区结束 ---

; --- 辅助函数 ---
ShowTip(Text) {
    ToolTip("[" Text "]")
    SetTimer(RemoveTooltip, -1000)
}

; v2 中的 Label 变成了函数
RemoveTooltip() {
    ToolTip()
}