#!/bin/bash

# Deploy Script for LPSE Biro PBJ Portal
# Pemerintah Provinsi Kalimantan Barat

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration
CONTAINER_NAME="lpse-biro-pbj"
IMAGE_NAME="lpse-web"
PORT=3000
GIT_BRANCH="master"  # atau "main" sesuai branch default Anda

# Functions
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Git is installed
check_git() {
    if ! command -v git &> /dev/null; then
        print_error "Git tidak terinstall. Silakan install Git terlebih dahulu."
        exit 1
    fi
    print_success "Git terdeteksi"
}

# Check if directory is a Git repository
check_git_repo() {
    if [ ! -d ".git" ]; then
        print_error "Directory ini bukan Git repository!"
        print_info "Silakan clone repository terlebih dahulu dengan: git clone <repository-url>"
        exit 1
    fi
    print_success "Git repository terdeteksi"
}

# Backup current changes if any
backup_changes() {
    if ! git diff-index --quiet HEAD -- 2>/dev/null; then
        print_warning "Terdeteksi perubahan lokal yang belum di-commit!"
        print_info "Membuat backup perubahan lokal..."

        TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
        STASH_NAME="auto-backup-$TIMESTAMP"

        git stash push -u -m "$STASH_NAME"
        print_success "Perubahan lokal di-backup dengan nama: $STASH_NAME"
        print_info "Untuk restore backup: git stash apply stash^{/$STASH_NAME}"
    else
        print_success "Tidak ada perubahan lokal"
    fi
}

# Pull latest changes from GitHub
pull_updates() {
    print_info "Memeriksa pembaruan dari GitHub..."

    # Fetch latest changes
    git fetch origin

    # Get current commit hash
    LOCAL_COMMIT=$(git rev-parse HEAD)
    REMOTE_COMMIT=$(git rev-parse origin/$GIT_BRANCH)

    if [ "$LOCAL_COMMIT" = "$REMOTE_COMMIT" ]; then
        print_info "Tidak ada pembaruan. Code sudah up-to-date."
        return 0
    fi

    print_info "Ditemukan pembaruan baru!"
    print_info "Local:  $LOCAL_COMMIT"
    print_info "Remote: $REMOTE_COMMIT"

    # Show what will be updated
    echo ""
    print_info "Perubahan yang akan diaplikasikan:"
    git log --oneline HEAD..origin/$GIT_BRANCH
    echo ""

    # Pull changes
    print_info "Mengunduh pembaruan dari GitHub..."
    git pull origin $GIT_BRANCH

    print_success "Pembaruan berhasil diunduh!"
}

# Remove old Docker images
cleanup_images() {
    print_info "Membersihkan Docker images lama..."

    # Remove dangling images
    DANGLING=$(docker images -f "dangling=true" -q)
    if [ -n "$DANGLING" ]; then
        docker rmi $DANGLING 2>/dev/null || true
        print_success "Docker images lama berhasil dihapus"
    else
        print_info "Tidak ada Docker images lama yang perlu dihapus"
    fi
}

# Check if Docker is installed
check_docker() {
    if ! command -v docker &> /dev/null; then
        print_error "Docker tidak terinstall. Silakan install Docker terlebih dahulu."
        exit 1
    fi

    if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
        print_error "Docker Compose tidak terinstall. Silakan install Docker Compose terlebih dahulu."
        exit 1
    fi

    print_success "Docker dan Docker Compose terdeteksi"
}

# Check if logo file exists
check_logo() {
    if [ ! -f "public/logo-kalbar.png" ]; then
        print_warning "Logo Kalimantan Barat (public/logo-kalbar.png) tidak ditemukan!"
        print_warning "Aplikasi akan tetap berjalan, tapi logo tidak akan tampil."
        print_warning "Silakan tambahkan file logo-kalbar.png ke folder public/"
        read -p "Lanjutkan deployment? (y/n) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_info "Deployment dibatalkan"
            exit 0
        fi
    else
        print_success "Logo ditemukan"
    fi
}

