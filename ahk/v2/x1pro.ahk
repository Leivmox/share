#Requires AutoHotkey v2.0

; =========================================
; 1. 强制管理员模式
; =========================================
if not A_IsAdmin {
    ; 如果当前没有管理员权限，则请求提权并重新运行当前脚本
    Run '*RunAs "' A_ScriptFullPath '"'
    ExitApp
}

; =========================================
; 2. 按键映射 (基于扫描码 Scan Code)
; =========================================

; 右Alt(>!) + Esc(SC001) 输出 Tab 上面的键 (SC029，即 `)
; 注意：这里用 Send 函数是为了直接输出按键，防止被下面的 SC029 规则拦截变成 Insert
>!SC001::Send "{SC029}"

; SC029 (原来的 ` / ~) 映射为 SC152 (Insert)
SC029::SC152

; SC153 (Delete) 映射为 SC149 (Page Up)
SC153::SC149

; SC149 (Page Up) 映射为 SC151 (Page Down)
SC149::SC151

; SC151 (Page Down) 映射为 SC153 (Delete)
SC151::SC153