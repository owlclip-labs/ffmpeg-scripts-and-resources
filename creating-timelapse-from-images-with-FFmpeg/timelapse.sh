#!/bin/bash

# Timelapse Creation Script
# This script offers different options for creating timelapses from images

# Display help menu
show_help() {
    echo "Timelapse Creation Script"
    echo "------------------------"
    echo "Usage: $0 [option]"
    echo ""
    echo "Options:"
    echo "  1: Create basic timelapse from all JPG files"
    echo "  2: Create timelapse with resizing to 1080p (requires images 01.jpg, 02.jpg..)"
    echo "  3: Create timelapse with watermark"
    echo "  h: Show this help message"
    echo ""
}

# Check if FFmpeg is installed
check_ffmpeg() {
    if ! command -v ffmpeg &> /dev/null; then
        echo "Error: FFmpeg is not installed. Please install FFmpeg first."
        exit 1
    fi
}

# Create basic timelapse
create_basic_timelapse() {
    echo "Creating basic timelapse from all JPG files..."
    ffmpeg -framerate 1/5 -pattern_type glob -i "*.jpg" -c:v libx264 -r 24 -pix_fmt yuv420p output.mp4
    echo "Done! Output saved as output.mp4"
}

# Create timelapse with resizing
create_resizing_timelapse() {
    echo "Creating timelapse with resizing to 1080p..."
    ffmpeg -framerate 1/3 -pattern_type glob -i "*.jpg" -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:(ow-iw)/2:(oh-ih)/2" -c:v libx264 -r 18 -preset slow -pix_fmt yuv420p hq_timelapse.mp4
    echo "Done! Output saved as hq_timelapse.mp4"
}

# Create timelapse with watermark
create_watermarked_timelapse() {
    echo "Creating timelapse with watermark (requires images 01.jpg, 02.jpg)..."
    ffmpeg -framerate 1/5 -start_number 1 -i "%02d.jpg" -vf "drawtext=font=Arial:text='Watermark':fontcolor=white:box=1:boxcolor=black:fontsize=48:x=10:y=10" -c:v libx264 -r 24 -pix_fmt yuv420p watermarked.mp4
    echo "Done! Output saved as watermarked.mp4"
}

# Main script logic
main() {
    check_ffmpeg
    
    # Show help if no arguments provided
    if [ $# -eq 0 ]; then
        show_help
        exit 0
    fi
    
    # Process arguments
    case "$1" in
        1)
            create_basic_timelapse
            ;;
        2)
            create_resizing_timelapse
            ;;
        3)
            create_watermarked_timelapse
            ;;
        h|help|-h|--help)
            show_help
            ;;
        *)
            echo "Invalid option. Use '$0 h' for help."
            exit 1
            ;;
    esac
}

# Run the script
main "$@"