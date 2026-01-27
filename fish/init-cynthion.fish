function init-cynthion
    # Activate Cynthion development environment
    # Activates Python virtual environment with LUNA, Cynthion CLI, Facedancer, and OSS CAD Suite
    # LUNA will auto-detect your connected Cynthion device via Apollo debugger

    set -l CYNTHION_DIR ~/Workspace/cynthion-toolchain

    if not test -d $CYNTHION_DIR
        echo "Error: Cynthion toolchain directory not found at $CYNTHION_DIR"
        return 1
    end

    # Activate Python virtual environment
    if test -f $CYNTHION_DIR/luna-venv/bin/activate.fish
        source $CYNTHION_DIR/luna-venv/bin/activate.fish
        echo "✓ Activated Python virtual environment"
    else
        echo "Error: luna-venv not found"
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
