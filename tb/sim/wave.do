onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb/PIPE/PCLK
add wave -noupdate /tb/PIPE/Reset
add wave -noupdate /tb/LPIF/pl_linkup
add wave -noupdate /tb/LPIF/lp_data
add wave -noupdate /tb/LPIF/lp_valid
add wave -noupdate /tb/LPIF/lp_irdy
add wave -noupdate /tb/LPIF/pl_trdy
add wave -noupdate /tb/LPIF/lp_tlp_start
add wave -noupdate /tb/LPIF/lp_tlp_end
add wave -noupdate /tb/LPIF/lp_dllp_start
add wave -noupdate /tb/LPIF/lp_dllp_end
add wave -noupdate /tb/LPIF/lp_tlpedb
add wave -noupdate /tb/LPIF/pl_data
add wave -noupdate /tb/LPIF/pl_valid
add wave -noupdate /tb/LPIF/pl_tlp_start
add wave -noupdate /tb/LPIF/pl_tlp_end
add wave -noupdate /tb/LPIF/pl_dllp_start
add wave -noupdate /tb/LPIF/pl_dllp_end
add wave -noupdate /tb/LPIF/pl_tlpedb
add wave -noupdate /tb/PIPE/PhyStatus
add wave -noupdate /tb/PIPE/TxDetectRxLoopback
add wave -noupdate -radix binary /tb/LPIF/lp_state_req
add wave -noupdate /tb/LPIF/pl_state_sts
add wave -noupdate /tb/PIPE/RxStatus
add wave -noupdate /tb/PIPE/PowerDown
add wave -noupdate /tb/LPIF/reset
add wave -noupdate /tb/PIPE/TxElecIdle
add wave -noupdate /tb/PIPE/RxData
add wave -noupdate /tb/PIPE/RxDataK
add wave -noupdate /tb/PIPE/RxDataValid
add wave -noupdate /tb/PIPE/RxStartBlock
add wave -noupdate /tb/PIPE/RxSyncHeader
add wave -noupdate /tb/PIPE/TxData
add wave -noupdate /tb/PIPE/TxDataK
add wave -noupdate /tb/PIPE/TxDataValid
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {15 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 149
configure wave -valuecolwidth 156
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {7 ns} {29 ns}
