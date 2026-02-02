; ==================================================================
; AHK 笔记本通用版: Colemak-DH + 增强层
; ==================================================================

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
global ColemakEnabled := true  ; 默认开启 Colemak
global EnglishID := 0x04090409 
global ChineseID := 0x08040804 


; ==================================================================
; 【控制区】 模式切换
; ==================================================================

; CapsLock + q -> 关闭 Colemak (变回 QWERTY)
CapsLock & q::
    ColemakEnabled := false
    ShowTip("QWERTY 标准模式")
    DllCall("PostMessage", "Ptr", WinExist("A"), "UInt", 0x50, "Ptr", 0, "Ptr", EnglishID)
return

; CapsLock + w -> 开启 Colemak
CapsLock & w::
    ColemakEnabled := true
    ShowTip("Colemak-DH 开启")
return

; CapsLock + 空格 -> 强制切英文
CapsLock & Space::
    DllCall("PostMessage", "Ptr", WinExist("A"), "UInt", 0x50, "Ptr", 0, "Ptr", EnglishID)
return

; CapsLock + Alt -> 切中文
CapsLock & LAlt::
    DllCall("PostMessage", "Ptr", WinExist("A"), "UInt", 0x50, "Ptr", 0, "Ptr", ChineseID)
return


; ==================================================================
; 【Colemak 映射区】 核心逻辑
; ==================================================================
; 生效条件：变量开启 (移除 CS2 判断，全局生效)
#If (ColemakEnabled)

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

#If ; --- Colemak 结束 ---


; ==================================================================
; 【增强功能区】 导航/编辑/系统 (全局生效)
; ==================================================================
; 移除 #If !WinActive("ahk_exe cs2.exe")，使其在任何软件下都可用

    ; --- CapsLock 单按变 Esc ---
    CapsLock::SendInput {Blind}{Esc}

    ; --- NEW: CapsLock + A 切换大小写锁定 ---
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

; --- 导航层 (强烈建议：物理 HJKL) ---
    ; 只要你手指放在主行上，不用动就能按到
    CapsLock & SC023::SendInput {Left}   ; 物理 H
    CapsLock & SC024::SendInput {Down}   ; 物理 J
    CapsLock & SC025::SendInput {Up}     ; 物理 K
    CapsLock & SC026::SendInput {Right}  ; 物理 L
    
    ; --- 编辑 ---
    CapsLock & SC02E::SendInput ^{Insert} ; 物理 C 复制
    CapsLock & SC02F::SendInput +{Insert} ; 物理 V 粘贴
    CapsLock & Backspace::SendInput {Delete}

  ; --- [新增] 标点符号区 (使用 CapsLock 触发) ---
    ; CapsLock + , -> 书名号并回退光标 (方便输入内容)
    CapsLock & ,::
        SendInput {Text}《》
        SendInput {Left}
    return

    ; CapsLock + . -> 中文句号 (即使在英文模式下也能打出)
    CapsLock & .::SendInput {Text}。

    ; CapsLock + / -> 倒问号
    CapsLock & /::SendInput {Text}¿ 

    ; --- 系统快捷键 (右Alt) ---
    ; 使用 DllCall 直接调用系统锁屏，避免 Win 键卡死
    >!SC026::DllCall("User32\LockWorkStation")
    >!SC019::Send #p  ; 右Alt + 物理 P -> 投影 (Win+P)

; ==================================================================
; 【全局快捷键】
; ==================================================================
!q::
    WinGetClass, class, A
    if (class ~= "Progman|WorkerW")
        return
    WinClose, A
return

#SC012::Send #e

; 笔记本通用修改：
; 1. 最小化当前窗口
^!q::WinMinimize, A

; 2. 打开终端 (改为系统路径，避免笔记本无D盘报错)
; 如果安装了 Windows Terminal，wt.exe 通常在环境变量中
; 如果没有，可以改为 powershell.exe
^!t::Run, "D:\Windows\WindowsTerminal\wt.exe"


; --- 辅助函数 ---
ShowTip(Text) {
    Tooltip, [%Text%]
    SetTimer, RemoveTooltip, -1000
}

RemoveTooltip:
    Tooltip
return