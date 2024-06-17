// Get the canvas element and its 2D context
var canvas = document.getElementById("ballCanvas");
var ctx = canvas.getContext("2d");

// Set initial position and velocity of the ball
var ball = {
    x: canvas.width / 2,
    y: canvas.height,
    radius: canvas.height / 2, // Radius is half the canvas height
    speed: 2,
    direction: -1 // -1 for up, 1 for down
};

// Animation loop function
function animateBall() {
    // Clear the canvas
    ctx.clearRect(0, 0, canvas.width, canvas.height);

    // Update ball position
    ball.y += ball.speed * ball.direction;

    // Reverse direction if ball reaches canvas boundaries
    if (ball.y - ball.radius <= 0 || ball.y + ball.radius >= canvas.height) {
        ball.direction *= -1;
    }

    // Draw the ball
    ctx.beginPath();
    ctx.arc(ball.x, ball.y, ball.radius, 0, Math.PI * 2);
    ctx.fillStyle = "#FF6347";
    ctx.fill();

    // Request next animation frame
    requestAnimationFrame(animateBall);
}

// Resize canvas to fill the screen
function resizeCanvas() {
    canvas.width = window.innerWidth * window.devicePixelRatio;
    canvas.height = window.innerHeight * window.devicePixelRatio;
    ball.radius = canvas.height / 2; // Update ball radius based on new canvas height
}

// Event listener for window resize
window.addEventListener("resize", resizeCanvas);

// Initialize canvas size and start animation
resizeCanvas();
animateBall();
