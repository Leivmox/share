; ==================================================================
; AHK 纯净增强版: 专注快捷键与组合层 (适配硬件 Colemak 布局)
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
; 【控制区】 输入法切换
; ==================================================================

; CapsLock + 空格 -> 强制切英文
CapsLock & Space::
    DllCall("PostMessage", "Ptr", WinExist("A"), "UInt", 0x50, "Ptr", 0, "Ptr", EnglishID)
return

; CapsLock + Alt -> 切中文
CapsLock & LAlt::
    DllCall("PostMessage", "Ptr", WinExist("A"), "UInt", 0x50, "Ptr", 0, "Ptr", ChineseID)
return

; ==================================================================
; 【增强功能区】 导航/编辑/系统 (非 CS2 生效)
; ==================================================================
; 下面这行 #If 决定了：只要在这个区间内的快捷键，如果在 CS2 游戏里就不会生效
#If !WinActive("ahk_exe cs2.exe")

    ; --- CapsLock 单按变 Esc ---
    CapsLock::SendInput {Blind}{Esc}

    ; --- CapsLock + A 切换大小写锁定 ---
    CapsLock & a::
        if GetKeyState("CapsLock", "T") ; 如果当前是大写开启状态
        {
            SetCapsLockState, AlwaysOff ; 强制关闭
            ShowTip("CapsLock: OFF (小写)")
        }
        else
        {
            SetCapsLockState, On      ; 强制开启
            ShowTip("CapsLock: ON (大写)")
        }
    return

    ; --- 导航层 (物理位置 HJKL) ---
    CapsLock & SC023::SendInput {Left}   ; 物理 H 位置
    CapsLock & SC024::SendInput {Down}   ; 物理 J 位置
    CapsLock & SC025::SendInput {Up}     ; 物理 K 位置
    CapsLock & SC026::SendInput {Right}  ; 物理 L 位置
    
    ; --- 编辑 (物理位置 C / V) ---
    CapsLock & SC02E::SendInput ^{Insert} ; 物理 C 复制
    CapsLock & SC02F::SendInput +{Insert} ; 物理 V 粘贴
    CapsLock & Backspace::SendInput {Delete}

    ; --- 标点符号区 ---
    ; CapsLock + , -> 书名号并回退光标
    CapsLock & ,::
        SendInput {Text}《》
        SendInput {Left}
    return

    ; CapsLock + . -> 中文句号
    CapsLock & .::SendInput {Text}。

    ; CapsLock + / -> 倒问号
    CapsLock & /::SendInput {Text}¿ 

    ; --- 系统快捷键 (右Alt) ---
    >!SC026::DllCall("User32\LockWorkStation") ; 右Alt + 物理 L -> 锁屏
    >!SC019::Send #p                           ; 右Alt + 物理 P -> 投影

; Shift + Esc 输出波浪号 ~
+Esc::Send, ~

#If ; --- 增强区结束 ---

; ==================================================================
; 【全局快捷键】
; ==================================================================

; --- NEW: Win + F 打开资源管理器 ---
#f::Run, explorer.exe

!q::
    WinGetClass, class, A
    if (class ~= "Progman|WorkerW")
        return
    WinClose, A
return

^!q::WinMinimize, A
^!t::Run, "D:\Windows\WindowsTerminal\wt.exe"

; --- 辅助函数 ---
ShowTip(Text) {
    Tooltip, [%Text%]
    SetTimer, RemoveTooltip, -1000
}

RemoveTooltip:
    Tooltip
return