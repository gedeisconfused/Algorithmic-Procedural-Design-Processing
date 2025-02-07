ArrayList<Particle> particles; // ArrayList to store particles
color currentColor; // Variable to store the current color

void setup() {
  size(1200, 900); // Set the canvas size
  background(190); // Set the background color to stone grey
  particles = new ArrayList<Particle>(); // Initialize ArrayList to store particles
  currentColor = color(40, 60, 90); // Initialize the current color to blue
}

void draw() {
  for (int i = particles.size() - 1; i >= 0; i--) {
    Particle p = particles.get(i);
    p.update(particles);
    p.show(currentColor); // Pass the current color to the show function
    if (p.alpha <= 2) {
      particles.remove(i); // Remove particles that have faded away
    }
  }
}

void mousePressed() {
  particles.add(new Particle(mouseX, mouseY, 5, 75)); // Spawn a new particle at the mouse position
  changeColor(); // Change the color when the mouse is pressed
}

// Function to change the color slightly
void changeColor() {
  // Adjust the color by a small random amount
  float r = red(currentColor) + random(-10, 10);
  float g = green(currentColor) + random(-10, 10);
  float b = blue(currentColor) + random(-10, 10);
  
  // Ensure the color values stay within the 0-255 range
  r = constrain(r, 0, 255);
  g = constrain(g, 0, 255);
  b = constrain(b, 0, 255);
  
  // Update the current color
  currentColor = color(r, g, b);
}

// Particle class
class Particle {
  PVector location;
  PVector velocity;
  PVector acceleration;
  // These variables track the position, speed, and changes in speed (acceleration) of each particle.
  float alpha;
  float palpha;
  // 'alpha' represents the current transparency level of the particle, while 'palpha' stores the initial transparency value for reference during recursive creation of new particles.
  float amp;
  // Defines the size of the particle.
  float rate;
  // Governs the speed at which the particle fades away over time.

// Initializing the particle's attributes when a new particle object is created.
  Particle(float x, float y, float r, float a) {
    location = new PVector(x, y);
    velocity = new PVector(random(-1, 1), random(-1, 1));
    acceleration = new PVector();
    alpha = palpha = a;
    amp = 6; // Size of the particle
    rate = r;
  }

  // Update particle velocity and location
  void update(ArrayList<Particle> p) {
    acceleration.add(new PVector((noise(location.x) * 2 - 1), (noise(location.y) * 2 - 1)));
    velocity.add(acceleration);
    acceleration.set(0, 0);
    location.add(velocity);
    alpha -= rate;
    // Updates the particle's attributes such as position, velocity, and transparency over time.
    // Utilizes Perlin noise to introduce randomness to the particle's movement.
    // Decreases the particle's transparency (alpha) based on the rate.
   
    // Recursion condition
    // The recursion condition creates new particles when a current particle's transparency falls below a certain threshold (palpha * 0.25) and the initial transparency is above a minimum value (palpha > 10).
    // When a particle's transparency diminishes and meets the conditions, a new particle is generated at the same position but with modified attributes: a slower fade rate (rate * 0.25) and a reduced initial transparency (palpha * 0.5).
    if (alpha <= palpha * 0.25 && palpha > 10) {
      p.add(new Particle(location.x, location.y, rate * 0.25, palpha * 0.5));
    // This recursive behavior forms a hierarchy of fading particles, where smaller, slower-fading particles are generated from their fading parent particles. It creates a visually evolving pattern of fading elements, contributing to the overall composition.
    }
  }

  // Display the particle
  void show(color c) {
    noStroke();
    fill(c, alpha); // Use the current color with alpha for particle transparency
    ellipse(location.x, location.y, amp, amp); // Draw particle as an ellipse
    // Renders the particle on the canvas as an ellipse with a specific color and transparency (alpha).
  }
}

// KeyPressed function to detect key presses
void keyPressed() {
  if (keyCode == ENTER) { // Check if the "Enter" key is pressed
    String filename = "particle_image.png"; // Define the file name for the saved image
    saveFrame(filename); // Save the current frame as an image
    println("Image saved as " + filename); // Print a message to the console
  }
}