# Stop and remove existing containers
cleanup() {
    print_info "Membersihkan container lama..."

    if docker ps -a | grep -q $CONTAINER_NAME; then
        docker stop $CONTAINER_NAME 2>/dev/null || true
        docker rm $CONTAINER_NAME 2>/dev/null || true
        print_success "Container lama berhasil dihapus"
    else
        print_info "Tidak ada container lama yang perlu dihapus"
    fi
}

# Build Docker image
build_image() {
    print_info "Membangun Docker image..."

    if docker compose version &> /dev/null; then
        docker compose build
    else
        docker-compose build
    fi

    print_success "Docker image berhasil dibangun"
}

# Start containers
start_containers() {
    print_info "Menjalankan container..."

    if docker compose version &> /dev/null; then
        docker compose up -d
    else
        docker-compose up -d
    fi

    print_success "Container berhasil dijalankan"
}

# Check container status
check_status() {
    print_info "Memeriksa status container..."

    sleep 3

    if docker ps | grep -q $CONTAINER_NAME; then
        print_success "Container berjalan dengan baik!"
        print_info "Aplikasi dapat diakses di: http://localhost:$PORT"
        print_info ""
        print_info "Untuk melihat logs: docker logs $CONTAINER_NAME"
        print_info "Untuk stop: docker stop $CONTAINER_NAME"
        print_info "Untuk restart: docker restart $CONTAINER_NAME"
    else
        print_error "Container gagal berjalan. Periksa logs dengan: docker logs $CONTAINER_NAME"
        exit 1
    fi
}

