<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);
header("Access-Control-Allow-Origin: *");
header('Content-Type: application/json');
include 'dbconnect.php';

if ($_SERVER['REQUEST_METHOD'] == 'GET') {

    $results_per_page = 10;

    if (isset($_GET['curpage'])) {
        $curpage = (int)$_GET['curpage'];
    } else {
        $curpage = 1;
    }

    if (!isset($_GET['user_id'])) {
        $response = array('status' => false, 'message' => 'Missing user_id');
        sendJsonResponse($response);
        exit();
    }

    $userid = $conn->real_escape_string($_GET['user_id']);
    $page_first_result = ($curpage - 1) * $results_per_page;

    // Base query
    $baseQuery = "
        SELECT 
            p.pet_id,
            p.user_id,
            p.pet_name,
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
        WHERE p.user_id = '$userid'
    ";

    // Search filter
    if (isset($_GET['search']) && !empty($_GET['search'])) {
        $search = $conn->real_escape_string($_GET['search']);
        $sqlloadpets = $baseQuery . "
            AND (p.pet_name LIKE '%$search%'
             OR p.description LIKE '%$search%'
             OR p.pet_type LIKE '%$search%'
             OR p.category LIKE '%$search%')
            ORDER BY p.pet_id DESC";
    } else {
        $sqlloadpets = $baseQuery . " ORDER BY p.pet_id DESC";
    }

    // Count number of pages
    $result = $conn->query($sqlloadpets);
    
    if (!$result) {
        $response = array('status' => false, 'message' => 'Query error: ' . $conn->error);
        sendJsonResponse($response);
        exit();
    }
    
    $number_of_result = $result->num_rows;
    $number_of_page = ceil($number_of_result / $results_per_page);

    // Add LIMIT
    $sqlloadpets .= " LIMIT $page_first_result, $results_per_page";
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
            'numofpage' => $number_of_page,
            'numberofresult' => $number_of_result
        );
        sendJsonResponse($response);

    } else {
        $response = array(
            'status' => true,
            'data' => array(),
            'numofpage' => 1,
            'numberofresult' => 0,
            'message' => 'No pets found for this user'
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