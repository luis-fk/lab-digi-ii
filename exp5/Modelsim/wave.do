onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -height 40 /circuito_pwm_tb/clock_in
add wave -noupdate -color white -height 40 /circuito_pwm_tb/largura_in
add wave -noupdate -color blue -height 40 -radix binary /circuito_pwm_tb/pwm_out
add wave -noupdate -color magenta -height 40 -radix decimal /circuito_pwm_tb/caso
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
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
WaveRestoreZoom {0 ns} {382092024 ns}
