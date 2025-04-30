<?php
header('Content-Type: text/html; charset=utf-8');
?>
<!DOCTYPE html>
<html><head><title>Vanel's Web Application</title></head>
<body>
<h1>Welcome to Vanel's Web Application</h1>
<?php
try {
  $pdo = new PDO(
    "mysql:host=" . getenv('DB_HOST') . ";dbname=" . getenv('DB_NAME'),
    getenv('DB_USER'),
    getenv('DB_PASS'),
    [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]
  );
  echo "<p>Database connected successfully!</p>";
} catch (Exception $e) {
  echo "<p>Connection failed: " . htmlspecialchars($e->getMessage()) . "</p>";
}
?>
</body></html>
