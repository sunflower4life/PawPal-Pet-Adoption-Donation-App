<?php
header("Access-Control-Allow-Origin: *");
include 'dbconnect.php';

if ($_SERVER['REQUEST_METHOD'] != 'POST') {
    http_response_code(405);
    echo json_encode(array('status' => false, 'message' => 'Method Not Allowed'));
    exit();
}

// Receive POST values
$userid = $_POST['user_id'];
$petid = $_POST['pet_id'];
$donation_type = $_POST['donation_type'];
$amount = isset($_POST['amount']) ? $_POST['amount'] : null;
$description = isset($_POST['description']) ? addslashes($_POST['description']) : null;

// Validation: Check if all required fields are present
if (empty($userid) || empty($petid) || empty($donation_type)) {
    $response = array('status' => false, 'message' => 'Missing required fields');
    sendJsonResponse($response);
    exit();
}

// Validation: Check donation type
if (!in_array($donation_type, ['Food', 'Medical', 'Money'])) {
    $response = array('status' => false, 'message' => 'Invalid donation type');
    sendJsonResponse($response);
    exit();
}

// Validation based on donation type
if ($donation_type == 'Money') {
    if (empty($amount) || !is_numeric($amount) || $amount <= 0) {
        $response = array('status' => false, 'message' => 'Please enter a valid donation amount');
        sendJsonResponse($response);
        exit();
    }
} else {
    if (empty($description) || strlen($description) < 5) {
        $response = array('status' => false, 'message' => 'Description must be at least 5 characters');
        sendJsonResponse($response);
        exit();
    }
}

// Insert donation record
$sqlinsert = "INSERT INTO `tbl_donations`(`user_id`, `pet_id`, `donation_type`, `amount`, `description`) 
VALUES ('$userid','$petid','$donation_type','$amount','$description')";

try {
    if ($conn->query($sqlinsert) === TRUE) {
        $donation_id = $conn->insert_id;
        $response = array('status' => true, 'message' => 'Donation submitted successfully', 'donation_id' => $donation_id);
        sendJsonResponse($response);
    } else {
        $response = array('status' => false, 'message' => 'Donation submission failed');
        sendJsonResponse($response);
    }
} catch(Exception $e) {
    $response = array('status' => false, 'message' => $e->getMessage());
    sendJsonResponse($response);
}

// function to send json response 	
function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>