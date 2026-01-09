<?php
header("Access-Control-Allow-Origin: *");
include 'dbconnect.php';

if ($_SERVER['REQUEST_METHOD'] != 'GET') {
    http_response_code(405);
    echo json_encode(array('status' => false, 'message' => 'Method Not Allowed'));
    exit();
}

// Check if user_id is provided
if (!isset($_GET['user_id'])) {
    $response = array('status' => false, 'message' => 'Missing user_id');
    sendJsonResponse($response);
    exit();
}

$userid = $conn->real_escape_string($_GET['user_id']);

// Query to fetch user's donations with pet info
// Remove donation_date if it doesn't exist in your table
$sqlquery = "
    SELECT 
        d.donation_id,
        d.user_id,
        d.pet_id,
        d.donation_type,
        d.amount,
        d.description,
        d.payment_status,
        d.receipt_id,
        p.pet_name
    FROM tbl_donations d
    JOIN tbl_pets p ON d.pet_id = p.pet_id
    WHERE d.user_id = '$userid'
    ORDER BY d.donation_id DESC
";

$result = $conn->query($sqlquery);

if (!$result) {
    $response = array('status' => false, 'message' => 'Query error: ' . $conn->error);
    sendJsonResponse($response);
    exit();
}

if ($result->num_rows > 0) {
    $donationdata = array();
    while ($row = $result->fetch_assoc()) {
        // Ensure IDs are strings
        $row['donation_id'] = (string)$row['donation_id'];
        $row['user_id'] = (string)$row['user_id'];
        $row['pet_id'] = (string)$row['pet_id'];
        // Use current timestamp as fallback
        $row['created_at'] = date('Y-m-d H:i');
        $donationdata[] = $row;
    }

    $response = array(
        'status' => true,
        'data' => $donationdata,
        'message' => 'Successfully fetched donations'
    );
    sendJsonResponse($response);

} else {
    $response = array(
        'status' => true,
        'data' => array(),
        'message' => 'No donations found for this user'
    );
    sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>