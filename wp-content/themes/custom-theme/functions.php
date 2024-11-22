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
function custom_theme_enqueue_scripts() {
    wp_enqueue_style('custom-theme-style', get_template_directory_uri() . '/dist/style.css', [], '1.0.0');
    wp_enqueue_script('custom-theme-script', get_template_directory_uri() . '/dist/style.js', [], '1.0.0', true);
}
add_action('wp_enqueue_scripts', 'custom_theme_enqueue_scripts');

