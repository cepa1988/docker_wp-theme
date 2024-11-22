<?php
// Register theme support for various WordPress features
function customTheme() {
    // Add support for post thumbnails
    add_theme_support('post-thumbnails');
    // Register menus
    register_nav_menus(array(
        'primary' => __('Primary Menu', 'customTheme'),
    ));
}

add_action('after_setup_theme', 'customTheme');

// Enqueue styles and scripts
function customTheme_enqueue_assets() {
    // Enqueue the main stylesheet
    wp_enqueue_style('customTheme-style', get_template_directory_uri() . '/dist/style.css');
    // Enqueue additional scripts if needed
}

add_action('wp_enqueue_scripts', 'customTheme_enqueue_assets');
?>
