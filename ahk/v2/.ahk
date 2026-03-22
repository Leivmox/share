#Requires AutoHotkey v2.0
#SingleInstance Force

InstallKeybdHook()
SetWorkingDir(A_ScriptDir)
A_MaxHotkeysPerInterval := 200

; --- 初始化設置 ---
SetCapsLockState("AlwaysOff")

; ==================================================================
; 【Colemak-DH 映射區 & 全局按鍵替換】 (全局永久生效)
; ==================================================================

; --- Backspace 與 \ 互換 ---
SC00E::\           ; 將物理 Backspace (SC00E) 映射為 \ (按 Shift 自動出 |)
SC02B::Backspace   ; 將物理 \ (SC02B) 映射為 Backspace

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
; SC02f (V) 保持不變
SC030::z
SC031::k
SC032::h

; ==================================================================
; 【控制層 1】 (CapsLock 變 Esc & 組合鍵)
; ==================================================================

; 單按 CapsLock 發送 Esc
CapsLock::Send "{Esc}"

; --- CapsLock 組合鍵 ---
; 退格 (QWERTY 的 M 鍵)
CapsLock & SC032::Send "{Backspace}"

; hjkl 方向鍵 (QWERTY 的 H J K L)
CapsLock & SC023::Send "{Left}"
CapsLock & SC024::Send "{Down}"
CapsLock & SC025::Send "{Up}"
CapsLock & SC026::Send "{Right}"

; 括號區塊 (QWERTY 的 U I O P)
CapsLock & SC016::Send "["
CapsLock & SC017::Send "]"
CapsLock & SC018::Send "{{}"
CapsLock & SC019::Send "{}}"

; 括號區塊 (QWERTY 的 ; ')
CapsLock & SC027::Send "("
CapsLock & SC028::Send ")"

; ==================================================================
; 標點符號區塊 (QWERTY 的 , . / 分別對應 SC033, SC034, SC035)
; ==================================================================
CapsLock & SC033:: {
    SendText "《》"
    Send "{Left}"    ; 自動將游標移到書名號中間
}

CapsLock & SC034::SendText "。"

CapsLock & SC035::SendText "¿"

; ==================================================================
; 【控制層 2】 (Right Alt 組合鍵)
; ==================================================================

; 右 Alt + 原 CapsLock 輸出 ~ (CapsLock 對應 SC03A)
;RAlt & SC03A::SendText "~"

; QWERTY 的 Q, W, E, R 分別對應 SC010, SC011, SC012, SC013
RAlt & SC010::SendText "_"
RAlt & SC011::SendText "-"
RAlt & SC012::SendText "+"
RAlt & SC013::SendText "="

; QWERTY 的 A, S, D, F, G, H, J, K 分別對應 SC01E 到 SC025
; 使用 SendText 原生輸出符號
RAlt & SC01E::SendText "!"
RAlt & SC01F::SendText "@"
RAlt & SC020::SendText "#"
RAlt & SC021::SendText "$"
RAlt & SC022::SendText "%"
RAlt & SC023::SendText "^"
RAlt & SC024::SendText "&"
RAlt & SC025::SendText "*"

; ==================================================================
; 【系統快捷鍵層】 (Win 鍵與 Left Alt 組合)
; ==================================================================

; Win + 物理 E 鍵 (SC012) 打開資源管理器
#SC012::Run "explorer"

; 左 Alt + 物理 Q 鍵 (SC010) 發送 Alt + F4 關閉當前窗口
<!SC010::Send "!{F4}"