function init-idf
    # Local development paths - customize these for your setup
    set -gx IDF_PATH /Users/ven/Workspace/ESP/esp-idf
    set -gx ESP_MATTER_PATH /Users/ven/Workspace/ESP/esp-matter
    set -gx _PW_ACTUAL_ENVIRONMENT_ROOT $ESP_MATTER_PATH/connectedhomeip/connectedhomeip/.environment

    # Pigweed tools for Matter builds (must be in PATH before export.fish)
    set -gx PATH $_PW_ACTUAL_ENVIRONMENT_ROOT/cipd/packages/pigweed $_PW_ACTUAL_ENVIRONMENT_ROOT/cipd/packages/pigweed/bin $PATH

    # ESP-IDF export.fish expects 'python' command
    alias python=python3
    source $IDF_PATH/export.fish
end
