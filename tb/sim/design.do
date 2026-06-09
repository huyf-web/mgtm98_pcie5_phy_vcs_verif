onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb/PIPE/PCLK
add wave -noupdate /tb/PIPE/Reset
add wave -noupdate /tb/LPIF/pl_linkup
add wave -noupdate /tb/PIPE/PhyStatus
add wave -noupdate /tb/PIPE/TxDetectRxLoopback
add wave -noupdate -radix binary /tb/LPIF/lp_state_req
add wave -noupdate /tb/LPIF/pl_state_sts
add wave -noupdate /tb/PIPE/RxStatus
add wave -noupdate /tb/PIPE/PowerDown
add wave -noupdate /tb/LPIF/reset
add wave -noupdate /tb/PIPE/TxElecIdle
add wave -noupdate /tb/PIPE/RxData
add wave -noupdate /tb/PIPE/RxDataValid
add wave -noupdate /tb/PIPE/RxDataK
add wave -noupdate /tb/PIPE/TxData
add wave -noupdate /tb/PIPE/TxDataValid
add wave -noupdate /tb/PIPE/TxDataK
add wave -noupdate /tb/dut/mainltssm/linkNumberInTx
add wave -noupdate /tb/dut/mainltssm/linkNumberInRx
add wave -noupdate /tb/dut/mainltssm/writeLinkNumberTx
add wave -noupdate /tb/dut/mainltssm/writeLinkNumberRx
add wave -noupdate /tb/dut/mainltssm/finishTx
add wave -noupdate /tb/dut/mainltssm/finishRx
add wave -noupdate /tb/dut/mainltssm/gotoTx
add wave -noupdate /tb/dut/mainltssm/gotoRx
add wave -noupdate /tb/dut/mainltssm/linkNumberOutTx
add wave -noupdate /tb/dut/mainltssm/linkNumberOutRx
add wave -noupdate /tb/dut/mainltssm/substateTx
add wave -noupdate /tb/dut/mainltssm/substateRx
add wave -noupdate /tb/dut/rx/rxltssm/masterRxLTSSM/substate
add wave -noupdate /tb/dut/rx/rxltssm/masterRxLTSSM/lastState
add wave -noupdate /tb/dut/rx/rxltssm/masterRxLTSSM/currentState
add wave -noupdate /tb/dut/rx/rxltssm/orderedSets
add wave -noupdate /tb/dut/rx/rxltssm/countUp
add wave -noupdate /tb/dut/rx/rxltssm/resetCounters
add wave -noupdate /tb/dut/rx/rxltssm/countersValues
add wave -noupdate -radix unsigned {/tb/dut/rx/rxltssm/genblk1[0]/counter/count}
add wave -noupdate /tb/dut/DEVICETYPE
add wave -noupdate /tb/dut/rx/DEVICETYPE
add wave -noupdate /tb/dut/TX/DEVICETYPE
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {34357 ns} 0}
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
WaveRestoreZoom {34331 ns} {34441 ns}
