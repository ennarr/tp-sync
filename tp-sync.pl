#!/usr/bin/perl

use Expect;

# Example sesion:
#
# $ telnet x
# Trying x...
# Connected to x.
# Escape character is '^]'.
# 
# Password: **********
# Copyright (c) 2001 - 2012 TP-LINK TECHNOLOGIES CO., LTD
# TP-LINK> wan adsl c
# near-end interleaved channel bit rate: 10313 kbps
# near-end fast channel bit rate: 0 kbps
# far-end interleaved channel bit rate: 1293 kbps
# far-end fast channel bit rate: 0 kbps
# TP-LINK> exit

$timeout = 20;
$host = $ARGV[0];
$login_pass = $ARGV[1];
$prompt="TP-LINK>";
$command="wan adsl c";
my $exp = Expect->spawn("telnet $host")
 or die "Cannot spawn $command: $!\n";
$exp->log_user(0);
$exp->expect($timeout, "Password:");
$exp->send("$login_pass\r");
$exp->expect($timeout, $prompt);
$exp->send("$command\r");
$exp->expect($timeout, $prompt);
$out = $exp->before();
@rates;
$x = 0;
while ($out =~ /(\d+)/g) {
    $rates[$x] = $1;
    $x++;
}
print "dir:$rates[0] dfr:$rates[1] uir:$rates[2] ufr:$rates[3]\n";
$exp->send("exit\r");
$exp->soft_close();
