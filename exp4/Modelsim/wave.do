onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -height 30 -radix binary /exp4_sensor_tb/dut/clock
add wave -noupdate -height 20 -expand -group Inputs -color yellow -height 30 -radix binary /exp4_sensor_tb/dut/reset
add wave -noupdate -height 20 -expand -group Inputs -color yellow -height 30 -radix binary /exp4_sensor_tb/dut/medir
add wave -noupdate -height 20 -expand -group {Sinais de medicao} -color blue -height 30 -radix binary /exp4_sensor_tb/dut/trigger
add wave -noupdate -height 20 -expand -group {Sinais de medicao} -color blue -height 30 -radix binary /exp4_sensor_tb/dut/echo
add wave -noupdate -height 20 -expand -group {Sinais de medicao} -color blue -height 30 -radix binary /exp4_sensor_tb/dut/fim_medicao
add wave -noupdate -height 20 -expand -group {Sinais de medicao} -color blue -height 30 -radix binary /exp4_sensor_tb/dut/s_fim_transmissao
add wave -noupdate -height 20 -expand -group {Sinais de depuracao} -color magenta -height 30 -radix decimal /exp4_sensor_tb/dut/s_estado
add wave -noupdate -height 20 -expand -group {Sinais de depuracao} -color magenta -height 30 /exp4_sensor_tb/dut/medida
add wave -noupdate -height 20 -expand -group {Sinais de depuracao} -color magenta -height 30 -radix hexadecimal /exp4_sensor_tb/dut/exp4_fd/s_medida_ascii
add wave -noupdate -height 20 -expand -group {Sinais de depuracao} -color magenta -height 30 -radix binary /exp4_sensor_tb/dut/saida_serial
add wave -noupdate -height 20 -expand -group {Sinais de fim} -color white -height 30 -radix binary /exp4_sensor_tb/dut/exp4_fd/serial/U2_UC/tick
add wave -noupdate -height 20 -expand -group {Sinais de fim} -color white -height 30 -radix binary /exp4_sensor_tb/dut/pronto
add wave -noupdate -height 20 -expand -group {Sinais de fim} -color white -height 30 -radix binary /exp4_sensor_tb/dut/s_fim_contador
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1330933 ns} 0}
quietly wave cursor active 1
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
WaveRestoreZoom {15592672 ns} {21821597 ns}
