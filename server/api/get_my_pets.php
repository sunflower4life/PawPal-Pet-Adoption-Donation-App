<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);
header("Access-Control-Allow-Origin: *");
header('Content-Type: application/json');
include 'dbconnect.php';

if ($_SERVER['REQUEST_METHOD'] == 'GET') {

    // Fetch ALL pets from database (not filtered by user)
    // JOIN with users table to get owner information
    $sqlloadpets = "
        SELECT 
            p.pet_id,
            p.user_id,
            p.pet_name,
            p.pet_gender,
            p.pet_age,
            p.pet_health,
            p.pet_type,
            p.category,
            p.description,
            p.image_paths,
            p.lat,
            p.lng,
            p.created_at,
            u.name as user_name,
            u.email as user_email,
            u.phone as user_phone
        FROM tbl_pets p
        JOIN tbl_users u ON p.user_id = u.user_id
        ORDER BY p.pet_id DESC
    ";

    $result = $conn->query($sqlloadpets);

    if (!$result) {
        $response = array('status' => false, 'message' => 'Query error: ' . $conn->error);
        sendJsonResponse($response);
        exit();
    }

    if ($result->num_rows > 0) {
        $petdata = array();
        while ($row = $result->fetch_assoc()) {
            // Ensure IDs are strings
            $row['pet_id'] = (string)$row['pet_id'];
            $row['user_id'] = (string)$row['user_id'];
            $petdata[] = $row;
        }

        $response = array(
            'status' => true,
            'data' => $petdata,
            'message' => 'Successfully fetched all pets'
        );
        sendJsonResponse($response);

    } else {
        $response = array(
            'status' => true,
            'data' => array(),
            'message' => 'No pets available'
        );
        sendJsonResponse($response);
    }

} else {
    $response = array('status' => false, 'message' => 'Invalid request method');
    sendJsonResponse($response);
    exit();
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
    exit();
}
?>