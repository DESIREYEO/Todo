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
    $passwordInput = $_POST['password'];

    // Recherche de l'utilisateur dans la base de données
    $stmt = $conn->prepare("SELECT * FROM users WHERE email = :email");
    $stmt->bindParam(':email', $email);
    $stmt->execute();
    $user = $stmt->fetch(PDO::FETCH_ASSOC);

    // Vérification du mot de passe si l'utilisateur existe
    if ($user && password_verify($passwordInput, $user['password'])) {
        // Authentification réussie
        error_log(print_r($user, true));
        echo json_encode(['message' => 'Connexion réussie', 'user' => $user]);
    } else {
        // Authentification échouée
        echo json_encode(['message' => 'Identifiants invalides']);
    }
} else {
    // Données du formulaire manquantes
    echo json_encode(['message' => 'Données du formulaire manquantes']);
}
?>
