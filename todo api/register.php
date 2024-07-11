<?php
// Connexion à la base de données
$host = "localhost";
$dbname = "todo";
$username = "";
$password = "";

$conn = new PDO("mysql:host=$host;dbname=$dbname", $username, $password);

// Vérification que les données du formulaire sont définies
if(isset($_POST['email']) && isset($_POST['password'])) {
    // Récupération des données du formulaire
    $email = $_POST['email'];
    $password = $_POST['password'];

    // Hashage du mot de passe
    $hashedPassword = password_hash($password, PASSWORD_DEFAULT);

    // Insertion de l'utilisateur dans la base de données
    $stmt = $conn->prepare("INSERT INTO users (email, password) VALUES (:email, :password)");
    $stmt->bindParam(':email', $email);
    $stmt->bindParam(':password', $hashedPassword);
    $stmt->execute();

    // Retourner une réponse JSON
    echo json_encode(['message' => 'Inscription réussie']);
} else {
    // Données du formulaire manquantes
    echo json_encode(['message' => 'Données du formulaire manquantes']);
}
?>
