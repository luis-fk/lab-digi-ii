onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -color {Spring Green} -height 30 /tx_serial_7N2_tb/clock_in
add wave -noupdate -divider -height 20 Entrada
add wave -noupdate -color white -height 30 -radix binary /tx_serial_7N2_tb/dut/U1_FD/reset
add wave -noupdate -color white -height 30 -radix binary /tx_serial_7N2_tb/dut/U1_FD/U1/entrada_serial
add wave -noupdate -height 30 -radix hexadecimal /tx_serial_7N2_tb/dados_ascii_7_in
add wave -noupdate -divider -height 20 {Sinais de saída}
add wave -noupdate -color magenta -height 30 -radix binary /tx_serial_7N2_tb/dut/s_zera
add wave -noupdate -color magenta -height 30 -radix binary /tx_serial_7N2_tb/dut/s_conta
add wave -noupdate -color magenta -height 30 -radix binary /tx_serial_7N2_tb/dut/s_carrega
add wave -noupdate -color magenta -height 30 -radix binary /tx_serial_7N2_tb/dut/s_desloca
add wave -noupdate -color magenta -height 30 -radix binary /tx_serial_7N2_tb/dut/s_fim
add wave -noupdate -color magenta -height 30 -radix binary /tx_serial_7N2_tb/dut/s_saida_serial
add wave -noupdate -color magenta -height 30 /tx_serial_7N2_tb/dut/U1_FD/s_saida
add wave -noupdate -divider -height 20 {Sinal interno}
add wave -noupdate -radix decimal /tx_serial_7N2_tb/dut/U2_UC/Eatual
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2070 ns} 0}
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
configure wave -timelineunits ns
update
WaveRestoreZoom {393 ns} {2764 ns}
