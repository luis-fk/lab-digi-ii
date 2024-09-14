onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -height 30 -radix binary /interface_hcsr04_tb/dut/clock
add wave -noupdate -color blue -height 30 -radix decimal /interface_hcsr04_tb/dut/db_estado
add wave -noupdate -color yellow -height 30 -radix binary /interface_hcsr04_tb/dut/reset
add wave -noupdate -color yellow -height 30 -radix binary /interface_hcsr04_tb/dut/pronto
add wave -noupdate -color yellow -height 30 -radix binary /interface_hcsr04_tb/dut/medir
add wave -noupdate -color magenta -height 30 -radix binary /interface_hcsr04_tb/dut/echo
add wave -noupdate -color magenta -height 30 -radix binary /interface_hcsr04_tb/dut/trigger
add wave -noupdate -color white -height 30 /interface_hcsr04_tb/dut/medida
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {172770775 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 101
configure wave -valuecolwidth 86
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
configure wave -timelineunits us
update
WaveRestoreZoom {171354430 ns} {172851314 ns}
