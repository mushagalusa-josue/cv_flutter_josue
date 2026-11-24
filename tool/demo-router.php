<?php
// Route the course API and the Flutter build through the same browser origin.
$path = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
if (str_starts_with($path, '/api-test/public/')) {
    $_SERVER['SCRIPT_NAME'] = '/api-test/public/index.php';
    require getenv('COURSE_API_DIR') . '/public/index.php';
    return true;
}
return false;
