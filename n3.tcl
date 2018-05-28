set ns [new Simulator]
set trfile [open out3.tr w]
set namfile [open out3.nam w]

$ns trace-all $trfile
$ns namtrace-all $namfile

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node]
set n7 [$ns node]
set n8 [$ns node]
set n9 [$ns node]

$ns make-lan "$n0 $n1 $n2 $n3 $n4" 1Mb 10ms LL Queue/DropTail Mac/802_3

$ns make-lan "$n5 $n6 $n7 $n8 $n9" 1Mb 10ms LL Queue/DropTail Mac/802_3

$ns duplex-link $n4 $n5 1Mb 30ms DropTail
$ns duplex-link-op $n4 $n5 orient right-down

$n0 label "TCP"
$n2 label "UDP"
$n7 label "SINK"
$n9 label "NULL"

$ns color 1 blue
$ns color 2 red

set udp [new Agent/UDP]
$ns attach-agent $n2 $udp
set null [new Agent/Null]
$ns attach-agent $n9 $null
$ns connect $udp $null
$udp set fid_ 1

set tcp [new Agent/TCP]
$ns attach-agent $n0 $tcp
set sink [new Agent/TCPSink]
$ns attach-agent $n7 $sink
$ns connect $tcp $sink
$tcp set fid_ 2

set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp

$cbr set packetSize_ 500
$cbr set interval_ 0.005

set ftp [new Application/FTP]
$ftp attach-agent $tcp

$ftp set packetSize_ 500

$ns at 0.1 "$cbr start"
$ns at 1.0 "$ftp start"
$ns at 9.0 "$ftp stop"
$ns at 9.5 "$cbr stop"
$ns at 10.0 "Finish"

proc Finish {} {
	global ns trfile namfile
	$ns flush-trace
	close $trfile
	close $namfile
	exec nam out3.nam &
	exec awk -f n3.awk out3.tr &
	exit 0
}

set error [new ErrorModel]
$ns lossmodel $error $n4 $n5
$error set rate_ 0.1
$ns set datarate_ 5 Mb

$ns run

