onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -height 20 /sensor_tb/UUT/exp5_fd/serial/clock
add wave -noupdate -height 20 /sensor_tb/ligar_in
add wave -noupdate -height 20 /sensor_tb/echo_in
add wave -noupdate -height 20 /sensor_tb/trigger_out
add wave -noupdate -height 20 /sensor_tb/s_fim_posicao_out
add wave -noupdate -height 15 -expand -group serial -color magenta -height 20 /sensor_tb/UUT/exp5_fd/serial/dados_ascii
add wave -noupdate -height 15 -expand -group serial -color magenta -height 20 /sensor_tb/UUT/exp5_fd/serial/saida_serial
add wave -noupdate -height 15 -expand -group serial -color magenta -height 20 /sensor_tb/UUT/exp5_fd/serial/pronto
add wave -noupdate -height 15 -expand -group serial -color magenta -height 20 /sensor_tb/UUT/exp5_fd/serial/partida
add wave -noupdate -height 15 -expand -group serial -color magenta -height 20 /sensor_tb/UUT/exp5_fd/serial/s_tick
add wave -noupdate -height 15 -expand -group serial -color magenta -height 20 /sensor_tb/UUT/exp5_fd/serial/s_conta
add wave -noupdate -height 15 -expand -group {contador serial} -color blue -height 20 /sensor_tb/UUT/exp5_fd/CONTADOR_SERIAL/Q
add wave -noupdate -height 15 -expand -group {contador serial} -color blue -height 20 /sensor_tb/UUT/exp5_fd/CONTADOR_SERIAL/conta
add wave -noupdate -height 15 -expand -group {contador serial} -color blue -height 20 /sensor_tb/UUT/exp5_fd/CONTADOR_SERIAL/fim
add wave -noupdate -height 15 -expand -group pwm -color yellow -height 20 /sensor_tb/UUT/exp5_fd/SERVO/s_posicao
add wave -noupdate -height 15 -expand -group pwm -color yellow -height 20 /sensor_tb/UUT/exp5_fd/SERVO/s_controle
add wave -noupdate -height 15 -expand -group pwm -color yellow -height 20 /sensor_tb/UUT/exp5_fd/SERVO/s_reset
add wave -noupdate -height 15 -expand -group {contador up-down} -color white -height 20 /sensor_tb/UUT/exp5_fd/UPDOWN/zera_as
add wave -noupdate -height 15 -expand -group {contador up-down} -color white -height 20 /sensor_tb/UUT/exp5_fd/UPDOWN/conta
add wave -noupdate -height 15 -expand -group {contador up-down} -color white -height 20 /sensor_tb/UUT/exp5_fd/UPDOWN/Q
add wave -noupdate -height 15 -expand -group {contador up-down} -color white -height 20 /sensor_tb/UUT/exp5_fd/UPDOWN/fim
add wave -noupdate -height 15 -expand -group {contador intervalo} -color Orange /sensor_tb/UUT/exp5_fd/CONT_INTERVALO/conta
add wave -noupdate -height 15 -expand -group {contador intervalo} -color Orange /sensor_tb/UUT/exp5_fd/CONT_INTERVALO/Q
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
WaveRestoreZoom {0 ns} {99039 ns}
