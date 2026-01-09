<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

echo "<h1>Test Donation Payment</h1>";
echo "<p>This file is working!</p>";

echo "<h2>GET Parameters Received:</h2>";
echo "<pre>";
print_r($_GET);
echo "</pre>";

echo "<h2>Test Billplz Connection:</h2>";

$api_key = '10522a74-03f1-4fcf-b8f4-57236cb6aab2';
$host = 'https://www.billplz-sandbox.com/api/v3/bills';

$test_data = array(
    'collection_id' => 'j2cv81ts',
    'email' => 'test@example.com',
    'mobile' => '0123456789',
    'name' => 'Test User',
    'amount' => 5000,
    'description' => 'Test Donation'
);

$process = curl_init($host);
curl_setopt($process, CURLOPT_HEADER, 0);
curl_setopt($process, CURLOPT_USERPWD, $api_key . ":");
curl_setopt($process, CURLOPT_TIMEOUT, 30);
curl_setopt($process, CURLOPT_RETURNTRANSFER, 1);
curl_setopt($process, CURLOPT_SSL_VERIFYHOST, 0);
curl_setopt($process, CURLOPT_SSL_VERIFYPEER, 0);
curl_setopt($process, CURLOPT_POSTFIELDS, http_build_query($test_data));

$return = curl_exec($process);
$curl_error = curl_error($process);
curl_close($process);

echo "<p><strong>Curl Error:</strong> " . ($curl_error ?: "None") . "</p>";
echo "<p><strong>Response:</strong></p>";
echo "<pre>" . $return . "</pre>";
?>
```

Now **test it directly** in your browser:
```
https://socstudentmusicforlife.com/nad/pawpal/api/test_donation.php