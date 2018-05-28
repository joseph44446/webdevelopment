set myNS [new Simulator]
set myTraceFile [open out4.tr w]
$myNS trace-all $myTraceFile
set myNamFile [open out4.nam w]
$myNS namtrace-all $myNamFile

set n0 [$myNS node]
set n1 [$myNS node]
set n2 [$myNS node]
set n3 [$myNS node]
set n4 [$myNS node]
set n5 [$myNS node]
set n6 [$myNS node]
set n7 [$myNS node]


$n0 label "SRC-1"
$n7 label "DST-1"
$n4 label "SRC-2"
$n3 label "DST-2"


$myNS make-lan "$n0 $n1 $n2 $n3 $n4 $n5 $n6 $n7" 3Mb 30ms LL Queue/DropTail Mac/802_3

set tcp1 [new Agent/TCP]
$myNS attach-agent $n0 $tcp1
set sink1 [new Agent/TCPSink]
$myNS attach-agent $n7 $sink1

$myNS connect $tcp1 $sink1
$tcp1 set class_ 1


set tcp2 [new Agent/TCP]
$myNS attach-agent $n4 $tcp2
set sink2 [new Agent/TCPSink]
$myNS attach-agent $n3 $sink2

$myNS connect $tcp2 $sink2
$tcp2 set class_ 2

set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1
$ftp1 set type_ FTP

set ftp2 [new Application/FTP]
$ftp2 attach-agent $tcp2
$ftp2 set type_ FTP

$myNS color 1 "red"
$myNS color 2 "blue"

set outFile1 [open congestion1.xg w]
set outFile2 [open congestion2.xg w]

proc plotWindow {tcpSource outfile} {
	global myNS
	set curTime [$myNS now]
	set curCwnd [$tcpSource set cwnd_]
	puts $outfile "$curTime $curCwnd"
	$myNS at [expr $curTime+0.01] "plotWindow $tcpSource $outfile"
}


$myNS at 0.0 "plotWindow $tcp1 $outFile1"
$myNS at 0.0 "plotWindow $tcp2 $outFile2"
$myNS at 0.1 "$ftp1 start"
$myNS at 0.1 "$ftp2 start"
$myNS at 49.5 "$ftp1 stop"
$myNS at 49.5 "$ftp2 stop"
$myNS at 50.0 "finish"

proc finish {} {
	global myNS myTraceFile myNamFile outFile2
	$myNS flush-trace
	close $myTraceFile
	close $myNamFile
	
	exec nam out4.nam &
	exec xgraph congestion1.xg congestion2.xg -geometry 800x800 &
	
	exit 0
}
$myNS run