# Show deployment info
show_info() {
    echo ""
    echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                  DEPLOYMENT BERHASIL!                      ║${NC}"
    echo -e "${GREEN}╠════════════════════════════════════════════════════════════╣${NC}"
    echo -e "${GREEN}║${NC} Portal Layanan Digital Biro PBJ                          ${GREEN}║${NC}"
    echo -e "${GREEN}║${NC} Pemerintah Provinsi Kalimantan Barat                     ${GREEN}║${NC}"
    echo -e "${GREEN}╠════════════════════════════════════════════════════════════╣${NC}"
    echo -e "${GREEN}║${NC} URL          : http://localhost:$PORT                     ${GREEN}║${NC}"
    echo -e "${GREEN}║${NC} Container    : $CONTAINER_NAME                                ${GREEN}║${NC}"
    echo -e "${GREEN}║${NC} Status       : Running                                    ${GREEN}║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# Update process (pull from GitHub and redeploy)
update() {
    echo ""
    echo -e "${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║              UPDATE SCRIPT - LPSE BIRO PBJ                 ║${NC}"
    echo -e "${CYAN}║         Pemerintah Provinsi Kalimantan Barat               ║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""

    check_git
    check_git_repo
    backup_changes
    pull_updates
    check_docker
    check_logo
    cleanup
    cleanup_images
    build_image
    start_containers
    check_status

    echo ""
    echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                  UPDATE BERHASIL!                          ║${NC}"
    echo -e "${GREEN}╠════════════════════════════════════════════════════════════╣${NC}"
    echo -e "${GREEN}║${NC} Portal Layanan Digital Biro PBJ                          ${GREEN}║${NC}"
    echo -e "${GREEN}║${NC} Pemerintah Provinsi Kalimantan Barat                     ${GREEN}║${NC}"
    echo -e "${GREEN}╠════════════════════════════════════════════════════════════╣${NC}"
    echo -e "${GREEN}║${NC} URL          : http://localhost:$PORT                     ${GREEN}║${NC}"
    echo -e "${GREEN}║${NC} Container    : $CONTAINER_NAME                                ${GREEN}║${NC}"
    echo -e "${GREEN}║${NC} Status       : Running (Updated)                         ${GREEN}║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# Main deployment process
deploy() {
    echo ""
    echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║              DEPLOYMENT SCRIPT - LPSE BIRO PBJ             ║${NC}"
    echo -e "${BLUE}║         Pemerintah Provinsi Kalimantan Barat               ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""

    check_docker
    check_logo
    cleanup
    build_image
    start_containers
    check_status
    show_info
}

# Stop container
stop_container() {
    echo ""
    echo -e "${YELLOW}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${YELLOW}║              STOP CONTAINER - LPSE BIRO PBJ                ║${NC}"
    echo -e "${YELLOW}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""

    if docker ps | grep -q $CONTAINER_NAME; then
        print_info "Menghentikan container $CONTAINER_NAME..."
        docker stop $CONTAINER_NAME
        print_success "Container berhasil dihentikan!"
    else
        if docker ps -a | grep -q $CONTAINER_NAME; then
            print_warning "Container $CONTAINER_NAME sudah dalam keadaan berhenti"
        else
            print_warning "Container $CONTAINER_NAME tidak ditemukan"
        fi
    fi
    echo ""
}

# Start container
start_container() {
    echo ""
    echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║              START CONTAINER - LPSE BIRO PBJ               ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""

    if docker ps | grep -q $CONTAINER_NAME; then
        print_warning "Container $CONTAINER_NAME sudah berjalan"
        print_info "Aplikasi dapat diakses di: http://localhost:$PORT"
    elif docker ps -a | grep -q $CONTAINER_NAME; then
        print_info "Memulai container $CONTAINER_NAME..."
        docker start $CONTAINER_NAME
        sleep 2
        if docker ps | grep -q $CONTAINER_NAME; then
            print_success "Container berhasil dimulai!"
            print_info "Aplikasi dapat diakses di: http://localhost:$PORT"
        else
            print_error "Gagal memulai container. Cek logs: docker logs $CONTAINER_NAME"
        fi
    else
        print_error "Container $CONTAINER_NAME tidak ditemukan"
        print_info "Jalankan 'bash deploy.sh deploy' untuk membuat container baru"
    fi
    echo ""
}

# Restart container
restart_container() {
    echo ""
    echo -e "${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║             RESTART CONTAINER - LPSE BIRO PBJ              ║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""

    if docker ps -a | grep -q $CONTAINER_NAME; then
        print_info "Me-restart container $CONTAINER_NAME..."
        docker restart $CONTAINER_NAME
        sleep 2
        if docker ps | grep -q $CONTAINER_NAME; then
            print_success "Container berhasil di-restart!"
            print_info "Aplikasi dapat diakses di: http://localhost:$PORT"
        else
            print_error "Gagal restart container. Cek logs: docker logs $CONTAINER_NAME"
        fi
    else
        print_error "Container $CONTAINER_NAME tidak ditemukan"
        print_info "Jalankan 'bash deploy.sh deploy' untuk membuat container baru"
    fi
    echo ""
}

# Remove container and images
remove_all() {
    echo ""
    echo -e "${RED}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${RED}║           REMOVE CONTAINER - LPSE BIRO PBJ                 ║${NC}"
    echo -e "${RED}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""

    print_warning "PERINGATAN: Ini akan menghapus container dan images!"
    read -p "Apakah Anda yakin ingin melanjutkan? (y/n) " -n 1 -r
    echo ""

    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_info "Pembatalan dihentikan"
        exit 0
    fi

    # Stop and remove container
    if docker ps -a | grep -q $CONTAINER_NAME; then
        print_info "Menghentikan dan menghapus container..."
        docker stop $CONTAINER_NAME 2>/dev/null || true
        docker rm $CONTAINER_NAME 2>/dev/null || true
        print_success "Container berhasil dihapus"
    else
        print_info "Container tidak ditemukan"
    fi

    # Remove images
    if docker compose version &> /dev/null; then
        print_info "Menghapus Docker images..."
        docker compose down --rmi all 2>/dev/null || true
    else
        print_info "Menghapus Docker images..."
        docker-compose down --rmi all 2>/dev/null || true
    fi

    # Clean up dangling images
    cleanup_images

    print_success "Semua container dan images berhasil dihapus!"
    echo ""
}

# Show container status
show_status() {
    echo ""
    echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║            CONTAINER STATUS - LPSE BIRO PBJ                ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""

    if docker ps | grep -q $CONTAINER_NAME; then
        print_success "Container Status: RUNNING ✓"
        echo ""
        print_info "Container Details:"
        docker ps --filter "name=$CONTAINER_NAME" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
        echo ""
        print_info "Aplikasi dapat diakses di: http://localhost:$PORT"
        echo ""
        print_info "Useful commands:"
        echo "  - Logs:    docker logs $CONTAINER_NAME"
        echo "  - Follow:  docker logs -f $CONTAINER_NAME"
        echo "  - Stop:    bash deploy.sh stop"
        echo "  - Restart: bash deploy.sh restart"
    elif docker ps -a | grep -q $CONTAINER_NAME; then
        print_warning "Container Status: STOPPED"
        echo ""
        print_info "Container Details:"
        docker ps -a --filter "name=$CONTAINER_NAME" --format "table {{.Names}}\t{{.Status}}"
        echo ""
        print_info "Untuk menjalankan: bash deploy.sh start"
    else
        print_error "Container Status: NOT FOUND"
        echo ""
        print_info "Container belum dibuat"
        print_info "Untuk deploy: bash deploy.sh deploy"
    fi
    echo ""
}

# Show logs
show_logs() {
    echo ""
    echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║            CONTAINER LOGS - LPSE BIRO PBJ                  ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""

    if docker ps -a | grep -q $CONTAINER_NAME; then
        print_info "Menampilkan logs container $CONTAINER_NAME..."
        print_info "Tekan Ctrl+C untuk keluar"
        echo ""
        docker logs -f --tail 100 $CONTAINER_NAME
    else
        print_error "Container $CONTAINER_NAME tidak ditemukan"
        print_info "Jalankan 'bash deploy.sh deploy' untuk membuat container baru"
    fi
}

# Show help/usage
show_help() {
    echo ""
    echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║         LPSE BIRO PBJ - Deployment Script Help             ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo "Usage: bash deploy.sh [COMMAND]"
    echo ""
    echo "Commands:"
    echo "  deploy         Deploy aplikasi (default)"
    echo "  update         Pull pembaruan dari GitHub dan redeploy"
    echo "  start          Mulai container yang sudah ada"
    echo "  stop           Hentikan container yang sedang berjalan"
    echo "  restart        Restart container"
    echo "  status         Tampilkan status container"
    echo "  logs           Tampilkan logs container (real-time)"
    echo "  remove         Hapus container dan images"
    echo "  help           Tampilkan bantuan ini"
    echo ""
    echo "Examples:"
    echo "  bash deploy.sh                # Deploy aplikasi"
    echo "  bash deploy.sh deploy         # Deploy aplikasi"
    echo "  bash deploy.sh update         # Update dari GitHub"
    echo "  bash deploy.sh start          # Mulai container"
    echo "  bash deploy.sh stop           # Hentikan container"
    echo "  bash deploy.sh restart        # Restart container"
    echo "  bash deploy.sh status         # Cek status container"
    echo "  bash deploy.sh logs           # Lihat logs container"
    echo "  bash deploy.sh remove         # Hapus container dan images"
    echo ""
}

# Main entry point
case "${1:-deploy}" in
    deploy)
        deploy
        ;;
    update)
        update
        ;;
    start)
        start_container
        ;;
    stop)
        stop_container
        ;;
    restart)
        restart_container
        ;;
    status)
        show_status
        ;;
    logs)
        show_logs
        ;;
    remove)
        remove_all
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        print_error "Command tidak dikenal: $1"
        show_help
        exit 1
        ;;
esac
