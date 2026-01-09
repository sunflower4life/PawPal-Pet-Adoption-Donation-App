<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

$email = $_GET['email'] ?? '';
$phone = $_GET['phone'] ?? '';
$name = $_GET['name'] ?? '';
$amount = $_GET['amount'] ?? '';
$user_id = $_GET['user_id'] ?? '';
$pet_id = $_GET['pet_id'] ?? '';
$pet_name = $_GET['pet_name'] ?? '';

// Log the request
error_log("Donation Payment - email: $email, amount: $amount, user_id: $user_id");

// Validate required fields
if (empty($email) || empty($amount) || empty($user_id)) {
    echo "<h2>Error: Missing required fields</h2>";
    echo "Email: " . ($email ?: "MISSING") . "<br>";
    echo "Amount: " . ($amount ?: "MISSING") . "<br>";
    echo "User ID: " . ($user_id ?: "MISSING") . "<br>";
    exit;
}

// Billplz API credentials
$api_key = '10522a74-03f1-4fcf-b8f4-57236cb6aab2';
$collection_id = 'j2cv81ts';
$host = 'https://www.billplz-sandbox.com/api/v3/bills';

// Prepare donation data for Billplz
$data = array(
    'collection_id' => $collection_id,
    'email' => $email,
    'mobile' => $phone,
    'name' => $name,
    'amount' => intval($amount * 100),  // Convert to cents
    'description' => 'Donation for ' . $pet_name,
    'callback_url' => "https://socstudentmusicforlife.com/nad/pawpal/api/donation_callback.php",
    'redirect_url' => "https://socstudentmusicforlife.com/nad/pawpal/api/donation_update.php?user_id=$user_id&email=$email&name=$name&phone=$phone&amount=$amount&pet_id=$pet_id&pet_name=$pet_name"
);

error_log("Billplz Data: " . json_encode($data));

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
$curl_error = curl_error($process);
curl_close($process);

error_log("Billplz Response: " . $return);
error_log("Curl Error: " . $curl_error);

$bill = json_decode($return, true);

// Redirect to Billplz payment page
if (isset($bill['url']) && !empty($bill['url'])) {
    error_log("Bill created, redirecting to: " . $bill['url']);
    header("Location: " . $bill['url']);
    exit;
} else {
    echo "<h2>Error creating payment bill</h2>";
    echo "<p>Response from Billplz:</p>";
    echo "<pre>" . json_encode($bill, JSON_PRETTY_PRINT) . "</pre>";
    
    if (!empty($curl_error)) {
        echo "<p><strong>cURL Error:</strong> $curl_error</p>";
    }
    
    error_log("Bill creation failed: " . $return);
    exit;
}
?>