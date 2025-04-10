# Docker Setup Script for Ubuntu

This script automates the installation of Docker and Docker Compose on an Ubuntu system. It also sets up a user with Docker permissions and configures SSH for GitHub access.

## Usage

To use this script, you need to provide your GitHub email and the password for the `dockeruser` account as parameters.

### Prerequisites

- Ubuntu operating system
- Administrative privileges (sudo access)

### Installation

1. Clone the repository or download the script.
2. Make the script executable:
   ```bash
   chmod +x setup-docker-ubuntu.sh
   ```

3. Run the script with your GitHub email and desired password for `dockeruser`:
   ```bash
   sudo ./setup-docker-ubuntu.sh your_github_email@example.com your_dockeruser_password
   ```

### Features

- Installs Docker and Docker Compose
- Creates a new user `dockeruser` with specified password
- Adds `dockeruser` to the Docker group
- Generates an SSH key for GitHub and displays the public key for easy addition to your GitHub account

### Notes

- After running the script, remember to add the displayed SSH public key to your GitHub account under [SSH and GPG keys](https://github.com/settings/keys).
- Verify Docker installation by running `docker --version` and `docker-compose --version`.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
