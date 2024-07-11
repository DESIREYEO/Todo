<?php
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE');
header('Access-Control-Allow-Headers: Content-Type');
header('Content-Type: application/json');

$host = "localhost";
$dbname = "todo";
$username = "";
$password = "";

try {
    $conn = new PDO("mysql:host=$host;dbname=$dbname", $username, $password);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    echo json_encode(['message' => 'Erreur de connexion à la base de données: ' . $e->getMessage()]);
    exit();
}

$requestBody = file_get_contents('php://input');
$data = json_decode($requestBody, true);

switch ($_SERVER['REQUEST_METHOD']) {
    case 'POST':
        if (isset($data['userId']) && isset($data['title']) && isset($data['description'])) {
            $userId = $data['userId'];
            $title = $data['title'];
            $description = $data['description'];

            try {
                $stmt = $conn->prepare("INSERT INTO tasks (user_id, title, description) VALUES (:userId, :title, :description)");
                $stmt->bindParam(':userId', $userId);
                $stmt->bindParam(':title', $title);
                $stmt->bindParam(':description', $description);
                $stmt->execute();

                $taskId = (int) $conn->lastInsertId();
                echo json_encode(['message' => 'Tâche ajoutée', 'taskId' => $taskId]);
            } catch (PDOException $e) {
                echo json_encode(['message' => 'Erreur lors de l\'ajout de la tâche : ' . $e->getMessage()]);
            }
        } else {
            echo json_encode(['message' => 'Données incomplètes pour l\'ajout de tâche']);
        }
        break;

    case 'PUT':
        if (isset($data['taskId'])) {
            $taskId = $data['taskId'];
            $title = isset($data['title']) ? $data['title'] : null;
            $description = isset($data['description']) ? $data['description'] : null;
            $completed = isset($data['completed']) ? (int)$data['completed'] : null;

            try {
                if ($title !== null || $description !== null || $completed !== null) {
                    $stmt = $conn->prepare("UPDATE tasks SET
                        title = COALESCE(:title, title),
                        description = COALESCE(:description, description),
                        completed = COALESCE(:completed, completed)
                        WHERE id = :taskId");

                    $stmt->bindParam(':title', $title);
                    $stmt->bindParam(':description', $description);
                    $stmt->bindParam(':completed', $completed);
                    $stmt->bindParam(':taskId', $taskId);
                    $stmt->execute();

                    echo json_encode(['message' => 'Tâche mise à jour']);
                } else {
                    echo json_encode(['message' => 'Aucune donnée fournie pour la mise à jour']);
                }
            } catch (PDOException $e) {
                echo json_encode(['message' => 'Erreur lors de la mise à jour de la tâche : ' . $e->getMessage()]);
            }
        } else {
            echo json_encode(['message' => 'ID de tâche non fourni']);
        }
        break;

    case 'DELETE':
        if (isset($_GET['taskId'])) {
            $taskId = $_GET['taskId'];

            try {
                $stmt = $conn->prepare("DELETE FROM tasks WHERE id = :taskId");
                $stmt->bindParam(':taskId', $taskId);
                $stmt->execute();

                echo json_encode(['message' => 'Tâche supprimée']);
            } catch (PDOException $e) {
                echo json_encode(['message' => 'Erreur lors de la suppression de la tâche : ' . $e->getMessage()]);
            }
        } else {
            echo json_encode(['message' => 'ID de tâche non fourni']);
        }
        break;

    case 'GET':
        if (isset($_GET['userId'])) {
            $userId = $_GET['userId'];

            try {
                $stmt = $conn->prepare("SELECT * FROM tasks WHERE user_id = :userId");
                $stmt->bindParam(':userId', $userId);
                $stmt->execute();
                $tasks = $stmt->fetchAll(PDO::FETCH_ASSOC);

                echo json_encode($tasks);
            } catch (PDOException $e) {
                echo json_encode(['message' => 'Erreur lors de la récupération des tâches : ' . $e->getMessage()]);
            }
        } else {
            echo json_encode(['message' => 'ID utilisateur non fourni']);
        }
        break;
}
?>
