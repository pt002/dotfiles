# dotfiles

macOS setup and configuration scripts for a new machine.

## Usage

1. **Bootstrap**: Install essential tools and applications

   ```bash
   ./bootstrap.sh
   ```

2. **Finalization**: Set up personal configurations and dotfiles

   ```bash
   ./finalize.sh
   ```

3. **macOS Configuration**: Configure system settings and preferences

   ```bash
   ./macos.sh
   ```

## Scripts

- `bootstrap.sh` - Installs Homebrew, essential command-line tools, applications, and Oh My Zsh
- `finalize.sh` - Sets up SSH keys, dotfiles symlinks, and personal configurations
- `macos.sh` - Configures macOS system preferences and settings

## Configuration

- `configs/apps.cfg` - List of applications to install via Homebrew
- `configs/` - Various configuration files (Terminal themes, SSH config, etc.)
- `homedir/` - Dotfiles to be symlinked to home directory
- `libs/` - Helper functions for logging and installation

## Notes

- Scripts are designed to be idempotent (safe to run multiple times)
- **Prerequisites for a newly provisioned macOS**: Either Xcode Command Line Tools (`xcode-select --install`) or full Xcode must be installed before you can use git to clone this repository
- If installing full Xcode from the App Store, accept the license agreement before running bootstrap script
- Logs are saved to `~/logs/` for troubleshooting
