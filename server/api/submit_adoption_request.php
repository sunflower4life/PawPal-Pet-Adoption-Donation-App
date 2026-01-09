<?php
header("Access-Control-Allow-Origin: *");
include 'dbconnect.php';

if ($_SERVER['REQUEST_METHOD'] != 'POST') {
    http_response_code(405);
    echo json_encode(array('status' => 'failed', 'message' => 'Method Not Allowed'));
    exit();
}

// Receive POST values
$userid = $_POST['user_id'];
$petid = $_POST['pet_id'];
$motivation_message = addslashes($_POST['motivation_message']);

// Validation: Check if all fields are present
if (empty($userid) || empty($petid) || empty($motivation_message)) {
    $response = array('status' => false, 'message' => 'Missing required fields');
    sendJsonResponse($response);
    exit();
}

// Validation: Check motivation message length
if (strlen($motivation_message) < 10) {
    $response = array('status' => false, 'message' => 'Motivation message must be at least 10 characters');
    sendJsonResponse($response);
    exit();
}

// Check if user already requested this pet
$checkDuplicate = "SELECT adoption_id FROM tbl_adoptions WHERE user_id = '$userid' AND pet_id = '$petid'";
$resultDuplicate = $conn->query($checkDuplicate);
if ($resultDuplicate->num_rows > 0) {
    $response = array('status' => false, 'message' => 'You have already submitted an adoption request for this pet');
    sendJsonResponse($response);
    exit();
}

// Insert adoption request
$sqlinsert = "INSERT INTO `tbl_adoptions`(`user_id`, `pet_id`, `motivation_message`) 
VALUES ('$userid','$petid','$motivation_message')";

try {
    if ($conn->query($sqlinsert) === TRUE) {
        $adoption_id = $conn->insert_id;
        $response = array('status' => true, 'message' => 'Adoption request submitted successfully', 'adoption_id' => $adoption_id);
        sendJsonResponse($response);
    } else {
        $response = array('status' => false, 'message' => 'Adoption request failed');
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