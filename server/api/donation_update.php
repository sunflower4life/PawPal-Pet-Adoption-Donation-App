<?php
include_once("dbconnect.php");

// Get parameters
$email = $_GET['email'];
$phone = $_GET['phone'];
$name = $_GET['name'];
$amount = $_GET['amount'];
$user_id = $_GET['user_id'];
$pet_id = $_GET['pet_id'];
$pet_name = $_GET['pet_name'];

// Get Billplz payment data
$data = array(
    'id' => $_GET['billplz']['id'],
    'paid_at' => $_GET['billplz']['paid_at'],
    'paid' => $_GET['billplz']['paid'],
    'x_signature' => $_GET['billplz']['x_signature']
);

// Determine payment status
$paidstatus = $_GET['billplz']['paid'];
if ($paidstatus == "true") {
    $paidstatus = "Success";
} else {
    $paidstatus = "Failed";
}

$receiptid = $_GET['billplz']['id'];

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

if ($signed === $data['x_signature']) {
    if ($paidstatus == "Success") {
        // Save donation to database
        $sqlsavedonation = "INSERT INTO tbl_donations (user_id, pet_id, donation_type, amount, description, donation_date, payment_status, receipt_id) 
                            VALUES ('$user_id', '$pet_id', 'Money', '$amount', 'Donation for $pet_name', NOW(), 'Success', '$receiptid')";
        
        if ($conn->query($sqlsavedonation) === TRUE) {
            // Success receipt
            showReceipt($name, $email, $phone, $amount, $pet_name, $receiptid, "Success", "green", "✓ Donation Successful", "Thank you for your donation!");
        } else {
            // Database error receipt
            showReceipt($name, $email, $phone, $amount, $pet_name, $receiptid, "Payment Success But DB Error", "orange", "⚠ Payment Received But Error Saving", "Please contact admin with your receipt ID");
        }
    } else {
        // Failed receipt
        showReceipt($name, $email, $phone, $amount, $pet_name, $receiptid, "Failed", "red", "✗ Donation Failed", "Please try again or contact support");
    }
} else {
    echo "<h2>Invalid signature - Transaction not verified</h2>";
}

$conn->close();

// Display receipt HTML
function showReceipt($name, $email, $phone, $amount, $pet_name, $receiptid, $status, $color, $title, $message) {
    echo "
    <html>
    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">
    <link rel=\"stylesheet\" href=\"https://www.w3schools.com/w3css/4/w3.css\">
    <body style=\"font-family: Arial, sans-serif;\">
    <div style=\"max-width: 600px; margin: 40px auto; padding: 20px; border: 2px solid $color; border-radius: 10px; background-color: #fff0f0;\">
        <center><h2 style=\"color: $color;\">$title</h2></center>
        <table class='w3-table w3-striped'>
            <tr><td><b>Receipt ID</b></td><td>$receiptid</td></tr>
            <tr><td><b>Name</b></td><td>$name</td></tr>
            <tr><td><b>Email</b></td><td>$email</td></tr>
            <tr><td><b>Phone</b></td><td>$phone</td></tr>
            <tr><td><b>Pet Name</b></td><td>$pet_name</td></tr>
            <tr><td><b>Amount</b></td><td>RM $amount</td></tr>
            <tr><td><b>Status</b></td><td style=\"color: $color;\"><b>$status</b></td></tr>
        </table>
        <br>
        <center><p>$message</p></center>
    </div>
    </body>
    </html>";
}
?>