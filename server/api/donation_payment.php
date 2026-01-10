<?php
error_reporting(0);

// Get parameters
$email = $_GET['email'];
$phone = $_GET['phone'];
$name = $_GET['name'];
$amount = $_GET['amount'];
$user_id = $_GET['user_id'];
$pet_id = $_GET['pet_id'];
$pet_name = $_GET['pet_name'];

// Billplz API credentials
$api_key = '10522a74-03f1-4fcf-b8f4-57236cb6aab2';
$collection_id = 'j2cv81ts';
$host = 'https://www.billplz-sandbox.com/api/v3/bills';

// Prepare donation data
$data = array(
    'collection_id' => $collection_id,
    'email' => $email,
    'mobile' => $phone,
    'name' => $name,
    'amount' => $amount * 100,
    'description' => 'Donation for ' . $pet_name,
    'callback_url' => "https://socstudentmusicforlife.com/nad/pawpal/api/donation_callback.php",
    'redirect_url' => "https://socstudentmusicforlife.com/nad/pawpal/api/donation_update.php?user_id=$user_id&email=$email&name=$name&phone=$phone&amount=$amount&pet_id=$pet_id&pet_name=$pet_name"
);

// Send request to Billplz
$process = curl_init($host);
curl_setopt($process, CURLOPT_HEADER, 0);
curl_setopt($process, CURLOPT_USERPWD, $api_key . ":");
curl_setopt($process, CURLOPT_TIMEOUT, 30);
curl_setopt($process, CURLOPT_RETURNTRANSFER, 1);
curl_setopt($process, CURLOPT_SSL_VERIFYHOST, 0);
curl_setopt($process, CURLOPT_SSL_VERIFYPEER, 0);
curl_setopt($process, CURLOPT_POSTFIELDS, http_build_query($data));

$return = curl_exec($process);
curl_close($process);

$bill = json_decode($return, true);

// Redirect to Billplz payment page
echo "<pre>" . print_r($bill, true) . "</pre>";
header("Location: {$bill['url']}");
?>