function init-cynthion
    # Activate Cynthion development environment
    # Activates Python virtual environment with LUNA, Cynthion CLI, Facedancer, and OSS CAD Suite
    # LUNA will auto-detect your connected Cynthion device via Apollo debugger

    set -l CYNTHION_DIR $HOME/Workspace/cynthion-toolchain
    set -l VENV_DIR $HOME/.venvs/cynthion

    if not test -d $CYNTHION_DIR
        echo "Error: Cynthion toolchain directory not found at $CYNTHION_DIR"
        return 1
    end

    # Activate Python virtual environment
    if test -f $VENV_DIR/bin/activate.fish
        source $VENV_DIR/bin/activate.fish
        echo "✓ Activated Python virtual environment"
    else
        echo "Error: Python virtual environment not found at $VENV_DIR"
        return 1
    end

    # Source OSS CAD Suite environment
    if test -f $CYNTHION_DIR/oss-cad-suite/environment.fish
        source $CYNTHION_DIR/oss-cad-suite/environment.fish
        echo "✓ Loaded OSS CAD Suite environment (Yosys, NextPNR)"
    else
        echo "Error: oss-cad-suite environment.fish not found"
        return 1
    end

    echo ""
    echo "Cynthion environment ready!"
    echo "Available tools: cynthion, facedancer, packetry, amaranth (LUNA gateware)"
    echo ""
    echo "Note: LUNA will auto-detect your connected Cynthion device when building gateware"
end
