import os

# API Configuration
BASE_URL = "https://reqres.in/api"
API_KEY = "reqres-free-v1"
SESSION_ALIAS = "reqres_api"

HEADERS = {
    "accept": "application/json",
    "Content-Type": "application/json",
    "x-api-key": API_KEY
}

CURRENT_DIR = os.path.dirname(os.path.abspath(__file__))
PROJECT_ROOT = os.path.dirname(CURRENT_DIR)

BANCO_USUARIOS = os.path.join(PROJECT_ROOT, "data", "banco_usuarios.json")
BANCO_ENDPOINTS = os.path.join(PROJECT_ROOT, "data", "banco_endpoints.json")
BANCO_STATUS_CODES = os.path.join(PROJECT_ROOT, "data", "banco_status_codes.json")