set ns [new Simulator]
set tracefile [open n6.tr w]
set namfile [open n6.nam w]

$ns trace-all $tracefile
$ns namtrace-all $namfile


set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]


$ns duplex-link $n0 $n1 100.0Mb 10ms DropTail
$ns queue-limit $n0 $n1 50

$ns duplex-link $n0 $n2 100.0Mb 10ms DropTail
$ns queue-limit $n0 $n2 50

$ns duplex-link $n0 $n3 100.0Mb 10ms DropTail
$ns queue-limit $n0 $n3 50

$ns duplex-link $n1 $n2 100.0Mb 10ms DropTail
$ns queue-limit $n1 $n2 50

$ns duplex-link $n1 $n4 100.0Mb 10ms DropTail
$ns queue-limit $n1 $n4 50

$ns duplex-link $n2 $n4 100.0Mb 10ms DropTail
$ns queue-limit $n2 $n4 50


$ns duplex-link-op $n0 $n1 orient right
$ns duplex-link-op $n0 $n2 orient right-down
$ns duplex-link-op $n0 $n3 orient down
$ns duplex-link-op $n1 $n2 orient left-down
$ns duplex-link-op $n1 $n4 orient down
$ns duplex-link-op $n2 $n4 orient right-down


$ns cost $n0 $n1 9
$ns cost $n0 $n2 1
$ns cost $n0 $n3 9

$ns cost $n1 $n2 9
$ns cost $n1 $n4 9

$ns cost $n2 $n4 1


set tcp [new Agent/TCP]
$ns attach-agent $n0 $tcp
set sink [new Agent/TCPSink]
$ns attach-agent $n4 $sink

$ns connect $tcp $sink
$tcp set fid_ 1

$tcp set packetSize_ 1500


set ftp [new Application/FTP]
$ftp attach-agent $tcp
$ftp set packetSize_ 1000
$ftp set rate_ 1.0Mb

$ns at 1.0 "$ftp start"
$ns at 5.0 "$ftp stop"
$ns at 10.0 "finish"

$ns color 1 Red


$ns rtproto LS

proc finish {} {
	global ns tracefile namfile
	$ns flush-trace
	close $tracefile
	close $namfile
	exec nam n6.nam &
	exit 0
}
$ns run
