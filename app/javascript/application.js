// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"; // Turbo must load first
import "controllers"; // Stimulus controllers
import "flowbite"; // External library

// Custom modules
import "custom/constants"; // Constants should load early if reused
import "custom/dark-mode"; // Handles dark mode logic
import "custom/sidebar"; // Sidebar logic
import "custom/flash"; // Sidebar logic