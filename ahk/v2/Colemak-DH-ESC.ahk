#Requires AutoHotkey v2.0
#SingleInstance Force
InstallKeybdHook()
SetWorkingDir(A_ScriptDir)
A_MaxHotkeysPerInterval := 200

; --- 初始化設置 ---
SetCapsLockState("AlwaysOff")

; ==================================================================
; 【Colemak-DH 映射區】 核心邏輯 (全局永久生效)
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
; SC02f (V) 保持不變
SC030::z
SC031::k
SC032::h

; ==================================================================
; 【控制層】 (CapsLock 變 Esc)
; ==================================================================

; --- 簡單粗暴：將 CapsLock 徹底替換為 Esc ---
CapsLock::Esc