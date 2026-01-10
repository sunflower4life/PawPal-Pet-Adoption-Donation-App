<?php
// Billplz callback handler - just acknowledge receipt
error_reporting(0);

// Log callback data for debugging
$logfile = 'billplz_callback.log';
$logdata = date('Y-m-d H:i:s') . " - Callback received: " . json_encode($_GET) . "\n";
file_put_contents($logfile, $logdata, FILE_APPEND);

// Always respond with 200 OK to Billplz
http_response_code(200);
echo "OK";
?>