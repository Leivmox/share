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

; --- 4. 读取外部配置 ---
global ConfigFile := A_ScriptDir "\config.ini"
global TerminalPath := ""

; 如果配置文件存在，则读取其中的路径
if FileExist(ConfigFile) {
    ; 参数：IniRead(文件名, 段落名, 键名, 找不到时的默认值)
    TerminalPath := IniRead(ConfigFile, "Settings", "TerminalPath", "")
}

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
; 【全局键位替换层】
; ==================================================================

; --- Backspace 與 \ 互換 ---
SC00E::\           ; 將物理 Backspace (SC00E) 映射為 \ (按 Shift 自動出 |)
SC02B::Backspace   ; 將物理 \ (SC02B) 映射為 Backspace


; ==================================================================
; 【控制与增强层】 (完全依赖物理 CapsLock: SC03A)
; ==================================================================

; --- 单按 CapsLock(SC03A) 变 Esc (保留组合键穿透) ---
*SC03A:: {
    if GetKeyState("Shift", "P")
        SendInput("+{Esc}")
    else if GetKeyState("Ctrl", "P")
        SendInput("^{Esc}")
    else
        SendInput("{Esc}")
}

; --- 强制切输入法 ---
SC03A & SC039:: {      ; CapsLock + 物理 Space (SC039)
    if WinExist("A")
        DllCall("PostMessage", "Ptr", WinExist("A"), "UInt", 0x50, "Ptr", 0, "Ptr", EnglishID)
}

SC03A & SC038:: {      ; CapsLock + 物理 左Alt (SC038)
    if WinExist("A")
        DllCall("PostMessage", "Ptr", WinExist("A"), "UInt", 0x50, "Ptr", 0, "Ptr", ChineseID)
}

; --- 导航层 (物理 QWERTY 上的 H J K L 位置) ---
SC03A & SC032::Send "{Backspace}" ;
SC03A & SC00E::SendInput("{Delete}") ;

SC03A & SC023::SendInput("{Left}") ; 物理 H
SC03A & SC024::SendInput("{Down}") ; 物理 J
SC03A & SC025::SendInput("{Up}") ; 物理 K
SC03A & SC026::SendInput("{Right}") ; 物理 L

; --- 快捷编辑层 (完全依赖物理 QWERTY 位置，适配 Colemak-DH 习惯) ---
SC03A & SC01E::SendInput("^a")      ; 物理 A -> 全选
SC03A & SC02D::SendInput("^c")      ; 物理 X -> 复制 (Ctrl+C)
SC03A & SC02F::SendInput("^v")      ; 物理 V -> 粘贴 (Ctrl+V)
SC03A & SC02C::SendInput("^x")      ; 物理 Z -> 剪切 (Ctrl+X)
SC03A & SC030::SendInput("^z")      ; 物理 B -> 撤销 (Ctrl+Z)
SC03A & SC022::SendInput("^+z")     ; 物理 G -> 重做 (Ctrl+Shift+Z)
SC03A & SC020::SendInput("^s")      ; 物理 D -> 保存 (Ctrl+S)
SC03A & SC012::SendInput("^f")      ; 物理 E -> 查找 (Ctrl+F)
SC03A & SC011::SendInput("^w")      ; 物理 W -> 关闭标签页 (Ctrl+W)
SC03A & SC01F::SendInput("^r")      ; 物理 S -> 刷新当前页面 (Ctrl+R)

; --- 标点符号区 ---
SC03A & SC033:: {      ; CapsLock + 物理 , (SC033)
    SendInput("{Text}《》")
    SendInput("{Left}")
}
SC03A & SC034::SendInput("{Text}。")  ; CapsLock + 物理 . (SC034)
SC03A & SC035::SendInput("{Text}¿")   ; CapsLock + 物理 / (SC035)


; ==================================================================
; 【符号映射层】 (完全依赖物理右 Alt 和物理 QWERTY 位置)
; ==================================================================

; --- 右 Alt + 原 CapsLock 输出 ~ ---
>!SC03A::SendInput("{Text}~")       ; 物理 CapsLock (SC03A)

; --- 右 Alt + A S D F G H J K L ; (物理位置) 输出 !@#$%^&*() ---
>!SC01E::SendInput("{Text}!")  ; 物理 A
>!SC01F::SendInput("{Text}@")  ; 物理 S
>!SC020::SendInput("{Text}#")  ; 物理 D
>!SC021::SendInput("{Text}$")  ; 物理 F
>!SC022::SendInput("{Text}%")  ; 物理 G
>!SC023::SendInput("{Text}^")  ; 物理 H
>!SC024::SendInput("{Text}&")  ; 物理 J
>!SC025::SendInput("{Text}*")  ; 物理 K

SC03A & SC027::SendInput("{Text}(")  ; CapsLock + 物理 ; (SC027)
SC03A & SC028::SendInput("{Text})")  ; CapsLock + 物理 ' (SC028)

; --- 右 Alt + Q W E R (物理位置) 输出 _ - + = ---
>!SC010::SendInput("{Text}_")  ; 物理 Q
>!SC011::SendInput("{Text}-")  ; 物理 W
>!SC012::SendInput("{Text}+")  ; 物理 E
>!SC013::SendInput("{Text}=")  ; 物理 R

; --- Capslock + U I O P (物理位置) 输出 [ ] { } ---
SC03A & SC016::SendInput("[")  ; 物理 U (SC016)
SC03A & SC017::SendInput("]")  ; 物理 I (SC017)
SC03A & SC018::SendInput("{Text}{")  ; 物理 O (SC018)
SC03A & SC019::SendInput("{Text}}")  ; 物理 P (SC019)


; ==================================================================
; 【全局快捷键区】 (系统级工具)
; ==================================================================

; Win + 物理 E 键 (SC012) -> 打开资源管理器
#SC012::Run "explorer"

; 左Alt(<! ) + 物理 Q 键(SC010) -> 关闭当前窗口
<!SC010:: {
    if !WinExist("A")
        return
    class := WinGetClass("A")
    if (class ~= "Progman|WorkerW")
        return
    WinClose("A")
}

; Ctrl(^) + 左Alt(<! ) + 物理 Q 键(SC010) -> 最小化当前窗口
^<!SC010::WinMinimize("A")

; Ctrl(^) + 左Alt(<! ) + 物理 F 键 (SC021, 即 Colemak 的 t) -> 打开配置的终端，否则打开 CMD
^<!SC021:: {
    ; 如果配置文件里写了路径，并且这个路径里的文件确实存在
    if (TerminalPath != "" && FileExist(TerminalPath)) {
        Run(TerminalPath)
    } else {
        ; 降级方案：以管理员身份运行系统自带的 cmd.exe
        Run("cmd.exe")
    }
}


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