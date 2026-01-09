<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);
include_once("dbconnect.php");

$email = $_GET['email'] ?? '';
$phone = $_GET['phone'] ?? '';
$name = $_GET['name'] ?? '';
$amount = $_GET['amount'] ?? '';
$user_id = $_GET['user_id'] ?? '';
$pet_id = $_GET['pet_id'] ?? '';
$pet_name = $_GET['pet_name'] ?? '';

error_log("Donation Update - user_id: $user_id, amount: $amount, pet_id: $pet_id");

// Get Billplz payment data
$data = array(
    'id' => $_GET['billplz']['id'] ?? '',
    'paid_at' => $_GET['billplz']['paid_at'] ?? '',
    'paid' => $_GET['billplz']['paid'] ?? '',
    'x_signature' => $_GET['billplz']['x_signature'] ?? ''
);

$paidstatus = $_GET['billplz']['paid'] ?? '';
if ($paidstatus == "true") {
    $paidstatus = "Success";
} else {
    $paidstatus = "Failed";
}

$receiptid = $_GET['billplz']['id'] ?? '';

error_log("Payment Status: $paidstatus, Receipt: $receiptid");

// Verify signature
$signing = '';
foreach ($data as $key => $value) {
    $signing .= 'billplz' . $key . $value;
    if ($key === 'paid') {
        break;
    } else {
        $signing .= '|';
    }
}

$signed = hash_hmac('sha256', $signing, 'xkey');

error_log("Signature verification - Calculated: $signed, Received: " . $data['x_signature']);

if ($signed === $data['x_signature']) {
    if ($paidstatus == "Success") {
        // Payment successful - save donation to database
        $sqlsavedonation = "INSERT INTO tbl_donations (user_id, pet_id, donation_type, amount, description, donation_date, payment_status, receipt_id) 
                            VALUES ('$user_id', '$pet_id', 'Money', '$amount', 'Donation for $pet_name', NOW(), 'Success', '$receiptid')";
        
        error_log("Executing SQL: $sqlsavedonation");
        
        if ($conn->query($sqlsavedonation) === TRUE) {
            // Donation saved successfully
            error_log("Donation saved successfully");
            echo "
            <html>
            <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">
            <link rel=\"stylesheet\" href=\"https://www.w3schools.com/w3css/4/w3.css\">
            <body style=\"font-family: Arial, sans-serif;\">
            <div style=\"max-width: 600px; margin: 40px auto; padding: 20px; border: 2px solid green; border-radius: 10px; background-color: #f0fff0;\">
                <center><h2 style=\"color: green;\">✓ Donation Successful</h2></center>
                <table class='w3-table w3-striped'>
                    <tr><td><b>Receipt ID</b></td><td>$receiptid</td></tr>
                    <tr><td><b>Donor Name</b></td><td>$name</td></tr>
                    <tr><td><b>Email</b></td><td>$email</td></tr>
                    <tr><td><b>Phone</b></td><td>$phone</td></tr>
                    <tr><td><b>Pet Name</b></td><td>$pet_name</td></tr>
                    <tr><td><b>Donation Amount</b></td><td>RM $amount</td></tr>
                    <tr><td><b>Status</b></td><td style=\"color: green;\"><b>$paidstatus</b></td></tr>
                </table>
                <br>
                <center><p>Thank you for your donation!</p></center>
            </div>
            </body>
            </html>";
        } else {
            error_log("Database error: " . $conn->error);
            echo "
            <html>
            <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">
            <link rel=\"stylesheet\" href=\"https://www.w3schools.com/w3css/4/w3.css\">
            <body style=\"font-family: Arial, sans-serif;\">
            <div style=\"max-width: 600px; margin: 40px auto; padding: 20px; border: 2px solid orange; border-radius: 10px; background-color: #fff8f0;\">
                <center><h2 style=\"color: orange;\">⚠ Payment Received But Error Saving</h2></center>
                <p><strong>Database Error:</strong> " . $conn->error . "</p>
                <table class='w3-table w3-striped'>
                    <tr><td><b>Receipt ID</b></td><td>$receiptid</td></tr>
                    <tr><td><b>Name</b></td><td>$name</td></tr>
                    <tr><td><b>Amount</b></td><td>RM $amount</td></tr>
                    <tr><td><b>Status</b></td><td style=\"color: orange;\"><b>Payment Success But DB Error</b></td></tr>
                </table>
                <br>
                <center><p>Please contact admin with your receipt ID</p></center>
            </div>
            </body>
            </html>";
        }
    } else {
        // Payment failed
        error_log("Payment failed");
        echo "
        <html>
        <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">
        <link rel=\"stylesheet\" href=\"https://www.w3schools.com/w3css/4/w3.css\">
        <body style=\"font-family: Arial, sans-serif;\">
        <div style=\"max-width: 600px; margin: 40px auto; padding: 20px; border: 2px solid red; border-radius: 10px; background-color: #fff0f0;\">
            <center><h2 style=\"color: red;\">✗ Donation Failed</h2></center>
            <table class='w3-table w3-striped'>
                <tr><td><b>Receipt ID</b></td><td>$receiptid</td></tr>
                <tr><td><b>Name</b></td><td>$name</td></tr>
                <tr><td><b>Amount</b></td><td>RM $amount</td></tr>
                <tr><td><b>Status</b></td><td style=\"color: red;\"><b>$paidstatus</b></td></tr>
            </table>
            <br>
            <center><p>Please try again or contact support</p></center>
        </div>
        </body>
        </html>";
    }
} else {
    error_log("Signature verification failed");
    echo "<h2>Invalid signature - Transaction not verified</h2>";
    echo "<p>Calculated: $signed</p>";
    echo "<p>Received: " . $data['x_signature'] . "</p>";
}

$conn->close();
?>